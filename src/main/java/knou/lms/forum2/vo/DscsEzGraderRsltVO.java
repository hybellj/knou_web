package knou.lms.forum2.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class DscsEzGraderRsltVO extends DefaultVO {

    private String orgId;           // 기관 코드

    private String crsCreCd;
    private String forumCd;
    private String evalCd;
    private String forumSendCd;
    private String mutEvalCd;
    private String rltnTeamCd;
    private String evalUserId;
    private String evalTrgtUserId;
    private String qstnNos;
    private String evalScores;
    private int    evalTotal;       // 각 믄항별 총점
    private int    evalScore;       // 성적평가 점수
    private String evalCts;
    private String evalStatusCd;
    private String evalYn;

    private List<String> qstnCdList;
    private List<String> evalScoreList;

    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    public String getDscsId() {
        return forumCd;
    }
    public void setDscsId(String dscsId) {
        this.forumCd = dscsId;
    }
    public String getEvalCd() {
        return evalCd;
    }
    public void setEvalCd(String evalCd) {
        this.evalCd = evalCd;
    }
    public String getForumSendCd() {
        return forumSendCd;
    }
    public void setForumSendCd(String forumSendCd) {
        this.forumSendCd = forumSendCd;
    }
    public String getMutEvalCd() {
        return mutEvalCd;
    }
    public void setMutEvalCd(String mutEvalCd) {
        this.mutEvalCd = mutEvalCd;
    }
    public String getRltnTeamCd() {
        return rltnTeamCd;
    }
    public void setRltnTeamCd(String rltnTeamCd) {
        this.rltnTeamCd = rltnTeamCd;
    }
    public String getEvalUserId() {
        return evalUserId;
    }
    public void setEvalUserId(String evalUserId) {
        this.evalUserId = evalUserId;
    }
    public String getEvalTrgtUserId() {
        return evalTrgtUserId;
    }
    public void setEvalTrgtUserId(String evalTrgtUserId) {
        this.evalTrgtUserId = evalTrgtUserId;
    }
    public String getQstnNos() {
        return qstnNos;
    }
    public void setQstnNos(String qstnNos) {
        this.qstnNos = qstnNos;
    }
    public String getEvalScores() {
        return evalScores;
    }
    public void setEvalScores(String evalScores) {
        this.evalScores = evalScores;
    }
    public int getEvalTotal() {
        return evalTotal;
    }
    public void setEvalTotal(int evalTotal) {
        this.evalTotal = evalTotal;
    }
    public int getEvalScore() {
        return evalScore;
    }
    public void setEvalScore(int evalScore) {
        this.evalScore = evalScore;
    }
    public String getEvalCts() {
        return evalCts;
    }
    public void setEvalCts(String evalCts) {
        this.evalCts = evalCts;
    }
    public String getEvalStatusCd() {
        return evalStatusCd;
    }
    public void setEvalStatusCd(String evalStatusCd) {
        this.evalStatusCd = evalStatusCd;
    }
    public String getEvalYn() {
        return evalYn;
    }
    public void setEvalYn(String evalYn) {
        this.evalYn = evalYn;
    }
    public List<String> getQstnCdList() {
        return qstnCdList;
    }
    public void setQstnCdList(List<String> qstnCdList) {
        this.qstnCdList = qstnCdList;
    }
    public List<String> getEvalScoreList() {
        return evalScoreList;
    }
    public void setEvalScoreList(List<String> evalScoreList) {
        this.evalScoreList = evalScoreList;
    }

}
