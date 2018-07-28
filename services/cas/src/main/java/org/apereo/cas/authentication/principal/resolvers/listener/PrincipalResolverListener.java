package org.apereo.cas.authentication.principal.resolvers.listener;

import org.apereo.cas.authentication.AuthenticationHandler;
import org.apereo.cas.authentication.Credential;
import org.apereo.cas.authentication.principal.Principal;

/**
 * Principal Resolver Listener interface.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
public interface PrincipalResolverListener {

	default Principal preResolve(Credential credential, Principal principal, AuthenticationHandler handler) {
		return principal;
	}

	default Principal postResolve(Credential credential, Principal principal, AuthenticationHandler handler) {
		return principal;
	}

}
