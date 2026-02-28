package knou.lms.lesson.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.CommonUtil;
import knou.framework.util.RedisUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.service.LessonService;
import knou.lms.lesson.service.LessonStudyService;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyRecordVO;
import knou.lms.log.userconn.service.LogUserConnService;

@Controller
@RequestMapping(value= {"/lesson/stdy"})
public class LessonStdyController extends ControllerBase {
    //private static final Logger LOGGER = LoggerFactory.getLogger(LessonStdyController.class);
    
    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;
    
    @Resource(name="lessonService")
    private LessonService lessonService;
    
    @Resource(name="lessonStudyService")
    private LessonStudyService lessonStudyService;
    
    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    /**
     * 학습기록 저장
     * @param vo
     * @param map
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/saveStdyRecord.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> saveStdyRecord(LessonStudyRecordVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(vo.getUserId());
        String ssUserId = StringUtil.nvl(SessionInfo.getUserId(request));
        String multiconState = StringUtil.nvl((String)request.getSession().getAttribute("MULTICON_STATE"));
        String logoutGbn = StringUtil.nvl((String)request.getSession().getAttribute("LOGOUT_GBN"));
        
        if ("".equals(userId) || ("".equals(ssUserId) && !"LOGOUT".equals(multiconState))) {
            resultVO.setResult(-1);
            return resultVO;
        }
        else if ("".equals(ssUserId) && "LOGOUT".equals(multiconState)) {
            request.getSession().setAttribute("MULTICON_STATE","");
            resultVO.setResult(-2);
            if (!"".equals(logoutGbn)) {
                resultVO.setResult(-3);    
            }
            return resultVO;
        }
        
        // 학습창 중복 체크 (Redis 사용, 다른 브라우저에서 오픈한 경우)
        if (CommConst.REDIS_USE && "Y".equals(CommConst.MULTISTUDY_CHECK_YN)) {
        	String ssStudyWindowId = (String)SessionUtil.getSessionValue(request, "STUDY_WINDOW_ID");
        	String studyWindowId = StringUtil.nvl(RedisUtil.getValue("StudyWindow:"+userId));
        	
        	if (!"".equals(studyWindowId) && !studyWindowId.equals(ssStudyWindowId)) {
        		resultVO.setResult(-5);
                return resultVO;
        	}
        }
        
        try {
            String browser = CommonUtil.getBrowser(request);
            String playSpeed = vo.getPlaySpeed();
            
            if (vo.getSaveType() != null) {
                browser += ", "+vo.getSaveType();
            }
            if (playSpeed != null) {
            	if (playSpeed.length() > 4) {
            		playSpeed = playSpeed.substring(0, 4);
            	}
                browser += ", "+playSpeed+"X";
            }
            
            browser += " (";
            if (!"".equals(StringUtil.nvl(vo.getPageCnt())) && !"-1".equals(vo.getPageCnt())) {
                browser += "page:"+vo.getPageCnt()+", ";
            }
            
            browser += "start "+vo.getPlayStartDttm()+")";
            
            vo.setUserId(userId);
            vo.setBrowserCd(browser);
            vo.setDeviceCd(CommonUtil.getClientOS(request));
            vo.setUserIp(CommonUtil.getIpAddress(request));
            vo.setAgent(request.getHeader("USER-AGENT"));
            
            String skey = "RECD_"+vo.getLessonScheduleId()+"_"+vo.getStudyCnt();
            
            @SuppressWarnings("unchecked")
            HashMap<String, Object> recordMap = (HashMap<String, Object>)SessionUtil.getSessionValue(request, skey);
            
            if (recordMap != null) {
                int studySumTm = (int)recordMap.get("sumTime");
                int studyTotalTm = (int)recordMap.get("totalTime");
                int studyAfterTm = (int)recordMap.get("afterTime");
                int studySessionTm = (int)recordMap.get("sessionTime");
                long checkTime = (long)recordMap.get("checkTime");
                
                if (vo.getStudySumTm() < studySumTm) vo.setStudySumTm(studySumTm) ;
                if (vo.getStudyTotalTm() < studyTotalTm) vo.setStudyTotalTm(studyTotalTm);
                if (vo.getStudyAfterTm() < studyAfterTm) vo.setStudyAfterTm(studyAfterTm);
                if (vo.getStudySessionTm() < studySessionTm) {
                    long curTime = (new Date().getTime() / 1000);
                    if ((curTime - checkTime) < 60) {
                        vo.setStudySessionTm(studySessionTm + (int)(curTime - checkTime));
                    }
                    else {
                        vo.setStudySessionTm(studySessionTm + 60);
                    }
                    recordMap.put("sessionTime", vo.getStudySessionTm());
                }
                
                recordMap.put("sessionTime", vo.getStudySessionTm());
                recordMap.put("checkTime", (new Date().getTime() / 1000));
            }
            else {
                recordMap = new HashMap<>();
                recordMap.put("sumTime", vo.getStudySumTm());
                recordMap.put("totalTime", vo.getStudyTotalTm());
                recordMap.put("afterTime", vo.getStudyAfterTm());
                recordMap.put("sessionTime", vo.getStudySessionTm());
                recordMap.put("checkTime", (new Date().getTime() / 1000));
                SessionUtil.setSessionValue(request, skey, recordMap);
            }
            
            // 학습기록 저장
            String status = lessonStudyService.saveLessonStudyRecord(vo);
            if ("COMPLETE".equals(status)) {
                resultVO.setResult(100);
            }
            else {
                resultVO.setResult(1);
            }
        } catch(Exception e) {
            System.out.println("STUDY SAVE ERROR :: "+e.toString());
            e.printStackTrace();
            resultVO.setResult(-4);
            resultVO.setMessage("에러가 발생했습니다.");
        }
        
        return resultVO;
    }
    
    /**
     * 학습주차 체크
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/checkStdySchedule.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> checkStdySchedule(LessonStudyRecordVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            EgovMap egovMap = new EgovMap();
            
            LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
            lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
            lessonScheduleVO.setLessonScheduleId(vo.getLessonScheduleId());
            lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
            
            if(lessonScheduleVO != null) {
                // 학습인정 최대일 체크
                String ltDetmToDtMax = lessonScheduleVO.getLtDetmToDtMax();
                String today = new SimpleDateFormat("yyyyMMdd").format(new Date(System.currentTimeMillis()));
                
                if (today.compareTo(ltDetmToDtMax) > 0) {
                    egovMap.put("ltDetmToDtMaxOverYn", "Y");
                } else {
                    egovMap.put("ltDetmToDtMaxOverYn", "N");
                }
            }
            
            resultVO.setReturnVO(egovMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생했습니다.");
        }
        
        return resultVO;
    }
}
