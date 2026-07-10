package knou.lms.crs.opHstry.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.CodeInfo;
import knou.framework.common.SubjectInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.service.CommonService;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.UserActvHstryVO;
import knou.lms.login.service.UserLgnHstryService;
import knou.lms.login.vo.UserLgnHstryPageInfoVO;
import knou.lms.mrk.service.MrkProcStatusService;
import knou.lms.crs.opHstry.service.SbjctEvlRfltrtStatusService;
import knou.lms.mrk.vo.MrkProcStatusVO;
import knou.lms.crs.opHstry.vo.SbjctEvlRfltrtStatusVO;
import knou.lms.system.manage.vo.CommonCodeVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UsrDeptCdService;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value="/crs/opHstry")
public class OpHstryController extends ControllerBase {

    @Resource(name="sbjctEvlRfltrtStatusService")
    private SbjctEvlRfltrtStatusService sbjctEvlRfltrtStatusService;

    @Resource(name="mrkProcStatusService")
    private MrkProcStatusService mrkProcStatusService;

    @Resource(name="commonService")
    private CommonService commonService;

    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    @Resource(name="logUserActvService")
    private LogUserActvService logUserActvService;

    @Resource(name="userLgnHstryService")
    private UserLgnHstryService userLgnHstryService;

    /**
     * 관리자 > 수업운영현황및이력 > 과목별 평가비중 시행현황 화면
     */
    @RequestMapping(value="/admSbjctEvlRfltrtStatusListView.do")
    public String admSbjctEvlRfltrtStatusListView(SbjctEvlRfltrtStatusVO vo, @CurrentUser UserContext userCtx,
                                                  ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = userCtx.getLoginUser().getOrgId();
        vo.setOrgId(orgId);
        vo.setLangCd(userCtx.getLangCd());

        model.addAttribute("yrSmstrList", commonService.yrSmstrSelect(vo));
//        model.addAttribute("deptList", usrDeptCdService.admByOrgDeptList(vo));
        model.addAttribute("userCtx", userCtx);
        model.addAttribute("evlRfltrtStatusVO", vo);
        model.addAttribute("encParams", getEncParams());

        return "crs/opHstry/adm_sbjct_evl_rfltrt_status_list_view";
    }

    /**
     * 과목별 평가비중 시행현황 목록 조회
     */
    @RequestMapping(value="/admSbjctEvlRfltrtStatusListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSbjctEvlRfltrtStatusListAjax(SbjctEvlRfltrtStatusVO vo,
                                                              @CurrentUser UserContext userCtx,
                                                              HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        ResultDTO<EgovMap> resultDTO = sbjctEvlRfltrtStatusService.sbjctEvlRfltrtStatusList(vo);
        resultDTO.setResultSuccess();
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /**
     * 과목별 평가비중 시행현황 엑셀 다운로드
     */
    @RequestMapping(value="/admSbjctEvlRfltrtStatusExcelDown.do")
    public String admSbjctEvlRfltrtStatusExcelDown(SbjctEvlRfltrtStatusVO vo,
                                                   @CurrentUser UserContext userCtx,
                                                   ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        String title = "과목별 평가비중 시행현황";
        List<EgovMap> list = sbjctEvlRfltrtStatusService.sbjctEvlRfltrtStatusExcelList(vo);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", list);

        HashMap<String, Object> modelAttr = new HashMap<>();
        modelAttr.put("outFileName", title + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));
        modelAttr.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        model.addAllAttributes(modelAttr);

        return "excelView";
    }

    /**
     * 관리자 > 수업운영현황및이력 > 성적처리현황 화면
     */
    @RequestMapping(value="/admMrkProcStatusListView.do")
    public String admMrkProcStatusListView(MrkProcStatusVO vo, @CurrentUser UserContext userCtx,
                                           ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = userCtx.getLoginUser().getOrgId();
        vo.setOrgId(orgId);
        vo.setLangCd(userCtx.getLangCd());

        model.addAttribute("yrSmstrList", commonService.yrSmstrSelect(vo));
//        model.addAttribute("deptList", usrDeptCdService.admByOrgDeptList(vo));
        model.addAttribute("userCtx", userCtx);
        model.addAttribute("mrkProcStatusVO", vo);
        model.addAttribute("encParams", getEncParams());

        return "mrk/adm_mrk_proc_status_list_view";
    }

