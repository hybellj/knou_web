package knou.framework.base;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.egovframe.rte.fdl.cmmn.exception.handler.ExceptionHandler;

public class ExcepHandler implements ExceptionHandler  {
	private static final Logger LOGGER = LoggerFactory.getLogger(ExcepHandler.class);

	/**
	* @param ex
	* @param packageName
	*/
	@Override
	public void occur(Exception ex, String packageName) {
		ex.printStackTrace();
		LOGGER.debug(packageName + " --> "+ex.toString());
	}
}
