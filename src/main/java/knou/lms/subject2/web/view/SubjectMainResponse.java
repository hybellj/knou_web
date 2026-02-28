package knou.lms.subject2.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.web.view.BoardResponse;
import knou.lms.subject2.vo.SubjectVO;

public class SubjectMainResponse extends BoardResponse {
	
	SubjectVO	subjectVO;
	
	EgovMap	subjectBbsIds;
	
	EgovMap subjectAdmsMap;
	
	EgovMap middleLastExamMap;
	
	List<EgovMap> subjectLearingActvList;	
	
	List<EgovMap> bbsAtclDataRmList;
	
	List<EgovMap> lectureScheduleList;
	
	List<EgovMap> profLectureScheduleList;
	
	EgovMap thisWeekLectureMap;
	
	List<EgovMap> byWeeknoLectureSchdlList;

	public SubjectVO getSubjectVO() {
		return subjectVO;
	}

	public void setSubjectVO(SubjectVO subjectVO) {
		this.subjectVO = subjectVO;
	}

	public EgovMap getSubjectAdmsMap() {
		return subjectAdmsMap;
	}

	public void setSubjectAdmsMap(EgovMap subjectAdmsMap) {
		this.subjectAdmsMap = subjectAdmsMap;
	}

	public List<EgovMap> getBbsAtclDataRmList() {
		return bbsAtclDataRmList;
	}

	public void setBbsAtclDataRmList(List<EgovMap> bbsAtclDataRmList) {
		this.bbsAtclDataRmList = bbsAtclDataRmList;
	}

	public EgovMap getMiddleLastExamMap() {
		return middleLastExamMap;
	}

	public void setMiddleLastExamMap(EgovMap middleLastExamMap) {
		this.middleLastExamMap = middleLastExamMap;
	}

	public List<EgovMap> getSubjectLearingActvList() {
		return subjectLearingActvList;
	}

	public void setSubjectLearingActvList(List<EgovMap> subjectLearingActvList) {
		this.subjectLearingActvList = subjectLearingActvList;
	}

	public List<EgovMap> getLectureScheduleList() {
		return lectureScheduleList;
	}

	public void setLectureScheduleList(List<EgovMap> list) {
		this.lectureScheduleList = list;
	}

	public List<EgovMap> getProfLectureScheduleList() {
		return profLectureScheduleList;
	}

	public void setProfLectureScheduleList(List<EgovMap> profLectureScheduleList) {
		this.profLectureScheduleList = profLectureScheduleList;
	}

	public EgovMap getThisWeekLectureMap() {
		return thisWeekLectureMap;
	}

	public void setThisWeekLectureMap(EgovMap thisWeekLectureMap) {
		this.thisWeekLectureMap = thisWeekLectureMap;
	}

	public List<EgovMap> getByWeeknoLectureSchdlList() {
		return byWeeknoLectureSchdlList;
	}

	public void setByWeeknoLectureSchdlList(List<EgovMap> byWeeknoLectureSchdlList) {
		this.byWeeknoLectureSchdlList = byWeeknoLectureSchdlList;
	}

	public EgovMap getSubjectBbsIds() {
		return subjectBbsIds;
	}

	public void setSubjectBbsIds(EgovMap subjectBbsIds) {
		this.subjectBbsIds = subjectBbsIds;
	}	
}