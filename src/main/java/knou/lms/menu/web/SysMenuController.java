package knou.lms.menu.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.StringUtil;
import knou.lms.common.service.OrgMenuService;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.AdmAuthSaveVO;
import knou.lms.menu.vo.MenuVO;
import knou.lms.menu.vo.MgrSysMenuVO;
import knou.lms.menu.vo.SysAuthGrpVO;
import knou.lms.menu.vo.SysMenuVO;
import knou.lms.org.service.OrgService;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/menu/menuMgr")
public class SysMenuController extends ControllerBase {

    @Autowired @Qualifier("orgMenuService")
    private OrgMenuService orgMenuService;

    @Autowired @Qualifier("sysMenuService")
    private SysMenuService sysMenuService;

    @Resource(name="orgService")
    private OrgService orgService;

    private Logger logger = LoggerFactory.getLogger(getClass());

    /*****************************************************
     * @Method Name : sysMenuMain
     * @Method 설명 : 시스템 관리 > 메뉴관리
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "menu/system_menu.jsp"
     * @throws Exception
     * /menu/menuMgr/sysMenuMain.do
     ******************************************************/
    @RequestMapping(value = "/admAuthMngListView.do")
    public String sysAuthMain(OrgMenuVO vo, @CurrentUser UserContext userCtx,
            ModelMap model, HttpServletRequest request) throws Exception {

        String menuTycd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if (!menuTycd.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        String orgId    = SessionInfo.getOrgId(request);
        String userTycd = StringUtil.nvl(SessionInfo.getAuthrtCd(request), "SUP");

        vo.setOrgId(orgId);
        vo.setAuthrtGrpcd("ADM");
        vo.setAuthrtCd(userTycd);
        vo.setParMenuCd(""); // 최상위 메뉴

        // 권한 그룹 목록 조회
        SysAuthGrpVO sagvo = new SysAuthGrpVO();
        sagvo.setOrgId(orgId);
        sagvo.setAuthrtGrpcd("ADM");

        List<SysAuthGrpVO> authGrpList = sysMenuService.selectListAuthGrp(sagvo).getReturnList();
        request.setAttribute("authGrpList", authGrpList);

        request.setAttribute("authGrpCd", vo.getAuthrtCd());
        request.setAttribute("vo", vo);

        model.addAttribute("filterOptions", sysMenuService.loadFilterOptions(userCtx));
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request)); // 현 프로세스 유지(원본값)

