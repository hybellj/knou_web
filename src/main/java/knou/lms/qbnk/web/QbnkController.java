package knou.lms.qbnk.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.qbnk.facade.QbnkFacadeService;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.web.view.QbnkMainView;
import knou.lms.qbnk.web.view.QbnkPageInfo;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value="/qbnk")
public class QbnkController extends ControllerBase {

	@Resource(name="qbnkFacadeService")
	private QbnkFacadeService qbnkFacadeService;

	/**
     * 교수문제은행목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_qbnk_list_view.jsp
     */
    @RequestMapping(value="/profQbnkListView.do")
    public String profQbnkListView(QbnkCtgrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkListView(vo);
    	model.addAttribute("qbnkSbjct", qbnkMainView.getEgovMap());
    	model.addAttribute("upQbnkCtgrList", qbnkMainView.getQbnkCtgrList());
    	model.addAttribute("sbjctList", qbnkMainView.getEgovListMap().get("sbjctList"));
    	model.addAttribute("profList", qbnkMainView.getEgovListMap().get("profList"));
    	model.addAttribute("vo", vo);

        return "qbnk/prof_qbnk_list_view";
    }

	/**
	* 문제은행분류목록조회
	*
	* @param sbjctId 		과목아이디
	* @param upQbnkCtgrId 	상위문제은행분류아이디
	* @return 문제은행분류 목록
	*/
    @RequestMapping(value={"/profQbnkCtgrListAjax.do", "/admQbnkCtgrListAjax.do"})
    @ResponseBody
    public ResultDTO<QbnkCtgrVO> profQbnkCtgrListAjax(QbnkCtgrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<QbnkCtgrVO>().setReturnList(qbnkFacadeService.getProfQbnkCtgrList(vo).getQbnkCtgrList()).setResultSuccess();
    }

    /**
     * 교수문제은행문항목록조회
     *
     * @param upQbnkCtgrId 		상위문제은행분류아이디
     * @param qbnkCtgrId 		문제은행분류아이디
     * @param sbjctId 			과목아이디
     * @param userId	 		사용자아이디
     * @param searchValue 		검색어(문항제목)
     * @param searchKey 		검색키(현재 과목아이디)
     * @return 문제은행문항 목록
     */
    @RequestMapping(value="/profQbnkQstnListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profQbnkQstnListAjax(QbnkPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return qbnkFacadeService.getProfQbnkQstnList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 교수문제은행문제보기팝업
     *
     * @param qbnkQstnId 문제은행문항아이디
     * @return prof_qbnk_qstn_view_pop.jsp
     */
    @RequestMapping(value="/profQbnkQstnViewPopup.do")
    public String profBfrQuizCopyPopup(QbnkQstnVO vo, ModelMap model, HttpServletRequest request) {
    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkQstnViewPopup(vo);
    	model.addAttribute("qbnkQstnVO", qbnkMainView.getEgovMap());
    	model.addAttribute("qbnkQstnVwitmList", qbnkMainView.getQbnkQstnVwitmList());

        return "qbnk/popup/prof_qbnk_qstn_view_pop";
    }

    /**
     * 교수문제은행문항등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_qbnk_qstn_regist_view.jsp
     */
    @RequestMapping(value="/profQbnkQstnRegistView.do")
    public String profQbnkQstnRegistView(QbnkCtgrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkQstnRegistView(vo, userCtx);
    	vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));	// 첨부파일저장소 설정
        model.addAttribute("vo", vo);
    	model.addAttribute("qbnkSbjct", qbnkMainView.getEgovMap());
    	model.addAttribute("upQbnkCtgrList", qbnkMainView.getQbnkCtgrList());
    	model.addAttribute("qstnRspnsTycdList", qbnkMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", qbnkMainView.getCmmnCdList().get("qstnDfctlvTycd"));

        return "qbnk/prof_qbnk_qstn_regist_view";
    }

    /**
     * 문제은행문항등록
     *
     * @param QbnkQstnVO 문항 정보
     */
    @RequestMapping(value="/qbnkQstnRegistAjax.do")
    @ResponseBody
    public ResultDTO<QbnkQstnVO> qbnkQstnRegistAjax(QbnkQstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr) {
        vo.setRgtrId(userCtx.getUserId());
        qbnkFacadeService.qbnkQstnRegist(vo, qstnsStr);

        return new ResultDTO<QbnkQstnVO>().setResultSuccess();
    }

