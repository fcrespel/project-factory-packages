package org.jasig.cas.authentication.listener;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.authentication.principal.Credentials;
import org.jasig.cas.authentication.principal.Principal;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ldap.NameNotFoundException;
import org.springframework.ldap.core.DirContextAdapter;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.ldap.core.LdapEncoder;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.security.authentication.encoding.LdapShaPasswordEncoder;
import org.springframework.security.authentication.encoding.PasswordEncoder;

/**
 * LDAP Synchronization Authentication Listener.
 * 
 * This listener uses the authentication credentials and the authenticated principal
 * coming from a remote CAS server to synchronize attributes with an LDAP directory.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public class LdapSyncAuthenticationListener implements AuthenticationListener {
	
	private static final Logger log = LoggerFactory.getLogger(LdapSyncAuthenticationListener.class);
	private static final Random random;
	
	@NotNull
	private LdapTemplate ldapTemplate;
	
	@NotNull
	private String dnTemplate;
	
	private PasswordEncoder passwordEncoder = new LdapShaPasswordEncoder();

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

	/*
	 * (non-Javadoc)
	 * @see org.jasig.cas.authentication.listener.AuthenticationListener#postAuthenticate(org.jasig.cas.authentication.principal.Credentials, org.jasig.cas.authentication.principal.Principal)
	 */
	public boolean postAuthenticate(final Credentials credentials, final Principal principal) {
		if (principal == null)
			return false;
		
		// Build the user DN
		String userDN = dnTemplate.replaceAll("%u", LdapEncoder.nameEncode(principal.getId().toLowerCase(Locale.ROOT)));
		
		try {
			// Find and update the existing user
			DirContextOperations context = ldapTemplate.lookupContext(userDN);
			mapAttributes(credentials, principal, context);
			ldapTemplate.modifyAttributes(context);
			log.info("User DN '" + userDN + "' was successfully updated");
		} catch (NameNotFoundException e) {
			// Create a new user
			DirContextOperations context = new DirContextAdapter(userDN);
			mapAttributes(credentials, principal, context);
			ldapTemplate.bind(context);
			log.info("User DN '" + userDN + "' was successfully created");
		}
		
		// Add the user to groups
		if (groupDNs != null) {
			for (String groupDN : groupDNs) {
				try {
					// Find and update the existing group
					DirContextOperations context = ldapTemplate.lookupContext(groupDN);
					context.addAttributeValue(groupMemberAttr, groupMemberIsDN ? userDN : principal.getId().toLowerCase(Locale.ROOT));
					ldapTemplate.modifyAttributes(context);
					log.info("User DN '" + userDN + "' was successfully added to group DN '" + groupDN + "'");
				} catch (NameNotFoundException e) {
					log.warn("Group DN '" + groupDN + "' does not exist in LDAP directory");
				}
			}
		}
		
		return true;
	}
	
	/**
	 * Map default, principal and override attributes to an LDAP DirContext.
	 * @param credentials authentication credentials
	 * @param principal authenticated principal
	 * @param context LDAP DirContext
	 */
	protected void mapAttributes(Credentials credentials, Principal principal, DirContextOperations context) {
		// Set default attributes
		if (defaultAttributes != null) {
			for (Map.Entry<String, Object> entry : defaultAttributes.entrySet()) {
				// Ensure the attribute is not already set
				if (context.getAttributes().get(entry.getKey()) == null) {
					// Get and interpolate value
					Object value = interpolateAttributeValue(entry.getValue(), credentials);
					
					// Set attribute value(s)
					if (value.getClass().isArray()) {
						context.setAttributeValues(entry.getKey(), (Object[])value);
					} else {
						context.setAttributeValue(entry.getKey(), value);
					}
				}
			}
		}
		
		// Map principal attributes
		if (mapAttributes != null) {
			for (Map.Entry<String, Object> entry : principal.getAttributes().entrySet()) {
				String attribute = mapAttributes.get(entry.getKey());
				if (attribute != null) {
					context.setAttributeValue(attribute, entry.getValue());
				}
			}
		}
		
		// Override attributes
		if (overrideAttributes != null) {
			for (Map.Entry<String, Object> entry : overrideAttributes.entrySet()) {
				// Get and interpolate value
				Object value = interpolateAttributeValue(entry.getValue(), credentials);
				
				// Set attribute value(s)
				if (value.getClass().isArray()) {
					context.setAttributeValues(entry.getKey(), (Object[])value);
				} else {
					context.setAttributeValue(entry.getKey(), value);
				}
			}
		}
	}
	
	/**
	 * Interpolate placeholders in an attribute's value.
	 * @param value value to interpolate
	 * @param credentials authentication credentials
	 * @return interpolated value, or the original value if no placeholder was found
	 */
	protected Object interpolateAttributeValue(Object value, Credentials credentials) {
		if (value instanceof String && credentials instanceof UsernamePasswordCredentials) {
			String sValue = (String) value;
			UsernamePasswordCredentials upCredentials = (UsernamePasswordCredentials) credentials;
			
			// Replace %u placeholder with username
			if (sValue.contains("%u")) {
				sValue = sValue.replaceAll("%u", upCredentials.getUsername().toLowerCase(Locale.ROOT));
			}
			
			// Replace %p placeholder with hashed and salted password
			if (sValue.contains("%p")) {
				byte[] salt = new byte[4]; // 32 bits salt
				random.nextBytes(salt);
				String password = passwordEncoder.encodePassword(upCredentials.getPassword(), salt);
				sValue = sValue.replaceAll("%p", password);
			}
			
			value = sValue;
		}
		return value;
	}

	/**
	 * @return the ldapTemplate
	 */
	public LdapTemplate getLdapTemplate() {
		return ldapTemplate;
	}

	/**
	 * @param ldapTemplate the ldapTemplate to set
	 */
	public void setLdapTemplate(LdapTemplate ldapTemplate) {
		this.ldapTemplate = ldapTemplate;
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
	 * @return the passwordEncoder
	 */
	public PasswordEncoder getPasswordEncoder() {
		return passwordEncoder;
	}

	/**
	 * @param passwordEncoder the passwordEncoder to set
	 */
	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
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
