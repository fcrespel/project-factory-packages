package org.jasig.cas.authentication.handler.support;

import java.net.URI;

import javax.validation.constraints.NotNull;

import org.jasig.cas.authentication.handler.AuthenticationException;
import org.jasig.cas.authentication.principal.Principal;
import org.jasig.cas.authentication.principal.SimplePrincipal;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.client.validation.Assertion;
import org.jasig.cas.client.validation.TicketValidationException;
import org.jasig.cas.client.validation.TicketValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;

/**
 * Remote CAS server REST authentication handler.
 * 
 * This handler relies on the RestTicketController being present and configured
 * on a remote CAS server, in order to directly authenticate against it.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public class CasRestTicketUsernamePasswordAuthenticationHandler extends AbstractRestUsernamePasswordAuthenticationHandler {

	private static final Logger log = LoggerFactory.getLogger(CasRestTicketUsernamePasswordAuthenticationHandler.class);

	@NotNull
	protected String restTicketUrl;
	
	@NotNull
	protected String service;
	
	@NotNull
	protected TicketValidator ticketValidator;

	public String getRestTicketUrl() {
		return restTicketUrl;
	}

	public void setRestTicketUrl(String restTicketUrl) {
		this.restTicketUrl = restTicketUrl;
	}
	
	public String getService() {
		return service;
	}

	public void setService(String service) {
		this.service = service;
	}

	public TicketValidator getTicketValidator() {
		return ticketValidator;
	}

	public void setTicketValidator(TicketValidator ticketValidator) {
		this.ticketValidator = ticketValidator;
	}

	@Override
	protected Principal authenticateUsernamePasswordPrincipal(UsernamePasswordCredentials credentials) throws AuthenticationException {
		URI tgt = null;
		try {
			tgt = createTicketGrantingTicket(credentials);
			String st = grantServiceTicket(tgt, getService());
			Assertion assertion = validateServiceTicket(st, getService());
			
			return new SimplePrincipal(assertion.getPrincipal().getName(), assertion.getPrincipal().getAttributes());
			
		} catch (TicketValidationException e) {
			log.info("Error validating remote CAS REST Ticket", e);
			return null;
			
		} catch (Exception e) {
			log.info("Error calling remote CAS REST Ticket API", e);
			return null;
			
		} finally {
			if (tgt != null) {
				try {
					destroyTicketGrantingTicket(tgt);
				} catch (Throwable e) {
					// Ignored
				}
			}
		}
	}
	
	protected URI createTicketGrantingTicket(UsernamePasswordCredentials credentials) throws RestClientException {
		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
		params.add("username", credentials.getUsername());
		params.add("password", credentials.getPassword());
		return restTemplate.postForLocation(getRestTicketUrl(), params);
	}
	
	protected String grantServiceTicket(URI tgtUri, String service) throws RestClientException {
		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
		params.add("service", service);
		return restTemplate.postForObject(tgtUri, params, String.class);
	}
	
	protected Assertion validateServiceTicket(String serviceTicket, String service) throws TicketValidationException {
		return getTicketValidator().validate(serviceTicket, service);
	}
	
	protected void destroyTicketGrantingTicket(URI tgtUri) throws RestClientException {
		restTemplate.delete(tgtUri);
	}

}
