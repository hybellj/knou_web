package knou.framework.base;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.egovframe.rte.fdl.cmmn.exception.handler.ExceptionHandler;

public class OtherExcepHandler implements ExceptionHandler {
	
	private static final Logger log = LoggerFactory.getLogger(OtherExcepHandler.class);
	
	/**
	* @param ex
	* @param packageName
	*/
	@Override
	public void occur(Exception ex, String packageName) {
		//log.error("[ERROR] 위치: {} | 내용: {}", packageName, ex.getMessage());
	}
}
