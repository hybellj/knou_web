package knou.lms.exam.web.view;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;

public class QuizMainView {

	ExamBscVO examBscVO;

	List<EgovMap> sbjctDcvlasList;

	List<EgovMap> quizGrpSbjctList;

	Map<String, List<CmmnCdVO>> cmmnCdList;

	List<EgovMap> quizTeamList;

	Boolean isQstnsCmptn;

	List<QstnVO> qstnList;

	List<QstnVwitmVO> qstnVwitmList;

	EgovMap quizExamnee;

	List<EgovMap> tkexamHstryList;

	List<EgovMap> quizTkexamList;

	List<EgovMap> tkexamExampprAnswShtList;

	EgovMap profMemo;

	public ExamBscVO getExamBscVO() {
		return examBscVO;
	}

	public List<EgovMap> getQuizGrpSbjctList() {
		return quizGrpSbjctList;
	}

	public void setExamBscVO(ExamBscVO examBscVO) {
		this.examBscVO = examBscVO;
	}

	public void setQuizGrpSbjctList(List<EgovMap> quizGrpSbjctList) {
		this.quizGrpSbjctList = quizGrpSbjctList;
	}

	public Map<String, List<CmmnCdVO>> getCmmnCdList() {
		return cmmnCdList;
	}

	public void setCmmnCdList(Map<String, List<CmmnCdVO>> cmmnCdList) {
		this.cmmnCdList = cmmnCdList;
	}

	public List<EgovMap> getQuizTeamList() {
		return quizTeamList;
	}

	public void setQuizTeamList(List<EgovMap> quizTeamList) {
		this.quizTeamList = quizTeamList;
	}

	public Boolean getIsQstnsCmptn() {
		return isQstnsCmptn;
	}

	public void setIsQstnsCmptn(Boolean isQstnsCmptn) {
		this.isQstnsCmptn = isQstnsCmptn;
	}

	public List<QstnVO> getQstnList() {
		return qstnList;
	}

	public List<QstnVwitmVO> getQstnVwitmList() {
		return qstnVwitmList;
	}

	public void setQstnList(List<QstnVO> qstnList) {
		this.qstnList = qstnList;
	}

	public void setQstnVwitmList(List<QstnVwitmVO> qstnVwitmList) {
		this.qstnVwitmList = qstnVwitmList;
	}

	public List<EgovMap> getSbjctDcvlasList() {
		return sbjctDcvlasList;
	}

	public void setSbjctDcvlasList(List<EgovMap> sbjctDcvlasList) {
		this.sbjctDcvlasList = sbjctDcvlasList;
	}

	public List<EgovMap> getTkexamHstryList() {
		return tkexamHstryList;
	}

	public void setTkexamHstryList(List<EgovMap> tkexamHstryList) {
		this.tkexamHstryList = tkexamHstryList;
	}

	public EgovMap getQuizExamnee() {
		return quizExamnee;
	}

	public void setQuizExamnee(EgovMap quizExamnee) {
		this.quizExamnee = quizExamnee;
	}

	public List<EgovMap> getQuizTkexamList() {
		return quizTkexamList;
	}

	public void setQuizTkexamList(List<EgovMap> quizTkexamList) {
		this.quizTkexamList = quizTkexamList;
	}

	public List<EgovMap> getTkexamExampprAnswShtList() {
		return tkexamExampprAnswShtList;
	}

	public void setTkexamExampprAnswShtList(List<EgovMap> tkexamExampprAnswShtList) {
		this.tkexamExampprAnswShtList = tkexamExampprAnswShtList;
	}

	public EgovMap getProfMemo() {
		return profMemo;
	}

	public void setProfMemo(EgovMap profMemo) {
		this.profMemo = profMemo;
	}

}
