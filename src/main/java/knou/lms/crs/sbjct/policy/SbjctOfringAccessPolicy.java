package knou.lms.crs.sbjct.policy;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.vo.SbjctVO;

/**
 * 과목개설 후속 단계 접근 정책을 제공한다.
 */
@Service("sbjctOfringAccessPolicy")
public class SbjctOfringAccessPolicy {

    public static final String ATNDLC_CERT_STSCD_APPROVE = "APPROVE";
    public static final String MSG_KEY_NEXT_STEP_APPROVE_REQUIRED =
            "crs.sbjct.ofring.alert.approve.required";/*수강인증상태가 승인이여야 합니다.*/

    @Resource(name="sbjctService")
    private SbjctService sbjctService;

    /**
     * 과목개설 접근 권한 체크용 정보를 조회한다.
     * @param sbjctId
     * @return
     */
    public SbjctVO selectSbjctOfringAccess(String sbjctId) {
        if(StringUtil.isNull(sbjctId)) {
            return null;
        }

        SbjctVO searchVO = new SbjctVO();
        searchVO.setSbjctId(sbjctId);
        return sbjctService.selectSbjctOfringAccess(searchVO);
    }

    /**
     * 로그인 사용자가 과목개설 기관에 접근할 수 있는지 확인한다.
     * @param savedVO
     * @param userCtx
     * @param systemAdmin
     * @return
     */
    public boolean canAccessOrg(SbjctVO savedVO, UserContext userCtx, boolean systemAdmin) {
        if(savedVO == null || userCtx == null) {
            return false;
        }

        return systemAdmin || StringUtil.nvl(userCtx.getOrgId()).equals(savedVO.getOrgId());
    }

    /**
     * 과목개설 후속 단계에 진입할 수 있는지 확인한다.
     * @param savedVO
     * @return
     */
    public boolean canEnterNextStep(SbjctVO savedVO) {
        return savedVO != null
                && ATNDLC_CERT_STSCD_APPROVE.equals(StringUtil.nvl(savedVO.getAtndlcCertStscd()));
    }

    /**
     * 로그인 사용자가 과목개설 후속 단계를 관리할 수 있는지 확인한다.
     * @param savedVO
     * @param userCtx
     * @param systemAdmin
     * @return
     */
    public boolean canManageNextStep(SbjctVO savedVO, UserContext userCtx, boolean systemAdmin) {
        return canAccessOrg(savedVO, userCtx, systemAdmin) && canEnterNextStep(savedVO);
    }
}
