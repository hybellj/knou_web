package knou.lms.seminar.api.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import knou.lms.seminar.api.users.Role;

@Component
public class ZoomOAuthAppType {
    
    @Autowired
    private ZoomOAuthManager oAuthManager;
    
    public static final int ACCOUNT_LEVEL_APP = 0;
    public static final int USER_MANAGED_APP = 1;

    /**
     * ZOOM에서 OAuth APP을 생성할 때 "Accoutn-level app" 과 "User-managed app"을 선택한다.<br>
     * 두가지 APP에 따라 사용자는 사용할 수 있는 API가 다르다.<br>
     * <br>
     * Account-level app : 모든 사용자를 관리할 수 있는 APP으로 "admin"이 부여된 사용자만 사용할 수 있다.<br>
     * 따라서, "admin"이 부여된 사용자의 Access token을 사용해야한다.<br>
     * ZOOM API중 scope에 admin으로 표기된 API 사용할 수 있다.<br>
     * <br>
     * User-managed app : 자신의 데이터만 사용할 수 있다.<br>
     * ZOOM API중 scope에 admin으로 표기된 API는 사용할 수 없다.
     *  
     * @param appType "ACCOUNT_LEVEL_APP" 또는 "USER_MANAGED_APP"
     * @return
     */
    public ZoomOAuthManager getOAuthManager(int appType) {
        oAuthManager.chooseAppType(appType);
        return oAuthManager;
    }
    
    /**
     * 사용자의 Role에 따라 OAuth APP type을 반환한다.
     * 
     * @param role ZOOM의 Role
     * @return ZOOM의 OAuth APP type
     */
    public int getAppType(String role) {
        if (Role.MEMBER.getRoleName().equals(role)) {
            return USER_MANAGED_APP;
        } else if (Role.OWNER.getRoleName().equals(role) || Role.ADMIN.getRoleName().equals(role)) {
            return ACCOUNT_LEVEL_APP;
        } else {
            throw new IllegalArgumentException("Illegal role value for app type. role=" + role);
        }
    }

}
