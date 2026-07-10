package knou.lms.mrk.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.lms.asmt2.service.AsmtService;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.exam.service.ExamService;
import knou.lms.forum2.service.DscsService;
import knou.lms.mrk.dao.MarkItemSettingDAO;
import knou.lms.mrk.service.MarkFacadeService;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.service.MarkObjectionApplyService;
import knou.lms.mrk.service.MarkService;
import knou.lms.mrk.service.MarkSubjectService;
import knou.lms.mrk.vo.MarkItemSettingVO;
import knou.lms.mrk.vo.MarkObjectionApplyVO;
import knou.lms.mrk.vo.MarkObjectionApplyView;
import knou.lms.mrk.vo.MarkSubjectDetailView;
import knou.lms.mrk.vo.MarkView;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.schedule.service.CalendarService;
import knou.lms.schedule.vo.OrgTaskScheduleVO;
import knou.lms.smnr.service.SmnrService;
import knou.lms.srvy.service.SrvyService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UserPrfilService;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UserPrfilVO;
import knou.lms.user.vo.UsrDeptCdVO;

@Service("markFacadeService")
public class MarkFacadeServiceImpl extends ServiceBase implements MarkFacadeService {
	
	@Resource(name="semesterService")
    private SemesterService semesterService;
	
	@Resource(name="orgInfoService")
	private OrgInfoService orgInfoService;
	
	@Resource(name="usrDeptCdService")
	private UsrDeptCdService usrDeptCdService;

    @Resource(name="markItemSettingService")
    private MarkItemSettingService markItemSettingService;
    
    @Resource(name="markService")
    private MarkService markService;

    @Resource(name = "markSubjectService")
    private MarkSubjectService markSubjectService;

    @Resource(name = "markObjectionApplyService")
    private MarkObjectionApplyService markObjectionApplyService;

    @Resource(name = "subjectService")
    private SubjectService subjectService;

    @Resource(name = "calendarService")
    private CalendarService calendarService;

    @Resource(name="markItemSettingDAO")
    private MarkItemSettingDAO markItemSettingDAO;

    @Resource(name="userPrfilService")
    private UserPrfilService userPrfilService;
    
    @Resource(name="asmt2Service")
    private AsmtService asmt2Service;
    
    @Resource(name="dscsService")
    private DscsService dscsService;
    
    @Resource(name="examService")
    private ExamService examService;
    
    @Resource(name="srvyService")
    private SrvyService srvyService;
    
    @Resource(name="smnrService")
    private SmnrService smnrService;

    @Override
	public EgovMap loadFilterOptions(UserContext userCtx) {
		
		EgovMap filterOptions = new EgovMap();
		
		String orgId = userCtx.getOrgId();
		filterOptions.put("orgId", orgId);
		
		// 연도 목록
		filterOptions.put("yearList", DateTimeUtil.getYearList(10, "mix"));
		
		// 현재 연도 : yyyy
		String curYear = DateTimeUtil.getYear();
		filterOptions.put("curYear", curYear);
		
		// 조회기준연도에 개설된 학기기수 조회
		SmstrChrtVO curSmstrChrtVO = new SmstrChrtVO();
		curSmstrChrtVO.setOrgId(orgId);
		curSmstrChrtVO.setDgrsYr(curYear);
		filterOptions.put("smstrChrtList", semesterService.listSmstrChrtByDgrsYr(curSmstrChrtVO));
		
		// 기관 목록 조회
		OrgInfoVO orgInfoVO = new OrgInfoVO();
        orgInfoVO.setOrgId(orgId);
        filterOptions.put("orgList", orgInfoService.list(orgInfoVO));
        
        // 기관에 따른 학과 조회
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        filterOptions.put("deptList", usrDeptCdService.list(usrDeptCdVO));
		
		return filterOptions;
	}

    /**
     * 성적 이의신청 시작,종료 기간 조회
     * @param orgId
     * @return
     */
    @Override
    public Map<String, String> getMrkObjctAplyPrd(String orgId){

        OrgTaskScheduleVO schdlVO = calendarService.orgTaskSchdlSelect(orgId, "MRK_OBJCT_APLY_PRD");

        Map<String, String> resultMap = new HashMap<>();

        resultMap.put("taskSdttm", schdlVO == null ? "" : schdlVO.getTaskSdttm());
        resultMap.put("taskEdttm", schdlVO == null ? "" : schdlVO.getTaskEdttm());

        return resultMap;
    }

