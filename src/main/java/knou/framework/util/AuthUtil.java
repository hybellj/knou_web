package knou.framework.util;

import knou.framework.context2.UserContext;

public class AuthUtil {

    public static boolean isAdmin(UserContext userCtx) {
        String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

        return menuType.contains("ADM");
    }

    public static boolean isProfessor(UserContext userCtx) {
        String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

        return menuType.contains("PROF");
    }

    public static boolean isTutor(UserContext userCtx) {
        String userType = StringUtil.nvl(userCtx.getAuthrtCd());

        return userType.contains("TUT");
    }

    public static boolean isStudent(UserContext userCtx) {
        String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

        return menuType.contains("USR");
    }
}
