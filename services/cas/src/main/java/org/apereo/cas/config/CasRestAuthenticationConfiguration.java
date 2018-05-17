package org.apereo.cas.config;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apereo.cas.authentication.AuthenticationEventExecutionPlanConfigurer;
import org.apereo.cas.authentication.AuthenticationHandler;
import org.apereo.cas.authentication.ExtAuthenticationHandler;
import org.apereo.cas.authentication.listener.AuthenticationListener;
import org.apereo.cas.authentication.principal.DefaultPrincipalFactory;
import org.apereo.cas.authentication.principal.PrincipalFactory;
import org.apereo.cas.authentication.principal.PrincipalResolver;
import org.apereo.cas.configuration.CasConfigurationProperties;
import org.apereo.cas.integration.pac4j.authentication.handler.support.UsernamePasswordWrapperAuthenticationHandler;
import org.apereo.cas.services.ServicesManager;
import org.pac4j.cas.client.rest.AbstractCasRestClient;
import org.pac4j.cas.client.rest.CasRestBasicAuthClient;
import org.pac4j.cas.config.CasConfiguration;
import org.pac4j.cas.credentials.authenticator.CasRestAuthenticator;
import org.pac4j.cas.profile.creator.CasRestProfileCreator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import lombok.extern.slf4j.Slf4j;

/**
 * CAS REST authentication handler configuration.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Slf4j
@ConditionalOnProperty("cas.authn.cas-rest.enabled")
@Configuration("casRestAuthenticationConfiguration")
@EnableConfigurationProperties({ CasConfigurationProperties.class, CasRestAuthenticationProperties.class })
public class CasRestAuthenticationConfiguration {

	@Autowired
	private CasConfigurationProperties casProperties;

	@Autowired
	private CasRestAuthenticationProperties casRestAuthProperties;

	@Autowired
	@Qualifier("personDirectoryPrincipalResolver")
	private PrincipalResolver personDirectoryPrincipalResolver;

	@Autowired
	@Qualifier("servicesManager")
	private ServicesManager servicesManager;

	@Autowired
	private List<AuthenticationListener> authenticationListeners;

	@Bean
	public PrincipalFactory casRestPrincipalFactory() {
		return new DefaultPrincipalFactory();
	}

	@Bean
	public CasConfiguration casConfiguration() {
		final CasConfiguration config = new CasConfiguration(null, casRestAuthProperties.getServerUrl());
		config.setRestUrl(casRestAuthProperties.getTicketUrl());
		config.setProtocol(casRestAuthProperties.getProtocol());
		config.setTimeTolerance(casRestAuthProperties.getTimeTolerance());
		return config;
	}

	@Bean
	public AbstractCasRestClient casRestClient() {
		final CasRestBasicAuthClient client = new CasRestBasicAuthClient();
		client.setConfiguration(casConfiguration());
		return client;
	}

	@Bean
	public CasRestAuthenticator casRestAuthenticator() {
		return new CasRestAuthenticator(casConfiguration());
	}

	@Bean
	public CasRestProfileCreator casRestProfileCreator() {
		final CasRestProfileCreator profileCreator = new CasRestProfileCreator();
		profileCreator.setCasRestClient(casRestClient());
		if (StringUtils.isNotBlank(casRestAuthProperties.getServiceUrl())) {
			profileCreator.setServiceUrl(casRestAuthProperties.getServiceUrl());
		} else {
			profileCreator.setServiceUrl(casProperties.getServer().getPrefix());
		}
		return profileCreator;
	}

	@Bean
	public AuthenticationHandler casRestAuthenticationHandler() {
		final UsernamePasswordWrapperAuthenticationHandler pac4jHandler = new UsernamePasswordWrapperAuthenticationHandler(casRestAuthProperties.getName(), servicesManager, casRestPrincipalFactory(), casRestAuthProperties.getOrder());
		pac4jHandler.setAuthenticator(casRestAuthenticator());
		pac4jHandler.setProfileCreator(casRestProfileCreator());
		pac4jHandler.setTypedIdUsed(false);

		final ExtAuthenticationHandler extHandler = new ExtAuthenticationHandler(pac4jHandler);
		extHandler.setExcludedUsernamesPattern(casRestAuthProperties.getExcludedUsernamesPattern());
		extHandler.setAuthenticationListeners(authenticationListeners);
		return extHandler;
	}

	@Bean
	public AuthenticationEventExecutionPlanConfigurer casRestAuthenticationEventExecutionPlanConfigurer() {
		return plan -> {
			if (StringUtils.isNotBlank(casRestAuthProperties.getServerUrl())) {
				log.info("Registering CAS REST authentication handler for [{}]", casRestAuthProperties.getServerUrl());
				plan.registerAuthenticationHandlerWithPrincipalResolver(casRestAuthenticationHandler(), personDirectoryPrincipalResolver);
			} else {
				log.warn("No CAS REST server URL is defined. CAS REST authentication support will be disabled.");
			}
		};
	}

}
