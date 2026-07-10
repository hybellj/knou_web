package knou.lms.crs.sbjct.web;

import knou.framework.common.CommConst;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.sbjct.excel.SbjctTmpltExcelHandler;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.facade.SbjctCodeHelper;
import knou.lms.crs.sbjct.facade.SbjctTmpltViewFacadeService;
import knou.lms.crs.sbjct.service.SbjctTmpltService;
import knou.lms.crs.sbjct.vo.SbjctTmpltListVO;
import knou.lms.crs.sbjct.vo.SbjctTmpltVO;
import knou.lms.crs.sbjct.web.paging.SbjctTmpltPageInfo;
import knou.lms.user.CurrentUser;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 과목 템플릿 관리 화면과 비동기 기능을 제공한다.
 */
@Controller
@RequestMapping(value="/crs/sbjctTmplt")
public class SbjctTmpltController extends SbjctControllerBase {

    @Resource(name="sbjctTmpltService")
    private SbjctTmpltService sbjctTmpltService;

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctCodeHelper")
    private SbjctCodeHelper sbjctCodeHelper;

    @Resource(name="sbjctTmpltViewFacadeService")
    private SbjctTmpltViewFacadeService sbjctTmpltViewFacadeService;

    @Resource(name="sbjctTmpltExcelHandler")
    private SbjctTmpltExcelHandler sbjctTmpltExcelHandler;

    /**
     * 관리자 과목 목록 화면을 조회한다.
     * @param sbjctTmpltListVO
     * @param model
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctTmpltListView.do")
    public String admSbjctTmpltListView(
            SbjctTmpltListVO sbjctTmpltListVO,
            ModelMap model,
            @CurrentUser UserContext userCtx) throws Exception {

        model.addAllAttributes(sbjctTmpltViewFacadeService.listView(sbjctTmpltListVO, userCtx));

        return "crs/sbjct/adm_sbjct_tmplt_list_view";
    }

    /**
     * 관리자 과목분류 공통코드 목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping("/admSbjctTycdList.do")
    @ResponseBody
    public ResultDTO<CmmnCdVO> admSbjctTycdList(
            CmmnCdVO vo,
            @CurrentUser UserContext userCtx) throws Exception {

        ResultDTO<CmmnCdVO> resultDTO = new ResultDTO<>();
        String orgId = sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx);

        vo.setOrgId(orgId);
        List<CmmnCdVO> sbjctTycdList = sbjctCodeHelper.listCodeWithoutDefault(orgId, "SBJCT_TYCD");
        resultDTO.setReturnList(sbjctTycdList);
        resultDTO.setResultSuccess();

        return resultDTO;
    }

    /**
     * 관리자 과목명/과목코드 중복 여부를 확인한다.
     * @param sbjctTmpltVO
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping("/admSbjctTmpltDupCheck.do")
    @ResponseBody
    public ResultDTO<SbjctTmpltVO> admSbjctTmpltDupCheck(
            SbjctTmpltVO sbjctTmpltVO,
            @CurrentUser UserContext userCtx) throws Exception {

        sbjctTmpltVO.setOrgId(sbjctAuthHelper.resolveSearchOrgId(sbjctTmpltVO.getOrgId(), userCtx));
        return withFailMessage(sbjctTmpltService.checkSbjctTmpltDup(sbjctTmpltVO));
    }

    /**
     * 관리자 과목 목록을 조회한다.
     * @param pageInfo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctTmpltList.do")
    @ResponseBody
    public ResultDTO<SbjctTmpltListVO> admSbjctTmpltList(
            SbjctTmpltPageInfo pageInfo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        pageInfo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());
        ResultDTO<SbjctTmpltListVO> resultDTO = sbjctTmpltService.selectSbjctTmpltList(pageInfo);
        resultDTO.setEncParams(request.getParameter("encParams"));

        return resultDTO;
    }

    /**
     * 관리자 과목 목록을 엑셀로 다운로드한다.
     * @param pageInfo
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctTmpltListExcelDown.do")
    public String admSbjctTmpltListExcelDown(
            SbjctTmpltPageInfo pageInfo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        // 엑셀 다운로드는 목록 화면의 암호화 검색 조건을 PageInfo에 복원한 뒤 조회한다.
        initEncryptedParamContext(request, model, pageInfo);
        String title = getMessage("common.subject.list");/*과목 목록*/
        model.addAllAttributes(sbjctTmpltExcelHandler.listExcel(pageInfo, userCtx, title));

