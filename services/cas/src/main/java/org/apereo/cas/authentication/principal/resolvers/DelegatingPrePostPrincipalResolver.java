package org.apereo.cas.authentication.principal.resolvers;

import java.util.List;

import org.apereo.cas.authentication.AuthenticationHandler;
import org.apereo.cas.authentication.Credential;
import org.apereo.cas.authentication.principal.Principal;
import org.apereo.cas.authentication.principal.PrincipalResolver;
import org.apereo.cas.authentication.principal.resolvers.listener.PrincipalResolverListener;
import org.apereo.services.persondir.IPersonAttributeDao;

import lombok.Getter;
import lombok.Setter;

/**
 * Principal resolver invoking pre/post-resolve listeners around an actual
 * implementation.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Getter
@Setter
public class DelegatingPrePostPrincipalResolver implements PrincipalResolver {

	private final PrincipalResolver resolver;

	protected List<PrincipalResolverListener> principalResolverListeners;

	public DelegatingPrePostPrincipalResolver(PrincipalResolver resolver) {
		this.resolver = resolver;
	}

	public DelegatingPrePostPrincipalResolver(PrincipalResolver resolver, List<PrincipalResolverListener> listeners) {
		this(resolver);
		this.principalResolverListeners = listeners;
	}

	protected Principal preResolve(Credential credential, Principal principal, AuthenticationHandler handler) {
		if (principalResolverListeners != null) {
			for (PrincipalResolverListener listener : principalResolverListeners) {
				principal = listener.preResolve(credential, principal, handler);
			}
		}
		return principal;
	}

	protected Principal postResolve(Credential credential, Principal principal, AuthenticationHandler handler) {
		if (principalResolverListeners != null) {
			for (PrincipalResolverListener listener : principalResolverListeners) {
				principal = listener.postResolve(credential, principal, handler);
			}
		}
		return principal;
	}

	@Override
	public Principal resolve(Credential credential, Principal principal, AuthenticationHandler handler) {
		principal = preResolve(credential, principal, handler);
		principal = resolver.resolve(credential, principal, handler);
		return postResolve(credential, principal, handler);
	}

	@Override
	public boolean supports(Credential credential) {
		return resolver.supports(credential);
	}

	@Override
	public IPersonAttributeDao getAttributeRepository() {
		return resolver.getAttributeRepository();
	}

}
