package knou.lms.subject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.BaseParam;
import knou.lms.subject.dto.SubjectParam;
import knou.lms.subject.vo.LectureWknoScheduleVO;
import knou.lms.subject.vo.SubjectVO;

@Mapper("subjectDAO")
public interface SubjectDAO {
   
    public SubjectVO subjectSelect(BaseParam param) throws Exception;

    public List<EgovMap> subjectLearningActvList(BaseParam param) throws Exception;

    public EgovMap sbjctAdmSelect(BaseParam param) throws Exception;

    public List<EgovMap> sbjctAdmList(BaseParam param) throws Exception;

    public EgovMap middleLastExamSelect(BaseParam param) throws Exception;

	public EgovMap subjectBbsIdsSelect(BaseParam param) throws Exception;

	public List<EgovMap> subjectSummaryList(BaseParam param) throws Exception;
	
	public List<EgovMap> profSubjectSummaryList(BaseParam param) throws Exception;
	
	public List<EgovMap> stdntSubjectSummaryList(BaseParam param) throws Exception;

	public int stdntOrProfCountSelect(SubjectParam subjectParam) throws Exception;

	public List<EgovMap> subjectUsersList(BaseParam param) throws Exception;

	public LectureWknoScheduleVO currLctrWknoSchdlSelect(String sbjctId) throws Exception ;

	public int connectStdCntSelect(String userId) throws Exception ;

	public int totalStdCntSelect(String userId) throws Exception ;

	public List<EgovMap> stdntSubjectConnectList(String sbjctId) throws Exception ;

	public int subjectConnectStdCntSelect(String sbjctId) throws Exception ;

	public int subjectTotalStdCntSelect(String sbjctId) throws Exception ;

	public EgovMap lctrWknoAtndcrtSelect(@Param("sbjctId") String sbjctId, @Param("lctrWknoSchdlId") String lctrWknoSchdlId) throws Exception;

	public List<EgovMap> subjectByUserOrgIdSelect(@Param("profIds") List<String> profIds, @Param("stdntIds") List<String> stdntIds) throws Exception;
}