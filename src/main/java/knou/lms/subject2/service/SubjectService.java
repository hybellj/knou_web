package knou.lms.subject2.service;

import knou.lms.common.dto.BaseParam;
import knou.lms.subject2.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface SubjectService {

    public SubjectVO subjectSelect(BaseParam param) throws Exception;
    
    public SubjectVO subjectSelect(String	subjectId) throws Exception;

    public List<EgovMap> subjectLearningActvList(BaseParam param) throws Exception;

    public EgovMap sbjctAdmSelect(BaseParam param) throws Exception;

    public List<EgovMap> sbjctAdmList(BaseParam param) throws Exception;
    
    public List<EgovMap> sbjctAdmList(String	subjectId) throws Exception;

    public EgovMap middleLastExamSelect(BaseParam param) throws Exception;

    public EgovMap subjectBbsIdsSelect(BaseParam param) throws Exception;
}