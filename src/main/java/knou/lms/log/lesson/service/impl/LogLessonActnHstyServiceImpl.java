package knou.lms.log.lesson.service.impl;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.CommonUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.lesson.dao.LogLessonActnHstyDAO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.lesson.vo.LogLessonActnHstyVO;

@Service("logLessonActnHstyService")
public class LogLessonActnHstyServiceImpl extends ServiceBase implements LogLessonActnHstyService {
    
    @Resource(name="logLessonActnHstyDAO")
    private LogLessonActnHstyDAO logLessonActnHstyDAO;

    /*****************************************************
     * 강의실 활동 로그 목록
     * @param LogLessonActnHstyVO
     * @return ProcessResultVO<LogLessonActnHstyVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LogLessonActnHstyVO> listLessonActnHsty(LogLessonActnHstyVO vo) throws Exception {
        return logLessonActnHstyDAO.listLessonActnHsty(vo);
    }
    
    /*****************************************************
     * 강의실 활동 로그 목록 페이징
     * @param LogLessonActnHstyVO
     * @return ProcessResultVO<LogLessonActnHstyVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<LogLessonActnHstyVO> listLessonActnHstyPaging(LogLessonActnHstyVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<LogLessonActnHstyVO> lessonActnHstyList = logLessonActnHstyDAO.listLessonActnHstyPaging(vo);
        
        if(lessonActnHstyList.size() > 0) {
            paginationInfo.setTotalRecordCount(lessonActnHstyList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<LogLessonActnHstyVO> resultVO = new ProcessResultVO<LogLessonActnHstyVO>();
        
        resultVO.setReturnList(lessonActnHstyList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }

    /*****************************************************
     * 강의실 활동 로그 등록
     * @param crsCreCd
     * @param userId
     * @param actnHstyCd
     * @param actnHstyCts
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void saveLessonActnHsty(HttpServletRequest request, String crsCreCd, String actnHstyCd, String actnHstyCts) throws Exception {
        String userId = SessionInfo.getUserId(request);
        String deviceTypeCd = SessionInfo.getDeviceType(request);
        String regIp = CommonUtil.getIpAddress(request);
        
        LogLessonActnHstyVO vo = new LogLessonActnHstyVO();
        vo.setActnHstySn(IdGenerator.getNewId("ACTN"));
        vo.setCrsCreCd(crsCreCd);
        vo.setUserId(userId);
        vo.setActnHstyCd(actnHstyCd);
        vo.setActnHstyCts(actnHstyCts);
        vo.setDeviceTypeCd(deviceTypeCd);
        vo.setRegIp(regIp);
        vo.setRgtrId(userId);
        
        try {
            if (!"".equals(StringUtil.nvl(crsCreCd)) && !"".equals(StringUtil.nvl(userId)) && !SessionInfo.isVirtualLogin(request)) {
                logLessonActnHstyDAO.insertLessonActnHsty(vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /*****************************************************
     * 강의실 활동 로그 등록 (학습창용)
     * @param crsCreCd
     * @param userId
     * @param actnHstyCd
     * @param actnHstyCts
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void saveLessonActnHstyForStudy(HttpServletRequest request, String crsCreCd, String actnHstyCd, String actnHstyCts) throws Exception {
        String userId = SessionInfo.getUserId(request);
        String deviceTypeCd = SessionInfo.getDeviceType(request);
        String regIp = CommonUtil.getIpAddress(request);
        
        LogLessonActnHstyVO vo = new LogLessonActnHstyVO();
        vo.setActnHstySn(IdGenerator.getNewId("ACTN"));
        vo.setCrsCreCd(crsCreCd);
        vo.setUserId(userId);
        vo.setActnHstyCd(actnHstyCd);
        vo.setActnHstyCts(actnHstyCts);
        vo.setDeviceTypeCd(deviceTypeCd);
        vo.setRegIp(regIp);
        vo.setRgtrId(userId);
        
        try {
            if (!"".equals(StringUtil.nvl(crsCreCd)) && !"".equals(StringUtil.nvl(userId)) && !SessionInfo.isVirtualLogin(request)) {
                logLessonActnHstyDAO.insertLessonActnHsty(vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
