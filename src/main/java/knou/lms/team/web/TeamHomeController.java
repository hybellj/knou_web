package knou.lms.team.web;

import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.util.JsonUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.SessionUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;

@Controller
@RequestMapping(value="/team/teamHome")
public class TeamHomeController {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(TeamHomeController.class);

    @Resource(name = "teamService")
    private TeamService teamService;
    
    @Resource(name = "teamCtgrService")
    private TeamCtgrService teamCtgrService;
    
    @Resource(name = "teamMemberService")
    private TeamMemberService teamMemberService;
    
    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    @Resource(name = "messageSource")
    private MessageSource messageSource;
    
    @RequestMapping(value = "/listTeam.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> listTeam(TeamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();
        
        try {
            List<TeamVO> list = teamService.list(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }
    
    @RequestMapping(value = "/listTeamCtgr.do")
    @ResponseBody
    public ProcessResultVO<TeamCtgrVO> listTeamCtgr(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<TeamCtgrVO> resultVO = new ProcessResultVO<>();
        String orgId = (String) SessionUtil.getSessionValue(request, "orgId");
        
        try {
            vo.setOrgId(orgId);
            List<TeamCtgrVO> list = teamCtgrService.list(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 내 소속 팀 조회
     * @param TeamMemberVO 
     * @return ProcessResultVO<TeamMemberVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listMyTeamStd.do")
    @ResponseBody
    public ProcessResultVO<TeamMemberVO> listMyTeamStd(TeamMemberVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        ProcessResultVO<TeamMemberVO> resultVO = new ProcessResultVO<>();
        
        try {
            List<TeamMemberVO> list = teamMemberService.listMyTeamStd(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    // 팀 리스트 조회(토론)
    @RequestMapping(value = "/listTeamJson.do")
    public ProcessResultVO<TeamVO> listTeamJson(TeamCtgrVO vo, 
            ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();
        try {
            vo = teamCtgrService.select(vo);
            TeamVO tVO = new TeamVO();
            tVO.setTeamCtgrCd(vo.getTeamCtgrCd());
            List<TeamCtgrVO> list1 = teamCtgrService.list(vo);
            List<TeamVO> list = teamService.list(tVO);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 팀 분류 선택 팝업
     * @param TeamCtgrVO 
     * @return "team/popup/team_ctgr_select_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/teamCtgrSelectPop.do")
    public String examListForm(TeamCtgrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        List<TeamCtgrVO> teamCtgrList = teamCtgrService.listComplateTeamByCrsCreCd(vo);
        request.setAttribute("teamCtgrList", teamCtgrList);
        request.setAttribute("vo", vo);
        
        return "team/popup/team_ctgr_select_pop";
    }
    
    /***************************************************** 
     * 팀원 목록 조회
     * @param TeamMemberVO 
     * @return ProcessResultVO<TeamMemberVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listTeamMember.do")
    @ResponseBody
    public ProcessResultVO<TeamMemberVO> listTeamMember(TeamMemberVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        ProcessResultVO<TeamMemberVO> resultVO = new ProcessResultVO<>();
        
        try {
            List<TeamMemberVO> list = teamMemberService.list(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }
    
    // 팀토론 성적 분포 현황
    @RequestMapping(value = "/viewScoreChart.do")
    public String viewScoreChart(TeamVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        EgovMap scoreMap = new EgovMap();
        try {
            scoreMap = teamService.viewScoreChart(vo);
        } catch(Exception e) {
            e.printStackTrace();
        }
        return JsonUtil.responseJson(response, scoreMap);
    }

}
