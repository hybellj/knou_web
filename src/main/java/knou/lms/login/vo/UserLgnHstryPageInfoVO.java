package knou.lms.login.vo;

import knou.framework.common.PageInfo;

import java.util.Arrays;
import java.util.stream.Collectors;

public class UserLgnHstryPageInfoVO extends PageInfo {

    private String langCd;
    private String excelGrid;
    private String searchSdttm;
    private String searchEdttm;
    private String acsrTycds;
    private String[] acsrTycdList;
    private String certMthdCd;          // 인증방법코드
    private String userLgnHstryId;      // 사용자로그인이력아이디
    private String userSnsId;           // 사용자SNS연결아이디
    private String acsrTycd;            // 접속자유형코드
    private String lgnIp;               // 로그인아이피
    private String lgnDttm;             // 로그인일시
    private String lgtDttm;             // 로그아웃일시
    private String lgnScsyn;            // 로그인성공여부
    private String cntnDvcTycd;         // 접속기기유형코드
    private String lgnCntnBrwsr;        // 로그인접속브라우저
    private String sessId;              // 세션아이디
    private String lgnFailMsg;          // 로그인실패메시지
    private String traceId;             // 추적아이디

    public void normalizeSearchParams() {
        if(this.acsrTycdList == null || this.acsrTycdList.length == 0) {
            return;
        }

        this.acsrTycds = Arrays.stream(this.acsrTycdList)
                .filter(code -> code != null && !code.trim().isEmpty())
                .map(String::trim)
                .distinct()
                .collect(Collectors.joining(","));
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getExcelGrid() {
        return excelGrid;
    }

    public void setExcelGrid(String excelGrid) {
        this.excelGrid = excelGrid;
    }

    public String getSearchSdttm() {
        return searchSdttm;
    }

    public void setSearchSdttm(String searchSdttm) {
        this.searchSdttm = searchSdttm;
    }

    public String getSearchEdttm() {
        return searchEdttm;
    }

    public void setSearchEdttm(String searchEdttm) {
        this.searchEdttm = searchEdttm;
    }

    public String getAcsrTycds() {
        return acsrTycds;
    }

    public void setAcsrTycds(String acsrTycds) {
        this.acsrTycds = acsrTycds;
    }

    public String[] getAcsrTycdList() {
        return acsrTycdList;
    }

    public void setAcsrTycdList(String[] acsrTycdList) {
        this.acsrTycdList = acsrTycdList;
    }

    public String getCertMthdCd() {
        return certMthdCd;
    }

    public void setCertMthdCd(String certMthdCd) {
        this.certMthdCd = certMthdCd;
    }

    public String getUserLgnHstryId() {
        return userLgnHstryId;
    }

    public void setUserLgnHstryId(String userLgnHstryId) {
        this.userLgnHstryId = userLgnHstryId;
    }

    public String getUserSnsId() {
        return userSnsId;
    }

    public void setUserSnsId(String userSnsId) {
        this.userSnsId = userSnsId;
    }

    public String getAcsrTycd() {
        return acsrTycd;
    }

    public void setAcsrTycd(String acsrTycd) {
        this.acsrTycd = acsrTycd;
    }

    public String getLgnIp() {
        return lgnIp;
    }

    public void setLgnIp(String lgnIp) {
        this.lgnIp = lgnIp;
    }

    public String getLgnDttm() {
        return lgnDttm;
    }

    public void setLgnDttm(String lgnDttm) {
        this.lgnDttm = lgnDttm;
    }

    public String getLgtDttm() {
        return lgtDttm;
    }

    public void setLgtDttm(String lgtDttm) {
        this.lgtDttm = lgtDttm;
    }

    public String getLgnScsyn() {
        return lgnScsyn;
    }

    public void setLgnScsyn(String lgnScsyn) {
        this.lgnScsyn = lgnScsyn;
    }

    public String getCntnDvcTycd() {
        return cntnDvcTycd;
    }

    public void setCntnDvcTycd(String cntnDvcTycd) {
        this.cntnDvcTycd = cntnDvcTycd;
    }

    public String getLgnCntnBrwsr() {
        return lgnCntnBrwsr;
    }

    public void setLgnCntnBrwsr(String lgnCntnBrwsr) {
        this.lgnCntnBrwsr = lgnCntnBrwsr;
    }

    public String getSessId() {
        return sessId;
    }

    public void setSessId(String sessId) {
        this.sessId = sessId;
    }

    public String getLgnFailMsg() {
        return lgnFailMsg;
    }

    public void setLgnFailMsg(String lgnFailMsg) {
        this.lgnFailMsg = lgnFailMsg;
    }

    public String getTraceId() {
        return traceId;
    }

    public void setTraceId(String traceId) {
        this.traceId = traceId;
    }
}
