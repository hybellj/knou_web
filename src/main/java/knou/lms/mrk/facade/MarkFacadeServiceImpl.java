package knou.lms.mrk.facade;

import javax.annotation.Resource;
import javax.security.auth.Subject;

import knou.framework.common.IdPrefixType;
import knou.framework.util.IdGenUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.service.MarkSubjectService;
import knou.lms.mrk.vo.MarkItemSettingVO;
import knou.lms.mrk.vo.MarkSubjectDetailVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import knou.lms.sch.service.SchCalendarService;
import knou.lms.sch.service.impl.SchCalendarServiceImpl;
import knou.lms.sch.vo.OrgTaskScheduleVO;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @Resource(name = "markSubjectService")
    private MarkSubjectService markSubjectService;

    @Resource(name = "subjectService")
    private SubjectService subjectService;

    @Resource(name = "schCalendarService")
    private SchCalendarService schCalendarServiceImpl;


    @Override
	public EgovMap loadFilterOptions(UserContext userCtx) throws Exception {
		
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

    @Override
    public Map<String, String> getMrkObjctAplyPrd(String orgId){

        OrgTaskScheduleVO schdlVO = schCalendarServiceImpl.orgTaskSchdlSelect(orgId, "MRK_OBJCT_APLY_PRD");

        Map<String, String> resultMap = new HashMap<>();

        resultMap.put("taskSdttm", schdlVO == null ? "" : schdlVO.getTaskSdttm());
        resultMap.put("taskEdttm", schdlVO == null ? "" : schdlVO.getTaskEdttm());

        return resultMap;
    }
}
