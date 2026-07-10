package knou.lms.subject.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.lecture2.vo.LectureWknoScheduleVO;
import knou.lms.subject.dao.SubjectDAO;
import knou.lms.subject.service.SubjectFacadeService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectOrgDTO;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.subject.web.view.SubjectViewModel;
import knou.lms.user.CurrentUser;

@Service("subjectService")
public class SubjectServiceImpl extends ServiceBase implements SubjectService {

    private static final Logger log = LoggerFactory.getLogger(SubjectServiceImpl.class);

    @Resource(name="subjectDAO")
    private SubjectDAO subjectDAO;

    @Resource(name="subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;

    @Override
    public SubjectVO subjectSelect(CommonDTO cmmnDto) {
        return subjectDAO.subjectSelect(cmmnDto);
    }

    @Override
    public List<EgovMap> subjectLearningActvList(CommonDTO cmmnDto){
        return subjectDAO.subjectLearningActvList(cmmnDto);
    }

    @Override
    public EgovMap sbjctAdmSelect(CommonDTO cmmnDto){
        return subjectDAO.sbjctAdmSelect(cmmnDto);
    }

    @Override
    public List<EgovMap> sbjctAdmList(CommonDTO cmmnDto) {
        return subjectDAO.sbjctAdmList(cmmnDto);
    }

    @Override
    public EgovMap middleLastExamSelect(CommonDTO cmmnDto){
        return subjectDAO.middleLastExamSelect(cmmnDto);
    }

    @Override
    public EgovMap subjectBbsIdsSelect(CommonDTO cmmnDto){
        return subjectDAO.subjectBbsIdsSelect(cmmnDto);
    }

    @Override
    public List<EgovMap> profSubjectSummaryList(CommonDTO cmmnDto) {
        return subjectDAO.profSubjectSummaryList(cmmnDto);
    }

    @Override
    public List<EgovMap> stdntSubjectSummaryList(CommonDTO cmmnDto) {
        return subjectDAO.stdntSubjectSummaryList(cmmnDto);
    }

	@Override
	public boolean hasSubjectAuthority(SubjectDTO sbjctDto) {
		return subjectDAO.stdntOrProfCountSelect(sbjctDto) != 0;
    }

	@Override
	public LectureWknoScheduleVO currLctrWknoSchdlSelect(String sbjctId){
		return subjectDAO.currLctrWknoSchdlSelect(sbjctId);
	}

	@Override
	public int connectStdCntSelect(String userId) {
		return	subjectDAO.connectStdCntSelect(userId);
	}

	@Override
	public int totalStdCntSelect(String userId)  {
		return	subjectDAO.totalStdCntSelect(userId);
	}

	@Override
	public List<EgovMap> stdntSubjectConnectList(String sbjctId) {
		return	subjectDAO.stdntSubjectConnectList(sbjctId);
	}

	@Override
	public int subjectConnectStdCntSelect(String sbjctId) {
		return	subjectDAO.subjectConnectStdCntSelect(sbjctId);
	}

	@Override
	public int subjectTotalStdCntSelect(String sbjctId)  {
		return	subjectDAO.subjectTotalStdCntSelect(sbjctId);
	}

	@Override
	public EgovMap lctrWknoAtndcrtSelect(String sbjctId, String lctrWknoSchdlId) {
		return subjectDAO.lctrWknoAtndcrtSelect(sbjctId, lctrWknoSchdlId);
	}

	/**
	 * 사용자 운영/수강 과목 기관 목록 조회
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<SubjectOrgDTO> selectUserSubjectOrgList(String userId) throws Exception {
		return subjectDAO.selectUserSubjectOrgList(userId);
	}

	/**
	 * 과목운영자권한조회
	 * @param sbjctId
	 * @param userId
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String subjectByAdmAuthSelect(String sbjctId, String userId) throws Exception {
		return subjectDAO.subjectByAdmAuthSelect(sbjctId, userId);
	}

	/**
	 * 과목수강생권한조회
	 * @param sbjctId
	 * @param userId
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String subjectByStdntAuthSelect(String sbjctId, String userId) throws Exception {
		return subjectDAO.subjectByStdntAuthSelect(sbjctId, userId);
	}

	/**
	 * 교수자 운영과목 전체 조회
	 * @param userId
	 * @return List<SubjectVO>
	 * @throws Exception
	 */
	@Override
	public List<SubjectVO> subjectListAllByProf(String userId) throws Exception {
		return subjectDAO.subjectListAllByProf(userId);
	}

	/**
	 * 학생 수강과목 전체 조회
	 * @param userId
	 * @return List<SubjectVO>
	 * @throws Exception
	 */
	public List<SubjectVO> subjectListAllByStdnt(String userId) throws Exception {
		return subjectDAO.subjectListAllByStdnt(userId);
	}

	@Override
	public List<EgovMap> admByOrgByDeptSubjectSelect(PageInfo pageInfo) {
		return subjectDAO.admByOrgByDeptSubjectSelect(pageInfo);
	}

	@Override
	public boolean isSubjectAuthrt(UserContext userCtx, String sbjctId) {

		SubjectDTO sbjctDto = new SubjectDTO (userCtx, sbjctId);

		if ( null == sbjctId || "".equals(sbjctId)) {
			log.info("과목아이디가 없습니다.");
			return false;
		}

		sbjctDto.setProfIds(userCtx.getProfIds());
		sbjctDto.setStdntIds(userCtx.getStdntIds());

		// 과목접근권한확인
		if ( ! hasSubjectAuthority( sbjctDto ) ) {
			log.info("과목 접근 권한이 없습니다");
			return false;
		}
		return true;
	}

	@Override
	public SubjectViewModel getSubjectCommonData(@CurrentUser UserContext userCtx, String sbjctId, ModelMap model) {

		String	userId = userCtx.getLoginUser().getUserId();

		// 주차 및 주차출석정보
    	LectureWknoScheduleVO lctrWknoSchdlVO = currLctrWknoSchdlSelect(sbjctId);
    	model.addAttribute("lctrWknoSchdlVO", lctrWknoSchdlVO);

    	//	접속학생수
    	int connectStdCnt = connectStdCntSelect(userId);
    	model.addAttribute("connectStdCnt", connectStdCnt);

    	// 	과목접속학생수
    	int sbjctConnectStdCnt = subjectConnectStdCntSelect(sbjctId);
    	model.addAttribute("sbjctConnectStdCnt", sbjctConnectStdCnt);

    	//	전체수강생수
    	int	totalStdCnt = totalStdCntSelect(userId);
    	model.addAttribute("totalStdCnt", totalStdCnt);

    	//	과목수강생수
    	int	sbjctTotalStdCnt = subjectTotalStdCntSelect(sbjctId);
    	model.addAttribute("sbjctTotalStdCnt", sbjctTotalStdCnt);

    	//	과목접속학생목록조회
    	List<EgovMap> stdntSubjectConnectList = stdntSubjectConnectList(sbjctId);
    	model.addAttribute("stdntSubjectConnectList", stdntSubjectConnectList);

    	return subjectFacadeService.getSubjectViewModel(userCtx, sbjctId);
	}


	/**
	 * 사용자 운영/수강과목 학기 목록 조회
	 * @param userId
	 * @param orgId
	 * @return List<SmstrChrtVO>
	 * @throws Exception
	 */
	@Override
	public List<SmstrChrtVO> selectUserSemesterList(String userId, String orgId) throws Exception {
		return subjectDAO.selectUserSemesterList(userId, orgId);
	}
}