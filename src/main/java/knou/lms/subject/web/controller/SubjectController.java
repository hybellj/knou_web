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

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.URLBuilder;
import knou.lms.common.dto.BaseParam;
import knou.lms.subject.dto.SubjectParam;
import knou.lms.subject.service.SubjectFacadeService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.LectureWknoScheduleVO;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.subject.web.view.SubjectViewModel;

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
     * @param sbjctId
     * @param userCtx
     * @param model
     * @return
     * @throws Exception
     */
    private SubjectViewModel prepareSubject(HttpServletRequest request, ModelMap model) throws Exception {

        String sbjctId = request.getParameter("sbjctId");
        UserContext userCtx = SessionInfo.getUserContext(request);

        if (userCtx == null) {
            throw new RuntimeException("LOGIN_REQUIRED");
        }

        if (sbjctId == null || sbjctId.isEmpty()) {
            throw new RuntimeException("INVALID_SUBJECT");
        }

        if (!subjectService.hasSubjectAuthority(sbjctId, userCtx)) {
            throw new RuntimeException("NO_AUTH");
        }

        BaseParam param = new SubjectParam(sbjctId, userCtx, 3);
        SubjectViewModel subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, param);

        model.addAttribute("userCtx", userCtx);
        model.addAttribute("subjectVM", subjectVM);

        return subjectVM;
    }

    /**
     * 과목화면
     * @param SubjectVO
     * @param userCtx
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/subject.do"})
    public String subject(SubjectVO svo, HttpServletRequest request, ModelMap model) throws Exception {

    	SubjectViewModel subjectVM = new SubjectViewModel();
    	String sbjctId = request.getParameter("sbjctId");
    	   	
    	try {
    		
    	addEncParam("sbjctId", sbjctId);

    	UserContext userCtx = SessionInfo.getUserContext(request);
    	
    	if ( null == userCtx ) {
    		log.info("세션정보가 없습니다. 로그인페이지로 이동합니다.");
    		return "redirect:" + new URLBuilder("", "loginTOBE.do",request).toString();
    	}

    	if ( null == sbjctId || "".equals(sbjctId)) {
    		log.info("과목아이디가 없습니다.");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}

    	// 과목접근권한확인
    	if ( ! subjectService.hasSubjectAuthority( sbjctId, userCtx ) ) {
    		log.info("권한이 없습니다");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}

    	// 암호화 파라메터 추가
    	//addEncParam("sbjctId", sbjctId);
    	//addEncParam("orgId", vo.getOrgId());

    	LectureWknoScheduleVO lctrWknoSchdlVO = subjectService.currLctrWknoSchdlSelect(sbjctId);
    	model.addAttribute("lctrWknoSchdlVO", lctrWknoSchdlVO);

    	int connectStdCnt = subjectService.connectStdCntSelect(userCtx.getUserId());
    	model.addAttribute("connectStdCnt", connectStdCnt);

    	int sbjctConnectStdCnt = subjectService.subjectConnectStdCntSelect(sbjctId);
    	model.addAttribute("sbjctConnectStdCnt", sbjctConnectStdCnt);

    	int	totalStdCnt = subjectService.totalStdCntSelect(userCtx.getUserId());
    	model.addAttribute("totalStdCnt", totalStdCnt);

    	int	sbjctTotalStdCnt = subjectService.subjectTotalStdCntSelect(sbjctId);
    	model.addAttribute("sbjctTotalStdCnt", sbjctTotalStdCnt);

    	List<EgovMap> stdntSubjectConnectList = subjectService.stdntSubjectConnectList(sbjctId);
    	model.addAttribute("stdntSubjectConnectList", stdntSubjectConnectList);

    	BaseParam param = new SubjectParam(sbjctId, userCtx, 3);

    	subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, param);

    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("subjectVM", subjectVM);

    	model.addAttribute("contentPage", "/WEB-INF/jsp/subject/prof_classroom.jsp");
    	
    	} catch ( Exception e ) {
    		e.printStackTrace();
    	}
    	
    	log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + subjectVM.getViewName());

    	return subjectVM.getViewName();
    }


    /**
     * 과목관리자목록조회
     * @param sbjctId
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/sbjctAdmList.do"})
    public String sbjctAdmList(SubjectVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	SubjectViewModel subjectVM = new SubjectViewModel();
    	String sbjctId = vo.getSbjctId();

    	UserContext userCtx = SessionInfo.getUserContext(request);
    	
    	if ( null == userCtx ) {
    		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>세션정보가 없습니다. 로그인페이지로 이동합니다.");
    		return "redirect:" + new URLBuilder("", "login.do",request).toString();
    	}

    	if ( null == sbjctId || "".equals(sbjctId)) {
    		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>과목아이디가 없습니다.");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}

    	// 과목접근권한확인
    	if ( ! subjectService.hasSubjectAuthority( sbjctId, userCtx ) ) {
    		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>권한이 없습니다");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}

    	BaseParam param = new SubjectParam(sbjctId, userCtx, 3);
    	subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, param);
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("subjectVM", subjectVM);

    	List<EgovMap> users = subjectService.sbjctAdmList(sbjctId);

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
    public String sbjctClasSchdlList(HttpServletRequest request, ModelMap model) throws Exception {
    	
    	String sbjctId = request.getParameter("sbjctId");
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");
    	if ( null == userCtx ) {
    		log.info("세션정보가 없습니다. 로그인페이지로 이동합니다.");
    		return "redirect:" + new URLBuilder("", "login.do",request).toString();
    	}
    	if ( null == sbjctId || "".equals(sbjctId)) {
    		log.info("과목아이디가 없습니다.");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}
    	// 과목접근권한확인
    	if ( ! subjectService.hasSubjectAuthority( sbjctId, userCtx ) ) {
    		log.info("권한이 없습니다");
    		return "redirect:" + new URLBuilder("", "/dashboard/dashboard.do",request).toString();
    	}

    	//List<EgovMap> users = subjectService.sbjctAdmList(sbjctId);
    	//model.addAttribute("users", users);

    	//return "subject/sbjct_adm_list";
    	return "";
    }
}