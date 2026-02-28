package knou.lms.score.vo;

import java.util.Date;

public class ScoreCumVO {
    private static final long serialVersionUID = 1L;
    private String userId;     // 사용자번호
    private float avgMrks;     // 평균평점 
    private float pctScr;      // 백분위점수
    private float cptnHp;      // 취득학점
    private Date insertAt;      // 등록일시
    private Date modifyAt;      // 수정일시

    public String getUserId() {
        return userId;
    }

    public float getAvgMrks() {
        return avgMrks;
    }

    public float getPctScr() {
        return pctScr;
    }

    public float getCptnHp() {
        return cptnHp;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setAvgMrks(float avgMrks) {
        this.avgMrks = avgMrks;
    }

    public void setPctScr(float pctScr) {
        this.pctScr = pctScr;
    }

    public void setCptnHp(float cptnHp) {
        this.cptnHp = cptnHp;
    }

    public Date getInsertAt() {
        return insertAt;
    }

    public Date getModifyAt() {
        return modifyAt;
    }

    public void setInsertAt(Date insertAt) {
        this.insertAt = insertAt;
    }

    public void setModifyAt(Date modifyAt) {
        this.modifyAt = modifyAt;
    }
}
