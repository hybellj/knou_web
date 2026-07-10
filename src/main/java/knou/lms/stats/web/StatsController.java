package knou.lms.stats.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import knou.framework.common.CommConst;
import knou.framework.common.PageInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.service.CommonService;
import knou.lms.statistics.facade.StatisticsFacadeService;
import knou.lms.statistics.vo.LearnProgressVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.stats.service.StatsService;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.CurrentUser;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/stats")
public class StatsController extends ControllerBase {
	
	private static final Logger log = LoggerFactory.getLogger(StatsController.class);

    @Resource(name="statisticsFacadeService")
    private StatisticsFacadeService statisticsFacadeService;

	@Resource(name = "statsService")
    private StatsService statsService;

    @Resource(name = "commonService")
    private CommonService commonService;
	
	/**
     * 과목학습진도목록조회화면
     * @param SubjectVO
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping(value="/bySubjectLearningProgressListView.do")
    public String bySubjectLearningProgressListView(SubjectVO vo, @CurrentUser UserContext userCtx,
    										HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	model.addAttribute("vo", vo);
        return "stats/stdnt_learning_progress_list";
    }
  
    /*
     * 과목학습진도목록조회페이징
     */
    @RequestMapping(value={"/bySubjectLearningProgressListPaging.do"})
    @ResponseBody
    public ProcessResultVO<EgovMap> bySubjectLearningProgressListPaging(SubjectVO vo, @CurrentUser UserContext userCtx,
    							HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	
    	ProcessResultVO<EgovMap> resultVO = statsService.bySubjectLearningProgressListPaging(vo);    
    	
    	resultVO.setResultSuccess().setEncParams(getEncParams()); 
    	
    	model.addAttribute("vo", vo); // List 쿼리를 수행한 후 vo를 addAttribute 해줘야 함 // call by reference   
    	
        return resultVO;
    }

