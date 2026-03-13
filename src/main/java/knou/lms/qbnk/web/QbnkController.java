package knou.lms.qbnk.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.qbnk.facade.QbnkFacadeService;
import knou.lms.qbnk.service.QbnkCtgrService;
import knou.lms.qbnk.service.QbnkQstnService;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.web.view.QbnkMainView;

@Controller
@RequestMapping(value="/qbnk")
public class QbnkController extends ControllerBase {

	@Resource(name="qbnkFacadeService")
	private QbnkFacadeService qbnkFacadeService;

	@Resource(name="qbnkCtgrService")
	private QbnkCtgrService qbnkCtgrService;

	@Resource(name="qbnkQstnService")
	private QbnkQstnService qbnkQstnService;

	/**
     * 교수문제은행목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_qbnk_list_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQbnkListView.do")
    public String profQbnkListView(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String userRprsId = StringUtil.nvl(SessionInfo.getUserRprsId(request));
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
    	if("".equals(vo.getSbjctId())) vo.setSbjctId("SBJCT_OFRNG_ID1");

    	vo.setUserRprsId(userRprsId);
    	vo.setUserId(userId);
    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkListView(vo);
    	model.addAttribute("upQbnkCtgrList", qbnkMainView.getUpQbnkCtgrList());
    	model.addAttribute("qbnkSearchSbjctList", qbnkMainView.getQbnkSearchSbjctList());
    	model.addAttribute("qbnkSearchProfList", qbnkMainView.getQbnkSearchProfList());

    	model.addAttribute("vo", vo);
        model.addAttribute("menuTycd", "PROF");

        return "qbnk/prof_qbnk_list_view";
    }

	/**
	* 교수문제은행분류목록조회
	*
	* @param sbjctId 		과목아이디
	* @param upQbnkCtgrId 	상위문제은행분류아이디
	* @return 문제은행분류 목록
	* @throws Exception
	*/
    @RequestMapping(value="/profQbnkCtgrListAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkCtgrVO> profQbnkCtgrListAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String userRprsId = StringUtil.nvl(SessionInfo.getUserRprsId(request));
        ProcessResultVO<QbnkCtgrVO> resultVO = new ProcessResultVO<QbnkCtgrVO>();

        try {
        	vo.setUserRprsId(userRprsId);
            List<QbnkCtgrVO> qbnkList = qbnkCtgrService.profQbnkCtgrList(vo);
            resultVO.setReturnList(qbnkList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /**
     * 교수문제은행문항목록조회
     *
     * @param upQbnkCtgrId 	상위문제은행분류아이디
     * @param qbnkCtgrId 	문제은행분류아이디
     * @param sbjctId 		과목아이디
     * @param userRprsId 	사용자대표아이디
     * @param searchValue 	검색어(문항제목)
     * @return 문제은행문항 목록
     * @throws Exception
     */
    @RequestMapping(value="/profQbnkQstnListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profQbnkQstnListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = qbnkQstnService.qbnkQstnList(params);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수문제은행문제보기팝업
     *
     * @param qbnkQstnId 문제은행문항아이디
     * @return prof_qbnk_qstn_view_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQbnkQstnViewPopup.do")
    public String profBfrQuizCopyPopup(QbnkQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkQstnViewPopup(vo);
    	model.addAttribute("qbnkQstnVO", qbnkMainView.getQbnkQstnVO());

        return "qbnk/popup/prof_qbnk_qstn_view_pop";
    }

    /**
     * 교수문제은행문항등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_qbnk_qstn_regist_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQbnkQstnRegistView.do")
    public String profQbnkQstnRegistView(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));
        request.getSession().setAttribute("USER_CONTEXT", userCtx);

    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkQstnRegistView(vo, userCtx);
    	model.addAttribute("qbnkSbjct", qbnkMainView.getQbnkSbjct());
    	model.addAttribute("upQbnkCtgrList", qbnkMainView.getUpQbnkCtgrList());
    	model.addAttribute("qstnRspnsTycdList", qbnkMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", qbnkMainView.getCmmnCdList().get("qstnDfctlvTycd"));

        model.addAttribute("menuTycd", "PROF");

        return "qbnk/prof_qbnk_qstn_regist_view";
    }

    /**
     * 문제은행문항등록
     *
     * @param QbnkQstnVO 문항 정보
     * @return ProcessResultVO<QbnkQstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/qbnkQstnRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkQstnVO> qbnkQstnRegistAjax(QbnkQstnVO vo, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<QbnkQstnVO> resultVO = new ProcessResultVO<QbnkQstnVO>();
        ObjectMapper mapper = new ObjectMapper();

        try {
            vo.setRgtrId(userId);
            vo.setQstns(mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {
            }));
            qbnkQstnService.qbnkQstnRegist(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 등록 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수문제은행문항수정화면
     *
     * @param sbjctId 과목아이디
     * @return prof_qbnk_qstn_regist_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQbnkQstnModifyView.do")
    public String profQbnkQstnModifyView(QbnkQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));
        request.getSession().setAttribute("USER_CONTEXT", userCtx);

    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkQstnModifyView(vo, userCtx);
    	model.addAttribute("qbnkSbjct", qbnkMainView.getQbnkSbjct());
    	model.addAttribute("qbnkQstnVO", qbnkMainView.getQbnkQstnVO());
    	ObjectMapper mapper = new ObjectMapper();
    	model.addAttribute("qbnkQstnVwitmList", mapper.writeValueAsString(qbnkMainView.getQbnkQstnVwitmList()));
    	model.addAttribute("upQbnkCtgrList", qbnkMainView.getUpQbnkCtgrList());
    	model.addAttribute("qstnRspnsTycdList", qbnkMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", qbnkMainView.getCmmnCdList().get("qstnDfctlvTycd"));

        model.addAttribute("menuTycd", "PROF");

        return "qbnk/prof_qbnk_qstn_regist_view";
    }

    /**
     * 문제은행문항수정
     *
     * @param QbnkQstnVO 문항 정보
     * @return ProcessResultVO<QbnkQstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/qbnkQstnModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkQstnVO> qbnkQstnModifyAjax(QbnkQstnVO vo, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<QbnkQstnVO> resultVO = new ProcessResultVO<QbnkQstnVO>();
        ObjectMapper mapper = new ObjectMapper();

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setQstns(mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {
            }));
            qbnkQstnService.qbnkQstnModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 문제은행문항삭제
     *
     * @param QbnkQstnVO 문항 정보
     * @return ProcessResultVO<QbnkQstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/qbnkQstnDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkQstnVO> qbnkQstnDeleteAjax(QbnkQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<QbnkQstnVO> resultVO = new ProcessResultVO<QbnkQstnVO>();

        try {
        	vo.setMdfrId(userId);
            qbnkQstnService.qbnkQstnDelete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 삭제 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수문제은행분류관리화면
     *
     * @param sbjctId 과목아이디
     * @return prof_qbnk_ctgr_mng_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQbnkCtgrMngView.do")
    public String profQbnkCtgrMngView(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String userRprsId = StringUtil.nvl(SessionInfo.getUserRprsId(request));
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));

    	vo.setUserRprsId(userRprsId);
    	vo.setUserId(userId);
    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkCtgrMngView(vo);
    	model.addAttribute("qbnkSbjct", qbnkMainView.getQbnkSbjct());
    	model.addAttribute("upQbnkCtgrList", qbnkMainView.getUpQbnkCtgrList());
    	model.addAttribute("qbnkSearchSbjctList", qbnkMainView.getQbnkSearchSbjctList());
    	model.addAttribute("qbnkSearchProfList", qbnkMainView.getQbnkSearchProfList());

    	model.addAttribute("vo", vo);
        model.addAttribute("menuTycd", "PROF");

        return "qbnk/prof_qbnk_ctgr_mng_view";
    }

    /**
     * 교수문제은행분류전체목록조회
     *
     * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * @param sbjctId 		과목아이디
	 * @param userRprsId 	사용자대표아이디
	 * @param searchValue 	검색어(분류명, 과목, 담당교수)
     * @return 문제은행문항 목록
     * @throws Exception
     */
    @RequestMapping(value="/profQbnkCtgrAllListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profQbnkCtgrAllListAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = qbnkCtgrService.profQbnkCtgrAllList(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 문제은행다음분류순번조회
     *
     * @param userRprsId 		사용자대표아이디
	 * @param upQbnkCtgrId 		상위문제은행분류아이디
     * @return 문제은행다음분류순번
     * @throws Exception
     */
    @RequestMapping(value="/qbnkNextCtgrSeqnoSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkCtgrVO> qbnkNextCtgrSeqnoSelectAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<QbnkCtgrVO> resultVO = new ProcessResultVO<QbnkCtgrVO>();

        try {
            resultVO.setResult(qbnkCtgrService.qbnkNextCtgrSeqnoSelect(vo));
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 문제은행분류등록
     *
     * @param ExamBscVO 퀴즈 정보
     * @return ProcessResultVO<QbnkCtgrVO>
     * @throws Exception
     */
    @RequestMapping(value="/qbnkCtgrRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkCtgrVO> qbnkCtgrRegistAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<QbnkCtgrVO> resultVO = new ProcessResultVO<QbnkCtgrVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setRgtrId(userId);

            qbnkCtgrService.qbnkCtgrRegist(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("저장 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 문제은행분류조회
     *
	 * @param qbnkCtgrId 		문제은행분류아이디
     * @return 문제은행분류 정보
     * @throws Exception
     */
    @RequestMapping(value="/qbnkCtgrSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkCtgrVO> qbnkCtgrSelectAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<QbnkCtgrVO> resultVO = new ProcessResultVO<QbnkCtgrVO>();

        try {
        	resultVO.setReturnVO(qbnkCtgrService.qbnkCtgrSelect(vo.getQbnkCtgrId()));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 문제은행분류사용수조회
     *
	 * @param qbnkCtgrId 		문제은행분류아이디
     * @return 문제은행분류사용수
     * @throws Exception
     */
    @RequestMapping(value="/qbnkCtgrUseCntSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> qbnkCtgrUseCntSelectAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	resultVO.setReturnVO(qbnkCtgrService.qbnkCtgrUseCntSelect(vo.getQbnkCtgrId()));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 문제은행분류삭제
     *
     * @param qbnkCtgrId   문제은행분류아이디
     * @return ProcessResultVO<QbnkCtgrVO>
     * @throws Exception
     */
    @RequestMapping(value="/qbnkCtgrDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkCtgrVO> qbnkCtgrDeleteAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<QbnkCtgrVO> resultVO = new ProcessResultVO<QbnkCtgrVO>();

        try {
            vo.setMdfrId(userId);
            qbnkCtgrService.qbnkCtgrDelete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("삭제 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 교수문항복사문제은행문항목록조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항목록
     * @throws Exception
     */
    @RequestMapping(value="/profQstnCopyQbnkQstnListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

    	ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

    	try {
    		List<EgovMap> qbnkQstnList = qbnkQstnService.profQstnCopyQbnkQstnList(vo);
    		resultVO.setReturnList(qbnkQstnList);
    		resultVO.setResult(1);
    	} catch(Exception e) {
    		resultVO.setResult(-1);
    		resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
    	}
    	return resultVO;
    }

}
