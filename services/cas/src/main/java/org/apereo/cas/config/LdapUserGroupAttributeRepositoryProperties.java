package org.apereo.cas.config;

import java.util.HashMap;
import java.util.Map;

import org.apereo.cas.configuration.model.support.ldap.AbstractLdapProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.Getter;
import lombok.Setter;

/**
 * LDAP user/group attribute repository properties.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Getter
@Setter
@ConfigurationProperties("cas.authn.attribute-repository.ldap-user-group")
public class LdapUserGroupAttributeRepositoryProperties extends AbstractLdapProperties {

	private static final long serialVersionUID = 3327198642705685503L;

	/**
	 * Whether subtree searching should be perform recursively.
	 */
	private boolean subtreeSearch = true;

	/**
	 * Initial base DN to start the search for users.
	 */
	private String userDn;

	/**
	 * Filter to query for user accounts.
	 * Format must match {@code attributeName={0}}.
	 */
	private String userFilter;

	/**
	 * Map of user attributes to fetch from the source.
	 * Attributes are defined using a key-value structure
	 * where CAS allows the attribute name/key to be renamed virtually
	 * to a different attribute. The key is the attribute fetched
	 * from the data source and the value is the attribute name CAS should
	 * use for virtual renames.
	 */
	private Map<String, String> userAttributes = new HashMap<>();

	/**
	 * Initial base DN to start the search for groups.
	 */
	private String groupDn;

	/**
	 * Filter to query for user groups.
	 * Format must match {@code attributeName={0}}.
	 */
	private String groupFilter;

	/**
	 * Map of group attributes to fetch from the source.
	 * Attributes are defined using a key-value structure
	 * where CAS allows the attribute name/key to be renamed virtually
	 * to a different attribute. The key is the attribute fetched
	 * from the data source and the value is the attribute name CAS should
	 * use for virtual renames.
	 */
	private Map<String, String> groupAttributes = new HashMap<>();

	/**
	 * Mapping between user attributes and group attributes to establish memberhsip.
	 * The key is the user attribute, the value is the group attribute.
	 */
	private Map<String, String> groupMemberMapping = new HashMap<>();

	/**
	 * The order of this attribute repository in the chain of repositories.
	 * Can be used to explicitly position this source in chain and affects
	 * merging strategies.
	 */
	private int order;

}
