package knou.lms.forum2.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.service.ForumEzGraderService;
import knou.lms.forum2.service.ForumFdbkService;
import knou.lms.forum2.service.ForumJoinUserService;
import knou.lms.forum2.service.ForumService;
import knou.lms.forum.vo.*;
import knou.lms.forum2.vo.Forum2VO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.BeanUtils;
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
public class Forum2EzGraderLectController extends ControllerBase {

    // 상호평가
    @Resource(name="forum2EzGraderService")
    private ForumEzGraderService forumEzGraderService;
    
    // 토론 정보
    @Resource(name="forum2Service")
    private ForumService forum2Service;
    
    // 토론 참여자
    @Resource(name = "forum2JoinUserService")
    private ForumJoinUserService forumJoinUserService;
    
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
    
    @Resource(name = "forum2FdbkService")
    private ForumFdbkService forumFdbkService;
    
    // EZ-Grader 메인
    @RequestMapping(value = "/ezgMainForm.do")
    public String getEzgMainView(ForumEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();
        
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        vo.setForumCd(vo.getForumCd());
        vo.setStdId(vo.getStdId());
        vo.setCrsCreCd(crsCreCd);
        vo.setEvalCtgr(vo.getEvalCtgr());
        
        // 모든 토론 참여자를 토론 참여자 테이블에 삽입
        ForumVO forumVO = new ForumVO();
        forumVO.setRgtrId(userId);
        forumVO.setCrsCreCd(crsCreCd);
        forumVO.setForumCd(vo.getForumCd());
        forumJoinUserService.insertJoinUser(forumVO);

        request.setAttribute("vo", vo);
        
        return "forum2/ezgPop/ezg_main_form";
    }

