package knou.lms.erp.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.erp.vo.AlarmMainVO;
import knou.lms.erp.vo.ErpEnrollmentVO;
import knou.lms.erp.vo.ErpLcdmsCntsVO;
import knou.lms.erp.vo.ErpLcdmsPageVO;
import knou.lms.erp.vo.ErpMessageMsgVO;
import knou.lms.erp.vo.ErpMessagePushVO;
import knou.lms.erp.vo.ErpScoreTestVO;

public interface ErpService {

    /**
     * 과목 수강 정보 조회
     * @param vo
     * @return ErpEnrollmentVO
     * @throws Exception
     */
    public ErpEnrollmentVO selectCourseEnrollment(ErpEnrollmentVO vo) throws Exception;
 
    /**
     * 사용자의 과목 수강 목록 조회
     * @param vo
     * @return List<ErpEnrollmentVO>
     * @throws Exception
     */
    public List<ErpEnrollmentVO> listUserEnrollment(ErpEnrollmentVO vo) throws Exception;
    
    /**
     * 쪽지 사용자 발송
     * @param request
     * @param vo
     * @param logDesc
     * @throws Exception
     */
    public void insertUserMessageMsg(HttpServletRequest request, ErpMessageMsgVO vo, String logDesc) throws Exception;
    
    /**
     * 쪽지 시스템 발송
     * @param request
     * @param vo
     * @param logDesc
     * @throws Exception
     */
    public void insertSysMessageMsg(HttpServletRequest request, ErpMessageMsgVO vo, String logDesc) throws Exception;
    
    /**
     * PUSH 시스템 발송
     * @param request
     * @param vo
     * @param logDesc
     * @throws Exception
     */
    public void insertSysMessagePush(HttpServletRequest request, ErpMessagePushVO vo, String logDesc) throws Exception;
    
    /**
     * 콘텐츠 정보 조회
     * @param ErpLcdmsPageVO
     * @throws Exception
     */
    public ErpLcdmsPageVO selectContentsInfo(ErpLcdmsPageVO vo) throws Exception;
    
    /**
     * 미리보기 콘텐츠 정보 조회
     * @param ErpLcdmsPageVO
     * @throws Exception
     */
    public ErpLcdmsPageVO selectContentsPreviewInfo(ErpLcdmsPageVO vo) throws Exception;
    
    /**
     * SMS 발송
     * @param List<ErpMessageSmsVO>
     * @throws Exception
     */
    //public void insertMessageSms(List<ErpMessageSmsVO> list) throws Exception;
    
    /**
     * 테스트 성적 저장
     * @param List<ErpScoreTestVO>
     * @throws Exception
     */
    public void insertTestScore(ErpScoreTestVO vo, List<ErpScoreTestVO> list) throws Exception;
    
    /**
     * ERP 성적 메인 테이블로 이관하는 프로시저
     * @param Map<String, Object>
     * @throws Exception
     */
    public void callSpScorLmsMrksGet(Map<String, Object> map) throws Exception;
    
    /**
     * LCDMS 년도 목록 조회
     * @return List<ErpLcdmsCntsVO>
     * @throws Exception
     */
    public List<ErpLcdmsCntsVO> listLcdmsYear() throws Exception;
    
    /**
     * LCDMS 콘텐츠 조회
     * @param ErpLcdmsCntsVO
     * @return ErpLcdmsCntsVO
     * @throws Exception
     */
    public ErpLcdmsCntsVO selectLcdmsCnts(ErpLcdmsCntsVO vo) throws Exception;
    
    /**
     * LCDMS 콘텐츠 목록 조회
     * @param ErpLcdmsCntsVO
     * @return List<ErpLcdmsCntsVO>
     * @throws Exception
     */
    public List<ErpLcdmsCntsVO> listLcdmsCnts(ErpLcdmsCntsVO vo) throws Exception;
    
    /**
     * LCDMS 콘텐츠 페이지 목록 조회
     * @param ErpLcdmsPageVO
     * @return List<ErpLcdmsPageVO>
     * @throws Exception
     */
    public List<ErpLcdmsPageVO> listLcdmsPage(ErpLcdmsPageVO vo) throws Exception;
    
    /**
     * Erp SMS 보내기
     * @param request
     * @param vo
     * @throws Exception
     */
    public ProcessResultVO<AlarmMainVO> directSendMsg(HttpServletRequest request, AlarmMainVO vo) throws Exception;
}