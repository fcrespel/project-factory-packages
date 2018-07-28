package org.apereo.cas.config;

import java.util.List;

import org.apereo.cas.authentication.principal.PrincipalFactory;
import org.apereo.cas.authentication.principal.PrincipalResolver;
import org.apereo.cas.authentication.principal.resolvers.DelegatingPrePostPrincipalResolver;
import org.apereo.cas.authentication.principal.resolvers.PersonDirectoryPrincipalResolver;
import org.apereo.cas.authentication.principal.resolvers.listener.PrincipalResolverListener;
import org.apereo.cas.configuration.CasConfigurationProperties;
import org.apereo.services.persondir.IPersonAttributeDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Person Directory principal resolver configuration, that does not fall back
 * to principal attributes in any case and invokes pre/post-resolve listeners.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Configuration("personDirectoryPrincipalResolverConfiguration")
@EnableConfigurationProperties(CasConfigurationProperties.class)
public class PrincipalResolverConfiguration {

	@Autowired
	private CasConfigurationProperties casProperties;

	@Autowired
	@Qualifier("attributeRepository")
	private IPersonAttributeDao attributeRepository;

	@Autowired(required = false)
	private List<PrincipalResolverListener> principalResolverListeners;

	@Autowired
	@RefreshScope
	@Bean
	public PrincipalResolver personDirectoryPrincipalResolver(@Qualifier("principalFactory") final PrincipalFactory principalFactory) {
		return new DelegatingPrePostPrincipalResolver(new PersonDirectoryPrincipalResolver(
				attributeRepository, 
				principalFactory,
				casProperties.getPersonDirectory().isReturnNull(),
				casProperties.getPersonDirectory().getPrincipalAttribute()
		), principalResolverListeners);
	}

}
