package knou.lms.msg.web.util;

import knou.framework.context2.UserContext;
import knou.framework.util.AuthUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;

public class MsgAuthUtil extends AuthUtil {

    // 교수 검색 제약 (교수: orgId + userId 강제, 관리자: orgId 비어있으면 기본값)
    public static void applyProfConstraints(DefaultVO vo, UserContext userCtx) {
        if (isProfessor(userCtx) && !isAdmin(userCtx)) {
            vo.setOrgId(userCtx.getOrgId());
            vo.setUserId(userCtx.getUserId());
        } else if ("".equals(StringUtil.nvl(vo.getOrgId()))) {
            vo.setOrgId(userCtx.getOrgId());
        }
    }

    // 템플릿 조회 권한 (관리자: 전체, 교수: 본인 등록 또는 기관공통)
    public static String getTmpltAccessAuth(UserContext userCtx, String rgtrId, String msgCtsGbncd, String tmpltOrgId) {
        String auth = "N";
        String userId = userCtx.getUserId();
        String orgId = userCtx.getOrgId();

        if (isAdmin(userCtx)) {
            auth = "Y";
        } else if (isProfessor(userCtx)) {
            boolean isOwner = StringUtil.nvl(userId).equals(rgtrId);
            boolean isOrgMsg = "ORG_MSG".equals(msgCtsGbncd) && StringUtil.nvl(orgId).equals(tmpltOrgId);

            if (isOwner || isOrgMsg) {
                auth = "Y";
            }
        }

        return auth;
    }

    // 템플릿 수정 권한 (관리자: 기관공통 포함 전체, 교수: 본인 등록만)
    public static String getTmpltEditAuth(UserContext userCtx, String rgtrId, String msgCtsGbncd) {
        String auth = "N";
        String userId = userCtx.getUserId();

        if (isAdmin(userCtx)) {
            auth = "Y";
        } else if (isProfessor(userCtx)) {
            if ("ORG_MSG".equals(msgCtsGbncd)) {
                auth = "N";
            } else {
                if (StringUtil.nvl(userId).equals(rgtrId)) {
                    auth = "Y";
                }
            }
        }

        return auth;
    }

    // 쪽지 발신 접근 권한 (관리자: 전체, 비관리자: 본인 발신만)
    public static String getShrtntSndngAuth(UserContext userCtx, String sndngrId) {
        String auth = "N";
        String userId = userCtx.getUserId();

        if (isAdmin(userCtx)) {
            auth = "Y";
        } else {
            if (StringUtil.nvl(userId).equals(sndngrId)) {
                auth = "Y";
            }
        }

        return auth;
    }
}
