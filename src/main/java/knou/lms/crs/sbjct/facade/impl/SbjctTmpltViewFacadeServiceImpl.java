package knou.lms.crs.sbjct.facade.impl;

import knou.framework.common.CommConst;
import knou.framework.context2.UserContext;
import knou.lms.crs.sbjct.facade.SbjctTmpltViewFacadeService;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.facade.SbjctCodeHelper;
import knou.lms.crs.sbjct.vo.SbjctTmpltListVO;
import knou.lms.crs.sbjct.vo.SbjctTmpltVO;
import knou.lms.org.service.OrgInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * 과목 템플릿 화면에 필요한 기관, 코드, 기본 VO 데이터를 조립한다.
 */
@Service("sbjctTmpltViewFacadeService")
public class SbjctTmpltViewFacadeServiceImpl implements SbjctTmpltViewFacadeService {

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctCodeHelper")
    private SbjctCodeHelper sbjctCodeHelper;

    @Autowired
    @Qualifier("orgInfoService")
    private OrgInfoService orgInfoService;

    /**
     * 과목 목록 화면에 필요한 기관과 검색 조건 데이터를 조립한다.
     * @param sbjctTmpltListVO
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Object> listView(SbjctTmpltListVO sbjctTmpltListVO, UserContext userCtx) throws Exception {
        String orgId = sbjctAuthHelper.resolveSearchOrgId(sbjctTmpltListVO.getOrgId(), userCtx);
        boolean fixedOrg = !sbjctAuthHelper.isSystemAdmin(userCtx);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("orgList", sbjctAuthHelper.filterOrgListByRole(orgInfoService.listActiveOrg(), orgId, fixedOrg));
        resultMap.put("orgId", orgId);
        resultMap.put("fixedOrgYn", fixedOrg ? "Y" : "N");
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        resultMap.put("sbjctTmpltListVO", sbjctTmpltListVO);
        return resultMap;
    }

    /**
     * 과목 엑셀 업로드 팝업에 필요한 업로드 가능 여부와 요청 값을 조립한다.
     * @param vo
     * @param validUploadContext
     * @return
     */
    @Override
    public Map<String, Object> excelUploadPopView(SbjctTmpltVO vo, boolean validUploadContext) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("sbjctTmpltVO", vo);
        resultMap.put("validUploadContext", validUploadContext);
        return resultMap;
    }

    /**
     * 과목 등록/수정 화면에 필요한 기관, 강의형태, 과목분류 데이터를 조립한다.
     * @param vo
     * @param mode
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Object> registView(SbjctTmpltVO vo, String mode, UserContext userCtx) throws Exception {
        String orgId = sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx);
        boolean fixedOrg = !sbjctAuthHelper.isSystemAdmin(userCtx);
        vo.setOrgId(orgId);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("orgList", sbjctAuthHelper.filterOrgListByRole(orgInfoService.listActiveOrg(), orgId, fixedOrg));
        resultMap.put("lctrGbncdList", sbjctCodeHelper.listCodeWithoutDefault(orgId, "LCTR_GBNCD"));
        resultMap.put("sbjctTycdList", sbjctCodeHelper.listCodeWithoutDefault(orgId, "SBJCT_TYCD"));
        resultMap.put("sbjctTmpltVO", vo);
        resultMap.put("mode", mode);
        resultMap.put("orgId", orgId);
        resultMap.put("fixedOrgYn", fixedOrg ? "Y" : "N");
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        return resultMap;
    }
}
