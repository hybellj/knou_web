package knou.lms.evalwgtmng.vo;

import knou.framework.common.PageInfo;

public class EvalWgtMngListVO extends PageInfo {

    private String langCd;   // 언어 코드
    private String menuId;   // 메뉴 ID



    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getHaksaYear() {
        return getDgrsYr();
    }

    public void setHaksaYear(String haksaYear) {
        setDgrsYr(haksaYear);
    }

    public String getHaksaTerm() {
        return getDgrsSmstrChrt();
    }

    public void setHaksaTerm(String haksaTerm) {
        setDgrsSmstrChrt(haksaTerm);
    }
}
