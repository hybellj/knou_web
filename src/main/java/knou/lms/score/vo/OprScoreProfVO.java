package knou.lms.score.vo;

import knou.lms.common.vo.DefaultVO;

public class OprScoreProfVO extends DefaultVO {

    private static final long serialVersionUID = 4349094167990597763L;

    // TB_OPR_SCORE_PROF
    private String lessonScheduleId;
    private String creYear;
    private String creTerm;
    private String crsCd;
    private String declsNo;
    private float  score01;
    private float  score02;
    private float  score03;
    private float  score04;
    private float  score05;
    private float  score06;
    private float  score07;
    private float  score08;
    private float  score09;
    private float  score10;
    private float  score11;
    private float  score12;
    private float  score13;
    private float  score14;
    private float  totScore;
    private String delYn;

    // 추가
    private String  haksaYear;
    private String  haksaTerm;
    private Integer lsnOdr;
    private String  uniCd;
    private String  univGbn;
    private String  univGbnNm;
    private String  deptCd;
    private String  deptNm;
    private String  userNm;
    private String  penaltyYn;

    private String email;
    private String mobileNo;
    private String userTypeDetail;
    private String tchType;

    public String getLessonScheduleId() {
        return lessonScheduleId;
    }

    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }

    public String getCreYear() {
        return creYear;
    }

    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }

    public String getCreTerm() {
        return creTerm;
    }

    public void setCreTerm(String creTerm) {
        this.creTerm = creTerm;
    }

    public String getCrsCd() {
        return crsCd;
    }

    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    public String getDeclsNo() {
        return declsNo;
    }

    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }

    public float getScore01() {
        return score01;
    }

    public void setScore01(float score01) {
        this.score01 = score01;
    }

    public float getScore02() {
        return score02;
    }

    public void setScore02(float score02) {
        this.score02 = score02;
    }

    public float getScore03() {
        return score03;
    }

    public void setScore03(float score03) {
        this.score03 = score03;
    }

    public float getScore04() {
        return score04;
    }

    public void setScore04(float score04) {
        this.score04 = score04;
    }

    public float getScore05() {
        return score05;
    }

    public void setScore05(float score05) {
        this.score05 = score05;
    }

    public float getScore06() {
        return score06;
    }

    public void setScore06(float score06) {
        this.score06 = score06;
    }

    public float getScore07() {
        return score07;
    }

    public void setScore07(float score07) {
        this.score07 = score07;
    }

    public float getScore08() {
        return score08;
    }

    public void setScore08(float score08) {
        this.score08 = score08;
    }

    public float getScore09() {
        return score09;
    }

    public void setScore09(float score09) {
        this.score09 = score09;
    }

    public float getScore10() {
        return score10;
    }

    public void setScore10(float score10) {
        this.score10 = score10;
    }

    public float getScore11() {
        return score11;
    }

    public void setScore11(float score11) {
        this.score11 = score11;
    }

    public float getScore12() {
        return score12;
    }

    public void setScore12(float score12) {
        this.score12 = score12;
    }

    public float getScore13() {
        return score13;
    }

    public void setScore13(float score13) {
        this.score13 = score13;
    }

    public float getTotScore() {
        return totScore;
    }

    public void setTotScore(float totScore) {
        this.totScore = totScore;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getDeptCd() {
        return deptCd;
    }

    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getHaksaYear() {
        return haksaYear;
    }

    public void setHaksaYear(String haksaYear) {
        this.haksaYear = haksaYear;
    }

    public String getHaksaTerm() {
        return haksaTerm;
    }

    public void setHaksaTerm(String haksaTerm) {
        this.haksaTerm = haksaTerm;
    }

    public Integer getLsnOdr() {
        return lsnOdr;
    }

    public void setLsnOdr(Integer lsnOdr) {
        this.lsnOdr = lsnOdr;
    }

    public String getPenaltyYn() {
        return penaltyYn;
    }

    public void setPenaltyYn(String penaltyYn) {
        this.penaltyYn = penaltyYn;
    }

    public String getUniCd() {
        return uniCd;
    }

    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getUserTypeDetail() {
        return userTypeDetail;
    }

    public void setUserTypeDetail(String userTypeDetail) {
        this.userTypeDetail = userTypeDetail;
    }

    public String getTchType() {
        return tchType;
    }

    public void setTchType(String tchType) {
        this.tchType = tchType;
    }

    public float getScore14() {
        return score14;
    }

    public void setScore14(float score14) {
        this.score14 = score14;
    }

    public String getUnivGbn() {
        return univGbn;
    }

    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }

    public String getUnivGbnNm() {
        return univGbnNm;
    }

    public void setUnivGbnNm(String univGbnNm) {
        this.univGbnNm = univGbnNm;
    }

}
