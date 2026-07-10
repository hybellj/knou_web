package knou.lms.crs.sbjct.web;

import knou.framework.context2.UserContext;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.service.SbjctTmpltService;
import knou.lms.crs.sbjct.excel.OpenLctrOfringExcelHandler;
import knou.lms.crs.sbjct.facade.OpenLctrOfringViewFacadeService;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.facade.SbjctCodeHelper;
import knou.lms.crs.sbjct.vo.SbjctAdmVO;
import knou.lms.crs.sbjct.vo.SbjctListVO;
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

/**
 * 공개강좌개설 관리 화면과 비동기 기능을 제공한다.
 */
@Controller
@RequestMapping(value="/crs/openLctrOfring")
public class OpenLctrOfringController extends SbjctControllerBase {

    // 공개강좌개설은 과목개설 테이블을 사용하되 과목유형을 공개강좌 시스템으로 고정한다.
    private static final String OPEN_LCTR_SYSTEM_SBJCT_TYCD = "OPEN_LCTR_SYSTEM";
    private static final String OPEN_CRS_GBNCD = "OPEN_CRS";

    @Resource(name="sbjctService")
    private SbjctService sbjctService;

    @Resource(name="sbjctTmpltService")
    private SbjctTmpltService sbjctTmpltService;

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctCodeHelper")
    private SbjctCodeHelper sbjctCodeHelper;

    @Resource(name="openLctrOfringViewFacadeService")
    private OpenLctrOfringViewFacadeService openLctrOfringViewFacadeService;

    @Resource(name="openLctrOfringExcelHandler")
    private OpenLctrOfringExcelHandler openLctrOfringExcelHandler;

    /**
     * 공개강좌개설 목록 화면을 표시한다.
     * 관리자 권한에 따라 조회 기관을 고정하거나 전체 기관 선택을 허용한다.
     * @param sbjctListVO
     * @param model
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admOpenLctrOfringListView.do")
    public String admOpenLctrOfringListView(
            SbjctListVO sbjctListVO,
            ModelMap model,
            @CurrentUser UserContext userCtx) throws Exception {

        model.addAllAttributes(openLctrOfringViewFacadeService.listView(sbjctListVO, userCtx));

        return "crs/sbjct/adm_open_lctr_ofring_list_view";
    }

    /**
     * 공개강좌개설 등록/수정 화면을 표시한다.
     * 신규 등록 시 과목유형은 OPEN_LCTR_SYSTEM으로 고정한다.
     * @param sbjctVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admOpenLctrOfringRegistView.do")
    public String admOpenLctrOfringRegistView(
            SbjctVO sbjctVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        String orgId = sbjctAuthHelper.resolveSearchOrgId(sbjctVO.getOrgId(), userCtx);
        String mode = "I";

        if(!isBlank(sbjctVO.getSbjctId())) {
            SbjctVO detailVO = resolveOpenLctrOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
            if(detailVO == null) {
                return redirectNoAuthToSafeReferer(request, "/crs/openLctrOfring/admOpenLctrOfringListView.do");
            }
            sbjctVO = detailVO;
            mode = "E";
        } else {
            sbjctVO.setOrgId(orgId);
        }

        model.addAllAttributes(openLctrOfringViewFacadeService.registView(sbjctVO, mode, userCtx));

        return "crs/sbjct/adm_open_lctr_ofring_regist_view";
    }

    /**
     * 공개강좌 관리자 등록 화면을 표시한다.
     * 기존 과목관리자 저장 로직을 재사용하되 공개강좌 접근 가능 여부를 먼저 확인한다.
     * @param sbjctVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admOpenLctrOfringAdmRegistView.do")
    public String admOpenLctrOfringAdmRegistView(
            SbjctVO sbjctVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        SbjctVO detailVO = resolveOpenLctrOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
        if(detailVO == null) {
            return redirectNoAuthToSafeReferer(request, "/crs/openLctrOfring/admOpenLctrOfringListView.do");
        }

        model.addAllAttributes(openLctrOfringViewFacadeService.admRegistView(detailVO, userCtx));
        model.addAttribute("encParams", getEncParams());

        return "crs/sbjct/adm_open_lctr_ofring_adm_regist_view";
    }

    /**
     * 공개강좌개설 상세 화면을 표시한다.
     * @param sbjctVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringDetailView.do")
    public String admOpenLctrOfringDetailView(
            SbjctVO sbjctVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        SbjctVO detailVO = resolveOpenLctrOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
        if(detailVO == null) {
            return redirectNoAuthToSafeReferer(request, "/crs/openLctrOfring/admOpenLctrOfringListView.do");
        }

        model.addAllAttributes(openLctrOfringViewFacadeService.detailView(detailVO, userCtx));

        return "crs/sbjct/adm_open_lctr_ofring_detail_view";
    }

    /**
     * 목록에서 과목명 클릭 시 표시할 공개강좌 기본정보 팝업을 구성한다.
     * @param sbjctVO
     * @param model
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringBasicInfoPop.do")
    public String admOpenLctrOfringBasicInfoPop(
            SbjctVO sbjctVO,
            ModelMap model,
            @CurrentUser UserContext userCtx) {

        SbjctVO detailVO = resolveOpenLctrOfringViewAccess(sbjctVO.getSbjctId(), userCtx);
        if(detailVO == null) {
            model.addAttribute("message", getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
            return "crs/sbjct/popup/adm_open_lctr_ofring_basic_info_popview";
        }

        model.addAllAttributes(openLctrOfringViewFacadeService.basicInfoPopView(detailVO, userCtx));
        model.addAttribute("encParams", getEncParams());

        return "crs/sbjct/popup/adm_open_lctr_ofring_basic_info_popview";
    }

    /**
     * 공개강좌개설 목록 데이터를 조회한다.
     * @param pageInfo
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringList.do")
    @ResponseBody
    public ResultDTO<SbjctListVO> admOpenLctrOfringList(
            SbjctOfringPageInfo pageInfo,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        pageInfo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());
        pageInfo.setCrsGbncd(OPEN_CRS_GBNCD);
        pageInfo.setSbjctTycd(OPEN_LCTR_SYSTEM_SBJCT_TYCD);
        ResultDTO<SbjctListVO> resultDTO = sbjctService.selectOpenLctrOfringList(pageInfo);
        resultDTO.setEncParams(request.getParameter("encParams"));
        return resultDTO;
    }

    /**
     * 공개강좌개설 목록을 현재 검색조건 기준으로 엑셀 다운로드한다.
     * @param pageInfo
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admOpenLctrOfringListExcelDown.do")
    public String admOpenLctrOfringListExcelDown(
            SbjctOfringPageInfo pageInfo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        // 엑셀 다운로드는 목록 화면의 암호화 검색 조건을 PageInfo에 복원한 뒤 조회한다.
        initEncryptedParamContext(request, model, pageInfo);
        String title = getMessage("crs.open.lctr.ofring.list");/*공개강좌개설 목록*/
        model.addAllAttributes(openLctrOfringExcelHandler.listExcel(pageInfo, userCtx, title));

