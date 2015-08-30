package org.jasig.cas.authentication.handler.support;

import java.util.List;

import org.jasig.cas.authentication.listener.AuthenticationListener;
import org.jasig.cas.authentication.principal.Credentials;
import org.jasig.cas.authentication.principal.Principal;

/**
 * Abstract AuthenticationListener-enabled authentication handler.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public abstract class AbstractListenerEnabledUsernamePasswordAuthenticationHandler extends AbstractUsernamePasswordAuthenticationHandler {

	protected List<AuthenticationListener> authenticationListeners;

	public List<AuthenticationListener> getAuthenticationListeners() {
		return authenticationListeners;
	}

	public void setAuthenticationListeners(List<AuthenticationListener> authenticationListeners) {
		this.authenticationListeners = authenticationListeners;
	}
	
	/**
	 * Execute authentication listeners in the order in which they have been defined.
	 * The first listener to return false will halt the execution.
	 * @param credentials
	 * @param principal
	 * @return true if all listeners executed without returning false
	 */
	protected boolean fireAuthenticationListeners(final Credentials credentials, final Principal principal) {
		if (authenticationListeners != null) {
			for (AuthenticationListener listener : authenticationListeners) {
				if (!listener.postAuthenticate(credentials, principal))
					return false;
			}
		}
		return true;
	}

}
