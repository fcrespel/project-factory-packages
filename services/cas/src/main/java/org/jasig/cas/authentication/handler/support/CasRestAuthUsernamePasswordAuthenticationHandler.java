package org.jasig.cas.authentication.handler.support;

import java.util.HashMap;
import java.util.Map;

import javax.validation.constraints.NotNull;
import javax.xml.transform.dom.DOMSource;

import org.jasig.cas.authentication.handler.AuthenticationException;
import org.jasig.cas.authentication.handler.UnknownUsernameAuthenticationException;
import org.jasig.cas.authentication.principal.Principal;
import org.jasig.cas.authentication.principal.SimplePrincipal;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Remote CAS server REST authentication handler.
 * 
 * This handler relies on the RestAuthController being present and configured
 * on a remote CAS server, in order to directly authenticate against it.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public class CasRestAuthUsernamePasswordAuthenticationHandler extends AbstractRestUsernamePasswordAuthenticationHandler {
	
	private static final Logger log = LoggerFactory.getLogger(CasRestAuthUsernamePasswordAuthenticationHandler.class);
	private static final String CAS_NAMESPACE_URL = "http://www.yale.edu/tp/cas";

	@NotNull
	protected String restAuthUrl;

	public String getRestAuthUrl() {
		return restAuthUrl;
	}

	public void setRestAuthUrl(String restAuthUrl) {
		this.restAuthUrl = restAuthUrl;
	}

	@Override
	protected Principal authenticateUsernamePasswordPrincipal(UsernamePasswordCredentials credentials) throws AuthenticationException {
		// Prepare arguments
		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
		params.add("username", credentials.getUsername());
		params.add("password", credentials.getPassword());
		
		// Call the remote CAS server
		DOMSource response;
		try {
			response = restTemplate.postForObject(getRestAuthUrl(), params, DOMSource.class);
		} catch (Exception e) {
			log.info("Error calling remote CAS REST Auth API", e);
			return null;
		}
		
		// Parse the response into a Principal
		return parseResponse(credentials, (Document) response.getNode());
	}
	
	/**
	 * Parse the response from the remote CAS server as a Principal with attributes.
	 * @param credentials
	 * @param response
	 * @return Principal object
	 * @throws AuthenticationException
	 */
	protected Principal parseResponse(UsernamePasswordCredentials credentials, Document doc) throws AuthenticationException {
		// Ensure a response was provided
		if (doc == null) {
			log.info("Missing REST authentication response");
			return null;
		}
		
		// Parse root element
		Element root = doc.getDocumentElement();
		Element authSuccess = (Element) root.getElementsByTagNameNS(CAS_NAMESPACE_URL, "authenticationSuccess").item(0);
		if (authSuccess == null) {
			log.info("Malformed REST authentication response: missing 'authenticationSuccess' element");
			return null;
		}
		
		// Parse user
		Element user = (Element) authSuccess.getElementsByTagNameNS(CAS_NAMESPACE_URL, "user").item(0);
		if (user == null) {
			log.info("Malformed REST authentication response: missing 'user' element");
			return null;
		} else if (!credentials.getUsername().equalsIgnoreCase(user.getTextContent())) {
			// This should not happen
			log.info("Malformed REST authentication response: credentials username (" + credentials.getUsername() + ") and response user element (" + user.getTextContent() + ") do not match");
			throw UnknownUsernameAuthenticationException.ERROR;
		}
		
		// Parse attributes
		Map<String, Object> attributesMap = null;
		Element attributes = (Element) authSuccess.getElementsByTagNameNS(CAS_NAMESPACE_URL, "attributes").item(0);
		if (attributes != null) {
			NodeList attributesList = attributes.getChildNodes();
			attributesMap = new HashMap<String, Object>(attributesList.getLength());
			for (int i = 0; i < attributesList.getLength(); i++) {
				Node attributeNode = attributesList.item(i);
				if (attributeNode instanceof Element) {
					Element attribute = (Element) attributeNode;
					attributesMap.put(attribute.getLocalName(), attribute.getTextContent());
				}
			}
		}
		
		return new SimplePrincipal(credentials.getUsername(), attributesMap);
	}
}
