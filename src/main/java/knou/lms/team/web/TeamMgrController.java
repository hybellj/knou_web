package knou.lms.team.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.util.IdGenerator;
import knou.framework.util.JsonUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.URLBuilder;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;

@Controller
@RequestMapping(value="/team/teamMgr")
public class TeamMgrController {

    @Resource(name = "teamService")
    private TeamService teamService;
    
    @Resource(name = "teamCtgrService")
    private TeamCtgrService teamCtgrService;
    
    @Resource(name = "teamMemberService")
    private TeamMemberService teamMemberService;
    
    @Resource(name = "stdService")
    private StdService stdService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    @Resource(name="crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name = "messageSource")
    private MessageSource messageSource;
    
    // 팀관리 팀리스트
    @RequestMapping(value="/teamList.do")
    public String teamList(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        String prevCourseYn = SessionInfo.getPrevCourseYn(request);
        
        model.addAttribute("prevCourseYn", prevCourseYn);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "team/mgr/team_list";
    }

    // 팀 만들기 팝업
    @RequestMapping(value = "/teamWritePop.do")
    public String teamWritePop(TeamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String crsCreCd = request.getParameter("crsCreCd");
        String teamCtgrCd = request.getParameter("teamCtgrCd");
        TeamCtgrVO tcVO = new TeamCtgrVO();

        tcVO.setCrsCreCd(crsCreCd);
        tcVO.setTeamCtgrCd(teamCtgrCd);

        try {
            tcVO = teamCtgrService.select(tcVO);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if(ValidationUtils.isNotEmpty(tcVO)) {
            String stdNoStr = teamService.selectTeamCtgrStd(vo).getStdNo();
            System.err.println("==========> stdNoStr : "+ stdNoStr);
            request.setAttribute("stdNoStr", stdNoStr);
        }
        request.setAttribute("tcVO", tcVO);
        List<TeamVO> teamStdList = teamService.listStd(vo);
        request.setAttribute("teamStdList", teamStdList);

        return "team/mgr/teamWritePop";
    }

    // 팀구성 등록 폼
    @RequestMapping(value = "/teamWrite.do")
    public String teamWrite(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        String crsCreCd = vo.getCrsCreCd();
        String teamCtgrCd = IdGenerator.getNewId("TEAMC");
        
        StdVO sVo = new StdVO();
        sVo.setCrsCreCd(crsCreCd);
        
        int totalStdCount = stdService.count(sVo);
 
        vo.setCrsCreCd(crsCreCd);
        vo.setTeamCtgrCd(teamCtgrCd);
        vo.setTotalCnt(totalStdCount);

        request.setAttribute("vo", vo);
        request.setAttribute("mode", "A");
        
        return "team/mgr/team_write";
    }

    // 팀구성 수정 폼
    @RequestMapping(value="/editTeamForm.do")
    public String editTeamForm(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        
        String crsCreCd = vo.getCrsCreCd();
        String teamCtgrCd = request.getParameter("teamCtgrCd");
        
        StdVO sVo = new StdVO();
        sVo.setCrsCreCd(crsCreCd);

        int totalStdCount = stdService.count(sVo);
        
        vo.setCrsCreCd(crsCreCd);
        vo.setTeamCtgrCd(teamCtgrCd);
        
        vo = teamCtgrService.selectTeamForm(vo);
        vo.setTotalCnt(totalStdCount);
        
        // 팀 구성된 총 인원
        int totalTeamMember = teamCtgrService.totalTeamMember(vo);
        
        request.setAttribute("totalTeamMember", totalTeamMember);
        request.setAttribute("vo", vo);
        request.setAttribute("mode", "U");
        
        return "team/mgr/team_write";
    }
    
    // 토론 등록
    @RequestMapping(value = "/teamAdd.do")
    @ResponseBody
    public String teamAdd(TeamCtgrVO teamCtgrVO, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
//        String crsCreCd = StringUtil.nvl(teamCtgrVO.getCrsCreCd());
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String returnUrl = new URLBuilder("team","/teamMgr/teamList.do", request).toString();
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /*강의실에서 토론 진입시 교수자이름*/ 
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));
        teamCtgrVO.setRgtrId(userId);
        
        ProcessResultVO<TeamCtgrVO> result = new ProcessResultVO<TeamCtgrVO>();
        
        TeamCtgrVO vo = null;
        try {
            vo = new TeamCtgrVO();
            
            teamCtgrVO.setTeamCtgrCd(teamCtgrVO.getTeamCtgrCd());
            teamCtgrVO.setOrgId(orgId);

            teamCtgrService.insertTeamCtgr(teamCtgrVO);
            
            vo.setTeamCtgrCd(teamCtgrVO.getTeamCtgrCd());
            
            result.setReturnVO(vo);
            result.setResult(1);
        } catch (Exception e) {
            result.setResult(-1);
        }
        return JsonUtil.responseJson(response, result);
    }

