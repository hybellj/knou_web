package knou.lms.org.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerMapping;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;

@Controller
@RequestMapping(value="/org/orgMgr")
public class OrgMgrController extends ControllerBase {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(OrgMgrController.class);
    
    @Resource(name="orgInfoService")
    private OrgInfoService orgInfoService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    /*****************************************************
     * 소속(테넌시)관리 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "org/org_manage_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/orgManageList.do")
    public String orgManageList(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        model.addAttribute("userType", userType);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/org_info_list";
    }
    
    /*****************************************************
     * 소속(테넌시)관리 페이징 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listPagingOrgManage.do")
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> listPagingOrgManage(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();

        try {
            resultVO = orgInfoService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /*****************************************************
     * 소속(테넌시)관리 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/orgManageExcelDown.do")
    public String orgManageExcelDown(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<OrgInfoVO> resultList = orgInfoService.list(vo);

        String title = getMessage("common.label.org.mgr"); // 소속(테넌시) 관리
        
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
      
        map.put("list", resultList);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
       
        modelMap.put("outFileName", title + "_" + date.format(today));
      
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /*****************************************************
     * 소속(테넌시)관리 상세 폼, 소속(테넌시)정보 폼
     * @param vo
     * @param model
     * @param request
     * @return "org/org_info_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = {"/Form/orgManageDetail.do", "/Form/orgInfo.do"})
    public String orgInfoDetailForm(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String requestUrl = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        
        // 소속(테넌시)정보 메뉴로 들어온경우
        if(requestUrl.indexOf("/Form/orgInfo.do") > -1) {
            vo.setOrgId(SessionInfo.getOrgId(request));
            
            model.addAttribute("menu", "orgInfo");
        }
        
        OrgInfoVO orgInfoVO = orgInfoService.select(vo);
        
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("ORGINFO");
        fileVO.setFileBindDataSn(orgInfoVO.getOrgId());
        
        orgInfoVO.setFileList(sysFileService.list(fileVO).getReturnList());
        
        List<EgovMap> listOrgAdmUser = orgInfoService.listOrgAdmUser(vo);
        
        model.addAttribute("userType", userType);
        model.addAttribute("orgInfoVO", orgInfoVO);
        model.addAttribute("listOrgAdmUser", listOrgAdmUser);
        model.addAttribute("vo", vo);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/org_info_detail";
    }
    
    /*****************************************************
     * 소속(테넌시)관리 등록 폼 (슈퍼관리자)
     * @param vo
     * @param model
     * @param request
     * @return "org/org_info_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/orgManageWrite.do")
    public String orgManageWriteForm(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        // 슈퍼관리자
        if(!(userType.contains("DEV") || userType.contains("ADM") || userType.contains("SUP"))) {
            // 페이지 접근 권한이 없습니다.
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        
        model.addAttribute("vo", vo);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/org_info_write";
    }
    
    /*****************************************************
     * 소속(테넌시)관리 등록 (슈퍼관리자)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insertOrgInfo.do")
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> insertOrgInfo(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();

        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId = SessionInfo.getUserId(request);
        
        try {
            // 슈퍼관리자
            if(!(userType.contains("DEV") || userType.contains("ADM") || userType.contains("SUP"))) {
                // 페이지 접근 권한이 없습니다.
                throw new AccessDeniedException(getCommonNoAuthMessage());
            }
            
            vo.setRgtrId(userId);
            
            orgInfoService.insert(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /*****************************************************
     * 소속(테넌시)관리 수정 폼 (슈퍼관리자, 전체운영자)
     * @param vo
     * @param model
     * @param request
     * @return "org/org_info_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = {"/Form/orgManageEdit.do", "/Form/orgInfoEdit.do"})
    public String orgManageEditForm(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String requestUrl = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        
        // 슈퍼관리자 OR 전체운영자
        if(!(userType.contains("DEV") || userType.contains("ADM") || userType.contains("SUP"))) {
            // 페이지 접근 권한이 없습니다.
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        
        if(!userType.contains("DEV")) {
            //vo.setOrgId(SessionInfo.getOrgId(request));
        }
        
        // 소속(테넌시)정보 메뉴로 들어온경우
        if(requestUrl.indexOf("/Form/orgInfoEdit.do") > -1) {
            vo.setOrgId(SessionInfo.getOrgId(request));
            
            model.addAttribute("menu", "orgInfo");
        }
        
        OrgInfoVO orgInfoVO = orgInfoService.select(vo);
        
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("ORGINFO");
        fileVO.setFileBindDataSn(orgInfoVO.getOrgId());
        
        orgInfoVO.setFileList(sysFileService.list(fileVO).getReturnList());
        
        model.addAttribute("orgInfoVO", orgInfoVO);
        model.addAttribute("vo", vo);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/org_info_write";
    }
    
    /*****************************************************
     * 소속(테넌시)관리 수정  (슈퍼관리자, 전체운영자)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateOrgInfo.do")
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> updateOrgInfo(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();

        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId = SessionInfo.getUserId(request);
        
        try {
            // 슈퍼관리자 OR 전체운영자
            if(!(userType.contains("DEV") || userType.contains("ADM") || userType.contains("SUP"))) {
                // 페이지 접근 권한이 없습니다.
                throw new AccessDeniedException(getCommonNoAuthMessage());
            }
            
            vo.setMdfrId(userId);
            
            orgInfoService.update(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /*****************************************************
     * 소속(테넌시)관리  사용안함 (슈퍼관리자)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateUseN.do")
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> updateUseN(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();
        
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        try {
            // 슈퍼관리자
            if(!(userType.contains("DEV") || userType.contains("ADM") || userType.contains("SUP"))) {
                // 페이지 접근 권한이 없습니다.
                throw new AccessDeniedException(getCommonNoAuthMessage());
            }
            
            orgInfoService.updateUseN(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    

    /*****************************************************
     * 디자인 컬러 설정 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "org/org_manage_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/dsgnClrStng.do")
    public String dsgnClrStng(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        model.addAttribute("userType", userType);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/dsgn_clr_stng";
    }
    
    /*****************************************************
     * 대시보드 위젯 설정 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "org/org_manage_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/dashWgtStng.do")
    public String dashWgtStng(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        model.addAttribute("userType", userType);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/dash_wgt_stng";
    }
    
    /*****************************************************
     * 강의실 메뉴 설정 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "org/org_manage_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/clsMenuStng.do")
    public String clsMenuStng(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        model.addAttribute("userType", userType);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/cls_menu_stng";
    }
    
    /*****************************************************
     * LMS 옵션 설정 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "org/org_manage_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lmsOptStng.do")
    public String lmsOptStng(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        model.addAttribute("userType", userType);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/lms_opt_stng";
    }
    
    /*****************************************************
     * 학사 연동 관리 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "org/org_manage_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/acadIntgMng.do")
    public String acadIntgMng(OrgInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        model.addAttribute("userType", userType);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "org/acad_intg_mng";
    }
}