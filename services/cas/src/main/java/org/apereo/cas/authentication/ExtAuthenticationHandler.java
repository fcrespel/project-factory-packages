package org.apereo.cas.authentication;

import java.security.GeneralSecurityException;
import java.util.List;
import java.util.regex.Pattern;

import javax.security.auth.login.AccountNotFoundException;
import javax.security.auth.login.FailedLoginException;

import org.apereo.cas.authentication.AbstractAuthenticationHandler;
import org.apereo.cas.authentication.AuthenticationHandler;
import org.apereo.cas.authentication.Credential;
import org.apereo.cas.authentication.HandlerResult;
import org.apereo.cas.authentication.PreventedException;
import org.apereo.cas.authentication.listener.AuthenticationListener;

import lombok.Getter;
import lombok.Setter;

/**
 * Extended AuthenticationHandler with support for firing multiple AuthenticationListener
 * instances after successful authentication using a delegated AuthenticationHandler. 
 * 
 * Specific usernames matching a regex may also be excluded from using this handler.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Getter
@Setter
public class ExtAuthenticationHandler extends AbstractAuthenticationHandler {

	private final AuthenticationHandler handler;

	protected Pattern excludedUsernamesPattern;
	protected List<AuthenticationListener> authenticationListeners;

	public ExtAuthenticationHandler(AuthenticationHandler handler) {
		super(handler.getName(), null, null, handler.getOrder());
		this.handler = handler;
	}

	@Override
	public HandlerResult authenticate(Credential credential) throws GeneralSecurityException, PreventedException {
		Pattern excludedUsernamesPattern = getExcludedUsernamesPattern();
		if (excludedUsernamesPattern != null && excludedUsernamesPattern.matcher(credential.getId()).find())
			throw new AccountNotFoundException("User ID '" + credential.getId() + "' is excluded from authenticating with this handler");

		try {
			HandlerResult result = handler.authenticate(credential);
			return fireAuthenticationListeners(credential, result);
		} catch (GeneralSecurityException | PreventedException e) {
			throw e;
		} catch (Exception e) {
			throw new FailedLoginException("Failed to validate credentials: " + e.getMessage());
		}
	}

	@Override
	public boolean supports(Credential credential) {
		return handler.supports(credential);
	}

	protected HandlerResult fireAuthenticationListeners(Credential credential, HandlerResult result) throws GeneralSecurityException, PreventedException {
		if (authenticationListeners != null) {
			for (AuthenticationListener listener : authenticationListeners) {
				result = listener.postAuthenticate(credential, result);
			}
		}
		return result;
	}

}
