package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsListVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctId; // 과목아이디
    private String dvclasNo; // 분반번호
    private String dscsUnitTycd; // 토론단위유형코드
    private String dscsTtl; // 토론제목

    private String dscsId; // 토론아이디
    private String dscsSdttm; // 토론시작일시
    private String dscsEdttm; // 토론종료일시
    private String mrkRfltyn; // 성적반영여부
    private Integer mrkRfltrt; // 성적반영비율
    private String mrkOyn; // 성적공개여부

    /* DB와 관계없는 파라미터 */
    private Integer dscsAtclCnt; // 게시글 개수
    private Integer dscsCmntCnt; // 댓글 개수
    private Integer dscsUserTotalCnt; // 총 인원 수
    private Integer dscsJoinUserCnt; // 참여자 수
    private Integer dscsEvalCnt; // 평가한 인원수
    private String learnerDscsId; // 학습자 기준 토론아이디
    private String learnerTeamId; // 학습자 팀아이디
    private Integer dscsMyAtclCnt; // 나의 게시글 개수
    private Integer dscsMyCmntCnt; // 나의 댓글 개수
    private Double scr; // 점수
    private Integer dscsFdbkCnt; // 피드백 개수

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getDscsUnitTycd() {
        return dscsUnitTycd;
    }

    public void setDscsUnitTycd(String dscsUnitTycd) {
        this.dscsUnitTycd = dscsUnitTycd;
    }

    public String getDscsTtl() {
        return dscsTtl;
    }

    public void setDscsTtl(String dscsTtl) {
        this.dscsTtl = dscsTtl;
    }

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getDscsSdttm() {
        return dscsSdttm;
    }

    public void setDscsSdttm(String dscsSdttm) {
        this.dscsSdttm = dscsSdttm;
    }

    public String getDscsEdttm() {
        return dscsEdttm;
    }

    public void setDscsEdttm(String dscsEdttm) {
        this.dscsEdttm = dscsEdttm;
    }

    public String getMrkRfltyn() {
        return mrkRfltyn;
    }

    public void setMrkRfltyn(String mrkRfltyn) {
        this.mrkRfltyn = mrkRfltyn;
    }

    public Integer getMrkRfltrt() {
        return mrkRfltrt;
    }

    public void setMrkRfltrt(Integer mrkRfltrt) {
        this.mrkRfltrt = mrkRfltrt;
    }

    public String getMrkOyn() {
        return mrkOyn;
    }

    public void setMrkOyn(String mrkOyn) {
        this.mrkOyn = mrkOyn;
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

    public Integer getDscsUserTotalCnt() {
        return dscsUserTotalCnt;
    }

    public void setDscsUserTotalCnt(Integer dscsUserTotalCnt) {
        this.dscsUserTotalCnt = dscsUserTotalCnt;
    }

    public Integer getDscsJoinUserCnt() {
        return dscsJoinUserCnt;
    }

    public void setDscsJoinUserCnt(Integer dscsJoinUserCnt) {
        this.dscsJoinUserCnt = dscsJoinUserCnt;
    }

    public Integer getDscsEvalCnt() {
        return dscsEvalCnt;
    }

    public void setDscsEvalCnt(Integer dscsEvalCnt) {
        this.dscsEvalCnt = dscsEvalCnt;
    }

    public String getLearnerDscsId() {
        return learnerDscsId;
    }

    public void setLearnerDscsId(String learnerDscsId) {
        this.learnerDscsId = learnerDscsId;
    }

    public String getLearnerTeamId() {
        return learnerTeamId;
    }

    public void setLearnerTeamId(String learnerTeamId) {
        this.learnerTeamId = learnerTeamId;
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

    public Double getScr() {
        return scr;
    }

    public void setScr(Double scr) {
        this.scr = scr;
    }

    public Integer getDscsFdbkCnt() {
        return dscsFdbkCnt;
    }

    public void setDscsFdbkCnt(Integer dscsFdbkCnt) {
        this.dscsFdbkCnt = dscsFdbkCnt;
    }
}