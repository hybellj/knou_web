package knou.lms.log.adminconnlog.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.log.adminconnlog.dao.LogAdminConnLogDAO;
import knou.lms.log.adminconnlog.service.LogAdminConnLogService;
import knou.lms.log.adminconnlog.vo.LogAdminConnLogVO;

@Service("logAdminConnLogService")
public class LogAdminConnLogServiceImpl implements LogAdminConnLogService {
	
	/** dao */
    @Resource(name="logAdminConnLogDAO")
    private LogAdminConnLogDAO logAdminConnLogDAO;
    
	@Override
	public ProcessResultListVO<LogAdminConnLogVO> listLoginLog(LogAdminConnLogVO vo, int pageIndex, int listScale, int pageScale) throws Exception{ 
		
	    ProcessResultListVO<LogAdminConnLogVO> resultList = new ProcessResultListVO<LogAdminConnLogVO>(); 
		
	    try {
		    
			/** start of paging */
	        PagingInfo paginationInfo = new PagingInfo();
			paginationInfo.setCurrentPageNo(pageIndex);
			paginationInfo.setRecordCountPerPage(listScale);
			paginationInfo.setPageSize(pageScale);
			
			vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
			vo.setLastIndex(paginationInfo.getLastRecordIndex());
			
			// 전체 목록 수
			int totalCount = logAdminConnLogDAO.count(vo);
			paginationInfo.setTotalRecordCount(totalCount);
			
			List<LogAdminConnLogVO> logList =  logAdminConnLogDAO.listPageing(vo);
			resultList.setResult(1);
			resultList.setReturnList(logList);
			resultList.setPageInfo(paginationInfo);
			
		} catch (Exception e) {
			e.printStackTrace();
			resultList.setResult(-1);
			resultList.setMessage(e.getMessage());
		}
		return resultList;
	}
 
	@Override
	public LogAdminConnLogVO viewLoginLogLast(LogAdminConnLogVO vo) throws Exception {
		return logAdminConnLogDAO.selectLastSn(vo);			
	}

	@Override
	public void addConnectLog(LogAdminConnLogVO vo) throws Exception {
		logAdminConnLogDAO.insert(vo);		
	}

	@Override
	public void editConnectLog(LogAdminConnLogVO vo) throws Exception {
		logAdminConnLogDAO.update(vo);
	}
}
