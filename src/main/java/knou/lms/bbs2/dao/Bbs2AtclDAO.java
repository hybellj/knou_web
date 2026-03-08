package knou.lms.bbs2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.BaseParam;

/**
 * 게시판2게시글 DAO
 */
@Mapper("bbs2AtclDAO")
public interface Bbs2AtclDAO {
	
	public EgovMap bbsUnreadCntSelect(BaseParam param) throws Exception;
	
	public List<EgovMap> dashCrsNoticeList(BaseParam param)  throws Exception;	
	
	public List<EgovMap> profDashAllNoticeList(BaseParam param)  throws Exception;		
	public List<EgovMap> profDashSubjectNoticeList(BaseParam param)  throws Exception;
	public List<EgovMap> profDashLctrQnaList(BaseParam param)  throws Exception;	
	public List<EgovMap> profDashOneOnOneList(BaseParam param)  throws Exception;
	
	public List<EgovMap> stdntDashAllNoticeList(BaseParam param)  throws Exception;	
	public List<EgovMap> stdntDashSubjectNoticeList(BaseParam param)  throws Exception;	
	public List<EgovMap> stdntDashLctrQnaList(BaseParam param)  throws Exception;
	public List<EgovMap> stdntDashDatarmList(BaseParam param)  throws Exception;		
	
	public List<EgovMap> subjectTopNoticeList(BaseParam param)  throws Exception;
	public List<EgovMap> subjectTopLctrQnaList(BaseParam param)  throws Exception;
	
	public List<EgovMap> profSubjectTopOneOnOneList(BaseParam param)  throws Exception;
	public List<EgovMap> stdntSubjectTopDatarmList(BaseParam param) throws Exception;
}