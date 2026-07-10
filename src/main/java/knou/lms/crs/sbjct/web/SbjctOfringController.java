package knou.lms.crs.sbjct.web;

import knou.framework.common.CommConst;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtSchdlVO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.crs.sbjct.excel.SbjctOfringExcelHandler;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.facade.SbjctCodeHelper;
import knou.lms.crs.sbjct.facade.SbjctOfringViewFacadeService;
import knou.lms.crs.sbjct.policy.SbjctOfringAccessPolicy;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.service.SbjctTmpltService;
import knou.lms.crs.sbjct.vo.SbjctAdmVO;
import knou.lms.crs.sbjct.vo.SbjctAtndlcVO;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctSchdlVO;
import knou.lms.crs.sbjct.vo.SbjctTmpltListVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.crs.sbjct.web.paging.SbjctOfringPageInfo;
import knou.lms.user.CurrentUser;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.List;

/**
 * 일반 과목개설 관리 화면과 비동기 기능을 제공한다.
 */
@Controller
@RequestMapping(value="/crs/sbjctOfring")
public class SbjctOfringController extends SbjctControllerBase {

    @Resource(name="sbjctService")
    private SbjctService sbjctService;

    @Resource(name="sbjctTmpltService")
    private SbjctTmpltService sbjctTmpltService;

    @Resource(name="semesterService")
    private SemesterService semesterService;

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctCodeHelper")
    private SbjctCodeHelper sbjctCodeHelper;

    @Resource(name="sbjctOfringViewFacadeService")
    private SbjctOfringViewFacadeService sbjctOfringViewFacadeService;

    @Resource(name="sbjctOfringExcelHandler")
    private SbjctOfringExcelHandler sbjctOfringExcelHandler;

    /**
     * 관리자 과목개설 목록 화면을 조회한다.
     * @param sbjctListVO
     * @param model
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctOfringListView.do")
    public String admSbjctOfringListView(
            SbjctListVO sbjctListVO,
            ModelMap model,
            @CurrentUser UserContext userCtx) throws Exception {

        model.addAllAttributes(sbjctOfringViewFacadeService.listView(sbjctListVO, userCtx));

        return "crs/sbjct/adm_sbjct_ofring_list_view";
    }

    /**
     * 관리자 과목개설 등록 화면을 조회한다.
     * @param sbjctVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctOfringRegistView.do")
    public String admSbjctOfringRegistView(
            SbjctVO sbjctVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        String orgId = sbjctAuthHelper.resolveSearchOrgId(sbjctVO.getOrgId(), userCtx);
        String mode = "I";

        if(sbjctVO.getSbjctId() != null && !sbjctVO.getSbjctId().trim().isEmpty()) {
            SbjctVO detailVO = resolveSbjctOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
            if(detailVO == null) {
                return redirectNoAuthToSafeReferer(request, "/crs/sbjctOfring/admSbjctOfringListView.do");
            }
            sbjctVO = detailVO;
            mode = "E";
        } else {
            sbjctVO.setOrgId(orgId);
        }

        model.addAllAttributes(sbjctOfringViewFacadeService.registView(sbjctVO, mode, userCtx));

        return "crs/sbjct/adm_sbjct_ofring_regist_view";
    }

    /**
     * 관리자 과목개설 상세 화면을 조회한다.
     * @param sbjctVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringDetailView.do")
    public String admSbjctOfringDetailView(
            SbjctVO sbjctVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        SbjctVO detailVO = resolveSbjctOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
        if(detailVO == null) {
            return redirectNoAuthToSafeReferer(request, "/crs/sbjctOfring/admSbjctOfringListView.do");
        }

        model.addAllAttributes(sbjctOfringViewFacadeService.detailView(detailVO, userCtx));

        return "crs/sbjct/adm_sbjct_ofring_detail_view";
    }

    /**
     * 관리자 과목개설 기본정보 팝업 화면을 조회한다.
     * @param sbjctVO
     * @param model
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringBasicInfoPop.do")
    public String admSbjctOfringBasicInfoPop(
            SbjctVO sbjctVO,
            ModelMap model,
            @CurrentUser UserContext userCtx) {

        SbjctVO detailVO = resolveSbjctOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
        if(detailVO == null) {
            model.addAttribute("message", getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
            return "crs/sbjct/popup/adm_sbjct_ofring_basic_info_popview";
        }

        model.addAllAttributes(sbjctOfringViewFacadeService.basicInfoPopView(detailVO, userCtx));
        model.addAttribute("encParams", getEncParams());

        return "crs/sbjct/popup/adm_sbjct_ofring_basic_info_popview";
    }

    /**
     * 관리자 과목개설 목록을 조회한다.
     * @param pageInfo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringList.do")
    @ResponseBody
    public ResultDTO<SbjctListVO> admSbjctOfringList(
            SbjctOfringPageInfo pageInfo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        pageInfo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());
        ResultDTO<SbjctListVO> resultDTO = sbjctService.selectSbjctOfringList(pageInfo);
        resultDTO.setEncParams(request.getParameter("encParams"));

        return resultDTO;
    }

    /**
     * 관리자 과목개설 목록을 엑셀로 다운로드한다.
     * @param pageInfo
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctOfringListExcelDown.do")
    public String admSbjctOfringListExcelDown(
            SbjctOfringPageInfo pageInfo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        // 엑셀 다운로드는 목록 화면의 암호화 검색 조건을 PageInfo에 복원한 뒤 조회한다.
        initEncryptedParamContext(request, model, pageInfo);
        String title = getMessage("crs.sbjct.ofring.list");/*과목개설 목록*/
        model.addAllAttributes(sbjctOfringExcelHandler.listExcel(pageInfo, userCtx, title));

