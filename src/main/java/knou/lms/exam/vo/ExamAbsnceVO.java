package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamAbsnceVO extends DefaultVO {

	private static final long serialVersionUID = -2672957114531707845L;

	// TB_LMS_EXAM_ABSNCE ( 시험결시 )
	private String 	examAbsnceId;		// 시험결시아이디
	private String 	examBscId;			// 시험기본아이디
	private String 	absnceTtl;			// 결시제목
	private String 	absnceCts;			// 결시내용
	private String 	aplyStscd;			// 신청상태코드 ( APLY : 신청, RE_APLY : 재신청, APRV : 승인, RJCT : 거절 )
	private String 	autzrId;			// 승인자아이디
	private String 	aprvdttm;			// 승인일시
	private String 	aprvCts;			// 승인내용
	private String 	mngrOpnn;			// 매니져의견

	public String getExamAbsnceId() {
		return examAbsnceId;
	}
	public String getExamBscId() {
		return examBscId;
	}
	public String getAbsnceTtl() {
		return absnceTtl;
	}
	public String getAbsnceCts() {
		return absnceCts;
	}
	public String getAplyStscd() {
		return aplyStscd;
	}
	public String getAutzrId() {
		return autzrId;
	}
	public String getAprvdttm() {
		return aprvdttm;
	}
	public String getAprvCts() {
		return aprvCts;
	}
	public String getMngrOpnn() {
		return mngrOpnn;
	}
	public void setExamAbsnceId(String examAbsnceId) {
		this.examAbsnceId = examAbsnceId;
	}
	public void setExamBscId(String examBscId) {
		this.examBscId = examBscId;
	}
	public void setAbsnceTtl(String absnceTtl) {
		this.absnceTtl = absnceTtl;
	}
	public void setAbsnceCts(String absnceCts) {
		this.absnceCts = absnceCts;
	}
	public void setAplyStscd(String aplyStscd) {
		this.aplyStscd = aplyStscd;
	}
	public void setAutzrId(String autzrId) {
		this.autzrId = autzrId;
	}
	public void setAprvdttm(String aprvdttm) {
		this.aprvdttm = aprvdttm;
	}
	public void setAprvCts(String aprvCts) {
		this.aprvCts = aprvCts;
	}
	public void setMngrOpnn(String mngrOpnn) {
		this.mngrOpnn = mngrOpnn;
	}

}
