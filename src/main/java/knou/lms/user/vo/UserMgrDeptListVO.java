package knou.lms.user.vo;

import knou.framework.common.PageInfo;

public class UserMgrDeptListVO extends PageInfo {

    private String menuId;   // 메뉴 ID

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }
}
