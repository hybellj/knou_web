package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamGrpVO extends DefaultVO {

	private static final long serialVersionUID = 5618205352955226364L;

	// TB_LMS_EXAM_GRP ( 시험그룹 )
	private String 	examGrpId;				// 시험그룹아이디
    private String  examGrpnm;				// 시험그룹명

	public String getExamGrpId() {
		return examGrpId;
	}
	public String getExamGrpnm() {
		return examGrpnm;
	}
	public void setExamGrpId(String examGrpId) {
		this.examGrpId = examGrpId;
	}
	public void setExamGrpnm(String examGrpnm) {
		this.examGrpnm = examGrpnm;
	}

}
