package knou.lms.user.vo;

import java.util.Date;

import knou.lms.common.vo.DefaultVO;

public class CoachVO extends DefaultVO{
    private static final long serialVersionUID = 1L;
    private String userId;          // 사용자번호
    private String yy;              // 년도
    private String tmGbn;           // 학기구분
    private String tmGbnNm;         // 학기명
    private String ecshgCoachNo;    // 코치사번
    private String counslGvupYn;    // 코치포기여부
    private Date insertAt;          // 등록일시
    private Date modifyAt;          // 수정일시

    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getYy() {
        return yy;
    }
    public void setYy(String yy) {
        this.yy = yy;
    }

    public String getTmGbn() {
        return tmGbn;
    }
    public void setTmGbn(String tmGbn) {
        this.tmGbn = tmGbn;
    }

    public String getTmGbnNm() {
        return tmGbnNm;
    }
    public void setTmGbnNm(String tmGbnNm) {
        this.tmGbnNm = tmGbnNm;
    }

    public String getEcshgCoachNo() {
        return ecshgCoachNo;
    }
    public void setEcshgCoachNo(String ecshgCoachNo) {
        this.ecshgCoachNo = ecshgCoachNo;
    }

    public String getCounslGvupYn() {
        return counslGvupYn;
    }
    public void setCounslGvupYn(String counslGvupYn) {
        this.counslGvupYn = counslGvupYn;
    }

    public Date getInsertAt() {
        return insertAt;
    }
    public void setInsertAt(Date insertAt) {
        this.insertAt = insertAt;
    }

    public Date getModifyAt() {
        return modifyAt;
    }
    public void setModifyAt(Date modifyAt) {
        this.modifyAt = modifyAt;
    }

}
