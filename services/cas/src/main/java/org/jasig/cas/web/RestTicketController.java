package org.jasig.cas.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import javax.validation.ValidationException;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.CentralAuthenticationService;
import org.jasig.cas.authentication.principal.SimpleWebApplicationServiceImpl;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.ticket.InvalidTicketException;
import org.jasig.cas.ticket.TicketException;
import org.jasig.cas.util.HttpClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.validation.Validator;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

/**
 * Tickets REST resource controller.
 * 
 * This resource allows obtaining/destroying Ticket Granting Tickets
 * as well as Service Tickets for a given service URL.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
@Controller
public class RestTicketController {
	
	private static final Logger log = LoggerFactory.getLogger(RestTicketController.class);
	private static final String DEFAULT_TGT_VIEW_NAME = "restTicketGrantingTicketView";
	
	@NotNull
	protected CentralAuthenticationService centralAuthenticationService;
	
	@NotNull
	protected HttpClient httpClient;
	
	protected Validator validator;
	
	@InitBinder
	protected void initBinder(WebDataBinder binder) {
		binder.setValidator(validator);
	}
	
	@ExceptionHandler(Exception.class)
	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
	public void handleUnknownException(Exception e, HttpServletResponse response) throws IOException {
		log.error(e.getMessage(), e);
		response.setContentType("text/plain");
		response.getWriter().write(e.getMessage());
	}
	
	@ExceptionHandler(ValidationException.class)
	@ResponseStatus(HttpStatus.BAD_REQUEST)
	public void handleValidationException(ValidationException e, HttpServletResponse response) throws IOException {
		response.setContentType("text/plain");
		response.getWriter().write(e.getMessage());
	}
	
	@ExceptionHandler(TicketException.class)
	@ResponseStatus(HttpStatus.BAD_REQUEST)
	public void handleTicketException(TicketException e, HttpServletResponse response) throws IOException {
		response.setContentType("text/plain");
		response.getWriter().write(e.getMessage());
	}
	
	@ExceptionHandler(InvalidTicketException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public void handleInvalidTicketException(InvalidTicketException e, HttpServletResponse response) throws IOException {
		response.setContentType("text/plain");
		response.getWriter().write(e.getMessage());
	}

	@RequestMapping(value="/", method=RequestMethod.POST)
	@ResponseStatus(HttpStatus.CREATED)
	public ModelAndView postCredentials(@Valid @ModelAttribute("credentials") UsernamePasswordCredentials credentials, BindingResult result, HttpServletRequest request, HttpServletResponse response) throws IOException, ValidationException, TicketException {
		if (result.hasErrors()) {
			List<String> errors = new ArrayList<String>();
			for (ObjectError error : result.getAllErrors()) {
				StringBuilder sb = new StringBuilder();
				if (error instanceof FieldError) {
					sb.append(((FieldError)error).getField());
				} else {
					sb.append(error.getObjectName());
				}
				sb.append(": ").append(error.getDefaultMessage());
				errors.add(sb.toString());
			}
			throw new ValidationException(StringUtils.join(errors, "\n"));
		}

		String ticketGrantingTicket = this.centralAuthenticationService.createTicketGrantingTicket(credentials);
		String ticketRef = ServletUriComponentsBuilder.fromServletMapping(request)
				.path("/{ticketGrantingTicketId}")
				.build()
				.expand(ticketGrantingTicket)
				.toUriString();
		
		response.addHeader("Location", ticketRef);
		return new ModelAndView(DEFAULT_TGT_VIEW_NAME, "ticket_ref", ticketRef);
	}

	@RequestMapping(value="/{ticketGrantingTicketId}/**", method=RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void postTicketGrantingTicket(@PathVariable String ticketGrantingTicketId, @RequestParam("service") String serviceUrl, HttpServletResponse response) throws IOException, TicketException, InvalidTicketException {
		String serviceTicketId = this.centralAuthenticationService.grantServiceTicket(ticketGrantingTicketId, new SimpleWebApplicationServiceImpl(serviceUrl, this.httpClient));
		response.setContentType("text/plain");
		response.getWriter().write(serviceTicketId);
	}

	@RequestMapping(value="/{ticketGrantingTicketId}/**", method=RequestMethod.DELETE)
	@ResponseStatus(HttpStatus.OK)
	public void deleteTicketGrantingTicket(@PathVariable String ticketGrantingTicketId) {
		this.centralAuthenticationService.destroyTicketGrantingTicket(ticketGrantingTicketId);
	}

	public CentralAuthenticationService getCentralAuthenticationService() {
		return centralAuthenticationService;
	}

	public void setCentralAuthenticationService(CentralAuthenticationService centralAuthenticationService) {
		this.centralAuthenticationService = centralAuthenticationService;
	}

	public HttpClient getHttpClient() {
		return httpClient;
	}

	public void setHttpClient(HttpClient httpClient) {
		this.httpClient = httpClient;
	}

	public Validator getValidator() {
		return validator;
	}

	public void setValidator(Validator validator) {
		this.validator = validator;
	}
	
}
