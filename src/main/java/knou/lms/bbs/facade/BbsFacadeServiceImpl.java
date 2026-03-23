package knou.lms.bbs.facade;


import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Service("bbsFacadeService")
public class BbsFacadeServiceImpl extends ServiceBase implements BbsFacadeService{

	@Resource(name="semesterService")
    private SemesterService semesterService;

	@Resource(name="orgInfoService")
	private OrgInfoService orgInfoService;

	@Resource(name="usrDeptCdService")
	private UsrDeptCdService usrDeptCdService;

	@Resource(name="sbjctService")
	private SbjctService sbjctService;

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

        // 과목 조회
        SbjctVO sbjctVO = new SbjctVO();
        sbjctVO.setOrgId(orgId);
        filterOptions.put("sbjctList", sbjctService.list(sbjctVO));

		return filterOptions;
	}
}