        return "excelView";
    }

    /**
     * 공개강좌개설 정보를 등록한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringRegist.do")
    @ResponseBody
    public ResultDTO<SbjctVO> admOpenLctrOfringRegist(
            SbjctVO vo,
            @CurrentUser UserContext userCtx) {

        applyAudit(vo, userCtx);
        ResultDTO<SbjctVO> resultDTO = sbjctService.insertOpenLctrOfring(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }
        return successSave(resultDTO);
    }

    /**
     * 공개강좌개설 정보를 수정한다.
     * 저장 전 현재 사용자가 해당 공개강좌 기관에 접근 가능한지 확인한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringModify.do")
    @ResponseBody
    public ResultDTO<SbjctVO> admOpenLctrOfringModify(
            SbjctVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();
        applyAudit(vo, userCtx);
        SbjctVO savedVO = resolveOpenLctrOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }

        vo.setOrgId(savedVO.getOrgId());
        resultDTO = sbjctService.updateOpenLctrOfring(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }
        return successSave(resultDTO);
    }

    /**
     * 공개강좌개설 목록에서 사용여부만 즉시 수정한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringUseynModify.do")
    @ResponseBody
    public ResultDTO<SbjctVO> admOpenLctrOfringUseynModify(
            SbjctVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveOpenLctrOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }

        vo.setMdfrId(userCtx.getUserId());
        resultDTO = sbjctService.updateOpenLctrOfringUseyn(vo);
        if(resultDTO.getResult() < 0) {
            return withFailMessage(resultDTO);
        }
        return successSave(resultDTO);
    }

    /**
     * 공개강좌개설 정보를 삭제 처리한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringDelete.do")
    @ResponseBody
    public ResultDTO<Integer> admOpenLctrOfringDelete(
            SbjctVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<Integer> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveOpenLctrOfringAsyncAccess(vo.getSbjctId(), userCtx);
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
     * 공개강좌 관리자 등록 화면에서 추가할 사용자 후보를 조회한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringAdmUserList.do")
    @ResponseBody
    public ResultDTO<SbjctAdmVO> admOpenLctrOfringAdmUserList(
            SbjctAdmVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctAdmVO> resultDTO = new ResultDTO<>();

        SbjctVO savedVO = resolveOpenLctrOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
        }

        vo.setLangCd(userCtx.getLangCd());
        return sbjctService.admSbjctOfringAdmUserList(vo);
    }

    /**
     * 공개강좌 관리자 목록을 저장한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/admOpenLctrOfringAdmRegist.do")
    @ResponseBody
    public ResultDTO<SbjctAdmVO> admOpenLctrOfringAdmRegist(
            SbjctAdmVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<SbjctAdmVO> resultDTO = new ResultDTO<>();
        SbjctVO savedVO = resolveOpenLctrOfringAsyncAccess(vo.getSbjctId(), userCtx);
        if(savedVO == null) {
            return noAuthResult(resultDTO);
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
     * 공개강좌 화면에서 기관별 공통코드 목록을 조회한다.
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
        if(isBlank(vo.getUpCd())) {
            resultDTO.setReturnList(Collections.emptyList());
            resultDTO.setResultSuccess();
            return resultDTO;
        }

        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));

        resultDTO.setReturnList(sbjctCodeHelper.listOpenLctrOfringCode(vo.getOrgId(), vo.getUpCd()));
        resultDTO.setResultSuccess();
        return resultDTO;
    }

    /**
     * 공개강좌 등록 시 선택 가능한 과목템플릿 목록을 조회한다.
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
        if(isBlank(vo.getSmstrChrtId())) {
            resultDTO.setReturnList(Collections.emptyList());
            resultDTO.setResultSuccess();
            return resultDTO;
        }

        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        return sbjctTmpltService.selectSbjctTmpltOfringList(vo);
    }

    /**
     * 공개강좌 등록 화면의 기관별 학과 목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     */
    /**
     * 공개강좌 저장 요청에 로그인 사용자 기준 등록/수정 정보를 적용한다.
     * @param vo
     * @param userCtx
     */
    private void applyAudit(SbjctVO vo, UserContext userCtx) {
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
