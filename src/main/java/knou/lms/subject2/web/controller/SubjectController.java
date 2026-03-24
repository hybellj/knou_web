package knou.lms.subject2.web.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.util.URLBuilder;
import knou.lms.common.dto.BaseParam;
import knou.lms.subject2.dto.SubjectParam;
import knou.lms.subject2.service.SubjectFacadeService;
import knou.lms.subject2.service.SubjectService;
import knou.lms.subject2.web.view.SubjectViewModel;

@RequestMapping(value="/subject")
@Controller
public class SubjectController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(SubjectController.class);

    @Resource(name="subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;

    @Resource(name="subjectService")
    private SubjectService subjectService;   

    /**
     * 과목화면
     * @param subjectId
     * @param userCtx
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/subject.do"})
    public String subject(HttpServletRequest request, ModelMap model) throws Exception {

    	SubjectViewModel subjectVM = new SubjectViewModel();
    	String subjectId = request.getParameter("subjectId");
    	
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");
    	if ( null == userCtx ) {
    		LOGGER.info("세션정보가 없습니다. 로그인페이지로 이동합니다.");
    		return "redirect:" + new URLBuilder("", "login.do",request).toString();
    	}

    	if ( null == subjectId || "".equals(subjectId)) {
    		LOGGER.info("과목아이디가 없습니다.");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}
    	
    	// 과목접근권한확인
    	if ( ! subjectService.hasSubjectAuthority( subjectId, userCtx ) ) {
    		LOGGER.info("권한이 없습니다");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}
    	

    	BaseParam param = new SubjectParam(subjectId, userCtx, 3);

    	subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, param);

    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("subjectVM", subjectVM);

    	return subjectVM.getViewName();
    }
    
    
    /**
     * 과목관리자목록조회
     * @param subjectI
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/sbjctAdmList.do"})
    public String sbjctAdmList(HttpServletRequest request, ModelMap model) throws Exception {
    	
    	String subjectId = request.getParameter("subjectId");
    	
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");
    	if ( null == userCtx ) {
    		LOGGER.info("세션정보가 없습니다. 로그인페이지로 이동합니다.");
    		return "redirect:" + new URLBuilder("", "login.do",request).toString();
    	}

    	if ( null == subjectId || "".equals(subjectId)) {
    		LOGGER.info("과목아이디가 없습니다.");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}
    	
    	// 과목접근권한확인
    	if ( ! subjectService.hasSubjectAuthority( subjectId, userCtx ) ) {
    		LOGGER.info("권한이 없습니다");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}    	

    	List<EgovMap> users = subjectService.sbjctAdmList(subjectId);

    	model.addAttribute("users", users);

    	return "subject2/sbjct_adm_list";
    }
}