    /**
     * 교수문제은행문항수정화면
     *
     * @param sbjctId 과목아이디
     * @return prof_qbnk_qstn_regist_view.jsp
     */
    @RequestMapping(value="/profQbnkQstnModifyView.do")
    public String profQbnkQstnModifyView(QbnkQstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkQstnModifyView(vo, userCtx);
    	vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, qbnkMainView.geteMap().get("qbnkQstnVO").get("qbnkQstnId").toString()));	// 첨부파일저장소 설정
        model.addAttribute("vo", vo);
    	model.addAttribute("qbnkSbjct", qbnkMainView.geteMap().get("qbnkSbjct"));
    	model.addAttribute("qbnkQstnVO", qbnkMainView.geteMap().get("qbnkQstnVO"));
    	model.addAttribute("qbnkQstnVwitmList", qbnkMainView.getQbnkQstnVwitmList());
    	model.addAttribute("upQbnkCtgrList", qbnkMainView.getQbnkCtgrList());
    	model.addAttribute("qstnRspnsTycdList", qbnkMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", qbnkMainView.getCmmnCdList().get("qstnDfctlvTycd"));

        return "qbnk/prof_qbnk_qstn_regist_view";
    }

    /**
     * 문제은행문항수정
     *
     * @param QbnkQstnVO 문항 정보
     */
    @RequestMapping(value="/qbnkQstnModifyAjax.do")
    @ResponseBody
    public ResultDTO<QbnkQstnVO> qbnkQstnModifyAjax(QbnkQstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        qbnkFacadeService.qbnkQstnModify(vo, qstnsStr);

        return new ResultDTO<QbnkQstnVO>().setResultSuccess();
    }

    /**
     * 문제은행문항삭제
     *
     * @param QbnkQstnVO 문항 정보
     */
    @RequestMapping(value="/qbnkQstnDeleteAjax.do")
    @ResponseBody
    public ResultDTO<QbnkQstnVO> qbnkQstnDeleteAjax(QbnkQstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        qbnkFacadeService.qbnkQstnDelete(vo);

        return new ResultDTO<QbnkQstnVO>().setResultSuccess();
    }

    /**
     * 교수문제은행분류관리화면
     *
     * @param sbjctId 과목아이디
     * @return prof_qbnk_ctgr_mng_view.jsp
     */
    @RequestMapping(value="/profQbnkCtgrMngView.do")
    public String profQbnkCtgrMngView(QbnkCtgrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QbnkMainView qbnkMainView = qbnkFacadeService.loadProfQbnkCtgrMngView(vo);
    	model.addAttribute("qbnkSbjct", qbnkMainView.getEgovMap());
    	model.addAttribute("upQbnkCtgrList", qbnkMainView.getQbnkCtgrList());
    	model.addAttribute("sbjctList", qbnkMainView.getEgovListMap().get("sbjctList"));
    	model.addAttribute("profList", qbnkMainView.getEgovListMap().get("profList"));
    	model.addAttribute("vo", vo);

        return "qbnk/prof_qbnk_ctgr_mng_view";
    }

    /**
     * 교수문제은행분류전체목록조회
     *
     * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * @param sbjctId 		과목아이디
	 * @param userId 		사용자아이디
	 * @param searchValue 	검색어(분류명, 과목, 담당교수)
	 * @param searchKey 	검색키(현재 과목아이디)
     * @return 문제은행문항 목록
     */
    @RequestMapping(value="/profQbnkCtgrAllListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profQbnkCtgrAllListAjax(QbnkPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return qbnkFacadeService.getProfQbnkCtgrAllList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 문제은행다음분류순번조회
     *
     * @param userId	 		사용자아이디
	 * @param upQbnkCtgrId 		상위문제은행분류아이디
     * @return 문제은행다음분류순번
     */
    @RequestMapping(value="/qbnkNextCtgrSeqnoSelectAjax.do")
    @ResponseBody
    public ResultDTO<QbnkCtgrVO> qbnkNextCtgrSeqnoSelectAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) {
    	ResultDTO<QbnkCtgrVO> resultVO = new ResultDTO<QbnkCtgrVO>();
        resultVO.setResult(qbnkFacadeService.getQbnkNextCtgrSeqnoSelect(vo));

        return resultVO;
    }

    /**
     * 문제은행분류등록
     *
     * @param QbnkCtgrVO 문제은행분류정보
     */
    @RequestMapping(value="/qbnkCtgrRegistAjax.do")
    @ResponseBody
    public ResultDTO<QbnkCtgrVO> qbnkCtgrRegistAjax(QbnkCtgrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        qbnkFacadeService.qbnkCtgrRegist(vo);

        return new ResultDTO<QbnkCtgrVO>().setResultSuccess();
    }

    /**
     * 문제은행분류조회
     *
	 * @param qbnkCtgrId 		문제은행분류아이디
     * @return 문제은행분류 정보
     */
    @RequestMapping(value="/qbnkCtgrSelectAjax.do")
    @ResponseBody
    public ResultDTO<QbnkCtgrVO> qbnkCtgrSelectAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<QbnkCtgrVO>().setData(qbnkFacadeService.getQbnkCtgrSelect(vo).getQbnkCtgrVO()).setResultSuccess();
    }

    /**
     * 문제은행분류사용수조회
     *
	 * @param qbnkCtgrId 		문제은행분류아이디
     * @return 문제은행분류사용수
     */
    @RequestMapping(value="/qbnkCtgrUseCntSelectAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> qbnkCtgrUseCntSelectAjax(QbnkCtgrVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setData(qbnkFacadeService.getQbnkCtgrUseCntSelect(vo).getEgovMap()).setResultSuccess();
    }

    /**
     * 문제은행분류삭제
     *
     * @param qbnkCtgrId   문제은행분류아이디
     */
    @RequestMapping(value="/qbnkCtgrDeleteAjax.do")
    @ResponseBody
    public ResultDTO<QbnkCtgrVO> qbnkCtgrDeleteAjax(QbnkCtgrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        qbnkFacadeService.qbnkCtgrDelete(vo);

        return new ResultDTO<QbnkCtgrVO>().setResultSuccess();
    }

    /**
     * 문항복사문제은행문항목록조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @param sbjctId	 	과목아이디
     * @return 문제은행문항목록
     */
    @RequestMapping(value={"/profQstnCopyQbnkQstnListAjax.do", "/admQstnCopyQbnkQstnListAjax.do"})
    @ResponseBody
    public ResultDTO<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<EgovMap>().setReturnList(qbnkFacadeService.getProfQstnCopyQbnkQstnList(vo).getEgovList()).setResultSuccess();
    }

}
