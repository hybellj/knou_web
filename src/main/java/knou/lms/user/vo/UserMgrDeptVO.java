package knou.lms.user.vo;

public class UserMgrDeptVO {

    private String menuId;      // 메뉴 ID
    private String orgId;       // 기관 ID
    private String orgnm;       // 기관명
    private String deptId;      // 학과/부서 코드
    private String upDeptId;    // 상위 학과/부서 코드
    private String upDeptnm;    // 상위 학과/부서명
    private String deptnm;      // 학과/부서명 (KR)
    private String deptEnnm;    // 학과/부서명 (EN)
    private String orgDeptId;   // 수정 대상 원본 학과/부서 코드 (PK 변경 대응)
    private String searchValue; // 검색어
    private String rgtrId;      // 등록자 ID
    private String mdfrId;      // 수정자 ID

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getOrgnm() {
        return orgnm;
    }

    public void setOrgnm(String orgnm) {
        this.orgnm = orgnm;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getUpDeptId() {
        return upDeptId;
    }

    public void setUpDeptId(String upDeptId) {
        this.upDeptId = upDeptId;
    }

    public String getUpDeptnm() {
        return upDeptnm;
    }

    public void setUpDeptnm(String upDeptnm) {
        this.upDeptnm = upDeptnm;
    }

    public String getDeptnm() {
        return deptnm;
    }

    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }

    public String getDeptEnnm() {
        return deptEnnm;
    }

    public void setDeptEnnm(String deptEnnm) {
        this.deptEnnm = deptEnnm;
    }

    public String getOrgDeptId() {
        return orgDeptId;
    }

    public void setOrgDeptId(String orgDeptId) {
        this.orgDeptId = orgDeptId;
    }

    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }
}
