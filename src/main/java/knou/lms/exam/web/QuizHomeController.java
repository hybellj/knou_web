package knou.lms.exam.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.vo.DefaultVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.exam.facade.QuizFacadeService;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.vo.*;
import knou.lms.exam.web.view.QuizMainView;
import knou.lms.exam.web.view.QuizPageInfo;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.team.vo.TeamVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value="/quiz")
public class QuizHomeController extends ControllerBase {

    @Resource(name="quizFacadeService")
    private QuizFacadeService quizFacadeService;

    @Resource(name="examService")
    private ExamService examService;

    /*****************************************************
     *						교수 화면	 					*
     ******************************************************/

    /**
     * 교수퀴즈목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_quiz_list_view.jsp
     */
    @RequestMapping(value="/profQuizListView.do")
    public String profQuizListView(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", vo);

        return "quiz/prof_quiz_list_view";
    }

    /**
     * 과목별퀴즈목록
     *
     * @param 	ExamBscVO   시험기본
     * @return 	퀴즈목록
     */
    @RequestMapping(value="/bySubjectQuizList.do")
    @ResponseBody
    public ResultDTO<EgovMap> bySubjectQuizList(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(examService.bySubjectQuizList(vo)).setResultSuccess();
    }

    /**
     * 교수퀴즈목록조회
     *
     * @param sbjctId     과목아이디
     * @param searchValue 검색어 ( 퀴즈명 )
     * @return 교수 퀴즈목록
     */
    @RequestMapping(value="/profQuizListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profQuizListAjax(QuizPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return quizFacadeService.getProfQuizList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 퀴즈성적공개여부수정
     *
     * @param examBscId  시험기본아이디
     * @param mrkOyn     성적공개여부
     * @param exampprOyn 시험지공개여부
     */
    @RequestMapping(value="/quizMrkOynModifyAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizMrkOynModifyAjax(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.quizMrkOynModify(vo);

        return new ResultDTO<ExamBscVO>().setResultSuccess();
    }

    /**
     * 퀴즈성적반영비율수정
     *
     * @param examDtlId 성적상세아이디
     * @param mrkRfltrt 성적반영비율
     */
    @RequestMapping(value="/quizMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizMrkRfltrtModifyAjax(@RequestBody List<ExamBscVO> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(vo -> vo.setMdfrId(userCtx.getUserId()));
        quizFacadeService.quizMrkRfltrtListModify(list);

        return new ResultDTO<ExamBscVO>().setResultSuccess();
    }

    /**
     * 교수퀴즈등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_quiz_regist_view.jsp
     */
    @RequestMapping(value="/profQuizRegistView.do")
    public String profQuizRegistView(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadProfQuizRegistView(vo);
        model.addAttribute("dvclasList", quizMainView.getEgovListMap().get("dvclasList"));
        model.addAttribute("lctrWknoList", quizMainView.getEgovListMap().get("lctrWknoList"));
        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));	// 첨부파일저장소 설정
        model.addAttribute("vo", vo);