    /**
     * 교수 대시보드 > 학습진도관리
     *
     * @return learn_progress_list_view.jsp
     * @throws Exception
     */
    @RequestMapping("/profLrnPrgrtListView.do")
    public String profLrnPrgrtListView (LearnProgressVO vo, @CurrentUser UserContext userCtx, Model model) {

        if(!userCtx.getAuthrtGrpcd().equals("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }

        // 조회필터옵션 세팅
        userCtx.setUserRprsId(userCtx.getLoginUser().getUserRprsId());
        model.addAttribute("filterOptions", commonService.loadFilterOptions(userCtx));


        model.addAttribute("encParams", getEncParams());
        model.addAttribute("pageInfo", new PageInfo());

        return "statistics/learn_progress_list_view";
    }

    /**
     * 전체/운영과목에 대한 수강생 수, 평균학습진도율을 조회한다.
     *
     * @return 전체/운영과목 수강생 수, 평균학습진도율
     * @throws Exception
     */
    @GetMapping("/lrnPrgrtStatsSummaryAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> lrnPrgrtStatsSummaryAjax (SubjectVO sbjctVO, @CurrentUser UserContext userCtx) {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        sbjctVO.setOrgId(userCtx.getOrgId());
        sbjctVO.setUserId(userCtx.getUserId());

        resultVO.setReturnVO(statsService.lrnPrgrtStatsSummaryAjax(sbjctVO));
        resultVO.setResultSuccess();

        return resultVO;
    }



    /**
     * 학습자의 학습진도 현황 목록 조회 (페이징)
     * @param vo
     * @param userCtx
     * @return
     * @throws Exception
     */
    @GetMapping("/lrnPrgrtStatsListAjax.do")
    @ResponseBody
//    public ProcessResultVO<EgovMap> lessonProgressList(PageInfo pageInfo, @CurrentUser UserContext userCtx) throws Exception {
    public ResultDTO<EgovMap> lessonProgressList(PageInfo pageInfo, @CurrentUser UserContext userCtx) {

        String orgId = StringUtil.nvl(pageInfo.getOrgId(), userCtx.getOrgId());
        String userId = userCtx.getUserId();

        pageInfo.setOrgId(orgId);
        pageInfo.setUserId(userId);

        ResultDTO<EgovMap> resultDTO = statsService.stdntLrnPrgrtListPaging(pageInfo);
        resultDTO.setEncParams(getEncParams());

        return resultDTO;
    }


    /**
     * 교수 대시보드 > 학습진도관리 > 학과별 전체통계 팝업
     * @param userCtx
     * @param model
     * @return lesson_progress_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value = "/lrnPrgrtListByDeptPopView.do")
    public String lessonProgressPop(@CurrentUser UserContext userCtx, Model model) {

        if(!userCtx.getAuthrtGrpcd().equals("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }

        userCtx.setUserRprsId(userCtx.getLoginUser().getUserRprsId());

        // 조회필터옵션 세팅
        model.addAttribute("filterOptions", commonService.loadFilterOptions(userCtx));

        return "statistics/learn_progress_dept_list_popview";
    }

    /*****************************************************
     * 학과별 학습진도율 목록 조회
     * @return 학과별 학습진도율 목록
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lrnPrgrtListByDeptAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> lrnPrgrtListByDept(PageInfo pageInfo, @CurrentUser UserContext userCtx) {

        ResultDTO<EgovMap> resultDTO = new ResultDTO<>(pageInfo);

        if(!userCtx.getAuthrtGrpcd().equals("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }

        String orgId = StringUtil.nvl(pageInfo.getOrgId(),userCtx.getOrgId());
        pageInfo.setOrgId(orgId);

        resultDTO.setReturnList(statsService.listLrnPrgrtStatusByDept(pageInfo));

        return resultDTO.setResultSuccess();
    }

    /**
     * [과목관리자] 수업운영도구 > 과목관리 > 수업운영 > 과목별 학습진도현황
     *
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping("/admLrnPrgStsListBySbjct.do")
    public String admLrnPrgStsListBySbjct(SubjectVO vo, @CurrentUser UserContext userCtx, Model model) {
        String authrtCd = userCtx.getAuthrtCd();

        if ( !isSbjctop(userCtx) ) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        String orgId = authrtCd.equals(CommConst.AUTHRT_CD_SBJCTOP) ? userCtx.getOrgId() : "";

        PageInfo pageInfo = new PageInfo();
        pageInfo.setOrgId(orgId);
//        pageInfo.setRecordCountPerPage(20);


        // todo: filterOptions
        model.addAttribute("encParams", getEncParams());
        model.addAttribute("vo", vo);
        model.addAttribute("orgId", orgId);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("filterOptions", commonService.loadFilterOptions(userCtx));
        model.addAttribute("searchKey", "SBJCT");

        return "/statistics/adm_lrn_prg_stats_list_view";
    }

    /**
     * 과목별/담당별 학습진도현황 목록 AJAX 조회
     * @param pageInfo
     * @param userCtx
     * @return
     */
    @GetMapping("/admLrnPrgStsListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admLrnPrgStsListAjax(PageInfo pageInfo, @CurrentUser UserContext userCtx) {

        if ( !isSbjctop(userCtx) ) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        return statsService.lrnPrgStsListPaging(pageInfo);
    }

    /**
     * [과목관리자] 수업운영도구 > 과목관리 > 수업운영 > 담당별 학습진도현황
     *
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping("/admLrnPrgStsListBySbjctAdm.do")
    public String admLrnPrgStsListBySbjctAdm(SubjectVO vo, @CurrentUser UserContext userCtx, Model model) {
        String authrtCd = userCtx.getAuthrtCd();

        if ( !isSbjctop(userCtx) ) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        String orgId = authrtCd.equals(CommConst.AUTHRT_CD_SBJCTOP) ? userCtx.getOrgId() : "";

        PageInfo pageInfo = new PageInfo();
        pageInfo.setOrgId(orgId);
//        pageInfo.setRecordCountPerPage(20);

        List<EgovMap> sbjctAdmCdList = new ArrayList<>();
        EgovMap prof = new EgovMap();
        prof.put("cd", "PROF");
        prof.put("cdnm", "교수");

        EgovMap assi = new EgovMap();
        prof.put("cd", "ASSI");
        prof.put("cdnm", "조교");
        sbjctAdmCdList.add(prof);
        sbjctAdmCdList.add(assi);

        model.addAttribute("encParams", getEncParams());
        model.addAttribute("vo", vo);
        model.addAttribute("orgId", orgId);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("filterOptions", commonService.loadFilterOptions(userCtx));
        model.addAttribute("sbjctAdmCdList", sbjctAdmCdList);
        model.addAttribute("searchKey", "SBJCT_ADM");

        return "/statistics/adm_lrn_prg_stats_by_sbjctadm_list_view";
    }


    /**
     * 과목 운영자 여부 체크
     * @param userCtx
     * @return boolean
     */
    private boolean isSbjctop(UserContext userCtx) {

        boolean isSbjctop = false;
        List<String> allowedAuthrtCds = Arrays.asList(CommConst.AUTHRT_CD_ADM, CommConst.AUTHRT_CD_SBJCTOP);

        if ( userCtx.isAdmin() && allowedAuthrtCds.contains(userCtx.getAuthrtCd()) ) {
            isSbjctop = true;
        }

        return isSbjctop;
    }
}