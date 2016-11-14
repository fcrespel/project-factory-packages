package org.jasig.cas.authentication.listener;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import javax.naming.NameNotFoundException;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.authentication.Credential;
import org.jasig.cas.authentication.HandlerResult;
import org.jasig.cas.authentication.PreventedException;
import org.jasig.cas.authentication.UsernamePasswordCredential;
import org.jasig.cas.authentication.principal.Principal;
import org.ldaptive.Connection;
import org.ldaptive.ConnectionFactory;
import org.ldaptive.LdapAttribute;
import org.ldaptive.LdapEntry;
import org.ldaptive.LdapException;
import org.ldaptive.LdapUtils;
import org.ldaptive.Response;
import org.ldaptive.SearchOperation;
import org.ldaptive.SearchRequest;
import org.ldaptive.SearchResult;
import org.ldaptive.SortBehavior;
import org.ldaptive.ext.MergeOperation;
import org.ldaptive.ext.MergeRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * LDAP Synchronization Authentication Listener.
 * 
 * This listener uses the authentication credentials and the authenticated principal
 * to synchronize attributes with an LDAP directory.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public class LdapSyncAuthenticationListener implements AuthenticationListener {
	
	private static final Logger log = LoggerFactory.getLogger(LdapSyncAuthenticationListener.class);
	private static final Random random;
	
	private @NotNull ConnectionFactory connectionFactory;
	private @NotNull String dnTemplate;

	private Map<String, Object> defaultAttributes;
	private Map<String, String> mapAttributes;
	private Map<String, Object> overrideAttributes;
	
	private List<String> groupDNs;
	private String groupMemberAttr = "member";
	private boolean groupMemberIsDN = true;
	
	static {
		Random randomLocal = null;
		try {
			randomLocal = SecureRandom.getInstance("SHA1PRNG");
		} catch (NoSuchAlgorithmException e) {
			randomLocal = new Random();
		}
		random = randomLocal;
	}
	
	@Override
	public HandlerResult postAuthenticate(Credential credential, HandlerResult result) throws GeneralSecurityException, PreventedException {
		Principal principal = result.getPrincipal();
		if (principal == null)
			return result;
		
		Connection conn;
		try {
			conn = connectionFactory.getConnection();
			try {
				// Build the user DN
				String userDN = dnTemplate.replaceAll("%u", LdapAttribute.escapeValue(principal.getId().toLowerCase(Locale.ROOT)));
				
				// Sync LDAP user and groups
				syncUser(conn, userDN, principal, credential);
				syncGroups(conn, userDN, principal);
				
			} finally {
				conn.close();
			}
		} catch (LdapException e) {
			log.error("LDAP sync failed", e);
			throw new PreventedException("LDAP sync failed: " + e.getMessage(), e);
		}
		
		return result;
	}
	
	/**
	 * Synchronize LDAP user with authenticated principal.
	 * @param conn LDAP connection
	 * @param userDN user distinguished name
	 * @param principal authenticated principal
	 * @param credential authentication credentials
	 * @throws LdapException
	 */
	protected void syncUser(Connection conn, String userDN, Principal principal, Credential credential) throws LdapException {
		log.debug("Syncing LDAP user for user DN '" + userDN + "'");
		
		// Search the user
		SearchOperation search = new SearchOperation(conn);
		LdapEntry entry = null;
		try {
			Response<SearchResult> response = search.execute(SearchRequest.newObjectScopeSearchRequest(userDN));
			entry = response.getResult().getEntry();
		} catch (LdapException e) {
			if (e.getCause() instanceof NameNotFoundException) {
				// Ignore
			} else {
				throw e;
			}
		}
		if (entry == null) {
			log.info("User DN '" + userDN + "' not found, will be created");
			entry = new LdapEntry(userDN);
		}
		
		// Map attributes and merge the user
		mapAttributes(credential, principal, entry);
		MergeOperation merge = new MergeOperation(conn);
		merge.execute(new MergeRequest(entry));
		log.info("User DN '" + userDN + "' was successfully synchronized");
	}
	
	/**
	 * Synchronize LDAP groups with authenticated principal.
	 * @param conn LDAP connection
	 * @param userDN user distinguished name
	 * @param principal authenticated principal
	 * @throws LdapException
	 */
	protected void syncGroups(Connection conn, String userDN, Principal principal) throws LdapException {
		if (groupDNs != null) {
			log.debug("Syncing LDAP groups for user DN '" + userDN + "'");
			for (String groupDN : groupDNs) {
				// Search the group
				SearchOperation search = new SearchOperation(conn);
				LdapEntry entry = null;
				try {
					Response<SearchResult> response = search.execute(SearchRequest.newObjectScopeSearchRequest(groupDN));
					entry = response.getResult().getEntry();
				} catch (LdapException e) {
					if (e.getCause() instanceof NameNotFoundException) {
						// Ignore
					} else {
						throw e;
					}
				}
				if (entry == null) {
					log.warn("Group DN '" + groupDN + "' does not exist in LDAP directory");
				} else {
					// Update attribute and merge the group
					entry.getAttribute(groupMemberAttr).addStringValue(groupMemberIsDN ? userDN : principal.getId().toLowerCase(Locale.ROOT));
					MergeOperation merge = new MergeOperation(conn);
					merge.execute(new MergeRequest(entry));
					log.info("User DN '" + userDN + "' was successfully added to group DN '" + groupDN + "'");
				}
			}
		}
	}
	
	/**
	 * Map default, principal and override attributes to an LDAP entry.
	 * @param credential authentication credentials
	 * @param principal authenticated principal
	 * @param entry LDAP entry
	 */
	protected void mapAttributes(Credential credential, Principal principal, LdapEntry entry) {
		// Set default attributes
		if (defaultAttributes != null) {
			for (Map.Entry<String, Object> defaultAttribute : defaultAttributes.entrySet()) {
				// Ensure the attribute is not already set
				if (entry.getAttribute(defaultAttribute.getKey()) == null) {
					Object value = interpolateAttributeValue(defaultAttribute.getValue(), credential);
					entry.addAttribute(createAttribute(defaultAttribute.getKey(), value));
				}
			}
		}
		
		// Map principal attributes
		if (mapAttributes != null) {
			for (Map.Entry<String, Object> principalAttribute : principal.getAttributes().entrySet()) {
				String mappedAttribute = mapAttributes.get(principalAttribute.getKey());
				if (mappedAttribute != null) {
					entry.addAttribute(createAttribute(mappedAttribute, principalAttribute.getValue()));
				}
			}
		}
		
		// Override attributes
		if (overrideAttributes != null) {
			for (Map.Entry<String, Object> overrideAttribute : overrideAttributes.entrySet()) {
				Object value = interpolateAttributeValue(overrideAttribute.getValue(), credential);
				entry.addAttribute(createAttribute(overrideAttribute.getKey(), value));
			}
		}
	}
	
	/**
	 * Create an attribute with a name and value(s).
	 * @param name attribute name
	 * @param value attribute value(s)
	 * @return corresponding LDAP attribute
	 */
	@SuppressWarnings("unchecked")
	protected LdapAttribute createAttribute(String name, Object value) {
		if (value == null) {
			return new LdapAttribute(name);
		} else {
			Collection<Object> values;
			if (value.getClass().isArray()) {
				values = Arrays.asList((Object[]) value);
			} else if (value instanceof Collection) {
				values = (Collection<Object>) value;
			} else {
				values = Arrays.asList(value);
			}
			return LdapAttribute.createLdapAttribute(SortBehavior.getDefaultSortBehavior(), name, values);
		}
	}
	
	/**
	 * Interpolate placeholders in an attribute's value.
	 * @param value value to interpolate
	 * @param credential authentication credential
	 * @return interpolated value, or the original value if no placeholder was found
	 */
	protected Object interpolateAttributeValue(Object value, Credential credential) {
		if (value instanceof String && credential instanceof UsernamePasswordCredential) {
			String sValue = (String) value;
			UsernamePasswordCredential upCredentials = (UsernamePasswordCredential) credential;
			
			// Replace %u placeholder with username
			if (sValue.contains("%u")) {
				sValue = sValue.replaceAll("%u", upCredentials.getUsername().toLowerCase(Locale.ROOT));
			}
			
			// Replace %p placeholder with hashed and salted password
			if (sValue.contains("%p")) {
				byte[] salt = new byte[4]; // 32 bits salt
				random.nextBytes(salt);
				String password = encodePassword(upCredentials.getPassword(), salt);
				sValue = sValue.replaceAll("%p", password);
			}
			
			value = sValue;
		}
		return value;
	}
	
	/**
	 * Encode a password using the SSHA algorithm.
	 * @param password password to encode
	 * @param salt 32-bit salt
	 * @return encoded password prefixed with {SSHA}
	 */
	protected String encodePassword(String password, byte[] salt) {
		MessageDigest sha;
		try {
			sha = MessageDigest.getInstance("SHA");
		} catch (NoSuchAlgorithmException e) {
			throw new IllegalStateException("No SHA implementation available", e);
		}
		
		// Compute hash of password+salt
		sha.update(LdapUtils.utf8Encode(password));
		sha.update(salt);
		byte[] hash = sha.digest();
		
		// Concat hash and salt
		byte[] hashAndSalt = new byte[hash.length + salt.length];
		System.arraycopy(hash, 0, hashAndSalt, 0, hash.length);
		System.arraycopy(salt, 0, hashAndSalt, hash.length, salt.length);

		return "{SSHA}" + LdapUtils.base64Encode(hashAndSalt);
	}

	/**
	 * @return the connectionFactory
	 */
	public ConnectionFactory getConnectionFactory() {
		return connectionFactory;
	}

	/**
	 * @param connectionFactory the connectionFactory to set
	 */
	public void setConnectionFactory(ConnectionFactory connectionFactory) {
		this.connectionFactory = connectionFactory;
	}

	/**
	 * @return the dnTemplate
	 */
	public String getDnTemplate() {
		return dnTemplate;
	}

	/**
	 * @param dnTemplate the dnTemplate to set
	 */
	public void setDnTemplate(String dnTemplate) {
		this.dnTemplate = dnTemplate;
	}

	/**
	 * @return the defaultAttributes
	 */
	public Map<String, Object> getDefaultAttributes() {
		return defaultAttributes;
	}

	/**
	 * @param defaultAttributes the defaultAttributes to set
	 */
	public void setDefaultAttributes(Map<String, Object> defaultAttributes) {
		this.defaultAttributes = defaultAttributes;
	}

	/**
	 * @return the mapAttributes
	 */
	public Map<String, String> getMapAttributes() {
		return mapAttributes;
	}

	/**
	 * @param mapAttributes the mapAttributes to set
	 */
	public void setMapAttributes(Map<String, String> mapAttributes) {
		this.mapAttributes = mapAttributes;
	}

	/**
	 * @return the overrideAttributes
	 */
	public Map<String, Object> getOverrideAttributes() {
		return overrideAttributes;
	}

	/**
	 * @param overrideAttributes the overrideAttributes to set
	 */
	public void setOverrideAttributes(Map<String, Object> overrideAttributes) {
		this.overrideAttributes = overrideAttributes;
	}

	/**
	 * @return the groupDNs
	 */
	public List<String> getGroupDNs() {
		return groupDNs;
	}

	/**
	 * @param groupDNs the groupDNs to set
	 */
	public void setGroupDNs(List<String> groupDNs) {
		if (groupDNs != null && groupDNs.size() == 1) {
			groupDNs = Arrays.asList(StringUtils.split(groupDNs.get(0), "; "));
		}
		this.groupDNs = groupDNs;
	}

	/**
	 * @param groupDNs the groupDNs to set
	 */
	public void setGroupDNs(String groupDNs) {
		this.groupDNs = Arrays.asList(StringUtils.split(groupDNs, "; "));
	}

	/**
	 * @return the groupMemberAttr
	 */
	public String getGroupMemberAttr() {
		return groupMemberAttr;
	}

	/**
	 * @param groupMemberAttr the groupMemberAttr to set
	 */
	public void setGroupMemberAttr(String groupMemberAttr) {
		this.groupMemberAttr = groupMemberAttr;
	}

	/**
	 * @return the groupMemberIsDN
	 */
	public boolean getGroupMemberIsDN() {
		return groupMemberIsDN;
	}

	/**
	 * @param groupMemberIsDN the groupMemberIsDN to set
	 */
	public void setGroupMemberIsDN(boolean groupMemberIsDN) {
		this.groupMemberIsDN = groupMemberIsDN;
	}

}
