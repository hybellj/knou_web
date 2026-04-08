package knou.lms.log.logintry.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import knou.framework.common.CommConst;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.logintry.dao.LogUserLoginTryLogDAO;
import knou.lms.log.logintry.service.LogUserLoginTryLogService;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;

/**
 *  <b>로그 - 로그인 시도 로그 관리</b> 영역  Service 클래스
 * @author Jamfam
 *
 */
@Service("logUserLoginTryLogService")
public class LogUserLoginTryLogServiceImpl 
	extends EgovAbstractServiceImpl implements LogUserLoginTryLogService {

    @Resource(name="logUserLoginTryLogDAO")
    private LogUserLoginTryLogDAO 		logUserLoginTryLogDAO;
    
    
    
	/**
	 *  로그인 시도 로그 전체 목록을 조회한다.
	 * @param LogUserLoginTryLogVO
	 * @return ProcessResultVO
	 * @throws Exception
	 */
 	@Override
	public ProcessResultVO<LogUserLoginTryLogVO> list(LogUserLoginTryLogVO vo) throws Exception {
 	   ProcessResultVO<LogUserLoginTryLogVO> resultList = new ProcessResultVO<LogUserLoginTryLogVO>(); 
  		List<LogUserLoginTryLogVO> logList =  logUserLoginTryLogDAO.list(vo);
  		resultList.setResult(1);
  		resultList.setReturnList(logList);
  		return resultList;
  	}
  	
	/**
	 * 로그인 시도 로그 페이징 목록을 조회한다.
	 * @param LogUserLoginTryLogVO
	 * @param pageIndex
	 * @param listScale
	 * @param pageScale
	 * @return ProcessResultVO
	 * @throws Exception
	 */
 	@Override
	public ProcessResultVO<LogUserLoginTryLogVO> listPageing(LogUserLoginTryLogVO vo, 
  			int pageIndex, int listScale, int pageScale) throws Exception {
 	    ProcessResultVO<LogUserLoginTryLogVO> resultList = new ProcessResultVO<LogUserLoginTryLogVO>(); 
  		
 		// 전체 목록 수
 		int totalCount = logUserLoginTryLogDAO.count(vo);
 		
 		List<LogUserLoginTryLogVO> logList =  logUserLoginTryLogDAO.listPageing(vo);
 		resultList.setResult(1);
 		resultList.setReturnList(logList);
  			
  		return resultList;
  	}
  	
	/**
	 * 로그인 시도 로그 페이징 목록을 조회한다.
	 * @param LogUserLoginTryLogVO
	 * @param pageIndex
	 * @param listScale
	 * @return ProcessResultVO
	 * @throws Exception
	 */
 	@Override
	public ProcessResultVO<LogUserLoginTryLogVO> listPageing(LogUserLoginTryLogVO vo, 
  			int pageIndex, int listScale) throws Exception {
  		return this.listPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
  	}
  	
	/**
	 * 로그인 시도 로그 페이징 목록을 조회한다.
	 * @param LogUserLoginTryLogVO
	 * @param pageIndex
	 * @return ProcessResultVO
	 * @throws Exception
	 */
 	@Override
	public ProcessResultVO<LogUserLoginTryLogVO> listPageing(LogUserLoginTryLogVO vo, 
  			int pageIndex) throws Exception {
  		return this.listPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
  	}
 	
	/**
	 * 로그인 시도 로그 정보를 등록한다.
	 * @param LogUserLoginTryLogVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public void add(LogUserLoginTryLogVO vo) throws Exception {
		if(ValidationUtils.isNull(vo.getLoginTrySn())) {
			vo.setLoginTrySn(IdGenerator.getNewId("ULOG"));
		}
		/* logUserLoginTryLogDAO.insert(vo); */
	}
}
