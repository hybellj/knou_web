package knou.lms.smnr.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.subject.vo.SubjectVO;

public class SmnrMainView {

	ProcessResultVO<EgovMap> profSmnrList;

	List<EgovMap> sbjctDcvlasList;

	EgovMap smnrEgovMap;

	SubjectVO subjectVO;

	List<EgovMap> smnrLrnGrpSubSmnrList;

	public ProcessResultVO<EgovMap> getProfSmnrList() {
		return profSmnrList;
	}

	public void setProfSmnrList(ProcessResultVO<EgovMap> profSmnrList) {
		this.profSmnrList = profSmnrList;
	}

	public List<EgovMap> getSbjctDcvlasList() {
		return sbjctDcvlasList;
	}

	public void setSbjctDcvlasList(List<EgovMap> sbjctDcvlasList) {
		this.sbjctDcvlasList = sbjctDcvlasList;
	}

	public EgovMap getSmnrEgovMap() {
		return smnrEgovMap;
	}

	public void setSmnrEgovMap(EgovMap smnrEgovMap) {
		this.smnrEgovMap = smnrEgovMap;
	}

	public SubjectVO getSubjectVO() {
		return subjectVO;
	}

	public void setSubjectVO(SubjectVO subjectVO) {
		this.subjectVO = subjectVO;
	}

	public List<EgovMap> getSmnrLrnGrpSubSmnrList() {
		return smnrLrnGrpSubSmnrList;
	}

	public void setSmnrLrnGrpSubSmnrList(List<EgovMap> smnrLrnGrpSubSmnrList) {
		this.smnrLrnGrpSubSmnrList = smnrLrnGrpSubSmnrList;
	}

}
