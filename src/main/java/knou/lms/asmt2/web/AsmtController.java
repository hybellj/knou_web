package knou.lms.asmt2.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.common.SubjectInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.CommonUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.ValidationUtils;
import knou.lms.asmt2.service.AsmtFdbkService;
import knou.lms.asmt2.service.AsmtService;
import knou.lms.asmt2.vo.*;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.rubric.service.RubricService;
import knou.lms.crs.rubric.vo.RubricVO;
import knou.lms.file.vo.AtflVO;
import knou.lms.log2.user.service.LogLrnActvService;
import knou.lms.log2.user.vo.LogLrnActvInqHstryVO;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.team.service.TeamGrpMgrService;
import knou.lms.user.CurrentUser;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/asmt2")
public class AsmtController extends ControllerBase {

    private static final Logger log = LoggerFactory.getLogger(AsmtController.class);

    /**
     * 과제 정보 service
     */
    @Resource(name="asmt2Service")
    private AsmtService asmtService;
    @Resource(name="cmmnCdService")
    private CmmnCdService cmmnCdService;
    @Resource(name="asmtFdbkService")
    private AsmtFdbkService asmtFdbkService;
    @Resource(name="teamGrpMgrService")
    private TeamGrpMgrService teamGrpMgrService;
    @Resource(name="rubricService")
    private RubricService rubricService;
    @Resource(name="logLrnActvService")
    private LogLrnActvService logLrnActvService;

