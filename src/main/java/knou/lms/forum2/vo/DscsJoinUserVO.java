package knou.lms.forum2.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class DscsJoinUserVO extends DefaultVO {
    private static final long serialVersionUID = 2877017439237698606L;

    private String sbjctId; // 과목아이디
    private String stdId; // 사용자아이디
    private String stdntNo; // 학번
    private String stdIds; // 사용자아이디 목록
    private String ptcpTargets; // 참여자 처리 대상 목록
    private List<String> stdIdList; // 사용자아이디 목록

    private String dscsId; // 토론아이디
    private String teamId; // 팀아이디
    private Double scr; // 점수
    private String scrNull; // 점수 표시값
    private String leaderYn; // 리더여부
    private String evlyn; // 평가여부
    private String profMemo; // 교수메모
    private String dscsFdbkCts; // 토론피드백내용
    private String oknokGbnCd; // 찬성반대구분코드

    private String scoreType; // 점수처리유형
    private String joinStatus; // 참여상태

    private Integer actlCnt; // 게시글 수
    private Integer cmntCnt; // 댓글 수

    private String dscsFdbkId; // 토론피드백아이디
    private Integer dscsFdbkCnt; // 토론피드백 수
    private Integer dscsAtclCnt; // 게시글 수
    private Integer dscsCmntCnt; // 댓글 수
    private Integer dscsMyAtclCnt; // 내 게시글 수
    private Integer dscsMyCmntCnt; // 내 댓글 수

    private String scoreArr; // 개별 점수 목록
    private String conditionType; // 점수처리 조건유형

    private String deptNm; // 학과부서명
    private String teamnm; // 팀명
    private String memberRole; // 역할
    private String dscsUnitTycd; // 토론단위유형코드

    private String mobileNo; // 휴대전화번호
    private String email; // 이메일

    private Long ctsLen; // 글자수
    private String chkCmnt; // 댓글포함여부

    private String dscsPtcpId; // 토론참여아이디

    public String getDscsPtcpId() {
        return dscsPtcpId;
    }

    public void setDscsPtcpId(String dscsPtcpId) {
        this.dscsPtcpId = dscsPtcpId;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public Double getScr() {
        return scr;
    }

    public void setScr(Double scr) {
        this.scr = scr;
    }

    public String getEvlyn() {
        return evlyn;
    }

    public void setEvlyn(String evlyn) {
        this.evlyn = evlyn;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getStdIds() {
        return stdIds;
    }

    public void setStdIds(String stdIds) {
        this.stdIds = stdIds;
    }

    public String getPtcpTargets() {
        return ptcpTargets;
    }

    public void setPtcpTargets(String ptcpTargets) {
        this.ptcpTargets = ptcpTargets;
    }

    public String getScoreType() {
        return scoreType;
    }

    public void setScoreType(String scoreType) {
        this.scoreType = scoreType;
    }

    public String getJoinStatus() {
        return joinStatus;
    }

    public void setJoinStatus(String joinStatus) {
        this.joinStatus = joinStatus;
    }

    public Integer getActlCnt() {
        return actlCnt;
    }

    public void setActlCnt(Integer actlCnt) {
        this.actlCnt = actlCnt;
    }

    public Integer getCmntCnt() {
        return cmntCnt;
    }

    public void setCmntCnt(Integer cmntCnt) {
        this.cmntCnt = cmntCnt;
    }

    public List<String> getStdIdList() {
        return stdIdList;
    }

    public void setStdIdList(List<String> stdIdList) {
        this.stdIdList = stdIdList;
    }

    public String getScoreArr() {
        return scoreArr;
    }

    public void setScoreArr(String scoreArr) {
        this.scoreArr = scoreArr;
    }

    public String getConditionType() {
        return conditionType;
    }

    public void setConditionType(String conditionType) {
        this.conditionType = conditionType;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getProfMemo() {
        return profMemo;
    }

    public void setProfMemo(String profMemo) {
        this.profMemo = profMemo;
    }

    public String getDscsFdbkCts() {
        return dscsFdbkCts;
    }

    public void setDscsFdbkCts(String dscsFdbkCts) {
        this.dscsFdbkCts = dscsFdbkCts;
    }

    public String getOknokGbnCd() {
        return oknokGbnCd;
    }

    public void setOknokGbnCd(String oknokGbnCd) {
        this.oknokGbnCd = oknokGbnCd;
    }

    public String getTeamnm() {
        return teamnm;
    }

    public void setTeamnm(String teamnm) {
        this.teamnm = teamnm;
    }

    public String getMemberRole() {
        return memberRole;
    }

    public void setMemberRole(String memberRole) {
        this.memberRole = memberRole;
    }

    public String getLeaderYn() {
        return leaderYn;
    }

    public void setLeaderYn(String leaderYn) {
        this.leaderYn = leaderYn;
    }

    public String getDscsUnitTycd() {
        return dscsUnitTycd;
    }

    public void setDscsUnitTycd(String dscsUnitTycd) {
        this.dscsUnitTycd = dscsUnitTycd;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Long getCtsLen() {
        return ctsLen;
    }

    public void setCtsLen(Long ctsLen) {
        this.ctsLen = ctsLen;
    }

    public String getChkCmnt() {
        return chkCmnt;
    }

    public void setChkCmnt(String chkCmnt) {
        this.chkCmnt = chkCmnt;
    }

    public String getDscsFdbkId() {
        return dscsFdbkId;
    }

    public void setDscsFdbkId(String dscsFdbkId) {
        this.dscsFdbkId = dscsFdbkId;
    }

    public Integer getDscsFdbkCnt() {
        return dscsFdbkCnt;
    }

    public void setDscsFdbkCnt(Integer dscsFdbkCnt) {
        this.dscsFdbkCnt = dscsFdbkCnt;
    }

    public Integer getDscsAtclCnt() {
        return dscsAtclCnt;
    }

    public void setDscsAtclCnt(Integer dscsAtclCnt) {
        this.dscsAtclCnt = dscsAtclCnt;
    }

    public Integer getDscsCmntCnt() {
        return dscsCmntCnt;
    }

    public void setDscsCmntCnt(Integer dscsCmntCnt) {
        this.dscsCmntCnt = dscsCmntCnt;
    }

    public Integer getDscsMyAtclCnt() {
        return dscsMyAtclCnt;
    }

    public void setDscsMyAtclCnt(Integer dscsMyAtclCnt) {
        this.dscsMyAtclCnt = dscsMyAtclCnt;
    }

    public Integer getDscsMyCmntCnt() {
        return dscsMyCmntCnt;
    }

    public void setDscsMyCmntCnt(Integer dscsMyCmntCnt) {
        this.dscsMyCmntCnt = dscsMyCmntCnt;
    }

    public String getScrNull() {
        return scrNull;
    }

    public void setScrNull(String scrNull) {
        this.scrNull = scrNull;
    }
}
