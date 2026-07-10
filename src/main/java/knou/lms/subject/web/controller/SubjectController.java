package knou.lms.subject.web.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.PageInfo;
import knou.framework.common.SubjectInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.URLBuilder;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.subject.service.SubjectFacadeService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.subject.web.view.SubjectViewModel;
import knou.lms.user.CurrentUser;

@RequestMapping(value="/subject")
@Controller
public class SubjectController extends ControllerBase {

    private static final Logger log = LoggerFactory.getLogger(SubjectController.class);

    @Resource(name="subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;

    @Resource(name="subjectService")
    private SubjectService subjectService;

    /**
     * 과목화면
     * @param 	SubjectVO
     * @param	userCtx
     * @param	model
     * @return
     * @throws 	Exception
     */
    @RequestMapping(value={"/subject.do"})
    public String subject(SubjectVO svo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {

    	// 공통부분 A 시작
    	String	sbjctId = svo.getSbjctId();
    	//String	userId = userCtx.getLoginUser().getUserId();
    	
    	log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> sbjctId=" + sbjctId);
    	
    	//	필요한가? - 필요하다 LEFT메뉴가 안나온다
    	addEncParam("sbjctId", sbjctId);
    	addEncParam("orgId", userCtx.getLoginUser().getOrgId());
    	    	
    	if ( ! subjectService.isSubjectAuthrt( userCtx, sbjctId) ) {
    		
    		if ( userCtx.isProfessor() )    		
    			return "redirect:" + new URLBuilder("", "dashboard/profDashboard.do",request).toString();
    		else
    			return "redirect:" + new URLBuilder("", "dashboard/stuDashboard.do",request).toString();
    		
    	} else {
    	// 공통부분 A 끝
    		
    		//////////////////////////////////////// 공통부분 B 시작
    		SubjectViewModel subjectVM = subjectService.getSubjectCommonData(userCtx, sbjctId, model);
    		model.addAttribute("subjectVM", subjectVM);
	    	model.addAttribute("userCtx", userCtx);
	    	//////////////////////////////////////// 공통부분 B 끝	    	
	    	
	    	//////////////////////////////////////// 개발자 단위업무 처리 부분 시작	    	
	    	model.addAttribute("contentPage", "/WEB-INF/jsp/subject/prof_classroom.jsp");	    	
	    	////////////////////////////////////////개발자 단위업무 처리 부분 끝
	    	
	    	return subjectVM.getViewName();
    	}
    }

    /**
     * 과목관리자목록조회
     * @param sbjctId
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/sbjctAdmList.do"})
    public String sbjctAdmList(SubjectVO vo, @CurrentUser UserContext userCtx,
    		HttpServletRequest request, ModelMap model) throws Exception {

    	SubjectViewModel subjectVM = new SubjectViewModel();
    	String sbjctId = vo.getSbjctId();
    	
    	SubjectDTO sbjctDto = new SubjectDTO(userCtx);
    	sbjctDto.setSbjctId(sbjctId);

    	if ( null == sbjctId || "".equals(sbjctId)) {
    		log.info(">>>>>>>>>>>>/sbjctAdmList.do>>>>>>>>>>>>>>>>>>>>>>>과목아이디가 없습니다.");
    		return "redirect:" + new URLBuilder("", "dashboard/dashboard.do",request).toString();
    	}

    	// 과목접근권한확인
    	if ( ! subjectService.hasSubjectAuthority( sbjctDto ) ) {
    		log.info(">>>>>>>>>>>>/sbjctAdmList.do>>>>>>>>>>>>>>>>>>>>>>>권한이 없습니다");
    		return "redirect:" + new URLBuilder("", "dashboard/dashboard.do",request).toString();
    	}

    	subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, sbjctId);
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("subjectVM", subjectVM);

    	List<EgovMap> users = subjectService.sbjctAdmList(sbjctDto);

    	model.addAttribute("users", users);
    	model.addAttribute("contentPage", "/WEB-INF/jsp/subject/sbjct_adm_list.jsp");

    	return "subject/prof_layout_classroom";
    }

    /**
     * 과목수업일정목록조회 - 교수와 튜터, 조교, 학생의 일정이 다르다.
     * @param sbjctId
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/sbjctClasSchdlList.do"})
    public String sbjctClasSchdlList(@CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {

    	String sbjctId = request.getParameter("sbjctId");
    	SubjectDTO sbjctDto = new SubjectDTO(userCtx, sbjctId);

    	if ( null == sbjctId || "".equals(sbjctId)) {
    		log.info(">>>>>>>>/sbjctClasSchdlList.do>>>>>>>>>>>>>>>>>>>>>>>>>>>과목아이디가 없습니다.");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}
    	// 과목접근권한확인
    	if ( ! subjectService.hasSubjectAuthority(sbjctDto) ) {
    		log.info(">>>>>>>>/sbjctClasSchdlList.do>>>>>>>>>>>>>>>>>>>>>>>>>>>권한이 없습니다");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}

    	//List<EgovMap> users = subjectService.sbjctAdmList(sbjctId);
    	//model.addAttribute("users", users);

    	//return "subject/sbjct_adm_list";
    	return "";
    }

    /**
     * 강의실 학기목록 조회 Ajax
     *
     * @param vo
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/classSemesterListAjax.do")
    @ResponseBody
    public ProcessResultListVO<SmstrChrtVO> classSemesterListAjax(SubjectVO vo, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultListVO<SmstrChrtVO> resultVO = new ProcessResultListVO<>();
        try {
            List<SmstrChrtVO> classSemesterList = SubjectInfo.getSubjectSemesterList(request, vo.getOrgId());
            resultVO.setReturnList(classSemesterList);
            resultVO.setResult(1);
        } catch(Exception e) {
            log.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /**
     * 강의실 과목목록 조회 Ajax
     *
     * @param vo
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/classSubjectListAjax.do")
    @ResponseBody
    public ProcessResultListVO<SubjectVO> classSubjectListAjax(SubjectVO vo, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultListVO<SubjectVO> resultVO = new ProcessResultListVO<>();
        try {
            List<SubjectVO> classSubjectList = SubjectInfo.getSubjectListBySemester(request, vo.getOrgId(), vo.getSmstrChrtId());
            resultVO.setReturnList(classSubjectList);
            resultVO.setResult(1);
        } catch(Exception e) {
            log.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }
    
    
    @RequestMapping(value={"/admByOrgByDeptSubjectSelect.do", "/byyOrgByDeptSubjectSelect.do"})
	 @ResponseBody
	 public ProcessResultVO<EgovMap> admByOrgByDeptSubjectSelect( PageInfo pageInfo, @CurrentUser UserContext userCtx, 
   		ModelMap model, HttpServletRequest request) throws Exception {
		 return new ProcessResultVO<EgovMap>().setReturnList(subjectService.admByOrgByDeptSubjectSelect(pageInfo)).setResultSuccess();
    }
}