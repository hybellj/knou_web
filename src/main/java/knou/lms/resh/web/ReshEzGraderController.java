package knou.lms.resh.web;

import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.SessionInfo;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.resh.service.ReshAnsrService;
import knou.lms.resh.service.ReshQstnService;
import knou.lms.resh.service.ReshService;
import knou.lms.resh.vo.ReshAnsrVO;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshVO;

@Controller
@RequestMapping(value="/resh/ezg")
public class ReshEzGraderController {
    
    @Resource(name="reshService")
    private ReshService reshService;
    
    @Resource(name="reshQstnService")
    private ReshQstnService reshQstnService;
    
    @Resource(name="reshAnsrService")
    private ReshAnsrService reshAnsrService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    /***************************************************** 
     * EZ-Grader 메인 폼
     * @param ReshVO 
     * @return "resh/ezgPop/ezg_main_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/ezgMainForm.do")
    public String getEzgMainView(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        vo = reshService.select(vo);
        request.setAttribute("vo", vo);
        
        return "resh/ezgPop/ezg_main_form";
    }
    
    /***************************************************** 
     * 설문 학습자 설문지 정보
     * @param ReshAnsrVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listReshAnswer.do")
    @ResponseBody
    public ProcessResultVO<ReshPageVO> listReshAnswer(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ReshPageVO> resultVO = new ProcessResultVO<>();
        
        try {
            ReshPageVO pageVo = new ReshPageVO();
            pageVo.setReschCd(vo.getReschCd());
            List<ReshPageVO> listReschPage = reshQstnService.listReshPage(pageVo);
            
            ReshAnsrVO reshAnsrVO = new ReshAnsrVO();
            reshAnsrVO.setUserId(vo.getUserId());
            reshAnsrVO.setReschCd(vo.getReschCd());
            pageVo.setAnswerList(reshAnsrService.listReshMyAnswer(reshAnsrVO));
            
            resultVO.setReturnList(listReschPage);
            resultVO.setReturnVO(pageVo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 설문 학습자 설문지 정보
     * @param ReshAnsrVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listReshUser.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listReshUser(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        try {
            List<EgovMap> userList = reshAnsrService.listReshJoinUserByEzGrader(vo);
            resultVO.setReturnList(userList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }

}
