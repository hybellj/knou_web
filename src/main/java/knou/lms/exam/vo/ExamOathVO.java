package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamOathVO extends DefaultVO {
    
	private static final long serialVersionUID = 591482341043588348L;
	
	/** tb_lms_exam_oath */
    private String  oathCd;         // 서약서 고유번호
    private String  haksaYear;      // 학사 년도
    private String  haksaTerm;      // 학사 학기
    private String  midOath;        // 중간고사 서약
    private String  endOath;        // 기말고사 서약
    
    private String  deptNm;         // 학과명
    private Integer totStdCnt;      // 과목 수강생 수
    private String  stdId;          // 학습자 번호
    
    public String getOathCd() {
        return oathCd;
    }
    public void setOathCd(String oathCd) {
        this.oathCd = oathCd;
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
    public String getMidOath() {
        return midOath;
    }
    public void setMidOath(String midOath) {
        this.midOath = midOath;
    }
    public String getEndOath() {
        return endOath;
    }
    public void setEndOath(String endOath) {
        this.endOath = endOath;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public Integer getTotStdCnt() {
        return totStdCnt;
    }
    public void setTotStdCnt(Integer totStdCnt) {
        this.totStdCnt = totStdCnt;
    }
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdNo) {
        this.stdId = stdNo;
    }

}
