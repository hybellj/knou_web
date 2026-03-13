package knou.lms.exam.vo;

import java.util.List;
import java.util.Map;

import knou.lms.common.vo.DefaultVO;

public class ExamDtlVO extends DefaultVO {

	private static final long serialVersionUID = 8248081663571996698L;

	// TB_LMS_EXAM_DTL ( 시험상세 )
    private String 	examDtlId;				// 시험상세아이디
    private String 	examBscId;				// 시험기본아이디
    private String 	examTtl;				// 시험제목
    private String 	examCts;				// 시험내용
    private Integer	examMnts;				// 시험시간
    private String 	examtmLmtyn;			// 시험시간제한여부
    private String 	examPsblSdttm;			// 시험가능시작일시
    private String 	examPsblEdttm;			// 시험가능종료일시
    private String 	examQstnsCmptnyn;		// 시험문제출제완료여부
    private Integer	passScr;				// 통과점수
    private Integer	cnsdrAddMnts;			// 배려추가시간
    private String  useyn;					// 사용여부
    private String  delyn;					// 삭제여부
    private String 	reexamyn;				// 재시험여부
    private String 	reexamPsblSdttm;		// 재시험가능시작일시
    private String 	reexamPsblEdttm;		// 재시험가능종료일시
    private Integer	reexamMrkRfltrt;		// 재시험성적반영비율

    private String  lrnGrpId;				// 학습그룹아이디
    private String  teamId;					// 팀아이디
    private String  teamnm;					// 팀명
    private String  leadernm;				// 리더명
    private Integer teamMbrCnt;				// 팀멤버수

    private List<Map<String, Object>> dtlInfos;

	public String getExamDtlId() {
		return examDtlId;
	}

	public String getExamBscId() {
		return examBscId;
	}

	public String getExamTtl() {
		return examTtl;
	}

	public String getExamCts() {
		return examCts;
	}

	public Integer getExamMnts() {
		return examMnts;
	}

	public String getExamtmLmtyn() {
		return examtmLmtyn;
	}

	public String getExamPsblSdttm() {
		return examPsblSdttm;
	}

	public String getExamPsblEdttm() {
		return examPsblEdttm;
	}

	public String getExamQstnsCmptnyn() {
		return examQstnsCmptnyn;
	}

	public Integer getPassScr() {
		return passScr;
	}

	public Integer getCnsdrAddMnts() {
		return cnsdrAddMnts;
	}

	public String getUseyn() {
		return useyn;
	}

	public String getDelyn() {
		return delyn;
	}

	public String getReexamyn() {
		return reexamyn;
	}

	public String getReexamPsblSdttm() {
		return reexamPsblSdttm;
	}

	public String getReexamPsblEdttm() {
		return reexamPsblEdttm;
	}

	public Integer getReexamMrkRfltrt() {
		return reexamMrkRfltrt;
	}

	public String getLrnGrpId() {
		return lrnGrpId;
	}

	public String getTeamId() {
		return teamId;
	}

	public String getTeamnm() {
		return teamnm;
	}

	public String getLeadernm() {
		return leadernm;
	}

	public Integer getTeamMbrCnt() {
		return teamMbrCnt;
	}

	public List<Map<String, Object>> getDtlInfos() {
		return dtlInfos;
	}

	public void setExamDtlId(String examDtlId) {
		this.examDtlId = examDtlId;
	}

	public void setExamBscId(String examBscId) {
		this.examBscId = examBscId;
	}

	public void setExamTtl(String examTtl) {
		this.examTtl = examTtl;
	}

	public void setExamCts(String examCts) {
		this.examCts = examCts;
	}

	public void setExamMnts(Integer examMnts) {
		this.examMnts = examMnts;
	}

	public void setExamtmLmtyn(String examtmLmtyn) {
		this.examtmLmtyn = examtmLmtyn;
	}

	public void setExamPsblSdttm(String examPsblSdttm) {
		this.examPsblSdttm = examPsblSdttm;
	}

	public void setExamPsblEdttm(String examPsblEdttm) {
		this.examPsblEdttm = examPsblEdttm;
	}

	public void setExamQstnsCmptnyn(String examQstnsCmptnyn) {
		this.examQstnsCmptnyn = examQstnsCmptnyn;
	}

	public void setPassScr(Integer passScr) {
		this.passScr = passScr;
	}

	public void setCnsdrAddMnts(Integer cnsdrAddMnts) {
		this.cnsdrAddMnts = cnsdrAddMnts;
	}

	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}

	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}

	public void setReexamyn(String reexamyn) {
		this.reexamyn = reexamyn;
	}

	public void setReexamPsblSdttm(String reexamPsblSdttm) {
		this.reexamPsblSdttm = reexamPsblSdttm;
	}

	public void setReexamPsblEdttm(String reexamPsblEdttm) {
		this.reexamPsblEdttm = reexamPsblEdttm;
	}

	public void setReexamMrkRfltrt(Integer reexamMrkRfltrt) {
		this.reexamMrkRfltrt = reexamMrkRfltrt;
	}

	public void setLrnGrpId(String lrnGrpId) {
		this.lrnGrpId = lrnGrpId;
	}

	public void setTeamId(String teamId) {
		this.teamId = teamId;
	}

	public void setTeamnm(String teamnm) {
		this.teamnm = teamnm;
	}

	public void setLeadernm(String leadernm) {
		this.leadernm = leadernm;
	}

	public void setTeamMbrCnt(Integer teamMbrCnt) {
		this.teamMbrCnt = teamMbrCnt;
	}

	public void setDtlInfos(List<Map<String, Object>> dtlInfos) {
		this.dtlInfos = dtlInfos;
	}

}
