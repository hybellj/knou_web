package knou.lms.subject2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.BaseParam;
import knou.lms.subject2.dto.SubjectParam;
import knou.lms.subject2.vo.SubjectVO;

@Mapper("subjectDAO")
public interface SubjectDAO {
   
    public SubjectVO subjectSelect(BaseParam param) throws Exception;

    public List<EgovMap> subjectLearningActvList(BaseParam param) throws Exception;

    public EgovMap sbjctAdmSelect(BaseParam param) throws Exception;

    public List<EgovMap> sbjctAdmList(BaseParam param) throws Exception;

    public EgovMap middleLastExamSelect(BaseParam param) throws Exception;

	public EgovMap subjectBbsIdsSelect(BaseParam param) throws Exception;

	public List<EgovMap> profSubjectSummaryList(BaseParam param) throws Exception;
	
	public List<EgovMap> stdntSubjectSummaryList(BaseParam param) throws Exception;

	public int stdntOrProfCountSelect(SubjectParam param) throws Exception;
}