package knou.lms.subject2.service;

import knou.lms.subject2.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface SubjectService {

    public SubjectVO subjectSelect(String subjectId) throws Exception;

    public List<EgovMap> subjectLearningActvList(String subjectId) throws Exception;

    public EgovMap sbjctAdmSelect(String subjectId) throws Exception;

    public List<EgovMap> sbjctAdmList(String subjectId) throws Exception;

    public EgovMap middleLastExamSelect(String subjectId) throws Exception;

    public EgovMap subjectBbsIdsSelect(String subjectId) throws Exception;
}