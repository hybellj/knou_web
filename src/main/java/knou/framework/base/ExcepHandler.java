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
		log.error(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>에러", ex);
		log.error(packageName + " --> "+ex.toString());
	}
}
