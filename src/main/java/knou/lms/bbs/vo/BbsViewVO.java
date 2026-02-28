package knou.lms.bbs.vo;

import knou.lms.common.vo.DefaultVO;

public class BbsViewVO extends DefaultVO {

    private static final long serialVersionUID = 2346357379043712095L;
    
    // TB_HOME_BBS_VIEW
    private String viewId;
    private String atclId;
    private int    hits;
    private String lastInqDttm;
    private String regNm;
    private String regDttm;

    // 추가
    private String userNm;
    private String userGrade;
    private String deptNm;
    private String userId;
    private String studentYn;

    private String userAcntId;
    
    public String getViewId() {
        return viewId;
    }

    public void setViewId(String viewId) {
        this.viewId = viewId;
    }

    public String getAtclId() {
        return atclId;
    }

    public void setAtclId(String atclId) {
        this.atclId = atclId;
    }

    public int getHits() {
        return hits;
    }

    public void setHits(int hits) {
        this.hits = hits;
    }

    public String getLastInqDttm() {
        return lastInqDttm;
    }

    public void setLastInqDttm(String lastInqDttm) {
        this.lastInqDttm = lastInqDttm;
    }

    public String getRegNm() {
        return regNm;
    }

    public void setRegNm(String regNm) {
        this.regNm = regNm;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getUserGrade() {
        return userGrade;
    }

    public void setUserGrade(String userGrade) {
        this.userGrade = userGrade;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getStudentYn() {
        return studentYn;
    }

    public void setStudentYn(String studentYn) {
        this.studentYn = studentYn;
    }

	public String getUserAcntId() {
		return userAcntId;
	}

	public void setUserAcntId(String userAcntId) {
		this.userAcntId = userAcntId;
	}

}