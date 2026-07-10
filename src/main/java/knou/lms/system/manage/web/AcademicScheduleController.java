package knou.lms.system.manage.web;

import javax.annotation.Resource;
import javax.validation.Valid;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.IdGenUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.service.CommonService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.service.OrgService;
import knou.lms.system.manage.service.AcademicScheduleService;
import knou.lms.system.manage.vo.AcademicScheduleVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/acad/schdl")
public class AcademicScheduleController extends ControllerBase {
	
	@Resource(name="acadSchdlService")
    private AcademicScheduleService acadSchdlService;
	
	@Resource(name="orgService")
    private OrgService orgService;
	
	@Resource(name="commonService")
    private CommonService commonService;	
	
	//학사일정등록화면
	@RequestMapping(value={"/admAcademicScheduleRegistView.do", "/academicScheduleRegistView.do"})
    public String	academicScheduleRegistView(SmstrChrtVO scvo, ModelMap model, @CurrentUser UserContext userCtx) {
		
		//model.addAttribute("yrSmstrList",commonService.yrSmstrSelect(scvo));
		
    	return "system/manage/acad_schdl_regist";    	
    }
	
	//	학사일정등록
	@RequestMapping(value={"/admAcademicScheduleRegist.do"})
	@ResponseBody
    public	ResultDTO<Void>	academicScheduleRegist(@Valid AcademicScheduleVO vo, ModelMap model, @CurrentUser UserContext userCtx) {
		
		vo.setRgtrId(userCtx.getLoginUser().getUserId());
		
		vo.setAcadSchdlId(IdGenUtil.genNewId(IdPrefixType.ORASC));
		
		return new ResultDTO<Void>().setSuccessCount(acadSchdlService.academicScheduleRegist(vo));
    }
	
	//학사일정수정화면
	@RequestMapping(value={"/admAcademicScheduleModifyView.do"})
    public String	academicScheduleModifytView( SmstrChrtVO scvo, AcademicScheduleVO acvo, ModelMap model, @CurrentUser UserContext userCtx) {
		
		//model.addAttribute("yrSmstrList",commonService.yrSmstrSelect(scvo));
		
		acvo = acadSchdlService.academicScheduleSelect(acvo);
		
		model.addAttribute("acvo", acvo);
		
    	return "system/manage/acad_schdl_modify";
    }
	
	//학사일정수정
	@RequestMapping(value={"/admAcademicScheduleModify.do"})
	@ResponseBody
    public	ResultDTO<Void>	academicScheduleModify(@Valid AcademicScheduleVO acvo, ModelMap model , @CurrentUser UserContext userCtx) {
		return new ResultDTO<Void>().setSuccessCount(acadSchdlService.academicScheduleModify(acvo));
    }
	
	//학사일정목록조회화면
    @RequestMapping(value={"/admAcademicScheduleListView.do", "/academicScheduleListView.do"})
    public	String	academicScheduleListView(SmstrChrtVO scvo, PageInfo pageInfo, ModelMap model , @CurrentUser UserContext userCtx) {
    	
    	return "system/manage/acad_schdl_list";
    }	
    
	
    //	학사일정페이징
    @RequestMapping(value={"/admAcademicScheduleListPaging.do", "/academicScheduleListPaging.do"})
    @ResponseBody
    public ResultDTO<EgovMap> academicScheduleListPaging(PageInfo pageInfo, @CurrentUser UserContext userCtx) {  
    	
    	pageInfo.setOrgId(userCtx.getLoginUser().getOrgId());   
    	
    	return acadSchdlService.academicScheduleList(pageInfo).setResultSuccess();
    }
    
    // 학사일정삭제
    @PostMapping(value="/admAcademicScheduleDelete.do")
    @ResponseBody
    public ResultDTO<Void> admAcademicScheduleDelete(String acadSchdlId, @CurrentUser UserContext userCtx) {
    	
    	int successCnt = acadSchdlService.academicScheduleDelete(acadSchdlId);
    	
    	return new ResultDTO<Void>().setSuccessCount(successCnt);
    } 
}