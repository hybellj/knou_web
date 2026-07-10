package knou.lms.evalwgtmng.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.ListOrderedMap;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.ui.ModelMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.evalwgtmng.service.EvalWgtMngService;
import knou.lms.evalwgtmng.vo.EvalWgtMngListVO;
import knou.lms.evalwgtmng.vo.EvalWgtMngVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.service.OrgService;
import knou.lms.org.vo.OrgAisLinkVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/evalwgtmng")
public class EvalWgtMngController extends ControllerBase {

    private static final String EVAL_WGT_AIS_LINK_TYCD = "OPTN0001_007";

    @Resource(name = "evalWgtMngService")
    private EvalWgtMngService evalWgtMngService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "orgService")
    private OrgService orgService;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    /*****************************************************
     * 평가비중관리 목록 화면
     * @param pageInfo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admEvalWgtMngList.do")
    public String evalWgtMngList(EvalWgtMngListVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);

        String orgId = resolveListOrgId(vo.getOrgId(), userCtx, request);
        vo.setOrgId(orgId);

        List<OrgInfoVO> orgList = getOrgList(userCtx, request);
        List<Integer> yearList = DateTimeUtil.getYearList(10, "mix");
        SmstrChrtVO currentSemester = getCurrentSemester(userCtx);
        String curYear = currentSemester == null ? DateTimeUtil.getYear() : StringUtil.nvl(currentSemester.getDgrsYr(), DateTimeUtil.getYear());
        String curTerm = currentSemester == null ? "" : StringUtil.nvl(currentSemester.getDgrsSmstrChrt());

        if (StringUtil.nvl(vo.getDgrsYr()).isEmpty()) {
            vo.setDgrsYr(curYear);
        }

        List<SmstrChrtVO> smstrChrtList = getSmstrChrtList(orgId, vo.getDgrsYr(), orgList);
        OrgAisLinkVO aisLinkInfo = orgService.orgAisLinkInfoSelect(orgId, EVAL_WGT_AIS_LINK_TYCD);

        if (StringUtil.nvl(vo.getDgrsSmstrChrt()).isEmpty() && hasSmstrTerm(smstrChrtList, curTerm)) {
            vo.setDgrsSmstrChrt(curTerm);
        }

        model.addAttribute("orgList", orgList);
        model.addAttribute("yearList", yearList);
        model.addAttribute("smstrChrtList", smstrChrtList);
        model.addAttribute("allOrgYn", isAllOrgAdmin(userCtx) ? "Y" : "N");
        model.addAttribute("evalWgtHaksaSyncYn", isHaksaSyncEnabled(aisLinkInfo) ? "Y" : "N");
        setCommonModel(model, request, vo);
        return "evalwgtmng/adm_evalwgtmng_list";
    }

    /*****************************************************
     * 평가비중관리 등록/수정 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admEvalWgtMngWrite.do")
    public String evalWgtMngWrite(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);
        vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));
        vo.setLangCd("ko");

        List<OrgInfoVO> orgList = getOrgList(userCtx, request);
        List<Integer> yearList = DateTimeUtil.getYearList(10, "mix");
        SmstrChrtVO currentSemester = getCurrentSemester(userCtx);
        String curYear = currentSemester == null ? DateTimeUtil.getYear() : StringUtil.nvl(currentSemester.getDgrsYr(), DateTimeUtil.getYear());
        String curTerm = currentSemester == null ? "" : StringUtil.nvl(currentSemester.getDgrsSmstrChrt());

        String mode = StringUtil.nvl(vo.getMode());
        if (mode.isEmpty()) {
            mode = StringUtil.nvl(vo.getSbjctId()).isEmpty() ? "regist" : "modify";
        }
        vo.setMode(mode);

        if (StringUtil.nvl(vo.getHaksaYear()).isEmpty()) {
            vo.setHaksaYear(curYear);
        }

        List<SmstrChrtVO> smstrChrtList = getSmstrChrtList(vo.getOrgId(), vo.getHaksaYear(), orgList);
        if (StringUtil.nvl(vo.getHaksaTerm()).isEmpty() && hasSmstrTerm(smstrChrtList, curTerm)) {
            vo.setHaksaTerm(curTerm);
        }

        EgovMap subjectInfo = null;
        List<EgovMap> mrkItmStngList = Collections.emptyList();
        List<EgovMap> dvclasList = Collections.emptyList();
        if (!isBlank(vo.getSbjctId())) {
            String listOrgId = vo.getOrgId();
            subjectInfo = evalWgtMngService.selectEvalWgtMngSubject(vo);
            if (subjectInfo == null) {
                throw new BadRequestUrlException("과목 정보를 확인할 수 없습니다.");
            }
            if (subjectInfo.get("orgId") != null) {
                vo.setOrgId(String.valueOf(subjectInfo.get("orgId")));
            }
            mrkItmStngList = evalWgtMngService.listEvalWgtMngItem(vo);
            dvclasList = evalWgtMngService.listEvalWgtMngDvclasSubject(vo);
            vo.setOrgId(listOrgId);
        } else if ("regist".equals(mode) && !isBlank(vo.getOrgId())) {
            mrkItmStngList = evalWgtMngService.listEvalWgtMngItem(vo);
        }

        model.addAttribute("orgList", orgList);
        model.addAttribute("yearList", yearList);
        model.addAttribute("smstrChrtList", smstrChrtList);
        model.addAttribute("allOrgYn", isAllOrgAdmin(userCtx) ? "Y" : "N");
        model.addAttribute("subjectInfo", subjectInfo);
        model.addAttribute("mrkItmStngList", mrkItmStngList);
        model.addAttribute("dvclasList", dvclasList);
        model.addAttribute("mode", mode);
        setCommonModel(model, request, vo);
        return "evalwgtmng/adm_evalwgtmng_write";
    }

    /*****************************************************
     * 평가비중관리 학사연동 팝업 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admEvalWgtMngHaksaSyncPopup.do")
    public String evalWgtMngHaksaSyncPopup(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);
        vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));

        OrgAisLinkVO aisLinkInfo = orgService.orgAisLinkInfoSelect(vo.getOrgId(), EVAL_WGT_AIS_LINK_TYCD);

        model.addAttribute("vo", vo);
        model.addAttribute("aisLinkInfo", aisLinkInfo);
        model.addAttribute("aisLinkTycd", EVAL_WGT_AIS_LINK_TYCD);
        model.addAttribute("encParams", getEncParams());
        return "evalwgtmng/popup/adm_evalwgtmng_haksa_sync_pop";
    }

    /*****************************************************
     * 평가비중관리 학사연동 설정 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<OrgAisLinkVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admEvalWgtMngHaksaSyncInfo.do")
    @ResponseBody
    public ResultDTO<OrgAisLinkVO> evalWgtMngHaksaSyncInfo(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<OrgAisLinkVO> resultDTO = new ResultDTO<OrgAisLinkVO>();
        try {
            checkAdmin(userCtx, request);
            String orgId = resolveListOrgId(vo.getOrgId(), userCtx, request);
            OrgAisLinkVO aisLinkInfo = null;
            if (!isBlank(orgId)) {
                aisLinkInfo = orgService.orgAisLinkInfoSelect(orgId, EVAL_WGT_AIS_LINK_TYCD);
            }
            if (aisLinkInfo == null) {
                aisLinkInfo = new OrgAisLinkVO();
                aisLinkInfo.setAutoLinkyn("N");
            }

            resultDTO.setData(aisLinkInfo);
            resultDTO.setResultSuccess();
            resultDTO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultDTO.setResultFailed(getCommonFailMessage());
            resultDTO.setEncParams(getEncParams());
        }
        return resultDTO;
    }

    /*****************************************************
     * 평가비중관리 학사연동 실행
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admRunEvalWgtMngHaksaSync.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<EgovMap> runEvalWgtMngHaksaSync(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        Map<String, Object> resultMap = buildHaksaSyncResult("ready", "대기", "학사연동 실행 전입니다.");
        try {
            checkAdmin(userCtx, request);
            String orgId = resolveRequiredOrgId(vo.getOrgId(), userCtx, request);
            if (isBlank(orgId)) {
                throw new IllegalArgumentException("기관 정보를 확인할 수 없습니다.");
            }
            if (isBlank(vo.getHaksaYear()) || isBlank(vo.getHaksaTerm())) {
                throw new IllegalArgumentException("년도/학기(기수)를 선택해 주세요.");
            }

            OrgAisLinkVO aisLinkInfo = orgService.orgAisLinkInfoSelect(orgId, EVAL_WGT_AIS_LINK_TYCD);
            if (!isHaksaSyncEnabled(aisLinkInfo)) {
                throw new IllegalArgumentException("학사연동설정에서 평가비중정보 사용여부가 설정되지 않았습니다.");
            }

            String manlUrl = aisLinkInfo == null ? "" : StringUtil.nvl(aisLinkInfo.getManlUrl()).trim();
            if (isBlank(manlUrl)) {
                throw new IllegalArgumentException("학사연동 URL이 설정되지 않았습니다.");
            }

            String responseMessage = requestHaksaSync(manlUrl, orgId, vo.getHaksaYear(), vo.getHaksaTerm(), getUserId(userCtx, request));
            resultMap = buildHaksaSyncResult("success", "성공", StringUtil.nvl(responseMessage, "평가비중 정보를 연동했습니다."));
            resultDTO.setData(toEgovMap(resultMap));
            resultDTO.setResultSuccess(String.valueOf(resultMap.get("message")));
            resultDTO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultMap = buildHaksaSyncResult("error", "실패", StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            resultDTO.setData(toEgovMap(resultMap));
            resultDTO.setResultFailed(String.valueOf(resultMap.get("message")));
            resultDTO.setEncParams(getEncParams());
        } catch (RestClientException e) {
            String message = "[실패] 연동에 실패하였습니다. " + StringUtil.nvl(e.getMessage(), getCommonFailMessage());
            resultMap = buildHaksaSyncResult("error", "실패", message);
            resultDTO.setData(toEgovMap(resultMap));
            resultDTO.setResultFailed(message);
            resultDTO.setEncParams(getEncParams());
        }
        return resultDTO;
    }

    /*****************************************************
     * 평가비중관리 엑셀 업로드 팝업 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admEvalWgtMngExcelUploadPopup.do")
    public String evalWgtMngExcelUploadPopup(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);
        vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));
        vo.setUploadPath("/evalwgtmng/" + vo.getOrgId());

        model.addAttribute("vo", vo);
        return "evalwgtmng/popup/adm_evalwgtmng_excel_upload_pop";
    }

    @RequestMapping(value = "/admCheckEvalWgtMngExcelSample.do")
    @ResponseBody
    public ResultDTO<EgovMap> checkEvalWgtMngExcelSample(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        try {
            checkAdmin(userCtx, request);
            vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));
            vo.setLangCd("ko");

            List<EgovMap> subjectList = evalWgtMngService.listEvalWgtMngSubject(vo);
            if (subjectList == null || subjectList.isEmpty()) {
                resultDTO.setResultFailed("샘플 대상 과목이 없습니다.");
                return resultDTO;
            }

            EvalWgtMngVO itemVo = new EvalWgtMngVO();
            itemVo.setOrgId(vo.getOrgId());
            itemVo.setLangCd("ko");
            itemVo.setMode("regist");
            List<EgovMap> itemList = evalWgtMngService.listEvalWgtMngItem(itemVo);
            if (itemList == null || itemList.isEmpty()) {
                resultDTO.setResultFailed("평가항목 공통코드가 없어 샘플을 생성할 수 없습니다.");
                return resultDTO;
            }

            resultDTO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultDTO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
        } catch (Exception e) {
            resultDTO.setResultFailed(getCommonFailMessage());
        }
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 평가비중관리 엑셀 업로드 양식 다운로드
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admEvalWgtMngExcelUploadSampleDownload.do")
    public String evalWgtMngExcelUploadSampleDownload(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);
        vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));

        List<ListOrderedMap> list = new ArrayList<ListOrderedMap>();
        vo.setLangCd("ko");
        List<EgovMap> subjectList = evalWgtMngService.listEvalWgtMngSubject(vo);

        EvalWgtMngVO itemVo = new EvalWgtMngVO();
        itemVo.setOrgId(vo.getOrgId());
        itemVo.setLangCd("ko");
        itemVo.setMode("regist");
        List<EgovMap> itemList = evalWgtMngService.listEvalWgtMngItem(itemVo);

        Map<String, EgovMap> subjectMap = new LinkedHashMap<String, EgovMap>();
        if (subjectList != null) {
            for (EgovMap subjectInfo : subjectList) {
                String subjectKey = getMapText(subjectInfo, "orgId") + "|" + getMapText(subjectInfo, "haksaYear") + "|" + getMapText(subjectInfo, "haksaTerm")
                    + "|" + getMapText(subjectInfo, "crclmnNo") + "|" + getMapText(subjectInfo, "sbjctNm");
                if (!subjectMap.containsKey(subjectKey)) {
                    subjectMap.put(subjectKey, subjectInfo);
                }
            }
        }

        if (itemList != null) {
            for (EgovMap subjectInfo : subjectMap.values()) {
                for (EgovMap itemInfo : itemList) {
                    String itemName = getMapText(itemInfo, "mrkItmTynm");
                    if (isBlank(itemName)) {
                        itemName = getMapText(itemInfo, "mrkItmTycd");
                    }

                    ListOrderedMap row = new ListOrderedMap();
                    row.put("orgNm", getMapText(subjectInfo, "orgNm"));
                    row.put("haksaYear", getMapText(subjectInfo, "haksaYear"));
                    row.put("haksaTerm", getMapText(subjectInfo, "haksaTerm"));
                    row.put("crclmnNo", getMapText(subjectInfo, "crclmnNo"));
                    row.put("sbjctNm", getMapText(subjectInfo, "sbjctNm"));
                    row.put("mrkItmTycd", itemName);
                    row.put("mrkRfltrt", "");
                    row.put("mrkOyn", "공개");
                    list.add(row);
                }
            }
        }

        HashMap<String, Object> excelMap = new HashMap<String, Object>();
        excelMap.put("title", "평가비중 엑셀 등록 샘플");
        excelMap.put("sheetName", "sample");
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "평가비중_엑셀등록_샘플");
        modelMap.put("sheetName", "sample");
        modelMap.put("list", list);
        modelMap.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        model.addAllAttributes(modelMap);
        return "excelView";
    }

    /*****************************************************
     * 평가비중관리 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admListEvalWgtMng.do")
    @ResponseBody
    public ResultDTO<EgovMap> listEvalWgtMng(EvalWgtMngListVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        try {
            checkAdmin(userCtx, request);
            vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));
            vo.setLangCd(userCtx != null ? StringUtil.nvl(userCtx.getLangCd(), "ko") : "ko");
            resultDTO = evalWgtMngService.listEvalWgtMng(vo);
            resultDTO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultDTO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            resultDTO.setEncParams(getEncParams());
        }
        return resultDTO;
    }

    /*****************************************************
     * 평가비중관리 과목 정보 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admSelectEvalWgtMngSubject.do")
    @ResponseBody
    public ResultDTO<EgovMap> selectEvalWgtMngSubject(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        try {
            checkAdmin(userCtx, request);
            vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));
            vo.setLangCd("ko");

            if (isBlank(vo.getSbjctId())) {
                throw new IllegalArgumentException("과목을 선택해 주세요.");
            }

            EgovMap subjectInfo = evalWgtMngService.selectEvalWgtMngSubject(vo);
            if (subjectInfo == null) {
                throw new IllegalArgumentException("과목 정보를 확인할 수 없습니다.");
            }

            if (subjectInfo.get("orgId") != null) {
                vo.setOrgId(String.valueOf(subjectInfo.get("orgId")));
            }

            Map<String, Object> resultMap = new HashMap<String, Object>();
            resultMap.put("subjectInfo", subjectInfo);
            resultMap.put("itemList", evalWgtMngService.listEvalWgtMngItem(vo));
            resultMap.put("dvclasList", evalWgtMngService.listEvalWgtMngDvclasSubject(vo));

            resultDTO.setData(toEgovMap(resultMap));
            resultDTO.setResultSuccess();
            resultDTO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultDTO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            resultDTO.setEncParams(getEncParams());
        }
        return resultDTO;
    }

    /*****************************************************
     * 평가비중관리 과목 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admListEvalWgtMngSubject.do")
    @ResponseBody
    public ResultDTO<EgovMap> listEvalWgtMngSubject(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        try {
            checkAdmin(userCtx, request);
            vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));
            vo.setLangCd("ko");

            resultDTO.setReturnList(evalWgtMngService.listEvalWgtMngSubject(vo));
            resultDTO.setResultSuccess();
            resultDTO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultDTO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            resultDTO.setEncParams(getEncParams());
        }
        return resultDTO;
    }

    /*****************************************************
     * 평가비중관리 저장
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<EvalWgtMngVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admSaveEvalWgtMng.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<EvalWgtMngVO> saveEvalWgtMng(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<EvalWgtMngVO> resultDTO = new ResultDTO<EvalWgtMngVO>();
        try {
            checkAdmin(userCtx, request);
            vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx, request));
            if (!isBlank(vo.getSbjctId())) {
                EgovMap subjectInfo = evalWgtMngService.selectEvalWgtMngSubject(vo);
                if (subjectInfo == null) {
                    throw new BadRequestUrlException("과목 정보를 확인할 수 없습니다.");
                }
                if (isAllOrgAdmin(userCtx) && isBlank(vo.getOrgId()) && subjectInfo.get("orgId") != null) {
                    vo.setOrgId(String.valueOf(subjectInfo.get("orgId")));
                }
            }
            vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx, request));
            vo.setRgtrId(getUserId(userCtx, request));
            vo.setMdfrId(getUserId(userCtx, request));

            if (isBlank(vo.getRgtrId())) {
                throw new BadRequestUrlException("사용자 정보를 확인할 수 없습니다.");
            }

            evalWgtMngService.saveEvalWgtMng(vo);
            resultDTO.setData(vo);
            resultDTO.setResultSuccess(getMessage("success.common.save"));
            resultDTO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultDTO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            resultDTO.setEncParams(getEncParams());
        }
        return resultDTO;
    }

    /*****************************************************
     * 평가비중관리 엑셀 업로드
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<EvalWgtMngVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admEvalWgtMngExcelUpload.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<EvalWgtMngVO> evalWgtMngExcelUpload(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<EvalWgtMngVO> resultDTO = new ResultDTO<EvalWgtMngVO>();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            checkAdmin(userCtx, request);
            vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx, request));
            vo.setRgtrId(getUserId(userCtx, request));
            vo.setMdfrId(getUserId(userCtx, request));

            int saveCount = evalWgtMngService.evalWgtMngExcelUpload(vo);
            resultDTO.setResultSuccess(saveCount + "건 과목 평가비중을 등록했습니다.");
            resultDTO.setData(vo);
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultDTO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
        } finally {
            if (!isBlank(uploadFiles) && !isBlank(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 평가비중관리 학기 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<SmstrChrtVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admListHaksaTerm.do")
    @ResponseBody
    public ResultDTO<SmstrChrtVO> listHaksaTerm(EvalWgtMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<SmstrChrtVO> resultDTO = new ResultDTO<SmstrChrtVO>();
        try {
            checkAdmin(userCtx, request);
            String orgId = resolveListOrgId(vo.getOrgId(), userCtx, request);
            resultDTO.setReturnList(getSmstrChrtList(orgId, vo.getHaksaYear(), getOrgList(userCtx, request)));
            resultDTO.setResultSuccess();
            resultDTO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultDTO.setResultFailed(getCommonFailMessage());
            resultDTO.setEncParams(getEncParams());
        }
        return resultDTO;
    }

    /*****************************************************
     ******************************************************/
    private String requestHaksaSync(String manlUrl, String orgId, String haksaYear, String haksaTerm, String userId) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(Collections.singletonList(MediaType.ALL));

        MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
        params.add("orgId", StringUtil.nvl(orgId));
        params.add("haksaYear", StringUtil.nvl(haksaYear));
        params.add("haksaTerm", StringUtil.nvl(haksaTerm));
        params.add("dgrsYr", StringUtil.nvl(haksaYear));
        params.add("dgrsSmstrChrt", StringUtil.nvl(haksaTerm));
        params.add("aisLinkTycd", EVAL_WGT_AIS_LINK_TYCD);
        params.add("userId", StringUtil.nvl(userId));

        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<MultiValueMap<String, String>>(params, headers);
        ResponseEntity<String> response = new RestTemplate().postForEntity(manlUrl, requestEntity, String.class);

        String message = resolveHaksaSyncMessage(response.getBody());
        return isBlank(message) ? "평가비중 정보를 연동했습니다." : message;
    }

    private String resolveHaksaSyncMessage(String responseBody) {
        String body = StringUtil.nvl(responseBody).trim();
        if (isBlank(body)) {
            return "";
        }

        if (body.startsWith("{") && body.endsWith("}")) {
            Map<String, Object> responseMap = JsonUtil.getJsonObject(body);
            String message = getMapValueText(responseMap, "message");
            if (isBlank(message)) {
                message = getMapValueText(responseMap, "resultMsg");
            }
            if (isBlank(message)) {
                message = getMapValueText(responseMap, "msg");
            }
            if (!isBlank(message)) {
                return message;
            }
        }
        return body;
    }

    private Map<String, Object> buildHaksaSyncResult(String status, String statusNm, String message) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("execDttm", DateTimeUtil.getCurrentString("yyyy.MM.dd(HH:mm:ss)"));
        resultMap.put("status", status);
        resultMap.put("statusNm", statusNm);
        resultMap.put("message", message);
        return resultMap;
    }

    private EgovMap toEgovMap(Map<String, Object> source) {
        EgovMap map = new EgovMap();
        if (source != null) {
            map.putAll(source);
        }
        return map;
    }

    private void checkAdmin(UserContext userCtx, HttpServletRequest request) {
        String authGrpCd = getAuthGrpCd(userCtx);
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        if ((userCtx == null || !userCtx.isAdmin()) && !CommConst.AUTHRT_GRPCD_ADM.equals(authGrpCd) && !"Y".equals(admYn)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
    }

    private void setCommonModel(ModelMap model, HttpServletRequest request, EvalWgtMngVO vo) throws Exception {
        preserveMenuId(vo, request);
        addEncParam("orgId", vo.getOrgId());
        addEncParam("haksaYear", vo.getHaksaYear());
        addEncParam("haksaTerm", vo.getHaksaTerm());
        addEncParam("sbjctId", vo.getSbjctId());
        addEncParam("mode", vo.getMode());
        addEncParam("searchValue", vo.getSearchValue());

        model.addAttribute("vo", vo);
        model.addAttribute("encParams", getEncParams());
    }

    private void setCommonModel(ModelMap model, HttpServletRequest request, EvalWgtMngListVO vo) throws Exception {
        preserveMenuId(vo, request);
        addEncParam("orgId", vo.getOrgId());
        addEncParam("dgrsYr", vo.getDgrsYr());
        addEncParam("dgrsSmstrChrt", vo.getDgrsSmstrChrt());
        addEncParam("sbjctId", vo.getSbjctId());
        addEncParam("searchText", vo.getSearchText());

        model.addAttribute("vo", vo);
        model.addAttribute("encParams", getEncParams());
    }

    private boolean isHaksaSyncEnabled(OrgAisLinkVO aisLinkInfo) {
        return aisLinkInfo != null
            && "Y".equals(StringUtil.nvl(aisLinkInfo.getAutoLinkyn()));
    }

    private void preserveMenuId(EvalWgtMngVO vo, HttpServletRequest request) throws Exception {
        String menuId = StringUtil.nvl(vo.getMenuId());
        if (isBlank(menuId)) {
            menuId = StringUtil.nvl(request.getParameter("menuId"));
        }
        if (!isBlank(menuId)) {
            vo.setMenuId(menuId);
            addEncParam("menuId", menuId);
        }
    }

    private void preserveMenuId(EvalWgtMngListVO vo, HttpServletRequest request) throws Exception {
        String menuId = StringUtil.nvl(vo.getMenuId());
        if (isBlank(menuId)) {
            menuId = StringUtil.nvl(request.getParameter("menuId"));
        }
        if (!isBlank(menuId)) {
            vo.setMenuId(menuId);
            addEncParam("menuId", menuId);
        }
    }

    private String resolveRequiredOrgId(String orgId, UserContext userCtx, HttpServletRequest request) {
        if (!isAllOrgAdmin(userCtx)) {
            return getOrgId(userCtx, request);
        }
        return StringUtil.nvl(orgId);
    }

    private String resolveListOrgId(String orgId, UserContext userCtx, HttpServletRequest request) {
        if (!isAllOrgAdmin(userCtx)) {
            return getOrgId(userCtx, request);
        }
        return StringUtil.nvl(orgId);
    }

    private List<OrgInfoVO> getOrgList(UserContext userCtx, HttpServletRequest request) throws Exception {
        List<OrgInfoVO> orgList = orgInfoService.listActiveOrg();
        if (isAllOrgAdmin(userCtx)) {
            return orgList;
        }

        return filterOrgList(orgList, getOrgId(userCtx, request));
    }

    private List<OrgInfoVO> filterOrgList(List<OrgInfoVO> orgList, String orgId) {
        List<OrgInfoVO> filteredList = new ArrayList<OrgInfoVO>();
        String value = StringUtil.nvl(orgId);
        if (value.isEmpty() || orgList == null) {
            return filteredList;
        }

        for (OrgInfoVO orgInfoVO : orgList) {
            if (orgInfoVO != null && value.equals(StringUtil.nvl(orgInfoVO.getOrgId()))) {
                filteredList.add(orgInfoVO);
            }
        }
        return filteredList;
    }

    private List<SmstrChrtVO> getSmstrChrtList(String orgId, String haksaYear, List<OrgInfoVO> orgList) throws Exception {
        String year = StringUtil.nvl(haksaYear);
        if (year.isEmpty()) {
            return Collections.emptyList();
        }
        if (StringUtil.nvl(orgId).isEmpty()) {
            return getAllOrgSmstrChrtList(year, orgList);
        }

        SmstrChrtVO smstrChrtVO = new SmstrChrtVO();
        smstrChrtVO.setOrgId(orgId);
        smstrChrtVO.setDgrsYr(haksaYear);
        return semesterService.listSmstrChrtByDgrsYr(smstrChrtVO);
    }

    private List<SmstrChrtVO> getAllOrgSmstrChrtList(String haksaYear, List<OrgInfoVO> orgList) throws Exception {
        Map<String, SmstrChrtVO> termMap = new LinkedHashMap<String, SmstrChrtVO>();
        if (orgList != null) {
            for (OrgInfoVO org : orgList) {
                if (org == null || isBlank(org.getOrgId())) {
                    continue;
                }

                SmstrChrtVO searchVO = new SmstrChrtVO();
                searchVO.setOrgId(org.getOrgId());
                searchVO.setDgrsYr(haksaYear);
                List<SmstrChrtVO> list = semesterService.listSmstrChrtByDgrsYr(searchVO);
                if (list == null) {
                    continue;
                }

                for (SmstrChrtVO term : list) {
                    String termValue = term == null ? "" : StringUtil.nvl(term.getDgrsSmstrChrt());
                    if (termValue.isEmpty() || termMap.containsKey(termValue)) {
                        continue;
                    }

                    SmstrChrtVO option = new SmstrChrtVO();
                    option.setDgrsYr(haksaYear);
                    option.setDgrsSmstrChrt(termValue);
                    option.setSmstrChrtnm(term.getSmstrChrtnm());
                    termMap.put(termValue, option);
                }
            }
        }

        List<SmstrChrtVO> result = new ArrayList<SmstrChrtVO>(termMap.values());
        Collections.sort(result, new Comparator<SmstrChrtVO>() {
            @Override
            public int compare(SmstrChrtVO left, SmstrChrtVO right) {
                return compareTerm(left.getDgrsSmstrChrt(), right.getDgrsSmstrChrt());
            }
        });
        return result;
    }

    private int compareTerm(String left, String right) {
        String leftText = StringUtil.nvl(left);
        String rightText = StringUtil.nvl(right);
        try {
            return Integer.valueOf(leftText).compareTo(Integer.valueOf(rightText));
        } catch (NumberFormatException e) {
            return leftText.compareTo(rightText);
        }
    }

    private boolean hasSmstrTerm(List<SmstrChrtVO> list, String term) {
        String target = StringUtil.nvl(term);
        if (target.isEmpty() || list == null) {
            return false;
        }
        for (SmstrChrtVO item : list) {
            if (item != null && target.equals(StringUtil.nvl(item.getDgrsSmstrChrt()))) {
                return true;
            }
        }
        return false;
    }

    private SmstrChrtVO getCurrentSemester(UserContext userCtx) throws Exception {
        SmstrChrtVO searchVO = new SmstrChrtVO();
        searchVO.setOrgId(userCtx != null ? StringUtil.nvl(userCtx.getOrgId()) : "");
        return semesterService.selectCurrentSemester(searchVO);
    }

    private boolean isAllOrgAdmin(UserContext userCtx) {
        String orgId = userCtx != null ? StringUtil.nvl(userCtx.getOrgId()) : "";
        return CommConst.KNOU_ORG_ID.equals(orgId) || CommConst.LMSBASIC_ORG_ID.equals(orgId);
    }

    private String getUserId(UserContext userCtx, HttpServletRequest request) {
        if (userCtx != null && !isBlank(userCtx.getUserId())) {
            return userCtx.getUserId();
        }
        return "";
    }

    private String getOrgId(UserContext userCtx, HttpServletRequest request) {
        if (userCtx != null && !isBlank(userCtx.getOrgId())) {
            return userCtx.getOrgId();
        }
        return request != null ? StringUtil.nvl(SessionInfo.getOrgId(request)) : "";
    }

    private String getAuthGrpCd(UserContext userCtx) {
        return userCtx != null ? StringUtil.nvl(userCtx.getAuthrtGrpcd()) : "";
    }

    private String getMapText(EgovMap map, String key) {
        if (map == null || map.get(key) == null) {
            return "";
        }
        return StringUtil.nvl(String.valueOf(map.get(key))).trim();
    }

    private String getMapValueText(Map<String, Object> map, String key) {
        if (map == null || map.get(key) == null) {
            return "";
        }
        return StringUtil.nvl(String.valueOf(map.get(key))).trim();
    }

    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
