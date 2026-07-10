package knou.lms.subject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.CommonDTO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.lecture2.vo.LectureWknoScheduleVO;
import knou.lms.subject.vo.SubjectOrgDTO;
import knou.lms.subject.vo.SubjectVO;

/**
 * 과목정보 DAO
 */
@Mapper("subjectDAO")
public interface SubjectDAO {

    public SubjectVO subjectSelect(CommonDTO cmmnDto);

    public List<EgovMap> subjectLearningActvList(CommonDTO cmmnDto);

    public EgovMap sbjctAdmSelect(CommonDTO cmmnDto);

    public List<EgovMap> sbjctAdmList(CommonDTO cmmnDto);

    public EgovMap middleLastExamSelect(CommonDTO cmmnDto);

	public EgovMap subjectBbsIdsSelect(CommonDTO cmmnDto);

	public List<EgovMap> profSubjectSummaryList(CommonDTO cmmnDto);

	public List<EgovMap> stdntSubjectSummaryList(CommonDTO cmmnDto);

	public int stdntOrProfCountSelect(CommonDTO cmmnDto);

	public LectureWknoScheduleVO currLctrWknoSchdlSelect(String sbjctId) ;

	public int connectStdCntSelect(String userId) ;

	public int totalStdCntSelect(String userId) ;

	public List<EgovMap> stdntSubjectConnectList(String sbjctId);

	public int subjectConnectStdCntSelect(String sbjctId);

	public int subjectTotalStdCntSelect(String sbjctId);

	public EgovMap lctrWknoAtndcrtSelect(@Param("sbjctId") String sbjctId, @Param("lctrWknoSchdlId") String lctrWknoSchdlId) ;

	/**
	 * 사용자 운영/수강 과목 기관 목록 조회
	 * @param userId
	 * @return List<SubjectOrgDTO>
	 */
	public List<SubjectOrgDTO> selectUserSubjectOrgList(String userId);

	/**
	 * 과목운영자권한조회
	 * @param sbjctId
	 * @param userId
	 * @return String
	 * @throws Exception
	 */
	public String subjectByAdmAuthSelect(@Param("sbjctId") String sbjctId, @Param("userId") String userId) throws Exception;

	/**
	 * 과목수강생권한조회
	 * @param sbjctId
	 * @param userId
	 * @return String
	 * @throws Exception
	 */
	public String subjectByStdntAuthSelect(@Param("sbjctId") String sbjctId, @Param("userId") String userId) throws Exception;

	/**
	 * 교수자 운영과목 전제 조회
	 * @param userId
	 * @return List<SubjectVO>
	 * @throws Exception
	 */
	public List<SubjectVO> subjectListAllByProf(@Param("userId") String userId) throws Exception;

	/**
	 * 학생 수강과목 전체 조회
	 * @param userId
	 * @return List<SubjectVO>
	 * @throws Exception
	 */
	public List<SubjectVO> subjectListAllByStdnt(@Param("userId") String userId) throws Exception;

	public List<EgovMap> admByOrgByDeptSubjectSelect(PageInfo pageInfo);

	/**
	 * 사용자 운영/수강과목 학기 목록 조회
	 * @param userId
	 * @param orgId
	 * @return List<SmstrChrtVO>
	 * @throws Exception
	 */
	public List<SmstrChrtVO> selectUserSemesterList(@Param("userId") String userId, @Param("orgId") String orgId) throws Exception;
}