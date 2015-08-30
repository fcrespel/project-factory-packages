package org.jasig.cas.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import javax.validation.ValidationException;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.authentication.Authentication;
import org.jasig.cas.authentication.AuthenticationManager;
import org.jasig.cas.authentication.handler.AuthenticationException;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

/**
 * Authentication REST resource.
 * 
 * This resource directly authenticates credentials passed to it, and returns
 * a CAS 2.0 XML response, including attributes.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
@Controller
public class RestAuthController {

	private static final Logger log = LoggerFactory.getLogger(RestAuthController.class);
	private static final String DEFAULT_AUTH_SUCCESS_VIEW_NAME = "restAuthSuccessView";
	private static final String DEFAULT_AUTH_FAILURE_VIEW_NAME = "restAuthFailureView";
	
	@NotNull
	protected AuthenticationManager authenticationManager;
	
	@NotNull
	protected MessageSource messageSource;
	
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
	
	@ExceptionHandler(AuthenticationException.class)
	@ResponseStatus(HttpStatus.BAD_REQUEST)
	public ModelAndView handleAuthenticationException(AuthenticationException e, HttpServletResponse response) throws IOException {
		ModelAndView mav = new ModelAndView(DEFAULT_AUTH_FAILURE_VIEW_NAME);
		mav.addObject("code", "INVALID_CREDENTIALS");
		mav.addObject("description", messageSource.getMessage(e.getCode(), null, e.getCode(), null));
		return mav;
	}
	
	@RequestMapping(value="/", method=RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public ModelAndView authenticate(@Valid @ModelAttribute("credentials") UsernamePasswordCredentials credentials, BindingResult result) throws ValidationException, AuthenticationException {
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
		
		Authentication auth = authenticationManager.authenticate(credentials);
		return new ModelAndView(DEFAULT_AUTH_SUCCESS_VIEW_NAME, "auth", auth);
	}
	
	public AuthenticationManager getAuthenticationManager() {
		return authenticationManager;
	}

	public void setAuthenticationManager(AuthenticationManager authenticationManager) {
		this.authenticationManager = authenticationManager;
	}

	public MessageSource getMessageSource() {
		return messageSource;
	}

	public void setMessageSource(MessageSource messageSource) {
		this.messageSource = messageSource;
	}

	public Validator getValidator() {
		return validator;
	}

	public void setValidator(Validator validator) {
		this.validator = validator;
	}

}
