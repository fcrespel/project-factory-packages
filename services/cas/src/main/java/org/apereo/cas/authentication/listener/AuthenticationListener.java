package org.apereo.cas.authentication.listener;

import java.security.GeneralSecurityException;

import org.apereo.cas.authentication.Credential;
import org.apereo.cas.authentication.HandlerResult;
import org.apereo.cas.authentication.PreventedException;

/**
 * Authentication listener.
 * 
 * Listeners are called whenever authentication succeeded, are free to perform
 * any relevant action and may decide to mark the authentication as failed.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
public interface AuthenticationListener {

	/**
	 * Method to execute after authentication occurs.
	 * 
	 * @param credential the supplied credential
	 * @param result latest authentication handler result
	 * @return new authentication handler result
	 */
	HandlerResult postAuthenticate(Credential credential, HandlerResult result) throws GeneralSecurityException, PreventedException;

}
