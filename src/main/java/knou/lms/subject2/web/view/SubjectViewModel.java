package knou.lms.subject2.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.web.view.BoardViewModel;
import knou.lms.subject2.vo.SubjectVO;

public class SubjectViewModel extends BoardViewModel {
	
	SubjectVO	subjectVO;
	
	EgovMap	subjectBbsIds;
	
	EgovMap subjectAdms;
	
	EgovMap middleLastExam;
	
	List<EgovMap> subjectLearingActvList;	
	
	List<EgovMap> bbsAtclDataRmList;
	
	List<EgovMap> lectureScheduleList;
	
	List<EgovMap> profLectureScheduleList;
	
	EgovMap thisWeekLecture;
	
	List<EgovMap> byWeeknoLectureSchdlList;

	public SubjectVO getSubjectVO() {
		return subjectVO;
	}

	public void setSubjectVO(SubjectVO subjectVO) {
		this.subjectVO = subjectVO;
	}

	public EgovMap getSubjectAdms() {
		return subjectAdms;
	}

	public void setSubjectAdms(EgovMap subjectAdms) {
		this.subjectAdms = subjectAdms;
	}

	public List<EgovMap> getBbsAtclDataRmList() {
		return bbsAtclDataRmList;
	}

	public void setBbsAtclDataRmList(List<EgovMap> bbsAtclDataRmList) {
		this.bbsAtclDataRmList = bbsAtclDataRmList;
	}

	public EgovMap getMiddleLastExam() {
		return middleLastExam;
	}

	public void setMiddleLastExam(EgovMap middleLastExam) {
		this.middleLastExam = middleLastExam;
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

	public EgovMap getThisWeekLecture() {
		return thisWeekLecture;
	}

	public void setThisWeekLectureMap(EgovMap thisWeekLecture) {
		this.thisWeekLecture = thisWeekLecture;
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