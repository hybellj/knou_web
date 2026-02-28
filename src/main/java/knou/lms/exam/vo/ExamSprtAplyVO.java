package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamSprtAplyVO extends DefaultVO {

	private static final long serialVersionUID = -8672595683631011962L;

	// TB_LMS_EXAM_SPRT_APLY ( 시험지원신청 )
	private String 	examSprtAplyId;			// 시험지원신청아이디
	private String 	examBscId;				// 시험기본아이디
	private String 	aplyStscd;				// 신청상태코드 ( APLY : 신청, RE_APLY : 재신청, APRV : 승인, RJCT : 거절 )
	private String 	autzrId;				// 승인자아이디
	private String 	aprvdttm;				// 승인일시
	private Integer	addMnts;				// 추가시간
	private String 	extdtmChgyn;			// 연장시간변경여부
	private String 	cnclAplyStscd;			// 취소신청상태코드 ( CNCL_APLY : 취소신청, CNCL_APRV : 취소승인 )

	public String getExamSprtAplyId() {
		return examSprtAplyId;
	}
	public String getExamBscId() {
		return examBscId;
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
	public Integer getAddMnts() {
		return addMnts;
	}
	public String getExtdtmChgyn() {
		return extdtmChgyn;
	}
	public String getCnclAplyStscd() {
		return cnclAplyStscd;
	}
	public void setExamSprtAplyId(String examSprtAplyId) {
		this.examSprtAplyId = examSprtAplyId;
	}
	public void setExamBscId(String examBscId) {
		this.examBscId = examBscId;
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
	public void setAddMnts(Integer addMnts) {
		this.addMnts = addMnts;
	}
	public void setExtdtmChgyn(String extdtmChgyn) {
		this.extdtmChgyn = extdtmChgyn;
	}
	public void setCnclAplyStscd(String cnclAplyStscd) {
		this.cnclAplyStscd = cnclAplyStscd;
	}

}
