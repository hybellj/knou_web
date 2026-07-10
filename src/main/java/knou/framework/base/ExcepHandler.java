package knou.framework.base;

import org.egovframe.rte.fdl.cmmn.exception.handler.ExceptionHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ExcepHandler implements ExceptionHandler  {
	
	private static final Logger log = LoggerFactory.getLogger(ExcepHandler.class);	
	/**
	* @param ex
	* @param packageName
	*/
	@Override
	public void occur(Exception ex, String packageName) {
	    //log.error("Service 단에서 발생한 Exception >>>>>>>>>>>>> ExcepHandler.occur > Exception 발생", ex.toString());
	}
}