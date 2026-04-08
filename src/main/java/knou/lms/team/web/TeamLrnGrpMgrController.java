package knou.lms.team.web;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.common.ControllerBase;
import knou.framework.util.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.exam.web.ExamHomeController;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.team.service.TeamLrnGrpMgrService;
import knou.lms.team.vo.TeamLrnGrpMgrVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value="/team")
public class TeamLrnGrpMgrController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExamHomeController.class);

    @Resource(name = "teamLrnGrpMgrService")
    private TeamLrnGrpMgrService teamLrnGrpMgrService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /*****************************************************
     * 학습그룹지정 페이지
     * @param vo
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lrnGrpMngListView.do")
    public String lrnGrpMngListView(TeamLrnGrpMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        model.addAttribute("vo", vo);

        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "team/lrnGrpMgr/lrn_grp_list_view";
    }

    /*****************************************************
     * 학습 그룹 목록 페이징
     * @param TeamLrnGrpMgrVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lrnGrpPaging.do")
    @ResponseBody
    public ProcessResultVO<TeamLrnGrpMgrVO> listTeamLrnGrpPaging(TeamLrnGrpMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<TeamLrnGrpMgrVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();

        vo.setOrgId(orgId);
        vo.setSbjctId(sbjctId);
        try {
            resultVO = teamLrnGrpMgrService.listTeamLrnGrpPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

}
