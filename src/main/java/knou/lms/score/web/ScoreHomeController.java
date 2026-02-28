package knou.lms.score.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.score.service.ScoreService;
import knou.lms.score.vo.OprScoreAssistVO;
import knou.lms.score.vo.OprScoreProfVO;

@Controller
@RequestMapping(value= {"/score/scoreHome"})
public class ScoreHomeController extends ControllerBase {
    private static final Logger logger = LoggerFactory.getLogger(ScoreHomeController.class);

    @Resource(name="scoreService")
    private ScoreService scoreService;
    
    @Resource(name = "termService")
    private TermService termService;
    
    /***************************************************** 
     * 교수 수업운영 점수현황 팝업
     * @param vo
     * @param model
     * @param request
     * @return "score/popup/opr_score_prof_status_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/oprScoreProfStatusPop.do")
    public String oprScoreProfStatusPop(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String userTypeDetail = StringUtil.nvl(SessionInfo.getUserTypeDetail(request));
        String termCd = vo.getTermCd();
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setTermCd(termCd);
        
        List<CrsTermLessonVO> listTermLesson = termService.listTermLesson(termVO);
        
        model.addAttribute("vo", vo);
        model.addAttribute("listTermLesson", listTermLesson);
        model.addAttribute("userTypeDetail", userTypeDetail);
        
        return "score/popup/opr_score_prof_status_pop";
    }
    
    /***************************************************** 
     * 교수 수업운영 점수현황 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listOprScoreProfTotal.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listOprScoreProfTotal(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            
            List<EgovMap> list = scoreService.listOprScoreProfTotal(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 조교 수업운영 점수현황 팝업
     * @param vo
     * @param model
     * @param request
     * @return "score/popup/opr_score_assist_status_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/oprScoreAssistStatusPop.do")
    public String oprScoreAssistStatusPop(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String termCd = vo.getTermCd();
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setTermCd(termCd);
        
        List<CrsTermLessonVO> listTermLesson = termService.listTermLesson(termVO);
        
        model.addAttribute("vo", vo);
        model.addAttribute("listTermLesson", listTermLesson);
        
        return "score/popup/opr_score_assist_status_pop";
    }
    
    /***************************************************** 
     * 조교 수업운영 점수현황 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listOprScoreAssistTotal.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listOprScoreAssistTotal(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            
            List<EgovMap> list = scoreService.listOprScoreAssistTotal(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
}
