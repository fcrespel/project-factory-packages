package org.pac4j.cas.profile.creator;

import javax.validation.constraints.NotNull;

import org.pac4j.cas.client.rest.AbstractCasRestClient;
import org.pac4j.cas.credentials.CasCredentials;
import org.pac4j.cas.profile.CasProfile;
import org.pac4j.cas.profile.HttpTGTProfile;
import org.pac4j.core.profile.UserProfile;
import org.pac4j.http.credentials.HttpCredentials;
import org.pac4j.http.profile.creator.ProfileCreator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * CAS REST profile creator using a TGT to create a ST and validate it.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public class CasRestProfileCreator implements ProfileCreator<HttpCredentials, UserProfile> {
	
	private static final Logger log = LoggerFactory.getLogger(CasRestProfileCreator.class);

	private @NotNull AbstractCasRestClient casRestClient;
	private @NotNull String serviceUrl;

	public AbstractCasRestClient getCasRestClient() {
		return casRestClient;
	}

	public void setCasRestClient(AbstractCasRestClient casRestClient) {
		this.casRestClient = casRestClient;
	}

	public String getServiceUrl() {
		return serviceUrl;
	}

	public void setServiceUrl(String serviceUrl) {
		this.serviceUrl = serviceUrl;
	}

	@Override
	public UserProfile create(HttpCredentials credentials) {
		UserProfile authProfile = credentials.getUserProfile();
		if (authProfile instanceof HttpTGTProfile) {
			HttpTGTProfile tgtProfile = (HttpTGTProfile) authProfile;
			log.debug("Requesting Service Ticket via CAS REST API");
			CasCredentials ticket = casRestClient.requestServiceTicket(serviceUrl, tgtProfile);
			log.debug("Validating Service Ticket '" + ticket.getServiceTicket() + "' via CAS REST API");
			CasProfile casProfile = casRestClient.validateServiceTicket(serviceUrl, ticket);
			log.debug("Destroying Ticket Granting Ticket via CAS REST API");
			casRestClient.destroyTicketGrantingTicket(null, tgtProfile);
			return casProfile;
		} else {
			return authProfile;
		}
	}

}
