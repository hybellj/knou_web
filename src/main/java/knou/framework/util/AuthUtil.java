package knou.framework.util;

import knou.framework.context2.UserContext;

public class AuthUtil {

    public static boolean isAdmin(UserContext userCtx) {
    	return userCtx.isAdmin();
    }

    public static boolean isProfessor(UserContext userCtx) {
        return userCtx.isProfessor();
    }

    public static boolean isStudent(UserContext userCtx) {
    	return userCtx.isStudent();
    }
}