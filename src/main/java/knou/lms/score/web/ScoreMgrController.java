package knou.lms.score.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.score.service.ScoreService;
import knou.lms.score.vo.OprScoreAssistVO;
import knou.lms.score.vo.OprScoreProfVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Controller
@RequestMapping(value= {"/score/scoreMgr"})
public class ScoreMgrController extends ControllerBase {

    private static final Logger logger = LoggerFactory.getLogger(ScoreMgrController.class);
    
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="scoreService")
    private ScoreService scoreService;
    
    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    /***************************************************** 
     * 수업운영점수등록(교수) 폼
     * @param vo
     * @param model
     * @param request
     * @return "score/mgr/opr_score_prof_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/oprScoreProfWrite.do")
    public String oprScoreProfWriteForm(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        
        return "score/mgr/opr_score_prof_write";
    }
    
    /***************************************************** 
     * 수업운영점수등록(교수) 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<OprScoreProfVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listOprScoreProfWrite.do")
    @ResponseBody
    public ProcessResultVO<OprScoreProfVO> listOprScoreProfWrite(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<OprScoreProfVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            List<OprScoreProfVO> list = scoreService.listOprScoreProfWrite(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 수업운영점수등록(교수) 엑셀
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelOprScoreProfWrite.do")
    public String downExcelOprScoreProfWrite(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String haksaTermNm = request.getParameter("haksaTermNm");
        String uniNm = StringUtil.nvl(request.getParameter("uniNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));
        
        // 조회조건 
        String[] searchValues = {
              getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
            , getMessage("common.term") + " : " + haksaTermNm // 학기
            , getMessage("common.week") + " : " + vo.getLsnOdr() // 주차
            , getMessage("score.label.uni.cd") + " : " + uniNm // 대학구분
            , getMessage("common.dept_name") + " : " + deptNm // 학과
            , getMessage("socre.common.placeholder.oper.score") + " : " + StringUtil.nvl(vo.getSearchValue())
            , getMessage("score.label.hr.no") + " : " + StringUtil.nvl(vo.getUserId())
            , getMessage("common.professor") + " : " + StringUtil.nvl(vo.getUserNm())
            , getMessage("score.label.penalty.yn") + " : " + StringUtil.nvl(vo.getPenaltyYn())
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<OprScoreProfVO> list = scoreService.listOprScoreProfWrite(vo);
        
        String title = getMessage("score.label.prof.write"); // 수업운영 점수등록(교수)
      
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 수업운영점수(교수) 벌점원인 엑셀
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelOprScoreProfPanaltyReason.do")
    public String downExcelOprScoreProfPanaltyReason(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String haksaTermNm = request.getParameter("haksaTermNm");
        String uniNm = StringUtil.nvl(request.getParameter("uniNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));
        
        // 조회조건 
        String[] searchValues = {
              getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
            , getMessage("common.term") + " : " + haksaTermNm // 학기
            , getMessage("score.label.uni.cd") + " : " + uniNm // 대학구분
            , getMessage("common.dept_name") + " : " + deptNm // 학과
            , getMessage("socre.common.placeholder.oper.score") + " : " + StringUtil.nvl(vo.getSearchValue())
            , getMessage("score.label.hr.no") + " : " + StringUtil.nvl(vo.getUserId())
            , getMessage("common.professor") + " : " + StringUtil.nvl(vo.getUserNm())
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<EgovMap> list = scoreService.listOprScoreProfPanaltyReason(vo);
        
        String title = getMessage("score.label.prof.oper.score") + " " +getMessage("score.label.panalty.reason"); // 수업운영점수 벌점원인
      
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 수업운영점수(교수) 벌점원인 엑셀
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelOprScoreStatusByProf.do")
    public String downExcelOprScoreStatusByProf(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String haksaTermNm = request.getParameter("haksaTermNm");
        String uniNm = StringUtil.nvl(request.getParameter("uniNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));
        
        // 조회조건 
        String[] searchValues = {
              getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
            , getMessage("common.term") + " : " + haksaTermNm // 학기
            , getMessage("score.label.uni.cd") + " : " + uniNm // 대학구분
            , getMessage("common.dept_name") + " : " + deptNm // 학과
            , getMessage("socre.common.placeholder.oper.score") + " : " + StringUtil.nvl(vo.getSearchValue())
            , getMessage("score.label.hr.no") + " : " + StringUtil.nvl(vo.getUserId())
            , getMessage("common.professor") + " : " + StringUtil.nvl(vo.getUserNm())
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<EgovMap> list = scoreService.listOprScoreStatusByProf(vo);
        
        String title = getMessage("score.label.prof.oper.score") + " " +getMessage("score.label.status.by.prof"); // 교수별 통계
      
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 수업운영점수전체(교수) 폼
     * @param vo
     * @param model
     * @param request
     * @return "score/mgr/opr_score_prof_total"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/oprScoreProfTotal.do")
    public String oprScoreProfTotalForm(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        
        return "score/mgr/opr_score_prof_total";
    }
    
    /***************************************************** 
     * 수업운영점수전체(교수) 목록
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
        
        try {
            vo.setOrgId(orgId);
            
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
     * 수업운영점수전체(교수) 엑셀
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelOprScoreProfTotal.do")
    public String downExcelOprScoreProfTotal(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String haksaTermNm = request.getParameter("haksaTermNm");
        String uniNm = StringUtil.nvl(request.getParameter("uniNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));
        
        // 조회조건 
        String[] searchValues = {
              getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
            , getMessage("common.term") + " : " + haksaTermNm // 학기
            , getMessage("score.label.uni.cd") + " : " + uniNm // 대학구분
            , getMessage("common.dept_name") + " : " + deptNm // 학과
            , getMessage("socre.common.placeholder.oper.score") + " : " + StringUtil.nvl(vo.getSearchValue())
            , getMessage("score.label.hr.no") + " : " + StringUtil.nvl(vo.getUserId())
            , getMessage("common.professor") + " : " + StringUtil.nvl(vo.getUserNm())
            , getMessage("score.label.penalty.yn") + " : " + StringUtil.nvl(vo.getPenaltyYn())
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<EgovMap> list = scoreService.listOprScoreProfTotal(vo);
        
        String title = getMessage("score.label.prof.oper.total"); // 수업운영 점수전체(교수)
      
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 수업운영점수등록(교수)
     * @param list
     * @param request
     * @return ProcessResultVO<OprScoreProfVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/saveOprScoreProf.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<OprScoreProfVO> saveOprScoreProf(@RequestBody List<OprScoreProfVO> list, HttpServletRequest request) throws Exception {
        ProcessResultVO<OprScoreProfVO> resultVO = new ProcessResultVO<>();
        
        try {
            scoreService.updateOprScoreProf(request, list);
            resultVO.setResult(1);
        } catch (EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 수업운영점수삭제(교수)
     * @param list
     * @param request
     * @return ProcessResultVO<OprScoreProfVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/deleteOprScoreProf.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<OprScoreProfVO> deleteOprScoreProf(@RequestBody List<OprScoreProfVO> list, HttpServletRequest request) throws Exception {
        ProcessResultVO<OprScoreProfVO> resultVO = new ProcessResultVO<>();
        
        try {
            scoreService.deleteOprScoreProf(request, list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 교수 수업운영 평가기준 팝업
     * @param vo
     * @param model
     * @param request
     * @return "score/popup/opr_score_prof_criteria_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/oprScoreProfCriteriaPop.do")
    public String oprScoreProfCriteriaPop(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        return "score/popup/opr_score_prof_criteria_pop";
    }
    
    /***************************************************** 
     * 교수 수업운영 평가 등록 팝업
     * @param vo
     * @param model
     * @param request
     * @return "score/popup/opr_score_prof_write_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/oprScoreProfWritePop.do")
    public String oprScoreProfWritePop(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        OprScoreProfVO oprScoreProfVO;
        
        if(ValidationUtils.isEmpty(lessonScheduleId)) {
            // 총합
            oprScoreProfVO = scoreService.selectOprScoreProfTotal(vo);
        } else {
            // 주차별
            oprScoreProfVO = scoreService.selectOprScoreProf(vo);
        }
        
        if(oprScoreProfVO == null) {
            oprScoreProfVO = new OprScoreProfVO();
        }
        
        model.addAttribute("oprScoreProfVO", oprScoreProfVO);
        model.addAttribute("vo", vo);
        
        return "score/popup/opr_score_prof_write_pop";
    }
    
    /***************************************************** 
     * 수업운영점수등록(조교) 폼
     * @param vo
     * @param model
     * @param request
     * @return "score/mgr/opr_score_assist_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/oprScoreAssistWrite.do")
    public String oprScoreAssistWriteForm(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        
        return "score/mgr/opr_score_assist_write";
    }
    
    /***************************************************** 
     * 수업운영점수등록(조교) 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<OprScoreAssistVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listOprScoreAssistWrite.do")
    @ResponseBody
    public ProcessResultVO<OprScoreAssistVO> listOprScoreAssistWrite(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<OprScoreAssistVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            List<OprScoreAssistVO> list = scoreService.listOprScoreAssistWrite(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 수업운영점수등록(교수) 엑셀
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelOprScoreAssistWrite.do")
    public String downExcelOprScoreAssistWrite(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String haksaTermNm = request.getParameter("haksaTermNm");
        String lsnOdrNm = request.getParameter("lsnOdrNm");
        String uniNm = StringUtil.nvl(request.getParameter("uniNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));
        
        // 조회조건 
        String[] searchValues = {
              getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
            , getMessage("common.term") + " : " + haksaTermNm // 학기
            , getMessage("common.week") + " : " + lsnOdrNm // 주차
            , getMessage("score.label.uni.cd") + " : " + uniNm // 대학구분
            , getMessage("common.dept_name") + " : " + deptNm // 학과
            , getMessage("socre.common.placeholder.oper.score") + " : " + StringUtil.nvl(vo.getSearchValue())
            , getMessage("score.label.hr.no") + " : " + StringUtil.nvl(vo.getUserId())
            , getMessage("common.teaching.assistant") + " : " + StringUtil.nvl(vo.getUserNm())
            , getMessage("score.label.penalty.yn") + " : " + StringUtil.nvl(vo.getPenaltyYn())
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<OprScoreAssistVO> list = scoreService.listOprScoreAssistWrite(vo);
        
        String title = getMessage("score.label.assist.write"); // 수업운영 점수등록(조교)
      
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
        map.put("ext", ".xlsx(big)");
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 수업운영점수전체(조교) 폼
     * @param vo
     * @param model
     * @param request
     * @return "score/mgr/opr_score_assist_total"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/oprScoreAssistTotal.do")
    public String oprScoreAssistTotalForm(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        
        return "score/mgr/opr_score_assist_total";
    }
    
    /***************************************************** 
     * 수업운영점수전체(조교) 목록
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
        
        try {
            vo.setOrgId(orgId);
            
            List<EgovMap> list = scoreService.listOprScoreAssistTotal(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 수업운영점수전체(조교) 엑셀
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelOprScoreAssistTotal.do")
    public String downExcelOprScoreAssistTotal(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String haksaTermNm = request.getParameter("haksaTermNm");
        String uniNm = StringUtil.nvl(request.getParameter("uniNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));
        
        // 조회조건 
        String[] searchValues = {
              getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
            , getMessage("common.term") + " : " + haksaTermNm // 학기
            , getMessage("score.label.uni.cd") + " : " + uniNm // 대학구분
            , getMessage("common.dept_name") + " : " + deptNm // 학과
            , getMessage("socre.common.placeholder.oper.score") + " : " + StringUtil.nvl(vo.getSearchValue())
            , getMessage("score.label.hr.no") + " : " + StringUtil.nvl(vo.getUserId())
            , getMessage("common.teaching.assistant") + " : " + StringUtil.nvl(vo.getUserNm())
            , getMessage("score.label.penalty.yn") + " : " + StringUtil.nvl(vo.getPenaltyYn())
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<EgovMap> list = scoreService.listOprScoreAssistTotal(vo);
        
        String title = getMessage("score.label.assist.oper.total"); // 수업운영 점수전체(조교)
      
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 수업운영점수삭제(조교)
     * @param list
     * @param request
     * @return ProcessResultVO<OprScoreAssistVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/saveOprScoreAssist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<OprScoreAssistVO> saveOprScoreAssist(@RequestBody List<OprScoreAssistVO> list, HttpServletRequest request) throws Exception {
        ProcessResultVO<OprScoreAssistVO> resultVO = new ProcessResultVO<>();
        
        try {
            scoreService.updateOprScoreAssist(request, list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 수업운영점수등록(조교)
     * @param list
     * @param request
     * @return ProcessResultVO<OprScoreAssistVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/deleteOprScoreAssist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<OprScoreAssistVO> deleteOprScoreAssist(@RequestBody List<OprScoreAssistVO> list, HttpServletRequest request) throws Exception {
        ProcessResultVO<OprScoreAssistVO> resultVO = new ProcessResultVO<>();
        
        try {
            scoreService.deleteOprScoreAssist(request, list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 조교 수업운영 평가기준 팝업
     * @param vo
     * @param model
     * @param request
     * @return "score/popup/opr_score_assist_criteria_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/oprScoreAssistCriteriaPop.do")
    public String oprScoreAssistCriteriaPop(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        return "score/popup/opr_score_assist_criteria_pop";
    }
    
    /***************************************************** 
     * 조교 수업운영 평가 등록 팝업
     * @param vo
     * @param model
     * @param request
     * @return "score/popup/opr_score_assist_write_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/oprScoreAssistWritePop.do")
    public String oprScoreAssistWritePop(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        OprScoreAssistVO oprScoreAssistVO;
        if(ValidationUtils.isEmpty(lessonScheduleId)) {
            // 총합
            oprScoreAssistVO = scoreService.selectOprScoreAssistTotal(vo);
        } else {
            // 주차별
            oprScoreAssistVO = scoreService.selectOprScoreAssist(vo);
        }
        
        if(oprScoreAssistVO == null) {
            oprScoreAssistVO = new OprScoreAssistVO();
        }
        
        model.addAttribute("oprScoreAssistVO", oprScoreAssistVO);
        model.addAttribute("vo", vo);
        
        return "score/popup/opr_score_assist_write_pop";
    }
    
    
    /***************************************************** 
     * 조교 수업운영 평가 상세 보기
     * @param vo
     * @param model
     * @param request
     * @return "score/popup/opr_score_assist_detail_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/oprScoreAssistDetailPop.do")
    public String oprScoreAssistDetailPop(OprScoreAssistVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        OprScoreAssistVO oprScoreAssistVO;
        if(ValidationUtils.isEmpty(lessonScheduleId)) {
            // 총합
            oprScoreAssistVO = scoreService.selectOprScoreAssistTotal(vo);
        } else {
            // 주차별
            oprScoreAssistVO = scoreService.selectOprScoreAssist(vo);
        }
        
        if(oprScoreAssistVO == null) {
            oprScoreAssistVO = new OprScoreAssistVO();
        }
        
        model.addAttribute("oprScoreAssistVO", oprScoreAssistVO);
        model.addAttribute("vo", vo);
        
        return "score/popup/opr_score_assist_detail_pop";
    }
    
    
    /***************************************************** 
     * 교수 수업운영 평가 상세정보
     * @param vo
     * @param model
     * @param request
     * @return "score/popup/opr_score_prof_detail_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/oprScoreProfDetailPop.do")
    public String oprScoreProfDetailPop(OprScoreProfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        OprScoreProfVO oprScoreProfVO;
        
        if(ValidationUtils.isEmpty(lessonScheduleId)) {
            // 총합
            oprScoreProfVO = scoreService.selectOprScoreProfTotal(vo);
        } else {
            // 주차별
            oprScoreProfVO = scoreService.selectOprScoreProf(vo);
        }
        
        if(oprScoreProfVO == null) {
            oprScoreProfVO = new OprScoreProfVO();
        }
        
        model.addAttribute("oprScoreProfVO", oprScoreProfVO);
        model.addAttribute("vo", vo);
        
        return "score/popup/opr_score_prof_detail_pop";
    }
}
