package knou.lms.crs.term.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.CrsExcelUtilPoi;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.URLBuilder;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.org.service.OrgCodeMemService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;


@Controller
@RequestMapping(value="/crs/termMgr")
public class TermMgrController extends ControllerBase {

    /** 학기 정보 service */
    @Autowired @Qualifier("termService")
    private TermService termService;

    @Autowired @Qualifier("orgCodeService")
    private OrgCodeService orgCodeService;

    /** 기관 시스템 코드 service */
    @Autowired @Qualifier("orgCodeMemService")
    private OrgCodeMemService orgCodeMemService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Autowired @Qualifier("sysJobSchService")
    private SysJobSchService sysJobSchService;
    
    @Autowired
    private SemesterService semesterService;

    /**
     * @Method Name : main
     * @Method 설명 : 개설과목관리 > 학기관리 목록
     * @param
     * @param model
     * @return  "/crs/term/crs_term_form.jsp"
     * @throws Exception
     */
    @RequestMapping(value = "/Form/crsTermForm.do")
    public String crsTermForm(TermVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        List<OrgCodeVO> crsOperUniList = orgCodeService.getOrgCodeList("TERM_TYPE");
        request.setAttribute("crsOperUniList", crsOperUniList);

        List<OrgCodeVO> termStatusList = orgCodeService.getOrgCodeList("TERM_STATUS");
        request.setAttribute("termStatusList", termStatusList);

        request.setAttribute("termVo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/term/crs_term_form";
    }

    /**
     * @Method Name : crsTermList
     * @Method 설명 : 개설과목관리 > 학기관리 목록
     * @param
     * @param commandMap
     * @param model
     * @return  "/crs/term/crs_term_form.jsp"
     * @throws Exception
     */
    @RequestMapping(value = "/crsTermList.do")
    public String crsTermList(TermVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        if(vo.getSearchValue().equals("")) {
            vo.setSearchValue(null);
        }

        // 학기 운영 상태
        List<OrgCodeVO> termStatustList = orgCodeService.getOrgCodeList("TERM_STATUS");
        request.setAttribute("termStatustList",termStatustList);

        ProcessResultListVO<TermVO> crsTermList = (ProcessResultListVO<TermVO>) termService.listPageing(vo);

        TermVO termVO = new TermVO();
        for(int i=0; i<crsTermList.getReturnList().size(); i++) {

            termVO = crsTermList.getReturnList().get(i);
            termVO.setSvcStartDttm(DateTimeUtil.getDateType(8, termVO.getSvcStartDttm()));
            termVO.setSvcEndDttm(DateTimeUtil.getDateType(8, termVO.getSvcEndDttm()));
            /*
            termVO.setEnrlAplcStartDttm(DateTimeUtil.getDateType(1, termVO.getEnrlAplcStartDttm()));
            termVO.setEnrlAplcEndDttm(DateTimeUtil.getDateType(1, termVO.getEnrlAplcEndDttm()));
            termVO.setEnrlStartDttm(DateTimeUtil.getDateType(1, termVO.getEnrlStartDttm()));
            termVO.setEnrlEndDttm(DateTimeUtil.getDateType(1, termVO.getEnrlEndDttm()));
            termVO.setScoreEvalStartDttm(DateTimeUtil.getDateType(1, termVO.getScoreEvalStartDttm()));
            termVO.setScoreEvalEndDttm(DateTimeUtil.getDateType(1, termVO.getScoreEvalEndDttm()));
            termVO.setScoreOpenStartDttm(DateTimeUtil.getDateType(1, termVO.getScoreOpenStartDttm()));
            termVO.setScoreOpenEndDttm(DateTimeUtil.getDateType(1, termVO.getScoreOpenEndDttm()));
            */
        }
        request.setAttribute("crsTermList", crsTermList.getReturnList());
        request.setAttribute("pageInfo", crsTermList.getPageInfo());

        return "crs/term/crs_term_list";
    }

    /**
     * @Method Name : crsTermInfoWrite
     * @Method 설명 : 개설과목관리 > 학기관리  > 학기정보등록
     * @param
     * @param commandMap
     * @param model
     * @return  "/crs/term/crs_term_info_write.jsp"
     * @throws Exception
     */
    @RequestMapping(value = "/Form/crsTermInfoWrite.do")
    public String crsTermInfoWrite(TermVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        List<Integer> yearList = DateTimeUtil.getYearList(5, "mix");
        model.addAttribute("yearList", yearList);

        // 학기 구분
        List<OrgCodeVO> termTypeList = orgCodeService.getOrgCodeList("TERM_TYPE");
        request.setAttribute("termTypeList", termTypeList);

        // 학기 유형
        List<OrgCodeVO> haksaTermList = orgCodeService.getOrgCodeList("HAKSA_TERM");
        request.setAttribute("haksaTermList", haksaTermList);

        // 학기 운영 상태
        List<OrgCodeVO> termStatustList = orgCodeService.getOrgCodeList("TERM_STATUS");
        request.setAttribute("termStatustList", termStatustList);

        ProcessResultVO<TermVO> resultVO = new ProcessResultVO<TermVO>();
        if(StringUtil.nvl(vo.getTermCd()) != "") {
            resultVO= termService.view(vo);
            TermVO termVO = (TermVO)resultVO.getReturnVO();

            // 외부기관인 경우
            if (!SessionInfo.isKnou(request) && resultVO != null) {
	        	SysJobSchVO jobSchVO = new SysJobSchVO();
	        	jobSchVO.setOrgId(orgId);
	        	jobSchVO.setHaksaYear(termVO.getHaksaYear());
	        	jobSchVO.setHaksaTerm(termVO.getHaksaTerm());

	        	List<SysJobSchVO> jobList = sysJobSchService.list(jobSchVO);
	        	for (SysJobSchVO schVO : jobList) {
	        		// 성적입력기간 - 00210206
	        		if ("00210206".equals(schVO.getCalendarCtgr())) {
	        			termVO.setScoInputStartDttm(schVO.getSysjobSchdlSymd());
	        			termVO.setScoInputEndDttm(schVO.getSysjobSchdlEymd());
	        		}
	        		// 성적조회기간 - 00210210
	        		else if ("00210210".equals(schVO.getCalendarCtgr())) {
	        			termVO.setScoViewStartDttm(schVO.getSysjobSchdlSymd());
	        			termVO.setScoViewEndDttm(schVO.getSysjobSchdlEymd());
	        		}
	        		// 성적재확인신청기간 - 00210202
	        		else if ("00210202".equals(schVO.getCalendarCtgr())) {
	        			termVO.setScoObjtStartDttm(schVO.getSysjobSchdlSymd());
	        			termVO.setScoObjtEndDttm(schVO.getSysjobSchdlEymd());
	        		}
	        		// 성적재확인신청정정기간 - 00210203
	        		else if ("00210203".equals(schVO.getCalendarCtgr())) {
	        			termVO.setScoRechkStartDttm(schVO.getSysjobSchdlSymd());
	        			termVO.setScoRechkEndDttm(schVO.getSysjobSchdlEymd());
	        		}
	        	}
            }

            request.setAttribute("termVo", termVO);
        } else {
        	vo.setHaksaYear(DateTimeUtil.getYear());
            request.setAttribute("termVo", vo);
        }

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/term/crs_term_info_write";
    }

    /**
     *
     * @Method Name : crsTermCheck
     * @Method 설명 : 개설과목관리 > 학기관리  > 학기 만들때 중복 체크
     * @param  vo
     * @param model
     * @param request
     * @return  JsonUtil.responseJson(response, returnVo)
     * @throws Exception
     */
    @RequestMapping(value = "/crsTermCheck.do")
    public String crsTermCheck(TermVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        TermVO returnVo = new TermVO();
        try {
            returnVo = termService.crsTermCheck(vo);
            returnVo.setResult(1);
        } catch(Exception e) {
            e.getMessage();
            returnVo.setResult(-1);
        }
        return JsonUtil.responseJson(response, returnVo);
    }

    /**
     *
     * @Method Name : crsTermCheck
     * @Method 설명 : 개설과목관리 > 학기관리  > 학기 만들때 중복 체크
     * @param  vo
     * @param model
     * @param request
     * @return  JsonUtil.responseJson(response, returnVo)
     * @throws Exception
     */
    @RequestMapping(value = "/crsCurTermYnCheck.do")
    public String crsCurTermYnCheck(TermVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        TermVO returnVo = new TermVO();
        try {
            returnVo = termService.crsCurTermYnCheck(vo);
            returnVo.setResult(1);
        } catch(Exception e) {
            e.getMessage();
            returnVo.setResult(-1);
        }
        return JsonUtil.responseJson(response, returnVo);
    }

    /**
     * @Method Name : main
     * @Method 설명 : 개설과목관리 > 학기관리  > 학기정보등록 > 임시저장
     * @param
     * @param commandMap
     * @param model
     * @return  "/crs/term/crs_term_info_write.jsp"
     * @throws Exception
     */
    @RequestMapping(value = "/addTerm.do")
    public String addTerm(TermVO vo, ModelMap model, HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {
        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        String returnString = "";

        TermVO resultVO = new TermVO();
        resultVO = vo;
        ProcessResultVO<TermVO> defaultVO = termService.view(resultVO);

        Date date = null;

        if(vo.getSvcStartDttm() != null && !vo.getSvcStartDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm", vo.getSvcStartDttm());
            vo.setSvcStartDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
        }
        if(vo.getSvcEndDttm() != null && !vo.getSvcEndDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getSvcEndDttm());
            vo.setSvcEndDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
        }

        /*
        if(vo.getSvcStartDttm() != null && !vo.getSvcStartDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getSvcStartDttm());
            vo.setSvcStartDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getSvcEndDttm() != null && !vo.getSvcEndDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getSvcEndDttm());
            vo.setSvcEndDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getEnrlAplcStartDttm() != null && !vo.getEnrlAplcStartDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlAplcStartDttm());
            vo.setEnrlAplcStartDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getEnrlAplcEndDttm() != null && !vo.getEnrlAplcEndDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlAplcEndDttm());
            vo.setEnrlAplcEndDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getEnrlModStartDttm() != null && !vo.getEnrlModStartDttm().equals("") ) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlModStartDttm());
            vo.setEnrlModStartDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getEnrlModEndDttm() != null && !vo.getEnrlModEndDttm().equals("")  ) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlModEndDttm());
            vo.setEnrlModEndDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getEnrlStartDttm() != null && !vo.getEnrlStartDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlStartDttm());
            vo.setEnrlStartDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getEnrlEndDttm() != null && !vo.getEnrlEndDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlEndDttm());
            vo.setEnrlEndDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getScoreEvalStartDttm() != null && !vo.getScoreEvalStartDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getScoreEvalStartDttm());
            vo.setScoreEvalStartDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(vo.getScoreEvalEndDttm() != null && !vo.getScoreEvalEndDttm().equals("")) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getScoreEvalEndDttm());
            vo.setScoreEvalEndDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(!"".equals(StringUtil.nvl(vo.getScoreOpenStartDttm()))) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getScoreOpenStartDttm());
            vo.setScoreOpenStartDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        if(!"".equals(StringUtil.nvl(vo.getScoreOpenEndDttm()))) {
            date = DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getScoreOpenEndDttm());
            vo.setScoreOpenEndDttm(DateTimeUtil.dateToString(date, "yyyyMMdd"));
        }
        */
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);


        // 외부기관인 경우 일정정보
        if (!SessionInfo.isKnou(request)) {
	        if(vo.getScoInputStartDttm() != null && !vo.getScoInputStartDttm().equals("")) {
	            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getScoInputStartDttm());
	            vo.setScoInputStartDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
	        }
	        if(vo.getScoInputEndDttm() != null && !vo.getScoInputEndDttm().equals("")) {
	            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getScoInputEndDttm());
	            vo.setScoInputEndDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
	        }
	        if(vo.getScoViewStartDttm() != null && !vo.getScoViewStartDttm().equals("")) {
	            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getScoViewStartDttm());
	            vo.setScoViewStartDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
	        }
	        if(vo.getScoViewEndDttm() != null && !vo.getScoViewEndDttm().equals("")) {
	            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getScoViewEndDttm());
	            vo.setScoViewEndDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
	        }
	        if(vo.getScoObjtStartDttm() != null && !vo.getScoObjtStartDttm().equals("")) {
	            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getScoObjtStartDttm());
	            vo.setScoObjtStartDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
	        }
	        if(vo.getScoObjtEndDttm() != null && !vo.getScoObjtEndDttm().equals("")) {
	            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getScoObjtEndDttm());
	            vo.setScoObjtEndDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
	        }
	        if(vo.getScoRechkStartDttm() != null && !vo.getScoRechkStartDttm().equals("")) {
	            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getScoRechkStartDttm());
	            vo.setScoRechkStartDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
	        }
	        if(vo.getScoRechkEndDttm() != null && !vo.getScoRechkEndDttm().equals("")) {
	            date = DateTimeUtil.stringToDate("yyyyy-MM-dd HH:mm", vo.getScoRechkEndDttm());
	            vo.setScoRechkEndDttm(DateTimeUtil.dateToString(date, "yyyyMMddHHmmss"));
	        }
        }

        try {
            if(defaultVO.getReturnVO() != null ) {
                // termService.update(vo);
                termService.updateTerm(vo);

            } else {
            	String termOrg = StringUtil.nvl(vo.getOrgId(), orgId);
            	if ("ORG0000001".equals(termOrg)) { // 한사대인 경우
            		vo.setTermCd("TERM_"+vo.getHaksaYear()+vo.getHaksaTerm());
            	}
            	else { // 한사대가 아닌경우
            		vo.setTermCd(termOrg+"_"+vo.getHaksaYear()+vo.getHaksaTerm());
            	}
                termService.add(vo);
            }

        } catch(Exception e) {
            e.printStackTrace();
            // crs.pop.regist.course.fail=학기 등록 실패하였습니다. 다시 시도하시기 바랍니다
            setAlertMessage(getMessage("crs.pop.regist.course.fail"));
            returnString =  "redirect:"+new URLBuilder("crs","/termMgr/Form/crsTermInfoWrite.do", request).toString();
        }

        if(vo.getGubun().equals("next")) {
            // 다음
            returnString = "redirect:" + new URLBuilder("crs","/termMgr/Form/crsTermLessonForm.do", request).addParameter("termCd", vo.getTermCd()).toString();
        } else {
            // 임시저장
            returnString = "redirect:" + new URLBuilder("crs","/termMgr/Form/crsTermInfoWrite.do", request).addParameter("termCd", vo.getTermCd()).toString();
        }
        return returnString;
    }

    @RequestMapping(value = "/editCurTermYn.do")
    public String editCurTermYn(TermVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        ProcessResultVO<TermVO> TermVO = new ProcessResultVO<TermVO>();

        try {
            termService.editCurTermYn(vo);
            TermVO.setResult(1);
        } catch(Exception e) {
            TermVO.setResult(-1);
        }
        return JsonUtil.responseJson(response, TermVO);
    }

    @RequestMapping(value = "/notEditCurTermYn.do")
    public String notEditCurTermYn(TermVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        ProcessResultVO<TermVO> TermVO = new ProcessResultVO<TermVO>();

        try {
            termService.notEditCurTermYn(vo);
            TermVO.setResult(1);
        } catch(Exception e) {
            TermVO.setResult(-1);
        }
        return JsonUtil.responseJson(response, TermVO);
    }

    /**
     * @Method Name : main
     * @Method 설명 : 개설과목관리 > 학기관리  > 학기삭제
     * @param
     * @param commandMap
     * @param model
     * @return  "/crs/term/crs_term_info_write.jsp"
     * @throws Exception
     */
    @RequestMapping(value = "/removeCrsTerm.do")
    public String removeCrsTerm(TermVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        ProcessResultVO<TermVO> resultVo = new ProcessResultVO<TermVO>();
        ProcessResultVO<TermVO> termVo = new ProcessResultVO<TermVO>();

        try {
            termService.delete(vo);

            // 해당 학기가 잘 지워졌는지 확인
            termVo = termService.view(vo);
            if(termVo.getReturnVO() != null) {
                resultVo.setResult(-1);
            } else {
                resultVo.setResult(1);
            }

        } catch(Exception e) {
            e.printStackTrace();
            resultVo.setResult(-1);
        }
        return JsonUtil.responseJson(response, resultVo);
    }

    /**
     * @Method Name : main
     * @Method 설명 : 개설과목관리 > 학기관리  > 학기주차설정
     * @param vo
     * @param model
     * @param request
     * @return "crs/term/crs_term_lesson_form"
     * @throws Exception
     */
    @RequestMapping(value = "/Form/crsTermLessonForm.do")
    public String crsTermLessonForm(TermVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("vo", vo);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/term/crs_term_lesson_form";
    }

    /**
     * @Method Name : listTermLesson
     * @Method 설명 : 학기 주차 설정 목록
     * @param vo
     * @param request
     * @return ProcessResultVO<CrsTermLessonVO>
     * @throws Exception
     */
    @RequestMapping(value = "/listTermLesson.do")
    @ResponseBody
    public ProcessResultVO<CrsTermLessonVO> listTermLesson(CrsTermLessonVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<CrsTermLessonVO> resultVO = new ProcessResultVO<>();

        try {
            List<CrsTermLessonVO> termLessonList = termService.termLessonList(vo);
            resultVO.setReturnList(termLessonList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /**
     * @Method Name : saveTermLesson
     * @Method 설명 : 학기 주차 설정 저장
     * @param list
     * @param request
     * @return ProcessResultVO<CrsTermLessonVO>
     * @throws Exception
     */
    @RequestMapping(value = "/saveTermLesson.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<CrsTermLessonVO> saveTermLesson(@RequestBody List<CrsTermLessonVO> list, HttpServletRequest request) throws Exception {
        ProcessResultVO<CrsTermLessonVO> resultVO = new ProcessResultVO<>();

        try {
            termService.saveTermLesson(request, list);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 사용자 상세 정보 과정 변경
     * @param TermVO
     * @return ProcessResultVO<TermVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/changeTerm.do")
    @ResponseBody
    public ProcessResultVO<TermVO> changeTerm(TermVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<TermVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);
        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);

            List<TermVO> termList = termService.list(vo);
            resultVO.setReturnList(termList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale)); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /**
     * @Method Name : crsListExcel
     * @Method 설명 : 과목 리스트(엑셀 다운로드)
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return  "excelView"
     * @throws Exception
     */
    @RequestMapping(value="/termListExcel.do")
    public String termListExcel(TermVO vo, ModelMap model,
            HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        // 과목 리스트
        vo.setPagingYn("N");
        List<TermVO> resultList = termService.listPageing(vo).getReturnList();
        String[] searchValues = {"조회조건 : "+StringUtil.nvl(vo.getSearchValue())};

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "학기 목록");
        map.put("sheetName", "학기 목록");
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", resultList);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        String name = "";
        String termTypeNm = "";

        if(StringUtil.isNotNull(vo.getTermType())) {
            if("NORMAL".equals(vo.getTermType())) {
                termTypeNm = "정규_";
            } else if("BNORMAL".equals(vo.getTermType())) {
                termTypeNm = "비정규_";
            } else if("OPEN".equals(vo.getTermType())) {
                termTypeNm = "공개_";
            }
        }
        name = StringUtil.nvl(termTypeNm+"학기 목록_"+date.format(today));

        modelMap.put("outFileName", name);

        CrsExcelUtilPoi excelUtilPoi = new CrsExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 학사연동 사용 학기 정보 조회
     * @param TermVO
     * @return ProcessResultVO<TermVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectUniTermByTermLink.do")
    public ProcessResultVO<TermVO> selectUniTermByTermLink(TermVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<TermVO> resultVO = new ProcessResultVO<TermVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String orgId  = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            vo = termService.selectUniTermByTermLink(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /**
     * 개설학기 목록 조회 (학위연도 기준)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @GetMapping("/smstrListByDgrsYr.do")
    @ResponseBody
    public ProcessResultVO<SmstrChrtVO> smstrListByDgrsYr(SmstrChrtVO vo, HttpServletRequest request) throws Exception {
    	
    	ProcessResultVO<SmstrChrtVO> resultVO = new ProcessResultVO<>();
        
        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        
        try {
        	resultVO.setReturnList(semesterService.listSmstrChrtByDgrsYr(vo));
        	resultVO.setResult(1);
        } catch(Exception e) {
        	resultVO.setResult(-1);
        	resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

}
