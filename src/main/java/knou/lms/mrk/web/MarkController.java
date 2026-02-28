package knou.lms.mrk.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.lms.mrk.facade.MarkFacadeService;
import knou.lms.score.vo.ScoreOverallVO;
import knou.lms.score.web.ScoreOverallController;

@Controller
@RequestMapping("/mrk")
public class MarkController extends ControllerBase {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ScoreOverallController.class);
	
    @Resource(name="markFacadeService")
    private MarkFacadeService markFacadeService;

	/**
	 * 교수 > 대시보드 > 성적관리
	 * 
	 * @return .jsp
	 * @throws Exception
	 */
	@RequestMapping("/profTotalMrkListView.do")
    public String scoreOverallProfMain(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	UserContext userCtx = new UserContext( 	SessionInfo.getOrgId(request),
				SessionInfo.getUserId(request),
				SessionInfo.getAuthrtCd(request),
				SessionInfo.getAuthrtGrpcd(request),
				SessionInfo.getUserRprsId(request),
				SessionInfo.getLastLogin(request));

    	String authrtGrpcd = userCtx.getAuthrtGrpcd();
    	
     // 조회필터옵션 세팅
    	EgovMap filterOptions = markFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("authGrpCd", authrtGrpcd);


        if(!authrtGrpcd.equals("PROF") && !authrtGrpcd.equals("TUT")) {
        	throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        model.addAttribute("TUT_YN", authrtGrpcd.equals("TUT") ? "Y" : "N");
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        model.addAttribute("sUserId", userCtx.getUserId());

        return "mrk/mrk_sbjct_list_view";
    }
	
}
