package knou.lms.rubricmng.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.rubricmng.service.RubricMngService;
import knou.lms.rubricmng.vo.RubricMngVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/rubricmng")
public class RubricMngController extends ControllerBase {

    @Resource(name = "rubricMngService")
    private RubricMngService rubricMngService;

    /*****************************************************
     * 기본 루브릭 관리 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admRubricMngList.do")
    public String rubricMngList(RubricMngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);
        applyOrgScope(vo, userCtx, request);
        setCommonModel(model, request, userCtx, vo);
        return "rubricmng/adm_rubricmng_list";
    }

    /*****************************************************
     * 기본 루브릭 관리 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<RubricMngVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admListRubricMng.do")
    @ResponseBody
    public ProcessResultVO<RubricMngVO> listRubricMng(RubricMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<RubricMngVO> resultVO = new ProcessResultVO<RubricMngVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);
            resultVO = rubricMngService.listRubricPaging(vo);
            resultVO.setResultSuccess();
            delEncParam("rubricId");
            delEncParam("rubricTtl");
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            delEncParam("rubricId");
            delEncParam("rubricTtl");
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 기본 루브릭 등록/수정 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admRubricMngWrite.do")
    public String rubricMngWrite(RubricMngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);
        applyOrgScope(vo, userCtx, request);

        String isModify = "N";
        List<EgovMap> rubricInfoVO = null;
        if (!isBlank(vo.getRubricId())) {
            RubricMngVO infoVO = rubricMngService.selectRubricRegistInfo(vo);
            if (infoVO == null) {
                throw new BadRequestUrlException("대상 루브릭 정보를 찾을 수 없습니다.");
            }
            vo.setOrgId(infoVO.getOrgId());
            vo.setRubricTtl(infoVO.getRubricTtl());
            rubricInfoVO = rubricMngService.listRubricInfo(vo);
            isModify = "Y";
        }

        setCommonModel(model, request, userCtx, vo);
        model.addAttribute("vo", vo);
        model.addAttribute("rubricInfoVO", rubricInfoVO);
        model.addAttribute("isModify", isModify);
        return "rubricmng/adm_rubricmng_write";
    }

    /*****************************************************
     * 루브릭 가져오기 팝업
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     ******************************************************/
    @RequestMapping(value = "/admRubricMngImportPopup.do")
    public String rubricMngImportPopup(RubricMngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        checkAdmin(userCtx, request);
        applyOrgScope(vo, userCtx, request);
        model.addAttribute("vo", vo);
        return "rubricmng/popup/adm_rubricmng_import_pop";
    }

    /*****************************************************
     * 루브릭 문항/평가등급 정보 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return List<EgovMap>
     ******************************************************/
    @RequestMapping(value = "/admListRubricMngInfo.do")
    @ResponseBody
    public List<EgovMap> listRubricMngInfo(RubricMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) {
        checkAdmin(userCtx, request);
        applyOrgScope(vo, userCtx, request);
        return rubricMngService.listRubricInfo(vo);
    }

