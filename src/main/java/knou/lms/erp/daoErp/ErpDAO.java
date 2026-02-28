package knou.lms.erp.daoErp;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.api.vo.CntsPreviewVO;
import knou.lms.api.vo.PagePreviewVO;
import knou.lms.erp.vo.AlarmSmsLogVO;
import knou.lms.erp.vo.AlarmSmsVO;
import knou.lms.erp.vo.ErpBsns110VO;
import knou.lms.erp.vo.ErpBsns111VO;
import knou.lms.erp.vo.ErpEnrollmentVO;
import knou.lms.erp.vo.ErpJobScheduleVO;
import knou.lms.erp.vo.ErpLcdmsCntsVO;
import knou.lms.erp.vo.ErpLcdmsPageVO;
import knou.lms.erp.vo.ErpMessageMsgVO;
import knou.lms.erp.vo.ErpMessagePushVO;
import knou.lms.erp.vo.ErpMessageSmsLogVO;
import knou.lms.erp.vo.ErpMessageSmsVO;
import knou.lms.erp.vo.ErpScoreTestVO;

/**
 * ERP DB 조회 DAO
 * 
 * @author Mediopia
 */

@Mapper("erpDAO")
public interface ErpDAO {

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
     * 통합메시지 쪽지 목록 저장
     * @param messageList
     * @throws Exception
     */
    public void insertMessageMsgList(List<ErpMessageMsgVO> messageList) throws Exception;
    
    /**
     * 통합메시지 쪽지 로그 저장
     * @param ErpMessageMsgVO
     * @throws Exception
     */
    public void insertMessageMsgLog(ErpMessageMsgVO vo) throws Exception;
    
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
     * 과목 수강 정보 전체 조회
     * @param vo
     * @return List<ErpEnrollmentVO>
     * @throws Exception
     */
    public List<ErpEnrollmentVO> selectCourseEnrollmentAll(ErpEnrollmentVO vo) throws Exception;
    
    /**
     * SMS 저장
     * @param ErpMessageSmsVO
     * @throws Exception
     */
    public void insertMessageSms(ErpMessageSmsVO vo) throws Exception;
    
    /**
     * SMS 저장
     * @param ErpMessageSmsVO
     * @throws Exception
     */
    public void insertMessageSmsTwo(ErpMessageSmsVO vo) throws Exception;
    
    /**
     * SMS LOG 저장
     * @param ErpMessageSmsLogVO
     * @throws Exception
     */
    public void insertMessageSmsLog(ErpMessageSmsLogVO vo) throws Exception;
    
    /**
     * 학사 연계 SMS, PUSH 보내는 정보 저장
     * @param ErpMessageSmsVO
     * @throws Exception
     */
    public void insertBsns110(ErpBsns110VO vo) throws Exception;
    
    /**
     * 학사 연계 SMS, PUSH 받는 정보 저장
     * @param ErpMessageSmsLogVO
     * @throws Exception
     */
    public void insertBsns111(ErpBsns111VO vo) throws Exception;
    
    /**
     * 학사 연계 SMS, PUSH 받는 정보 목록 저장
     * @param ErpMessageSmsLogVO
     * @throws Exception
     */
    public void insertBsns111List(List<ErpBsns111VO> messageList) throws Exception;
    
    /*****************************************************
     * LCDMS 콘텐츠 미리보기 조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public CntsPreviewVO selectLcdmsCntsPreview(CntsPreviewVO vo) throws Exception;
    
    /*****************************************************
     * LCDMS 콘텐츠 페이지 미리보기 목록 조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public List<PagePreviewVO> listLcdmsPagePreview(PagePreviewVO vo) throws Exception;
    
    /**
     * PUSH 저장
     * @param messageList
     * @throws Exception
     */
    public void insertMessagePushList(List<ErpMessagePushVO> messageList) throws Exception;
    
    /**
     * PUSH 로그 저장
     * @param vo
     * @throws Exception
     */
    public void insertMessagePushLog(ErpMessagePushVO vo) throws Exception;

    /**
     * 테스트 성적 저장
     * @param List<ErpScoreTestVO>
     * @throws Exception
     */
    public void insertTestScore(List<ErpScoreTestVO> list) throws Exception;
    
    /**
     * 테스트 성적 삭제
     * @param ErpScoreTestVO
     * @throws Exception
     */
    public void deleteTestScore(ErpScoreTestVO vo) throws Exception;
    
    /**
     * ERP 성적 메인 테이블로 이관하는 프로시저
     * @param Map<String, Object>
     * @throws Exception
     */
    public void callSpScorLmsMrksGet(Map<String, Object> map) throws Exception;
    
    /**
     * ERP 업무일정 목록 조회
     * @param ErpJobScheduleVO
     * @return List<ErpJobScheduleVO>
     * @throws Exception
     */
    public List<ErpJobScheduleVO> listJobSchedule(ErpJobScheduleVO vo) throws Exception;
    
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
     * SMS 목록 저장
     * @param List<ErpScoreTestVO>
     * @throws Exception
     */
    public void insertSmsList(List<AlarmSmsVO> list) throws Exception;
    
    /**
     * SMS 발송 로그 저장
     * @param vo
     * @throws Exception
     */
    public void insertAlarmSmsLog(AlarmSmsLogVO vo) throws Exception;
    
    /**
     * ERP SMS, PUSH 보내는 정보 저장
     * @param ErpBsns110VO
     * @throws Exception
     */
    public void insertAcademicSmsPushSend(ErpBsns110VO vo) throws Exception;
    
    /**
     * ERP SMS, PUSH 받는 정보 저장
     * @param List<ErpBsns111VO>
     * @throws Exception
     */
    public void insertAcademicSmsPushReceive(List<ErpBsns111VO> list) throws Exception;
}
