package knou.lms.std.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.service.DashboardService;
import knou.lms.erp.vo.ErpEnrollmentVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.LearnStopRiskIndexVO;
import knou.lms.std.vo.StdVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Controller
@RequestMapping(value= {"/std/stdMgr"})
public class StdMgrController extends ControllerBase {

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    @Resource(name="orgOrgInfoService")
    private OrgOrgInfoService orgOrgInfoService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name = "dashboardService")
    private DashboardService dashboardService;

    @Resource(name = "termService")
    private TermService termService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    private static final Logger LOGGER = LoggerFactory.getLogger(StdMgrController.class);

    /*****************************************************
     * 강의실별 수강생 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "std/mgr/student_info_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/studentInfoList.do")
    public String studentInfoListForm(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "std/mgr/student_info_list";
    }

    /*****************************************************
     * 수강생 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listStudent.do")
    @ResponseBody
    public ProcessResultVO<StdVO> listStudent(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();

        String crsCreCd = vo.getCrsCreCd();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }

            vo.setCrsCreCds(crsCreCd.split("\\,"));
            vo.setCrsCreCd("");
            if ("".equals(StringUtil.nvl(vo.getOrgId()))) {
            	vo.setOrgId(SessionInfo.getOrgId(request));
            }

            resultVO = stdService.listStudentInfoPaging(vo);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 장애학생 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listDisablilityStudent.do")
    @ResponseBody
    public ProcessResultVO<StdVO> listDisablilityStudent(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();

        String crsCreCd = vo.getCrsCreCd();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }

            vo.setCrsCreCds(crsCreCd.split("\\,"));
            vo.setCrsCreCd("");
            if ("".equals(StringUtil.nvl(vo.getOrgId()))) {
            	vo.setOrgId(SessionInfo.getOrgId(request));
            }

            resultVO = stdService.listDisablilityStudentInfoPaging(vo);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 수강생 정보 목록 엑셀 다운로드
     * @param ExamStareVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelStudentList.do")
    public String excelStudentList(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        String disablilityYn = vo.getDisablilityYn();
        String crsCreCd = vo.getCrsCreCd();

        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        vo.setCrsCreCds(crsCreCd.split("\\,"));
        vo.setCrsCreCd("");

        // 조회조건
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<EgovMap> list = stdService.listStudentInfoExcel(vo);

        String title = getMessage("std.label.learner_info"); // 수강생정보

        if("Y".equals(StringUtil.nvl(disablilityYn))) {
            title = getMessage("std.label.dis_studend_info"); // 장애학생 현황
        }

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
     * 강의실 목록
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listCrsCre.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listCrsCre(CreCrsVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String crsTypeCds = vo.getCrsTypeCds();

        try {
            if(!"".equals(StringUtil.nvl(crsTypeCds))) {
                vo.setCrsTypeCdList(crsTypeCds.split(","));
            }

            List<CreCrsVO> list = stdService.listCrsCre(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * ERP 수강생 미연동 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/haksaStdCheck.do")
    public String haksaStdCheck(TermVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String currentYear = "";
        String currentTerm = "";

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException("페이지 접근 권한이 없습니다.");
        }

        vo.setOrgId(orgId);

        Set<String> yearSet = new LinkedHashSet<>();
        List<TermVO> listHaksaTerm = termService.listHaksaTerm(vo);

        for(TermVO termVO : listHaksaTerm) {
            yearSet.add(termVO.getHaksaYear());

            if("Y".equals(StringUtil.nvl(termVO.getNowSmstryn()))) {
                currentYear = termVO.getHaksaYear();
                currentTerm = termVO.getHaksaTerm();
            }
        }

        model.addAttribute("currentYear", currentYear);
        model.addAttribute("currentTerm", currentTerm);
        model.addAttribute("yearList", new ArrayList<>(yearSet));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        // 관리자용
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "/std/erp/haksa_info_form";
    }

    /*****************************************************
     * ERP 수강생 미연동 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listHaksaStdCheck.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> listHaksaStdCheck(ErpEnrollmentVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<>();

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        try {
            if(!menuType.contains("ADM")) {
                throw new AccessDeniedException("페이지 접근 권한이 없습니다.");
            }

            Map<String, Object> enrollMap = stdService.listHaksaStdCheck(vo);

            resultVO.setReturnVO(enrollMap);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultVO.setResult(1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * ERP 수강생 미연동 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listHaksaStdExcelDown.do")
    public String listHaksaStdExcelDown(ErpEnrollmentVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", getMessage("crs.title.student.no.interlocker.management"));                       // 학생 수강신청 미연동 내역
        map.put("sheetName", getMessage("crs.title.student.no.interlocker.management"));           // 학생 수강신청 미연동 내역
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", stdService.listHaksaStdCheckExcel(vo));

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", getMessage("crs.title.student.no.interlocker.management"));    // 학생 수강신청 미연동 내역

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 학업중단 위험지수 폼
     * @param vo
     * @param model
     * @param request
     * @return "std/mgr/learn_stop_risk_index"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/learnStopRiskIndex.do")
    public String stdLearnStopIndexForm(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);

        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        model.addAttribute("vo", vo);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);

        return "std/mgr/learn_stop_risk_index";
    }

    /*****************************************************
     * 학업중단 위험지수 페이징 목록
     * @param vo
     * @return ProcessResultVO<LearnStopRiskIndexVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listPagingLearnStopRiskIndex.do")
    @ResponseBody
    public ProcessResultVO<LearnStopRiskIndexVO> listPagingLearnStopRiskIndex(LearnStopRiskIndexVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<LearnStopRiskIndexVO> resultVO = new ProcessResultVO<>();
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        try {
            if(!menuType.contains("ADM")) {
                throw new AccessDeniedException(getCommonNoAuthMessage());  // 페이지 접근 권한이 없습니다.
            }

            resultVO = stdService.listPagingLearnStopRiskIndex(vo);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * 학업중단 위험지수 엑셀 업로드 팝업
     * @param vo
     * @return "std/popup/learn_stop_risk_index_upload"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/learnStopRiskIndexUploadPop.do")
    public String learnStopRiskIndexUploadPop(LearnStopRiskIndexVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());  // 페이지 접근 권한이 없습니다.
        }

        return "std/popup/learn_stop_risk_index_upload";
    }

    /*****************************************************
     * 학업중단 위험지수 엑셀 샘플 다운로드
     * @param vo
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/learnStopRiskIndexSampleExcel.do")
    public String learnStopRiskIndexSampleExcel(LearnStopRiskIndexVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());  // 페이지 접근 권한이 없습니다.
        }

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", getMessage("std.label.risk_learn")); // 학업중단 위험지수
        map.put("sheetName", getMessage("std.label.risk_learn")); // 학업중단 위험지수
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", null);

        HashMap<String, Object> modelMap = new HashMap<>();
        String name = StringUtil.nvl(getMessage("std.label.risk_learn") +"_" + getMessage("common.label.sentence.sample")); // 학업중단 위험지수 샘플
        modelMap.put("outFileName", name);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 학업중단 위험지수  엑셀 업로드
     * @param vo
     * @return ProcessResultVO<LearnStopRiskIndexVO>
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/learnStopRiskIndexExcelUpload.do")
    @ResponseBody
    public ProcessResultVO<LearnStopRiskIndexVO> learnStopRiskIndexExcelUpload(LearnStopRiskIndexVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<LearnStopRiskIndexVO> resultVO = new ProcessResultVO<>();

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

            // 읽어온 값으로 insert
            stdService.mergeLearnStopRiskIndex(vo, list);
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
     * 학생 페이징 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listPagingStd.do")
    @ResponseBody
    public ProcessResultVO<StdVO> listPagingStd(StdVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);

            resultVO = stdService.listPaging(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 관리자 > 수업 > 수강생별 학습기록
     * @param vo
     * @param model
     * @param request
     * @return "std/mgr/student_attend_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/studentAttendList.do")
    public String studentAttendListForm(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId    = StringUtil.nvl(SessionInfo.getOrgId(request));

        // 페이지 접근 권한 체크
        if(!menuType.contains("ADM")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        UsrDeptCdVO deptVO = new UsrDeptCdVO();
        deptVO.setOrgId(orgId);
        List<UsrDeptCdVO> deptList = usrDeptCdService.listDept(deptVO);
        model.addAttribute("deptList", deptList);

        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "std/mgr/student_attend_list";
    }

    /*****************************************************
     * 수강생별 학습기록 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listStudentRecord.do")
    @ResponseBody
    public ProcessResultVO<StdVO> listStudentRecord(StdVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            if(!"".equals(StringUtil.nvl(vo.getCrsTypeCd()))) {
                String[] crsTypeCds = vo.getCrsTypeCd().split("\\,");
                vo.setCrsTypeCds(crsTypeCds);
            }
            vo.setOrgId(orgId);
            resultVO = stdService.listStudentRecord(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 수강생별 학습기록 엑셀다운
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/downExcelStudentRecord.do")
    public String downExcelStudentRecord(StdVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);

        if(!"".equals(StringUtil.nvl(vo.getCrsTypeCd()))) {
            String[] crsTypeCds = vo.getCrsTypeCd().split("\\,");
            vo.setCrsTypeCds(crsTypeCds);
        }

        vo.setOrgId(orgId);
        // 조회조건
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        ProcessResultVO<StdVO> resultVO = stdService.listStudentRecord(vo);

        List<StdVO> list = resultVO.getReturnList();

        String title = getMessage("std.label.learner_info"); // 수강생정보

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
        if(list.size() > 1000) {
            map.put("ext", ".xlsx(big)");
        }

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 관리자 > 수업 > 수강생별 학습기록 > 학습기록 팝업
     * @param vo
     * @param model
     * @param request
     * @return "std/mgr/popup/student_attend_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/studentAttendListPop.do")
    public String studentAttendListPop(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        // 페이지 접근 권한 체크
        if(!menuType.contains("ADM")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        model.addAttribute("stdVO", stdService.selectStd(vo));
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("vo", vo);

        return "std/mgr/popup/student_attend_list_pop";
    }

    /*****************************************************
     * 학생 과목 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listStudentCreCrs.do")
    @ResponseBody
    public ProcessResultVO<StdVO> listStudentCreCrs(StdVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();

        try {
            resultVO = stdService.listStudentCreCrs(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }
}
