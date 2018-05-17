package org.apereo.cas.config;

import org.apereo.cas.authentication.listener.LdapSyncAuthenticationListener;
import org.apereo.cas.util.LdapUtils;
import org.ldaptive.ConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import lombok.extern.slf4j.Slf4j;

/**
 * LDAP synchronization authentication listener configuration.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Slf4j
@Configuration("ldapSyncAuthenticationListenerConfiguration")
@ConditionalOnProperty("cas.authn.listeners.ldap-sync.enabled")
@EnableConfigurationProperties(LdapSyncAuthenticationListenerProperties.class)
public class LdapSyncAuthenticationListenerConfiguration {

	@Autowired
	private LdapSyncAuthenticationListenerProperties listenerProperties;

	@Bean
	public LdapSyncAuthenticationListener ldapSyncAuthenticationListener() {
		log.debug("Configuring LDAP sync for [{}]", listenerProperties.getLdapUrl());
		final ConnectionFactory cf = LdapUtils.newLdaptivePooledConnectionFactory(listenerProperties);
		final LdapSyncAuthenticationListener listener = new LdapSyncAuthenticationListener();
		listener.setConnectionFactory(cf);
		listener.setDnTemplate(listenerProperties.getDnTemplate());
		listener.setGroupDNs(listenerProperties.getGroupDn());
		listener.setGroupMemberAttr(listenerProperties.getGroupMemberAttr());
		listener.setGroupMemberIsDN(listenerProperties.isGroupMemberIsDn());
		listener.setAllowPasswordSync(listenerProperties.isAllowPasswordSync());
		listener.setDefaultAttributes(listenerProperties.getDefaultAttributes());
		listener.setMapAttributes(listenerProperties.getMapAttributes());
		listener.setOverrideAttributes(listenerProperties.getOverrideAttributes());
		return listener;
	}

}