    /**
     * 성적처리현황 목록 조회
     */
    @RequestMapping(value="/admMrkProcStatusListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admMrkProcStatusListAjax(MrkProcStatusVO vo,
                                                       @CurrentUser UserContext userCtx,
                                                       HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        ResultDTO<EgovMap> resultDTO = mrkProcStatusService.mrkProcStatusList(vo);
        resultDTO.setResultSuccess();
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /**
     * 성적처리현황 엑셀 다운로드
     */
    @RequestMapping(value="/admMrkProcStatusExcelDown.do")
    public String admMrkProcStatusExcelDown(MrkProcStatusVO vo,
                                            @CurrentUser UserContext userCtx,
                                            ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        String title = "성적처리현황";
        List<EgovMap> list = mrkProcStatusService.mrkProcStatusExcelList(vo);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", list);

        HashMap<String, Object> modelAttr = new HashMap<>();
        modelAttr.put("outFileName", title + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));
        modelAttr.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        model.addAllAttributes(modelAttr);

        return "excelView";
    }

    /**
     * 성적처리 로그 팝업 화면
     */
    @RequestMapping(value="/admMrkProcLogPop.do")
    public String admMrkProcLogPop(MrkProcStatusVO vo,
                                   @CurrentUser UserContext userCtx,
                                   ModelMap model,
                                   HttpServletRequest request) throws Exception {
        String orgId = userCtx.getLoginUser().getOrgId();
        vo.setOrgId(orgId);
        vo.setLangCd(userCtx.getLangCd());

        List<CommonCodeVO> mrkProcHstryTyList = new ArrayList<>();
        for(CommonCodeVO code : CodeInfo.getOrgCodeList(request, orgId, "MRK_PROC_HSTRY_TYCD")) {
            if(!"MRK_PROC_HSTRY_TYCD".equals(code.getCd())) {
                mrkProcHstryTyList.add(code);
            }
        }

        model.addAttribute("mrkProcStatusVO", vo);
        model.addAttribute("subjectInfo", SubjectInfo.getSubjectInfo(request, vo.getSbjctId()));
        model.addAttribute("mrkProcHstryTyList", mrkProcHstryTyList);
        model.addAttribute("encParams", getEncParams());

        return "mrk/popup/mrk_proc_log_pop";
    }

    /**
     * 성적처리 로그 목록 조회
     */
    @RequestMapping(value="/admMrkProcHstryListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admMrkProcHstryListAjax(MrkProcStatusVO vo,
                                                      @CurrentUser UserContext userCtx,
                                                      HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        ResultDTO<EgovMap> resultDTO = mrkProcStatusService.mrkProcHstryList(vo);
        EgovMap data = new EgovMap();
        data.put("subjectInfo", SubjectInfo.getSubjectInfo(request, vo.getSbjctId()));
        resultDTO.setData(data);
        resultDTO.setResultSuccess();
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /**
     * 성적처리 로그 엑셀 다운로드
     */
    @RequestMapping(value="/admMrkProcHstryExcelDown.do")
    public String admMrkProcHstryExcelDown(MrkProcStatusVO vo,
                                           @CurrentUser UserContext userCtx,
                                           ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        String title = "성적처리 로그조회";
        List<EgovMap> list = mrkProcStatusService.mrkProcHstryExcelList(vo);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", list);

        HashMap<String, Object> modelAttr = new HashMap<>();
        modelAttr.put("outFileName", title + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));
        modelAttr.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        model.addAllAttributes(modelAttr);

        return "excelView";
    }

