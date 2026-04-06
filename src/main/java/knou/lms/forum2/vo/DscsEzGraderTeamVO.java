package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;
import knou.lms.forum2.vo.DscsJoinUserVO;

import java.util.List;

public class DscsEzGraderTeamVO extends DefaultVO {

    private String formCd;
    private String orgId;           // 기관 코드
    private String sbjctId;

    private String teamCtgrCd;
    private String teamCtgrNm;
    private String teamTycd;
    private String teamId;
    private String teamNm;
    private String asmntSubmitStatusCd;
    private int    score;
    private String teamStdIds;      // 팀원의 stdNo(, 로 연결된 문자열)
    private String evalYn;
    private String submitStdNo;     // 제출자의 학생번호(팀장이 아닌 팀원이 제출 할수도 있음.)

    private List<DscsJoinUserVO> teamMembers;

    // 파일 업로드
//    private List<SysFileVO> attachFiles; // 관련서류첨부 파일목록

    public String getFormCd() {
        return formCd;
    }

    public void setFormCd(String formCd) {
        this.formCd = formCd;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getTeamCtgrCd() {
        return teamCtgrCd;
    }

    public void setTeamCtgrCd(String teamCtgrCd) {
        this.teamCtgrCd = teamCtgrCd;
    }

    public String getTeamTycd() {
        return teamTycd;
    }

    public void setTeamTycd(String teamTycd) {
        this.teamTycd = teamTycd;
    }

    public String getTeamCtgrNm() {
        return teamCtgrNm;
    }

    public void setTeamCtgrNm(String teamCtgrNm) {
        this.teamCtgrNm = teamCtgrNm;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public String getTeamNm() {
        return teamNm;
    }

    public void setTeamNm(String teamNm) {
        this.teamNm = teamNm;
    }

    public String getAsmntSubmitStatusCd() {
        return asmntSubmitStatusCd;
    }

    public void setAsmntSubmitStatusCd(String asmntSubmitStatusCd) {
        this.asmntSubmitStatusCd = asmntSubmitStatusCd;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getTeamStdIds() {
        return teamStdIds;
    }

    public void setTeamStdIds(String teamStdIds) {
        this.teamStdIds = teamStdIds;
    }

    public String getEvalYn() {
        return evalYn;
    }

    public void setEvalYn(String evalYn) {
        this.evalYn = evalYn;
    }

    public String getSubmitStdNo() {
        return submitStdNo;
    }

    public void setSubmitStdNo(String submitStdNo) {
        this.submitStdNo = submitStdNo;
    }

    public List<DscsJoinUserVO> getTeamMembers() {
        return teamMembers;
    }

    public void setTeamMembers(List<DscsJoinUserVO> teamMembers) {
        this.teamMembers = teamMembers;
    }

}
