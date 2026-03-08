package knou.lms.subject2.web.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import knou.lms.subject2.facade.SubjectFacadeService;
import knou.lms.subject2.web.view.SubjectViewModel;

@Controller
public class SubjectController extends ControllerBase {
	
    private static final Logger LOGGER = LoggerFactory.getLogger(SubjectController.class);   
    
    @Resource(name="subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;    

    /**
     * 과목메인화면
     * @param subjectId
     * @param userCtx
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/subject2MainView.do"})
    public String subject2MainView(HttpServletRequest request, ModelMap model) throws Exception {    	
    	
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");    	
    	if ( null == userCtx ) {
    		LOGGER.info("세션정보가 없습니다. 로그인페이지로 이동합니다.");
    		return "redirect:" + new URLBuilder("", "login.do",request).toString();
    	}
    	
    	String subjectId = request.getParameter("subjectId");
    	
    	if ( null == subjectId || "".equals(subjectId)) {
    		LOGGER.info("과목아이디가 없습니다.");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard2.do",request).toString();
    	}
    	
    	BaseParam param = new SubjectParam(userCtx.getOrgId(), userCtx.getUserId(), subjectId, 3);

    	SubjectViewModel subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, param);

    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("subjectVM", subjectVM);

    	return subjectVM.getViewName();
    }    	
}