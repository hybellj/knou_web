package knou.lms.system.manage.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.IdGenUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.service.OrgService;
import knou.lms.subject.service.SubjectService;
import knou.lms.system.manage.service.CommonCodeService;
import knou.lms.system.manage.service.SystemManageService;
import knou.lms.system.manage.vo.AdmCntnPermitIpVO;
import knou.lms.system.manage.vo.CommonCodeVO;
import knou.lms.system.manage.vo.SysErrVO;
import knou.lms.system.manage.vo.SysMgrErrVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UsrDeptCdService;

@Controller
@RequestMapping(value = "/system/manage")
public class SystemManageController extends ControllerBase {
	
	private static final Logger log = LoggerFactory.getLogger(SystemManageController.class);
    
    @Resource(name="systemManageService")
    private SystemManageService systemManageService;    
    
    @Resource(name="subjectService")
    private SubjectService subjectService;
    
    @Resource(name="commonCodeService")
    private CommonCodeService commonCodeService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="orgService")
    private OrgService orgService;
    
    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    /***************************************************** 
     * 관리자상위공통코드등록
     * @param 	vo
     * @param	model
     * @param 	request
     * @return 	ProcessResultVO<CommonCodeVO>
     * @throws 	Exception
     ******************************************************/
    @RequestMapping(value = "/admUpCmmnCdRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ResultDTO<EgovMap> admUpCmmnCdRegist(@Valid CommonCodeVO vo, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) {
    	        
        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setRgtrId(userCtx.getLoginUser().getUserId());
        vo.setLangCd(userCtx.getLangCd());
        vo.setCmmnCdId(IdGenUtil.genNewId(IdPrefixType.CMCOD));        
        
        return new ResultDTO<EgovMap>()
                .returnMessage(getMessage("success.common.save"))
                .setResultSuccess()
                .setSuccessCount(commonCodeService.admUpCmmnCdRegist(vo));
    }

    /***************************************************** 
     * 관리자상위공통코드목록페이징
     * @param 	vo
     * @param	model
     * @param 	request
     * @return 	ProcessResultVO<EgovMap>
     ******************************************************/
    @RequestMapping(value="/admUpCmmnCdListPaging.do")
    @ResponseBody
    public ResultDTO<EgovMap> admUpCmmnCdListPaging(PageInfo pageInfo, @CurrentUser UserContext userCtx, 
    		ModelMap model, HttpServletRequest request) throws Exception {    	
    	
    	pageInfo.setOrgId(userCtx.getLoginUser().getOrgId());
    	
        return commonCodeService.admUpCmmnCdListPaging(pageInfo).setResultSuccess();    
    }

    /***************************************************** 
     * 관리자상위공통코드수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CommonCodeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admUpCmmnCdModify.do", method = RequestMethod.POST)
    @ResponseBody
    //public ProcessResultVO<CommonCodeVO> updateSysCmmnUpCd(CommonCodeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    public ProcessResultVO<CommonCodeVO> admUpCmmnCdModify(@Valid CommonCodeVO vo, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {
    	
        ProcessResultVO<CommonCodeVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String mdfrId = SessionInfo.getUserId(request);
        String updtUpCd = vo.getUpdtUpCd();
        String upCdnm = vo.getUpCdnm();
        String upCd = vo.getUpCd();
        String cmmnCdId = vo.getCmmnCdId();
        boolean isUpCdModify = true;

        vo.setOrgId(orgId);
        vo.setMdfrId(mdfrId);
        vo.setUpdtUpCd(updtUpCd);
        vo.setUpCdnm(upCdnm);
        vo.setUpCd(upCd);
        vo.setCmmnCdId(cmmnCdId);
        vo.setIsUpCdModify(isUpCdModify);
        try {
        	commonCodeService.admUpCmmnCdModify(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /***************************************************** 
     * 관리자상위코드삭제
     * @param 	vo
     * @param 	model
     * @param 	request
     * @return 	ProcessResultVO<CommonCodeVO>
     * @throws 	Exception
     ******************************************************/
    @RequestMapping(value = "/admUpCmmnCdDelete.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<CommonCodeVO> admUpCmmnCdDelete(@Valid CommonCodeVO vo, @CurrentUser UserContext userCtx, 
    		ModelMap model, HttpServletRequest request){
    	
        ProcessResultVO<CommonCodeVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String upCd = vo.getUpCd();
        boolean isUpCdDelete = true;

        vo.setOrgId(orgId);
        vo.setUpCd(upCd);
        vo.setIsUpCdDelete(isUpCdDelete);
        try {            
        	commonCodeService.admUpCmmnCdDelete(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /***************************************************** 
     * 관리자공통코드등록
     * @param 	vo
     * @param 	model
     * @param 	request
     * @return 	ProcessResultVO<CommonCodeVO>
     * @throws 	Exception
     ******************************************************/
    @RequestMapping(value = "/admCmmnCdRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<EgovMap> admCmmnCdRegist(@Valid CommonCodeVO vo, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) {    

        vo.setOrgId(userCtx.getLoginUser().getOrgId());
        vo.setRgtrId(userCtx.getLoginUser().getUserId());
        vo.setLangCd(userCtx.getLangCd());
        vo.setCmmnCdId(IdGenUtil.genNewId(IdPrefixType.CMCOD));
        
        return new ProcessResultVO<EgovMap>()
                .returnMessage(getMessage("success.common.save"))
                .setResultSuccess()
                .setSuccessCount(commonCodeService.admCmmnCdRegist(vo));
    }

    /*****************************************************
     *	관리자공통코드목록조회페이징
     * @param 	vo
     * @param 	model
     * @param 	request
     * @return 	ProcessResultVO<EgovMap>
     ******************************************************/
    @RequestMapping(value="/admCmmnCdListPaging.do") 
    @ResponseBody
    public ResultDTO<EgovMap> admCmmnCdListPaging(PageInfo pageInfo, @CurrentUser UserContext userCtx
    		, ModelMap model, HttpServletRequest request) throws Exception {    	
        
        pageInfo.setOrgId(userCtx.getLoginUser().getOrgId());
        
        ResultDTO<EgovMap> resultDto = commonCodeService.admCmmnCdListPaging(pageInfo);
        
        resultDto.setResultSuccess().setEncParams(getEncParams());
        
    	//model.addAttribute("vo", vo); 
    	
        return resultDto;    
    }

    /***************************************************** 
     * 관리자공통코드수정
     * @param 	vo
     * @param 	model
     * @param 	request
     * @return 	ProcessResultVO<CommonCodeVO>
     * @throws 	Exception
     ******************************************************/
    @RequestMapping(value = "/admCmmnCdModify.do")
    @ResponseBody
    //public ProcessResultVO<CommonCodeVO> updateSysCmmnCd(@Valid CommonCodeVO vo, @CurrentUser UserContext userCtx,
    public ProcessResultVO<EgovMap> admCmmnCdModify(@Valid CommonCodeVO vo, @CurrentUser UserContext userCtx,    	    
    			ModelMap model, HttpServletRequest request){
    	
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String mdfrId = SessionInfo.getUserId(request);
        boolean isUpCdModify = false;
        String cd = vo.getCd();
        String cdnm = vo.getCdnm();
        int cdSeqno = vo.getCdSeqno();
        String useyn = vo.getUseyn();
        String upCd = vo.getUpCd();
        String cmmnCdId = vo.getCmmnCdId();

        vo.setOrgId(orgId);
        vo.setMdfrId(mdfrId);
        vo.setIsUpCdModify(isUpCdModify);
        vo.setCd(cd);
        vo.setCdnm(cdnm);
        vo.setCdSeqno(cdSeqno);
        vo.setUseyn(useyn);
        vo.setUpCd(upCd);
        vo.setCmmnCdId(cmmnCdId);
        try {           
        	commonCodeService.admCmmnCdModify(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }    

    /***************************************************** 
     *	관리자공통코드삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<CommonCodeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admCmmnCdDelete.do")
    @ResponseBody
    public ProcessResultVO<CommonCodeVO> admCmmnCdDelete(CommonCodeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CommonCodeVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        boolean isUpCdDelete = false;
        String cmmnCdId = vo.getCmmnCdId();

        vo.setOrgId(orgId);
        vo.setIsUpCdDelete(isUpCdDelete);
        vo.setCmmnCdId(cmmnCdId);
        try {
        	commonCodeService.admCmmnCdDelete(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }    
    
    /***************************************************** 
     * 시스템 관리 > 공통코드 관리 페이지 이동
     * @param vo
     * @param model
     * @param request
     * @return "sys/cmmn/cd_mng_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/admCmmnCode.do")
    public String sysCmmnCdForm(CommonCodeVO vo, ModelMap model ) {
        return "system/manage/cmmn_code_list";
    }
    
    /***************************************************** 
     * 관리자접속허용아이피목록화면
     * @param 	model
     * @param 	request
     * @return 	String
     ******************************************************/
    @RequestMapping(value = "/admCntnPermitIpListView.do")
    public String admCntnPermitIpListView(PageInfo pageInfo, ModelMap model) {
    	model.addAttribute("orgList", 		orgService.orgListSelect() ); 
//        model.addAttribute("deptList", 		usrDeptCdService.admByOrgDeptList(pageInfo) ) ;
    	return "system/manage/admin_cntn_permit_ip_list";
    }
    
    /***************************************************** 
     * 관리자접속허용아이피목록조회
     * @param 	model
     * @param 	request
     * @return 	ProcessResultVO<EgovMap>
     ******************************************************/
    @RequestMapping(value = "/admCntnPermitIpListPaging.do")
    @ResponseBody
    public ResultDTO<EgovMap> admCntnPermitIpListPaging(PageInfo pageInfo ) {    	
    	return commonCodeService.admCntnPermitIpListPaging(pageInfo).setResultSuccess();
    } 
    
    /***************************************************** 
     * 	관리자오류목록조회화면
     * 	@param 	PageInfo
     * 	@param 	model
     * 	@param 	request
     * 	@return "err_list"
     *	@throws Exception
     ******************************************************/
    @RequestMapping(value="/admExceptionListView.do")
    public String admExceptionListView( PageInfo pageInfo, ModelMap model){
        model.addAttribute("orgList", 		orgService.orgListSelect() ); 							// 	orgService.listActiveOrg()); asis
//        model.addAttribute("deptList", 		usrDeptCdService.admByOrgDeptList(pageInfo) ) ;			// 	deptService.list(pageInfo)); asis
        model.addAttribute("subjectList", 	subjectService.admByOrgByDeptSubjectSelect(pageInfo));	//	new        
        return "system/manage/exception_list";
    }

    /*****************************************************
     * 관리자오류목록조회페이징
     * @param 	vo
     * @param 	model
     * @param 	request
     * @return 	ResultDTO<EgovMap>
     * @throws 	Exception
     ******************************************************/
    @RequestMapping(value="/admExceptionListPaging.do")
    @ResponseBody
    public ResultDTO<EgovMap> admExceptionListPaging( PageInfo pageInfo ) {
        return systemManageService.admExceptionListPaging(pageInfo).setResultSuccess(); 
    }

    /*****************************************************
     * 관리자오류목록조회페이징
     * @param 	vo
     * @return 	ResultDTO<EgovMap>
     ******************************************************/
    @RequestMapping(value="/admExceptionListAjax.do")
    @ResponseBody
    public ResultDTO<SysMgrErrVO> admExceptionListAjax(SysMgrErrVO vo) {
        return new ResultDTO<>(systemManageService.exceptionList(vo)).setResultSuccess();
    }

    /*****************************************************
     * 관리자오류현황상세조회
     * @param vo
     * @param model
     * @param request
     * @return ResultDTO<SysMgrErrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/admExceptionDtl.do")
    @ResponseBody
    public ResultDTO<SysErrVO> admExceptionDtl( SysErrVO vo ) {
        return new ResultDTO<SysErrVO>().setData(systemManageService.admExceptionDtl(vo)).setResultSuccess();
    }

    /*****************************************************
     * 관리자오류현황엑셀다운로드
     * @param 	vo
     * @param 	model
     * @param 	request
     * @return 	"excelView"
     * @throws 	Exception
     ******************************************************/
    @RequestMapping(value="/admExceptionListExcelDown.do")
    public String excelSysErrList( SysMgrErrVO vo, ModelMap model) throws Exception {
        // 1. 시스템 오류 현황 목록 조회
    	List<SysMgrErrVO> list = systemManageService.exceptionList(vo);

        // 2. Excel 데이터 세팅
        // String title = getMessage("bbs.label.viewr_list"); // message-bbs_ko.properties 에 등록된 메시지를 사용함
        String title = "시스템오류현황"; // 이 부분 확인해보고 수정 예정

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", 		title);
        map.put("sheetName", 	title);
        map.put("excelGrid", 	vo.getExcelGrid());
        map.put("list", 		list);
        map.put("ext", 			".xlsx(big)");

        // 3. 현재 날짜 생성
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String currentDate = sdf.format(new Date());

        // 4. Excel 파일 생성 (파일명은 title + 날짜)
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        // 5. 엑셀화 작업
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);

        return "excelView";
    }
}