    /**
     * 관리자 > 수업운영현황및이력 > 사용자접속이력 화면
     */
    @RequestMapping(value="/admUserActvHstryListView.do")
    public String admUserActvHstryListView(UserActvHstryVO vo, @CurrentUser UserContext userCtx,
                                           ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = userCtx.getLoginUser().getOrgId();
        vo.setOrgId(orgId);
        vo.setLangCd(userCtx.getLangCd());

        List<CommonCodeVO> srvcActnGbncdList = new ArrayList<>();
        for(CommonCodeVO code : CodeInfo.getOrgCodeList(request, orgId, "SRVC_ACTN_GBNCD")) {
            if(!"SRVC_ACTN_GBNCD".equals(code.getCd())) {
                srvcActnGbncdList.add(code);
            }
        }

        model.addAttribute("yrSmstrList", commonService.yrSmstrSelect(vo));
//        model.addAttribute("deptList", usrDeptCdService.admByOrgDeptList(vo));
        model.addAttribute("sbjctList", logUserActvService.userActvHstrySbjctList(vo));
        model.addAttribute("srvcActnGbncdList", srvcActnGbncdList);
        model.addAttribute("userCtx", userCtx);
        model.addAttribute("userActvHstryVO", vo);
        model.addAttribute("encParams", getEncParams());

        return "log2/user/adm_user_actv_hstry_list_view";
    }

    /**
     * 사용자접속이력 목록 조회
     */
    @RequestMapping(value="/admUserActvHstryListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admUserActvHstryListAjax(UserActvHstryVO vo,
                                                       @CurrentUser UserContext userCtx,
                                                       HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        ResultDTO<EgovMap> resultDTO = logUserActvService.userActvHstryList(vo);
        resultDTO.setResultSuccess();
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /**
     * 사용자접속이력 검색조건 과목 목록 조회
     */
    @RequestMapping(value="/admUserActvHstrySbjctListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admUserActvHstrySbjctListAjax(UserActvHstryVO vo,
                                                            @CurrentUser UserContext userCtx,
                                                            HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        resultDTO.setReturnList(logUserActvService.userActvHstrySbjctList(vo));
        resultDTO.setResultSuccess();
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /**
     * 사용자접속이력 엑셀 다운로드
     */
    @RequestMapping(value="/admUserActvHstryExcelDown.do")
    public String admUserActvHstryExcelDown(UserActvHstryVO vo,
                                            @CurrentUser UserContext userCtx,
                                            ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        String title = "사용자접속이력";
        List<EgovMap> list = logUserActvService.userActvHstryExcelList(vo);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", list);

        HashMap<String, Object> modelAttr = new HashMap<>();
        modelAttr.put("outFileName", title + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));
        modelAttr.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        model.addAllAttributes(modelAttr);

        return "excelView";
    }

    /**
     * 관리자 > 수업운영현황및이력 > 로그인 이력 화면
     */
    @RequestMapping(value="/admUserLgnHstryListView.do")
    public String admUserLgnHstryListView(UserLgnHstryPageInfoVO vo, @CurrentUser UserContext userCtx,
                                          ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = userCtx.getLoginUser().getOrgId();
        vo.setOrgId(orgId);
        vo.setLangCd(userCtx.getLangCd());

//        model.addAttribute("deptList", usrDeptCdService.admByOrgDeptList(vo));
        model.addAttribute("userCtx", userCtx);
        model.addAttribute("userLgnHstryVO", vo);
        model.addAttribute("encParams", getEncParams());

        return "login/adm_user_lgn_hstry_list_view";
    }

    /**
     * 로그인 이력 목록 조회
     */
    @RequestMapping(value="/admUserLgnHstryListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admUserLgnHstryListAjax(UserLgnHstryPageInfoVO vo,
                                                      @CurrentUser UserContext userCtx,
                                                      HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        ResultDTO<EgovMap> resultDTO = userLgnHstryService.userLgnHstryList(vo);
        resultDTO.setResultSuccess();
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /**
     * 로그인 이력 엑셀 다운로드
     */
    @RequestMapping(value="/admUserLgnHstryExcelDown.do")
    public String admUserLgnHstryExcelDown(UserLgnHstryPageInfoVO vo,
                                           @CurrentUser UserContext userCtx,
                                           ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setLangCd(userCtx.getLangCd());

        String title = "로그인 이력";
        List<EgovMap> list = userLgnHstryService.userLgnHstryExcelList(vo);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", list);

        HashMap<String, Object> modelAttr = new HashMap<>();
        modelAttr.put("outFileName", title + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));
        modelAttr.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        model.addAllAttributes(modelAttr);

        return "excelView";
    }

}