    /**
     * 교수 과제 목록 화면
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/profAsmtListView.do", "/profAsmtListPopView.do"})
    public String profAsmtListView(AsmtVO vo, @CurrentUser UserContext userCtx
            , HttpServletRequest request, ModelMap model) throws Exception {

        // >>>>> 과목아이디가 없으면 어디서든 에러가 나기때문에 체크할 필요가 없지 않을까?
        //String sbjctId = vo.getSbjctId();
        //if( ValidationUtils.isEmpty(sbjctId) ) {
        // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        //    throw new IllegalArgumentException("과목아이디가 없습니다."); // DB에 저장되는 값은 한국 관리자만 보기 때문에 국제화가 필요없다.
        //}

        vo.setOrgId(userCtx.getOrgId());
        vo.setRgtrId(userCtx.getUserId());

        model.addAttribute("asmtVO", vo);

        String servletPath = request.getServletPath(); // 요청 URL
        log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> servletPath=" + servletPath);
        if("/asmt2/profAsmtListPopView.do".equals(servletPath))
            return "asmt2/popup/prof_asmt_list_pop_view";

        return "asmt2/prof_asmt_list_view";
    }

    /**
     * 교수 과제목록 AJAX
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/profAsmtListAjax.do"})
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtListAjax(AsmtVO vo, @CurrentUser UserContext userCtx,
                                                     HttpServletRequest request, ModelMap model) throws Exception {

        ProcessResultVO<EgovMap> resultVO = asmtService.asmtListPaging(vo);
        resultVO.setResult(CommonUtil.SUCCESS);
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 과목별과제목록
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/bySubjectAsmtList.do"})
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtList(SubjectVO vo, @CurrentUser UserContext userCtx,
                                                 HttpServletRequest request, ModelMap model) throws Exception {
        return new ProcessResultVO<EgovMap>().setReturnList(asmtService.bySubjectAsmtList(vo)).setResultSuccess();
    }


    /**
     * 교수 과제 성적반영비율 수정 AJAX
     *
     * @param request
     * @param response
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/profMrkRfltrtModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<AsmtVO> profMrkRfltrtModifyAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        vo.setMdfrId(SessionInfo.getUserId(request));
        return asmtService.mrkRfltrtModify(vo);
    }

    /**
     * 교수 과제 성적반영비율 수정 AJAX
     *
     * @param request
     * @param response
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/mrkRfltrtSingleModify.do"})
    @ResponseBody
    public ProcessResultVO<EgovMap> mrkRfltrtSingleModify(AsmtVO vo, @CurrentUser UserContext ctx,
                                                          HttpServletRequest request, HttpServletResponse response, ModelMap model) {
        vo.setMdfrId(ctx.getUserId());
        return new ProcessResultVO<EgovMap>().setSuccessCount(asmtService.mrkRfltrtSingleModify(vo));
    }

    /**
     * 교수 과제 성적공개여부 수정
     *
     * @param request
     * @param response
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtMrkOynModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profAsmtMrkOynModifyAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        vo.setMdfrId(SessionInfo.getUserId(request));
        return asmtService.mrkOynModify(vo);
    }

    /**
     * 교수 과제등록 화면
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtRegistView.do")
    public String profAsmtRegistView(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        String sbjctId = vo.getSbjctId();

        if(ValidationUtils.isEmpty(sbjctId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setAsmtId("");
        vo.setPrevAsmtId("");

        // 분반목록
        List<EgovMap> dvclasList = asmtService.dvclasList(vo);

        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_ASMT));

        // 주차일정
        List<EgovMap> wknoList = asmtService.lctrWknoSchdlList(vo);

        model.addAttribute("mode", "A");    // 수정: E, 등록: A
        model.addAttribute("asmtVO", vo);
        model.addAttribute("dvclasList", dvclasList);
        model.addAttribute("wknoList", wknoList);
        model.addAttribute("sbjctInfo", SubjectInfo.getSubjectInfo(request, sbjctId));

        return "asmt2/prof_asmt_write_view";
    }

    /**
     * 교수 과제수정 화면
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtModifyView.do")
    public String profAsmtModifyView(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        String sbjctId = vo.getSbjctId();
        String asmtId = vo.getAsmtId();

        if(ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(asmtId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 분반목록
        List<EgovMap> dvclasList = asmtService.dvclasList(vo);

        List<EgovMap> wknoList = asmtService.lctrWknoSchdlList(vo);

        EgovMap asmtVO = asmtService.asmtSelect(vo);
        asmtVO.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_ASMT));
        model.addAttribute("mode", "E");    // 수정: E, 등록: A
        model.addAttribute("dvclasList", dvclasList);
        model.addAttribute("wknoList", wknoList);
        model.addAttribute("asmtVO", asmtVO);
        model.addAttribute("sbjctInfo", SubjectInfo.getSubjectInfo(request, sbjctId));

        return "asmt2/prof_asmt_write_view";
    }

    /**
     * 학습그룹 팀 목록 조회(팀 부주제 설정용)
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtTeamGrpTeamListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtTeamGrpTeamListAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(asmtService.teamGrpTeamList(vo));
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 개별과제 수강생 목록 조회
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profIndivAsmtStdListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profIndivAsmtStdListAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(asmtService.indivStdList(vo));
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 교수 개별 과제 제출 대상 목록 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profIndivAsmtSbmsnTrgtListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profIndivAsmtSbmsnTrgtListAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(asmtService.indivSbmsnTrgt(vo).getReturnList());
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 교수 과제 조회 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtSelectAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnVO(asmtService.asmtSelect(vo));
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }


    /**
     * 교수 과제 등록
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profAsmtRegistAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        asmtService.profAsmtRegist(vo);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 교수 과제 수정
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profAsmtModifyAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        asmtService.profAsmtModify(vo);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 이전과제 가져오기 팝업
     *
     * @param vo
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtCopyListPop.do")
    public String profAsmtCopyPop(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());
        List<EgovMap> smstrChrtList = asmtService.asmtCopySmstrChrtList(vo);

        model.addAttribute("asmtVO", vo);
        model.addAttribute("smstrChrtList", smstrChrtList);
        return "asmt2/popup/asmt_copy_list_pop";
    }

    /**
     * 과제 복사 과목 목록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/asmtCopySbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> asmtCopySbjctListAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(asmtService.asmtCopySbjctList(vo));
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 과제 복사 목록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/asmtCopyListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> asmtCopyListAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setOrgId(userCtx.getOrgId());

        resultVO.setReturnList(asmtService.asmtCopyList(vo));
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 과제 등록 화면에서 공통 루브릭 작성 팝업을 호출한다.
     */
    @RequestMapping(value="/profAsmtRubricWritePopup.do")
    public String profAsmtRubricWritePopup(RubricVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        RubricVO rubricDefaultInfoVO;
        List<EgovMap> rubricInfoVO = null;
        String isModify = "N";
        if(ValidationUtils.isEmpty(vo.getRubricId())) {
            rubricDefaultInfoVO = rubricService.selectRegisterInfo(vo);
        } else {
            isModify = "Y";
            rubricDefaultInfoVO = rubricService.selectRubricRegistInfo(vo);
            rubricInfoVO = rubricService.listRubricInfo(vo);
        }

        model.addAttribute("vo", vo);
        model.addAttribute("rubricDefaultInfoVO", rubricDefaultInfoVO);
        model.addAttribute("rubricInfoVO", rubricInfoVO);
        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("isModify", isModify);
        return "crs/rubric/popup/rubric_write_pop";
    }

