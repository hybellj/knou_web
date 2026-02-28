package knou.lms.file.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.FileMgrService;
import knou.lms.file.vo.CrsSizeMgrVO;
import knou.lms.file.vo.FileSizeMgrVO;
import knou.lms.file.vo.LmsTermVO;
import knou.lms.org.service.OrgCodeMemService;
import knou.lms.org.vo.OrgCodeVO;

@Controller
@RequestMapping(value = "/file/fileMgr")
public class FileMgrController extends ControllerBase {

    @Resource(name="fileMgrService")
    private FileMgrService fileMgrService;

    @Resource(name="orgCodeMemService")
    private OrgCodeMemService orgCodeMemService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    /*****************************************************
     * 파일 용량 관리 메인 화면.
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/fileSizeManage.do")
    public String getFileSizeManageMainView(FileSizeMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        request.setAttribute("vo", vo);
        
        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        return "file/file_size_manage";
    }

    /*****************************************************
     * 권한 그룹별 용량제한 리스트 조회
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return file/auth_size_limit_list
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/authGrpSizeLimitList.do")
    public String getAuthGrpSizeLimitList(FileSizeMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        vo.setRgtrId(userId);
        vo.setOrgId(orgId);
        vo.setLangCd("ko");

        List<FileSizeMgrVO> resultList = fileMgrService.listAuthGrpSizeLimit(vo);
        request.setAttribute("vo", vo);
        request.setAttribute("resultList", resultList);

        return "file/auth_size_limit_list";
    }

    /***************************************************** 
     * 권한 그룹별 용량제한 크기 수정.
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/modify/auth/fileLimitSize.do")
    public String updateAuthGrpSizeLimit(FileSizeMgrVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        vo.setMdfrId(userId);
        vo.setUserOrgId(orgId);

        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        try {
            fileMgrService.updateAuthGrpSizeLimit(vo);
            returnVo.setResultSuccess();
        } catch (Exception e) {
            e.printStackTrace();
            returnVo.setResultFailed();
            returnVo.setMessage(messageSource.getMessage("filemgr.error.update.limit", null, locale));
        }
        return JsonUtil.responseJson(response, returnVo);
    }

    /*****************************************************
     * 사용자별 용량제한 검색화면 호출
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return file/user_size_limit_search
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/userSizeLimitSearch.do")
    public String getUserSizeLimitSearchView(FileSizeMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);
        vo.setRgtrId(userId);
        vo.setUserOrgId(orgId);
        vo.setLangCd(langCd);

        List<OrgCodeVO> userStsList = orgCodeMemService.getOrgCodeList("USER_STS", orgId);
        
        request.setAttribute("userStsList", userStsList);
        request.setAttribute("vo", vo);

        return "file/user_size_limit_search";
    }

    /*****************************************************
     * 사용자별 용량제한 리스트 조회(페이징 적용)
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return file/user_size_limit_list
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/userSizeLimitList.do")
    public String getUserSizeLimitList(FileSizeMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        vo.setRgtrId(userId);
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // default로 관리자를 선택해 준다.
        vo.setAuthGrpCd(StringUtil.nvl(vo.getAuthGrpCd(), "MANAGER"));
        
        ProcessResultListVO<FileSizeMgrVO> resultList = fileMgrService.listUserSizeLimitPageing(vo, vo.getPageIndex(), vo.getListScale(), 5);

        int fileCnt = resultList.getReturnList().size();
        
        request.setAttribute("resultList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());
        request.setAttribute("fileCnt", fileCnt);
        request.setAttribute("vo", vo);

        return "file/user_size_limit_list";
    }

    /*****************************************************
     * 사용자의 제한 용량 변경.
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/modify/user/fileLimitSize.do")
    public String updateUserSizeLimit(FileSizeMgrVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = SessionInfo.getUserId(request);
        vo.setMdfrId(userId);
        
        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        try {
            fileMgrService.updateUserSizeLimit(vo);
            returnVo.setResultSuccess();
        } catch (Exception e) {
            e.printStackTrace();
            returnVo.setResultFailed();
            returnVo.setMessage(messageSource.getMessage("filemgr.error.update.limit", null, locale));
        }

        return JsonUtil.responseJson(response, returnVo);
    }

    /*****************************************************
     * 학기 리스트 조회(AJAX).
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/search/term.do")
    public String searchTerm(LmsTermVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        ProcessResultListVO<LmsTermVO> resultList = new ProcessResultListVO<LmsTermVO>();
        List<LmsTermVO> termList = null;

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        vo.setRgtrId(userId);
        vo.setUserOrgId(orgId);

        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            termList = fileMgrService.listLmsTerm(vo);
            resultList.setReturnList(termList);
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setMessage(messageSource.getMessage("filemgr.error.retrieve.term", null, locale));
            resultList.setResult(-1);
        }
        return JsonUtil.responseJson(response, resultList);
    }

    /*****************************************************
     * 과목별 용량관리 검색화면 호출.
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/crsSizeLimitSearch.do")
    public String getCrsSizeLimitSearchView(CrsSizeMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        vo.setRgtrId(userId);

        // 학기제 > 학기 구분값(정규, 비정규 코드값)
        List<OrgCodeVO> crsOperCdList = orgCodeMemService.getOrgCodeList("TERM_TYPE", orgId);
        request.setAttribute("crsOperCdList", crsOperCdList);
        
    	// 시작년도 가져오기
		String curYear = DateTimeUtil.getYear();
		List<String> yearList = new ArrayList<String>();
		for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2012",10); i--) {
			yearList.add(Integer.toString(i));
		}
		
		// 현재의 년도를 Attribute에 세팅한다.
		request.setAttribute("curYear", curYear);
		request.setAttribute("yearList", yearList);
        
        request.setAttribute("vo", vo);

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        return "file/crs_size_limit_search";
    }

    /*****************************************************
     * 과목별 용량제한 리스트 조회(페이징 적용)
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return file/crs_size_limit_list
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/crsSizeLimitList.do")
    public String getCrsSizeLimitList(CrsSizeMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);
        vo.setRgtrId(userId);
        vo.setUserOrgId(orgId);
        vo.setLangCd(langCd);

        ProcessResultListVO<CrsSizeMgrVO> resultList = fileMgrService.listCrsSizeLimitPageing(vo, vo.getPageIndex(), vo.getListScale(), 5);

        request.setAttribute("resultList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());
        request.setAttribute("vo", vo);

        return "file/crs_size_limit_list";
    }

    /*****************************************************
     * 과목별 제한 용량 변경.
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/modify/crs/fileLimitSize.do")
    public String updateCrsSizeLimit(CrsSizeMgrVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        vo.setMdfrId(userId);
        vo.setUserOrgId(orgId);

        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        try {
            fileMgrService.updateCrsSizeLimit(vo);
            returnVo.setResultSuccess();
        } catch (Exception e) {
            e.printStackTrace();
            returnVo.setResultFailed();
            returnVo.setMessage(messageSource.getMessage("filemgr.error.update.limit", null, locale));
        }

        return JsonUtil.responseJson(response, returnVo);
    }

    /*****************************************************
     * 용량 초기설정 화면 호출.
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/defaultCrsSizeLimitList.do")
    public String getDefaultCrsSizeLimitList(CrsSizeMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);
        vo.setRgtrId(userId);
        vo.setUserOrgId(orgId);
        vo.setLangCd(langCd);

        String limitTypeCd = vo.getLimitTypeCd();
        List<OrgCodeVO> limitTypeCdList = orgCodeMemService.getOrgCodeList("LIMIT_TYPE_CD", orgId);

        vo.setLimitTypeCd("PORTAL");
        List<CrsSizeMgrVO> portalResultList = fileMgrService.listDefaultCrsSizeLimit(vo);

        vo.setLimitTypeCd("CLASS");
        List<CrsSizeMgrVO> classResultList = fileMgrService.listDefaultCrsSizeLimit(vo);

        vo.setLimitTypeCd(StringUtil.nvl(limitTypeCd, limitTypeCdList.get(0).getCd()));

        request.setAttribute("limitTypeCdList", limitTypeCdList);
        request.setAttribute("portalResultList", portalResultList);
        request.setAttribute("classResultList", classResultList);
        request.setAttribute("vo", vo);

        return "file/default_crs_size_limit_list";
    }

    /*****************************************************
     * 과목별 초기 용량 설정 변경
     * 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/modify/crs/defaultFileLimitSize.do")
    public String updateCrsDefaultSizeLimit(CrsSizeMgrVO vo, ModelMap model, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        vo.setMdfrId(userId);
        vo.setUserOrgId(orgId);

        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        try {
            fileMgrService.updateDefaultCrsSizeLimit(vo);
            returnVo.setResultSuccess();
        }  catch (Exception e) {
            e.printStackTrace();
            returnVo.setResultFailed();
            returnVo.setMessage(messageSource.getMessage("filemgr.error.update.limit", null, locale));
        }
        return JsonUtil.responseJson(response, returnVo);
    }

}
