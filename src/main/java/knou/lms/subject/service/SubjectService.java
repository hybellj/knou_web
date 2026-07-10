package knou.lms.subject.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.ui.ModelMap;

import knou.framework.common.PageInfo;
import knou.framework.context2.UserContext;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.lecture2.vo.LectureWknoScheduleVO;
import knou.lms.subject.vo.SubjectOrgDTO;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.subject.web.view.SubjectViewModel;

public interface SubjectService {

    public SubjectVO subjectSelect(CommonDTO cmmnDto);

    public List<EgovMap> subjectLearningActvList(CommonDTO cmmnDto);

    public EgovMap sbjctAdmSelect(CommonDTO cmmnDto);

    public List<EgovMap> sbjctAdmList(CommonDTO cmmnDto);

    public EgovMap middleLastExamSelect(CommonDTO cmmnDto);

    public EgovMap subjectBbsIdsSelect(CommonDTO cmmnDto);

	public List<EgovMap> profSubjectSummaryList(CommonDTO cmmnDto);

	public List<EgovMap> stdntSubjectSummaryList(CommonDTO cmmnDto);

	public boolean hasSubjectAuthority(SubjectDTO sbjctDto);

	public LectureWknoScheduleVO currLctrWknoSchdlSelect(String sbjctId);

	public int connectStdCntSelect(String userId);

	public int totalStdCntSelect(String userId);

	public List<EgovMap> stdntSubjectConnectList(String sbjctId);

	public int subjectConnectStdCntSelect(String sbjctId);

	public int subjectTotalStdCntSelect(String sbjctId);

	public EgovMap lctrWknoAtndcrtSelect(String sbjctId, String lctrWknoSchdlId);

	/**
	 * 사용자 운영/수강 과목 기관 목록 조회
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<SubjectOrgDTO> selectUserSubjectOrgList(String userId) throws Exception;

	/**
	 * 과목운영자권한조회
	 * @param sbjctId
	 * @param userId
	 * @return String
	 * @throws Exception
	 */
	public String subjectByAdmAuthSelect(String sbjctId, String userId) throws Exception;

	/**
	 * 과목수강생권한조회
	 * @param sbjctId
	 * @param userId
	 * @return String
	 * @throws Exception
	 */
	public String subjectByStdntAuthSelect(String sbjctId, String userId) throws Exception;

	/**
	 * 교수자 운영과목 전체 조회
	 * @param userId
	 * @return List<SubjectVO>
	 * @throws Exception
	 */
	public List<SubjectVO> subjectListAllByProf(String userId) throws Exception;

	/**
	 * 학생 수강과목 전체 조회
	 * @param userId
	 * @return List<SubjectVO>
	 * @throws Exception
	 */
	public List<SubjectVO> subjectListAllByStdnt(String userId) throws Exception;

	public List<EgovMap> admByOrgByDeptSubjectSelect(PageInfo pageInfo);

	public SubjectViewModel getSubjectCommonData(UserContext userCtx, String sbjctId, ModelMap model);

	public boolean isSubjectAuthrt(UserContext userCtx, String sbjctId);

	/**
	 * 사용자 운영/수강과목 학기 목록 조회
	 * @param userId
	 * @param orgId
	 * @return List<SmstrChrtVO>
	 * @throws Exception
	 */
	public List<SmstrChrtVO> selectUserSemesterList(String userId, String orgId) throws Exception;
}