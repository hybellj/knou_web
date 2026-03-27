package knou.lms.subject.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.BaseParam;
import knou.lms.subject.vo.LectureWknoScheduleVO;
import knou.lms.subject.vo.SubjectVO;

public interface SubjectService {

    public SubjectVO subjectSelect(BaseParam param) throws Exception;
    
    public SubjectVO subjectSelect(String	subjectId) throws Exception;

    public List<EgovMap> subjectLearningActvList(BaseParam param) throws Exception;

    public EgovMap sbjctAdmSelect(BaseParam param) throws Exception;

    public List<EgovMap> sbjctAdmList(BaseParam param) throws Exception;
    
    public List<EgovMap> sbjctAdmList(String subjectId) throws Exception;

    public EgovMap middleLastExamSelect(BaseParam param) throws Exception;

    public EgovMap subjectBbsIdsSelect(BaseParam param) throws Exception;

	public List<EgovMap> profSubjectSummaryList(BaseParam param) throws Exception;
	
	public List<EgovMap> stdntSubjectSummaryList(BaseParam param) throws Exception;

	public boolean hasSubjectAuthority(String subjectId, UserContext userCtx) throws Exception;

	public LectureWknoScheduleVO currLctrWknoSchdlSelect(String sbjctId) throws Exception;

	public int connectStdCntSelect(String userId) throws Exception;

	public int totalStdCntSelect(String userId) throws Exception;

	public List<EgovMap> stdntSubjectConnectList(String sbjctId) throws Exception;

	public int subjectConnectStdCntSelect(String sbjctId)  throws Exception;

	public int subjectTotalStdCntSelect(String sbjctId) throws Exception;

	public EgovMap lctrWknoAtndcrtSelect(String sbjctId, String lctrWknoSchdlId) throws Exception;
}