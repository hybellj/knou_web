package knou.lms.subject2.service;

import knou.framework.common.ServiceBase;
import knou.lms.subject2.dao.SubjectDAO;
import knou.lms.subject2.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("subjectService")
public class SubjectServiceImpl extends ServiceBase implements SubjectService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SubjectServiceImpl.class);

    @Resource(name="subjectDAO")
    private SubjectDAO subjectDAO;

    @Override
    public SubjectVO subjectSelect(String subjectId) throws Exception {
        return subjectDAO.subjectSelect(subjectId);
    }

    @Override
    public List<EgovMap> subjectLearningActvList(String subjectId) throws Exception {
        return subjectDAO.subjectLearningActvList(subjectId);
    }

    @Override
    public EgovMap sbjctAdmSelect(String subjectId) throws Exception {
        return subjectDAO.sbjctAdmSelect(subjectId);
    }

    /**
     * 과목관리자정보 목록 조회
     *
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> sbjctAdmList(String subjectId) throws Exception {
        return subjectDAO.sbjctAdmList(subjectId);
    }

    @Override
    public EgovMap middleLastExamSelect(String subjectId) throws Exception {
        return subjectDAO.middleLastExamSelect(subjectId);
    }

    @Override
    public EgovMap subjectBbsIdsSelect(String subjectId) throws Exception {
        return subjectDAO.subjectBbsIdsSelect(subjectId);
    }
}