    /**
     * 성적 상세 정보를 가져온다.
     * - 과목 성적항목 비율
     * - 학생 성적 상세
     * @param sbjctId
     * @param userId
     * @return
     */
    @Override
    public MarkSubjectDetailView getStdMrkSbjctDtl(String orgId, String sbjctId, String userId) {
        MarkSubjectDetailView detailView = new MarkSubjectDetailView();

        // 과목 성적항목비율
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setOrgId(orgId);
        mrkItmStngVO.setSbjctId(sbjctId);

        List<EgovMap> mrkItmStnglist = markItemSettingService.mrkItmStngList(mrkItmStngVO);

        int totalRatio = 0; // 평가비중 총합

        for (EgovMap map : mrkItmStnglist){
            int mrkRfltrt = ((Number)map.get("mrkRfltrt")).intValue();
            totalRatio += mrkRfltrt;

            if (mrkRfltrt == 0) {
                map.replace("mrkItmTycd", "-");
            }
        }
        detailView.setTotalRatio(totalRatio);
        detailView.setMrkItmStngList(mrkItmStnglist);

        // 학생 성적 상세
        EgovMap mrkDtlMap = markSubjectService.getStdMrkDetails(sbjctId, userId);
        detailView.setStdMrkSbjctDtlInfo(mrkDtlMap);

        return detailView;
    }

    /**
     * 학생 성적현황 정보
     * - 학생 성적항목별 점수 목록
     * - 과목 성적항목별 평균점수 목록
     * - 점수 구간별 분포 목록
     * @param sbjctId
     * @param userId
     * @return
     */
    @Override
    public MarkSubjectDetailView getStdMrkSbjctSts(String sbjctId, String userId) {
        MarkSubjectDetailView detailView = new MarkSubjectDetailView();

        // 학생 성적항목별 점수 목록
        EgovMap mrkDtlMap = markSubjectService.getStdMrkDetails(sbjctId, userId);
        detailView.setStdMrkSbjctDtlInfo(mrkDtlMap);

        // 과목 성적항목별 평균점수 목록
        Map<String, Double> avgScrInfo = markSubjectService.getAvgScrInfoByMrkItm(sbjctId);
        detailView.setAvgScrInfoByMrkItm(avgScrInfo);

        // 점수 구간 현황
        detailView.setMrkRangeStatus(markSubjectService.getMrkRangeStatus(sbjctId));

        return detailView;
    }

    /**
     * 학생의 성적 이의신청 정보를 가져온다.
     * @param sbjctId
     * @param userCtx
     * @return
     */
    @Override
    public MarkObjectionApplyView getStdMrkObjctAply(String sbjctId, @CurrentUser UserContext userCtx, String mrkObjctAplyId) {

        MarkObjectionApplyView applyView = new MarkObjectionApplyView();
        
        SubjectDTO sbjctDto = new SubjectDTO(sbjctId);

        // 과목정보
        SubjectVO subjectVO = subjectService.subjectSelect(sbjctDto);
        applyView.setSbjctInfo(subjectVO);

        // 학생 정보
        UserPrfilVO userPrfilVO = new UserPrfilVO();
        userPrfilVO.setUserId(userCtx.getUserId());
        userPrfilVO.setAuthrtGrpcd(userCtx.getAuthrtGrpcd());
        userPrfilVO = userPrfilService.userPrfilSelect(userPrfilVO);
        applyView.setUserInfo(userPrfilVO);

        // 성적 이의신청 정보
        MarkObjectionApplyVO applyVO = new MarkObjectionApplyVO();
        applyVO = markObjectionApplyService.mrkObjctAplySelect(mrkObjctAplyId);
        applyView.setApplyInfo(applyVO);

        return applyView;
    }

    /**
     * 
     * @param sbjctId
     * @param orgId
     * @return
     */
	@Override
	public MarkView getMarkActvInfoSelect(String sbjctId, UserContext userCtx) {
		
		MarkView markView = new MarkView();
		
		if ( userCtx.isProfessor() ) {
			markView.setViewName("mrk/popup/prof_mrk_eval_weight_list"); // 교수화면
		} else if ( userCtx.isStudent() ) {
			markView.setViewName("mrk/popup/stdnt_mrk_eval_weight_list"); // 학생화면
		} else {
			markView.setViewName("common/error");
		}
		
		// 성적항목설정목록조회
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO( sbjctId, userCtx.getOrgId() );
        markView.setMrkItmStngList( markItemSettingService.mrkItmStngList(mrkItmStngVO) );
        
		// 성적활동항목평가비율조회
		MarkItemSettingVO vo = new MarkItemSettingVO(sbjctId, userCtx.getOrgId(), "", "ko");
		markView.setMrkActvItmRateList( markService.markActivityEvalRateSelect(vo));
    	
        return markView;
	}
}