package knou.lms.crs.sbjct.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class SbjctAdmVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctAdmId; // 과목관리자아이디
    private String sbjctId; // 과목아이디
    private String userId; // 사용자아이디
    private String sbjctAdmTycd; // 과목관리자유형코드
    private String rgtrId; // 등록자아이디
    private String regDttm; // 등록일시
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시
    private Integer sbjctAdmSeqno; // 과목관리자순번

    /* DB와 관계없는 파라미터 */
    private String orgId; // 기관아이디
    private String orgnm; // 기관명
    private String deptId; // 학과부서아이디
    private String deptnm; // 학과명
    private String usernm; // 사용자명
    private String stdntNo; // 사번
    private String userTycd; // 사용자유형코드
    private String userTycdnm; // 사용자유형명
    private String mblPhn; // 휴대전화번호
    private String eml; // 이메일
    private String searchValue; // 검색어
    private String langCd; // 언어코드
    private List<SbjctAdmVO> admList; // 과목관리자목록

    public String getSbjctAdmId() {
        return sbjctAdmId;
    }

    public void setSbjctAdmId(String sbjctAdmId) {
        this.sbjctAdmId = sbjctAdmId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getSbjctAdmTycd() {
        return sbjctAdmTycd;
    }

    public void setSbjctAdmTycd(String sbjctAdmTycd) {
        this.sbjctAdmTycd = sbjctAdmTycd;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public Integer getSbjctAdmSeqno() {
        return sbjctAdmSeqno;
    }

    public void setSbjctAdmSeqno(Integer sbjctAdmSeqno) {
        this.sbjctAdmSeqno = sbjctAdmSeqno;
    }

    @Override
    public String getOrgId() {
        return orgId;
    }

    @Override
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getOrgnm() {
        return orgnm;
    }

    public void setOrgnm(String orgnm) {
        this.orgnm = orgnm;
    }

    @Override
    public String getDeptId() {
        return deptId;
    }

    @Override
    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getDeptnm() {
        return deptnm;
    }

    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getUserTycd() {
        return userTycd;
    }

    public void setUserTycd(String userTycd) {
        this.userTycd = userTycd;
    }

    public String getUserTycdnm() {
        return userTycdnm;
    }

    public void setUserTycdnm(String userTycdnm) {
        this.userTycdnm = userTycdnm;
    }

    public String getMblPhn() {
        return mblPhn;
    }

    public void setMblPhn(String mblPhn) {
        this.mblPhn = mblPhn;
    }

    public String getEml() {
        return eml;
    }

    public void setEml(String eml) {
        this.eml = eml;
    }

    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public List<SbjctAdmVO> getAdmList() {
        return admList;
    }

    public void setAdmList(List<SbjctAdmVO> admList) {
        this.admList = admList;
    }
}
