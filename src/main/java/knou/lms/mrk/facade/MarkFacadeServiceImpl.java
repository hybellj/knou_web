package knou.lms.mrk.facade;

import javax.annotation.Resource;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mrk.dao.MarkSubjectDAO;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.vo.MarkItemSettingVO;
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

import java.util.ArrayList;
import java.util.List;

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
    @Autowired
    private MarkSubjectDAO markSubjectDAO;

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
    public ProcessResultVO<EgovMap> stdMrkListSelect(String orgId, String sbjctId, String searchType) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        // 미평가, 결시신청 따로 조회
        String[] stdNos = null;

        switch (searchType) {
            case "btnZero" :
                stdNos = new String[]{"user001", "user002"};
                break;

            case "btnApprove" :
                stdNos = new String[]{"user001", "user002"};
                break;

            case "btnApplicate" :
                stdNos = new String[]{"user001", "user002"};
                break;

            default:
                stdNos = new String[]{""};
                break;
        };

        // 학생 수 -> ReturnVO
        int totCnt = 0;
        totCnt = markSubjectDAO.stdMrkListCntSelect(sbjctId);
        EgovMap listCnt = new EgovMap();
        listCnt.put("totCnt", totCnt);
        resultVO.setReturnVO(listCnt);

        // 학생 성적 목록 -> ReturnListVO
        EgovMap searchMap = new EgovMap();
        searchMap.put("searchType", searchType);
        searchMap.put("sbjctId", sbjctId);
        searchMap.put("stdNos", stdNos);

        List<EgovMap> listStdMrk = new ArrayList<>();
        listStdMrk = markSubjectDAO.stdMrkList(searchMap);
        resultVO.setReturnList(listStdMrk);

        // 성적반영비율 -> ReturnSubVO
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(orgId);
        mrkItmStngVO.setMrkItmUseyn("Y");

        List<EgovMap> mrkItmStngList = markItemSettingService.mrkItmStngList(mrkItmStngVO);
        resultVO.setReturnSubVO(mrkItmStngList);

        return resultVO;
    }
}
