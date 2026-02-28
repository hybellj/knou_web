package knou.lms.crs.home.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class CrsHomeVO extends DefaultVO {

    private static final long serialVersionUID = 6917694481612141051L;

    private List<CrsHomeMenuVO> menuList;
    private List<CrsHomeBbsMenuVO> bbsMenuList;
    
    public List<CrsHomeMenuVO> getMenuList() {
        return menuList;
    }
    public void setMenuList(List<CrsHomeMenuVO> menuList) {
        this.menuList = menuList;
    }
    public List<CrsHomeBbsMenuVO> getBbsMenuList() {
        return bbsMenuList;
    }
    public void setBbsMenuList(List<CrsHomeBbsMenuVO> bbsMenuList) {
        this.bbsMenuList = bbsMenuList;
    }
}
