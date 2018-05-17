package org.pac4j.cas.profile.creator;

import javax.validation.constraints.NotNull;

import org.pac4j.cas.client.rest.AbstractCasRestClient;
import org.pac4j.cas.profile.CasProfile;
import org.pac4j.cas.profile.CasRestProfile;
import org.pac4j.core.context.WebContext;
import org.pac4j.core.credentials.Credentials;
import org.pac4j.core.credentials.TokenCredentials;
import org.pac4j.core.profile.CommonProfile;
import org.pac4j.core.profile.creator.ProfileCreator;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * CAS REST profile creator using a TGT to create a ST and validate it.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Slf4j
@Getter
@Setter
public class CasRestProfileCreator implements ProfileCreator<Credentials, CommonProfile> {

	private @NotNull AbstractCasRestClient casRestClient;
	private @NotNull String serviceUrl;

	@Override
	public CommonProfile create(Credentials credentials, WebContext context) {
		CommonProfile authProfile = credentials.getUserProfile();
		if (authProfile instanceof CasRestProfile) {
			CasRestProfile tgtProfile = (CasRestProfile) authProfile;
			log.debug("Requesting Service Ticket via CAS REST API at [{}]", casRestClient.getConfiguration().getRestUrl());
			TokenCredentials ticket = casRestClient.requestServiceTicket(serviceUrl, tgtProfile, context);
			log.debug("Validating Service Ticket [{}] via CAS REST API", ticket.getToken());
			CasProfile casProfile = casRestClient.validateServiceTicket(serviceUrl, ticket, context);
			log.debug("Destroying Ticket Granting Ticket [{}] via CAS REST API", tgtProfile.getTicketGrantingTicketId());
			casRestClient.destroyTicketGrantingTicket(tgtProfile, context);
			return casProfile;
		} else {
			return authProfile;
		}
	}

}
