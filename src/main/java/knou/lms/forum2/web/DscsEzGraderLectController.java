package knou.lms.forum2.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.service.DscsEzGraderService;
import knou.lms.forum2.service.DscsFdbkService;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsEzGraderRsltVO;
import knou.lms.forum2.vo.DscsEzGraderVO;
import knou.lms.forum2.vo.DscsFdbkVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import knou.lms.forum2.vo.DscsVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Locale;


@Controller
@RequestMapping(value = "/forum2/ezgPop")
public class DscsEzGraderLectController extends ControllerBase {

    // 상호평가
    @Resource(name="dscsEzGraderService")
    private DscsEzGraderService dscsEzGraderService;
    
    // 토론 정보
    @Resource(name="dscsService")
    private DscsService dscsService;
    
    // 토론 참여자
    @Resource(name = "dscsJoinUserService")
    private DscsJoinUserService dscsJoinUserService;
    
    //
    @Resource(name = "stdService")
    private StdService stdService;
    
    //
    @Resource(name = "usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;
    
    @Resource(name = "messageSource")
    private MessageSource messageSource;
    
    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    @Resource(name = "dscsFdbkService")
    private DscsFdbkService dscsFdbkService;
    
    // EZ-Grader 메인
    @RequestMapping(value = "/ezgMainForm.do")
    public String getEzgMainView(DscsEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String sbjctId = vo.getSbjctId();
        
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        vo.setDscsId(vo.getDscsId());
        vo.setStdId(vo.getStdId());
        vo.setSbjctId(sbjctId);
        vo.setEvlScrTycd(vo.getEvlScrTycd());
        
        // 모든 토론 참여자를 토론 참여자 테이블에 삽입
        DscsVO forumVO = new DscsVO();
        forumVO.setRgtrId(userId);
        forumVO.setSbjctId(sbjctId);
        forumVO.setDscsId(vo.getDscsId());
        dscsJoinUserService.insertJoinUser(forumVO);

        request.setAttribute("vo", vo);
        
        return "forum2/ezgPop/ezg_main_form";
    }

    // 토론정보 조회
    @RequestMapping(value = "/forum.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> getForumInfoByAjax(DscsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<DscsVO>();
        try {
            // TODO : 26.3.20 : to-be vo 변경에 따른 처리.
           /* DscsVO forumVO = dscsService.selectDscs(vo);*/
            DscsVO param = new DscsVO();
            param.setDscsId(vo.getDscsId());
            DscsVO loadedDscsVO = dscsService.selectDscs(param);
            DscsVO forumVO = loadedDscsVO;

            resultVO.setReturnVO(forumVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    // 대상 사용자 또는 팀 search view
    @RequestMapping(value = "/ezgJoinUserSearchView.do")
    public String getEzgJoinUserSearchView(DscsEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        request.setAttribute("vo", vo);
        return "forum2/ezgPop/ezg_join_user_search";
    }

    // 토론 제출 대상 리스트 조회
    @RequestMapping(value = "/joinUserList.do")
    public String getForumJoinUserListForEzg(DscsVO dscsVO, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        dscsVO.setOrgId(orgId);
        dscsVO = dscsService.selectDscs(dscsVO);

        DscsJoinUserVO paramVO = new DscsJoinUserVO();
        paramVO.setDscsId(dscsVO.getDscsId());
        paramVO.setCrsCreCd(dscsVO.getSbjctId());
        paramVO.setSearchKey(dscsVO.getSearchKey());
        paramVO.setSearchSort(dscsVO.getSearchSort());
        paramVO.setDscsUnitTycd(dscsVO.getDscsUnitTycd());

        String viewNm = "";
        if ("TEAM".equals(dscsVO.getDscsUnitTycd())) {
            List<DscsEzGraderTeamVO> resultList= dscsEzGraderService.listDscsJoinTeam(paramVO, dscsVO.getByteamDscsUseyn());
            request.setAttribute("resultList", resultList);
            viewNm = "forum2/ezgPop/ezg_join_team_list";
        } else {
            List<DscsJoinUserVO> resultList= dscsEzGraderService.listDscsJoinUser(paramVO);
            request.setAttribute("resultList", resultList);
            viewNm = "forum2/ezgPop/ezg_join_user_list";
        }

        request.setAttribute("dscsVO", dscsVO);

        return viewNm;
    }

    // 전체 점수 입력 화면 로드
    @RequestMapping(value = "/ezgTotalScoreView.do")
    public String getTotalScoreView(DscsEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        request.setAttribute("vo", vo);
        return "forum2/ezgPop/ezg_total_score";
    }

    // 전체 점수 입력 화면 로드
    @RequestMapping(value = "/ezgScoreView.do")
    public String getScoreView(DscsEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        if(vo.getStdId() != null) { 
            DscsJoinUserVO forumJoinUserVO = new DscsJoinUserVO();
            forumJoinUserVO.setDscsId(vo.getDscsId());
            forumJoinUserVO.setStdId(vo.getStdId());
        
            forumJoinUserVO = dscsJoinUserService.selectDscsJoinUser(forumJoinUserVO);
            request.setAttribute("dscsJoinUserVO",forumJoinUserVO);
        }

        request.setAttribute("vo", vo);
        return "forum2/ezgPop/ezg_score";
    }

    // 평가항목별 점수 부여 화면 호출 (루브릭 평가 폐기 → 단순 점수 입력으로 대체)
    @RequestMapping(value = "/ezgEvalScoreView.do")
    public String getEvalScoreView(DscsEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        if (vo.getStdId() != null) {
            DscsJoinUserVO forumJoinUserVO = new DscsJoinUserVO();
            forumJoinUserVO.setDscsId(vo.getDscsId());
            forumJoinUserVO.setStdId(vo.getStdId());
            forumJoinUserVO = dscsJoinUserService.selectDscsJoinUser(forumJoinUserVO);
            request.setAttribute("dscsJoinUserVO", forumJoinUserVO);
        }

        request.setAttribute("vo", vo);
        return "forum2/ezgPop/ezg_score";
    }

    // 사용자 상세보기
    @RequestMapping(value = "/viewStdSumm.do")
    public String viewUser(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
//        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        StdVO stdVO = stdService.select(vo);
        
        UsrUserInfoVO uuiVO = new UsrUserInfoVO();
        uuiVO.setUserId(stdVO.getUserId());
        uuiVO.setOrgId(orgId);
        uuiVO.setCrsCreCd(vo.getSbjctId());
        UsrUserInfoVO resultVO = usrUserInfoService.viewUser(uuiVO);
        resultVO.setHy(stdVO.getHy());
        request.setAttribute("userVO", resultVO);
        
        String userId = resultVO.getUserId();

        char lastChar = userId.charAt(userId.length() - 1);
        
        //int ranNum = (int)((Math.random()*10000)%10);
        //o.setSearchKey(Integer.toString(ranNum));
        vo.setSearchKey(String.valueOf(lastChar));
        
        request.setAttribute("vo", vo);

        return "forum2/ezgPop/std_summ_view";
    }

    // 점수 저장 처리
    @RequestMapping(value = "/saveScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> saveScore(DscsEzGraderRsltVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        Locale locale = LocaleUtil.getLocale(request);

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            returnVo = dscsEzGraderService.saveScore(vo, request);
        } catch (Exception e) {
            e.printStackTrace();
            returnVo.setResult(-1);
            returnVo.setMessage(messageSource.getMessage("forum_ezg.error.save_score", null, locale)); // 평가 점수 저장중 에러가 발생하였습니다.
        }

        return returnVo;
    }

    // 점수 삭제 처리
    @RequestMapping(value = "/deleteScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> deleteScore(DscsEzGraderRsltVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        Locale locale = LocaleUtil.getLocale(request);

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            returnVo = dscsEzGraderService.deleteScore(vo, request);
        } catch(Exception e) {
            e.printStackTrace();
            returnVo.setResult(-1);
            returnVo.setMessage(messageSource.getMessage("forum_ezg.error.init_score", null, locale)); // 평가 점수 초기화 중  에러가 발생하였습니다.
        }

        return returnVo;
    }

    // 토론 성적평가 > 피드백
    @RequestMapping(value = "/forumScoreEvalFeedBack.do")
    public String forumScoreEvalFeedBack(DscsVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        /*참여자 정보*/
        if(!"EZG".equals(forumVO.getSearchMenu())) {
            DscsJoinUserVO forumJoinUserVO = new DscsJoinUserVO();
            forumJoinUserVO.setDscsId(forumVO.getDscsId());
            forumJoinUserVO.setStdId(forumVO.getStdId());
        
            forumJoinUserVO = dscsJoinUserService.selectDscsJoinUser(forumJoinUserVO);
            request.setAttribute("dscsJoinUserVO",forumJoinUserVO);
        }

        DscsFdbkVO forumFdbkVO = new DscsFdbkVO();
        forumFdbkVO.setDscsId(forumVO.getDscsId());
        forumFdbkVO.setStdId(forumVO.getStdId());
        
        if(forumVO.getTeamId() != null || forumVO.getTeamId() != "") {
            forumFdbkVO.setTeamId(forumVO.getTeamId());
        }
        
        // 피드백 갯수
        int cntFdbk = dscsFdbkService.cntFdbk(forumFdbkVO);
        
        // 메모
        DscsJoinUserVO mVO = dscsJoinUserService.getMemo(forumVO);
        
        request.setAttribute("cntFdbk", cntFdbk);
        request.setAttribute("dscsVO", forumVO);
        request.setAttribute("mVO", mVO);
        
        return "forum2/ezgPop/ezg_score_eval_feedback";
    }

    // 평가 점수 저장
    @RequestMapping(value = "saveEvalScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> saveEvalScore(DscsEzGraderRsltVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String sbjctId = vo.getSbjctId();

        Locale locale = LocaleUtil.getLocale(request);

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        vo.setSbjctId(sbjctId);
        
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        try
        {
            returnVo = dscsEzGraderService.saveEvalScore(vo, request);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            returnVo.setResultFailed();
            returnVo.setMessage(messageSource.getMessage("forum_ezg.error.save_score", null, locale)); // 평가 점수 저장중 에러가 발생하였습니다.
        }

        return returnVo;
    }

    // 평가 점수 초기화

    /**
     * 저장용세션공통값주입
     * @param vo
     * @param request
     */
    private void setCommonSessionValue(DscsVO vo, HttpServletRequest request) {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setLangCd(SessionInfo.getLocaleKey(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
    }
}
