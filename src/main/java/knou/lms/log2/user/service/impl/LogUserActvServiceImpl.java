package knou.lms.log2.user.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log2.user.dao.LogUserActvDAO;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.LogUserActvVO;

@Service("logUserActvService")
public class LogUserActvServiceImpl extends ServiceBase implements LogUserActvService {

    @Resource(name="logUserActvDAO")
    private LogUserActvDAO logUserActvDAO;

	/*
	 * @Override public Object userSbjctOfrngActvHstryList(String sbjctId, int
	 * timeRange) throws Exception { return
	 * logUserActvDAO.userSbjctOfrngActvHstryList(sbjctId, timeRange); }
	 */

    /*****************************************************
     * 강의실 활동 로그 조회 현황 목록 페이징 (TB_LMS_LOG_USER_ACTV)
     * @param LogUserActvVO
     * @return ProcessResultVO<LogUserActvVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<LogUserActvVO> selectLogUserActvList(LogUserActvVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<LogUserActvVO> list = logUserActvDAO.selectLogUserActvList(vo);

        paginationInfo.setTotalRecordCount(list.size() > 0 ? list.get(0).getTotalCnt() : 0);

        ProcessResultVO<LogUserActvVO> resultVO = new ProcessResultVO<LogUserActvVO>();
        resultVO.setReturnList(list);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }
}