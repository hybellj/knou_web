package knou.lms.bbs2.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;

public interface Bbs2Service {
	
	//	게시판미열람수조회 - 대시보드, 과목 공통
	public EgovMap bbsUnreadCntSelect(SubjectDTO sbjctDto);
	
	//	대시보드 과정공지
	public List<EgovMap> dashCrsNoticeList(CommonDTO cmmnDto);
	
	//	대시보드 교수
	public List<EgovMap> profDashAllNoticeList(CommonDTO cmmnDto);	
	public List<EgovMap> profDashSubjectNoticeList(SubjectDTO sbjctDto);	
	public List<EgovMap> profDashLctrQnaList(CommonDTO cmmnDto);
	public List<EgovMap> profDashOneOnOneList(CommonDTO cmmnDto);
	
	//	대시보드 학생
	public List<EgovMap> stdntDashAllNoticeList(CommonDTO cmmnDto);
	public List<EgovMap> stdntDashSubjectNoticeList(CommonDTO cmmnDto);
	public List<EgovMap> stdntDashLctrQnaList(CommonDTO cmmnDto);
	public List<EgovMap> stdntDashDatarmList(CommonDTO cmmnDto);

    // 대시보드 관리자
    public List<EgovMap> admDashSysNoticeList(int limitTop) ;
    public List<EgovMap> admDashAllNoticeList(int limitTop) ;
	
	//	과목 공통
	public List<EgovMap> subjectTopNoticeList(CommonDTO cmmnDto);
	public List<EgovMap> subjectTopLctrQnaList(CommonDTO cmmnDto);	
	
	//	과목 교수
	public List<EgovMap> profSubjectTopOneOnOneList(CommonDTO cmmnDto);
	
	//	과목 학생	
	public List<EgovMap> stdntSubjectTopDatarmList(CommonDTO cmmnDto);

	public EgovMap profBbsUnreadCntSelect(SubjectDTO sbjctDto);
}