        return "quiz/prof_quiz_regist_view";
    }

    /**
     * 퀴즈등록
     *
     * @param ExamBscVO 			퀴즈 정보
     * @param dtlInfos 				팀그룹부과제정보
     * @param sbjctIds 				분반과목아이디목록
     * @param teamGrpIds 			팀그룹아이디:과목아이디목록
     * @param teamGrpSubasmtStngyns 분반번호:과목아이디목록
     */
    @RequestMapping(value="/quizRegistAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizRegistAjax(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="dtlInfos", defaultValue="[]") String dtlInfos
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds
    		, @RequestParam(value="teamGrpIds", defaultValue="[]") String teamGrpIds
    		, @RequestParam(value="teamGrpSubasmtStngyns", defaultValue="[]") String teamGrpSubasmtStngyns) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.getExamDtlVO().setRgtrId(userCtx.getUserId());
        Map<String, String> subMap = new HashMap<>();
        subMap.put("dtlInfos", dtlInfos);
        subMap.put("sbjctIds", sbjctIds);
        subMap.put("teamGrpIds", teamGrpIds);
        subMap.put("teamGrpSubasmtStngyns", teamGrpSubasmtStngyns);

        return new ResultDTO<ExamBscVO>().setData(quizFacadeService.quizRegist(vo, subMap).getExamBscVO()).setResultSuccess();
    }

    /**
     * 교수퀴즈수정화면
     *
     * @param sbjctId 과목개설아이디
     * @return prof_quiz_regist_view.jsp
     */
    @RequestMapping(value="/profQuizModifyView.do")
    public String profQuizModifyView(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizModifyView(vo);
        ExamBscVO bscVO = quizMainView.getExamBscVO();
        bscVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, bscVO.getExamBscId()));	// 첨부파일저장소 설정
        model.addAttribute("vo", bscVO);
        model.addAttribute("dvclasList", quizMainView.getEgovListMap().get("dvclasList"));
        model.addAttribute("lctrWknoList", quizMainView.getEgovListMap().get("lctrWknoList"));

        return "quiz/prof_quiz_regist_view";
    }

    /**
     * 퀴즈수정
     *
     * @param ExamBscVO 퀴즈 정보
     * @param dtlInfos 				팀그룹부과제정보
     * @param sbjctIds 				분반과목아이디목록
     * @param teamGrpIds 			팀그룹아이디:과목아이디목록
     * @param teamGrpSubasmtStngyns 분반번호:과목아이디목록
     */
    @RequestMapping(value="/quizModifyAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizModifyAjax(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="dtlInfos", defaultValue="[]") String dtlInfos
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds
    		, @RequestParam(value="teamGrpIds", defaultValue="[]") String teamGrpIds
    		, @RequestParam(value="teamGrpSubasmtStngyns", defaultValue="[]") String teamGrpSubasmtStngyns) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.getExamDtlVO().setRgtrId(userCtx.getUserId());
        vo.getExamDtlVO().setMdfrId(userCtx.getUserId());
        Map<String, String> subMap = new HashMap<>();
        subMap.put("dtlInfos", dtlInfos);
        subMap.put("sbjctIds", sbjctIds);
        subMap.put("teamGrpIds", teamGrpIds);
        subMap.put("teamGrpSubasmtStngyns", teamGrpSubasmtStngyns);

        return new ResultDTO<ExamBscVO>().setData(quizFacadeService.quizModify(vo, subMap).getExamBscVO()).setResultSuccess();
    }

    /**
     * 퀴즈삭제
     *
     * @param sbjctId   과목아이디
     * @param examBscId 시험기본아이디
     * @param delyn 	삭제여부
     */
    @RequestMapping(value="/quizDeleteAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizDeleteAjax(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.quizDelete(vo);

        return new ResultDTO<ExamBscVO>().setResultSuccess();
    }

    /**
     * 교수이전퀴즈복사팝업
     *
     * @param sbjctId 과목아이디
     * @return prof_bfr_quiz_copy_pop.jsp
     */
    @RequestMapping(value="/profBfrQuizCopyPopup.do")
    public String profBfrQuizCopyPopup(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
        model.addAttribute("quizSearchSmstrList", quizFacadeService.loadProfBfrQuizCopyPopup(vo).getEgovList());
        vo.setUserId(userCtx.getUserId());
        model.addAttribute("vo", vo);

        return "quiz/popup/prof_bfr_quiz_copy_pop";
    }

    /**
     * 교수권한과목퀴즈목록조회
     *
     * @param userId        교수아이디
     * @param smstrChrtId 	학사년도/학기
     * @param sbjctId       과목아이디
     * @param searchValue   검색내용(퀴즈명)
     * @return 퀴즈목록
     */
    @RequestMapping(value="/profAuthrtSbjctQuizListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profAuthrtSbjctQuizListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getProfAuthrtSbjctQuizList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 퀴즈정보조회
     *
     * @param examBscId 시험기본아이디
     * @return 퀴즈 정보
     */
    @RequestMapping(value="/quizSelectAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizSelectAjax(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<ExamBscVO>().setData(quizFacadeService.getQuizSelect(vo).getExamBscVO()).setResultSuccess();
    }

    /**
     * 교수퀴즈문항관리화면
     *
     * @param examBscId 시험기본아이디
     * @param sbjctId   과목아이디
     * @return prof_quiz_qstn_mng_view.jsp
     */
    @RequestMapping(value="/profQuizQstnMngView.do")
    public String profQuizQstnMngView(ExamBscVO vo, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizQstnMngView(vo, userCtx);
        ExamBscVO bscVO = quizMainView.getExamBscVO();
        bscVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));
        model.addAttribute("vo", bscVO);
        model.addAttribute("quizTeamList", quizMainView.getEgovList());
        model.addAttribute("isQstnsCmptn", quizMainView.getIsQstnsCmptn());
        model.addAttribute("qstnRspnsTycdList", quizMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", quizMainView.getCmmnCdList().get("qstnDfctlvTycd"));
        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        model.addAttribute("userCtx", userCtx);

        return "quiz/prof_quiz_qstn_mng_view";
    }

    /**
     * 퀴즈팀그룹부퀴즈목록조회
     *
     * @param teamGrpId  	팀그룹아이디
     * @param examBscId 	시험기본아이디
     * @return 퀴즈부퀴즈목록
     */
    @RequestMapping(value="/quizTeamGrpSubQuizListAjax.do")
    @ResponseBody
    public ResultDTO<ExamDtlVO> quizTeamGrpSubQuizListAjax(ExamDtlVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<ExamDtlVO>().setReturnList(quizFacadeService.getQuizTeamGrpSubQuizList(vo).getExamDtlList()).setResultSuccess();
    }

    /**
     * 퀴즈문항목록조회
     *
     * @param examDtlId 시험상세아이디
     * @return 퀴즈 문항 목록
     */
    @RequestMapping(value={"/quizQstnListAjax.do", "/admQuizQstnListAjax.do"})
    @ResponseBody
    public ResultDTO<QstnVO> quizQstnListAjax(QstnVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<QstnVO>().setReturnList(quizFacadeService.getQuizQstnList(vo).getQstnList()).setResultSuccess();
    }

    /**
     * 퀴즈문항보기항목목록조회
     *
     * @param qstnId 문항아이디
     * @return 퀴즈 문항보기항목 목록
     */
    @RequestMapping(value={"/quizQstnVwitmListAjax.do", "/admQuizQstnVwitmListAjax.do"})
    @ResponseBody
    public ResultDTO<QstnVwitmVO> quizQstnVwitmListAjax(QstnVwitmVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<QstnVwitmVO>().setReturnList(quizFacadeService.getQuizQstnVwitmList(vo).getQstnVwitmList()).setResultSuccess();
    }

    /**
     * 퀴즈문항등록
     *
     * @param QstnVO 문항 정보
     */
    @RequestMapping(value="/quizQstnRegistAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizQstnRegistAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr) {
        vo.setRgtrId(userCtx.getUserId());
        quizFacadeService.quizQstnRegist(vo, qstnsStr);

        return new ResultDTO<ExamBscVO>().setResultSuccess();
    }

    /**
     * 퀴즈문항수정
     *
     * @param QstnVO 문항 정보
     */
    @RequestMapping(value="/quizQstnModifyAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizQstnModifyAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr) {
        vo.setMdfrId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        quizFacadeService.quizQstnModify(vo, qstnsStr);

        return new ResultDTO<ExamBscVO>().setResultSuccess();
    }

    /**
     * 퀴즈문항순번수정
     *
     * @param examDtlId 시험상세아이디
     * @param qstnSeqno 변경할 문항순번
     * @param searchKey 문항순번
     */
    @RequestMapping(value="/qstnSeqnoModifyAjax.do")
    @ResponseBody
    public ResultDTO<QstnVO> qstnSeqnoModifyAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.qstnSeqnoModify(vo);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 퀴즈문항후보순번수정
     *
     * @param examDtlId      시험상세아이디
     * @param qstnId         문항아이디
     * @param qstnSeqno      문항순번
     * @param qstnCnddtSeqno 변경할 문항후보순번
     */
    @RequestMapping(value="/qstnCnddtSeqnoModifyAjax.do")
    @ResponseBody
    public ResultDTO<QstnVO> qstnCnddtSeqnoModifyAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.qstnCnddtSeqnoModify(vo);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 문항정보조회
     *
     * @param examDtlId 시험상세아이디
     * @param qstnId    문항아이디
     * @return 퀴즈 문항 정보
     */
    @RequestMapping(value={"/qstnSelectAjax.do", "/admQstnSelectAjax.do"})
    @ResponseBody
    public ResultDTO<QstnVO> qstnSelectAjax(QstnVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<QstnVO>().setData(quizFacadeService.qstnSelect(vo).getQstnVO()).setResultSuccess();
    }

    /**
     * 퀴즈문항삭제
     *
     * @param QstnVO 문항 정보
     */
    @RequestMapping(value="/quizQstnDeleteAjax.do")
    @ResponseBody
    public ResultDTO<QstnVO> quizQstnDeleteAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.quizQstnDelete(vo);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 퀴즈문항점수수정
     *
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     */
    @RequestMapping(value="/quizQstnScrModifyAjax.do")
    @ResponseBody
    public ResultDTO<QstnVO> quizQstnScrModifyAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.quizQstnScrModify(vo);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 퀴즈문항점수일괄수정
     *
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     */
    @RequestMapping(value="/quizQstnScrBulkModifyAjax.do")
    @ResponseBody
    public ResultDTO<QstnVO> quizQstnScrBulkModifyAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.quizQstnScrBulkModify(vo);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 출제완료퀴즈문항점수일괄수정
     *
     * @param examDtlId 시험상세아이디
     * @param qstnSeqno 문항순번
     * @param qstnScr 	문항점수
     */
    @RequestMapping(value="/cmptnYQuizQstnScrBulkModifyAjax.do")
    @ResponseBody
    public ResultDTO<ExamDtlVO> cmptnYQuizQstnScrBulkModifyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("mdfrId", userCtx.getUserId()));
	    quizFacadeService.cmptnYQuizQstnScrBulkModify(list);

    	return new ResultDTO<ExamDtlVO>().setResultSuccess();
    }

    /**
     * 교수퀴즈문항가져오기
     *
     * @param copyQstnId	복사문항아이디
     * @param examDtlId 	시험상세아이디
     */
    @RequestMapping(value="/profQuizQstnCopyAjax.do")
    @ResponseBody
    public ResultDTO<QstnVO> profQuizQstnCopyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        quizFacadeService.quizQstnCopy(list);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 퀴즈문제출제완료수정
     *
     * @param examBscId   	시험기본아이디
     * @param examDtlId   	시험상세아이디
     * @param examGbncd   	시험구분코드
     * @param searchGubun 	수정상태 ( save, edit )
     * @param searchKey 	( bsc, dtl )
     */
    @RequestMapping(value="/quizQstnsCmptnModifyAjax.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> quizQstnsCmptnModifyAjax(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.quizQstnsCmptnModify(vo);

        return new ResultDTO<ExamBscVO>().setResultSuccess();
    }

    /**
     * 시험응시시작사용자수조회
     *
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     * @return 퀴즈 정보
     */
    @RequestMapping(value="/tkexamStrtUserCntSelectAjax.do")
    @ResponseBody
    public ResultDTO<ExamDtlVO> tkexamStrtUserCntSelectAjax(ExamDtlVO vo, ModelMap model, HttpServletRequest request) {
    	ResultDTO<ExamDtlVO> resultVO = new ResultDTO<ExamDtlVO>();
        resultVO.setResult(quizFacadeService.tkexamStrtUserCntSelect(vo));

        return resultVO;
    }

    /**
     * 교수퀴즈문제수정옵션팝업
     *
     * @param sbjctId	과목아이디
     * @param examBscId 시험기본아이디
     * @return prof_quiz_qstn_modify_option_pop.jsp
     */
    @RequestMapping(value="/profQuizQstnModifyOptionPopup.do")
    public String profQuizQstnModifyOptionPopup(QstnVO vo, ModelMap model, HttpServletRequest request) {
        request.setAttribute("vo", vo);

        return "quiz/popup/prof_quiz_qstn_modify_option_pop";
    }

    /**
     * 퀴즈문항옵션수정
     *
     * @param QstnVO 문항 정보
     */
    @RequestMapping(value="/quizQstnOptionModifyAjax.do")
    @ResponseBody
    public ResultDTO<QstnVO> quizQstnOptionModifyAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.quizQstnOptionModify(vo, qstnsStr);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 교수퀴즈문제복사팝업
     *
     * @param sbjctId	과목아이디
     * @param examBscId 시험기본아이디
     * @return prof_quiz_qstn_copy_pop.jsp
     */
    @RequestMapping(value="/profQuizQstnCopyPopup.do")
    public String profQuizQstnCopyPopup(ExamDtlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
        model.addAttribute("smstrList", quizFacadeService.loadProfQuizQstnCopyPopup(vo).getEgovList());
        vo.setUserId(userCtx.getUserId());
        model.addAttribute("vo", vo);

        return "quiz/popup/prof_quiz_qstn_copy_pop";
    }

    /**
     * 문제가져오기과목목록조회
     *
     * @param smstrChrtId 	학기기수아이디
     * @param sbjctId 		과목이이디
     * @return 과목목록
     */
    @RequestMapping(value={"/copyQstnSbjctListAjax.do", "/admCopyQstnSbjctListAjax.do"})
    @ResponseBody
    public ResultDTO<EgovMap> copyQstnSbjctListAjax(SbjctVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getCopyQstnSbjctList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 문제가져오기퀴즈목록조회
     *
     * @param sbjctId 		과목이이디
     * @return 퀴즈목록
     */
    @RequestMapping(value="/copyQstnQuizListAjax.do")
    @ResponseBody
    public ResultDTO<ExamDtlVO> copyQstnQuizListAjax(ExamDtlVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<ExamDtlVO>().setReturnList(quizFacadeService.getCopyQstnQuizList(vo).getExamDtlList()).setResultSuccess();
    }

    /**
     * 교수문항복사퀴즈문항목록조회
     *
     * @param examDtlId 시험상세아이디
     * @return 퀴즈문항목록
     */
    @RequestMapping(value="/profQstnCopyQuizQstnListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profQstnCopyQuizQstnList(QstnVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getQstnCopyQuizQstnList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 문항엑셀업로드팝업
     *
     * @param examDtlId				시험상세아이디
     * @param exrcsSddnQstnBscId	연습돌발문항기본아이디
     * @param qstnGbncd				문항구분코드
     * @return qstn_excel_upload_pop.jsp
     */
    @RequestMapping(value={"/profQstnExcelUploadPopup.do", "/admQstnExcelUploadPopup.do"})
    public String profQstnExcelUploadPopup(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setUserId(userCtx.getUserId());
        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, StringUtil.nvl(vo.getExamDtlId(), vo.getExrcsSddnQstnBscId())));
        model.addAttribute("vo", vo);
        model.addAttribute("userCtx", userCtx);

        return "quiz/popup/qstn_excel_upload_pop";
    }

    /**
     * 문항등록샘플엑셀다운로드
     *
     * @param examDtlId				시험상세아이디
     * @param exrcsSddnQstnBscId	연습돌발문항기본아이디
     * @param qstnGbncd				문항구분코드
     * @param excelGrid 			엑셀그리드
     * @return excelView
     */
    @RequestMapping(value={"/profQstnRegistSampleExcelDown.do", "/admQstnRegistSampleExcelDown.do"})
    public String profQstnRegistSampleExcelDown(QstnVO vo, ModelMap model, HttpServletRequest request) {
        HashMap<String, Object> map = quizFacadeService.getQstnExcelSampleData(vo).getQstnExcelSampleData();
        List<EgovMap> list = new ArrayList<>();
        if(map != null) {
        	list = (List<EgovMap>) map.get("list");
        }

        // 엑셀화를 위한 정보값 세팅
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("outFileName", "문항엑셀샘플");
        params.put("sheetName", "sample");
        params.put("list", list);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        params.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(params);

        return "excelView";
    }

    /**
     * 문항엑셀업로드
     *
     * @param examDtlId 			시험상세아이디
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @param qstnGbncd 			문항구분코드
     * @param uploadFiles 			파일목록
     * @param uploadPath 			파일경로
     * @param excelGrid 			엑셀그리드
     * @return excelView
     */
    @RequestMapping(value={"/profQstnExcelUpload.do", "/admQstnExcelUpload.do"})
    @ResponseBody
    public ResultDTO<EgovMap> profQstnExcelUpload(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setOrgId(userCtx.getOrgId());
        vo.setRgtrId(userCtx.getUserId());

        return quizFacadeService.qstnExcelUpload(vo).getResultDTO();
    }

    /**
     * 교수퀴즈문제출제완료수정팝업
     *
     * @param examBscId   시험기본아이디
     * @param examDtlId   시험상세아이디
     * @param examGbncd   시험구분코드
     * @param searchGubun 수정상태 ( save, edit )
     * @param searchKey   기본, 상세구분 ( bsc, dtl )
     * @return prof_quiz_qstns_cmptn_modify_pop.jsp
     */
    @RequestMapping(value="/profQuizQstnsCmptnModifyPopup.do")
    public String profQuizQstnsCmptnModifyPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
        request.setAttribute("vo", vo);

        return "quiz/popup/prof_quiz_qstns_cmptn_modify_pop";
    }

    /**
     * 교수퀴즈시험지미리보기팝업
     *
     * @param sbjctId   과목아이디
     * @param examBscId 시험기본아이디
     * @return prof_quiz_examppr_preview_pop.jsp
     */
    @RequestMapping(value="/profQuizExampprPreviewPopup.do")
    public String profQuizExampprPreviewPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizExampprPreviewPopup(vo);
        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("qstnList", quizMainView.getQstnList());
        model.addAttribute("qstnVwitmList", quizMainView.getQstnVwitmList());
        if("QUIZ_TEAM".equals(quizMainView.getExamBscVO().getExamGbncd())) {
            model.addAttribute("quizTeamList", quizMainView.getEgovList());
        }

        return "quiz/popup/prof_quiz_examppr_preview_pop";
    }

    /**
     * 교수퀴즈재응시관리화면
     *
     * @param examBscId 시험기본아이디
     * @param sbjctId   과목아이디
     * @return prof_quiz_retkexam_mng_view.jsp
     */
    @RequestMapping(value="/profQuizRetkexamMngView.do")
    public String profQuizRetkexamMngView(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizRetkexamMngView(vo);
        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizTeamList", quizMainView.getEgovList());
        model.addAttribute("userCtx", userCtx);

        return "quiz/prof_quiz_retkexam_mng_view";
    }

    /**
     * 교수퀴즈응시목록조회
     *
     * @param examBscId     시험기본아이디
     * @param tkexamCmptnyn 응시여부
     * @param evlyn         평가여부
     * @param searchValue   검색어(학과, 학번, 이름)
     * @return 퀴즈응시목록
     */
    @RequestMapping(value="/profQuizTkexamListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profQuizTkexamListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getQuizTkexamList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 교수퀴즈응시이력팝업
     *
     * @param examDtlId 시험상세아이디
     * @param userId    사용자아이디
     * @return prof_quiz_tkexam_hstry_pop.jsp
     */
    @RequestMapping(value="/profQuizTkexamHstryPopup.do")
    public String profQuizTkexamHstryPopup(TkexamVO vo, ModelMap model, HttpServletRequest request) {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizTkexamHstryPopup(vo);
        model.addAttribute("quizExamnee", quizMainView.getEgovMap());
        model.addAttribute("tkexamHstryList", quizMainView.getEgovList());

        return "quiz/popup/prof_quiz_tkexam_hstry_pop";
    }

    /**
     * 교수퀴즈시험지평가팝업
     *
     * @param examBscId 		시험기본아이디
     * @param examDtlId 		시험상세아이디
     * @param userId    		사용자아이디
     * @param evlyn    			평가여부
     * @param tkexamCmptnyn    	시험응시완료여부
     * @param searchValue    	검색어(학과, 학번, 이름)
     * @return quiz_examppr_evl_pop.jsp
     */
    @RequestMapping(value="/profQuizExampprEvlPopup.do")
    public String profQuizExampprEvlPopup(@RequestParam Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizExampprEvlPopup(params);
        model.addAttribute("params", params);
        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizExamnee", quizMainView.getEgovMap());
        model.addAttribute("quizTkexamList", quizMainView.getEgovListMap().get("tkexamList"));
        model.addAttribute("tkexamExampprAnswShtList", quizMainView.getEgovListMap().get("answShtList"));
        model.addAttribute("userTycd", userCtx.getUserTycd());

        return "quiz/popup/quiz_examppr_evl_pop";
    }

    /**
     * 퀴즈재응시설정
     *
     * @param examBscId       시험기본아이디
     * @param examDtlId       시험상세아이디
     * @param userId          사용자아이디
     * @param reexamyn        재시험여부
     * @param reexamPsblSdttm 재시험가능시작일시
     * @param reexamPsblEdttm 재시험가능종료일시
     * @param reexamMrkRfltrt 재시험성적반영비율
     */
    @RequestMapping(value="/quizRetkexamSettingAjax.do")
    @ResponseBody
    public ResultDTO<ExamDtlVO> quizRetkexamSettingAjax(@RequestBody List<ExamDtlVO> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        for(ExamDtlVO vo : list) {
            vo.setRgtrId(userCtx.getUserId());
            vo.setMdfrId(userCtx.getUserId());
        }
        quizFacadeService.quizRetkexamSetting(list);

        return new ResultDTO<ExamDtlVO>().setResultSuccess();
    }

    /**
     * 교수퀴즈평가관리화면
     *
     * @param examBscId 	시험기본아이디
     * @param sbjctId 		과목아이디
     * @return prof_quiz_evl_mng_view.jsp
     */
    @RequestMapping(value="/profQuizEvlMngView.do")
    public String profQuizEvlMngView(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
		QuizMainView quizMainView = quizFacadeService.loadProfQuizEvlMngView(vo);
		model.addAttribute("vo", quizMainView.getExamBscVO());
		model.addAttribute("userCtx", userCtx);

        return "quiz/prof_quiz_evl_mng_view";
    }

    /**
	* 교수퀴즈메모팝업
	*
	* @param examBscId	시험기본아이디
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @return prof_quiz_memo_pop.jsp
	*/
    @RequestMapping(value="/profQuizMemoPopup.do")
    public String profQuizMemoPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadProfQuizMemoPopup(params);
        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizExamnee", quizMainView.geteMap().get("examnee"));
        model.addAttribute("profMemo", quizMainView.geteMap().get("profMemo"));

		return "quiz/popup/prof_quiz_memo_pop";
    }

    /**
	* 퀴즈교수메모수정
	*
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param profMemo 	교수메모
	*/
    @RequestMapping(value="/quizProfMemoModifyAjax.do")
    @ResponseBody
    public ResultDTO<TkexamRsltVO> quizProfMemoModifyAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        params.put("rgtrId", userCtx.getUserId());
        quizFacadeService.profMemoModify(params);

        return new ResultDTO<TkexamRsltVO>().setResultSuccess();
    }

    /**
	* 교수퀴즈시험지초기화
	*
	* @param tkexamId 	시험응시아이디
	* @param examBscId 	시험기본아이디
	* @param examDtlId 	시험상세아이디
	* @param userId 	사용자아이디
	*/
    @RequestMapping(value="/profQuizExampprInitAjax.do")
    @ResponseBody
    public ResultDTO<DefaultVO> profQuizExampprInitAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        params.put("rgtrId", userCtx.getUserId());
        quizFacadeService.quizExampprInit(params);

        return new ResultDTO<DefaultVO>().setResultSuccess();
    }

    /**
	* 교수퀴즈평가점수일괄수정
	*
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param scr 		점수
	* @param scoreType  점수유형
	*/
    @RequestMapping(value="/profQuizEvlScrBulkModifyAjax.do")
    @ResponseBody
    public ResultDTO<DefaultVO> profQuizEvlScrBulkModifyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        quizFacadeService.quizEvlScrBulkModify(list);

        return new ResultDTO<DefaultVO>().setResultSuccess();
    }

    /**
     * 교수퀴즈엑셀성적등록팝업
     *
     * @param examBscId 시험기본아이디
     * @param sbjctId 	과목아이디
     * @return prof_quiz_excel_scr_regist_pop.jsp
     */
    @RequestMapping(value="/profQuizExcelScrRegistPopup.do")
    public String profQuizExcelScrRegistPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
    	vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, vo.getExamBscId()));
        request.setAttribute("vo", vo);

        return "quiz/popup/prof_quiz_excel_scr_regist_pop";
    }

    /**
     * 교수퀴즈성적등록샘플엑셀다운로드
     *
     * @param examBscId 	시험기본아이디
     * @param excelGrid 	엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profQuizScrRegistSampleExcelDown.do")
    public String profQuizScrRegistSampleExcelDown(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
        String title = getMessage("exam.label.std.list"); // 학습자목록
        Map<String, Object> searchMap = new HashMap<String, Object>();
        searchMap.put("examBscId", vo.getExamBscId());
        List<EgovMap> tkexamList = quizFacadeService.getQuizTkexamList(searchMap).getEgovList();

        // 엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", tkexamList);

        HashMap<String, Object> params = new HashMap<>();
        params.put("outFileName", title);
        params.put("sheetName", title);
        params.put("list", tkexamList);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        params.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(params);

        return "excelView";
    }

    /**
     * 교수퀴즈성적엑셀업로드
     *
     * @param examBscId 	시험기본아이디
     * @param excelGrid 	엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profQuizScrExcelUpload.do")
    @ResponseBody
    public ResultDTO<ExamBscVO> profQuizScrExcelUpload(ExamBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        quizFacadeService.quizScrExcelUpload(vo);

        return new ResultDTO<ExamBscVO>().setResultSuccess();
    }

    /**
     * 교수퀴즈응시현황팝업
     *
     * @param examBscId 시험기본아이디
     * @param sbjctId 	과목아이디
     * @return prof_quiz_tkexam_status_pop.jsp
     */
    @RequestMapping(value="/profQuizTkexamStatusPopup.do")
    public String profQuizTkexamStatusPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
        model.addAttribute("chartMap", quizFacadeService.getQuizTkexamStatus(vo).getEgovMap());

        return "quiz/popup/prof_quiz_tkexam_status_pop";
    }

    /**
     * 교수퀴즈응시현황엑셀다운로드
     *
     * @param examBscId 		시험기본아이디
     * @param tkexamCmptnyn 	응시여부
     * @param evlyn 			평가여부
     * @param searchValue 		검색어 ( 학과, 학번, 성명 )
     * @param excelGrid 		엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profQuizTkexamStatusExcelDown.do")
    public String profQuizTkexamStatusExcelDown(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", "시험학습자목록");
        map.put("sheetName", "학습자목록");
        map.put("excelGrid", vo.getExcelGrid());

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("examBscId", vo.getExamBscId());
        params.put("tkexamCmptnyn", request.getParameter("tkexamCmptnyn"));
        params.put("evlyn", request.getParameter("evlyn"));
        params.put("searchValue", vo.getSearchValue());
        map.put("list", quizFacadeService.getQuizTkexamList(params).getEgovList());

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", "학습자목록");

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 교수퀴즈시험지일괄엑셀다운로드
     *
     * @param examBscId 	시험기본아이디
     * @param sbjctId 		과목아이디
     * @return excelView
     */
    @RequestMapping(value="/profQuizExampprBulkExcelDown.do")
    public String profQuizExampprBulkExcelDown(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
        String paperTitle = "학습자별 시험지 목록";

        QuizMainView quizMainView = quizFacadeService.getQuizExampprBulkExcelDown(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", paperTitle);      // 학습자별 시험지 목록
        map.put("sheetName", paperTitle);  // 학습자별 시험지 목록
        map.put("list", quizMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", paperTitle);   // 학습자별 시험지 목록
        modelMap.put("workbook", quizExampprBulkListExcel(map, request));
        modelMap.put("list", quizMainView);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    public SXSSFWorkbook quizExampprBulkListExcel(HashMap<String, Object> map, HttpServletRequest request) {
        String title = StringUtil.nvl(map.get("title"));
        String sheetName = StringUtil.nvl(map.get("sheetName"), "sheet1");

        String ext = StringUtil.nvl(map.get("ext"));
        if(StringUtil.isNull(ext)) {
            ext = ".xlsx";
        }

        SXSSFWorkbook workbook = null;
        SXSSFSheet worksheet = null;
        SXSSFRow row = null;

        workbook = new SXSSFWorkbook();
        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);

        //폰트 설정
        Font fontTitle = workbook.createFont();
        fontTitle.setFontHeight((short) (16 * 25)); //사이즈
        fontTitle.setBold(true);

        //폰트 설정
        Font font1 = workbook.createFont();
        font1.setFontName("나눔고딕"); //글씨체
        font1.setFontHeight((short) (16 * 10)); //사이즈
        font1.setBold(true);

        //폰트 설정(정답)
        Font fontBlue = workbook.createFont();
        fontBlue.setFontName("나눔고딕"); //글씨체
        fontBlue.setFontHeight((short) (16 * 10)); //사이즈
        fontBlue.setBold(true);
        fontBlue.setColor(IndexedColors.BLUE.getIndex());

        //폰트 설정(미평가)
        Font fontGrey = workbook.createFont();
        fontGrey.setFontName("나눔고딕"); //글씨체
        fontGrey.setFontHeight((short) (16 * 10)); //사이즈
        fontGrey.setBold(true);
        fontGrey.setColor(IndexedColors.GREY_50_PERCENT.getIndex());

        //폰트 설정(틀림)
        Font fontRed = workbook.createFont();
        fontRed.setFontName("나눔고딕"); //글씨체
        fontRed.setFontHeight((short) (16 * 10)); //사이즈
        fontRed.setBold(true);
        fontRed.setColor(IndexedColors.RED.getIndex()); //Font.COLOR_RED

        // 셀 스타일 및 폰트 설정
        CellStyle styleTitle = workbook.createCellStyle();
        //정렬
        styleTitle.setAlignment(HorizontalAlignment.CENTER);
        styleTitle.setVerticalAlignment(VerticalAlignment.CENTER);
        styleTitle.setBorderRight(BorderStyle.NONE);
        styleTitle.setBorderLeft(BorderStyle.NONE);
        styleTitle.setBorderTop(BorderStyle.NONE);
        styleTitle.setBorderBottom(BorderStyle.NONE);
        styleTitle.setFont(fontTitle);

        // 셀 스타일 및 폰트 설정
        CellStyle styleCulums = workbook.createCellStyle();
        //정렬
        styleCulums.setAlignment(HorizontalAlignment.CENTER); //왼쪽 정렬
        styleCulums.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleCulums.setBorderRight(BorderStyle.NONE);
        styleCulums.setBorderLeft(BorderStyle.NONE);
        styleCulums.setBorderTop(BorderStyle.NONE);
        styleCulums.setBorderBottom(BorderStyle.NONE);
        styleCulums.setFont(font1);

        // 셀 스타일 및 폰트 설정
        CellStyle styleContent = workbook.createCellStyle();
        //정렬
        styleContent.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        styleContent.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleContent.setBorderRight(BorderStyle.NONE);
        styleContent.setBorderLeft(BorderStyle.NONE);
        styleContent.setBorderTop(BorderStyle.NONE);
        styleContent.setBorderBottom(BorderStyle.NONE);
        styleContent.setFont(font1);


        // 셀 스타일 및 폰트 설정(정답)
        CellStyle styleComplete = workbook.createCellStyle();
        //정렬
        styleComplete.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleComplete.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleComplete.setFont(fontBlue);

        // 셀 스타일 및 폰트 설정(미평가)
        CellStyle styleStudy = workbook.createCellStyle();
        //정렬
        styleStudy.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleStudy.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleStudy.setFont(fontGrey);

        // 셀 스타일 및 폰트 설정(틀림)
        CellStyle styleNoStudy = workbook.createCellStyle();
        //정렬
        styleNoStudy.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleNoStudy.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleNoStudy.setFont(fontRed);

        // 칼럼 길이 설정
        worksheet.setColumnWidth(0, 1500);
        worksheet.setColumnWidth(1, 3000);
        worksheet.setColumnWidth(2, 3000);
        worksheet.setColumnWidth(3, 3000);
        worksheet.setColumnWidth(4, 3000);

        QuizMainView quizMainView = (QuizMainView) map.get("list");
        List<EgovMap> trgtrList = quizMainView.getEgovListMap().get("trgtr");	// 대상자목록
        List<EgovMap> qstnList = quizMainView.getEgovListMap().get("qstn");		// 문항목록

        String checkNo = "";
        int checkQstnNo = 0;
        List<EgovMap> questionNos = new ArrayList<>();
        for(int i = 0; i < qstnList.size(); i++) {
        	EgovMap egovMap = qstnList.get(i);

            int qstnSeqno = Integer.parseInt(StringUtil.nvl(egovMap.get("qstnSeqno"), "0"));
            int qstnCnddtSeqno = Integer.parseInt(StringUtil.nvl(egovMap.get("qstnCnddtSeqno"), "0"));

            if(!checkNo.equals(qstnSeqno + "-" + qstnCnddtSeqno)) {
                questionNos.add(egovMap);
                checkNo = qstnSeqno + "-" + qstnCnddtSeqno;
                checkQstnNo++;
            }
        }

        int fixColSize = 5; //고정 컬럼 길이
        int addColSize = qstnList == null ? 0 : checkQstnNo; //가변 컬럼 길이
        int colSize = fixColSize + addColSize;

        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            worksheet.setColumnWidth(j, 3000);
        }

        int rowNum = -1;

        // TITLE
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < colSize; j++) {
            row.createCell(j).setCellValue(title);
            row.getCell(j).setCellStyle(styleTitle);
        }
        // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
        if(colSize > 1) {
            worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize - 1));
        }

        // 빈행
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < colSize; j++) {
            row.createCell(j).setCellValue("");
        }

        // 첫번째 문항 목록
        List<EgovMap> firstQstnList = qstnList.stream()
        			.filter(qstn ->
        				1 == Integer.valueOf(qstn.get("qstnSeqno").toString()) &&
        				1 == Integer.valueOf(qstn.get("qstnCnddtSeqno").toString())
        			)
        			.collect(Collectors.toList());

        int teamCnt = 0;
        String examDtlId = "";
        int i = 5;
        for(EgovMap firstQstn : firstQstnList) {
        	// 퀴즈팀
        	if(quizMainView.getExamBscVO().getExamGbncd().contains("TEAM")) {
        		List<EgovMap> teamList = quizMainView.getEgovListMap().get("teamList");
        		examDtlId = teamList.get(teamCnt).get("examDtlId").toString();
        		row = worksheet.createRow(++rowNum); // 빈 row
	        	row = worksheet.createRow(++rowNum);
	        	row.createCell(1).setCellValue(teamList.get(teamCnt).get("teamnm").toString());
	        	row.getCell(1).setCellStyle(styleTitle);
	        	row = worksheet.createRow(++rowNum); // 빈 row
	        	teamCnt++;
        	} else {
        		examDtlId = firstQstn.get("examDtlId").toString();
        	}

        	// 헤더 설정
        	row = worksheet.createRow(++rowNum);
        	row.createCell(0).setCellValue("NO.");
        	row.getCell(0).setCellStyle(styleCulums);
        	row.createCell(1).setCellValue("학과");
        	row.getCell(1).setCellStyle(styleCulums); // 학과
        	row.createCell(2).setCellValue("아이디");
        	row.getCell(2).setCellStyle(styleCulums); // 아이디
        	row.createCell(3).setCellValue("이름");
        	row.getCell(3).setCellStyle(styleCulums); // 이름
        	row.createCell(4).setCellValue("상태");
        	row.getCell(4).setCellStyle(styleCulums); // 상태
        	i = 5;
        	final String examDtlIdStr = examDtlId;

        	// 현재 퀴즈 문항 목록
        	List<EgovMap> curQuizQstnList = qstnList.stream()
        			.filter(qstn ->
        				examDtlIdStr.equals(qstn.get("examDtlId"))
        			)
        			.collect(Collectors.toList());

        	for(EgovMap qstn : curQuizQstnList) {
        		String qstnCts = StringUtil.nvl(qstn.get("qstnCts")).replaceAll("<[^>]*>", " ");
        		row.createCell(i).setCellValue(qstnCts);
        		row.getCell(i).setCellStyle(styleCulums);
        		i++;
        	}

        	//헤더별 병합
        	row = worksheet.createRow(++rowNum);
        	for(int j = 0; j < fixColSize; j++) {
        		row.createCell(j).setCellValue("");
        		row.getCell(j).setCellStyle(styleTitle);
        	}
        	i = 5;
        	for(EgovMap qstn : curQuizQstnList) {
        		row.createCell(i).setCellValue(StringUtil.nvl(qstn.get("qstnSeqno")) + "-" + StringUtil.nvl(qstn.get("qstnCnddtSeqno")) + "번");
        		row.getCell(i).setCellStyle(styleCulums);
        		i++;
        	}

        	//헤더별 병합
        	row = worksheet.createRow(++rowNum);
        	for(int j = 0; j < fixColSize; j++) {
        		row.createCell(j).setCellValue("");
        		row.getCell(j).setCellStyle(styleTitle);
        		// 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
        		if(colSize > 1) {
        			worksheet.addMergedRegion(new CellRangeAddress(rowNum - 2, rowNum, j, j));
        		}
        	}
        	i = 5;
        	for(EgovMap qstn : curQuizQstnList) {
        		row.createCell(i).setCellValue(StringUtil.nvl(qstn.get("qstnRspnsTynm")));
        		row.getCell(i).setCellStyle(styleCulums);
        		i++;
        	}

        	// 현재 퀴즈 학습자 목록
        	List<EgovMap> curQuizUserList = trgtrList.stream()
        			.filter(user -> examDtlIdStr.equals(user.get("examDtlId")))
        			.collect(Collectors.toMap(
        					user -> user.get("userId").toString(),
        					user -> user,
        					(existing, duplicate) -> existing
        			))
        			.values()
        			.stream()
        			.collect(Collectors.toList());

        	if (curQuizUserList != null && !curQuizUserList.isEmpty() && curQuizUserList.size() > 0) {
        		int idx = 1;
        		for(EgovMap curUser : curQuizUserList) {
        			row = worksheet.createRow(++rowNum);
            		String tkexamCmptnyn = StringUtil.nvl(curUser.get("tkexamCmptnyn"));
            		String reExamYn = StringUtil.nvl(curUser.get("retkexamYn"));
            		String status = "";
            		if("Y".equals(reExamYn)) {
            			status = "재응시";
            		} else if("N".equals(tkexamCmptnyn)) {
            			status = "미응시";
            		} else if("Y".equals(tkexamCmptnyn)) {
            			status = "응시완료";
            		}

            		row.createCell(0).setCellValue(StringUtil.nvl(idx++));
            		row.getCell(0).setCellStyle(styleContent);
            		row.createCell(1).setCellValue(StringUtil.nvl(curUser.get("deptnm")));
            		row.getCell(1).setCellStyle(styleContent);
            		row.createCell(2).setCellValue(StringUtil.nvl(curUser.get("userId")));
            		row.getCell(2).setCellStyle(styleContent);
            		row.createCell(3).setCellValue(StringUtil.nvl(curUser.get("usernm")));
            		row.getCell(3).setCellStyle(styleContent);
            		row.createCell(4).setCellValue(status);
            		row.getCell(4).setCellStyle(styleContent);

            		// 현재 학습자 답변 목록
		            List<EgovMap> curUserRspnsList = trgtrList.stream()
						    .filter(user ->
						    	curUser.get("userId").equals(user.get("userId")) &&
						    	curUser.get("examDtlId").equals(user.get("examDtlId"))
						    )
						    .collect(Collectors.toList());

		            i = 5;
		            // 여기 해야함 답변목록
		            for(EgovMap qstn : curQuizQstnList) {
		            	String qstnRspnsTycd = "";
		            	String answShtCts = "";
		            	int scr = 0;

		            	for (EgovMap user : curUserRspnsList) {
		            	    if (StringUtil.nvl(user.get("qstnId"),"").equals(qstn.get("qstnId"))) {
		            	    	qstnRspnsTycd = Objects.toString(qstn.get("qstnRspnsTycd"));
		            	    	answShtCts = Objects.toString(user.get("answShtCts"));
		            	        scr = (int) Math.round(Math.floor(Double.parseDouble(Objects.toString(user.get("scr")))));
		            	        break;
		            	    }
		            	}

			            row.createCell(i).setCellValue(answShtCts);
			            //정답유무 처리
    					if("LONG_TEXT".equals(qstnRspnsTycd) && scr <= 0) {
    						row.getCell(i).setCellStyle(styleStudy);
    					} else if(scr > 0 && !"".equals(answShtCts)) {
    						row.getCell(i).setCellStyle(styleComplete);
    					} else if(scr == 0) {
    						row.getCell(i).setCellStyle(styleNoStudy);
    					} else {
    						row.getCell(i).setCellStyle(styleNoStudy);
    					}

	    				i++;
		            }
        		}
        	}
        }


        return workbook;
    }

    /**
     * 교수퀴즈시험지일괄인쇄팝업
     *
     * @param examBscId 	시험기본아이디
     * @param sbjctId   	과목아이디
     * @return prof_quiz_examppr_bulk_print_pop.jsp
     */
    @RequestMapping(value="/profQuizExampprBulkPrintPopup.do")
    public String profQuizExampprBulkPrintPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadProfQuizExampprBulkPrintPopup(params);
    	model.addAttribute("examBscVO", quizMainView.getExamBscVO());
        model.addAttribute("quizTkexamList", quizMainView.getEgovList());

        return "quiz/popup/prof_quiz_examppr_bulk_print_pop";
    }

    /**
     * 교수시험응시시험지답안목록조회
     *
     * @param tkexamId  시험응시아이디
     * @param userId 	사용자아이디
     * @return 시험응시시험지답안목록
     */
    @RequestMapping(value="/profTkexamExampprAnswShtListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profTkexamExampprAnswShtListAjax(TkexamVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getTkexamExampprAnswShtList(vo).getEgovList()).setResultSuccess();
    }

    /**
	* 퀴즈시험지점수수정
	*
	* @param exampprId 			시험지아이디
	* @param qstnId 			문항아이디
	* @param tkexamAnswShtId 	시험응시답안아이디
	* @param userId 			사용자아이디
	*/
    @RequestMapping(value="/quizExampprScrModifyAjax.do")
    @ResponseBody
    public ResultDTO<TkexamAnswShtVO> quizExampprScrModifyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        quizFacadeService.tkexamAnswShtScrModify(list);

        return new ResultDTO<TkexamAnswShtVO>().setResultSuccess();
    }

    /**
     * 퀴즈문항상태차트
     *
     * @param examDtlId  	시험상세아이디
     * @param qstnId 		문항아이디
     * @return 퀴즈문항분포
     */
    @RequestMapping(value="/quizQstnStatusChartAjax.do")
    @ResponseBody
    public ResultDTO<QuizMainView> quizQstnStatusChartAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<QuizMainView>().setData(quizFacadeService.getQuizQstnStatusChart(params)).setResultSuccess();
    }

    /**
     * 교수연습문제목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_exrcs_qstn_list_view.jsp
     */
    @RequestMapping(value="/profExrcsQstnListView.do")
    public String profExrcsQstnListView(ExrcsSddnQstnBscVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", vo);

        return "quiz/prof_exrcs_qstn_list_view";
    }

    /**
     * 교수연습돌발문항기본목록조회
     *
     * @param sbjctId     	과목아이디
     * @param qstnGbncd 	문항구분코드
     * @param searchValue 	검색어 ( 제목 )
     * @return 연습돌발문항기본목록
     */
    @RequestMapping(value="/profExrcsSddnQstnBscListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profExrcsSddnQstnBscListAjax(QuizPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return quizFacadeService.getProfExrcsSddnQstnBscList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 연습문제시험지미리보기팝업
     *
     * @param exrcsSddnQstnBscId 연습돌발문항기본아이디
     * @return exrcs_qstn_examppr_preview_pop.jsp
     */
    @RequestMapping(value={"/profExrcsQstnExampprPreviewPopup.do", "/admExrcsQstnExampprPreviewPopup.do"})
    public String profExrcsQstnExampprPreviewPopup(ExrcsSddnQstnBscVO vo, ModelMap model, HttpServletRequest request) {
        QuizMainView quizMainView = quizFacadeService.loadProfExrcsQstnExampprPreviewPopup(vo);
        model.addAttribute("vo", quizMainView.getEgovMap());
        model.addAttribute("qstnList", quizMainView.getQstnList());
        model.addAttribute("qstnVwitmList", quizMainView.getQstnVwitmList());

        return "quiz/popup/exrcs_qstn_examppr_preview_pop";
    }

    /**
     * 교수연습문제등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_exrcs_qstn_regist_view.jsp
     */
    @RequestMapping(value="/profExrcsQstnRegistView.do")
    public String profExrcsQstnRegistView(ExrcsSddnQstnBscVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("dvclasList", quizFacadeService.loadProfExrcsQstnRegistView(vo).getEgovList());
    	vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));	// 첨부파일저장소 설정
    	model.addAttribute("vo", vo);

        return "quiz/prof_exrcs_qstn_regist_view";
    }

    /**
     * 연습문제등록
     *
     * @param ExrcsSddnQstnBscVO 	연습돌발문항기본정보
     */
    @RequestMapping(value={"/exrcsQstnRegistAjax.do", "/admExrcsQstnRegistAjax.do"})
    @ResponseBody
    public ResultDTO<ExrcsSddnQstnBscVO> exrcsQstnRegistAjax(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setSubParam(sbjctIds);

        return new ResultDTO<ExrcsSddnQstnBscVO>().setData(quizFacadeService.exrcsQstnRegist(vo).getExrcsSddnQstnBscVO()).setResultSuccess();
    }

    /**
     * 교수연습문제수정화면
     *
     * @param sbjctId 				과목아이디
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @return prof_exrcs_qstn_regist_view.jsp
     */
    @RequestMapping(value="/profExrcsQstnModifyView.do")
    public String profExrcsQstnModifyView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadProfExrcsQstnModifyView(vo, userCtx);
    	model.addAttribute("dvclasList", quizMainView.getEgovList());
    	EgovMap qstnEgovMap = quizMainView.getEgovMap();
    	qstnEgovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));	// 첨부파일저장소 설정
    	model.addAttribute("vo", qstnEgovMap);
    	model.addAttribute("sbjctIds", qstnEgovMap.get("sbjctIds"));
    	model.addAttribute("qstnRspnsTycdList", quizMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", quizMainView.getCmmnCdList().get("qstnDfctlvTycd"));

    	return "quiz/prof_exrcs_qstn_regist_view";
    }

    /**
     * 연습문제수정
     *
     * @param ExrcsSddnQstnBscVO 	연습돌발문항기본정보
     */
    @RequestMapping(value={"/exrcsQstnModifyAjax.do", "/admExrcsQstnModifyAjax.do"})
    @ResponseBody
    public ResultDTO<ExrcsSddnQstnBscVO> exrcsQstnModifyAjax(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());

        return new ResultDTO<ExrcsSddnQstnBscVO>().setData(quizFacadeService.exrcsQstnModify(vo).getExrcsSddnQstnBscVO()).setResultSuccess();
    }

    /**
     * 연습문제일괄문항등록
     *
     * @param QstnVO 문항정보
     */
    @RequestMapping(value={"/exrcsQstnBulkQstnRegistAjax.do", "/admExrcsQstnBulkQstnRegistAjax.do"})
    @ResponseBody
    public ResultDTO<QstnVO> exrcsQstnBulkQstnRegistAjax(QstnVO vo, ModelMap model, HttpServletRequest request
    				, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr
    				, @CurrentUser UserContext userCtx) {
        vo.setRgtrId(userCtx.getUserId());
        quizFacadeService.exrcsQstnBulkQstnRegist(vo, qstnsStr);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 연습문제일괄문항수정
     *
     * @param QstnVO 문항 정보
     */
    @RequestMapping(value={"/exrcsQstnBulkQstnModifyAjax.do", "/admExrcsQstnBulkQstnModifyAjax.do"})
    @ResponseBody
    public ResultDTO<QstnVO> exrcsQstnBulkQstnModifyAjax(QstnVO vo, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr
    		, @CurrentUser UserContext userCtx) {
    	vo.setRgtrId(userCtx.getUserId());
    	vo.setMdfrId(userCtx.getUserId());
    	quizFacadeService.exrcsQstnBulkQstnModify(vo, qstnsStr);

    	return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 연습문제일괄문항순번수정
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @param qstnSeqno 			변경할 문항순번
     * @param searchKey 			문항순번
     */
    @RequestMapping(value={"/exrcsQstnBulkQstnSeqnoModifyAjax.do", "/admExrcsQstnBulkQstnSeqnoModifyAjax.do"})
    @ResponseBody
    public ResultDTO<QstnVO> exrcsQstnBulkQstnSeqnoModifyAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.exrcsQstnBulkQstnSeqnoModify(vo);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 연습문제일괄문항삭제
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @param qstnSeqno 			문항순번
     */
    @RequestMapping(value={"/exrcsQstnBulkQstnDeleteAjax.do", "/admExrcsQstnBulkQstnDeleteAjax.do"})
    @ResponseBody
    public ResultDTO<QstnVO> exrcsQstnBulkQstnDeleteAjax(QstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.exrcsQstnBulkQstnDelete(vo);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 연습문제복사팝업
     *
     * @param sbjctId				과목아이디
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @return exrcs_qstn_copy_pop.jsp
     */
    @RequestMapping(value={"/profExrcsQstnCopyPopup.do", "/admExrcsQstnCopyPopup.do"})
    public String profExrcsQstnCopyPopup(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
        model.addAttribute("searchSmstrList", quizFacadeService.loadProfExrcsQstnCopyPopup(vo).getEgovList());
        vo.setUserId(userCtx.getUserId());
        model.addAttribute("vo", vo);
        model.addAttribute("userCtx", userCtx);

        return "quiz/popup/exrcs_qstn_copy_pop";
    }

    /**
     * 문제가져오기연습문제목록조회
     *
     * @param sbjctId 		과목이이디
     * @return 연습문제목록
     */
    @RequestMapping(value={"/copyQstnExrcsQstnListAjax.do", "/admCopyQstnExrcsQstnListAjax.do"})
    @ResponseBody
    public ResultDTO<ExrcsSddnQstnBscVO> copyQstnExrcsQstnListAjax(ExrcsSddnQstnBscVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<ExrcsSddnQstnBscVO>().setReturnList(quizFacadeService.getQstnCopyExrcsQstnList(vo).getExrcsQstnBscList()).setResultSuccess();
    }

    /**
     * 문항복사연습문제목록조회
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @return 연습문제목록
     */
    @RequestMapping(value={"/profQstnCopyExrcsQstnListAjax.do", "/admQstnCopyExrcsQstnListAjax.do"})
    @ResponseBody
    public ResultDTO<EgovMap> profQstnCopyExrcsQstnListAjax(QstnVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getProfQstnCopyExrcsQstnList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 연습문제가져오기
     *
     * @param copyQstnId			복사문항아이디
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     */
    @RequestMapping(value={"/profExrcsQstnCopyAjax.do", "/admExrcsQstnCopyAjax.do"})
    @ResponseBody
    public ResultDTO<QstnVO> profExrcsQstnCopyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        quizFacadeService.profExrcsQstnCopy(list);

        return new ResultDTO<QstnVO>().setResultSuccess();
    }

    /**
     * 연습문제출제완료수정
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @param searchGubun 			수정상태 ( save, edit )
     */
    @RequestMapping(value={"/exrcsQstnsCmptnModifyAjax.do", "/admExrcsQstnsCmptnModifyAjax.do"})
    @ResponseBody
    public ResultDTO<ExrcsSddnQstnBscVO> exrcsQstnsCmptnModifyAjax(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        quizFacadeService.exrcsQstnsCmptnModify(vo);

        return new ResultDTO<ExrcsSddnQstnBscVO>().setResultSuccess();
    }

    /**
     * 교수돌발퀴즈목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_sddn_quiz_list_view.jsp
     */
    @RequestMapping(value="/profSddnQuizListView.do")
    public String profSddnQuizListView(ExrcsSddnQstnBscVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", vo);

        return "quiz/prof_sddn_quiz_list_view";
    }

    /**
     * 교수돌발퀴즈등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_sddn_quiz_regist_view.jsp
     */
    @RequestMapping(value="/profSddnQuizRegistView.do")
    public String profSddnQuizRegistView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadProfSddnQuizRegistView(vo, userCtx);
    	vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));	// 첨부파일저장소 설정
    	model.addAttribute("vo", vo);
    	model.addAttribute("lectureScheduleList", quizMainView.getEgovList());
    	model.addAttribute("qstnRspnsTycdList", quizMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", quizMainView.getCmmnCdList().get("qstnDfctlvTycd"));

        return "quiz/prof_sddn_quiz_regist_view";
    }

    /**
     * 돌발퀴즈등록
     *
     * @param ExrcsSddnQstnBscVO 	연습돌발문항기본정보
     * @param QstnVO 				문항정보
     * @param qstnsStr 				문항보기항목정보
     */
    @RequestMapping(value={"/sddnQuizRegistAjax.do", "/admSddnQuizRegistAjax.do"})
    @ResponseBody
    public ResultDTO<ExrcsSddnQstnBscVO> sddnQuizRegistAjax(ExrcsSddnQstnBscVO vo, QstnVO qstn, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    			, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr) {
        vo.setRgtrId(userCtx.getUserId());
        String qstnTtl = vo.getQstnTtl();
        vo.setQstnTtl(qstnTtl.split(",")[0]);
        qstn.setQstnTtl(qstnTtl.split(",")[1]);
        vo.setQstnCts(request.getParameter("sddnQuizCts"));
        quizFacadeService.sddnQuizRegist(vo, qstn, qstnsStr);

        return new ResultDTO<ExrcsSddnQstnBscVO>().setResultSuccess();
    }

    /**
     * 교수돌발퀴즈수정화면
     *
     * @param sbjctId 				과목아이디
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @return prof_sddn_quiz_regist_view.jsp
     */
    @RequestMapping(value="/profSddnQuizModifyView.do")
    public String profSddnQuizModifyView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadProfSddnQuizModifyView(vo, userCtx);
    	EgovMap qstnEgovMap = quizMainView.getEgovMap();
    	qstnEgovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));	// 첨부파일저장소 설정
    	model.addAttribute("vo", qstnEgovMap);
    	model.addAttribute("qstnId", qstnEgovMap.get("qstnId"));
    	model.addAttribute("lectureScheduleList", quizMainView.getEgovList());
    	model.addAttribute("qstnRspnsTycdList", quizMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", quizMainView.getCmmnCdList().get("qstnDfctlvTycd"));

    	return "quiz/prof_sddn_quiz_regist_view";
    }

    /**
     * 돌발퀴즈수정
     *
     * @param ExrcsSddnQstnBscVO 	연습돌발문항기본정보
     * @param QstnVO 				문항정보
     * @param qstnsStr 				문항보기항목정보
     */
    @RequestMapping(value={"/sddnQuizModifyAjax.do", "/admSddnQuizModifyAjax.do"})
    @ResponseBody
    public ResultDTO<ExrcsSddnQstnBscVO> sddnQuizModifyAjax(ExrcsSddnQstnBscVO vo, QstnVO qstn, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    			, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        String qstnTtl = vo.getQstnTtl();
        vo.setQstnTtl(qstnTtl.split(",")[0]);
        qstn.setQstnTtl(qstnTtl.split(",")[1]);
        vo.setQstnCts(request.getParameter("sddnQuizCts"));
        quizFacadeService.sddnQuizModify(vo, qstn, qstnsStr);

        return new ResultDTO<ExrcsSddnQstnBscVO>().setResultSuccess();
    }

    /**
     * 돌발퀴즈강의주차등록문항수조회
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
	 * @param qstnGbncd 			문항구분코드
	 * @param sbjctId 				과목아이디
	 * @param lctrWknoSchdlId 		강의주차일정아이디
	 * @param qstnSeqno 			문항순번
     * @return 강의주차등록문항수
     */
    @RequestMapping(value={"/sddnQuizLctrWknoRegistQstnCntSelectAjax.do", "/admSddnQuizLctrWknoRegistQstnCntSelectAjax.do"})
    @ResponseBody
    public ResultDTO<EgovMap> sddnQuizLctrWknoRegistQstnCntSelectAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
    	ResultDTO<EgovMap> resultVO = new ResultDTO<EgovMap>();
        resultVO.setResult(quizFacadeService.getLctrWknoRegistQstnCntSelect(params));

        return resultVO;
    }

    /*****************************************************
     *						학생 화면	 					*
     ******************************************************/

    /**
     * 학생퀴즈목록화면
     *
     * @param sbjctId 과목아이디
     * @return stdnt_quiz_list_view.jsp
     */
    @RequestMapping(value="/stdntQuizListView.do")
    public String stdntQuizListView(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", vo);

        return "quiz/stdnt_quiz_list_view";
    }

    /**
     * 학생퀴즈목록조회
     *
     * @param sbjctId     과목아이디
     * @param searchValue 검색어 ( 퀴즈명 )
     * @return 학생 퀴즈목록
     */
    @RequestMapping(value="/stdntQuizListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntQuizListAjax(QuizPageInfo pageInfo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	pageInfo.setUserId(userCtx.getUserId());
        return quizFacadeService.getStdntQuizList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 학생퀴즈정보화면
     *
     * @param sbjctId 	과목아이디
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     * @return stdnt_quiz_info_view.jsp
     */
    @RequestMapping(value="/stdntQuizInfoView.do")
    public String stdntQuizInfoView(ExamBscVO bsc, ExamDtlVO dtl, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadStdntQuizInfoView(bsc, dtl, userCtx);
    	model.addAttribute("vo", quizMainView.geteMap().get("vo"));
    	model.addAttribute("rsltVO", quizMainView.geteMap().get("rslt"));
    	model.addAttribute("userCtx", userCtx);

        return "quiz/stdnt_quiz_info_view";
    }

    /**
     * 학생퀴즈응시이력목록조회
     *
     * @param examDtlId 시험상세아이디
     * @param userId	사용자아이디
     * @return 학생 퀴즈응시이력목록
     */
    @RequestMapping(value="/stdntQuizTkexamHstryListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntQuizTkexamHstryListAjax(TkexamHstryVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setUserId(userCtx.getUserId());

        return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getStdntQuizTkexamHstryList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 학생퀴즈응시주의사항팝업
     *
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     * @param sbjctId 	과목아이디
     * @return stdnt_quiz_tkexam_prep_info_pop.jsp
     */
    @RequestMapping(value="/stdntQuizTkexamPrepInfoPopup.do")
    public String stdntQuizTkexamPrepInfoPopup(ExamDtlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        model.addAttribute("vo", quizFacadeService.loadStdntQuizTkexamPrepInfoPopup(vo, userCtx).getEgovMap());

        return "quiz/popup/stdnt_quiz_tkexam_prep_info_pop";
    }

    /**
     * 학생퀴즈응시팝업
     *
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     * @param tkexamId 	시험응시아이디
     * @return stdnt_quiz_tkexam_pop.jsp
     */
    @RequestMapping(value="/stdntQuizTkexamPopup.do")
    public String stdntQuizTkexamPopup(ExamDtlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        QuizMainView quizMainView = quizFacadeService.loadStdntQuizTkexamPopup(vo, userCtx);
        model.addAttribute("vo", quizMainView.getEgovMap());
        if(quizMainView.getResultDTO().getResult() > 0) {
        	EgovMap exampprMap = (EgovMap) quizMainView.getResultDTO().getData();
        	model.addAttribute("tkexamInfo", exampprMap.get("tkexamInfo"));
        	model.addAttribute("qstnList", exampprMap.get("qstnList"));
        	model.addAttribute("qstnVwitmList", exampprMap.get("qstnVwitmList"));
        	model.addAttribute("answShtList", exampprMap.get("answShtList"));
        } else {
        	model.addAttribute("msg", quizMainView.getResultDTO().getMessage());
        }

        return "quiz/popup/stdnt_quiz_tkexam_pop";
    }

    /**
     * 학생단일문항임시저장
     *
     * @param qstnId		문항아이디
     * @param answShtCts	답안내용
     * @param tkexamId		시험응시아이디
     */
    @RequestMapping(value="/stdntSsnlQstnTempSaveAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntSsnlQstnTempSaveAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        params.put("userId", userCtx.getUserId());
        params.put("ip", userCtx.getIP());
        quizFacadeService.stdntSsnlQstnTempSave(params);

        return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /**
     * 학생문항일괄임시저장
     *
     * @param rspns			문항목록
     * @param tkexamId		시험응시아이디
     */
    @RequestMapping(value="/stdntQstnBulkTempSaveAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntQstnBulkTempSaveAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	params.put("userId", userCtx.getUserId());
    	params.put("ip", userCtx.getIP());
    	quizFacadeService.stdntQstnBulkTempSave(params);

    	return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /**
     * 학생퀴즈시험지제출
     *
     * @param rspns			문항목록
     * @param tkexamId		시험응시아이디
     */
    @RequestMapping(value="/stdntQuizExampprSbmsnAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntQuizExampprSbmsnAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	params.put("userId", userCtx.getUserId());
    	params.put("ip", userCtx.getIP());
    	quizFacadeService.stdntQuizExampprSbmsn(params);

    	return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /**
     * 학생퀴즈응시시간수정
     *
     * @param examDtlId		시험상세아이디
     * @param tkexamId		시험응시아이디
     */
    @RequestMapping(value="/stdntQuizTkexamMntsModifyAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntQuizTkexamMntsModifyAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	params.put("userId", userCtx.getUserId());
    	params.put("ip", userCtx.getIP());
    	quizFacadeService.stdntQuizTkexamMntsModify(params);

    	return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /**
     * 학생퀴즈평가시험지팝업
     *
     * @param examBscId 		시험기본아이디
     * @param examDtlId 		시험상세아이디
     * @param userId    		사용자아이디
     * @param evlyn    			평가여부
     * @param tkexamCmptnyn    	시험응시완료여부
     * @param searchValue    	검색어(학과, 학번, 이름)
     * @return quiz_examppr_evl_pop.jsp
     */
    @RequestMapping(value="/stdntQuizEvlExampprPopup.do")
    public String stdntQuizEvlExampprPopup(@RequestParam Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	params.put("userId", userCtx.getUserId());
        QuizMainView quizMainView = quizFacadeService.loadStdntQuizEvlExampprPopup(params);
        model.addAttribute("params", params);
        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizExamnee", quizMainView.getEgovMap());
        model.addAttribute("tkexamExampprAnswShtList", quizMainView.getEgovList());
        model.addAttribute("userTycd", userCtx.getUserTycd());

        return "quiz/popup/quiz_examppr_evl_pop";
    }

    /**
     * 퀴즈팀멤버팝업
     *
     * @param teamId 		팀아이디
     * @return quiz_team_mbr_pop.jsp
     */
    @RequestMapping(value="/quizTeamMbrPopup.do")
    public String quizTeamMbrPopup(TeamVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", vo);

        return "quiz/popup/quiz_team_mbr_pop";
    }

    /*****************************************************
     *						관리자 화면	 					*
     ******************************************************/

    /**
     * 관리자연습문제목록화면
     *
     * @return adm_exrcs_qstn_list_view.jsp
     */
    @RequestMapping(value="/admExrcsQstnListView.do")
    public String admExrcsQstnListView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadAdmExrcsQstnListView();

    	model.addAttribute("orgList", quizMainView.getOrgList());
    	model.addAttribute("yearList", quizMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", quizMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("vo", vo);

        return "quiz/adm_exrcs_qstn_list_view";
    }

    /**
     * 기관별학기기수목록조회
     *
     * @param orgId 	기관이이디
     * @param dgrsYr 	학위연도
     * @return 학기기수목록
     */
    @RequestMapping(value={"/smstrChrtListAjax.do", "/admSmstrChrtListAjax.do"})
    @ResponseBody
    public ResultDTO<EgovMap> admSmstrChrtListAjax(ExamBscVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getSmstrChrtList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 학기기수과목목록조회
     *
     * @param orgId 		기관이이디
     * @param smstrChrtId 	학기기수아이디
     * @param sbjctYr 		학사년도
     * @return 과목목록
     */
    @RequestMapping(value="/admSbjctListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSbjctListAjax(SubjectVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getSbjctList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 과목별주차목록조회
     *
     * @param sbjctId 		과목이이디
     * @return 주차목록
     */
    @RequestMapping(value="/admLctrWknoListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admLctrWknoListAjax(SubjectVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<EgovMap>().setReturnList(quizFacadeService.getLctrWknoList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 관리자연습돌발문항기본목록조회
     *
     * @param sbjctId     	과목아이디
     * @param dgrsYr		학위연도
     * @param smstrChrtId	학기기수아이디
     * @param orgId     	기관아이디
     * @param qstnGbncd 	문항구분코드
     * @param searchValue 	검색어 ( 제목 )
     * @return 연습돌발문항기본목록
     */
    @RequestMapping(value="/admExrcsSddnQstnBscListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admExrcsSddnQstnBscListAjax(QuizPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return quizFacadeService.getAdmExrcsSddnQstnBscList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 관리자연습문제등록화면
     *
     * @return adm_exrcs_qstn_regist_view.jsp
     */
    @RequestMapping(value="/admExrcsQstnRegistView.do")
    public String admExrcsQstnRegistView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadAdmExrcsQstnRegistView();

    	model.addAttribute("orgList", quizMainView.getOrgList());
    	model.addAttribute("yearList", quizMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", quizMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

        return "quiz/adm_exrcs_qstn_regist_view";
    }

    /**
     * 관리자연습문제수정화면
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @param sbjctId 				과목아이디
     * @return adm_exrcs_qstn_regist_view.jsp
     */
    @RequestMapping(value="/admExrcsQstnModifyView.do")
    public String admExrcsQstnModifyView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadAdmExrcsQstnModifyView(vo, userCtx);
    	EgovMap qstnEgovMap = (EgovMap) quizMainView.getEgovMap().get("vo");
    	qstnEgovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));	// 첨부파일저장소 설정
    	model.addAttribute("orgList", quizMainView.getOrgList());
    	model.addAttribute("yearList", quizMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", quizMainView.getEgovMap().get("curYear"));
    	model.addAttribute("vo", qstnEgovMap);
    	model.addAttribute("qstnRspnsTycdList", quizMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", quizMainView.getCmmnCdList().get("qstnDfctlvTycd"));
        model.addAttribute("userCtx", userCtx);

    	return "quiz/adm_exrcs_qstn_regist_view";
    }

    /**
     * 관리자돌발퀴즈목록화면
     *
     * @return adm_sddn_quiz_list_view.jsp
     */
    @RequestMapping(value="/admSddnQuizListView.do")
    public String admSddnQuizListView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadAdmSddnQuizListView();

    	model.addAttribute("orgList", quizMainView.getOrgList());
    	model.addAttribute("yearList", quizMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", quizMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("vo", vo);

        return "quiz/adm_sddn_quiz_list_view";
    }

    /**
     * 관리자돌발퀴즈등록화면
     *
     * @return adm_sddn_quiz_regist_view.jsp
     */
    @RequestMapping(value="/admSddnQuizRegistView.do")
    public String admSddnQuizRegistView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadAdmSddnQuizRegistView(vo, userCtx);
    	EgovMap map = new EgovMap();
    	map.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, null));	// 첨부파일저장소 설정
    	model.addAttribute(map);
    	model.addAttribute("yearList", quizMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", quizMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("orgList", quizMainView.getOrgList());
    	model.addAttribute("qstnRspnsTycdList", quizMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", quizMainView.getCmmnCdList().get("qstnDfctlvTycd"));

        return "quiz/adm_sddn_quiz_regist_view";
    }

    /**
     * 관리자돌발퀴즈수정화면
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @param sbjctId 				과목아이디
     * @return adm_sddn_quiz_regist_view.jsp
     */
    @RequestMapping(value="/admSddnQuizModifyView.do")
    public String admSddnQuizModifyView(ExrcsSddnQstnBscVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	QuizMainView quizMainView = quizFacadeService.loadAdmSddnQuizModifyView(vo, userCtx);
    	EgovMap qstnEgovMap = (EgovMap) quizMainView.getEgovMap().get("vo");
    	qstnEgovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, qstnEgovMap.get("exrcsSddnQstnBscId").toString()));	// 첨부파일저장소 설정
    	model.addAttribute("vo", qstnEgovMap);
    	model.addAttribute("orgList", quizMainView.getOrgList());
    	model.addAttribute("yearList", quizMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", quizMainView.getEgovMap().get("curYear"));
    	model.addAttribute("qstnId", qstnEgovMap.get("qstnId"));
    	model.addAttribute("qstnRspnsTycdList", quizMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", quizMainView.getCmmnCdList().get("qstnDfctlvTycd"));
        model.addAttribute("userCtx", userCtx);

    	return "quiz/adm_sddn_quiz_regist_view";
    }

}