        return "excelView";
    }

    /**
     * 관리자 과목 엑셀 등록 팝업 화면을 조회한다.
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctTmpltExcelUploadPop.do")
    public String admSbjctTmpltExcelUploadPop(
            SbjctTmpltVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {
        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));

        boolean validUploadContext = isValidSbjctTmpltExcelUploadContext(vo);
        if(validUploadContext) {
            vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_SBJCT));
        }
        model.addAllAttributes(sbjctTmpltViewFacadeService.excelUploadPopView(vo, validUploadContext));

        return "crs/sbjct/popup/adm_sbjct_tmplt_excel_upload_popview";
    }

    /**
     * 관리자 과목 엑셀 등록 샘플을 다운로드한다.
     * @param vo
     * @param model
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctTmpltExcelSampleDownload.do")
    public String admSbjctTmpltExcelSampleDownload(
            SbjctTmpltVO vo,
            ModelMap model,
            @CurrentUser UserContext userCtx) throws Exception {

        String title = getMessage("crs.label.crecrs") + " " + getMessage("crs.button.excel.reg");/*과목, 엑셀로 등록*/
        model.addAllAttributes(sbjctTmpltExcelHandler.sampleExcel(
                vo,
                userCtx,
                title,
                getMessage("common.use") + ":Y, " + getMessage("common.use.not") + ":N"));/*사용, 사용 안 함*/

        return "excelView";
    }

    /**
     * 관리자 과목 엑셀 업로드 데이터를 일괄 등록한다.
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctTmpltExcelUpload.do")
    @ResponseBody
    public ResultDTO<SbjctTmpltVO> admSbjctTmpltExcelUpload(
            SbjctTmpltVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        applySbjctTmpltAudit(vo, userCtx);
        ResultDTO<SbjctTmpltVO> resultDTO = sbjctTmpltService.uploadSbjctTmpltExcel(vo);
        if(resultDTO.getResult() <= 0) {
            return withFailMessage(resultDTO);
        }
        return successSave(resultDTO);
    }

    /**
     * 관리자 과목 등록 화면을 조회한다.
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admSbjctTmpltRegistView.do")
    public String admSbjctTmpltRegistView(
            SbjctTmpltVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        String orgId = userCtx.getOrgId();
        String mode = "I";

        if(vo.getSbjctTmpltId() != null && !vo.getSbjctTmpltId().trim().isEmpty()) {
            SbjctTmpltVO detailVO = sbjctTmpltService.selectSbjctTmplt(vo);
            if(detailVO == null || (!sbjctAuthHelper.isSystemAdmin(userCtx) && !userCtx.getOrgId().equals(detailVO.getOrgId()))) {
                return redirectNoAuthToSafeReferer(request, "/crs/sbjctTmplt/admSbjctTmpltListView.do");
            }
            vo = detailVO;
            orgId = sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx);
            vo.setOrgId(orgId);
            mode = "E";
        } else {
            vo.setOrgId(orgId);
            vo.setUseyn("Y");
        }

        model.addAllAttributes(sbjctTmpltViewFacadeService.registView(vo, mode, userCtx));

        return "crs/sbjct/adm_sbjct_tmplt_regist_view";
    }

    /**
     * 관리자 과목을 등록한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctTmpltRegist.do")
    @ResponseBody
    public ResultDTO<SbjctTmpltVO> admSbjctTmpltRegist(
            SbjctTmpltVO vo,
            @CurrentUser UserContext userCtx) {

        applySbjctTmpltAudit(vo, userCtx);
        ResultDTO<SbjctTmpltVO> resultDTO = sbjctTmpltService.insertSbjctTmplt(vo);
        if(resultDTO.getResult() <= 0) {
            return withFailMessage(resultDTO);
        }
        return successSave(resultDTO);
    }

    /**
     * 관리자 과목을 수정한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctTmpltModify.do")
    @ResponseBody
    public ResultDTO<SbjctTmpltVO> admSbjctTmpltModify(
            SbjctTmpltVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctTmpltVO> resultDTO = new ResultDTO<>();
        applySbjctTmpltAudit(vo, userCtx);

        SbjctTmpltVO savedVO = sbjctTmpltService.selectSbjctTmplt(vo);
        if(savedVO == null || (!sbjctAuthHelper.isSystemAdmin(userCtx) && !userCtx.getOrgId().equals(savedVO.getOrgId()))) {
            return noAuthResult(resultDTO);
        }

        resultDTO = sbjctTmpltService.updateSbjctTmplt(vo);
        if(resultDTO.getResult() <= 0) {
            return withFailMessage(resultDTO);
        }
        return successSave(resultDTO);
    }

    /**
     * 과목 목록의 사용 여부를 수정한다.
     * @param sbjctTmpltListVO
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctTmpltUseynModify.do")
    @ResponseBody
    public ResultDTO<SbjctTmpltListVO> admSbjctTmpltUseynModify(
            SbjctTmpltListVO sbjctTmpltListVO,
            @CurrentUser UserContext userCtx) {

        sbjctTmpltListVO.setMdfrId(userCtx.getUserId());
        return withFailMessage(sbjctTmpltService.updateSbjctTmpltUseyn(sbjctTmpltListVO));
    }

    /**
     * 과목 목록에서 선택한 과목을 삭제한다.
     * @param sbjctTmpltListVO
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admSbjctTmpltDelete.do")
    @ResponseBody
    public ResultDTO<Integer> admSbjctTmpltDelete(
            @RequestBody SbjctTmpltListVO sbjctTmpltListVO,
            @CurrentUser UserContext userCtx) {

        sbjctTmpltListVO.setMdfrId(userCtx.getUserId());

        return withFailMessage(sbjctTmpltService.deleteSbjctTmplt(sbjctTmpltListVO));
    }

    /**
     * 과목 저장/수정 시 공통으로 필요한 사용자 감사 정보를 설정한다.
     * @param vo
     * @param userCtx
     */
    private void applySbjctTmpltAudit(SbjctTmpltVO vo, UserContext userCtx) {
        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
    }

    /**
     * 과목 엑셀 업로드 팝업을 열 수 있는 필수 기준값이 모두 전달되었는지 확인한다.
     * @param vo
     * @return
     */
    private boolean isValidSbjctTmpltExcelUploadContext(SbjctTmpltVO vo) {
        return vo != null
                && !isBlank(vo.getOrgId())
                && !isBlank(vo.getSmstrChrtId())
                && !isBlank(vo.getSbjctYr())
                && !isBlank(vo.getSbjctSmstr());
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
