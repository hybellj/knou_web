package knou.lms.erp.vo;

import java.util.Date;

import knou.lms.common.vo.DefaultVO;

public class ErpEnrollmentVO extends DefaultVO {
	
	private static final long serialVersionUID = 1L;
	
	private String studentId;		    // 학번
	private String year;			        // 년도
	private String semester;		     // 학기 1학기, 여름학기, 2학기, 겨울학기
	private String courseCode;		   // 학수번호
	private String section;			   // 분반
	private String enrollYn;		       // 수강신청
	private String auditYn;			   // 승인
	private String repeatYn;
	private String midLtsatsfClsYn;  
	private String ltsatsfClsYn;	       
	private Date insertAt;	                // 저장일시
	private Date modifyAt;                 // 수정일시
	private String insertExcelAt;                  // 저장일시
	private String modifyExcelAt;                 // 수정일시
	private String midOathYn;
	private String finOathYn;
	private String termCd;
    private int order;
    
	public String getStudentId() {
		return studentId;
	}
	public void setStudentId(String studentId) {
		this.studentId = studentId;
	}

	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}

	public String getSemester() {
		return semester;
	}
	public void setSemester(String semester) {
		this.semester = semester;
	}

	public String getCourseCode() {
		return courseCode;
	}

	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}
	public String getSection() {
		return section;
	}

	public void setSection(String section) {
		this.section = section;
	}

	public String getEnrollYn() {
		return enrollYn;
	}
	public void setEnrollYn(String enrollYn) {
		this.enrollYn = enrollYn;
	}

	public String getAuditYn() {
		return auditYn;
	}
	public void setAuditYn(String auditYn) {
		this.auditYn = auditYn;
	}

	public String getRepeatYn() {
		return repeatYn;
	}
	public void setRepeatYn(String repeatYn) {
		this.repeatYn = repeatYn;
	}

	public String getMidLtsatsfClsYn() {
		return midLtsatsfClsYn;
	}
	public void setMidLtsatsfClsYn(String midLtsatsfClsYn) {
		this.midLtsatsfClsYn = midLtsatsfClsYn;
	}

	public String getLtsatsfClsYn() {
		return ltsatsfClsYn;
	}
	public void setLtsatsfClsYn(String ltsatsfClsYn) {
		this.ltsatsfClsYn = ltsatsfClsYn;
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

    public String getInsertExcelAt() {
        return insertExcelAt;
    }
    public void setInsertExcelAt(String insertExcelAt) {
        this.insertExcelAt = insertExcelAt;
    }
    
    public String getModifyExcelAt() {
        return modifyExcelAt;
    }
    public void setModifyExcelAt(String modifyExcelAt) {
        this.modifyExcelAt = modifyExcelAt;
    }
	
	public String getMidOathYn() {
		return midOathYn;
	}
	public void setMidOathYn(String midOathYn) {
		this.midOathYn = midOathYn;
	}
	
	public String getFinOathYn() {
		return finOathYn;
	}
	public void setFinOathYn(String finOathYn) {
		this.finOathYn = finOathYn;
	}

	public String getTermCd() {
		return termCd;
	}
	public void setTermCd(String termCd) {
		this.termCd = termCd;
	}
	
    public int getOrder() {
        return order;
    }
    public void setOrder(int order) {
        this.order = order;
    }

}