    // 팀 수정
    @RequestMapping(value = "/teamEdit.do")
    @ResponseBody
    public String teamEdit(TeamCtgrVO teamCtgrVO, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
//        String crsCreCd = StringUtil.nvl(teamCtgrVO.getCrsCreCd());
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /*강의실에서 토론 진입시 교수자이름*/
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));
        teamCtgrVO.setMdfrId(userId);
        
        ProcessResultVO<TeamCtgrVO> result = new ProcessResultVO<TeamCtgrVO>();
        
        TeamCtgrVO vo = null;
        try {
            vo = new TeamCtgrVO();
            teamCtgrVO.setOrgId(orgId);

            teamCtgrService.updateTeamCtgr(teamCtgrVO);
            TeamVO tvo = new TeamVO();
            tvo.setTeamCtgrCd(teamCtgrVO.getTeamCtgrCd());
            teamService.updateUseTeamMember(tvo);
            
            vo.setTeamCtgrCd(teamCtgrVO.getTeamCtgrCd());
            
            result.setReturnVO(vo);
            result.setResult(1);
        } catch (Exception e) {
            result.setResult(-1);
        }
        return JsonUtil.responseJson(response, result);
    }

    // 팀 자동 생성
    @RequestMapping(value="/addAutoTeam.do")
    public String addAutoTeam(TeamVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        vo.setRgtrId(StringUtil.nvl(SessionInfo.getUserId(request)));
        String crsCreCd = request.getParameter("crsCreCd");
        String teamCtgrCd = request.getParameter("teamCtgrCd");
        String teamCtgrNm = request.getParameter("teamCtgrNm");
        String teamBbsYn = request.getParameter("teamBbsYn");
        String stdNo = request.getParameter("stdNo");
        String stdRole = request.getParameter("stdRole");
        String userId = request.getParameter("userId");
        int resultChk = Integer.parseInt(request.getParameter("resultChk"));
        
        //
        int lastIndex = Integer.parseInt(request.getParameter("lastIndex"));
        if(lastIndex == 0) {
            TeamCtgrVO tcVO = new TeamCtgrVO();
            tcVO.setCrsCreCd(crsCreCd);
            tcVO.setTeamCtgrCd(vo.getTeamCtgrCd());
            
            // 팀 자동 생성시 기존의 데이터 삭제 후 다시 등록하게 처리
            // 팀원 삭제 후 팀 삭제
            int totalTeam = teamCtgrService.selectTeam(tcVO);

            if(totalTeam > 0) {
                teamCtgrService.delTeamMember(tcVO);
                teamCtgrService.delTeam(tcVO);
            }
        }

        vo.setSubParam(crsCreCd);
        vo.setTeamCtgrCd(teamCtgrCd);
        vo.setStdNo(stdNo);
        vo.setStdRole(stdRole);
        vo.setUserId(userId);

        // 팀 분류 코드가 없으면 팀 분류 테이블(tb_lms_team_ctgr)에 등록
        int chkTeamCnt = teamService.selectTeamCtgrCd(vo);

        if(chkTeamCnt == 0 && resultChk == 0) {
            TeamCtgrVO teamCtgrVO = new TeamCtgrVO();
            
            teamCtgrVO.setTeamCtgrCd(vo.getTeamCtgrCd());
            teamCtgrVO.setCrsCreCd(vo.getCrsCreCd());
            teamCtgrVO.setOrgId(vo.getOrgId());
            teamCtgrVO.setTeamCtgrNm(teamCtgrNm);
            teamCtgrVO.setTeamBbsYn(teamBbsYn);
            teamCtgrVO.setRgtrId(vo.getRgtrId());

            // 팀 분류 테이블에 등록
            teamCtgrService.insertTeamCtgr(teamCtgrVO);
        }
        
        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();
        try {
            teamService.addAutoTeam(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        
        return JsonUtil.responseJson(response, resultVO);
    }

    // 팀 리스트
    @RequestMapping(value="/listTeam.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> listTeam(TeamVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();

        try {
            List<TeamVO> list = teamService.listTeam(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    // 팀 삭제
    @RequestMapping(value="/removeTeam.do")
    @ResponseBody
    public String removeTeam(TeamVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        
        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();
        try {
            teamService.removeTeam(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }

        return JsonUtil.responseJson(response, resultVO);
    }

    // 팀 수정 및 추가
    @RequestMapping(value="/editTeam.do")
    public String editTeam(TeamVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamCtgrNm = request.getParameter("teamCtgrNm");
        String teamBbsYn = request.getParameter("teamBbsYn");
        String teamCtgrCd = request.getParameter("teamCtgrCd");

        vo.setTeamCtgrCd(teamCtgrCd);
        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        // 팀 분류 코드가 없으면 팀 분류 테이블(tb_lms_team_ctgr)에 등록
        int chkTeamCnt = teamService.selectTeamCtgrCd(vo);
        
        if(chkTeamCnt == 0) {
            TeamCtgrVO teamCtgrVO = new TeamCtgrVO();
            
            teamCtgrVO.setTeamCtgrCd(vo.getTeamCtgrCd());
            teamCtgrVO.setCrsCreCd(vo.getCrsCreCd());
            teamCtgrVO.setOrgId(vo.getOrgId());
            teamCtgrVO.setTeamCtgrNm(teamCtgrNm);
            teamCtgrVO.setTeamBbsYn(teamBbsYn);
            teamCtgrVO.setRgtrId(vo.getRgtrId());
            
            // 팀 분류 테이블에 등록
            teamCtgrService.insertTeamCtgr(teamCtgrVO);
        }
        
        TeamCtgrVO tcVO = new TeamCtgrVO();
        tcVO.setTeamCtgrCd(vo.getTeamCtgrCd());
        tcVO.setCrsCreCd(vo.getCrsCreCd());
        tcVO.setOrgId(orgId);
        tcVO.setTeamCtgrNm(teamCtgrNm);
        tcVO.setTeamBbsYn(teamBbsYn);
        tcVO.setRgtrId(userId);
        
        // 팀 분류
        tcVO = teamCtgrService.select(tcVO);
        request.setAttribute("tcVO", tcVO);
        
        String mode = request.getParameter("mode");
        
        String teamCnt = request.getParameter("teamCnt");
        request.setAttribute("teamCnt", teamCnt);

        if(!("add".equals(mode))) {
            // 현재 팀원
            List<TeamMemberVO> teamStdList = teamService.teamStdList(vo);
            request.setAttribute("teamStdList", teamStdList);
            request.setAttribute("teamCd", vo.getTeamCd());
            request.setAttribute("teamVo", teamService.select(vo));
        }

        vo.setTeamCd("");
        // 팀 구성이 안된 수강생
        //teamService.setGroupConcatMaxLen(); // 오라클에선 동작하지 않아서 일단 주석처리
        String stdNoStr = teamService.selectTeamCtgrStd(vo).getStdNo();
        request.setAttribute("stdNoStr", stdNoStr);
        request.setAttribute("crsCreCd", vo.getTeamCtgrCd());

        String crsCreCd = vo.getCrsCreCd();
        
        StdVO sVo = new StdVO();
        sVo.setCrsCreCd(crsCreCd);

        int totalStdCount = stdService.count(sVo);
        request.setAttribute("totalCnt", totalStdCount);
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);
        
        return "team/mgr/teamWritePop";
    }

    // 팀 구성 목록 가져오기 ajax
    @RequestMapping(value="/teamListDiv.do")
    @ResponseBody
    public ProcessResultVO<TeamCtgrVO> teamListDiv(TeamCtgrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        String crsCreCd = vo.getCrsCreCd();
        vo.setCrsCreCd(crsCreCd);

        ProcessResultVO<TeamCtgrVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = teamCtgrService.teamListDiv(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        request.setAttribute("teamVO", resultVO);
        
        return resultVO;
    }

    // 팀 구성 삭제
    @RequestMapping(value="/deleteTeamAll.do")
    @ResponseBody
    public ProcessResultVO<TeamCtgrVO> deleteTeamAll(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<TeamCtgrVO> resultVO = new ProcessResultVO<>();
        
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setMdfrNm(userId);

            teamCtgrService.delTeamAll(vo);
            
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        
        return resultVO;
    }

    // 팀 정보 상세
    @RequestMapping(value="/team_view.do")
    public String teamView(TeamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        String prevCourseYn = SessionInfo.getPrevCourseYn(request);
        
        model.addAttribute("prevCourseYn", prevCourseYn);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        //model.addAttribute("crsCreCd", vo.getCrsCreCd());

        String crsCreCd = request.getParameter("crsCreCd");

        List<TeamVO> list = teamService.teamTeamMemberList(vo);

        TeamCtgrVO tVo = new TeamCtgrVO();
        tVo.setCrsCreCd(crsCreCd);
        tVo.setTeamCtgrCd(vo.getTeamCtgrCd());
        vo = teamCtgrService.select(tVo);
        
        model.addAttribute("vo", vo);
        model.addAttribute("list", list);
        
        return "team/mgr/team_view";
    }
    
    
    // 팀 추가
    @RequestMapping(value = "/addTeam.do")
    @ResponseBody
    public String addTeam(TeamVO vo, @RequestParam HashMap<String, Object> commandMap, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        String crsCreCd = request.getParameter("crsCreCd");
        String teamCtgrCd = request.getParameter("teamCtgrCd");
        String stdNo = request.getParameter("stdNo");
        String stdRole = request.getParameter("stdRole");
        
        vo.setSubParam(crsCreCd);
        vo.setTeamCtgrCd(teamCtgrCd);
        vo.setStdNo(stdNo);
        vo.setStdRole(stdRole);
 
        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();
        try {
            teamService.addTeam(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        
        return JsonUtil.responseJson(response, resultVO);
    }

    // 팀구성 완료 여부 세팅
    @RequestMapping(value="/teamSetYn.do")
    @ResponseBody
    public String teamSetYn(TeamVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 팀 구성된 팀원수
		ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();
		try {
			TeamCtgrVO tcVO = new TeamCtgrVO();
			tcVO.setCrsCreCd(vo.getCrsCreCd());
			tcVO.setTeamCtgrCd(vo.getTeamCtgrCd());
			
			StdVO sVo = new StdVO();
	        sVo.setCrsCreCd(vo.getCrsCreCd());
	        
	        int teamCnt = teamMemberService.count(vo);
	        int totalStdCount = stdService.count(sVo);
			
			// 학습자와 팀 구성된 인원이 같으면 팀구성 완료 여부 Y
			if(teamCnt == totalStdCount) {
				tcVO.setTeamSetYn("Y");
			} else {
				tcVO.setTeamSetYn("N");
			}
			// 팀구성 완료 여부 세팅
			teamCtgrService.setTeamSetYn(tcVO);
			resultVO.setResult(1);
		} catch (Exception e) {
			resultVO.setResult(-1);
		}
    	return JsonUtil.responseJson(response, resultVO);
    }

}