    /*****************************************************
     * 기본 루브릭 등록
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<RubricMngVO>
     ******************************************************/
    @RequestMapping(value = "/admRubricMngRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<RubricMngVO> rubricMngRegist(RubricMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) {
        ProcessResultVO<RubricMngVO> resultVO = new ProcessResultVO<RubricMngVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);
            vo.setUserId(getUserId(userCtx, request));
            if (isBlank(vo.getOrgId())) {
                throw new BadRequestUrlException("기관 정보를 확인할 수 없습니다.");
            }
            resultVO.setReturnVO(rubricMngService.rubricRegist(vo));
            resultVO.setResultSuccess(getMessage("success.common.save"));
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
        }
        return resultVO;
    }

    /*****************************************************
     * 기본 루브릭 수정
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<RubricMngVO>
     ******************************************************/
    @RequestMapping(value = "/admRubricMngModify.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<RubricMngVO> rubricMngModify(RubricMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) {
        ProcessResultVO<RubricMngVO> resultVO = new ProcessResultVO<RubricMngVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);
            vo.setUserId(getUserId(userCtx, request));
            resultVO.setReturnVO(rubricMngService.rubricModify(vo));
            resultVO.setResultSuccess(getMessage("success.common.save"));
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
        }
        return resultVO;
    }

    /*****************************************************
     * 기본 루브릭 사용여부 수정
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<RubricMngVO>
     ******************************************************/
    @RequestMapping(value = "/admRubricMngUseynModify.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<RubricMngVO> rubricMngUseynModify(RubricMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) {
        ProcessResultVO<RubricMngVO> resultVO = new ProcessResultVO<RubricMngVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);
            vo.setUserId(getUserId(userCtx, request));
            rubricMngService.rubricUseynModify(vo);
            resultVO.setResultSuccess(getMessage("success.common.save"));
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
        }
        return resultVO;
    }

    /*****************************************************
     * 기본 루브릭 삭제
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<RubricMngVO>
     ******************************************************/
    @RequestMapping(value = "/admRubricMngDelete.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<RubricMngVO> rubricMngDelete(RubricMngVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) {
        ProcessResultVO<RubricMngVO> resultVO = new ProcessResultVO<RubricMngVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);
            vo.setUserId(getUserId(userCtx, request));
            rubricMngService.rubricDelete(vo);
            resultVO.setResultSuccess(getMessage("success.common.save"));
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
        }
        return resultVO;
    }

    /*****************************************************
     * 화면 공통 데이터 설정
     * @param model
     * @param request
     * @param userCtx
     * @param vo
     * @throws Exception
     ******************************************************/
    private void setCommonModel(ModelMap model, HttpServletRequest request, UserContext userCtx, RubricMngVO vo) throws Exception {
        String sessionOrgId = getOrgId(userCtx, request);
        boolean allOrgYn = isAllOrgAdmin(userCtx);
        preserveMenuId(vo, request);

        RubricMngVO orgVO = new RubricMngVO();
        if (!allOrgYn) {
            orgVO.setOrgId(sessionOrgId);
            if (isBlank(vo.getOrgId())) {
                vo.setOrgId(sessionOrgId);
            }
        }

        addEncParam("orgId", vo.getOrgId());
        delEncParam("rubricId");
        delEncParam("rubricTtl");

        model.addAttribute("vo", vo);
        model.addAttribute("orgInfoList", rubricMngService.listOrg(orgVO));
        model.addAttribute("allOrgYn", allOrgYn ? "Y" : "N");
        model.addAttribute("orgId", sessionOrgId);
        model.addAttribute("encParams", getEncParams());
    }

    private void preserveMenuId(RubricMngVO vo, HttpServletRequest request) throws Exception {
        String menuId = StringUtil.nvl(vo.getMenuId());
        if (isBlank(menuId)) {
            menuId = StringUtil.nvl(request.getParameter("menuId"));
        }
        if (!isBlank(menuId)) {
            vo.setMenuId(menuId);
            addEncParam("menuId", menuId);
        }
    }

    /*****************************************************
     * 기관 범위 적용
     * @param vo
     * @param userCtx
     * @param request
     ******************************************************/
    private void applyOrgScope(RubricMngVO vo, UserContext userCtx, HttpServletRequest request) {
        if (!isAllOrgAdmin(userCtx)) {
            vo.setOrgId(getOrgId(userCtx, request));
        }
    }

    /*****************************************************
     * 전체기관 관리자 여부 확인
     * @param request
     * @return boolean
     ******************************************************/
    private boolean isAllOrgAdmin(UserContext userCtx) {
        String orgId = userCtx != null ? StringUtil.nvl(userCtx.getOrgId()) : "";
        return CommConst.KNOU_ORG_ID.equals(orgId) || CommConst.LMSBASIC_ORG_ID.equals(orgId);
    }

    /*****************************************************
     * 관리자 권한 확인
     * @param userCtx
     * @param request
     ******************************************************/
    private void checkAdmin(UserContext userCtx, HttpServletRequest request) {
        if (userCtx != null && userCtx.isAdmin()) {
            return;
        }

        String authGrpCd = getAuthGrpCd(userCtx, request);
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        if (CommConst.AUTHRT_GRPCD_ADM.equals(authGrpCd) || "Y".equals(admYn)) {
            return;
        }

        throw new AccessDeniedException(getCommonNoAuthMessage());
    }

    /*****************************************************
     * 사용자 아이디 조회
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String getUserId(UserContext userCtx, HttpServletRequest request) {
        if (userCtx != null && !isBlank(userCtx.getUserId())) {
            return userCtx.getUserId();
        }
        return "";
    }

    /*****************************************************
     * 기관 아이디 조회
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String getOrgId(UserContext userCtx, HttpServletRequest request) {
        if (userCtx != null && !isBlank(userCtx.getOrgId())) {
            return userCtx.getOrgId();
        }
        return "";
    }

    /*****************************************************
     * 권한 그룹코드 조회
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String getAuthGrpCd(UserContext userCtx, HttpServletRequest request) {
        if (userCtx != null && !isBlank(userCtx.getAuthrtGrpcd())) {
            return StringUtil.nvl(userCtx.getAuthrtGrpcd());
        }
        return "";
    }

    /*****************************************************
     * 공백 여부 확인
     * @param value
     * @return boolean
     ******************************************************/
    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
