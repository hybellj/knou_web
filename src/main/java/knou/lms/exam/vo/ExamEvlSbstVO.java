package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamEvlSbstVO extends DefaultVO {

	private static final long serialVersionUID = 5690412728460578479L;

	// TB_LMS_EXAM_EVL_SBST ( 시험평가대체 )
	private String 	examEvlSbstId;		// 시험평가대체아이디
	private String 	examBscId;			// 시험기본아이디
	private String 	examSbstTycd;		// 시험대체유형코드 ( SBST_ASMT : 과제, SBST_QUIZ : 퀴즈, SBST_DSCS : 토론 )
	private String 	examSbstId;			// 시험대체아이디

	public String getExamEvlSbstId() {
		return examEvlSbstId;
	}
	public String getExamBscId() {
		return examBscId;
	}
	public String getExamSbstTycd() {
		return examSbstTycd;
	}
	public String getExamSbstId() {
		return examSbstId;
	}
	public void setExamEvlSbstId(String examEvlSbstId) {
		this.examEvlSbstId = examEvlSbstId;
	}
	public void setExamBscId(String examBscId) {
		this.examBscId = examBscId;
	}
	public void setExamSbstTycd(String examSbstTycd) {
		this.examSbstTycd = examSbstTycd;
	}
	public void setExamSbstId(String examSbstId) {
		this.examSbstId = examSbstId;
	}

}