        return "menu/adm_auth_mng_list_view";
    }

    /*****************************************************
     * @Method Name : sysMenuMain
     * @Method 설명 : 시스템 관리 > 메뉴관리
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "menu/system_menu.jsp"
     * @throws Exception
     * /menu/menuMgr/sysMenuMain.do
     ******************************************************/
    @RequestMapping(value="/admMenuMngListView.do")
    public String sysMenuMain(MenuVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        model.addAttribute("langCd", StringUtil.nvl(userCtx.getLangCd(), "ko"));

        // ✅ 초기 권한 탭 목록 조회 (ADM 기본값)
        SysAuthGrpVO authGrpVO = new SysAuthGrpVO();
        authGrpVO.setAuthrtGrpcd("ADM");
        authGrpVO.setMenuGbncd("MAIN");

        List<SysAuthGrpVO> authrtTabList = sysMenuService.admAuthrtTabList(authGrpVO);
        model.addAttribute("authrtTabList", authrtTabList);
        model.addAttribute("vo", vo);

        return "menu/adm_menu_mng_list_view";
    }

    /*****************************************************
     * 관리자 메뉴 조회
     * @param request
     * @param response
     * @param model
     * @param SysMenuVO
     * @return List<MgrSysMenuVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/sysMenuList.do")
    @ResponseBody
    public List<MgrSysMenuVO> sysMenuList(HttpServletRequest request, HttpServletResponse response, ModelMap model, SysMenuVO vo) throws Exception {
        List<MgrSysMenuVO> resultList = sysMenuService.selectSysMenulist(vo);
        return resultList;
    }

    /*****************************************************
     * 관리자 권한 조회
     * @param request
     * @param response
     * @param model
     * @param SysMenuVO
     * @return List<MgrSysMenuVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAuthMngListViewAjax.do")
    @ResponseBody
    public ProcessResultVO<SysAuthGrpVO> admAuthMngListViewAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model, SysAuthGrpVO vo) throws Exception {
    	ProcessResultVO<SysAuthGrpVO> resultVO = new ProcessResultVO<>();
    	vo.setOrgId(vo.getOrgId());
    	vo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"ADM")); //-- 홈페이지

    	String mode = request.getParameter("mode");

    	if("I".equals(mode)) {
    		resultVO = sysMenuService.admAuthMngPopViewAjax(vo);
    	} else {
    		resultVO = sysMenuService.admAuthMngListViewAjax(vo);
    	}

    	resultVO.setResult(1);
    	resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /*****************************************************
     * 관리자 메뉴 사용 유무 저장
     * @param request
     * @param response
     * @param model
     * @param SysMenuVO
     * @return int
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/updateSysMenuListUseYn.do")
    @ResponseBody
    public ProcessResultVO<SysMenuVO> updateSysMenuListUseYn(@RequestBody SysMenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysMenuVO> resultVO = new ProcessResultVO<>();

        try {
            vo.setMdfrId(SessionInfo.getUserId(request));
            sysMenuService.updateSysMenuListUseYn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 관리자 권한관리 페이지 이동
     * @param BbsAtclVO
     * @param model
     * @param request
     * @return "bbs/bbs_atcl_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAuthRegist.do")
    public String admAuthRegist(SysAuthGrpVO sysAuthGrpVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {
        return "menu/adm_auth_regist";
    }

    /*****************************************************
     * 게시글 저장(등록)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAuthSave.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<SysAuthGrpVO> admAuthSave(
            @RequestParam String saveDataJson,
            @CurrentUser UserContext userCtx,
            ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<SysAuthGrpVO> resultVO = new ProcessResultVO<>();

        try {
            // JSON 파싱 (사유 + 목록을 한 번에)
            ObjectMapper objectMapper = new ObjectMapper();
            AdmAuthSaveVO saveData = objectMapper.readValue(saveDataJson, AdmAuthSaveVO.class);

            String authrtChgCts       = saveData.getAuthrtChgCts();
            List<SysAuthGrpVO> admList = saveData.getAdmList();

            // 공통 값 세팅
            for (SysAuthGrpVO vo : admList) {
                vo.setAuthrtChgCts(authrtChgCts);
                vo.setOrgId(userCtx.getOrgId());
                vo.setRgtrId(userCtx.getUserId());
                vo.setMdfrId(userCtx.getUserId());
            }
            // 권한 변경
            sysMenuService.admAuthSave(admList);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save"));
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    @RequestMapping(value = "/admMgrAddPopupView.do")
    public String admMgrAddPopupView(SysAuthGrpVO sysAuthGrpVO, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {

    	EgovMap filterOptions = sysMenuService.loadFilterOptions(userCtx);
		model.addAttribute("filterOptions", filterOptions);

    	model.addAttribute("encParams", getEncParams());
        model.addAttribute("vo", sysAuthGrpVO);

        return "menu/popup/adm_mgr_add_popup";
    }

    /*****************************************************
	 * 게시글 삭제
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/admAuthDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<SysAuthGrpVO> admAuthDelete(SysAuthGrpVO sysAuthGrpVO, @CurrentUser UserContext userCtx, ModelMap model,
			HttpServletRequest request) throws Exception {

		ProcessResultVO<SysAuthGrpVO> resultVO = new ProcessResultVO<>();

		String userId = sysAuthGrpVO.getUserId();

		try {
			sysMenuService.admAuthDelete(sysAuthGrpVO);

			resultVO.setResult(1);
			resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * [관리자] 기관관리 > 강의실 메뉴 설정
	 *
	 * @param vo
	 * @param model
	 * @return "org/org_manage_list"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/admMenuStngView.do")
	public String admMenuStngView(MenuVO vo, @CurrentUser UserContext userCtx, Model model) {
		String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

		if (!menuType.contains("ADM")) {
			throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
		}

		model.addAttribute("langCd", StringUtil.nvl(userCtx.getLangCd(), "ko"));
		model.addAttribute("orgList", orgService.orgListSelect());

		vo.setMenuGbncd("MAIN");
		vo.setMenuAuthTycd("PROF");
		model.addAttribute("vo", vo);

		return "menu/adm_tenancy_menu_setting_list_view";
	}

	/*****************************************************
     * 관리자 메뉴 조회
     * @param request
     * @param response
     * @param model
     * @param SysMenuVO
     * @return List<MgrSysMenuVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAuthrtTabList.do")
    @ResponseBody
    public List<SysAuthGrpVO> admAuthrtTabList(HttpServletRequest request, HttpServletResponse response, ModelMap model, SysAuthGrpVO vo) throws Exception {
        List<SysAuthGrpVO> resultList = sysMenuService.admAuthrtTabList(vo);
        return resultList;
    }

    /**
	 * 메뉴 사용여부 변경
	 *
	 * @param vo
	 * @return
	 */
	@PostMapping("/admMenuStngModify.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admMenuStngModify(SysAuthGrpVO vo, @CurrentUser UserContext userCtx) {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		vo.setMdfrId(userCtx.getUserId());
		sysMenuService.admMenuUseynModify(vo);

		resultVO.setResultSuccess();
		return resultVO;
	}

	// 쓰기허용 수정 + 이력 저장
	@PostMapping("/admMenuWriteynChgHstry.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admMenuWriteynChgHstry(SysAuthGrpVO vo, @CurrentUser UserContext userCtx) {
	    ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

	    try {
	        vo.setMdfrId(userCtx.getUserId());
	        vo.setRgtrId(userCtx.getUserId());
	        sysMenuService.admMenuWriteynChgHstry(vo);
	        resultVO.setResult(1);
	    } catch (Exception e) {
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}

	    return resultVO;
	}

	/**
	 * 메뉴 목록 Ajax 조회
	 *
	 * @param vo
	 * @return
	 */
	@GetMapping("/admMenuStngListAjax.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admMenuStngListAjax(MenuVO vo) {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		// 메뉴 계층 조회
		List<EgovMap> menuList = sysMenuService.admMenuList(vo);

		resultVO.setReturnList(menuList);
		resultVO.setResultSuccess();

		return resultVO;
	}
}
