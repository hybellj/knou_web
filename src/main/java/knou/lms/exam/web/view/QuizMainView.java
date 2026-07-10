package knou.lms.exam.web.view;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.ExrcsSddnQstnBscVO;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;
import knou.lms.org.vo.OrgVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.user.vo.UsrDeptCdVO;

public class QuizMainView {

	ResultDTO<EgovMap> resultDTO;

	List<EgovMap> egovList;

	List<QstnVO> qstnList;

	List<QstnVwitmVO> qstnVwitmList;

	List<ExamDtlVO> examDtlList;

	List<ExrcsSddnQstnBscVO> exrcsQstnBscList;

	List<TeamMemberVO> teamMbrList;

	List<OrgVO> orgList;

	List<UsrDeptCdVO> deptList;

	Map<String, ResultDTO<EgovMap>> resultMap;

	Map<String, EgovMap> eMap;

	Map<String, List<EgovMap>> egovListMap;

	Map<String, List<CmmnCdVO>> cmmnCdList;

	HashMap<String, Object> qstnExcelSampleData;

	EgovMap egovMap;

	ExamBscVO examBscVO;

	ExrcsSddnQstnBscVO exrcsSddnQstnBscVO;

	QstnVO qstnVO;

	ExamDtlVO examDtlVO;

	Boolean isQstnsCmptn;

	public ResultDTO<EgovMap> getResultDTO() {
		return resultDTO;
	}

	public List<EgovMap> getEgovList() {
		return egovList;
	}

	public List<QstnVO> getQstnList() {
		return qstnList;
	}

	public List<QstnVwitmVO> getQstnVwitmList() {
		return qstnVwitmList;
	}

	public List<ExamDtlVO> getExamDtlList() {
		return examDtlList;
	}

	public List<ExrcsSddnQstnBscVO> getExrcsQstnBscList() {
		return exrcsQstnBscList;
	}

	public List<TeamMemberVO> getTeamMbrList() {
		return teamMbrList;
	}

	public List<OrgVO> getOrgList() {
		return orgList;
	}

	public List<UsrDeptCdVO> getDeptList() {
		return deptList;
	}

	public Map<String, ResultDTO<EgovMap>> getResultMap() {
		return resultMap;
	}

	public Map<String, EgovMap> geteMap() {
		return eMap;
	}

	public Map<String, List<EgovMap>> getEgovListMap() {
		return egovListMap;
	}

	public Map<String, List<CmmnCdVO>> getCmmnCdList() {
		return cmmnCdList;
	}

	public HashMap<String, Object> getQstnExcelSampleData() {
		return qstnExcelSampleData;
	}

	public EgovMap getEgovMap() {
		return egovMap;
	}

	public ExamBscVO getExamBscVO() {
		return examBscVO;
	}

	public ExrcsSddnQstnBscVO getExrcsSddnQstnBscVO() {
		return exrcsSddnQstnBscVO;
	}

	public QstnVO getQstnVO() {
		return qstnVO;
	}

	public ExamDtlVO getExamDtlVO() {
		return examDtlVO;
	}

	public Boolean getIsQstnsCmptn() {
		return isQstnsCmptn;
	}

	public void setResultDTO(ResultDTO<EgovMap> resultDTO) {
		this.resultDTO = resultDTO;
	}

	public void setEgovList(List<EgovMap> egovList) {
		this.egovList = egovList;
	}

	public void setQstnList(List<QstnVO> qstnList) {
		this.qstnList = qstnList;
	}

	public void setQstnVwitmList(List<QstnVwitmVO> qstnVwitmList) {
		this.qstnVwitmList = qstnVwitmList;
	}

	public void setExamDtlList(List<ExamDtlVO> examDtlList) {
		this.examDtlList = examDtlList;
	}

	public void setExrcsQstnBscList(List<ExrcsSddnQstnBscVO> exrcsQstnBscList) {
		this.exrcsQstnBscList = exrcsQstnBscList;
	}

	public void setTeamMbrList(List<TeamMemberVO> teamMbrList) {
		this.teamMbrList = teamMbrList;
	}

	public void setOrgList(List<OrgVO> orgList) {
		this.orgList = orgList;
	}

	public void setDeptList(List<UsrDeptCdVO> deptList) {
		this.deptList = deptList;
	}

	public void setResultMap(Map<String, ResultDTO<EgovMap>> resultMap) {
		this.resultMap = resultMap;
	}

	public void seteMap(Map<String, EgovMap> eMap) {
		this.eMap = eMap;
	}

	public void setEgovListMap(Map<String, List<EgovMap>> egovListMap) {
		this.egovListMap = egovListMap;
	}

	public void setCmmnCdList(Map<String, List<CmmnCdVO>> cmmnCdList) {
		this.cmmnCdList = cmmnCdList;
	}

	public void setQstnExcelSampleData(HashMap<String, Object> qstnExcelSampleData) {
		this.qstnExcelSampleData = qstnExcelSampleData;
	}

	public void setEgovMap(EgovMap egovMap) {
		this.egovMap = egovMap;
	}

	public void setExamBscVO(ExamBscVO examBscVO) {
		this.examBscVO = examBscVO;
	}

	public void setExrcsSddnQstnBscVO(ExrcsSddnQstnBscVO exrcsSddnQstnBscVO) {
		this.exrcsSddnQstnBscVO = exrcsSddnQstnBscVO;
	}

	public void setQstnVO(QstnVO qstnVO) {
		this.qstnVO = qstnVO;
	}

	public void setExamDtlVO(ExamDtlVO examDtlVO) {
		this.examDtlVO = examDtlVO;
	}

	public void setIsQstnsCmptn(Boolean isQstnsCmptn) {
		this.isQstnsCmptn = isQstnsCmptn;
	}
}
