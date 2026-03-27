package knou.lms.subject.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.common.dto.BaseParam;
import knou.lms.subject.dao.SubjectDAO;
import knou.lms.subject.dto.SubjectParam;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.LectureWknoScheduleVO;
import knou.lms.subject.vo.SubjectVO;

@Service("subjectService")
public class SubjectServiceImpl extends ServiceBase implements SubjectService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SubjectServiceImpl.class);

    @Resource(name="subjectDAO")
    private SubjectDAO subjectDAO;
    
    @Override
    public SubjectVO subjectSelect(String	subjectId) throws Exception {
        return subjectDAO.subjectSelect(new SubjectParam(subjectId));
    }

    @Override
    public SubjectVO subjectSelect(BaseParam param) throws Exception {
        return subjectDAO.subjectSelect(param);
    }

    @Override
    public List<EgovMap> subjectLearningActvList(BaseParam param) throws Exception {
        return subjectDAO.subjectLearningActvList(param);
    }

    @Override
    public EgovMap sbjctAdmSelect(BaseParam param) throws Exception {
        return subjectDAO.sbjctAdmSelect(param);
    }
   
    @Override
    public List<EgovMap> sbjctAdmList(BaseParam param) throws Exception {
        return subjectDAO.sbjctAdmList(param);
    }
    
    @Override
    public List<EgovMap> sbjctAdmList(String	subjectId) throws Exception {
        return subjectDAO.sbjctAdmList(new SubjectParam(subjectId));
    }

    @Override
    public EgovMap middleLastExamSelect(BaseParam param) throws Exception {
        return subjectDAO.middleLastExamSelect(param);
    }

    @Override
    public EgovMap subjectBbsIdsSelect(BaseParam param) throws Exception {
        return subjectDAO.subjectBbsIdsSelect(param);
    }
    
    @Override
    public List<EgovMap> profSubjectSummaryList(BaseParam param) throws Exception {
        return subjectDAO.profSubjectSummaryList(param);
    }
    
    @Override
    public List<EgovMap> stdntSubjectSummaryList(BaseParam param) throws Exception {
        return subjectDAO.stdntSubjectSummaryList(param);
    }

	@Override
	public boolean hasSubjectAuthority(String subjectId, UserContext userCtx) throws Exception {
		return subjectDAO.stdntOrProfCountSelect(new SubjectParam(subjectId, userCtx)) != 0;
    }

	@Override
	public LectureWknoScheduleVO currLctrWknoSchdlSelect(String sbjctId) throws Exception {
		return subjectDAO.currLctrWknoSchdlSelect(sbjctId);
	}

	@Override
	public int connectStdCntSelect(String userId) throws Exception {
		return	subjectDAO.connectStdCntSelect(userId);
	}

	@Override
	public int totalStdCntSelect(String userId) throws Exception {
		return	subjectDAO.totalStdCntSelect(userId);
	}

	@Override
	public List<EgovMap> stdntSubjectConnectList(String sbjctId) throws Exception {
		return	subjectDAO.stdntSubjectConnectList(sbjctId);
	}

	@Override
	public int subjectConnectStdCntSelect(String sbjctId) throws Exception {
		return	subjectDAO.subjectConnectStdCntSelect(sbjctId);
	}

	@Override
	public int subjectTotalStdCntSelect(String sbjctId) throws Exception {
		return	subjectDAO.subjectTotalStdCntSelect(sbjctId);
	}

	@Override
	public EgovMap lctrWknoAtndcrtSelect(String sbjctId, String lctrWknoSchdlId) throws Exception {		
		return subjectDAO.lctrWknoAtndcrtSelect(sbjctId, lctrWknoSchdlId);
	}
}