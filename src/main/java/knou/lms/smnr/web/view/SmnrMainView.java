package knou.lms.smnr.web.view;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomPastMeetingVO;
import knou.lms.smnr.vo.SmnrAtndVO;
import knou.lms.smnr.vo.SmnrFdbkVO;
import knou.lms.subject.vo.SubjectVO;

public class SmnrMainView {

	ResultDTO<EgovMap> resultDTO;

	List<EgovMap> egovList;

	Map<String, List<EgovMap>> egovListMap;

	EgovMap egovMap;

	Map<String, EgovMap> eMap;

	Map<String, List<CmmnCdVO>> cmmnCdList;

	List<SmnrFdbkVO> smnrFdbkList;

	SubjectVO subjectVO;

	SmnrAtndVO smnrAtndVO;

	SmnrFdbkVO smnrFdbkVO;

	ZoomPastMeetingVO zoomPastMeetingVO;

	public List<EgovMap> getEgovList() {
		return egovList;
	}

	public Map<String, List<EgovMap>> getEgovListMap() {
		return egovListMap;
	}

	public EgovMap getEgovMap() {
		return egovMap;
	}

	public Map<String, EgovMap> geteMap() {
		return eMap;
	}

	public Map<String, List<CmmnCdVO>> getCmmnCdList() {
		return cmmnCdList;
	}

	public List<SmnrFdbkVO> getSmnrFdbkList() {
		return smnrFdbkList;
	}

	public SubjectVO getSubjectVO() {
		return subjectVO;
	}

	public SmnrAtndVO getSmnrAtndVO() {
		return smnrAtndVO;
	}

	public SmnrFdbkVO getSmnrFdbkVO() {
		return smnrFdbkVO;
	}

	public ZoomPastMeetingVO getZoomPastMeetingVO() {
		return zoomPastMeetingVO;
	}

	public void setEgovList(List<EgovMap> egovList) {
		this.egovList = egovList;
	}

	public void setEgovListMap(Map<String, List<EgovMap>> egovListMap) {
		this.egovListMap = egovListMap;
	}

	public void setEgovMap(EgovMap egovMap) {
		this.egovMap = egovMap;
	}

	public void seteMap(Map<String, EgovMap> eMap) {
		this.eMap = eMap;
	}

	public void setCmmnCdList(Map<String, List<CmmnCdVO>> cmmnCdList) {
		this.cmmnCdList = cmmnCdList;
	}

	public void setSmnrFdbkList(List<SmnrFdbkVO> smnrFdbkList) {
		this.smnrFdbkList = smnrFdbkList;
	}

	public void setSubjectVO(SubjectVO subjectVO) {
		this.subjectVO = subjectVO;
	}

	public void setSmnrAtndVO(SmnrAtndVO smnrAtndVO) {
		this.smnrAtndVO = smnrAtndVO;
	}

	public void setSmnrFdbkVO(SmnrFdbkVO smnrFdbkVO) {
		this.smnrFdbkVO = smnrFdbkVO;
	}

	public void setZoomPastMeetingVO(ZoomPastMeetingVO zoomPastMeetingVO) {
		this.zoomPastMeetingVO = zoomPastMeetingVO;
	}

	public ResultDTO<EgovMap> getResultDTO() {
		return resultDTO;
	}

	public void setResultDTO(ResultDTO<EgovMap> resultDTO) {
		this.resultDTO = resultDTO;
	}
}
