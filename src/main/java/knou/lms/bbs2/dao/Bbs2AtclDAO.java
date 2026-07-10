package knou.lms.bbs2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;

/**
 * 게시판2게시글 DAO
 */
@Mapper("bbs2AtclDAO")
public interface Bbs2AtclDAO {
	
	public EgovMap bbsUnreadCntSelect(SubjectDTO sbjctDto);
	
	public List<EgovMap> dashCrsNoticeList(CommonDTO cmmnDto);	
	
	public List<EgovMap> profDashAllNoticeList(CommonDTO cmmnDto) ;		
	public List<EgovMap> profDashSubjectNoticeList(CommonDTO cmmnDto) ;
	public List<EgovMap> profDashLctrQnaList(CommonDTO cmmnDto) ;	
	public List<EgovMap> profDashOneOnOneList(CommonDTO cmmnDto) ;
	
	public List<EgovMap> stdntDashAllNoticeList(CommonDTO cmmnDto) ;	
	public List<EgovMap> stdntDashSubjectNoticeList(CommonDTO cmmnDto) ;	
	public List<EgovMap> stdntDashLctrQnaList(CommonDTO cmmnDto) ;
	public List<EgovMap> stdntDashDatarmList(CommonDTO cmmnDto) ;

    public List<EgovMap> admDashSysNoticeList(int limitTop) ;
    public List<EgovMap> admDashAllNoticeList(int limitTop) ;

	public List<EgovMap> subjectTopNoticeList(CommonDTO cmmnDto) ;
	public List<EgovMap> subjectTopLctrQnaList(CommonDTO cmmnDto) ;
	
	public List<EgovMap> profSubjectTopOneOnOneList(CommonDTO cmmnDto) ;
	public List<EgovMap> stdntSubjectTopDatarmList(CommonDTO cmmnDto);

	public EgovMap profBbsUnreadCntSelect(SubjectDTO sbjctDto);
}