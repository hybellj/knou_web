package knou.lms.org.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import knou.framework.common.*;
import knou.lms.common.dto.ResultDTO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.dashboard.vo.WidgetDTO;
import knou.lms.dashboard.vo.WidgetVO;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.MenuVO;
import knou.lms.menu.vo.SysAuthGrpVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.service.OrgService;
import knou.lms.org.vo.OrgAisLinkVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.org.vo.OrgSettingVO;
import knou.lms.org.vo.OrgTemplateVO;
import knou.lms.org.vo.OrgVO;
import knou.lms.system.manage.service.CommonCodeService;
import knou.lms.system.manage.vo.CommonCodeVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/org/orgMgr")
public class OrgMgrController extends ControllerBase {

	private static final Logger LOGGER = LoggerFactory.getLogger(OrgMgrController.class);

	@Resource(name = "orgInfoService")
	private OrgInfoService orgInfoService;

	@Resource(name = "orgService")
	private OrgService orgService;

	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "sysFileService")
	private SysFileService sysFileService;

	@Autowired @Qualifier("sysMenuService")
    private SysMenuService sysMenuService;

	/**
	 * 기관 목록 조회 Ajax
	 *
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@GetMapping("/admOrgListAjax.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgListAjax(OrgVO vo) throws Exception {

		ProcessResultVO<EgovMap> resultVO = orgService.orgListPaging(vo);
		resultVO.setEncParams(getEncParams());

		return resultVO;
	}

	/*****************************************************
	 * 기관(테넌시) - 기본 정보 관리 목록 폼
	 *
	 * @param vo
	 * @param model
	 * @return "org/adm_tenancy_basic_list_view"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/admOrgListView.do")
	public String orgManageList(MenuVO mvo, OrgInfoVO vo, @CurrentUser UserContext userCtx, Model model) throws Exception {
		model.addAttribute("vo", vo);
		model.addAttribute("encParams", getEncParams());
		addEncParam("menuId",  mvo.getMenuId());
		return "org/adm_tenancy_basic_list_view";
	}

	/*****************************************************
	 * 기관(테넌시) - 기본 정보 관리 페이징 Ajax
	 *
	 * @param vo
	 * @return ProcessResultVO<EgovMap>
	 * @throws Exception
	 ******************************************************/
	@GetMapping(value = "/admOrgListViewAjax.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgListViewAjax(OrgVO vo) throws Exception {

		ProcessResultVO<EgovMap> resultVO = orgService.orgListPaging(vo);
		resultVO.setEncParams(getEncParams());

		return resultVO;
	}

	/*****************************************************
	 * 기관(테넌시) - 기본정보 상세 조회
	 *
	 * @param vo
	 * @param model
	 * @return "org/adm_tenancy_basic_detail_view.jsp"
	 * @throws Exception
	 ******************************************************/
	@GetMapping("/admOrgDetailView.do")
	public String admOrgDetailView(OrgVO vo, @CurrentUser UserContext userCtx, Model model) {
		String menuType = userCtx.getAuthrtGrpcd();

		if (!menuType.contains("ADM")) {
			throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
		}

		// 기관 정보 조회
		EgovMap orgVO = orgService.orgSelect(vo.getOrgId());

		model.addAttribute("vo", orgVO);
		//model.addAttribute("logoFileId", (String)orgVO.get("logoFileId"));
		model.addAttribute("encParams", getEncParams());

		return "org/adm_tenancy_basic_detail_view";
	}

	/**
	 * [기관관리 > 기본정보관리] 기관 기본정보 등록 화면
	 *
	 * @param vo
	 * @param userCtx
	 * @return
	 */
	@GetMapping("/admOrgRegistView.do")
	public String admOrgRegistView(OrgVO vo, Model model, @CurrentUser UserContext userCtx,
			HttpServletRequest request) {

		PageInfo pageInfo = new PageInfo();
		pageInfo.setUpCd("ORG_TYCD");
		pageInfo.setOrgId("LMSBASIC");

		List<EgovMap> orgTycdList = commonCodeService.admCmmnCdList(pageInfo);
		model.addAttribute("orgTycdList", orgTycdList);

		model.addAttribute("encParams", getEncParams());
		model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_LOGO, null));
		model.addAttribute("gubun", "regist");

		return "org/adm_tenancy_basic_regist_view";
	}

	/**
	 * 기관 아이디 중복 체크
	 *
	 * @param vo
	 * @return
	 */
	@GetMapping("/admOrgIdDuplicateCheck.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgIdDuplicateCheck(OrgVO vo) {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		EgovMap searchedOrgVO = orgService.orgSelect(StringUtil.nvl(vo.getOrgId()));

		if (ValidationUtils.isNull(searchedOrgVO)) {
			resultVO.setResultSuccess("사용 가능합니다.");
		} else {
			resultVO.setResultFailed("중복된 기관ID 입니다.");
		}

		return resultVO;
	}

	/**
	 * 기관(테넌시)- 기관 기본정보 등록
	 *
	 * @param vo
	 * @return ProcessResultVO<EgovMap>
	 * @throws Exception
	 */
	@RequestMapping(value = "/admOrgRegist.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgRegist(OrgVO vo, @CurrentUser UserContext userCtx)
			throws JsonProcessingException {

		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		String userType = StringUtil.nvl(userCtx.getAuthrtCd());

		// 슈퍼관리자
		if (!(userType.contains("DEV") || userType.contains("ADM") || userType.contains("SUP"))) {
			// 페이지 접근 권한이 없습니다.
			throw new AccessDeniedException(getCommonNoAuthMessage());
		}

		vo.setRgtrId(userCtx.getUserId());

		orgService.orgRegist(vo);
		resultVO.setResultSuccess(getMessage("success.common.save"));

		return resultVO;
	}

	/**
	 * [기관관리 > 기본정보관리] 기관 기본정보 수정 화면
	 *
	 * @param vo
	 * @param userCtx
	 * @return
	 */
	@GetMapping("/admOrgModifyView.do")
	public String admOrgModifyView(OrgVO vo, Model model, @CurrentUser UserContext userCtx,
			HttpServletRequest request) {

		CommonCodeVO cmmnCdVO = new CommonCodeVO();
		cmmnCdVO.setUpCd("ORG_TYCD");
		cmmnCdVO.setOrgId("LMSBASIC");

        PageInfo pageInfo = new PageInfo();
        pageInfo.setUpCd("ORG_TYCD");
        pageInfo.setOrgId("LMSBASIC");

        List<EgovMap> orgTycdList = commonCodeService.admCmmnCdList(pageInfo);
		model.addAttribute("orgTycdList", orgTycdList);

		model.addAttribute("vo", orgService.orgSelect(vo.getOrgId()));
		model.addAttribute("encParams", getEncParams());
		model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_LOGO, null));
		model.addAttribute("gubun", "edit");

		return "org/adm_tenancy_basic_regist_view";
	}

	/**
	 * 기관 기본정보 수정
	 *
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admOrgModify.do")
	@ResponseBody
	public ProcessResultVO<OrgVO> admOrgModify(OrgVO vo, @CurrentUser UserContext userCtx) throws Exception {
		ProcessResultVO<OrgVO> resultVO = new ProcessResultVO<>();

		String userType = StringUtil.nvl(userCtx.getAuthrtCd());
		String userId = userCtx.getUserId();

		// 슈퍼관리자 OR 전체운영자
		if (!(userType.contains("DEV") || userType.contains("ADM") || userType.contains("SUP"))) {
			// 페이지 접근 권한이 없습니다.
			throw new AccessDeniedException(getCommonNoAuthMessage());
		}

		vo.setMdfrId(userId);

		// 기관 수정
		orgService.orgModify(vo);

		resultVO.setResultSuccess(getMessage("success.common.update"));
		return resultVO;
	}

	/**
	 * 기관 기본정보 삭제
	 *
	 * @param vo
	 * @param userCtx
	 * @return
	 */
	@GetMapping("/admOrgDelete.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgDelete(OrgVO vo, @CurrentUser UserContext userCtx) {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		String userType = StringUtil.nvl(userCtx.getAuthrtCd());

		// 슈퍼관리자 OR 전체운영자
		if (!(userType.contains("DEV") || userType.contains("ADM") || userType.contains("SUP"))) {
			// 페이지 접근 권한이 없습니다.
			throw new AccessDeniedException(getCommonNoAuthMessage());
		}

		// 기관 삭제
		orgService.orgDelete(vo.getOrgId());

		resultVO.setResultSuccess(getMessage("success.common.delete"));
		return resultVO;
	}

	/**
     * [기관관리 > 디자인 컬러 설정] 기관 디자인 컬러 설정 화면
	 *
	 * @param vo
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admDsgnColrStngListView.do")
	public String dsgnClrStng(MenuVO mvo, OrgTemplateVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
		String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

		if (!menuType.contains("ADM")) {
			throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
		}

		model.addAttribute("vo", vo);
		model.addAttribute("encParams", getEncParams());
        model.addAttribute("pageInfo", new PageInfo());
        addEncParam("menuId",  mvo.getMenuId());

		return "org/adm_tenancy_color_list_view";
	}

	/*****************************************************
	 * 기관(테넌시) - 디자인 컬러설정 페이징 Ajax
	 *
	 * @param vo
	 * @return ProcessResultVO<EgovMap>
	 * @throws Exception
	 ******************************************************/
	@GetMapping(value = "/admOrgTmpltListViewAjax.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgTmpltListViewAjax(OrgTemplateVO vo, @Param("currentPageNo")String currentPageNo, @Param("recordCountPerPage")String recordCountPerPage) throws Exception {

        PageInfo pageInfo = new PageInfo();
        pageInfo.setCurrentPageNo(Integer.parseInt(currentPageNo));
        pageInfo.setRecordCountPerPage(Integer.parseInt(recordCountPerPage));
        pageInfo.setSearchValue(vo.getSearchValue());

		ProcessResultVO<EgovMap> resultVO = orgService.orgTmpltListPaging(pageInfo);
        resultVO.setResultSuccess();

		return resultVO;
	}

    /**
     * 디자인 컬러설정 수정
     * @param vo
     * @param userCtx
     * @return
     */
    @PostMapping("/admDsgnColrStngModify.do")
    @ResponseBody
    public ResultDTO<EgovMap> admDsgnColrStngModify(OrgTemplateVO vo, @CurrentUser UserContext userCtx) {

        String authrtCd     = userCtx.getAuthrtCd();

        if (!userCtx.isAdmin() && !(authrtCd.equals(CommConst.AUTHRT_CD_ADM) || authrtCd.equals(CommConst.AUTHRT_CD_ORGOP))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        vo.setMdfrId(userCtx.getUserId());
        orgService.orgDsgnColrStngModify(vo);

        ResultDTO<EgovMap> resultDTO = new ResultDTO();
        resultDTO.setResultSuccess();

        return resultDTO.setResultSuccess();
    }

	/*****************************************************
	 * [관리자] 기관관리 > 대시보드 위젯설정
	 *
	 * @param vo
	 * @param model
	 * @return "org/adm_tenancy_widget_list_view"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/admOrgDashWgtStngListView.do")
	public String admDashWgtStngListView(OrgVO vo, @CurrentUser UserContext userCtx, Model model) {
		String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

		if (!menuType.contains("ADM")) {
			throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
		}

		model.addAttribute("encParams", getEncParams());
		model.addAttribute("vo", vo);

		return "org/adm_tenancy_widget_list_view";
	}

	/**
	 * 기관 대시보드 위젯 목록 Ajax 조회
	 *
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@GetMapping("/admOrgDashWgtStngListAjax.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admDashWgtStngListView(OrgVO vo) throws Exception {

		ProcessResultVO<EgovMap> resultVO = orgService.orgListPaging(vo);
		resultVO.setEncParams(getEncParams());

		return resultVO;
	}

	/**
	 * [관리자] 기관 위젯 설정 Ajax 조회
	 *
	 * @param vo
	 * @return
	 */
	@GetMapping("/admOrgDashWgtStngAjax.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgDashWgtStngPopView(WidgetVO vo) throws JsonProcessingException {

		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		// 교수 위젯
		WidgetVO profWgtVO = orgService.orgDashWgtStngSelect(vo.getOrgId(), CommConst.AUTHRT_GRPCD_PROF);
		List<WidgetDTO> profWgtList = profWgtVO == null ? null : profWgtVO.getWidgetStngList();

		// 학습자 위젯
		WidgetVO stdWgtVO = orgService.orgDashWgtStngSelect(vo.getOrgId(), CommConst.AUTHRT_GRPCD_STDNT);
		List<WidgetDTO> stdWgtList = stdWgtVO == null ? null : stdWgtVO.getWidgetStngList();

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("profWgtList", profWgtList);
		resultMap.put("stdWgtList", stdWgtList);

		resultVO.setReturnVO(resultMap);
		resultVO.setResultSuccess();

		return resultVO;
	}

	/**
	 * [관리자] 기관 대시보드 위젯 설정 수정
	 *
	 * @param vo
	 * @param userCtx
	 * @return
	 * @throws JsonProcessingException
	 */
	@PostMapping("/admOrgDashWgtStngModify.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgDashWgtStngModify(WidgetVO vo, @CurrentUser UserContext userCtx)
			throws JsonProcessingException {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		vo.setMdfrId(userCtx.getUserId());

		orgService.orgWidgetStngModify(vo);

		resultVO.setResultSuccess(getMessage("common.alert.ok.save"));

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

		return "org/adm_tenancy_menu_setting_list_view";
	}

	/*****************************************************
	 * [관리자] 기관관리 > 강의실 메뉴 설정
	 *
	 * @param vo
	 * @param model
	 * @return "org/org_manage_list"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/admOrgMenuStngView.do")
	public String admOrgMenuStngView(MenuVO vo, @CurrentUser UserContext userCtx, Model model) {
		String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

		if (!menuType.contains("ADM")) {
			throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
		}

		model.addAttribute("langCd", StringUtil.nvl(userCtx.getLangCd(), "ko"));
		model.addAttribute("orgList", orgService.orgListSelect());

		vo.setMenuGbncd("MAIN");
		vo.setMenuAuthTycd("PROF");
		model.addAttribute("vo", vo);

		return "org/adm_tenancy_menu_setting_list_view";
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
		List<EgovMap> menuList = orgService.menuList(vo);

		resultVO.setReturnList(menuList);
		resultVO.setResultSuccess();

		return resultVO;
	}

	/**
	 * 메뉴 사용여부 변경
	 *
	 * @param vo
	 * @return
	 */
	@PostMapping("/admMenuStngModify.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admMenuStngModify(MenuVO vo, @CurrentUser UserContext userCtx) {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		vo.setMdfrId(userCtx.getUserId());
		orgService.orgMenuUseynModify(vo);

		resultVO.setResultSuccess();
		return resultVO;
	}

	/*****************************************************
	 * [관리자] 기관관리 > LMS 옵션 설정
	 *
	 * @param vo
	 * @param model
	 * @return "org/adm_tenancy_lms_option_setting_list_view"
	 ******************************************************/
	@RequestMapping(value = "/admLmsOptnStngListView.do")
	public String admLmsOptStngListView(OrgVO vo, @CurrentUser UserContext userCtx, Model model) {
		String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

		if (!menuType.contains("ADM")) {
			throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
		}

		model.addAttribute("encParams", getEncParams());
		model.addAttribute("vo", vo);

		return "org/adm_tenancy_lms_option_setting_list_view";
	}

	/**
	 * 기관의 LMS 옵션 설정 조회
	 *
	 * @param vo
	 * @return
	 */
	@GetMapping("/admOrgLmsOptnStngAjax.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgLmsOptStngAjax(OrgVO vo) {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		Map<String, OrgSettingVO> optnList = orgService.orgOptnList(vo.getOrgId(), "LMS_OPTN");
		resultVO.setReturnVO(optnList);
		resultVO.setResultSuccess();

		return resultVO;
	}

	/**
	 * 기관의 LMS 옵션 설정 저장
	 *
	 * @param vo
	 * @param userCtx
	 * @return
	 */
	@PostMapping("/admOrgLmsOptnStngModify.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgLmsOptnStngModify(OrgSettingVO vo, @CurrentUser UserContext userCtx)
			throws JsonProcessingException {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		if (StringUtil.isNull(vo.getStngListStr()))
			return resultVO.setResultFailed("fail.common.config.again.try"); // 설정 적용에 실패하였습니다. 다시 시도해주시기 바랍니다.

		// json 문자열 list -> List로 변경
		ObjectMapper mapper = new ObjectMapper();
		List<OrgSettingVO> list = mapper.readValue(vo.getStngListStr(), new TypeReference<>() {
		});
		vo.setStngList(list);
		vo.setMdfrId(userCtx.getUserId());

		orgService.orgOptnModify(vo);
		resultVO.setResultSuccess(getMessage("success.common.save")); // 정상적으로 저장되었습니다.

		return resultVO;
	}

	/*****************************************************
	 * [관리자] 기관관리 > 학사연동관리
	 *
	 * @param vo
	 * @param model
	 * @return "org/adm_tenancy_haksa_link_list_view"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/admOrgAisLinkListView.do")
	public String acadIntgMng(OrgVO vo, @CurrentUser UserContext userCtx, Model model) {
		String menuType = StringUtil.nvl(userCtx.getAuthrtGrpcd());

		if (!menuType.contains("ADM")) {
			throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
		}

		model.addAttribute("encParams", getEncParams());
		model.addAttribute("vo", vo);

		return "org/adm_tenancy_haksa_link_list_view";
	}

	/**
	 * 기관의 학사연동 정보 목록 조회
	 *
	 * @param vo
	 * @return
	 */
	@GetMapping("/admOrgAisLinkListAjax.do")
	@ResponseBody
	public ProcessResultVO<OrgAisLinkVO> admOrgAcadLinkListAjax(OrgVO vo) {
		ProcessResultVO<OrgAisLinkVO> resultVO = new ProcessResultVO<>();

		List<OrgAisLinkVO> linkList = orgService.orgAisLinkList(vo.getOrgId());

		if (ValidationUtils.isNull(linkList))
			return resultVO.setResultFailed(getMessage("common.no.data.result"));

		resultVO.setReturnList(linkList);
		resultVO.setResultSuccess();

		return resultVO;
	}

	/**
	 * 기관의 학사연동 정보 상세 조회
	 *
	 * @param vo
	 * @return
	 */
	@GetMapping("/admOrgAisLinkDetailAjax.do")
	@ResponseBody
	public ProcessResultVO<OrgAisLinkVO> admOrgAisLinkDetailAjax(OrgAisLinkVO vo) {
		ProcessResultVO<OrgAisLinkVO> resultVO = new ProcessResultVO<>();

		OrgAisLinkVO linkVO = orgService.orgAisLinkInfoSelect(vo.getOrgId(), vo.getAisLinkTycd());
		if (ValidationUtils.isNull(linkVO))
			return resultVO.setResultFailed(getMessage("common.no.data.result"));

		resultVO.setReturnVO(linkVO);
		resultVO.setResultSuccess();

		return resultVO;
	}

	/**
	 * 기관의 LMS 옵션 설정 저장
	 *
	 * @param vo
	 * @param userCtx
	 * @return
	 */
	@PostMapping("/admOrgAisLinkDetailModify.do")
	@ResponseBody
	public ProcessResultVO<EgovMap> admOrgAisLinkDetailModify(OrgAisLinkVO vo, @CurrentUser UserContext userCtx) {
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

		vo.setMdfrId(userCtx.getUserId());

		String msg = getMessage("success.common.save");

		orgService.orgAisLinkModify(vo);
		resultVO.setResultSuccess(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
		return resultVO;
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
    @RequestMapping(value="/admOrgAuthMngListView.do")
    public String sysAuthMain(OrgMenuVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {

        String userTycd = StringUtil.nvl(SessionInfo.getAuthrtCd(request), "SUP");
        String menuTycd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuTycd.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setAuthrtGrpcd("ADM");
        vo.setAuthrtCd(userTycd);
        vo.setParMenuCd(""); //-- 최상위 메뉴
        vo.setOrgId(orgId);

        SysAuthGrpVO sagvo = new SysAuthGrpVO();
        sagvo.setOrgId(orgId);
        sagvo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"ADM")); //-- 홈페이지

        //--홈페이지 권한 목록 가져오기
        List<SysAuthGrpVO> authGrpList = sysMenuService.selectListAuthGrp(sagvo).getReturnList();
        request.setAttribute("authGrpList", authGrpList);

        //--메뉴 리스트 조회
        //ProcessResultListVO<OrgMenuVO> resultList = orgMenuService.listTreeMenu(vo);
        if(StringUtils.isEmpty(vo.getAuthrtCd())) {
            vo.setAuthrtCd(userTycd);
        }

        //request.setAttribute("menuList", resultList.getReturnList());
        request.setAttribute("authGrpCd", vo.getAuthrtCd());
        request.setAttribute("vo", vo);

        EgovMap filterOptions = sysMenuService.loadFilterOptions(userCtx);
		model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "org/adm_auth_mng_list_view";
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
    @RequestMapping(value="/admOrgMenuMngListView.do")
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

        return "org/adm_menu_mng_list_view";
    }
}