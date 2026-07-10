package knou.lms.crs.sbjct.facade.impl;

import knou.framework.common.CommConst;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.facade.SbjctOfringViewFacadeService;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.facade.SbjctCodeHelper;
import knou.lms.crs.sbjct.vo.SbjctAdmVO;
import knou.lms.crs.sbjct.vo.SbjctAtndlcVO;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctSchdlVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.schedule.service.CalendarService;
import knou.lms.schedule.vo.OrgTaskScheduleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 일반 과목개설 화면에 필요한 기관, 코드, 후속 단계 데이터를 조립한다.
 */
@Service("sbjctOfringViewFacadeService")
public class SbjctOfringViewFacadeServiceImpl implements SbjctOfringViewFacadeService {

    private static final String ATNDLC_APLY_PRD = "ATNDLC_APLY_PRD";
    private static final String LCTR_PLANDOC_ENRL_PRD = "LCTR_PLANDOC_ENRL_PRD";

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctCodeHelper")
    private SbjctCodeHelper sbjctCodeHelper;

    @Resource(name="sbjctService")
    private SbjctService sbjctService;

    @Resource(name="calendarService")
    private CalendarService calendarService;

    @Autowired
    @Qualifier("orgInfoService")
    private OrgInfoService orgInfoService;

    /**
     * 과목개설 목록 화면에 필요한 기관, 과정구분, 과목분류 데이터를 조립한다.
     * @param sbjctListVO
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Object> listView(SbjctListVO sbjctListVO, UserContext userCtx) throws Exception {
        String orgId = sbjctAuthHelper.resolveSearchOrgId(sbjctListVO.getOrgId(), userCtx);
        boolean fixedOrg = !sbjctAuthHelper.isSystemAdmin(userCtx);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("orgList", sbjctAuthHelper.filterOrgListByRole(orgInfoService.listActiveOrg(), orgId, fixedOrg));
        resultMap.put("crsGbncdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "CRS_GBNCD"));
        resultMap.put("sbjctTycdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "SBJCT_TYCD"));
        resultMap.put("orgId", orgId);
        resultMap.put("fixedOrgYn", fixedOrg ? "Y" : "N");
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        resultMap.put("sbjctListVO", sbjctListVO);
        return resultMap;
    }

    /**
     * 과목개설 등록/수정 화면에 필요한 기본값과 선택 목록 데이터를 조립한다.
     * @param sbjctVO
     * @param mode
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Object> registView(SbjctVO sbjctVO, String mode, UserContext userCtx) throws Exception {
        String orgId = sbjctAuthHelper.resolveSearchOrgId(sbjctVO.getOrgId(), userCtx);
        boolean fixedOrg = !sbjctAuthHelper.isSystemAdmin(userCtx);
        sbjctVO.setOrgId(orgId);
        applyRegistAtndlcAplyPeriod(sbjctVO, mode, orgId);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("orgList", sbjctAuthHelper.filterOrgListByRole(orgInfoService.listActiveOrg(), orgId, fixedOrg));
        resultMap.put("sbjctVO", sbjctVO);
        resultMap.put("mode", mode);
        resultMap.put("orgId", orgId);
        resultMap.put("fixedOrgYn", fixedOrg ? "Y" : "N");
        resultMap.put("crsGbncdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "CRS_GBNCD"));
        resultMap.put("sbjctTycdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "SBJCT_TYCD"));
        resultMap.put("lctrGbncdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "LCTR_GBNCD"));
        resultMap.put("cmcrsGbncdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "CMCRS_GBNCD"));
        resultMap.put("evlGbncdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "EVL_GBNCD"));
        resultMap.put("lctrFrmtGbncdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "LCTR_FRMT_GBNCD"));
        resultMap.put("lrnCntrlGbncdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "LRN_CNTRL_GBNCD"));
        resultMap.put("atndlcAplyMthdCdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "ATNDLC_APLY_MTHD_CD"));
        resultMap.put("atndlcCertStscdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "ATNDLC_CERT_STSCD"));
        resultMap.put("rvwPsblGbncdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "RVW_PSBL_GBNCD"));
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }

    /**
     * 등록 화면 최초 진입 시 기관 업무일정 기준 수강신청기간을 세팅한다.
     * @param sbjctVO
     * @param mode
     * @param orgId
     */
    private void applyRegistAtndlcAplyPeriod(SbjctVO sbjctVO, String mode, String orgId) {
        if(!"I".equals(mode)) {
            return;
        }

        OrgTaskScheduleVO schdlVO = calendarService.orgTaskSchdlSelect(orgId, ATNDLC_APLY_PRD);
        sbjctVO.setAtndlcAplySdttm(schdlVO == null || schdlVO.getTaskSdttm() == null ? "" : schdlVO.getTaskSdttm());
        sbjctVO.setAtndlcAplyEdttm(schdlVO == null || schdlVO.getTaskEdttm() == null ? "" : schdlVO.getTaskEdttm());
    }

