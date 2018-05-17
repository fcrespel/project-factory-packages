package org.apereo.cas.config;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.naming.directory.SearchControls;

import org.apache.commons.lang.StringUtils;
import org.apereo.cas.util.LdapUtils;
import org.apereo.services.persondir.IPersonAttributeDao;
import org.apereo.services.persondir.support.CascadingPersonAttributeDao;
import org.apereo.services.persondir.support.ldap.LdaptivePersonAttributeDao;
import org.apereo.services.persondir.support.merger.JoiningAttributeMerger;
import org.ldaptive.ConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.OrderComparator;

import lombok.extern.slf4j.Slf4j;

/**
 * Extended PersonDirectoryConfiguration adding support for JoiningAttributeMerger.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Slf4j
@Configuration("ldapUserGroupAttributeRepositoryConfiguration")
@EnableConfigurationProperties(LdapUserGroupAttributeRepositoryProperties.class)
public class LdapUserGroupAttributeRepositoryConfiguration {

	@Autowired
	private LdapUserGroupAttributeRepositoryProperties attrRepoProperties;

	@Bean
	@RefreshScope
	public List<IPersonAttributeDao> attributeRepositories(
			@Qualifier("ldapAttributeRepositories") List<IPersonAttributeDao> ldapAttributeRepositories,
			@Qualifier("jdbcAttributeRepositories") List<IPersonAttributeDao> jdbcAttributeRepositories,
			@Qualifier("jsonAttributeRepositories") List<IPersonAttributeDao> jsonAttributeRepositories,
			@Qualifier("groovyAttributeRepositories") List<IPersonAttributeDao> groovyAttributeRepositories,
			@Qualifier("grouperAttributeRepositories") List<IPersonAttributeDao> grouperAttributeRepositories,
			@Qualifier("restfulAttributeRepositories") List<IPersonAttributeDao> restfulAttributeRepositories,
			@Qualifier("scriptedAttributeRepositories") List<IPersonAttributeDao> scriptedAttributeRepositories,
			@Qualifier("stubAttributeRepositories") List<IPersonAttributeDao> stubAttributeRepositories) {

		final List<IPersonAttributeDao> list = new ArrayList<>();

		list.addAll(ldapAttributeRepositories);
		list.addAll(jdbcAttributeRepositories);
		list.addAll(jsonAttributeRepositories);
		list.addAll(groovyAttributeRepositories);
		list.addAll(grouperAttributeRepositories);
		list.addAll(restfulAttributeRepositories);
		list.addAll(scriptedAttributeRepositories);
		list.addAll(stubAttributeRepositories);
		list.addAll(ldapUserGroupAttributeRepository());

		OrderComparator.sort(list);

		log.debug("Final list of attribute repositories is [{}]", list);
		return list;
	}

	@Bean
	@RefreshScope
	public List<IPersonAttributeDao> ldapUserGroupAttributeRepository() {
		List<IPersonAttributeDao> daos = new ArrayList<>();
		if (StringUtils.isNotBlank(attrRepoProperties.getLdapUrl())) {
			log.debug("Configuring LDAP user/group attribute source for [{}]", attrRepoProperties.getLdapUrl());
			final ConnectionFactory cf = LdapUtils.newLdaptivePooledConnectionFactory(attrRepoProperties);
			final CascadingPersonAttributeDao cascadingDao = new CascadingPersonAttributeDao();
			cascadingDao.setOrder(attrRepoProperties.getOrder());
			cascadingDao.setStopIfFirstDaoReturnsNull(true);
			cascadingDao.setMerger(new JoiningAttributeMerger());
			cascadingDao.setPersonAttributeDaos(Arrays.asList(ldapUserAttributeRepository(cf), ldapGroupAttributeRepository(cf)));
			daos.add(cascadingDao);
		}
		return daos;
	}

	private IPersonAttributeDao ldapUserAttributeRepository(ConnectionFactory cf) {
		log.debug("LDAP user attributes are fetched from [{}] with baseDn [{}] via filter [{}]", attrRepoProperties.getLdapUrl(), attrRepoProperties.getUserDn(), attrRepoProperties.getUserFilter());
		final LdaptivePersonAttributeDao ldapDao = new LdaptivePersonAttributeDao();
		ldapDao.setConnectionFactory(cf);
		ldapDao.setBaseDN(attrRepoProperties.getUserDn());
		ldapDao.setSearchFilter(attrRepoProperties.getUserFilter());
		ldapDao.setSearchControls(searchControls(attrRepoProperties.getUserAttributes(), attrRepoProperties.isSubtreeSearch()));
		ldapDao.setResultAttributeMapping(attrRepoProperties.getUserAttributes());
		log.debug("Initializing LDAP user attribute source for [{}]", attrRepoProperties.getLdapUrl());
		ldapDao.initialize();
		return ldapDao;
	}

	private IPersonAttributeDao ldapGroupAttributeRepository(ConnectionFactory cf) {
		log.debug("LDAP group attributes are fetched from [{}] with baseDn [{}] via filter [{}]", attrRepoProperties.getLdapUrl(), attrRepoProperties.getGroupDn(), attrRepoProperties.getGroupFilter());
		final LdaptivePersonAttributeDao ldapDao = new LdaptivePersonAttributeDao();
		ldapDao.setConnectionFactory(cf);
		ldapDao.setBaseDN(attrRepoProperties.getGroupDn());
		ldapDao.setSearchFilter(attrRepoProperties.getGroupFilter());
		ldapDao.setSearchControls(searchControls(attrRepoProperties.getGroupAttributes(), attrRepoProperties.isSubtreeSearch()));
		ldapDao.setQueryAttributeMapping(attrRepoProperties.getGroupMemberMapping());
		ldapDao.setResultAttributeMapping(attrRepoProperties.getGroupAttributes());
		if (attrRepoProperties.getGroupAttributes().size() > 0) {
			ldapDao.setUnmappedUsernameAttribute(attrRepoProperties.getGroupAttributes().keySet().iterator().next());
		}
		log.debug("Initializing LDAP group attribute source for [{}]", attrRepoProperties.getLdapUrl());
		ldapDao.initialize();
		return ldapDao;
	}

	private SearchControls searchControls(Map<String, String> attrs, boolean isSubtreeSearch) {
		final SearchControls constraints = new SearchControls();
		if (attrs != null && !attrs.isEmpty()) {
			log.debug("Configured result attribute mapping to be [{}]", attrs);
			final String[] attributes = attrs.keySet().toArray(new String[attrs.keySet().size()]);
			constraints.setReturningAttributes(attributes);
		}
		if (isSubtreeSearch) {
			log.debug("Configured subtree searching");
			constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);
		}
		constraints.setDerefLinkFlag(true);
		return constraints;
	}

}
