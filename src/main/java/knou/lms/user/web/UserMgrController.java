package knou.lms.user.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.util.CommonUtil;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.login.service.LoginService;
import knou.lms.user.CurrentUser;
import knou.lms.user.facade.UserMgrFacadeService;
import knou.lms.user.service.UserService;
import knou.lms.user.vo.UserMsgVO;
import knou.lms.user.vo.UserMgrListVO;
import knou.lms.user.vo.UserMgrVO;
import knou.lms.user.vo.UserVO;
import knou.lms.user.web.view.UserMgrFormView;
import knou.lms.user.web.view.UserMgrListView;

@Controller
@RequestMapping(value = "/user/userMgr")
public class UserMgrController extends ControllerBase {

    @Resource(name = "userMgrFacadeService")
    private UserMgrFacadeService userMgrFacadeService;

    @Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name = "userService")
    private UserService userService;

    private static final String ADMIN_ORIGIN_CONTEXT = "ADMIN_ORIGIN_CONTEXT";

    /*****************************************************
     * 사용자 관리 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "user/mgr/adm_user_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admUserMgrList.do")
    public String userMgrList(UserMgrListVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        UserMgrListView view = userMgrFacadeService.userMgrListView(vo, userCtx);

        model.addAttribute("orgList", view.getOrgList());
        model.addAttribute("authrtGrpList", view.getAuthrtGrpList());
        model.addAttribute("userStscdList", view.getUserStscdList());
        model.addAttribute("userTyList", view.getUserTyList());
        model.addAttribute("acRcdTyList", view.getAcRcdTyList());
        model.addAttribute("allOrgYn", view.getAllOrgYn());
        model.addAttribute("loginUserNm", userCtx.getLoginUser() != null ? StringUtil.nvl(userCtx.getLoginUser().getUsernm()) : "");

        UserMgrVO meVo = new UserMgrVO();
        meVo.setUserId(userCtx.getUserId());
        ResultDTO<UserMgrVO> me = userMgrFacadeService.selectUserMgr(meVo, userCtx);
        model.addAttribute("loginUserMblPhn", me.getData() != null ? StringUtil.nvl(me.getData().getMobileNo()) : "");

        setCommonModel(model, request, vo);

        return "user/mgr/adm_user_list";
    }

    /*****************************************************
     * 사용자 목록 조회
     * @param vo
     * @param userCtx
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @RequestMapping(value = "/admListUserMgr.do")
    @ResponseBody
    public ResultDTO<EgovMap> listUserMgr(UserMgrListVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<EgovMap> resultDTO = userMgrFacadeService.listUserMgr(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 사용자 정보 단건 조회
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @RequestMapping(value = "/admSelectUserMgr.do")
    @ResponseBody
    public ResultDTO<UserMgrVO> selectUserMgr(UserMgrVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrVO> resultDTO = userMgrFacadeService.selectUserMgrInfo(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 사용자 연락처(전화번호) 변경이력 조회
     * @param vo
     * @param userCtx
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @RequestMapping(value = "/admListUserTelnoChgHstry.do")
    @ResponseBody
    public ResultDTO<EgovMap> listUserTelnoChgHstry(UserMgrVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<EgovMap> resultDTO = userMgrFacadeService.listUserTelnoChgHstry(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 사용자 등록/수정 폼 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "user/mgr/adm_user_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admUserMgrWriteForm.do")
    public String userMgrWriteForm(UserMgrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        UserMgrFormView view = userMgrFacadeService.userMgrFormView(vo, userCtx);

        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_USER));
        model.addAttribute("detail", view.getDetail());
        model.addAttribute("photoFileList", view.getPhotoFileList());
        model.addAttribute("orgList", view.getOrgList());
        model.addAttribute("authrtList", view.getAuthrtList());
        model.addAttribute("userAuthrtIds", view.getUserAuthrtIds());
        model.addAttribute("userTyAuthrtList", view.getUserTyAuthrtList());
        model.addAttribute("acRcdTyList", view.getAcRcdTyList());
        model.addAttribute("dsblTyList", view.getDsblTyList());
        model.addAttribute("dsblGrdList", view.getDsblGrdList());
        model.addAttribute("allOrgYn", view.getAllOrgYn());
        model.addAttribute("editMode", view.getDetail() != null);
        model.addAttribute("vo", vo);
        model.addAttribute("encParams", getEncParams());

        return "user/mgr/adm_user_write";
    }

    /*****************************************************
     * 아이디 중복 확인
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @RequestMapping(value = "/admCountUserMgrId.do")
    @ResponseBody
    public ResultDTO<UserMgrVO> countUserMgrId(UserMgrVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrVO> resultDTO = userMgrFacadeService.countUserMgrId(vo);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 학번/사번 중복 확인
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @RequestMapping(value = "/admCountUserMgrStdntNo.do")
    @ResponseBody
    public ResultDTO<UserMgrVO> countUserMgrStdntNo(UserMgrVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrVO> resultDTO = userMgrFacadeService.countUserMgrStdntNo(vo);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 사용자 등록
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @RequestMapping(value = "/admRegistUserMgr.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<UserMgrVO> registUserMgr(UserMgrVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrVO> resultDTO = userMgrFacadeService.registUserMgr(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 사용자 수정
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @RequestMapping(value = "/admModifyUserMgr.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<UserMgrVO> modifyUserMgr(UserMgrVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        vo.setCntnIp(CommonUtil.getIpAddress(request));
        vo.setCntnBrwsr(userAgent == null ? "etc" : CommonUtil.getBrowser(request));
        vo.setCntnDvcTycd(userAgent == null ? "PC" : CommonUtil.getDeviceType(request));

        ResultDTO<UserMgrVO> resultDTO = userMgrFacadeService.modifyUserMgr(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 사용자 탈퇴 처리 (손님 대상, 관리자 대리 탈퇴)
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @RequestMapping(value = "/admWithdrawUserMgr.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<UserMgrVO> withdrawUserMgr(UserMgrVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrVO> resultDTO = userMgrFacadeService.withdrawUserMgr(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 관리자 구분 변경 팝업 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "user/mgr/popup/adm_user_auth_change_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admUserMgrAuthChangePop.do")
    public String userMgrAuthChangePop(UserMgrVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        ResultDTO<UserMgrVO> result = userMgrFacadeService.selectUserMgr(vo, userCtx);

        model.addAttribute("detail", result.getData());
        model.addAttribute("authrtList", userMgrFacadeService.listAdminGbn());
        model.addAttribute("userAuthrtIds", userMgrFacadeService.listUserAuthrtId(vo.getUserId()));
        model.addAttribute("encParams", getEncParams());

        return "user/mgr/popup/adm_user_auth_change_pop";
    }

    /*****************************************************
     * 사용자 관리자 구분 변경
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @RequestMapping(value = "/admModifyUserMgrAuth.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<UserMgrVO> modifyUserMgrAuth(UserMgrVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        vo.setCntnIp(CommonUtil.getIpAddress(request));
        vo.setCntnBrwsr(userAgent == null ? "etc" : CommonUtil.getBrowser(request));
        vo.setCntnDvcTycd(userAgent == null ? "PC" : CommonUtil.getDeviceType(request));

        ResultDTO<UserMgrVO> resultDTO = userMgrFacadeService.modifyUserMgrAuth(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 사용자 알림 바로 보내기 (선택 채널 발송)
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMsgVO>
     ******************************************************/
    @RequestMapping(value = "/admSendUserMsg.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<UserMsgVO> sendUserMsg(UserMsgVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMsgVO> resultDTO = userMgrFacadeService.sendUserMsg(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 사용자 대리로그인 (관리자 → 교수/학생 대시보드 진입)
     * @param userCtx
     * @param request
     * @return "redirect:..."
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admLoginAsUser.do")
    public String loginAsUser(@CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        String targetUserId = StringUtil.nvl(request.getParameter("userId"));
        String goUrl = StringUtil.nvl(request.getParameter("goUrl"));

        if (isBlank(targetUserId)) {
            throw new AccessDeniedException(getCommonFailMessage());
        }

        UserVO targetUser = userService.userSelect(targetUserId);
        if (targetUser == null) {
            throw new AccessDeniedException(getCommonFailMessage());
        }
        if (StringUtil.nvl(targetUser.getAuthrtGrpcd()).contains(CommConst.AUTHRT_GRPCD_ADM)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        HttpSession session = request.getSession();
        if (session.getAttribute(ADMIN_ORIGIN_CONTEXT) == null) {
            session.setAttribute(ADMIN_ORIGIN_CONTEXT, userCtx);
        }

        applyUserContext(request, loginService.buildUserContext(targetUser));

        return "redirect:" + (isBlank(goUrl) ? "/dashboard/main.do" : goUrl);
    }

    /*****************************************************
     * 대리로그인 해제 (지원창 종료 시 원 관리자 세션 복원)
     * @param request
     * @return "1"
     ******************************************************/
    @RequestMapping(value = "/restoreAdminContext.do")
    @ResponseBody
    public String restoreAdminContext(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            UserContext origin = (UserContext) session.getAttribute(ADMIN_ORIGIN_CONTEXT);
            if (origin != null) {
                applyUserContext(request, origin);
                session.removeAttribute(ADMIN_ORIGIN_CONTEXT);
            }
        }
        return "1";
    }

    /*****************************************************
     * UserContext 세션 주입 (식별자/권한 세션키 동기화 포함)
     * @param request
     * @param ctx
     ******************************************************/
    private void applyUserContext(HttpServletRequest request, UserContext ctx) {
        UserVO sel = ctx.getLoginUser();
        SessionInfo.setUserContext(request, ctx);
        SessionInfo.setOrgId(request, sel.getOrgId());
        SessionInfo.setUserId(request, sel.getUserId());
        SessionInfo.setUserRprsId(request, sel.getUserRprsId());
        SessionInfo.setAuthrtCd(request, sel.getAuthrtCd());
        SessionInfo.setAuthrtGrpcd(request, sel.getAuthrtGrpcd());
    }

    /*****************************************************
     * 목록 화면 공통 모델/암호화 파라미터 구성
     * @param model
     * @param request
     * @param vo
     * @throws Exception
     ******************************************************/
    private void setCommonModel(ModelMap model, HttpServletRequest request, UserMgrListVO vo) throws Exception {
        preserveMenuId(vo, request);
        addEncParam("orgId", vo.getOrgId());
        addEncParam("authrtGrpcd", vo.getAuthrtGrpcd());
        addEncParam("userTycd", vo.getUserTycd());
        addEncParam("searchValue", vo.getSearchValue());

        model.addAttribute("vo", vo);
        model.addAttribute("encParams", getEncParams());
    }

    /*****************************************************
     * menuId 유지
     * @param vo
     * @param request
     * @throws Exception
     ******************************************************/
    private void preserveMenuId(UserMgrListVO vo, HttpServletRequest request) throws Exception {
        String menuId = StringUtil.nvl(vo.getMenuId());
        if (isBlank(menuId)) {
            menuId = StringUtil.nvl(request.getParameter("menuId"));
        }
        if (!isBlank(menuId)) {
            vo.setMenuId(menuId);
            addEncParam("menuId", menuId);
        }
    }

    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
