package knou.lms.crs.term.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.crs.term.vo.TermVO;


@Controller
@RequestMapping(value= "/crs/termHome")
public class TermHomeController extends ControllerBase {
    /** MessageSource */
    @Resource(name = "messageSource")
    private MessageSource messageSource;

    @Resource(name = "termService")
    private TermService termService;

    private Logger logger = LoggerFactory.getLogger(getClass());
    
    @RequestMapping(value = "/selectListHomeTermStatus.do")
    @ResponseBody
    public List<TermVO> selectListHomeTermStatus(TermVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        /*
         * String userId = UserBroker.getUserId(request);
         * String userId = UserBroker.getUserId(request);
         * String userType = UserBroker.getUserType(request);
         */
        
        List<TermVO> resultListTerm = termService.selectListHomeTermStatus(vo);
        
        //Map<String, Object> returnMap = new HashMap<String, Object>();
        return resultListTerm;
    }

    /**
     * 
     * @Method Name : listTermLessonByHaksa
     * @Method 설명 : 학기주차일정 목록
     * @param  vo
     * @param model
     * @param request
     * @return ProcessResultVO<CrsTermLessonVO>
     * @throws Exception
     */
    @RequestMapping(value = "/listTermLessonByHaksa.do")
    @ResponseBody
    public ProcessResultVO<CrsTermLessonVO> listTermLessonByHaksa(TermVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ProcessResultVO<CrsTermLessonVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            List<CrsTermLessonVO> list = termService.listTermLesson(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1); 
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO; 
    }
    
    /**
     * 
     * @Method Name : selectTermByCrsCreCd
     * @Method 설명 : 강의실의 학기 조회
     * @param  vo
     * @param model
     * @param request
     * @return ProcessResultVO<TermVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectTermByCrsCreCd.do")
    @ResponseBody
    public ProcessResultVO<TermVO> selectTermByCrsCreCd(TermVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ProcessResultVO<TermVO> resultVO = new ProcessResultVO<>();
        
        try {
            TermVO termVO = termService.selectTermByCrsCreCd(vo);
            resultVO.setReturnVO(termVO);
            resultVO.setResult(1); 
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO; 
    }
}
