package org.apereo.cas.config;

import java.util.regex.Pattern;

import org.pac4j.cas.config.CasProtocol;
import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.Getter;
import lombok.Setter;

/**
 * CAS REST authentication properties.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Getter
@Setter
@ConfigurationProperties("cas.authn.cas-rest")
public class CasRestAuthenticationProperties {

	private boolean enabled = false;
	private String name;
	private Integer order;
	private String serverUrl;
	private String ticketUrl;
	private String serviceUrl;
	private CasProtocol protocol = CasProtocol.SAML;
	private long timeTolerance = 30000L;
	private Pattern excludedUsernamesPattern;

}
