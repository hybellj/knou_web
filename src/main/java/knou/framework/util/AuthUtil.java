package knou.framework.util;

import javax.servlet.http.HttpServletRequest;

import knou.framework.common.SessionInfo;

public class AuthUtil {

    public static boolean isAdmin(HttpServletRequest request) {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        boolean isAdmin = menuType.contains("ADM") ? true : false;

        return isAdmin;
    }

    public static boolean isProfessor(HttpServletRequest request) {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        boolean isProfessor = menuType.contains("PROF");

        return isProfessor;
    }

    public static boolean isTutor(HttpServletRequest request) {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        boolean isTutor = userType.contains("TUT");

        return isTutor;
    }

    public static boolean isStudent(HttpServletRequest request) {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        boolean isStudent = menuType.contains("USR");

        return isStudent;
    }
}
