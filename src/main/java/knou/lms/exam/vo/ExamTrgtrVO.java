package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamTrgtrVO extends DefaultVO {

	private static final long serialVersionUID = -5943052115058868069L;

	// TB_LMS_EXAM_TRGTR ( 시험대상자 )
	private String 	examTrgtrId;		// 시험대상자아이디
	private String 	examDtlId;			// 시험상세아이디
	private String 	teamId;				// 팀아이디

	public String getExamTrgtrId() {
		return examTrgtrId;
	}
	public String getExamDtlId() {
		return examDtlId;
	}
	public String getTeamId() {
		return teamId;
	}
	public void setExamTrgtrId(String examTrgtrId) {
		this.examTrgtrId = examTrgtrId;
	}
	public void setExamDtlId(String examDtlId) {
		this.examDtlId = examDtlId;
	}
	public void setTeamId(String teamId) {
		this.teamId = teamId;
	}

}