    /**
     * 교수 과제 정보 및 평가 화면
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEvlMngView.do")
    public String profAsmtEvlMngView(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        // 과제 정보 조회
        EgovMap asmtVO = asmtService.asmtSelect(vo);

        // 개별제출 대상자 조회
        if("Y".equals(asmtVO.get("indvAsmtyn")) && asmtVO.get("indvAsmtyn") != null) {
            vo.setSearchType("LIST");
            List<EgovMap> indivSbmsnTrgtList = asmtService.indivSbmsnTrgt(vo).getReturnList();
            asmtVO.put("indivSbmsnTrgtList", indivSbmsnTrgtList);
        }

        if("Y".equals(asmtVO.get("byteamAsmtUseyn")) && asmtVO.get("teamGrpId") != null) {
            // 팀 부과제 정보 조회
            AsmtVO paramVO = new AsmtVO();
            paramVO.setUpAsmtId(vo.getAsmtId());
            paramVO.setTeamGrpId(asmtVO.get("teamGrpId").toString());
            List<EgovMap> subAsmtList = asmtService.teamGrpTeamList(paramVO);
            asmtVO.put("subAsmtList", subAsmtList);
        }

        // 재제출관리 가능 여부
        String resbmsnMngyn = asmtService.resbmsnMngyn(asmtVO);
        asmtVO.put("resbmsnMngyn", resbmsnMngyn);

        EgovMap cmmnCdList = new EgovMap();
        List<CmmnCdVO> sbmsnStscdList = cmmnCdService.listCode(userCtx.getOrgId(), "SBMSN_STSCD").getReturnList();
        sbmsnStscdList.removeIf(item -> item.getCdSeqno() == 0);
        cmmnCdList.put("sbmsnStscdList", sbmsnStscdList);

        asmtVO.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_ASMT, (String) asmtVO.get("asmtId")));

        model.addAttribute("asmtVO", asmtVO);
        model.addAttribute("cmmnCdList", cmmnCdList);
        return "asmt2/prof_asmt_evl_mng_view";
    }

    /**
     * 교수 과제 평가 목록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEvlListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtEvlListAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setOrgId(userCtx.getOrgId());

        resultVO.setReturnList(asmtService.asmtEvlList(vo).getReturnList());
        resultVO.setEncParams(getEncParams());
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수 과제 제출 파일 다운로드
     *
     * @param request
     * @param response
     * @param model
     * @param vo
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtFileDwld.do")
    public void profAsmtFileDwld(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo, @CurrentUser UserContext userCtx) throws Exception {
        String fileNamePattern = "[:\\\\/%*?:|\"<>]";
        vo.setOrgId(userCtx.getOrgId());
        EgovMap asmtVO = asmtService.asmtSelect(vo);
        String asmtTitle = String.valueOf(asmtVO.get("asmtTtl")).replaceAll(fileNamePattern, "");
        String zipFileName = asmtTitle + ".zip";
        List<EgovMap> fileList = asmtService.asmtSbmsnZipFileList(vo);

        response.setHeader("Content-Type", "application/octet-stream");
        response.setHeader("Content-Transfer-Coding", "binary");
        response.setHeader("Pragma", "no-cache;");
        response.setHeader("Expires", "-1;");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(zipFileName, "UTF-8").replaceAll("\\+", "%20") + "\";charset=\"UTF-8\"");

        ServletOutputStream binaryOut = response.getOutputStream();
        ZipArchiveOutputStream zos = new ZipArchiveOutputStream(binaryOut);
        zos.setEncoding(Charset.defaultCharset().name());

        Map<String, Integer> entryNameCount = new HashMap<>();
        byte[] buf = new byte[8 * 1024];

        try {
            for(EgovMap fileMap : fileList) {
                AtflVO atflVO = (AtflVO) fileMap.get("atfl");
                String path = (CommConst.WEBDATA_PATH + atflVO.getFilePath() + "/" + atflVO.getFileSavnm()).replace("\\", "/");

                File file = new File(path);
                if(file.isDirectory() || !file.exists() || file.length() <= 0) {
                    continue;
                }

                String entryName = (String) fileMap.get("downloadFileName");
                Integer count = entryNameCount.get(entryName);
                if(count == null) {
                    entryNameCount.put(entryName, 1);
                } else {
                    entryNameCount.put(entryName, count + 1);
                    int dotIndex = entryName.lastIndexOf(".");
                    entryName = dotIndex > 0
                            ? entryName.substring(0, dotIndex) + "_" + (count + 1) + entryName.substring(dotIndex)
                            : entryName + "_" + (count + 1);
                }
                zos.putArchiveEntry(new ZipArchiveEntry(entryName));

                try(FileInputStream fis = new FileInputStream(file)) {
                    int length;
                    while((length = fis.read(buf, 0, buf.length)) >= 0) {
                        zos.write(buf, 0, length);
                    }
                }

                zos.closeArchiveEntry();
            }
        } finally {
            try {
                zos.flush();
                zos.close();
            } catch(Exception e) {
                log.debug("Failed to close assignment zip stream.", e);
            }
            try {
                binaryOut.flush();
                binaryOut.close();
            } catch(Exception e) {
                log.debug("Failed to close assignment download stream.", e);
            }
        }
    }

    /**
     * 교수 과제 엑셀 성적등록 팝업
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtExcelScrRegistPopup.do")
    public String profAsmtExcelScrRegistPopup(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_ASMT, vo.getAsmtId()));
        EgovMap asmtInfo = asmtService.asmtSelect(vo);
        Object teamAsmtStngyn = asmtInfo.get("teamAsmtStngyn");
        vo.setTeamAsmtStngyn(teamAsmtStngyn == null ? null : String.valueOf(teamAsmtStngyn));

        request.setAttribute("vo", vo);
        request.setAttribute("asmtInfo", asmtInfo);

        return "asmt2/popup/prof_asmt_excel_scr_regist_pop";
    }

    /**
     * 교수 과제 엑셀 성적등록 샘플 다운로드
     *
     * @param vo
     * @param userCtx
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtScrRegistSampleExcelDown.do")
    public String profAsmtScrRegistSampleExcelDown(AsmtVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        vo.setSearchType("LIST");

        List<EgovMap> asmtEvlList = asmtService.asmtEvlList(vo).getReturnList();
        for(EgovMap item : asmtEvlList) {
            item.put("memberRole", "Y".equals(item.get("ldryn")) ? "팀장" : "팀원");
        }

        String title = "성적등록_학습자목록";
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", asmtEvlList);

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", "과제_성적등록_학습자목록_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));
        modelMap.put("workbook", new ExcelUtilPoi().simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 교수 과제 평가 목록 엑셀 다운로드
     *
     * @param vo
     * @param userCtx
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEvlListExcelDown.do")
    public String profAsmtEvlListExcelDown(AsmtVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        vo.setSearchType("LIST");
        vo.setTeamId("all".equals(vo.getTeamId()) ? "" : vo.getTeamId());

        EgovMap asmtInfo = asmtService.asmtSelect(vo);
        List<EgovMap> asmtEvlList = asmtService.asmtEvlList(vo).getReturnList();
        for(EgovMap item : asmtEvlList) {
            item.put("memberRole", "Y".equals(item.get("ldryn")) ? "팀장" : "팀원");
            if("N".equals(item.get("evlyn"))) {
                item.put("maxMosart", null);
            }
        }

        String title = "과제평가리스트";
        Object asmtTitleObj = asmtInfo == null ? null : asmtInfo.get("asmtTtl");
        String asmtTitle = asmtTitleObj == null ? "" : String.valueOf(asmtTitleObj);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", asmtEvlList);

        HashMap<String, Object> modelAttr = new HashMap<>();
        modelAttr.put("outFileName", asmtTitle + "_" + title + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));
        modelAttr.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        model.addAllAttributes(modelAttr);

        return "excelView";
    }

    /**
     * 교수 과제 엑셀 성적 업로드
     *
     * @param vo
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtScrExcelUpload.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profAsmtScrExcelUpload(AsmtVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();
        vo.setOrgId(userCtx.getOrgId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        asmtService.asmtScrExcelUpload(vo);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }


    /**
     * 교수 과제 평가 조회(단건) AJAX
     *
     * @param vo
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEvlSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtEvlSelectAjax(AsmtVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setOrgId(userCtx.getOrgId());

        vo.setSearchType("OBJECT");
        resultVO.setReturnVO(asmtService.asmtEvlList(vo).getReturnVO());
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }


    /**
     * 교수 과제 평가 일괄 수정 AJAX
     *
     * @param list
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEvlScrBulkModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtEvlScrBulkModifyAjax(@RequestBody List<AsmtEvlVO> list, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        if(list == null || list.isEmpty()) {
            resultVO.setResult(0);
            resultVO.setMessage("선택된 학습자가 없습니다.");
            return resultVO;
        }

        for(AsmtEvlVO asmtEvlVO : list) {
            asmtEvlVO.setRgtrId(userCtx.getUserId());
            asmtEvlVO.setMdfrId(userCtx.getUserId());
        }
        asmtService.profAsmtEvlScrBulkModify(list);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 교수 과제 평가 수정 AJAX(개별)
     *
     * @param asmtEvlVO
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEvlScrModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtEvlScrModifyAjax(AsmtEvlVO asmtEvlVO, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        asmtEvlVO.setRgtrId(userCtx.getUserId());
        asmtEvlVO.setMdfrId(userCtx.getUserId());
        asmtService.profAsmtEvlScrModify(asmtEvlVO);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 교수 과제 재제출 관리 팝업
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtResbmsnPopup.do")
    public String profAsmtResbmsnPopup(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        String sbjctId = vo.getSbjctId();
        // 과제 정보 조회
        EgovMap asmtVO = asmtService.asmtSelect(vo);

        // TODO: 성적산출기간 조회

        model.addAttribute("asmtVO", asmtVO);
        model.addAttribute("sbjctInfo", SubjectInfo.getSubjectInfo(request, sbjctId));
        return "asmt2/popup/prof_asmt_resbmsn_pop";
    }


    /**
     * 교수 재제출 후보자 목록 조회 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profResbmsnCandidateListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profResbmsnCandidateListAjax(AsmtVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(asmtService.resbmsnCandidateList(vo).getReturnList());
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 교수 재제출 대상 목록 조회 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profResbmsnTrgtListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profResbmsnTrgtListAjax(AsmtVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(asmtService.resbmsnTrgtList(vo).getReturnList());
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }


    /**
     * 교수 과제 재제출 수정 AJAX
     *
     * @param asmtVO
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtResbmsnModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtResbmsnModifyAjax(AsmtVO asmtVO, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        asmtVO.setRgtrId(userCtx.getUserId());
        asmtVO.setMdfrId(userCtx.getUserId());
        asmtService.profAsmtResbmsnModify(asmtVO);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 교수 과제 삭제 AJAX
     *
     * @param asmtVO
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtDeleteAjax(AsmtVO asmtVO, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        asmtVO.setRgtrId(userCtx.getUserId());
        asmtVO.setMdfrId(userCtx.getUserId());

        asmtService.asmtDelete(asmtVO);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 과제 피드백 등록 AJAX
     *
     * @param vo
     * @param fdbkUsersJson
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/asmtFdbkRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> asmtFdbkRegistAjax(AsmtFdbkVO vo, @RequestParam(value="fdbkUsers", defaultValue="[]") String fdbkUsersJson, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        asmtFdbkService.asmtFdbkRegist(vo, fdbkUsersJson);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 교수 과제 피드백 팝업
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtFdbkPopup.do")
    public String profAsmtFdbkPopup(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {

        // 과제 정보 조회
        EgovMap asmtVO = asmtService.asmtSelect(vo);
        // 대상자 조회
        vo.setSearchType("OBJECT");
        EgovMap asmtAtndlcVO = (EgovMap) asmtService.asmtEvlList(vo).getReturnVO();

        asmtVO.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_ASMT));
        model.addAttribute("asmtVO", asmtVO);
        model.addAttribute("asmtAtndlcVO", asmtAtndlcVO);
        model.addAttribute("fdbkPopupMode", userCtx.isStudent() ? CommConst.AUTHRT_GRPCD_STDNT : CommConst.AUTHRT_GRPCD_PROF);
        return "asmt2/popup/prof_asmt_fdbk_pop";
    }

    /**
     * 학생 과제 피드백 팝업
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/stdntAsmtFdbkPopup.do")
    public String stdntAsmtFdbkPopup(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {

        vo.setUserId(userCtx.getUserId());

        EgovMap asmtVO = asmtService.asmtSelect(vo);

        vo.setSearchType("OBJECT");
        EgovMap asmtAtndlcVO = (EgovMap) asmtService.asmtEvlList(vo).getReturnVO();
        if(asmtAtndlcVO == null) {
            asmtAtndlcVO = new EgovMap();
            asmtAtndlcVO.put("userId", userCtx.getUserId());
        }

        asmtVO.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_ASMT));
        model.addAttribute("asmtVO", asmtVO);
        model.addAttribute("asmtAtndlcVO", asmtAtndlcVO);
        model.addAttribute("fdbkPopupMode", userCtx.isStudent() ? CommConst.AUTHRT_GRPCD_STDNT : CommConst.AUTHRT_GRPCD_PROF);
        return "asmt2/popup/prof_asmt_fdbk_pop";
    }

    /**
     * 학생 과제 피드백 목록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/stdntAsmtFdbkListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> stdntAsmtFdbkListAjax(AsmtFdbkVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        vo.setUserId(userCtx.getUserId());
        resultVO = asmtFdbkService.asmtFdbkList(vo);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 교수 과제 피드백 목록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtFdbkListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtFdbkListAjax(AsmtFdbkVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        resultVO = asmtFdbkService.asmtFdbkList(vo);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 과제 피드백 수정 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/asmtFdbkModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> asmtFdbkModifyAjax(AsmtFdbkVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        asmtFdbkService.asmtFdbkModify(vo);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 과제 피드백 조회 AJAX (단건)
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/asmtFdbkSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> asmtFdbkSelectAjax(AsmtFdbkVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        resultVO = asmtFdbkService.asmtFdbkSelect(vo);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 과제 피드백 삭제 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/asmtFdbkDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> asmtFdbkDeleteAjax(AsmtFdbkVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        asmtFdbkService.asmtFdbkDelete(vo);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 교수 과제 메모 팝업
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtMemoPopup.do")
    public String profAsmtMemoPopup(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {

        // 과제 정보 조회
        EgovMap asmtVO = asmtService.asmtSelect(vo);
        // 대상자 조회
        vo.setSearchType("OBJECT");
        EgovMap asmtAtndlcVO = (EgovMap) asmtService.asmtEvlList(vo).getReturnVO();

        model.addAttribute("asmtVO", asmtVO);
        model.addAttribute("asmtAtndlcVO", asmtAtndlcVO);
        return "asmt2/popup/prof_asmt_memo_pop";
    }

    /**
     * 교수 과제 메모 수정
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtMemoModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtMemoModifyAjax(AsmtEvlVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        asmtService.asmtMemoModify(vo);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 이전과제제출목록 팝업
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtPrevSbmsnListPopup.do")
    public String profAsmtPrevSbmsnListPopup(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {

        model.addAttribute("asmtVO", vo);
        return "asmt2/popup/prof_asmt_prev_asmt_list_pop";
    }

    /**
     * 교수 이전 과제 제출 목록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profPrevAsmtSbmsnListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profPrevAsmtSbmsnListAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        resultVO = asmtService.prevAsmtSbmsnList(vo);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }


    /**
     * 교수 우수 과제 일괄 수정 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtExlnBulkModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtExlnBulkModifyAjax(@RequestBody List<AsmtEvlVO> list, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        if(list == null || list.isEmpty()) {
            resultVO.setResult(0);
            resultVO.setMessage("선택된 학습자가 없습니다.");
            return resultVO;
        }

        for(AsmtEvlVO vo : list) {
            vo.setRgtrId(userCtx.getUserId());
            vo.setMdfrId(userCtx.getUserId());
        }

        asmtService.asmtExlnBulkModify(list);

        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 교수 우수 과제 취소 수정 AJAX
     *
     * @param vo
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtExlnModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<AsmtEvlVO> profAsmtExlnModifyAjax(AsmtEvlVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<AsmtEvlVO> resultVO = new ProcessResultVO<>();
        vo.setMdfrId(userCtx.getUserId());
        asmtService.asmtExlnModify(vo);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 교수 과제 이지그레이더 팝업
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEzGraderPopup.do")
    public String profAsmtEzGraderPopup(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {

        String targetUserId = vo.getUserId();
        vo.setUserId(null);
        vo.setTeamId(null);

        // 과제 정보 조회
        EgovMap asmtVO = asmtService.asmtSelect(vo);


        EgovMap cmmnCdList = new EgovMap();
        List<CmmnCdVO> sbmsnStscdList = cmmnCdService.listCode(userCtx.getOrgId(), "SBMSN_STSCD").getReturnList();
        sbmsnStscdList.removeIf(item -> item.getCdSeqno() == 0);
        cmmnCdList.put("sbmsnStscdList", sbmsnStscdList);

        asmtVO.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_ASMT, (String) asmtVO.get("asmtId")));

        model.addAttribute("asmtVO", asmtVO);
        model.addAttribute("targetUserId", targetUserId);
        model.addAttribute("cmmnCdList", cmmnCdList);

        return "asmt2/ezgPop/ezg_main_pop";
    }

    /**
     * 교수 과제 제출 이력 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtSbmsnHistAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtSbmsnHistAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(asmtService.asmtSbmsnHistList(vo));
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }


    /**
     * 교수 과제 이지그레이더 점수 수정 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEzgScrModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtEzgScrModifyAjax(AsmtEvlVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setMdfrId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        asmtService.asmtEzgScrModify(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 교수 과제 이지그레이더 루브릭 평가 저장 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtRubricEvlSaveAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtRubricEvlSaveAjax(AsmtRubricEvlVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setMdfrId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        asmtService.asmtEzgRubricEvlSave(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 교수 과제 이지그레이더 우수과제 수정 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtEzgExlnModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtEzgExlnModifyAjax(AsmtEvlVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setMdfrId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        asmtService.asmtEzgExlnModify(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 교수 과제 이지그레이더 피드백 등록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return
     */
    @RequestMapping(value="/profAsmtEzgFdbkRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtEzgFdbkRegistAjax(AsmtFdbkVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setMdfrId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        asmtFdbkService.asmtEzgFdbkRegist(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 학생 과제 목록 화면
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/stdntAsmtListView.do")
    public String stdntAsmtListView(AsmtVO vo, @CurrentUser UserContext userCtx
            , HttpServletRequest request, ModelMap model) throws Exception {

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        model.addAttribute("asmtVO", vo);

        return "asmt2/stdnt_asmt_list_view";
    }

    /**
     * 학생 과제목록 AJAX
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/stdntAsmtListAjax.do"})
    @ResponseBody
    public ProcessResultVO<EgovMap> stdntAsmtListAjax(AsmtVO vo, @CurrentUser UserContext userCtx,
                                                      HttpServletRequest request, ModelMap model) throws Exception {

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        ProcessResultVO<EgovMap> resultVO = asmtService.stdntAsmtListPaging(vo);
        resultVO.setResult(CommonUtil.SUCCESS);
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 학생 과제 상세 화면
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/stdntAsmtView.do")
    public String stdntAsmtView(AsmtVO vo, @CurrentUser UserContext userCtx
            , HttpServletRequest request, ModelMap model) throws Exception {

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        EgovMap stdntAsmtVO = (EgovMap) asmtService.stdntAsmtView(vo).getReturnVO();

        String rootAsmtId = (String) stdntAsmtVO.get("asmtId");
        String targetAsmtId = (String) stdntAsmtVO.get("targetAsmtId");

        // 학습활동조회이력 저장
        if(userCtx.isStudent())
            logLrnActvService.lrnActvInqHstryRegist(new LogLrnActvInqHstryVO("ASMT", rootAsmtId, userCtx.getLoginUser().getUserId()), userCtx);

        AsmtVO asmtParamVO = new AsmtVO();
        asmtParamVO.setOrgId(userCtx.getOrgId());
        asmtParamVO.setUserId(userCtx.getUserId());
        asmtParamVO.setAsmtId(rootAsmtId);
        asmtParamVO.setSbjctId((String) stdntAsmtVO.get("sbjctId"));

        EgovMap asmtVO = asmtService.asmtSelect(asmtParamVO);

        asmtParamVO.setSearchType("LIST");
        List<EgovMap> indivSbmsnTrgtList = asmtService.indivSbmsnTrgt(asmtParamVO).getReturnList();
        asmtVO.put("indivSbmsnTrgtList", indivSbmsnTrgtList);

        if("Y".equals(asmtVO.get("byteamAsmtUseyn")) && asmtVO.get("teamGrpId") != null) {
            AsmtVO paramVO = new AsmtVO();
            paramVO.setUpAsmtId(asmtParamVO.getAsmtId());
            paramVO.setTeamGrpId(asmtVO.get("teamGrpId").toString());
            asmtVO.put("subAsmtList", asmtService.teamGrpTeamList(paramVO));
        }

        asmtVO.put("resbmsnMngyn", asmtService.resbmsnMngyn(asmtVO));
        stdntAsmtVO.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_ASMT, rootAsmtId));

        AsmtVO stdntAlimParamVO = new AsmtVO();
        stdntAlimParamVO.setOrgId(userCtx.getOrgId());
        stdntAlimParamVO.setUserId(userCtx.getUserId());
        model.addAttribute("stdntAlimVO", asmtService.stdntAsmtAlimInfo(stdntAlimParamVO).getReturnVO());

        AsmtVO targetParamVO = new AsmtVO();
        targetParamVO.setOrgId(userCtx.getOrgId());
        targetParamVO.setUserId(userCtx.getUserId());
        targetParamVO.setSbjctId((String) stdntAsmtVO.get("sbjctId"));
        targetParamVO.setAsmtId(targetAsmtId);

        model.addAttribute("asmtVO", asmtVO);
        model.addAttribute("stdntAsmtVO", stdntAsmtVO);
        model.addAttribute("sbmsnList", asmtService.stdntAsmtSbmsnList(targetParamVO).getReturnList());
        model.addAttribute("exlnAsmtList", asmtService.stdntExlnAsmtList(targetParamVO).getReturnList());

        return "asmt2/stdnt_asmt_view";
    }

    /**
     * 학생 과제 팀 구성원 팝업
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/stdntAsmtTeamMbrPopup.do")
    public String stdntAsmtTeamMbrPopup(AsmtVO vo, @CurrentUser UserContext userCtx
            , HttpServletRequest request, ModelMap model) throws Exception {
        if(ValidationUtils.isEmpty(vo.getTeamId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        if(userCtx.isStudent() && !teamGrpMgrService.isUserInTeam(vo.getTeamId(), userCtx.getUserId())) {
            throw new BadRequestUrlException(getCommonNoAuthMessage());
        }

        model.addAttribute("teamMbrList", teamGrpMgrService.listTeamMembers(vo.getTeamId()));
        return "asmt2/popup/stdnt_asmt_team_mbr_pop";
    }

    /**
     * 학생 과제 제출 저장 AJAX
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/stdntAsmtSbmsnRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> stdntAsmtSbmsnRegistAjax(AsmtSbmsnVO vo, @CurrentUser UserContext userCtx
            , HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setCntnIp(userCtx.getIP());

        resultVO = asmtService.stdntAsmtSbmsnRegist(vo);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

}