    // 토론정보 조회
    @RequestMapping(value = "/forum.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> getForumInfoByAjax(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<ForumVO>();
        try {
            // TODO : 26.3.20 : to-be vo 변경에 따른 처리.
           /* ForumVO forumVO = forumService.selectForum(vo);*/
            Forum2VO param = new Forum2VO();
            param.setDscsId(vo.getForumCd());
            Forum2VO tempForum2VO = forum2Service.selectForum(param);
            ForumVO forumVO = convertForum2VOtoForumVO(tempForum2VO) ;

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
    public String getEzgJoinUserSearchView(ForumEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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
    public String getForumJoinUserListForEzg(ForumVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        vo.setOrgId(orgId);
        // TODO : 26.3.20 : to-be vo 변경에 따른 처리.
        /* ForumVO forumVO = forumService.selectForum(vo);*/
        Forum2VO param = new Forum2VO();
        param.setDscsId(vo.getForumCd());
        Forum2VO tempForum2VO = forum2Service.selectForum(param);
        ForumVO forumVO = convertForum2VOtoForumVO(tempForum2VO) ;

        ForumJoinUserVO paramVO = new ForumJoinUserVO();
        paramVO.setForumCd(vo.getForumCd());
        paramVO.setCrsCreCd(vo.getCrsCreCd());
        paramVO.setSearchKey(vo.getSearchKey());
        paramVO.setSearchSort(vo.getSearchSort());
        paramVO.setForumCtgrCd(forumVO.getForumCtgrCd());

        String viewNm = "";
        if ("TEAM".equals(forumVO.getForumCtgrCd())) {
            List<ForumEzGraderTeamVO> resultList= forumEzGraderService.listForumJoinTeam(paramVO);
            request.setAttribute("resultList", resultList);
            viewNm = "forum/ezgPop/ezg_join_team_list";
        } else {
            List<ForumJoinUserVO> resultList= forumEzGraderService.listForumJoinUser(paramVO);
            request.setAttribute("resultList", resultList);
            viewNm = "forum/ezgPop/ezg_join_user_list";
        }

        request.setAttribute("forumVO", forumVO);
        request.setAttribute("vo", vo);

        return viewNm;
    }

    // 전체 점수 입력 화면 로드
    @RequestMapping(value = "/ezgTotalScoreView.do")
    public String getTotalScoreView(ForumEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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
    public String getScoreView(ForumEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        if(vo.getStdId() != null) { 
            ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
            forumJoinUserVO.setForumCd(vo.getForumCd());
            forumJoinUserVO.setStdId(vo.getStdId());
        
            forumJoinUserVO = forumJoinUserService.selectForumJoinUser(forumJoinUserVO);
            request.setAttribute("forumJoinUserVo",forumJoinUserVO);
        }

        request.setAttribute("vo", vo);
        return "forum2/ezgPop/ezg_score";
    }

    // 평가항목별 점수 부여 화면 호출
    @RequestMapping(value = "/ezgEvalScoreView.do")
    public String getEvalScoreView(ForumEzGraderVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        EgovMap evalMap = forumEzGraderService.selectEzgEvalInfo(vo);

        ForumEzGraderRsltVO paramRsltVo = new ForumEzGraderRsltVO();
        paramRsltVo.setForumCd(vo.getForumCd());
        paramRsltVo.setEvalCd(evalMap.get("evalCd").toString());
        paramRsltVo.setEvalUserId(userId);
        paramRsltVo.setEvalTrgtUserId(vo.getStdId());
        ForumEzGraderRsltVO evalRsltVo = forumEzGraderService.selectEzgEvalRslt(paramRsltVo);
        List<ForumEzGraderQstnVO> evalQstnList= forumEzGraderService.listEzgEvalQstn(vo);

        request.setAttribute("evalInfo", evalMap);
        request.setAttribute("evalRsltVo", evalRsltVo);
        request.setAttribute("evalQstnList", evalQstnList);
        request.setAttribute("vo", vo);
        return "forum2/ezgPop/ezg_eval_score";
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
        uuiVO.setCrsCreCd(vo.getCrsCreCd());
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
    public ProcessResultVO<DefaultVO> saveScore(ForumEzGraderRsltVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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
            returnVo = forumEzGraderService.saveScore(vo, request);
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
    public ProcessResultVO<DefaultVO> deleteScore(ForumEzGraderRsltVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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
            returnVo = forumEzGraderService.deleteScore(vo, request);
        } catch(Exception e) {
            e.printStackTrace();
            returnVo.setResult(-1);
            returnVo.setMessage(messageSource.getMessage("forum_ezg.error.init_score", null, locale)); // 평가 점수 초기화 중  에러가 발생하였습니다.
        }

        return returnVo;
    }

    // 토론 성적평가 > 피드백
    @RequestMapping(value = "/forumScoreEvalFeedBack.do")
    public String forumScoreEvalFeedBack(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        /*참여자 정보*/
        if(!"EZG".equals(forumVO.getSearchMenu())) {
            ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
            forumJoinUserVO.setForumCd(forumVO.getForumCd());
            forumJoinUserVO.setStdId(forumVO.getStdId());
        
            forumJoinUserVO = forumJoinUserService.selectForumJoinUser(forumJoinUserVO);
            request.setAttribute("forumJoinUserVo",forumJoinUserVO);
        }

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumCd(forumVO.getForumCd());
        forumFdbkVO.setStdId(forumVO.getStdId());
        
        if(forumVO.getTeamCd() != null || forumVO.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(forumVO.getTeamCd());
        }
        
        // 피드백 갯수
        int cntFdbk = forumFdbkService.cntFdbk(forumFdbkVO);
        
        // 메모
        ForumJoinUserVO mVO = forumJoinUserService.getMemo(forumVO);
        
        request.setAttribute("cntFdbk", cntFdbk);
        request.setAttribute("forumVo", forumVO);
        request.setAttribute("mVO", mVO);
        
        return "forum2/ezgPop/ezg_score_eval_feedback";
    }

    // 평가 점수 저장
    @RequestMapping(value = "saveEvalScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> saveEvalScore(ForumEzGraderRsltVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();

        Locale locale = LocaleUtil.getLocale(request);

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        vo.setCrsCreCd(crsCreCd);
        
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        try
        {
            returnVo = forumEzGraderService.saveEvalScore(vo, request);
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
    private void setCommonSessionValue(Forum2VO vo, HttpServletRequest request) {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setLangCd(SessionInfo.getLocaleKey(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
    }

    // TODO : 26.3.24 : 임시 변환용(추후 삭제 예정)
    private ForumVO convertForum2VOtoForumVO(Forum2VO src) throws Exception {
        ForumVO dest = new ForumVO();

        if (src == null) {
            return dest;
        }

        BeanUtils.copyProperties(src, dest);

        dest.setForumCd(src.getDscsId());                // 토론ID -> forumCd
        dest.setCrsCreCd(src.getSbjctId());              // 예: 과목ID
        dest.setForumTitle(src.getDscsTtl());            // 예: 토론명
        dest.setForumArtl(src.getDscsCts());                // 토론내용
        dest.setForumCtgrCd(src.getDscsUnitTycd());      // 예: 토론유형
        dest.setForumStartDttm(src.getDscsSdttm());      // 토론 시작일시
        dest.setForumEndDttm(src.getDscsEdttm());        // 토론 종료일시
        dest.setScoreAplyYn(src.getMrkRfltyn());         // 성적반영여부
        dest.setScoreRatio(src.getMrkRfltrt());          // 성적반영비율
        dest.setScoreOpenYn(src.getMrkOyn());           // 성적공개여부
        dest.setDelYn(src.getDelyn());                  // 삭제여부
        dest.setDeclsNo(src.getDvclsNo());              // 분반번호
        dest.setForumCtgrCd(src.getDscsUnitTycd());     // TEAM or GNRL
        dest.setProsConsForumCfg(src.getOknokStngyn()); // 찬반토론 설정 여부.(찬반)
        dest.setProsConsRateOpenYn(src.getOknokrtOyn());// 찬반 비율 공개(찬반)
        dest.setRegOpenYn(src.getOknokRgtrOyn());       // 작성자 공개(찬반)
        dest.setMultiAtclYn(src.getMltOpnnRegyn());     // 의견글 복수 등록(찬반)
        dest.setProsConsModYn(src.getOknokModyn());     // 의견 변경(찬반)
        dest.setByteamDscsUseyn(src.getByteamDscsUseyn()); // 팀별부토론사용여부
        dest.setDscsGrpnm(src.getDscsGrpnm());          // 학습그룹이름.
        dest.setEvalCtgr(src.getEvlScrTycd());          // 평가점수유형코드

        // DB 외 변수들
        dest.setForumAtclCnt(src.getForumAtclCnt());
        dest.setForumCmntCnt(src.getForumCmntCnt());
        dest.setForumMyAtclCnt(src.getForumMyAtclCnt());
        dest.setForumMyCmntCnt(src.getForumMyCmntCnt());
        dest.setForumAtclPorsCnt(src.getForumAtclPorsCnt());
        dest.setForumAtclConsCnt(src.getForumAtclConsCnt());
        dest.setForumUserTotalCnt(src.getForumUserTotalCnt());
        dest.setForumJoinUserCnt(src.getForumJoinUserCnt());
        dest.setForumMyScore(src.getForumMyScore());
        dest.setForumMyFdbk(src.getForumMyFdbk());
        dest.setForumEvalCnt(src.getForumEvalCnt());
        dest.setTeamDscsList(src.getTeamDscsList());

        // 필요 시 추가 매핑
        return dest;
    }

}
