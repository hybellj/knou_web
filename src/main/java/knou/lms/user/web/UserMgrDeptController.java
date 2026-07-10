package knou.lms.user.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import knou.framework.common.AdminMenuInfo;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.user.CurrentUser;
import knou.lms.user.facade.UserMgrDeptFacadeService;
import knou.lms.user.vo.UserMgrDeptListVO;
import knou.lms.user.vo.UserMgrDeptVO;
import knou.lms.user.web.view.UserMgrDeptListView;

@Controller
@RequestMapping(value = "/user/userMgrDept")
public class UserMgrDeptController extends ControllerBase {

    private static final Logger log = LoggerFactory.getLogger(AdminMenuInfo.class);

    @Resource(name = "userMgrDeptFacadeService")
    private UserMgrDeptFacadeService userMgrDeptFacadeService;

    /*****************************************************
     * 학과/부서 관리 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "user/mgr/adm_user_dept_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admUserMgrDeptList.do")
    public String userMgrDeptList(UserMgrDeptListVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        UserMgrDeptListView view = userMgrDeptFacadeService.userMgrDeptListView(vo, userCtx);

        model.addAttribute("orgList", view.getOrgList());
        model.addAttribute("deptCodeList", view.getDeptCodeList());
        model.addAttribute("allOrgYn", view.getAllOrgYn());
        model.addAttribute("haksaSyncYn", view.getHaksaSyncYn());
        setCommonModel(model, request, vo);

        return "user/mgr/adm_user_dept_list";
    }

    /*****************************************************
     * 학과/부서 목록 조회
     * @param vo
     * @param userCtx
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @RequestMapping(value = "/admListUserMgrDept.do")
    @ResponseBody
    public ResultDTO<EgovMap> listUserMgrDept(UserMgrDeptListVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<EgovMap> resultDTO = userMgrDeptFacadeService.listUserMgrDept(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 학과/부서 상위 코드 목록 조회 (기관 변경 시)
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @RequestMapping(value = "/admListUserMgrDeptCode.do")
    @ResponseBody
    public ResultDTO<UserMgrDeptVO> listUserMgrDeptCode(UserMgrDeptVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrDeptVO> resultDTO = new ResultDTO<UserMgrDeptVO>()
                .setReturnList(userMgrDeptFacadeService.listUserMgrDeptCode(vo, userCtx))
                .setResultSuccess();
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 학과/부서 단건 조회 (수정 폼)
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @RequestMapping(value = "/admSelectUserMgrDept.do")
    @ResponseBody
    public ResultDTO<UserMgrDeptVO> selectUserMgrDept(UserMgrDeptVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrDeptVO> resultDTO = userMgrDeptFacadeService.selectUserMgrDept(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 학과/부서 등록
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @RequestMapping(value = "/admRegistUserMgrDept.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<UserMgrDeptVO> registUserMgrDept(UserMgrDeptVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrDeptVO> resultDTO = userMgrDeptFacadeService.registUserMgrDept(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 학과/부서 수정
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @RequestMapping(value = "/admModifyUserMgrDept.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<UserMgrDeptVO> modifyUserMgrDept(UserMgrDeptVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrDeptVO> resultDTO = userMgrDeptFacadeService.modifyUserMgrDept(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 학과/부서 삭제
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @RequestMapping(value = "/admDeleteUserMgrDept.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<UserMgrDeptVO> deleteUserMgrDept(UserMgrDeptVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<UserMgrDeptVO> resultDTO = userMgrDeptFacadeService.deleteUserMgrDept(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 학과/부서 학사연동 가져오기 팝업 화면
     * @param vo
     * @param model
     * @return "user/mgr/popup/adm_user_dept_haksa_sync_pop"
     ******************************************************/
    @RequestMapping(value = "/admUserMgrDeptHaksaSyncPopup.do")
    public String userMgrDeptHaksaSyncPopup(UserMgrDeptVO vo, ModelMap model) {
        model.addAttribute("vo", vo);
        model.addAttribute("encParams", getEncParams());

        return "user/mgr/popup/adm_user_dept_haksa_sync_pop";
    }

    /*****************************************************
     * 학과/부서 학사연동 실행
     * @param vo
     * @param userCtx
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @RequestMapping(value = "/admRunUserMgrDeptHaksaSync.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<EgovMap> runUserMgrDeptHaksaSync(UserMgrDeptVO vo, @CurrentUser UserContext userCtx) {
        ResultDTO<EgovMap> resultDTO = userMgrDeptFacadeService.runUserMgrDeptHaksaSync(vo, userCtx);
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /*****************************************************
     * 목록 화면 공통 모델/암호화 파라미터 구성
     * @param model
     * @param request
     * @param vo
     * @throws Exception
     ******************************************************/
    private void setCommonModel(ModelMap model, HttpServletRequest request, UserMgrDeptListVO vo) throws Exception {
        preserveMenuId(vo, request);
        addEncParam("orgId", vo.getOrgId());
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
    private void preserveMenuId(UserMgrDeptListVO vo, HttpServletRequest request) throws Exception {
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
