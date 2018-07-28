package org.apereo.cas.authentication.handler;

import java.security.GeneralSecurityException;
import java.util.regex.Pattern;

import javax.security.auth.login.AccountNotFoundException;

import org.apereo.cas.authentication.AbstractAuthenticationHandler;
import org.apereo.cas.authentication.AuthenticationHandler;
import org.apereo.cas.authentication.Credential;
import org.apereo.cas.authentication.HandlerResult;
import org.apereo.cas.authentication.PreventedException;

import lombok.Getter;
import lombok.Setter;

/**
 * Authentication handler filtering usernames with a regex.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Getter
@Setter
public class FilteringAuthenticationHandler extends AbstractAuthenticationHandler {

	private final AuthenticationHandler handler;

	protected Pattern excludedUsernamesPattern;

	public FilteringAuthenticationHandler(AuthenticationHandler handler) {
		super(handler.getName(), null, null, handler.getOrder());
		this.handler = handler;
	}

	@Override
	public HandlerResult authenticate(Credential credential) throws GeneralSecurityException, PreventedException {
		Pattern excludedUsernamesPattern = getExcludedUsernamesPattern();
		if (excludedUsernamesPattern != null && excludedUsernamesPattern.matcher(credential.getId()).find())
			throw new AccountNotFoundException("User ID '" + credential.getId() + "' is excluded from authenticating with this handler");

		return handler.authenticate(credential);
	}

	@Override
	public boolean supports(Credential credential) {
		return handler.supports(credential);
	}

}
