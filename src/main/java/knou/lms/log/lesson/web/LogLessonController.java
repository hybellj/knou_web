package knou.lms.log.lesson.web;

import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.DefaultVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.lesson.vo.LogLessonActnHstyVO;

@Controller
@RequestMapping(value="/logLesson")
public class LogLessonController extends ControllerBase {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(LogLessonController.class);
    
    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    /***************************************************** 
     * TODO 강의실 활동 로그 등록 
     * @param LogLessonActnHstyVO
     * @return ProcessResultVO<LogLessonActnHstyVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/saveLessonActnHsty.do")
    @ResponseBody
    public ProcessResultVO<LogLessonActnHstyVO> saveLessonActnHsty(LogLessonActnHstyVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd(), SessionInfo.getCurCrsCreCd(request));
        ProcessResultVO<LogLessonActnHstyVO> resultVO = new ProcessResultVO<LogLessonActnHstyVO>();
        
        try {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, StringUtil.nvl(vo.getActnHstyCd()), StringUtil.nvl(vo.getActnHstyCts()));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }

}
