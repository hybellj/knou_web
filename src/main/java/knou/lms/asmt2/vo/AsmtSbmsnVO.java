package knou.lms.asmt2.vo;

import knou.lms.common.vo.DefaultVO;

public class AsmtSbmsnVO extends DefaultVO {

    private String asmtSbmsnId; // 과제제출아이디
    private String asmtId; // 과제아이디
    private String teamId; // 팀아이디
    private String sbmsnDttm; // 제출일시
    private String sbmsnTycd; // 제출유형코드
    private String sbmsnCts; // 제출내용
    private String sbmsnTxt; // 제출텍스트
    private String sbmsnStscd; // 제출상태코드
    private Integer sbmsnCnt; // 제출수
    private String cntnIp; // 접속아이피
    private String delyn; // 삭제여부

    public String getAsmtSbmsnId() {
        return asmtSbmsnId;
    }

    public void setAsmtSbmsnId(String asmtSbmsnId) {
        this.asmtSbmsnId = asmtSbmsnId;
    }

    public String getAsmtId() {
        return asmtId;
    }

    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public String getSbmsnDttm() {
        return sbmsnDttm;
    }

    public void setSbmsnDttm(String sbmsnDttm) {
        this.sbmsnDttm = sbmsnDttm;
    }

    public String getSbmsnTycd() {
        return sbmsnTycd;
    }

    public void setSbmsnTycd(String sbmsnTycd) {
        this.sbmsnTycd = sbmsnTycd;
    }

    public String getSbmsnCts() {
        return sbmsnCts;
    }

    public void setSbmsnCts(String sbmsnCts) {
        this.sbmsnCts = sbmsnCts;
    }

    public String getSbmsnTxt() {
        return sbmsnTxt;
    }

    public void setSbmsnTxt(String sbmsnTxt) {
        this.sbmsnTxt = sbmsnTxt;
    }

    public String getSbmsnStscd() {
        return sbmsnStscd;
    }

    public void setSbmsnStscd(String sbmsnStscd) {
        this.sbmsnStscd = sbmsnStscd;
    }

    public Integer getSbmsnCnt() {
        return sbmsnCnt;
    }

    public void setSbmsnCnt(Integer sbmsnCnt) {
        this.sbmsnCnt = sbmsnCnt;
    }

    public String getCntnIp() {
        return cntnIp;
    }

    public void setCntnIp(String cntnIp) {
        this.cntnIp = cntnIp;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }

}
