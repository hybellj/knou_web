package knou.lms.msg.web.util;

import knou.framework.context2.UserContext;
import knou.framework.util.AuthUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;

public class MsgAuthUtil extends AuthUtil {

    public static void applyOrgScope(DefaultVO vo, UserContext userCtx) {
        if (!isAdmin(userCtx)) {
            vo.setOrgId(userCtx.getOrgId());
        }
    }


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

}
