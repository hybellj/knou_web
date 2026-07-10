package knou.lms.crs.sbjct.facade;

import knou.framework.common.CommConst;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.org.vo.OrgInfoVO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 과목 화면 조립과 컨트롤러 흐름에서 공통으로 필요한 권한/기관 보정 기능을 제공한다.
 */
@Component("sbjctAuthHelper")
public class SbjctAuthHelper {

    /**
     * 로그인 권한에 따라 실제 조회 기관 아이디를 결정한다.
     */
    public String resolveSearchOrgId(String requestedOrgId, UserContext userCtx) {
        if(isSystemAdmin(userCtx)) {
            return StringUtil.nvl(requestedOrgId, userCtx.getOrgId());
        }
        return userCtx.getOrgId();
    }

    /**
     * 시스템 관리자 권한 여부를 반환한다.
     */
    public boolean isSystemAdmin(UserContext userCtx) {
        return hasAuthrtCd(userCtx, CommConst.AUTHRT_CD_ADM);
    }

    /**
     * 사용자 권한 코드 포함 여부를 반환한다.
     */
    public boolean hasAuthrtCd(UserContext userCtx, String authrtCd) {
        if(userCtx == null) {
            return false;
        }

        String[] authrtCdList = StringUtil.nvl(userCtx.getAuthrtCd()).split("\\|");
        for(String item : authrtCdList) {
            if(authrtCd.equals(item)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 권한에 따라 조회 가능한 기관 목록을 반환한다.
     */
    public List<OrgInfoVO> filterOrgListByRole(List<OrgInfoVO> orgList, String orgId, boolean fixedOrg) {
        if(orgList == null) {
            return new ArrayList<>();
        }
        if(!fixedOrg) {
            return orgList;
        }

        List<OrgInfoVO> filteredList = new ArrayList<>();
        for(OrgInfoVO orgInfoVO : orgList) {
            if(orgId.equals(orgInfoVO.getOrgId())) {
                filteredList.add(orgInfoVO);
            }
        }
        return filteredList;
    }

}