        return "excelView";
    }

    /**
     * 관리자 과목개설을 등록한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringRegist.do")
    @ResponseBody
    public ResultDTO<SbjctVO> admSbjctOfringRegist(
            SbjctVO vo,
            @CurrentUser UserContext userCtx) {

        applySbjctOfringAudit(vo, userCtx);
        ResultDTO<SbjctVO> resultDTO = sbjctService.insertSbjctOfring(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }

        return successSave(resultDTO);
    }

    /**
     * 관리자 과목개설을 수정한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringModify.do")
    @ResponseBody
    public ResultDTO<SbjctVO> admSbjctOfringModify(
            SbjctVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();
        applySbjctOfringAudit(vo, userCtx);

        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }

        resultDTO = sbjctService.updateSbjctOfring(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }

        return successSave(resultDTO);
    }

    /**
     * 과목개설 목록에서 사용여부만 수정한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringUseynModify.do")
    @ResponseBody
    public ResultDTO<SbjctVO> admSbjctOfringUseynModify(
            SbjctVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }

        vo.setMdfrId(userCtx.getUserId());
        resultDTO = sbjctService.updateSbjctOfringUseyn(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }

        return successSave(resultDTO);
    }

    /**
     * 과목개설 목록에서 선택한 과목개설을 삭제한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringDelete.do")
    @ResponseBody
    public ResultDTO<Integer> admSbjctOfringDelete(
            SbjctVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<Integer> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }

        vo.setMdfrId(userCtx.getUserId());
        resultDTO = sbjctService.deleteSbjctOfring(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }

        return successSave(resultDTO);
    }

    /**
     * 관리자 과목개설 주차 기간 설정 화면을 조회한다.
     * @param sbjctVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringSchdlRegistView.do")
    public String admSbjctOfringSchdlRegistView(
            SbjctVO sbjctVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        SbjctVO detailVO = resolveSbjctOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
        if(detailVO == null) {
            return redirectNoAuthToSafeReferer(request, "/crs/sbjctOfring/admSbjctOfringListView.do");
        }
        if(!canManageNextStep(detailVO, userCtx)) {
            setResultFail(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
            return "redirect:/crs/sbjctOfring/admSbjctOfringListView.do";
        }

        model.addAllAttributes(sbjctOfringViewFacadeService.schdlRegistView(detailVO, userCtx));
        model.addAttribute("encParams", getEncParams());

        return "crs/sbjct/adm_sbjct_ofring_schdl_regist_view";
    }

    /**
     * 관리자 과목개설 주차 기간 설정을 저장한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringSchdlRegist.do")
    @ResponseBody
    public ResultDTO<SbjctSchdlVO> admSbjctOfringSchdlRegist(
            SbjctSchdlVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctSchdlVO> resultDTO = new ResultDTO<>();
        if(vo == null) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }

        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }
        if(!canManageNextStep(savedVO, userCtx)) {
            return resultDTO.setResultFailed(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
        }

        vo.setOrgId(savedVO.getOrgId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        resultDTO = sbjctService.saveSbjctOfringSchdl(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }

        return successSave(resultDTO);
    }

    /**
     * 관리자 과목개설 과목관리자 등록 화면을 조회한다.
     * @param sbjctVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctOfringAdmRegistView.do")
    public String admSbjctOfringAdmRegistView(
            SbjctVO sbjctVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        SbjctVO detailVO = resolveSbjctOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
        if(detailVO == null) {
            return redirectNoAuthToSafeReferer(request, "/crs/sbjctOfring/admSbjctOfringListView.do");
        }
        if(!canManageNextStep(detailVO, userCtx)) {
            setResultFail(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
            return "redirect:/crs/sbjctOfring/admSbjctOfringListView.do";
        }

        model.addAllAttributes(sbjctOfringViewFacadeService.admRegistView(detailVO, userCtx));
        model.addAttribute("encParams", getEncParams());

        return "crs/sbjct/adm_sbjct_ofring_adm_regist_view";
    }

    /**
     * 과목개설 과목관리자 등록용 사용자 목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringAdmUserList.do")
    @ResponseBody
    public ResultDTO<SbjctAdmVO> admSbjctOfringAdmUserList(
            SbjctAdmVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctAdmVO> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }
        if(!canManageNextStep(savedVO, userCtx)) {
            return resultDTO.setResultFailed(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
        }

        vo.setLangCd(userCtx.getLangCd());
        return sbjctService.admSbjctOfringAdmUserList(vo);
    }

    /**
     * 관리자 과목개설 과목관리자를 저장한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringAdmRegist.do")
    @ResponseBody
    public ResultDTO<SbjctAdmVO> admSbjctOfringAdmRegist(
            SbjctAdmVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctAdmVO> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }
        if(!canManageNextStep(savedVO, userCtx)) {
            return resultDTO.setResultFailed(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
        }

        vo.setOrgId(savedVO.getOrgId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        resultDTO = sbjctService.admSbjctOfringAdmRegist(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }

        return successSave(resultDTO);
    }

    /**
     * 관리자 과목개설 수강생 등록 화면을 조회한다.
     * @param sbjctVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctOfringStdntRegistView.do")
    public String admSbjctOfringStdntRegistView(
            SbjctVO sbjctVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        SbjctVO detailVO = resolveSbjctOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
        if(detailVO == null) {
            return redirectNoAuthToSafeReferer(request, "/crs/sbjctOfring/admSbjctOfringListView.do");
        }
        if(!canManageNextStep(detailVO, userCtx)) {
            setResultFail(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
            return "redirect:/crs/sbjctOfring/admSbjctOfringListView.do";
        }

        model.addAllAttributes(sbjctOfringViewFacadeService.stdntRegistView(detailVO, userCtx));
        model.addAttribute("encParams", getEncParams());

        return "crs/sbjct/adm_sbjct_ofring_stdnt_regist_view";
    }

    /**
     * 과목개설 수강생 등록용 사용자 목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringStdntUserList.do")
    @ResponseBody
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntUserList(
            SbjctAtndlcVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctAtndlcVO> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }
        if(!canManageNextStep(savedVO, userCtx)) {
            return resultDTO.setResultFailed(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
        }

        vo.setOrgId(savedVO.getOrgId());
        vo.setLangCd(userCtx.getLangCd());
        return sbjctService.admSbjctOfringStdntUserList(vo);
    }

    /**
     * 관리자 과목개설 수강생을 저장한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringStdntRegist.do")
    @ResponseBody
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntRegist(
            SbjctAtndlcVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctAtndlcVO> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }
        if(!canManageNextStep(savedVO, userCtx)) {
            return resultDTO.setResultFailed(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
        }

        vo.setOrgId(savedVO.getOrgId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        resultDTO = sbjctService.admSbjctOfringStdntRegist(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }

        return successSave(resultDTO);
    }

    /**
     * 관리자 과목개설 수강생 목록을 엑셀로 다운로드한다.
     * @param vo
     * @param model
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringStdntListExcelDown.do")
    public String admSbjctOfringStdntListExcelDown(
            SbjctAtndlcVO vo,
            ModelMap model,
            @CurrentUser UserContext userCtx) {

        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            model.addAttribute("message", getMessage("common.system.no_auth"));/*사용권한이 없거나 로그아웃되었습니다. 다시 로그인하세요.*/
            return "jsonView";
        }
        if(!canManageNextStep(savedVO, userCtx)) {
            model.addAttribute("message", getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
            return "jsonView";
        }

        vo.setOrgId(savedVO.getOrgId());
        String title = getMessage("common.label.students");/*수강생*/
        model.addAllAttributes(sbjctOfringExcelHandler.stdntListExcel(vo, userCtx, title));

        return "excelView";
    }

    /**
     * 관리자 과목개설 수강생 엑셀 업로드 팝업 화면을 조회한다.
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctOfringStdntExcelUploadPop.do")
    public String admSbjctOfringStdntExcelUploadPop(
            SbjctAtndlcVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        boolean validUploadContext = false;

        if(vo != null && !isBlank(vo.getSbjctId())) {
            SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
            validUploadContext = canManageNextStep(savedVO, userCtx);
            if(validUploadContext) {
                vo.setOrgId(savedVO.getOrgId());
                vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_SBJCT));
            }
        }

        model.addAllAttributes(sbjctOfringViewFacadeService.stdntExcelUploadPop(vo, validUploadContext));

        return "crs/sbjct/popup/adm_sbjct_ofring_stdnt_excel_upload_popview";
    }

    /**
     * 관리자 과목개설 수강생 엑셀 업로드 샘플을 다운로드한다.
     * @param vo
     * @param model
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringStdntExcelSampleDownload.do")
    public String admSbjctOfringStdntExcelSampleDownload(
            SbjctAtndlcVO vo,
            ModelMap model,
            @CurrentUser UserContext userCtx) {

        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            model.addAttribute("message", getMessage("common.system.no_auth"));/*사용권한이 없거나 로그아웃되었습니다. 다시 로그인하세요.*/
            return "jsonView";
        }
        if(!canManageNextStep(savedVO, userCtx)) {
            model.addAttribute("message", getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
            return "jsonView";
        }

        String title = getMessage("common.label.students") + " " + getMessage("crs.button.excel.reg");/*수강생, 엑셀로 등록*/
        model.addAllAttributes(sbjctOfringExcelHandler.stdntExcelSample(
                vo,
                title,
                getMessage("crs.sbjct.ofring.excel.guide.stdnt.no")));/*학번 입력*/

        return "excelView";
    }

    /**
     * 관리자 과목개설 수강생 엑셀 업로드 데이터를 읽어 화면 추가용 목록으로 반환한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctOfringStdntExcelUpload.do")
    @ResponseBody
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntExcelUpload(
            SbjctAtndlcVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctAtndlcVO> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveSbjctOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }
        if(!canManageNextStep(savedVO, userCtx)) {
            return resultDTO.setResultFailed(getMessage(SbjctOfringAccessPolicy.MSG_KEY_NEXT_STEP_APPROVE_REQUIRED));/*수강인증상태가 승인이여야 합니다.*/
        }

        vo.setOrgId(savedVO.getOrgId());
        return withFailMessage(sbjctService.admSbjctOfringStdntExcelUpload(vo));
    }

    /**
     * 관리자 과목개설 학기/기수 목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping("/admYrSmstrSelect.do")
    @ResponseBody
    public ResultDTO<SmstrChrtVO> admYrSmstrSelect(
            SmstrChrtVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SmstrChrtVO> resultDTO = new ResultDTO<>();
        if(vo.getOrgId() == null || vo.getOrgId().trim().isEmpty()) {
            resultDTO.setReturnList(Collections.emptyList());
            resultDTO.setResultSuccess();
            return resultDTO;
        }

        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        resultDTO.setReturnList(semesterService.listSmstrChrtByDgrsYr(vo));
        resultDTO.setResultSuccess();

        return resultDTO;
    }

    /**
     * 관리자 과목개설 공통코드 목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping("/admOfringCmmnCdList.do")
    @ResponseBody
    public ResultDTO<CmmnCdVO> admOfringCmmnCdList(
            CmmnCdVO vo,
            @CurrentUser UserContext userCtx) throws Exception {

        ResultDTO<CmmnCdVO> resultDTO = new ResultDTO<>();
        String upCd = vo.getUpCd();

        if(upCd == null || upCd.trim().isEmpty()) {
            resultDTO.setReturnList(Collections.emptyList());
            resultDTO.setResultSuccess();
            return resultDTO;
        }


        String orgId = sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx);
        vo.setOrgId(orgId);
        resultDTO.setReturnList(sbjctCodeHelper.listSbjctOfringCode(orgId, upCd));
        resultDTO.setResultSuccess();
        return resultDTO;
    }

    /**
     * 과목개설 등록 화면에서 선택할 과목목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping("/admSbjctTmpltOfringList.do")
    @ResponseBody
    public ResultDTO<SbjctTmpltListVO> admSbjctTmpltOfringList(
            SbjctTmpltListVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctTmpltListVO> resultDTO = new ResultDTO<>();
        if(vo.getSmstrChrtId() == null || vo.getSmstrChrtId().trim().isEmpty()) {
            resultDTO.setReturnList(Collections.emptyList());
            resultDTO.setResultSuccess();
            return resultDTO;
        }

        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        return sbjctTmpltService.selectSbjctTmpltOfringList(vo);
    }

    /**
     * 관리자 과목개설 학기기수 일정 주차 목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping("/admSmstrChrtSchdlWknoList.do")
    @ResponseBody
    public ResultDTO<SmstrChrtSchdlVO> admSmstrChrtSchdlWknoList(
            SmstrChrtSchdlVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SmstrChrtSchdlVO> resultDTO = new ResultDTO<>();
        if(vo.getSmstrChrtId() == null || vo.getSmstrChrtId().trim().isEmpty()) {
            resultDTO.setReturnList(Collections.emptyList());
            resultDTO.setResultSuccess();
            return resultDTO;
        }

        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        resultDTO.setReturnList(semesterService.listSmstrChrtSchdlWkno(vo));
        resultDTO.setResultSuccess();

        return resultDTO;
    }

    /**
     * 과목개설 저장 시 공통으로 필요한 사용자 감사 정보를 설정한다.
     * @param vo
     * @param userCtx
     */
    private void applySbjctOfringAudit(SbjctVO vo, UserContext userCtx) {
        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
    }

    /**
     * 문자열이 null 이거나 공백인지 확인한다.
     * @param value
     * @return
     */
    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

}
