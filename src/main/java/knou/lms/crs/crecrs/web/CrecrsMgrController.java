package knou.lms.crs.crecrs.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.CrsExcelUtilPoi;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.URLBuilder;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crs.service.CrsService;
import knou.lms.crs.crs.vo.CrsVO;
import knou.lms.crs.crsCtgr.service.CrsCtgrService;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.service.DashboardService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.score.service.ScoreService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrDeptCdVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
@RequestMapping(value="/crs/creCrsMgr")
public class CrecrsMgrController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(CrecrsMgrController.class);

    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    @Resource(name="orgOrgInfoService")
    private OrgOrgInfoService orgOrgInfoService;

    @Resource(name = "termService")
    private TermService termService;

    @Resource(name = "crsService")
    private CrsService crsService;

    @Resource(name = "stdService")
    private StdService stdService;

    /** 과목 분류 정보 service */
    @Resource(name = "crsCtgrService")
    private CrsCtgrService crsCtgrService;

    @Resource(name = "scoreService")
    private ScoreService scoreService;

    @Resource(name = "dashboardService")
    private DashboardService dashboardService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    /*****************************************************
     * 강의실 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listCrsCre.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listCrsCre(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();
        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String crsTypeCds = vo.getCrsTypeCds();

        try {
            if(!"".equals(StringUtil.nvl(crsTypeCds))) {
                vo.setCrsTypeCdList(crsTypeCds.split(","));
            }

            List<CreCrsVO> list = crecrsService.list(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * 사용자 관리 > 상세 정보 > 현재 학기 강의 과목 페이징
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/userCrecrsListPaging.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> userCrecrsListPaging(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();
        String userId = StringUtil.nvl(vo.getUserId());
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            UsrUserInfoVO uuiVO = new UsrUserInfoVO();
            uuiVO.setUserId(userId);
            uuiVO = usrUserInfoService.userSelect(uuiVO);
            String menuType = StringUtil.nvl(uuiVO.getAuthrtGrpcd());

            if(!menuType.contains("ADM")) {
                if(!"".equals(userId)) {
                    if(menuType.contains("PROF")) {
                        vo.setSearchMenu("PROF");
                    } else if(menuType.contains("USR")) {
                        vo.setSearchMenu("USR");
                    }
                    resultVO = crecrsService.listUserCreCrsPaging(vo);
                }
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * 조교/교수 관리 목록 페이지
     * @param vo
     * @param model
     * @param request
     * @return "crs/crstch/mgr/crecrs_tch_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/creCrsTchList.do")
    public String creCrsTchListForm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException("페이지 접근 권한이 없습니다.");
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crstch/mgr/crecrs_tch_list";
    }

    /*****************************************************
     * 교수/조교 관리 > 교수/조교 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listTchStatus.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listTchStatus(CreCrsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);

            resultVO = crecrsService.listTchStatus(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 교수/조교 관리 > 교수/조교 목록 엑셀다운
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/tchStatuExcelDown.do")
    public String tchStatuExcelDown(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        vo.setPagingYn("N");

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        String title = getMessage("user.title.tch.status").replace("/", ","); // 교수/조교 정보

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", crecrsService.listTchStatus(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 조교/교수 관리 > 개설과목 페이징
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/creCrsListPaging.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> creCrsListPaging(CreCrsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        String crsTypeCds = vo.getCrsTypeCds();
        if(!"".equals(StringUtil.nvl(crsTypeCds))) {
            vo.setCrsTypeCdList(crsTypeCds.split(","));
        }

        try {
            if(!"".equals(StringUtil.nvl(vo.getCrsTypeCd()))) {
                vo.setSqlForeach(vo.getCrsTypeCd().split(","));
            }
            if(!"".equals(StringUtil.nvl(SessionInfo.getOrgId(request)))) {
            	vo.setOrgId(SessionInfo.getOrgId(request));
            }
            resultVO = crecrsService.listCreCrs(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * 조교/교수 정보 수정 페이지
     * @param vo
     * @param model
     * @param request
     * @return "crs/crstch/mgr/crecrs_tch_edit"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/editCreCrsTch.do")
    public String editCreCrsTchForm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException("페이지 접근 권한이 없습니다.");
        }

        request.setAttribute("vo", vo);
        request.setAttribute("tchTypeList", orgCodeService.selectOrgCodeList("CRE_TCH_TYPE"));

        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crstch/mgr/crecrs_tch_edit";
    }

    /*****************************************************
     * 학기/과목 > 개설과목 삭제 업데이트
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/crsCreCoDelete.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> crsCreCoDelete(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();
        String userId = SessionInfo.getUserId(request);

        try {
            vo.setMdfrId(userId);
            crecrsService.deletecrsCreCo(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e:", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 학기제 과목 개설 관리 > 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsListForm.do")
    public String creCrsListForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        model.addAttribute("vo", vo);
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crecrs/crecrs_info_form";
    }

    /*****************************************************
     * 학기/과목 > 학기제 과목 개설 관리 > 등록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_add_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/addForm.do")
    public String addForm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        // 개설 과목
        CreCrsVO creCrsVO = crecrsService.viewCrsCre(vo);
        if (creCrsVO == null) {
        	creCrsVO = new CreCrsVO();
        	creCrsVO.setDeclsNo("01");
        	if (!SessionInfo.isKnou(request)) {
        		creCrsVO.setLcdmsLinkYn("N");
        		creCrsVO.setErpLessonYn("N");
        	}
        }

        model.addAttribute("creCrsVo", creCrsVO);

        TermVO termVo  = new TermVO();
        termVo.setCrsCreCd(vo.getCrsCreCd());
        termVo.setOrgId(orgId);

        List<TermVO> resultListTerm = new ArrayList<>();

        if(!"E".equals(StringUtil.nvl(vo.getGubun(), ""))) {
            // 등록 페이지
             resultListTerm = termService.listTermStatus(termVo);
        } else {
            // 수정페이지
            resultListTerm = termService.listTermRltn(termVo);
        }
        model.addAttribute("creTermList", resultListTerm);

        UsrDeptCdVO udcVO = new UsrDeptCdVO();
        udcVO.setOrgId(orgId);
        model.addAttribute("deptCdList", usrDeptCdService.list(udcVO));

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("isKnou", SessionInfo.isKnou(request));

        return "crs/crecrs/crecrs_add_form";
    }

    /*****************************************************
     * 학기/과목 > 학기제 과목 개설 관리 > 저장
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/crsCreAdd.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> crsCreAdd(@RequestBody CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCd = vo.getCrsCd();

        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setUserId(userId);

            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO = crecrsService.viewCrsCre(vo);

            if(creCrsVO != null) {
                crecrsService.update(vo);
            } else {
                /*
            	// 과정선택없이 과목등록할 경우 과정 임의 생성(외부기관)
            	if ("".equals(StringUtil.nvl(vo.getCrsCd()))) {
            		CrsVO crsVO = new CrsVO();
            		crsVO.setCrsNm(vo.getCrsCreNm());
            		crsVO.setCrsDesc(vo.getCrsCreNm());
            		crsVO.setOrgId(orgId);
            		crsVO.setEnrlCertMthd("AT");
            		crsVO.setNopLimitYn("N");
            		crsVO.setUseYn("Y");
            		crsVO.setDelYn("N");
            		crsVO.setCrsTypeCd("UNI");
            		crsVO.setCrsOperTypeCd("ONLINE");
            		crsVO.setRgtrId(userId);
            		crsVO.setMdfrId(userId);

            		String crsCd = crsService.selectNewCrsCd(crsVO);
            		crsVO.setCrsCd(crsCd);
            		vo.setCrsCd(crsCd);

            		crsService.add(crsVO);
            	}
            	*/

            	if (!SessionInfo.isKnou(request)) {
            	    if(ValidationUtils.isNotEmpty(crsCd)) {
            	        CrsVO crsVO = new CrsVO();
            	        crsVO.setOrgId(orgId);
            	        crsVO.setCrsCd(crsCd);
            	        crsVO = crsService.selectCrsView(crsVO);

            	        if(crsVO == null) {
            	            // 신규 과목 생성
            	            crsVO = new CrsVO();
            	            crsVO.setCrsCd(crsCd);
            	            crsVO.setOrgId(orgId);
            	            crsVO.setCrsNm(vo.getCrsCreNm());
            	            crsVO.setCrsTypeCd("UNI");
            	            crsVO.setEnrlCertMthd("AT");
                            crsVO.setNopLimitYn("N");
                            crsVO.setUseYn("Y");
                            crsVO.setDelYn("N");
                            crsVO.setCrsTypeCd("UNI");
                            crsVO.setCrsOperTypeCd("ONLINE");
                            crsVO.setRgtrId(userId);
                            crsVO.setMdfrId(userId);

            	            crsService.add(crsVO);
            	        }
            	    } else {
            	        // 학수번호를 입력하세요.
            	        throw new BadRequestUrlException(getMessage("crs.confirm.input.crs.cd"));
            	    }

            		vo.setLcdmsLinkYn("N");
            		vo.setErpLessonYn("N");
            		vo.setHaksaDataYn("N");
            		vo.setUniCd("C");
            		vo.setCrsOperTypeCd("ONLINE");
            		vo.setMngtDeptCd(vo.getDeptCd());
            		vo.setCompDvCd("11");
            		vo.setLearningControl("DATE");
            		vo.setCertYn("N");
            		vo.setCertScoreYn("N");
            	}

                crecrsService.add(vo);

                // [기관 성적 항목 설정 -> 개설과정 성적 항목 설정] 복사
                /*
                CrsVO cVO = new CrsVO();
                cVO.setCrsCd(vo.getCrsCd());
                cVO = crsService.viewCrs(cVO).getReturnVO();

                ScoreVO sVO = new ScoreVO();
                sVO.setOrgId(SessionInfo.getOrgId(request));
                sVO.setCrsCreCd(vo.getCrsCreCd());
                sVO.setCrsTypeCd(cVO.getCrsTypeCd());
                sVO.setRgtrId(vo.getRgtrId());
                sVO.setMdfrId(vo.getMdfrId());
                scoreService.copyScoreItemConf(sVO);
                */
            }

            resultVO.setResult(1);
            resultVO.setReturnVO(vo);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 학기제 과목 개설 관리 > 상세 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsInfoDetail.do")
    public String creCrsInfoDetail(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);
        CreCrsVO creCrsVO = crecrsService.viewCrsCre(vo);

        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        TermVO termVo  = new TermVO();
        termVo.setOrgId(orgId);
        termVo.setSearchSort("ASC");

        List<TermVO> resultListTerm = termService.listTermStatus(termVo);
        model.addAttribute("creTermList", resultListTerm);

        return "crs/crecrs/crecrs_info_detail";
    }

    /*****************************************************
     * 학기/과목 > 법정 교육 개설 관리 > 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_legal_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsLegalListForm.do")
    public String creLegalListForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<>();
        for(int i= Integer.parseInt(curYear, 10) + 1; i >= Integer.parseInt("2016", 10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crecrs/crecrs_info_legal_list_form";
    }

    /*****************************************************
     * 학기/과목 > 법정 교육 개설 관리 > 등록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_legal_write_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsLegalWriteForm.do")
    public String creLegalWriteForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();

        // 학기목록
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        List<TermVO> termList = termService.list(termVO);

        // 과목정보
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.viewCrsCre(creCrsVO);

        if(creCrsVO != null) {
            // 강의기간
            creCrsVO.setEnrlStartDttm(DateTimeUtil.getDateType(1,  creCrsVO.getEnrlStartDttm()));
            creCrsVO.setEnrlEndDttm(DateTimeUtil.getDateType(1,  creCrsVO.getEnrlEndDttm()));

            String uploadPath = "/lecture/" + crsCreCd;
            model.addAttribute("uploadPath", uploadPath);

            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("LECTURE");
            fileVO.setFileBindDataSn(creCrsVO.getCrsCreCd());
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
            model.addAttribute("fileList", fileList);
        }

        model.addAttribute("vo", vo);
        model.addAttribute("termList", termList);
        model.addAttribute("creCrsVO", creCrsVO);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crecrs/crecrs_info_legal_write_form";
    }

    /*****************************************************
     * 학기/과목 > 법정 교육 개설 관리 > 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/insertCreCrsLegal.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> insertCreCrsLegal(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            CreCrsVO creCrsVO = crecrsService.insertCreCrsLegal(vo);

            resultVO.setReturnVO(creCrsVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 법정 교육 개설 관리 > 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/updateCreCrsLegal.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> updateCreCrsLegal(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);

            CreCrsVO creCrsVO = crecrsService.updateCreCrsLegal(vo);

            resultVO.setReturnVO(creCrsVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 법정 교육 개설 관리 > 파일 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/updateCreCrsLegalFile.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> updateCreCrsLegalFile(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);

            CreCrsVO creCrsVO = crecrsService.select(vo);

            FileVO fileVO = new FileVO();
            String delFileId[] = request.getParameterValues("deleteFileId");
            if(delFileId.length > 0) {
                for(int i=0; i<delFileId.length; i++ ) {
                    fileVO.setFileSn(delFileId[i]);
                    sysFileService.removeFile(fileVO.getFileSn());
                }
            }

            resultVO.setReturnVO(creCrsVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 법정 교육 개설 관리 > 상세보기  폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_legal_view_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsLegalViewForm.do")
    public String creCrsLegalViewForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);
        CreCrsVO creCrsVO = crecrsService.viewCrsCre(vo);

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("LECTURE");
        fileVO.setFileBindDataSn(creCrsVO.getCrsCreCd());
        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("fileList", fileList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crecrs/crecrs_info_legal_view_form";
    }

    /* ------------------------------------------------------ 공개 개설 과목 시작 ---------------------------------------------------------------*/

    /*****************************************************
     * 학기/과목 > 공개 강좌 개설 관리 > 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsOpenListForm.do")
    public String creOpenListForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2016",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crecrs/crecrs_info_open_list_form";
    }

    /*****************************************************
     * 학기/과목 > 공개 강좌 개설 관리 > 목록 리스트
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listPagingManageCourse.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listPagingManageCrs(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            resultVO = crecrsService.listPagingManageCourse(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e:", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 공개 강좌 개설 관리 > 등록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_write_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsOpenWriteForm.do")
    public String creOpenWriteForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();

        // 학기목록
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        List<TermVO> termList = termService.list(termVO);

        // 과목정보
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.viewCrsCre(creCrsVO);

        if(creCrsVO != null) {
            // 강의기간
            creCrsVO.setEnrlStartDttm(DateTimeUtil.getDateType(1,  creCrsVO.getEnrlStartDttm()));
            creCrsVO.setEnrlEndDttm(DateTimeUtil.getDateType(1,  creCrsVO.getEnrlEndDttm()));

            String uploadPath = "/lecture/" + crsCreCd;
            model.addAttribute("uploadPath", uploadPath);

            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("LECTURE");
            fileVO.setFileBindDataSn(creCrsVO.getCrsCreCd());
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
            model.addAttribute("fileList", fileList);
        }

        model.addAttribute("vo", vo);
        model.addAttribute("termList", termList);
        model.addAttribute("creCrsVO", creCrsVO);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crecrs/crecrs_info_open_write_form";
    }

    /*****************************************************
     * 학기/과목 > 공개 강좌 개설 관리 > 공개강좌 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/insertCreCrsOpen.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> insertCreCrsOpen(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            CreCrsVO creCrsVO = crecrsService.insertCreCrsOpen(vo);

            resultVO.setReturnVO(creCrsVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 공개 강좌 개설 관리 > 공개강좌 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/updateCreCrsOpen.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> updateCreCrsOpen(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);

            CreCrsVO creCrsVO = crecrsService.updateCreCrsOpen(vo);

            resultVO.setReturnVO(creCrsVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 개설과목관리(공개강좌) > 상세보기  폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_view_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsOpenViewForm.do")
    public String creCrsOpenViewForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);
        CreCrsVO creCrsVO = crecrsService.viewCrsCre(vo);

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("LECTURE");
        fileVO.setFileBindDataSn(creCrsVO.getCrsCreCd());
        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("fileList", fileList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crecrs/crecrs_info_open_view_form";
    }

    /*****************************************************
     * 학기/과목 > 과목개설 > 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/manageCourseExcelDown.do")
    public String selectCrsListExcelDown(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        String tName = "";
        String sName = "";

        if("OPEN".equals(vo.getCrsTypeCd())) {
            tName = "공개강좌 과목개설";
            sName = "공개강좌 과목개설목록";
        } else if("LEGAL".equals(vo.getCrsTypeCd())) {
            tName = "법정교육 과목개설";
            sName = "법정교육 과목개설목록";
        } else {
            tName = "학기제 과목개설";
            sName = "학기제 과목개설목록";
        }

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", tName);       // 과목관리
        map.put("sheetName", sName);   // 과목관리목록
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", crecrsService.listManageCourse(vo));

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", sName);    // 과목관리목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 학기/과목 > 과목개설 > 사용여부 변경
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editUseYn.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> editUseYn(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request), "");

        try {
            vo.setMdfrId(userId);

            crecrsService.editUseYn(vo);

            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /* ------------------------------------------------------ 개설 운영자 시작 ---------------------------------------------------------------*/

    /*****************************************************
     * 개설과목관리 > 운영자등록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crstch/crs_info_tch_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/crsTchForm.do")
    public String crsTchForm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String crsCreCd = vo.getCrsCreCd();

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.viewCrsCre(creCrsVO);

        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("creTchTypeList", orgCodeService.getOrgCodeList("CRE_TCH_TYPE"));
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crstch/crs_info_tch_manage";
    }

    /*****************************************************
     * 개설과목관리 > 운영자등록 리스트
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listCreTch.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listCreTch(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);

            List<CreCrsVO> list = crecrsService.listCreTch(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 개설과목관리 > 운영자 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addTch.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> addTch(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String[] tchNoList = vo.getTchNoArr();
        String[] tchTypeList = vo.getTchTypeArr();

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || tchNoList == null || tchNoList.length == 0 || tchTypeList == null || tchTypeList.length == 0) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            crecrsService.addTch(vo);
            resultVO.setResult(1);
            resultVO.setReturnVO(vo);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 개설과목관리 > 학습자 등록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crsstd/crs_info_std_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/crsStdForm.do")
    public String crsStdForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.viewCrsCre(creCrsVO);

        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crsstd/crs_info_std_manage";
    }

    @RequestMapping(value="/searchCrsList.do")
    @ResponseBody
    public ProcessResultVO<CrsVO> searchCrsList(CrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CrsVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            List<CrsVO> list = crsService.list(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 수강생 등록
     * @param vo
     * @param model
     * @param request
     * @param response
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addCreStd.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> addCreStd(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            crecrsService.mergeEditStd(vo);
            resultVO.setResult(1);
            resultVO.setReturnVO(vo);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 학기/과목 > 엑셀 수강생 등록 팝업
     * @param vo
     * @param map
     * @param request
     * @return "crs/crsstd/crecrs_std_excel_upload"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/creCrsStsExcelUploadPop.do")
    public String creCrsStsExcelUploadPop(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());  // 페이지 접근 권한이 없습니다.
        }

        model.addAttribute("vo", vo);

        return "crs/crsstd/crecrs_std_excel_upload";
    }

    /*****************************************************
     * 학기/과목 > 엑셀 수강생 등록 샘플 다운로드
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/creCrsStdSampleExcelDownload.do")
    public String creCrsStdSampleExcelDownload(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        // 개설 과목 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.selectCrsCre(vo);

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", "수강생 엑셀 등록");
        map.put("sheetName", "수강생 엑셀 등록");
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", null);

        HashMap<String, Object> modelMap = new HashMap<>();
        String name = "";

        name = StringUtil.nvl(creCrsVO.getCrsCreNm()+"_수강생 엑셀 등록_"+date.format(today));
        modelMap.put("outFileName", name);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 학기/과목 > 엑셀 수강생 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addCreCrsStdexcelUpload.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> addStdexcelUpload(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            if(!menuType.contains("ADM")) {
                throw new AccessDeniedException(getCommonNoAuthMessage());  // 페이지 접근 권한이 없습니다.
            }

            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            List<FileVO> fileList = FileUtil.getUploadFileList(uploadFiles);
            FileVO fileVO = null;

            if(fileList != null && !fileList.isEmpty() && fileList.size() > 0) {
                fileVO = fileList.get(0);

                String fileExt = FileUtil.getFileExtention(fileVO.getFileNm());
                fileVO.setFilePath(uploadPath);
                fileVO.setFileSaveNm(fileVO.getFileSaveNm() + "." + fileExt);
            }

            // 엑셀 읽기위한 정보값 세팅
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 4);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("fileVO", fileVO);
            map.put("searchKey", "excelUpload");

            // 엑셀 리더
            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<Map<String, Object>> list = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);

            crecrsService.addStdexcelUpload(vo, list);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        } finally {
            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }

        return resultVO;
    }

    /*****************************************************
     * 개설과목관리 > 운영자등록 폼
     * @param vo
     * @param model
     * @param request
     * @return "crs/crsstd/crs_std_approve_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/crsStdApproveForm.do")
    public String crsStdApproveForm(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {

        // 개설과목 정보
        CreCrsVO returnVO = new CreCrsVO();
        if(vo.getCrsCreCd() != null) {
            returnVO = crecrsService.viewCrsCre(vo);
        }
        request.setAttribute("creCrsVo", returnVO);

        // 수료 상태 코드값
        List<OrgCodeVO> enrlStsCdList = orgCodeService.getOrgCodeList("ENRL_STS_CD");
        request.setAttribute("enrlStsCdList", enrlStsCdList);

        return "crs/crsstd/crs_std_approve_manage";
    }

    /*****************************************************
     * 개설과목관리 > 수강생 리스트
     * @param vo
     * @param model
     * @param request
     * @return "crs/crsstd/crs_std_approve_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/crsStdApproveList.do")
    public String crsStdApproveList(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);

        // 개설과목 정보
        CreCrsVO returnVO = new CreCrsVO();
        if(vo.getCrsCreCd() != null) {
            returnVO = crecrsService.viewCrsCre(vo);
        }
        request.setAttribute("creCrsVo", returnVO);

        // 릴레이션 테이블에 학생 정보 있는지 확인
        StdVO stdVo = new StdVO();
        stdVo.setOrgId(orgId);
        stdVo.setCrsCreCd(vo.getCrsCreCd());
        stdVo.setSearchValue(vo.getSearchValue());
        stdVo.setEnrlSts(vo.getEnrlSts());
        stdVo.setEnrlAplcDttm(StringUtil.nvl(vo.getEnrlAplcDttm(), ""));
        stdVo.setEnrlCancelDttm(StringUtil.nvl(vo.getEnrlCancelDttm(), ""));
        stdVo.setEnrlSts(vo.getEnrlSts());
        stdVo.setPageIndex(vo.getPageIndex());
        stdVo.setListScale(vo.getListScale());

        ProcessResultVO<StdVO> stdList = stdService.listPaging(stdVo);
        request.setAttribute("creStdList", stdList.getReturnList());
        request.setAttribute("pageInfo", stdList.getPageInfo());

        return "crs/crsstd/crs_std_approve_list";
    }

    /*****************************************************
     * 개설과목관리 > 개설 과목  view
     * @param vo
     * @param model
     * @param request
     * @return "crs/crsstd/crs_std_approve_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/crsStdApproveAddForm.do")
    public String crsStdApproveAddForm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);

        // 개설과목 정보
        CreCrsVO returnVO = new CreCrsVO();
        if(vo.getCrsCreCd() != null) {
            returnVO = crecrsService.viewCrsCre(vo);
        }
        request.setAttribute("vo", returnVO);

        // 학생 정보
        StdVO stdVo = new StdVO();
        stdVo.setOrgId(orgId);
        stdVo.setCrsCreCd(vo.getCrsCreCd());
        stdVo.setSearchValue(vo.getSearchValue());
        stdVo.setEnrlSts(vo.getEnrlSts());
        stdVo.setPageIndex(vo.getPageIndex());
        stdVo.setListScale(vo.getListScale());
        ProcessResultVO<StdVO> stdList = stdService.listPaging(stdVo);
        request.setAttribute("creStdList", stdList.getReturnList());
        request.setAttribute("pageInfo", stdList.getPageInfo());

        String userIdStr = "";
        for(int i = 0; i < stdList.getReturnList().size(); i++) {
            stdVo = stdList.getReturnList().get(i);
            if(i == 0) {
                userIdStr += stdVo.getUserId();
            } else {
                userIdStr += ","+stdVo.getUserId();
            }
        }
        request.setAttribute("userIdStr", userIdStr);

        return "crs/crsstd/crs_std_approve_write";
    }

    /*****************************************************
     * 개설과목관리 > 수강생 관리 > 수강생 추가 목록
     * @param vo
     * @param model
     * @param request
     * @return "crs/crsstd/user_approve_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/crsUserList.do")
    public String creeStdApproveAdd(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultList = new ProcessResultVO<>();

        if(!"".equals(StringUtil.nvl(vo.getSearchValue(), ""))) {
            resultList = crecrsService.creUserlistPageing(vo);
        }
        request.setAttribute("resultList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());

        return "crs/crsstd/user_approve_list";
    }

    /*****************************************************
     * 개설과목관리 > 수강생 관리 > 수강생 추가
     * @param vo
     * @param model
     * @param request
     * @return redirect
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/creStdApproveAdd.do")
    public String creeStdApproveAdd(CreCrsVO vo, ModelMap model, HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request), "");
        vo.setOrgId(orgId);

        StdVO stdVo = new StdVO();

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        if("".equals(StringUtil.nvl(stdVo.getRgtrId(), ""))) {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
        }

        // 이미 등록된 정보가 있는지 확인
        // List<CreCrsVO> resultList = creCrsService.creStdList(vo);
        // CreCrsVO creCrsvo = new CreCrsVO();

        // if(resultList.isEmpty()) { vo.setGubun("A"); } else { vo.setGubun("E"); }

        try {

            crecrsService.editStd(vo);
            returnVo.setResult(1);
            returnVo.setReturnVO(vo);
        } catch(Exception e) {
            returnVo.setResult(-1);
            e.printStackTrace();
        }

        redirectAttributes.addFlashAttribute("creCrsVO", vo);

        return "redirect:"+new URLBuilder("crs","/creCrsMgr/Form/crsStdApproveForm.do", request).toString();
    }

    /*****************************************************
     * 수강생 관리(엑셀 다운로드)
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/creStdListExcel.do")
    public String creStdListExcel(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        //개설 과목 정보
        CreCrsVO cVo = new CreCrsVO();
        cVo = crecrsService.viewCrsCre(vo);

        StdVO stdVo = new StdVO();
        stdVo.setOrgId(orgId);
        stdVo.setCrsCreCd(cVo.getCrsCreCd());
        List<StdVO> list  = stdService.exList(stdVo);
        String[] searchValues = {"과목 명: "+StringUtil.nvl(cVo.getCrsCreNm())};

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "과목 수강생 정보");
        map.put("sheetName", "과목 수강생 정보");
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", StringUtil.nvl(cVo.getCrsCreNm())+"_과목수강생정보_"+date.format(today));

        CrsExcelUtilPoi excelUtilPoi = new CrsExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 과목별 학습자 학습현황 페이지
     * @param vo
     * @param model
     * @param request
     * @return "crs/crsstd/crs_std_attend_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/crsStdAttendList.do")
    public String crsStdAttendListFrom(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException("페이지 접근 권한이 없습니다.");
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "crs/crsstd/crs_std_attend_list";
    }


    /*****************************************************
     * 선수강과목 이전학기 자료 이관
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/transPrevTermCorsData.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> transPrevTermCorsData(CreCrsVO vo, ModelMap model, HttpServletRequest request) {
    	ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

    	try {
    		int result = crecrsService.transPrevTermCorsData(vo);
        	resultVO.setResult(result);
		} catch (Exception e) {
			resultVO.setResult(-1);
		}

    	return resultVO;
    }

    /*****************************************************
     * JLPT과목 학기 이관
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/transJlptCorsData.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> transJlptCorsData(CreCrsVO vo, ModelMap model, HttpServletRequest request) {
    	ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

    	try {
    		int result = crecrsService.transJlptCorsData(vo);
        	resultVO.setResult(result);
		} catch (Exception e) {
			resultVO.setResult(-1);
		}

    	return resultVO;
    }

    /*****************************************************
     * 과정관리 > 수업운영 > 출석점수 기준관리
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/clasOp/atndcCrtrMng.do")
    public String atndcCrtrMng(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2016",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/clasop/atndc_crtr_mng";
    }

    /*****************************************************
     * 과정관리 > 수업운영 > 기본 루브릭 관리
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/clasOp/rubricMng.do")
    public String rubricMng(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2016",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/clasop/rubric_mng";
    }

    /*****************************************************
     * 과정관리 > 수업운영 > 과목별 평가비중관리
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/clasOp/sbjctEvlMng.do")
    public String sbjctEvlMng(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2016",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/clasop/sbjct_evl_mng";
    }

    /*****************************************************
     * 과정관리 > 수업운영 > 복습기간설정
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/clasOp/rvwPrdStng.do")
    public String rvwPrdStng(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2016",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/clasop/rvw_prd_stng";
    }

    /*****************************************************
     * 과정관리 > 수업운영 > 자동 알림 설정
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/clasOp/autoAlimStng.do")
    public String autoAlimStng(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2016",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/clasop/auto_alim_stng";
    }

    /*****************************************************
     * 과정관리 > 수업운영 > 동영상 플레이어
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/clasOp/videoPlayer.do")
    public String videoPlayer(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2016",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/clasop/video_player";
    }

    /*****************************************************
     * 과정관리 > 수업운영 > 실시간 시험연동
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/crecrs_info_open_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/clasOp/rltmLink.do")
    public String rltmLink(CreCrsVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2016",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/clasop/rltm_link";
    }

    @GetMapping("/sbjctOfrngList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> sbjctOfringList (SubjectVO sbjctOfrngVO, HttpServletRequest request) throws Exception{
    	ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

    	// TODO: 학위연도, 기관, 학기기수, 학과에 따른 개설 과목 목록 조회
    	String orgId = StringUtil.nvl(sbjctOfrngVO.getOrgId(), SessionInfo.getOrgId(request));
    	sbjctOfrngVO.setOrgId(orgId);

    	try {
    		resultVO.setReturnList(crecrsService.listSbjctOfrng(sbjctOfrngVO));
    		resultVO.setResultSuccess();
		} catch (Exception e) {
			resultVO.setResultFailed();
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}


    	return resultVO;
    }
}
