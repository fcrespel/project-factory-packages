package org.apereo.cas.config;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.apereo.cas.configuration.model.support.ldap.AbstractLdapProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.Getter;
import lombok.Setter;

/**
 * LDAP synchronization principal resolver listener properties.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Getter
@Setter
@ConfigurationProperties("cas.authn.listeners.ldap-sync")
public class LdapSyncPrincipalResolverListenerProperties extends AbstractLdapProperties {

	private static final long serialVersionUID = -2923069353756572307L;

	private boolean enabled = false;
	private String dnTemplate;
	private String groupDn;
	private String groupMemberAttr = "member";
	private boolean groupMemberIsDn = true;
	private boolean allowPasswordSync = false;
	private Map<String, List<String>> defaultAttributes;
	private Map<String, String> mapAttributes;
	private Map<String, List<String>> overrideAttributes;
	private Pattern excludedHandlersPattern;

}
