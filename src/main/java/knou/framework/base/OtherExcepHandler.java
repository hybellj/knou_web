package knou.framework.base;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.egovframe.rte.fdl.cmmn.exception.handler.ExceptionHandler;

public class OtherExcepHandler implements ExceptionHandler {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(OtherExcepHandler.class);
	
	/**
	* @param ex
	* @param packageName
	*/
	@Override
	public void occur(Exception ex, String packageName) {
		LOGGER.debug(packageName + " --> "+ex.toString());
	}
}
