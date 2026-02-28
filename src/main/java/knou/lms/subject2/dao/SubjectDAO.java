package knou.lms.subject2.dao;

import knou.lms.subject2.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("subjectDAO")
public interface SubjectDAO {

    /**
     * 과목조회
     *
     * @param subjectId
     * @return SubjctOfferingVO
     * @throws Exception
     */
    public SubjectVO subjectSelect(String subjectId) throws Exception;

    public List<EgovMap> subjectLearningActvList(String subjectId) throws Exception;

    public EgovMap sbjctAdmSelect(String subjectId) throws Exception;

    public List<EgovMap> sbjctAdmList(String subjectId) throws Exception;

    public EgovMap middleLastExamSelect(String subjectId) throws Exception;

	public EgovMap subjectBbsIdsSelect(String subjectId) throws Exception;

}
