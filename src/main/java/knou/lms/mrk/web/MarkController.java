package knou.lms.mrk.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mrk.service.MarkSubjectService;
import knou.lms.mrk.vo.MarkSubjectDetailVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.lms.mrk.facade.MarkFacadeService;
import knou.lms.score.vo.ScoreOverallVO;
import knou.lms.score.web.ScoreOverallController;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mrk")
public class MarkController extends ControllerBase {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ScoreOverallController.class);
	
    @Resource(name="markFacadeService")
    private MarkFacadeService markFacadeService;

    @Resource(name="markSubjectService")
    private MarkSubjectService markSubjectService;

    /**
	 * 교수 > 대시보드 > 글로벌메뉴 > 성적관리
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

    /**
     * [교수] 과목의 학생 성적 목록 조회
     * @param sbjctId
     * @param searchType
     * @param request
     * @return
     */
    @GetMapping("/profMrkRfltrtSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profMrkListBySbjctAjax (@RequestParam("sbjctId") String sbjctId,
                                                            @RequestParam("searchType") String searchType, HttpServletRequest request){
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            resultVO = markSubjectService.stdMrkList(orgId, sbjctId, searchType);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!

        }

        return resultVO;
    }

    /**
     * [교수]해당 과목의 학생 성적 초기화 (평가점수 가져오기)
     * @param sbjctId
     * @param request
     */
    @PostMapping("/profStdMrkInitAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profStdMrkInitAjax(@RequestParam("sbjctId") String sbjctId, HttpServletRequest request) {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        try{
            markSubjectService.stdMrkInit(orgId, sbjctId, userId);
            resultVO.setResultSuccess();

        }catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * [교수] 과목의 학생 성적 수정
     * @param param
     * @param request
     * @return
     */
    @PostMapping("/profStdMrkModify.do")
	@ResponseBody
    public ProcessResultVO<EgovMap> profStdMrkModify(@RequestBody Map<String, Object> param, HttpServletRequest request) {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        try {
            // unchecked cast 해소
            ObjectMapper mapper = new ObjectMapper();

            String sbjctId = (String) param.get("sbjctId");
            Map<String, Map<String, String>> stdMrkList = mapper.convertValue(
                    param.get("stdMrkList"),
                    new TypeReference<Map<String, Map<String, String>>>() {}
            );

            markSubjectService.stdMrkModify(stdMrkList, orgId, sbjctId, userId);

            resultVO.setResultSuccess();

        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }


        return resultVO;
    }
}
