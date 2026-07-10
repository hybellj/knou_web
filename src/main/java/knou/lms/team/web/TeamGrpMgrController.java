package knou.lms.team.web;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.common.ControllerBase;
import knou.framework.util.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.web.ExamHomeController;
import knou.lms.team.service.TeamGrpMgrService;
import knou.lms.team.vo.TeamGrpMgrVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value="/team")
public class TeamGrpMgrController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExamHomeController.class);

    @Resource(name = "teamGrpMgrService")
    private TeamGrpMgrService teamGrpMgrService;

    /*****************************************************
     * 팀 그룹지정 페이지
     * @param vo
     * @param model
     * @param request
     * @return view
     ******************************************************/
    @RequestMapping(value="/teamGrpMngListView.do")
    public String teamGrpMngListView(TeamGrpMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        resetEncParam();
        addEncParam("sbjctId", sbjctId);

        model.addAttribute("vo", vo);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("encParams", getEncParams());
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "team/grpMgr/team_grp_list_view";
    }

    /*****************************************************
     * 팀 그룹 상세 페이지
     * @param vo
     * @param model
     * @param request
     * @return view
     ******************************************************/
    @RequestMapping(value="/teamGrpMngDtlView.do")
    public String teamGrpMngDtlView(TeamGrpMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String sbjctId = StringUtil.nvl(vo.getSbjctId());
        String usingyn = vo.getUsingyn();
        Integer userTot = teamGrpMgrService.countAtndlcUser(vo);
        List<EgovMap> atndlcUserList = teamGrpMgrService.listAtndlcUser(vo);
        List<EgovMap> teamGrpVO = teamGrpMgrService.listTeamAndMbr(vo);

        if (!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        addEncParam("teamGrpId", StringUtil.nvl(vo.getTeamGrpId()));
        addEncParam("usingyn",   StringUtil.nvl(usingyn));
        if (!sbjctId.isEmpty()) addEncParam("sbjctId", sbjctId);

        model.addAttribute("vo", vo);
        model.addAttribute("teamGrpVO", teamGrpVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("usingyn", usingyn);
        model.addAttribute("userTot", userTot);
        model.addAttribute("atndlcUserList", atndlcUserList);
        model.addAttribute("encParams", getEncParams());

        return "team/grpMgr/team_grp_dtl";
    }

    /*****************************************************
     * 팀 그룹 [등록|수정] 페이지
     * @param vo
     * @param model
     * @param request
     * @return view
     ******************************************************/
    @RequestMapping(value="/teamGrpMngWriteView.do")
    public String teamGrpMngWriteView(TeamGrpMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String sbjctId = StringUtil.nvl(vo.getSbjctId());
        String usingyn = vo.getUsingyn();
        String isModify;
        Integer userTot = teamGrpMgrService.countAtndlcUser(vo);
        List<EgovMap> atndlcUserList = teamGrpMgrService.listAtndlcUser(vo);
        List<EgovMap> teamGrpVO = null;

        if (!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        if (vo.getTeamGrpId() == null || vo.getTeamGrpId().isEmpty()) {
            isModify = "N"; // 등록
        } else {
            isModify = "Y"; // 수정
            teamGrpVO = teamGrpMgrService.listTeamAndMbr(vo);
        }

        addEncParam("teamGrpId", StringUtil.nvl(vo.getTeamGrpId()));
        addEncParam("usingyn",   StringUtil.nvl(usingyn));
        if (!sbjctId.isEmpty()) addEncParam("sbjctId", sbjctId);

        model.addAttribute("vo", vo);
        model.addAttribute("teamGrpVO", teamGrpVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("isModify", isModify);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("usingyn", usingyn);
        model.addAttribute("userTot", userTot);
        model.addAttribute("atndlcUserList", atndlcUserList);
        model.addAttribute("encParams", getEncParams());

        return "team/grpMgr/team_grp_write";
    }

    /*****************************************************
     * 팀 구성 팝업
     * @param TeamGrpMgrVO
     * @param model
     * @param request
     * @return resultVO
     ******************************************************/
    @RequestMapping(value = "/teamGrpSetTeamPopup.do")
    public String teamGrpSettingTeamPopup(TeamGrpMgrVO vo, ModelMap model, HttpServletRequest request) {
        return "team/grpMgr/popup/team_grp_set_team_pop";
    }

    /*****************************************************
     * 팀 그룹 등록
     * @param TeamGrpMgrVO
     * @param model
     * @param request
     * @return resultVO
     ******************************************************/
    @RequestMapping(value = "/teamGrpRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<TeamGrpMgrVO> teamGrpRegist(TeamGrpMgrVO vo, ModelMap model, HttpServletRequest request) {
        ProcessResultVO<TeamGrpMgrVO> resultVO = new ProcessResultVO<TeamGrpMgrVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        if(ValidationUtils.isEmpty(userId)) {
            throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
        }
        resultVO.setReturnVO(teamGrpMgrService.teamGrpRegist(vo));
        resultVO.setResultSuccess();
        return resultVO;
    }

    /*****************************************************
     * 팀 그룹 목록 페이징
     * @param TeamGrpMgrVO
     * @param model
     * @param request
     * @return resultVO
     ******************************************************/
    @RequestMapping(value="/teamGrpPaging.do")
    @ResponseBody
    public ProcessResultVO<TeamGrpMgrVO> listTeamGrpPaging(TeamGrpMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<TeamGrpMgrVO> resultVO = new ProcessResultVO<>();
        String orgId     = SessionInfo.getOrgId(request);
        String sbjctId   = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();
        String teamGrpnm = StringUtil.nvl(request.getParameter("teamGrpnm"));

        vo.setOrgId(orgId);
        vo.setSbjctId(sbjctId);
        vo.setTeamGrpnm(teamGrpnm);

        addEncParam("teamGrpnm", teamGrpnm);

        resultVO = teamGrpMgrService.listTeamGrpPaging(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /*****************************************************
     * 팀 그룹 수정
     * @param TeamGrpMgrVO
     * @param model
     * @param request
     * @return resultVO
     ******************************************************/
    @RequestMapping(value="/teamGrpModify.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<TeamGrpMgrVO> updateTeamGrpInfo(TeamGrpMgrVO vo, ModelMap model, HttpServletRequest request) {
        ProcessResultVO<TeamGrpMgrVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        if(ValidationUtils.isEmpty(userId)) {
            throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
        }
        teamGrpMgrService.updateTeamGrpInfo(vo);
        resultVO.setResultSuccess();
        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        return resultVO;
    }

    /*****************************************************
     * 팀 그룹 삭제
     * @param TeamGrpMgrVO
     * @param model
     * @param request
     * @return resultVO
     ******************************************************/
    @RequestMapping(value="/teamGrpDelete.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<TeamGrpMgrVO> deleteLrnGrpInfo(TeamGrpMgrVO vo, ModelMap model, HttpServletRequest request) {
        ProcessResultVO<TeamGrpMgrVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        if(ValidationUtils.isEmpty(userId)) {
            throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
        }
        teamGrpMgrService.updateTeamGrpDelyn(vo);
        resultVO.setResultSuccess();
        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        return resultVO;
    }
}