    /**
     * 과목개설 상세 화면에 필요한 과목 정보와 메뉴 데이터를 조립한다.
     * @param detailVO
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> detailView(SbjctVO detailVO, UserContext userCtx) {
        detailVO.setOrgId(sbjctAuthHelper.resolveSearchOrgId(detailVO.getOrgId(), userCtx));

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("sbjctVO", detailVO);
        resultMap.put("sbjctId", detailVO.getSbjctId());
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }

    /**
     * 과목개설 기본정보 팝업에 표시할 과목 정보와 관리자 목록을 조립한다.
     * @param detailVO
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> basicInfoPopView(SbjctVO detailVO, UserContext userCtx) {
        SbjctAdmVO admSearchVO = new SbjctAdmVO();
        admSearchVO.setSbjctId(detailVO.getSbjctId());
        admSearchVO.setLangCd(userCtx.getLangCd());

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("sbjctVO", detailVO);
        resultMap.put("admList", sbjctService.admSbjctOfringAdmList(admSearchVO));
        return resultMap;
    }

    /**
     * 과목개설 주차 기간 설정 화면에 필요한 과목 정보와 일정 목록을 조립한다.
     * @param detailVO
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> schdlRegistView(SbjctVO detailVO, UserContext userCtx) {
        String orgId = sbjctAuthHelper.resolveSearchOrgId(detailVO.getOrgId(), userCtx);
        detailVO.setOrgId(orgId);
        List<SbjctSchdlVO> schdlList = sbjctService.selectSbjctOfringSchdlList(detailVO);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("sbjctVO", detailVO);
        resultMap.put("sbjctId", detailVO.getSbjctId());
        resultMap.put("schdlList", schdlList);
        resultMap.put("schdlSavedYn", hasSavedSbjctSchdl(schdlList) ? "Y" : "N");
        resultMap.put("schdlEditableYn", isBeforeLctrPlandocEnrlPrd(orgId) ? "Y" : "N");
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }

    /**
     * 강의계획서 등록기간 시작 전인지 확인한다.
     * @param orgId
     * @return
     */
    private boolean isBeforeLctrPlandocEnrlPrd(String orgId) {
        OrgTaskScheduleVO schdlVO = calendarService.orgTaskSchdlSelect(orgId, LCTR_PLANDOC_ENRL_PRD);
        return schdlVO != null
                && schdlVO.getTaskSdttm() != null
                && schdlVO.getTaskSdttm().matches("\\d{14}")
                && DateTimeUtil.getCurrentString().compareTo(schdlVO.getTaskSdttm()) < 0;
    }

    /**
     * 과목관리자 등록 화면에 필요한 기관, 사용자유형, 관리자 목록 데이터를 조립한다.
     * @param detailVO
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Object> admRegistView(SbjctVO detailVO, UserContext userCtx) throws Exception {
        String orgId = sbjctAuthHelper.resolveSearchOrgId(detailVO.getOrgId(), userCtx);
        boolean fixedOrg = !sbjctAuthHelper.isSystemAdmin(userCtx);
        SbjctAdmVO admSearchVO = new SbjctAdmVO();
        admSearchVO.setSbjctId(detailVO.getSbjctId());
        admSearchVO.setLangCd(userCtx.getLangCd());

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("orgList", sbjctAuthHelper.filterOrgListByRole(orgInfoService.listActiveOrg(), orgId, fixedOrg));
        resultMap.put("sbjctVO", detailVO);
        resultMap.put("sbjctId", detailVO.getSbjctId());
        resultMap.put("orgId", orgId);
        resultMap.put("fixedOrgYn", fixedOrg ? "Y" : "N");
        resultMap.put("sbjctAdmTycdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "SBJCT_ADM_TYCD"));
        resultMap.put("userTycdList", sbjctCodeHelper.listSbjctOfringCode(orgId, "USER_TYCD"));
        resultMap.put("admList", sbjctService.admSbjctOfringAdmList(admSearchVO));
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }

    /**
     * 수강생 등록 화면에 필요한 기관, 과목 정보, 수강생 목록 데이터를 조립한다.
     * @param detailVO
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Object> stdntRegistView(SbjctVO detailVO, UserContext userCtx) throws Exception {
        SbjctAtndlcVO atndlcSearchVO = new SbjctAtndlcVO();
        atndlcSearchVO.setSbjctId(detailVO.getSbjctId());
        atndlcSearchVO.setLangCd(userCtx.getLangCd());

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("sbjctVO", detailVO);
        resultMap.put("sbjctId", detailVO.getSbjctId());
        resultMap.put("atndlcList", sbjctService.admSbjctOfringStdntList(atndlcSearchVO));
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }

    /**
     * 수강생 엑셀 업로드 팝업에 필요한 업로드 가능 여부와 요청 값을 조립한다.
     * @param vo
     * @param validUploadContext
     * @return
     */
    @Override
    public Map<String, Object> stdntExcelUploadPop(SbjctAtndlcVO vo, boolean validUploadContext) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("validUploadContext", validUploadContext);
        resultMap.put("sbjctAtndlcVO", vo);
        return resultMap;
    }

    /**
     * 주차 기간 설정 화면에서 기존 저장 여부를 표시하기 위해 저장된 일정 ID 존재 여부를 확인한다.
     */
    private boolean hasSavedSbjctSchdl(List<SbjctSchdlVO> schdlList) {
        if(schdlList == null) {
            return false;
        }
        for(SbjctSchdlVO schdlVO : schdlList) {
            if(schdlVO != null && schdlVO.getSbjctSchdlId() != null && !schdlVO.getSbjctSchdlId().trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }
}
