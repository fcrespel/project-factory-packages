package org.jasig.cas.authentication.handler.support;

import java.util.regex.Pattern;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.authentication.handler.AuthenticationException;
import org.jasig.cas.authentication.principal.Principal;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.springframework.web.client.RestTemplate;

/**
 * Abstract REST authentication handler.
 *
 * @author Fabien Crespel <fabien@crespel.net>
 */
public abstract class AbstractRestUsernamePasswordAuthenticationHandler extends AbstractListenerEnabledUsernamePasswordAuthenticationHandler {
	
	@NotNull
	protected RestTemplate restTemplate;
	
	protected Pattern excludedUsernamesPattern;

	public RestTemplate getRestTemplate() {
		return restTemplate;
	}

	public void setRestTemplate(RestTemplate restTemplate) {
		this.restTemplate = restTemplate;
	}
	
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
	
	@Override
	protected boolean authenticateUsernamePasswordInternal(UsernamePasswordCredentials credentials) throws AuthenticationException {
		Pattern excludedUsernamesPattern = getExcludedUsernamesPattern();
		if (excludedUsernamesPattern != null && excludedUsernamesPattern.matcher(credentials.getUsername()).find())
			return false;
		
		Principal principal = authenticateUsernamePasswordPrincipal(credentials);
		if (principal == null)
			return false;
		
		return fireAuthenticationListeners(credentials, principal);
	}
	
	protected abstract Principal authenticateUsernamePasswordPrincipal(UsernamePasswordCredentials credentials) throws AuthenticationException;

}
