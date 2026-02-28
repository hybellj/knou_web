package knou.lms.user.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.CommonUtil;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.JsonUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.log.privateinfo.service.PrivateInfoInqService;
import knou.lms.log.privateinfo.vo.PrivateInfoInqVO;
import knou.lms.org.service.OrgCodeMemService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.service.UsrLoginService;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrDeptCdVO;
import knou.lms.user.vo.UsrLoginVO;
import knou.lms.user.vo.UsrUserInfoChgHstyVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
@RequestMapping(value="/user/userMgr")
public class UserMgrController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserMgrController.class);
    
    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;
    
    @Resource(name="usrLoginService")
    private UsrLoginService usrLoginService;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name="privateInfoInqService")
    private PrivateInfoInqService privateInfoInqService;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="orgOrgInfoService")
    private OrgOrgInfoService orgOrgInfoService;
    
    @Resource(name="orgCodeMemService")
    private OrgCodeMemService orgCodeMemService;
    
    /*****************************************************
     * 학과(부서) 관리 페이지
     * @param vo
     * @param model
     * @param request
     * @return "user/mgr/user_dept_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/manageDept.do")
    public String manageDeptForm(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        List<UsrDeptCdVO> deptList = usrDeptCdService.listDept(vo);
        model.addAttribute("deptList", deptList);

        model.addAttribute("vo", vo);
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "user/mgr/user_dept_manage";
    }

    /***************************************************** 
     * 학과(소속) 목록
     * @param vo
     * @param model
     * @param request
     * @return "user/mgr/user_dept_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listDeptPaging.do")
    public String listDeptPaging(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        
        ProcessResultVO<UsrDeptCdVO> resultList = usrDeptCdService.listPaging(vo);
        
        model.addAttribute("resultList", resultList.getReturnList());
        model.addAttribute("pageInfo", resultList.getPageInfo());

        return "user/mgr/user_dept_list";
    }
    
    /***************************************************** 
     * 학과(부서) 목록 가져오기
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deptList.do")
    @ResponseBody
    public ProcessResultVO<UsrDeptCdVO> deptList(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<UsrDeptCdVO> resultVO = new ProcessResultVO<UsrDeptCdVO>();
        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        
        try {
            vo.setOrgId(orgId);
            List<UsrDeptCdVO> deptList = usrDeptCdService.list(vo);
            resultVO.setReturnList(deptList);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학과(부서) 정보 가져오기
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewDept.do")
    @ResponseBody
    public ProcessResultVO<UsrDeptCdVO> viewDept(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<UsrDeptCdVO> resultVO = new ProcessResultVO<UsrDeptCdVO>();

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            vo = usrDeptCdService.select(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학과(부서) 등록
     * @param vo
     * @param model
     * @param request 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insertDept.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> insertDept(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            vo.setRgtrId(userId);
            vo.setOrgId(orgId);
            usrDeptCdService.insert(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("user.message.userdept.add.failed"));/* 학과/부서 등록 실패, 필수 입력 항목 확인 다시 시도 해 주세요. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 학과(부서) 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateDept.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateDept(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setMdfrId(userId);
            usrDeptCdService.update(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("user.message.userdept.edit.failed"));/* 학과/부서 수정 실패, 필수 입력 항목 확인 다시 시도 해 주세요. */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학과(부서) 삭제
     * @param vo
     * @param model
     * @param request 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deleteDept.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> deleteDept(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        try {
            usrDeptCdService.delete(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("user.message.userdept.remove.failed"));/* 학과/부서 삭제 실패, 다시 시도 해 주세요. */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학과/부서 엑셀 다운로드
     * @param vo
     * @param model
     * @param request 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deptExcelDownload.do")
    public String deptExcelDownload(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<UsrDeptCdVO> resultList = usrDeptCdService.list(vo);
        String[] searchValues = { getMessage("user.title.search.values") + " : " + StringUtil.nvl(vo.getSearchValue()) };/* 조회조건 */

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", getMessage("user.title.userdept.list"));/* 학과 목록 */
        map.put("sheetName", getMessage("user.title.userdept.list"));/* 학과 목록 */
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", resultList);
        
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        String name = StringUtil.nvl(getMessage("user.title.userdept.list")+"_" + date.format(today));/* 학과 목록 */
        modelMap.put("outFileName", name);
        
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /*****************************************************
     * 학과(부서) 엑셀 업로드 팝업
     * @param vo
     * @param model
     * @param request
     * @return "user/mgr/popup/dept_excel_upload"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deptExcelUploadPop.do")
    public String deptExcelUploadPop(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        model.addAttribute("vo", vo);

        return "user/mgr/popup/dept_excel_upload";
    }
    
    /***************************************************** 
     * 학과/부서 엑셀 샘플 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deptExcelSampleDownload.do")
    public String deptExcelSampleDownload(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
      
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", getMessage("user.title.userdept.list"));/* 학과 목록 */
        map.put("sheetName", getMessage("user.title.userdept.list"));/* 학과 목록 */
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", null);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        String name = StringUtil.nvl(getMessage("user.title.userdept.add.sample") + date.format(today));/* 학과등록 샘플 */
        modelMap.put("outFileName", name);
      
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 학과(부서) 엑셀 업로드
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deptExcelUpload.do")
    @ResponseBody
    public ProcessResultVO<UsrDeptCdVO> deptExcelUpload(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        
        ProcessResultVO<UsrDeptCdVO> resultVO = new ProcessResultVO<UsrDeptCdVO>();
        
        try {
            //등록된 파일 가져오기
            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(vo.getUploadFiles());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            //등록된 파일 저장 후 가져오기
            fileVO = sysFileService.addFile(fileVO);
            
            //엑셀 읽기위한 정보값 세팅
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 4);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("fileVO", fileVO);
            map.put("searchKey", "excelUpload");
            
            //엑셀 리더
            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<Map<String, Object>> usrDeptlist = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);
            
            //읽어온 값으로 insert
            usrDeptCdService.addExcelManageDept(vo, usrDeptlist);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("user.error.excel.upload"));/* 엑셀 업로드 중 에러가 발생하였습니다. */
            throw e;
        }
        return resultVO;
    }
    
    /*****************************************************
     * 운영자 관리 > 목록 폼
     * @param vo
     * @param model
     * @param request
     * @return "user/mgr/admin_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/manageAdmin.do")
    public String manageAdmin(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
        model.addAttribute("schregGbnCdList", orgCodeService.selectOrgCodeList("SCHREG_GBN_CD"));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "user/mgr/admin_manage";
    }
    
    /***************************************************** 
     * 운영자 관리 > 엑셀 다운로드
     * @param UsrUserInfoVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/adminExcelDownload.do")
    public String adminExcelDownload(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        vo.setPagingYn("N");
        
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<UsrUserInfoVO> list = usrUserInfoService.listUserByMenuType(vo);
        String[] searchValues = {getMessage("common.label.search.option") + " : " + StringUtil.nvl(vo.getSearchValue())}; // 조회조건
        String title = getMessage("admin.title.admininfo.list"); // 운영자 목록
        
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
//        map.put("ext", ".xlsx(big)"); // 해당 확장자로 설정 시 에러 발생하여 수정함.
        map.put("ext", ".xlsx");

        HashMap<String, Object> modelMap = new HashMap<>();
        String name = StringUtil.nvl(title + "_" + date.format(today));
        modelMap.put("outFileName", name);
        
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /*****************************************************
     * 운영자 관리 > 상세 정보 페이지
     * @param vo
     * @param model
     * @param request
     * @return "user/mgr/admin_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/viewAdmin.do")
    public String viewAdmin(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        UsrUserInfoVO userInfoVO = usrUserInfoService.viewUser(vo);
        
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("USER_PROFILE");
        fileVO.setFileBindDataSn(vo.getUserId());
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
        
        model.addAttribute("userInfoVO", userInfoVO);
        model.addAttribute("fileList", fileList.getReturnList());
        model.addAttribute("vo", vo);
        
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "user/mgr/admin_view";
    }
    
    /*****************************************************
     * 운영자 관리 > 등록 페이지
     * @param vo
     * @param model
     * @param request
     * @return "user/mgr/admin_regist"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/registAdmin.do")
    public String addAdminForm(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        model.addAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));
        model.addAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
        model.addAttribute("vo", vo);
        
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "user/mgr/admin_regist";
    }
    
    /*****************************************************
     * 사용자 관리 페이지
     * @param vo
     * @param model
     * @param request
     * @return "user/mgr/user_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/manageUser.do")
    public String manageUserForm(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
        model.addAttribute("schregGbnCdList", orgCodeService.selectOrgCodeList("SCHREG_GBN_CD"));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "user/mgr/user_manage";
//        return "user/mgr/user_manage_sample";
    }
    
    /***************************************************** 
    * 사용자 목록 가져오기 페이징
    * @param UsrUserInfoVO 
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/listPagingUser.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> listPagingUser(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {

       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       String menuTypes = vo.getMenuTypes();
       
       try {
           vo.setOrgId(orgId);
           
           if(ValidationUtils.isNotEmpty(menuTypes)) {
               vo.setMenuTypeList(menuTypes.split(","));
           }
           
           resultVO = usrUserInfoService.listPaging(vo);
           resultVO.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       return resultVO;
   }
   
   /*****************************************************
    * 모니터링 과목설정 팝업
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/popup/dept_excel_upload"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/crecrsMonitoringSettingPop.do")
   public String crecrsMonitoringSettingPop(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
       
       if(!menuType.contains("ADM")) {
           throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
       }
       
       TermVO termVO = new TermVO();
       termVO.setOrgId(SessionInfo.getOrgId(request));
       termVO = termService.selectCurrentTerm(termVO);
       request.setAttribute("termVO", termVO);
       request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
       request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
       model.addAttribute("vo", vo);

       return "user/mgr/popup/crecrs_monitoring_setting";
   }
   
   /*****************************************************
    * 권한 그룹 변경 팝업
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/popup/user_auth_change";
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/userAuthChgPop.do")
   public String userAuthChgPop(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
       
       if(!menuType.contains("ADM")) {
           throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
       }
       
       UsrUserInfoVO uuivo = new UsrUserInfoVO();
//       uuivo.setUserId(vo.getUserIds());
       uuivo.setUserId(vo.getUserId());
       uuivo = usrUserInfoService.viewUser(uuivo);
       
       List<OrgCodeVO> userTypeSearchList = orgCodeService.selectOrgCodeList("USER_TYPE");
       List<OrgCodeVO> userTypeList = new ArrayList<>();
       
       // 관리자 권한 설정코드 세팅
       for(OrgCodeVO orgCodeVO : userTypeSearchList) {
           String codeOptn = StringUtil.nvl(orgCodeVO.getCodeOptn());
       
           if("ADM".equals(codeOptn)) {
               userTypeList.add(orgCodeVO);
           }
       }
       
       model.addAttribute("vo", vo);
       model.addAttribute("uuivo", uuivo);
       model.addAttribute("userTypeList", userTypeList);

       return "user/mgr/popup/user_auth_change";
   }
   
   /***************************************************** 
    * 사용자 엑셀 다운로드
    * @param vo
    * @param model
    * @param request
    * @return "excelView"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/userExcelDownload.do")
   public String userExcelDownload(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       vo.setOrgId(orgId);

       vo.setPagingYn("N");
       
       Date today = new Date();
       SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
       
       List<UsrUserInfoVO> list = usrUserInfoService.listUserByMenuType(vo);
       String[] searchValues = {getMessage("common.label.search.option") + " : " + StringUtil.nvl(vo.getSearchValue())}; // 조회조건
       
       HashMap<String, Object> map = new HashMap<>();
       map.put("title", getMessage("user.title.userinfo.list"));/* 사용자 목록 */
       map.put("sheetName", getMessage("user.title.userinfo.list"));/* 사용자 목록 */
       map.put("searchValues", searchValues);
       map.put("excelGrid", vo.getExcelGrid());
       map.put("list", list);
       map.put("ext", ".xlsx(big)");

       HashMap<String, Object> modelMap = new HashMap<>();
       String name = StringUtil.nvl(getMessage("user.title.userinfo.list")+"_" + date.format(today));/* 사용자 목록 */
       modelMap.put("outFileName", name);
       
       ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
       modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
       model.addAllAttributes(modelMap);
       
       return "excelView";
   }
   
   /*****************************************************
    * 사용자 엑셀 업로드 팝업
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/popup/dept_excel_upload"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/userExcelUploadPop.do")
   public String userExcelUploadPop(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {

       String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       StringBuilder sb;
       
       if(!menuType.contains("ADM")) {
           throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
       }
       
       // 등록 가능한 권한 목록
       OrgAuthGrpVO orgAuthGrpVO = new OrgAuthGrpVO();
       orgAuthGrpVO.setOrgId(orgId);
       List<OrgAuthGrpVO> authGrpList = usrUserInfoService.listExcelUploadAuthGrp(orgAuthGrpVO);
       String excelAuthGrpExample = "";
       
       if(orgAuthGrpVO != null) {
           sb = new StringBuilder();
           sb.append("[");
           
           for(int i = 0; i < authGrpList.size(); i++) {
               sb.append(authGrpList.get(i).getAuthrtGrpnm());
               
               if(i != authGrpList.size() - 1) {
                   sb.append(",");
               }
           }
           
           sb.append("]");
           excelAuthGrpExample = sb.toString();
       }
       
       // 학년 목록
       List<OrgCodeVO> userGradeList = orgCodeService.selectOrgCodeList("USER_GRADE");
       String userGradeExample = "";
       
       if(userGradeList != null) {
           sb = new StringBuilder();
           sb.append("[");
           
           for(int i = 0; i < userGradeList.size(); i++) {
               sb.append(userGradeList.get(i).getCdnm());
               
               if(i != userGradeList.size() - 1) {
                   sb.append(",");
               }
           }
           
           sb.append("]");
           userGradeExample = sb.toString();
       }
       
       request.setAttribute("excelAuthGrpExample", excelAuthGrpExample);
       request.setAttribute("userGradeExample", userGradeExample);
       request.setAttribute("isKnou", SessionInfo.isKnou(request));

       return "user/mgr/popup/user_excel_upload";
   }
   
   /***************************************************** 
    * 사용자 관리 엑셀 샘플 다운로드
    * @param vo
    * @param model
    * @param request
    * @return "excelView"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/userExcelSampleDownload.do")
   public String userExcelSampleDownload(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       Date today = new Date();
       SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
     
       HashMap<String, Object> map = new HashMap<String, Object>();

       map.put("title", getMessage("user.title.userinfo.list"));/* 사용자 목록 */
       map.put("sheetName", getMessage("user.title.userinfo.list"));/* 사용자 목록 */
       map.put("excelGrid", vo.getExcelGrid());
       map.put("list", null);
    
       HashMap<String, Object> modelMap = new HashMap<String, Object>();
       String name = StringUtil.nvl(getMessage("user.title.userinfo.list.sample")+"_" + date.format(today));/* 사용자목록 샘플 */
       modelMap.put("outFileName", name);
     
       ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
       modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
       model.addAllAttributes(modelMap);
       
       return "excelView";
   }
   
   /***************************************************** 
    * 사용자 관리 엑셀 업로드
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/userExcelUpload.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> userExcelUpload(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       String userId = StringUtil.nvl(SessionInfo.getUserId(request));
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       vo.setRgtrId(userId);
       vo.setMdfrId(userId);
       vo.setOrgId(orgId);
       
       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
       
       try {
           //등록된 파일 가져오기
           FileVO fileVO = new FileVO();
           fileVO.setUploadFiles(vo.getUploadFiles());
           fileVO.setFilePath(vo.getUploadPath());
           fileVO.setRepoCd(vo.getRepoCd());
           fileVO.setRgtrId(vo.getRgtrId());
           //등록된 파일 저장 후 가져오기
           fileVO = sysFileService.addFile(fileVO);
           
           //엑셀 읽기위한 정보값 세팅
           HashMap<String, Object> map = new HashMap<String, Object>();
           map.put("startRaw", 4);
           map.put("excelGrid", vo.getExcelGrid());
           map.put("fileVO", fileVO);
           map.put("searchKey", "excelUpload");
           
           //엑셀 리더
           ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
           List<Map<String, Object>> userList = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);
           
           //읽어온 값으로 insert
           usrUserInfoService.userExcelUpload(request, vo, userList);
           resultVO.setResult(1);
       } catch (MediopiaDefineException e) {
           resultVO.setResult(-1);
           resultVO.setMessage(e.getMessage());
       } catch (Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getMessage("user.error.excel.upload"));/* 엑셀 업로드 중 에러가 발생하였습니다. */
       }
       return resultVO;
   }
   
   /*****************************************************
    * 사용자 상세 정보 페이지
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/user_manage"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/Form/viewUser.do")
   public String viewUserForm(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       
       if(!menuType.contains("ADM")) {
           throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
       }
       
       vo = usrUserInfoService.viewUser(vo);
       
       if (!SessionInfo.isKnou(request)) {
    	   UsrUserInfoVO userOrg = usrUserInfoService.selectUserOrgRltn(vo);
    	   if (userOrg != null) {
    		   vo.setHycuUserId(userOrg.getHycuUserId());
    		   vo.setHycuUserNm(userOrg.getHycuUserNm());
    	   }
       }
       
       FileVO fileVO = new FileVO();
       fileVO.setRepoCd("USER_PROFILE");
       fileVO.setFileBindDataSn(vo.getUserId());
       ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
       model.addAttribute("fileList", fileList.getReturnList());
       model.addAttribute("vo", vo);
       model.addAttribute("orgId", orgId);
       model.addAttribute("menuType", "ADM");
       model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
       
       return "user/mgr/user_view";
   }
   
   /***************************************************** 
    * 사용자 정보 변경이력 목록 가져오기 페이징
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoChgHstyVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/userInfoChgHstyListPaging.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoChgHstyVO> userInfoChgHstyListPaging(UsrUserInfoChgHstyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       
       ProcessResultVO<UsrUserInfoChgHstyVO> resultVO = new ProcessResultVO<UsrUserInfoChgHstyVO>();
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       
       try {
           vo.setOrgId(orgId);
           resultVO = usrUserInfoService.userChgHstyListPageing(vo);
           List<UsrUserInfoChgHstyVO> hstyList = usrUserInfoService.setChgTargetCode(resultVO.getReturnList(), orgId);
           resultVO.setReturnList(hstyList);
           resultVO.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       return resultVO;
   }
   
   /*****************************************************
    * 사용자 등록 페이지
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/user_write"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/Form/addUser.do")
   public String addUserForm(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       
       if(!menuType.contains("ADM")) {
           throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
       }
       
       UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
       usrDeptCdVO.setOrgId(orgId);
       request.setAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));
       OrgAuthGrpVO orgAuthGrpVO = new OrgAuthGrpVO();
       orgAuthGrpVO.setOrgId(orgId);
       OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();
       model.addAttribute("orgInfoList", orgOrgInfoService.list(orgOrgInfoVO));
       model.addAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
       model.addAttribute("disabilityCdList", orgCodeService.selectOrgCodeList("DISABILITY_CD"));
       model.addAttribute("disabilityLvList", orgCodeService.selectOrgCodeList("DISABILITY_LV"));
       //request.setAttribute("userGradeList", orgCodeService.selectOrgCodeList("USER_GRADE"));
       model.addAttribute("phoneCodeList", orgCodeService.selectOrgCodeList("PHONE_CODE"));
       model.addAttribute("isKnou", SessionInfo.isKnou(request));
       
       model.addAttribute("orgId", orgId);
       model.addAttribute("menuType", "ADM");
       model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
       
       
//       return "user/mgr/user_write";
       return "user/mgr/user_write_sample";
   }
   
   /***************************************************** 
    * 사용자 아이디 중복 체크
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<DefaultVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/joinIdCheck.do")
   @ResponseBody
   public ProcessResultVO<DefaultVO> joinIdCheck(UsrLoginVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       
       ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

       try {
           String isUsable = usrLoginService.userIdCheck(vo);
           resultVO.setMessage(isUsable);
           resultVO.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       return resultVO;
   }
   
   /***************************************************** 
    * 사용자 등록
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/addUser.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> addUser(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       
       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
       String userId = StringUtil.nvl(SessionInfo.getUserId(request));
       
       try {
           vo.setRgtrId(userId);
           vo.setMdfrId(userId);
           
           if(!SessionInfo.isKnou(request)) {
               if(ValidationUtils.isNotEmpty(vo.getUserIdEncpswd())) {
                   vo.setUserIdEncpswd(vo.getUserIdEncpswd() + "hycu!!");
               }
           }
           
           resultVO = usrUserInfoService.addUserInfo(vo, "AI");
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       return resultVO;
   }
   
   /*****************************************************
    * 사용자 수정 페이지
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/user_write"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/Form/editUser.do")
   public String aditUserForm(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       String userId = StringUtil.nvl(SessionInfo.getUserId(request));
       String userNm = StringUtil.nvl(SessionInfo.getUserNm(request));
       
       if(!menuType.contains("ADM")) {
           throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
       }
       
       UsrUserInfoVO userVO = usrUserInfoService.viewUser(vo);
       
       if (!SessionInfo.isKnou(request)) {
    	   UsrUserInfoVO userOrg = usrUserInfoService.selectUserOrgRltn(vo);
    	   if (userOrg != null) {
    		   userVO.setHycuUserId(userOrg.getHycuUserId());
    		   userVO.setHycuUserNm(userOrg.getHycuUserNm());
    	   }
       }
       
       model.addAttribute("userVO", userVO);
       UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
       usrDeptCdVO.setOrgId(orgId);
       model.addAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));
       OrgAuthGrpVO orgAuthGrpVO = new OrgAuthGrpVO();
       orgAuthGrpVO.setOrgId(orgId);
       OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();
       model.addAttribute("orgInfoList", orgOrgInfoService.list(orgOrgInfoVO));
       model.addAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
       model.addAttribute("disabilityCdList", orgCodeService.selectOrgCodeList("DISABILITY_CD"));
       model.addAttribute("disabilityLvList", orgCodeService.selectOrgCodeList("DISABILITY_LV"));
       model.addAttribute("userGradeList", orgCodeService.selectOrgCodeList("USER_GRADE"));
       model.addAttribute("phoneCodeList", orgCodeService.selectOrgCodeList("PHONE_CODE"));
       
       PrivateInfoInqVO pilVO = new PrivateInfoInqVO();
       pilVO.setOrgId(orgId);
       pilVO.setUserId(userId);
       pilVO.setUserNm(userNm);
       pilVO.setMenuCd(StringUtil.nvl(SessionInfo.getMenuCode(request)));
       pilVO.setDivCd("USER_EDIT");
       pilVO.setInqCts(StringUtil.nvl(userVO.getUserId()));
       privateInfoInqService.add(pilVO);
       model.addAttribute("orgId", orgId);
       model.addAttribute("menuType", "ADM");
       model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
       
       return "user/mgr/user_write";
   }
   
   /***************************************************** 
    * 사용자 수정
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/editUser.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> editUser(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();

       String userId = StringUtil.nvl(SessionInfo.getUserId(request));
       String connIp = StringUtil.nvl(CommonUtil.getIpAddress(request));
       
       try {
           vo.setRgtrId(userId);
           vo.setMdfrId(userId);
           resultVO = usrUserInfoService.editUserInfo(vo, "AE", connIp);
           resultVO.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       
       return resultVO;
   }
   
   /***************************************************** 
    * 사용자 탈퇴 처리
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<DefaultVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/withdrawalUser.do")
   @ResponseBody
   public ProcessResultVO<DefaultVO> withdrawalUser(UsrLoginVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

       String userId = StringUtil.nvl(SessionInfo.getUserId(request));
       
       try {
           vo.setMdfrId(userId);
           usrLoginService.WithdrawalUser(vo);
           resultVO.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       return resultVO;
   }
   
   /*****************************************************
    * 학생 검색 팝업
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/popup/student_search_list"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/studentSearchListPop.do")
   public String studentSearchListPop(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       
       OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();
       model.addAttribute("orgInfoList", orgOrgInfoService.list(orgOrgInfoVO));
       UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
       usrDeptCdVO.setOrgId(orgId);
       model.addAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));
       model.addAttribute("userGradeList", orgCodeService.selectOrgCodeList("USER_GRADE"));
       model.addAttribute("vo", vo);
       model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
       
       return "user/mgr/popup/student_search_list";
   }
   
   /***************************************************** 
    * 학생 목록 조회
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/studentList.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> studentList(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
       String userId = StringUtil.nvl(SessionInfo.getUserId(request));

       try {
           vo.setUserId(userId);
           resultVO = usrUserInfoService.listSearchByStudent(vo);
           resultVO.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       return resultVO;
   }
   
   /*****************************************************
    * 교직원 검색 팝업
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/popup/professor_search_list"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/professorSearchListPop.do")
   public String professorSearchListPop(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       request.setAttribute("vo", vo);
       
       return "user/mgr/popup/professor_search_list";
   }
   
   /***************************************************** 
    * 교직원 목록 조회
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/professorList.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> professorList(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
       String orgId = SessionInfo.getOrgId(request);
       
       try {
           vo.setOrgId(orgId);
           resultVO = usrUserInfoService.listSearchByProfessor(vo);
           resultVO.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       return resultVO;
   }

   /***************************************************** 
    * 개설과목관리 > 운영자 리스트에서 사용
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/userList.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> userList(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<>();
       
       String orgId = SessionInfo.getOrgId(request);
       
       try {
           vo.setOrgId(orgId);
           
           String menuTypes = vo.getMenuTypes();
           
           if(ValidationUtils.isNotEmpty(menuTypes)) {
               vo.setMenuTypeList(menuTypes.split(","));
           }
           
           resultVO = usrUserInfoService.listPaging(vo);
           resultVO.setResult(1);
       } catch (Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
       }
       
       return resultVO;
   }
   
   // 학과/부서관리 사용여부
   @RequestMapping(value = "/editUseYn.do")
   public String editUseYn(UsrDeptCdVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
       
       String userId = SessionInfo.getUserId(request);
       vo.setMdfrId(userId);
       
       ProcessResultVO<UsrDeptCdVO> crsVo = new ProcessResultVO<UsrDeptCdVO>();
       int result = 0;
   
       try {
           result = usrUserInfoService.editUseYn(vo);
           crsVo.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           crsVo.setResult(-1);
       }
       return JsonUtil.responseJson(response, crsVo); 
   }
   
   /*****************************************************
    * 관리자 권한변경
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value = "/saveAdminAuthGrp.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> saveAdminAuthGrp(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<>();
       String orgId = SessionInfo.getOrgId(request);
       String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
       String changeUserId = vo.getUserId();
       String authGrpCd = vo.getAuthrtCd();
       
       try {
           if(!menuType.contains("ADM")) {
               throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
           }
           
           if(ValidationUtils.isEmpty(changeUserId)) {
               // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
               throw new BadRequestUrlException(getMessage("common.system.error"));
           }
           UsrUserInfoVO usrUserInfoVO = new UsrUserInfoVO();
           usrUserInfoVO.setOrgId(orgId);
           usrUserInfoVO.setUserId(changeUserId);
           usrUserInfoVO.setAuthrtCd(authGrpCd);
           usrUserInfoVO.setRgtrId(SessionInfo.getUserId(request));
           usrUserInfoVO.setMdfrId(SessionInfo.getUserId(request));
           usrUserInfoService.saveAdminAuthGrp(usrUserInfoVO);
           
           resultVO.setResult(1);
       } catch(MediopiaDefineException | EgovBizException e) {
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
    * 내정보 팝업
    * @param vo
    * @param model
    * @param request
    * @return "user/popup/user_profile_pop"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/userMgrProfilePop.do")
   public String userProfilePop(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       String orgId    = StringUtil.nvl(SessionInfo.getOrgId(request));
       
       vo.setOrgId(orgId);
       vo = usrUserInfoService.viewUser(vo);
       model.addAttribute("phtFile", vo.getPhotoFileId());
       model.addAttribute("vo", vo);
       model.addAttribute("orgId", orgId);

       return "user/popup/user_profile_pop";
   }
   
   /**
    * @Method Name : 재학생 중 대학생 or 학부생 조회
    * @Method 설명 : 법정과목 > 수강생 리스트에서 사용
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    */
   @RequestMapping(value="/listStudentByUniCd.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> listStudentByUniCd(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<>();
       
       String orgId = SessionInfo.getOrgId(request);
       
       try {
           vo.setOrgId(orgId);
           //String userId = StringUtil.nvl(vo.getUserId());
           //vo.setSqlForeach(userId.split(","));
           
           resultVO = usrUserInfoService.listStudentByUniCd(vo);
           resultVO.setResult(1);
       } catch (Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
       }
       
       return resultVO;
   }
   
   /***************************************************** 
    * 메뉴 구분별 사용자 목록 
    * @param vo 
    * @return ProcessResultVO<DefaultVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/listUserByMenuType.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> listUserByMenuType(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<>();
       
       String orgId = SessionInfo.getOrgId(request);
       String pagingYn = StringUtil.nvl(vo.getPagingYn());
       
       try {
           vo.setOrgId(orgId);
           if (!SessionInfo.isKnou(request)) {
        	   vo.setOrgKnouRltn("Y");
           }
           
           if("Y".equals(pagingYn)) {
               resultVO = usrUserInfoService.listPagingUserByMenuType(vo);
           } else {
               List<UsrUserInfoVO> list = usrUserInfoService.listUserByMenuType(vo);
               resultVO.setReturnList(list);
           }
           
           resultVO.setResult(1);
       } catch (Exception e) {
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
       }
       
       return resultVO;
   }
   
   /*****************************************************
    * 한사대계정 연결 팝업
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/popup/hycu_user_select"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/hycuUserSelectPop.do")
   public String hycuUserSelectPop(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
       String orgId    = StringUtil.nvl(SessionInfo.getOrgId(request));
       
       vo.setOrgId(orgId);
       //vo = usrUserInfoService.viewUser(vo);
       model.addAttribute("vo", vo);
       model.addAttribute("orgId", orgId);

       return "user/mgr/popup/hycu_user_select";
   }
   
   /***************************************************** 
    * 한사대 사용자 목록 조회
    * @param vo
    * @param model
    * @param request
    * @return ProcessResultVO<UsrUserInfoVO>
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/hycuUserList.do")
   @ResponseBody
   public ProcessResultVO<UsrUserInfoVO> hycuUserList(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
       
       try {
           vo.setOrgId(CommConst.KNOU_ORG_ID);
           List<UsrUserInfoVO> userList = usrUserInfoService.listSearchByKnouUser(vo);
           resultVO.setReturnList(userList);
           resultVO.setResult(1);
       } catch(Exception e) {
           LOGGER.debug("e: ", e);
           resultVO.setResult(-1);
           resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
       }
       return resultVO;
   }
   
   /*****************************************************
    * 운영자 관리 > 목록 폼
    * @param vo
    * @param model
    * @param request
    * @return "user/mgr/admin_manage"
    * @throws Exception
    ******************************************************/
   @RequestMapping(value="/adminMenuMng.do")
   public String adminMenuMng(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

       String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
       String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
       vo.setOrgId(orgId);

       if(!menuType.contains("ADM")) {
           throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
       }

       model.addAttribute("vo", vo);
       model.addAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
       model.addAttribute("schregGbnCdList", orgCodeService.selectOrgCodeList("SCHREG_GBN_CD"));
       model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

       model.addAttribute("orgId", orgId);
       model.addAttribute("menuType", "ADM");
       model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
       
       return "user/mgr/admin_menu_mng";
   }
}
