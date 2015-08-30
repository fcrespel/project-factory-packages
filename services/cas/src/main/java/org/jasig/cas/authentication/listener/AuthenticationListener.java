package org.jasig.cas.authentication.listener;

import org.jasig.cas.authentication.principal.Credentials;
import org.jasig.cas.authentication.principal.Principal;

/**
 * Authentication listener.
 * 
 * Listeners are called whenever authentication succeeded, are free to perform
 * any relevant action and may decide to mark the authentication as failed.
 * In such a case, subsequent listeners will not be called.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public interface AuthenticationListener {

	/**
     * Method to execute after authentication occurs.
     * 
     * @param credentials the supplied credentials
     * @param principal the authenticated principal
     * @return true if the handler should return true, false otherwise.
     */
	boolean postAuthenticate(final Credentials credentials, final Principal principal);

}
