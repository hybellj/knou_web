package knou.lms.crs.sbjct.facade.impl;

import knou.framework.common.CommConst;
import knou.framework.context2.UserContext;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.facade.OpenLctrOfringViewFacadeService;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.facade.SbjctCodeHelper;
import knou.lms.crs.sbjct.vo.SbjctAdmVO;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.org.service.OrgInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * 공개강좌개설 화면에 필요한 기관, 코드, 관리자 데이터를 조립한다.
 */
@Service("openLctrOfringViewFacadeService")
public class OpenLctrOfringViewFacadeServiceImpl implements OpenLctrOfringViewFacadeService {

    private static final String OPEN_LCTR_SYSTEM_SBJCT_TYCD = "OPEN_LCTR_SYSTEM";
    private static final String OPEN_CRS_GBNCD = "OPEN_CRS";

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctCodeHelper")
    private SbjctCodeHelper sbjctCodeHelper;

    @Resource(name="sbjctService")
    private SbjctService sbjctService;

    @Autowired
    @Qualifier("orgInfoService")
    private OrgInfoService orgInfoService;

    /**
     * 공개강좌개설 목록 화면에 필요한 기관, 과정구분, 과목분류 데이터를 조립한다.
     * @param sbjctListVO
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Object> listView(SbjctListVO sbjctListVO, UserContext userCtx) throws Exception {
        String orgId = sbjctAuthHelper.resolveSearchOrgId(sbjctListVO.getOrgId(), userCtx);
        boolean fixedOrg = !sbjctAuthHelper.isSystemAdmin(userCtx);
        sbjctListVO.setCrsGbncd(OPEN_CRS_GBNCD);
        sbjctListVO.setSbjctTycd(OPEN_LCTR_SYSTEM_SBJCT_TYCD);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("orgList", sbjctAuthHelper.filterOrgListByRole(orgInfoService.listActiveOrg(), orgId, fixedOrg));
        resultMap.put("crsGbncdList", sbjctCodeHelper.listOpenLctrOfringCode(orgId, "CRS_GBNCD"));
        resultMap.put("sbjctTycdList", sbjctCodeHelper.listOpenLctrOfringCode(orgId, "SBJCT_TYCD"));
        resultMap.put("orgId", orgId);
        resultMap.put("fixedOrgYn", fixedOrg ? "Y" : "N");
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        resultMap.put("sbjctListVO", sbjctListVO);
        return resultMap;
    }

    /**
     * 공개강좌개설 등록/수정 화면에 필요한 기본값과 선택 목록 데이터를 조립한다.
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
        if("I".equals(mode)) {
            sbjctVO.setSbjctTycd(OPEN_LCTR_SYSTEM_SBJCT_TYCD);
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("orgList", sbjctAuthHelper.filterOrgListByRole(orgInfoService.listActiveOrg(), orgId, fixedOrg));
        resultMap.put("sbjctVO", sbjctVO);
        resultMap.put("mode", mode);
        resultMap.put("orgId", orgId);
        resultMap.put("fixedOrgYn", fixedOrg ? "Y" : "N");
        resultMap.put("sbjctTycdList", sbjctCodeHelper.listOpenLctrOfringCode(orgId, "SBJCT_TYCD"));
        resultMap.put("crsGbncdList", sbjctCodeHelper.listOpenLctrOfringCode(orgId, "CRS_GBNCD"));
        resultMap.put("lctrGbncdList", sbjctCodeHelper.listOpenLctrOfringCode(orgId, "LCTR_GBNCD"));
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }

    /**
     * 공개강좌 관리자 등록 화면에 필요한 기관, 사용자유형, 관리자 목록 데이터를 조립한다.
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
        resultMap.put("sbjctAdmTycdList", sbjctCodeHelper.listOpenLctrOfringCode(orgId, "SBJCT_ADM_TYCD"));
        resultMap.put("userTycdList", sbjctCodeHelper.listOpenLctrOfringCode(orgId, "USER_TYCD"));
        resultMap.put("admList", sbjctService.admSbjctOfringAdmList(admSearchVO));
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }

    /**
     * 공개강좌개설 상세 화면에 필요한 과목 정보와 메뉴 데이터를 조립한다.
     * @param detailVO
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> detailView(SbjctVO detailVO, UserContext userCtx) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("sbjctVO", detailVO);
        resultMap.put("sbjctId", detailVO.getSbjctId());
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }

    /**
     * 공개강좌 기본정보 팝업에 표시할 과목 정보와 관리자 목록을 조립한다.
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

}
