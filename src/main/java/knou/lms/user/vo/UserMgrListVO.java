package knou.lms.user.vo;

import knou.framework.common.PageInfo;

public class UserMgrListVO extends PageInfo {

    private String menuId;        // 메뉴 ID
    private String authrtGrpcd;   // 관리자 구분 검색 (권한그룹코드)
    private String userTycd;      // 사용자 구분 검색 (USER_TYCD)

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getAuthrtGrpcd() {
        return authrtGrpcd;
    }

    public void setAuthrtGrpcd(String authrtGrpcd) {
        this.authrtGrpcd = authrtGrpcd;
    }

    public String getUserTycd() {
        return userTycd;
    }

    public void setUserTycd(String userTycd) {
        this.userTycd = userTycd;
    }
}
