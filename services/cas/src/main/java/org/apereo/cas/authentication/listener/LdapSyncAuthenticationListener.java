package org.apereo.cas.authentication.listener;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import javax.naming.NameNotFoundException;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.apereo.cas.authentication.Credential;
import org.apereo.cas.authentication.HandlerResult;
import org.apereo.cas.authentication.PreventedException;
import org.apereo.cas.authentication.UsernamePasswordCredential;
import org.apereo.cas.authentication.principal.Principal;
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

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * LDAP Synchronization Authentication Listener.
 * 
 * This listener uses the authentication credentials and the authenticated principal
 * to synchronize attributes with an LDAP directory.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Slf4j
@Getter
@Setter
public class LdapSyncAuthenticationListener implements AuthenticationListener {

	private static final Random random;

	private @NotNull ConnectionFactory connectionFactory;
	private @NotNull String dnTemplate;

	private Map<String, List<String>> defaultAttributes;
	private Map<String, String> mapAttributes;
	private Map<String, List<String>> overrideAttributes;

	private List<String> groupDNs;
	private String groupMemberAttr = "member";
	private boolean groupMemberIsDN = true;
	private boolean allowPasswordSync = false;

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
		log.debug("Syncing LDAP user for user DN [{}]", userDN);

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
			log.info("User DN [{}] not found, will be created", userDN);
			entry = new LdapEntry(userDN);
		}

		// Map attributes and merge the user
		mapAttributes(credential, principal, entry);
		log.debug("Saving user DN [{}] to LDAP directory", userDN);
		MergeOperation merge = new MergeOperation(conn);
		merge.execute(new MergeRequest(entry));
		log.info("User DN [{}] was successfully synchronized", userDN);
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
			log.debug("Syncing LDAP groups for user DN [{}]", userDN);
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
					log.warn("Group DN [{}] does not exist in LDAP directory", groupDN);
				} else {
					// Update attribute and merge the group
					entry.getAttribute(groupMemberAttr).addStringValue(groupMemberIsDN ? userDN : principal.getId().toLowerCase(Locale.ROOT));
					log.debug("Saving group DN [{}] to LDAP directory", groupDN);
					MergeOperation merge = new MergeOperation(conn);
					merge.execute(new MergeRequest(entry));
					log.info("User DN [{}] was successfully added to group DN [{}]", userDN, groupDN);
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
		log.debug("Mapping LDAP attributes from principal [{}]", principal.getId());

		// Set default attributes
		if (defaultAttributes != null) {
			for (Map.Entry<String, List<String>> defaultAttribute : defaultAttributes.entrySet()) {
				// Ensure the attribute is not already set
				if (entry.getAttribute(defaultAttribute.getKey()) == null) {
					Object value = interpolateAttributeValue(defaultAttribute.getValue(), credential);
					if (value != null) {
						log.debug("Adding default LDAP attribute [{}] with value {}", defaultAttribute.getKey(), defaultAttribute.getValue());
						entry.addAttribute(createAttribute(defaultAttribute.getKey(), value));
					}
				}
			}
		}

		// Map principal attributes
		if (mapAttributes != null) {
			for (Map.Entry<String, Object> principalAttribute : principal.getAttributes().entrySet()) {
				String mappedAttribute = mapAttributes.get(principalAttribute.getKey());
				if (StringUtils.isNotBlank(mappedAttribute)) {
					log.debug("Mapping principal attribute [{}] to LDAP attribute [{}] with value [{}]", principalAttribute.getKey(), mappedAttribute, principalAttribute.getValue());
					entry.addAttribute(createAttribute(mappedAttribute, principalAttribute.getValue()));
				}
			}
		}

		// Override attributes
		if (overrideAttributes != null) {
			for (Map.Entry<String, List<String>> overrideAttribute : overrideAttributes.entrySet()) {
				Object value = interpolateAttributeValue(overrideAttribute.getValue(), credential);
				if (value != null) {
					log.debug("Overriding LDAP attribute [{}] with value {}", overrideAttribute.getKey(), overrideAttribute.getValue());
					entry.addAttribute(createAttribute(overrideAttribute.getKey(), value));
				}
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
	@SuppressWarnings("unchecked")
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
				String password = "";
				if (allowPasswordSync) {
					byte[] salt = new byte[4]; // 32 bits salt
					random.nextBytes(salt);
					password = encodePassword(upCredentials.getPassword(), salt);
				}
				sValue = sValue.replaceAll("%p", password);
			}

			// Remove empty strings
			if (StringUtils.isBlank(sValue)) {
				value = null;
			} else {
				value = sValue;
			}

		} else if (value instanceof Collection) {
			Collection<Object> in = (Collection<Object>) value;
			Collection<Object> out = new ArrayList<>(in.size());

			// Interpolate each item
			for (Object obj : in) {
				Object v = interpolateAttributeValue(obj, credential);
				if (v != null) {
					out.add(v);
				}
			}

			// Remove empty lists
			if (out.size() == 0) {
				value = null;
			} else {
				value = out;
			}
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
	 * @param groupDNs the groupDNs to set
	 */
	public void setGroupDNs(List<String> groupDNs) {
		if (groupDNs != null && groupDNs.size() == 1) {
			setGroupDNs(groupDNs.get(0));
		} else {
			this.groupDNs = groupDNs;
		}
	}

	/**
	 * @param groupDNs the groupDNs to set
	 */
	public void setGroupDNs(String groupDNs) {
		this.groupDNs = Arrays.asList(StringUtils.split(groupDNs, "; "));
	}

}
