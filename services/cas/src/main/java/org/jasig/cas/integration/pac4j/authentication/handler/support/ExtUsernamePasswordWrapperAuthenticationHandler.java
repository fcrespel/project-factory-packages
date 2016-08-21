package org.jasig.cas.integration.pac4j.authentication.handler.support;

import java.security.GeneralSecurityException;
import java.util.List;
import java.util.regex.Pattern;

import javax.security.auth.login.FailedLoginException;

import org.apache.commons.lang3.StringUtils;
import org.jasig.cas.authentication.Credential;
import org.jasig.cas.authentication.HandlerResult;
import org.jasig.cas.authentication.PreventedException;
import org.jasig.cas.authentication.listener.AuthenticationListener;

/**
 * Extended UsernamePasswordWrapperAuthenticationHandler with support for firing
 * multiple AuthenticationListener instances after successful authentication.
 * 
 * Specific usernames matching a regex may also be excluded from using this handler.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public class ExtUsernamePasswordWrapperAuthenticationHandler extends UsernamePasswordWrapperAuthenticationHandler {

	protected Pattern excludedUsernamesPattern;
	protected List<AuthenticationListener> authenticationListeners;

	public Pattern getExcludedUsernamesPattern() {
		return excludedUsernamesPattern;
	}

	public void setExcludedUsernamesPattern(Pattern excludedUsernamesPattern) {
		this.excludedUsernamesPattern = excludedUsernamesPattern;
	}

	public String getExcludedUsernamesRegex() {
		return (excludedUsernamesPattern != null) ? excludedUsernamesPattern.pattern() : null;
	}

	public void setExcludedUsernamesRegex(String excludedUsernamesRegex) {
		this.excludedUsernamesPattern = StringUtils.isNotBlank(excludedUsernamesRegex) ? Pattern.compile(excludedUsernamesRegex) : null;
	}

	public List<AuthenticationListener> getAuthenticationListeners() {
		return authenticationListeners;
	}

	public void setAuthenticationListeners(List<AuthenticationListener> authenticationListeners) {
		this.authenticationListeners = authenticationListeners;
	}

	@Override
	protected HandlerResult doAuthentication(Credential credential) throws GeneralSecurityException, PreventedException {
		Pattern excludedUsernamesPattern = getExcludedUsernamesPattern();
		if (excludedUsernamesPattern != null && excludedUsernamesPattern.matcher(credential.getId()).find())
			throw new PreventedException("User ID '" + credential.getId() + "' is excluded from authenticating with this handler", null);

		try {
			HandlerResult result = super.doAuthentication(credential);
			return fireAuthenticationListeners(credential, result);
		} catch (GeneralSecurityException | PreventedException e) {
			throw e;
		} catch (Exception e) {
			throw new FailedLoginException("Failed to validate credentials: " + e.getMessage());
		}
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
