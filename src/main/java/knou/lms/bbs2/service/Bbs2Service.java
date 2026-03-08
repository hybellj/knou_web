package knou.lms.bbs2.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.BaseParam;

public interface Bbs2Service {
	
	//	게시판미열람수조회 - 대시보드, 과목 공통
	public EgovMap bbsUnreadCntSelect(BaseParam param) throws Exception;
	
	//	대시보드 과정공지
	public List<EgovMap> dashCrsNoticeList(BaseParam param) throws Exception;
	
	//	대시보드 교수
	public List<EgovMap> profDashAllNoticeList(BaseParam param) throws Exception;	
	public List<EgovMap> profDashSubjectNoticeList(BaseParam param) throws Exception;	
	public List<EgovMap> profDashLctrQnaList(BaseParam param) throws Exception;
	public List<EgovMap> profDashOneOnOneList(BaseParam param) throws Exception;
	
	//	대시보드 학생
	public List<EgovMap> stdntDashAllNoticeList(BaseParam param) throws Exception;
	public List<EgovMap> stdntDashSubjectNoticeList(BaseParam param) throws Exception;
	public List<EgovMap> stdntDashLctrQnaList(BaseParam param) throws Exception;
	public List<EgovMap> stdntDashDatarmList(BaseParam param) throws Exception;			
	
	//	과목 공통
	public List<EgovMap> subjectTopNoticeList(BaseParam param) throws Exception;
	public List<EgovMap> subjectTopLctrQnaList(BaseParam param) throws Exception;	
	
	//	과목 교수
	public List<EgovMap> profSubjectTopOneOnOneList(BaseParam param) throws Exception;
	
	//	과목 학생	
	public List<EgovMap> stdntSubjectTopDatarmList(BaseParam param) throws Exception;
}