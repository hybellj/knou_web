package knou.lms.exam.facade;

import java.util.List;
import java.util.Map;

import knou.framework.context2.UserContext;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.ExrcsSddnQstnBscVO;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;
import knou.lms.exam.vo.TkexamHstryVO;
import knou.lms.exam.vo.TkexamVO;
import knou.lms.exam.web.view.QuizMainView;
import knou.lms.exam.web.view.QuizPageInfo;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.vo.UsrDeptCdVO;

public interface QuizFacadeService {

	/*****************************************************
     *						교수 화면	 					*
     ******************************************************/

	QuizMainView getProfQuizList(QuizPageInfo pageInfo);

	void quizMrkOynModify(ExamBscVO vo);

	void quizMrkRfltrtListModify(List<ExamBscVO> list);

	QuizMainView loadProfQuizRegistView(ExamBscVO vo);

	QuizMainView quizRegist(ExamBscVO vo, Map<String, String> subMap);

	QuizMainView loadProfQuizModifyView(ExamBscVO vo);

	QuizMainView quizModify(ExamBscVO vo, Map<String, String> subMap);

	void quizDelete(ExamBscVO vo);

	QuizMainView loadProfBfrQuizCopyPopup(ExamBscVO vo);

	QuizMainView getProfAuthrtSbjctQuizList(Map<String, Object> params);

	QuizMainView getQuizSelect(ExamBscVO vo);

	QuizMainView loadProfQuizQstnMngView(ExamBscVO vo, UserContext userCtx);

	QuizMainView getQuizTeamGrpSubQuizList(ExamDtlVO vo);

	QuizMainView getQuizQstnList(QstnVO vo);

	QuizMainView getQuizQstnVwitmList(QstnVwitmVO vo);

	void quizQstnRegist(QstnVO vo, String qstnsStr);

	void quizQstnModify(QstnVO vo, String qstnsStr);

	void qstnSeqnoModify(QstnVO vo);

	void qstnCnddtSeqnoModify(QstnVO vo);

	QuizMainView qstnSelect(QstnVO vo);

	void quizQstnDelete(QstnVO vo);

	void quizQstnScrModify(QstnVO vo);

	void quizQstnScrBulkModify(QstnVO vo);

	void cmptnYQuizQstnScrBulkModify(List<Map<String, Object>> list);

	void quizQstnCopy(List<Map<String, Object>> list);

	void quizQstnsCmptnModify(ExamBscVO vo);

	Integer tkexamStrtUserCntSelect(ExamDtlVO vo);

	void quizQstnOptionModify(QstnVO vo, String qstnsStr);

	QuizMainView loadProfQuizQstnCopyPopup(ExamDtlVO vo);

	QuizMainView getCopyQstnSbjctList(SbjctVO vo);

	QuizMainView getCopyQstnQuizList(ExamDtlVO vo);

	QuizMainView getQstnCopyQuizQstnList(QstnVO vo);

	QuizMainView getQstnExcelSampleData(QstnVO vo);

	QuizMainView qstnExcelUpload(QstnVO vo);

	QuizMainView loadProfQuizExampprPreviewPopup(ExamBscVO vo);

	QuizMainView loadProfQuizRetkexamMngView(ExamBscVO vo);

	QuizMainView getQuizTkexamList(Map<String, Object> params);

	QuizMainView loadProfQuizTkexamHstryPopup(TkexamVO vo);

	QuizMainView loadProfQuizExampprEvlPopup(Map<String, Object> params);

	void quizRetkexamSetting(List<ExamDtlVO> list);

	QuizMainView loadProfQuizEvlMngView(ExamBscVO vo);

	QuizMainView loadProfQuizMemoPopup(Map<String, Object> params);

	void profMemoModify(Map<String, Object> params);

	void quizExampprInit(Map<String, Object> params);

	void quizEvlScrBulkModify(List<Map<String, Object>> list);

	void quizScrExcelUpload(ExamBscVO vo);

	QuizMainView getQuizTkexamStatus(ExamBscVO vo);

	QuizMainView getQuizExampprBulkExcelDown(ExamBscVO vo);

	QuizMainView loadProfQuizExampprBulkPrintPopup(Map<String, Object> params);

	QuizMainView getTkexamExampprAnswShtList(TkexamVO vo);

	void tkexamAnswShtScrModify(List<Map<String, Object>> list);

	QuizMainView getQuizQstnStatusChart(Map<String, Object> params);

	QuizMainView getProfExrcsSddnQstnBscList(QuizPageInfo pageInfo);

	QuizMainView loadProfExrcsQstnExampprPreviewPopup(ExrcsSddnQstnBscVO vo);

	QuizMainView loadProfExrcsQstnRegistView(ExrcsSddnQstnBscVO vo);

	QuizMainView exrcsQstnRegist(ExrcsSddnQstnBscVO vo);

	QuizMainView loadProfExrcsQstnModifyView(ExrcsSddnQstnBscVO vo, UserContext userCtx);

	QuizMainView exrcsQstnModify(ExrcsSddnQstnBscVO vo);

	void exrcsQstnBulkQstnRegist(QstnVO vo, String qstnsStr);

	void exrcsQstnBulkQstnModify(QstnVO vo, String qstnsStr);

	void exrcsQstnBulkQstnSeqnoModify(QstnVO vo);

	void exrcsQstnBulkQstnDelete(QstnVO vo);

	QuizMainView loadProfExrcsQstnCopyPopup(ExrcsSddnQstnBscVO vo);

	QuizMainView getQstnCopyExrcsQstnList(ExrcsSddnQstnBscVO vo);

	QuizMainView getProfQstnCopyExrcsQstnList(QstnVO vo);

	void profExrcsQstnCopy(List<Map<String, Object>> list);

	void exrcsQstnsCmptnModify(ExrcsSddnQstnBscVO vo);

	QuizMainView loadProfSddnQuizRegistView(ExrcsSddnQstnBscVO vo, UserContext userCtx);

	void sddnQuizRegist(ExrcsSddnQstnBscVO vo, QstnVO qstn, String qstnsStr);

	QuizMainView loadProfSddnQuizModifyView(ExrcsSddnQstnBscVO vo, UserContext userCtx);

	void sddnQuizModify(ExrcsSddnQstnBscVO vo, QstnVO qstn, String qstnsStr);

	int getLctrWknoRegistQstnCntSelect(Map<String, Object> params);

	/*****************************************************
     *						학생 화면	 					*
     ******************************************************/

	QuizMainView getStdntQuizList(QuizPageInfo pageInfo);

	QuizMainView loadStdntQuizInfoView(ExamBscVO bsc, ExamDtlVO dtl, UserContext userCtx);

	QuizMainView getStdntQuizTkexamHstryList(TkexamHstryVO vo);

	QuizMainView loadStdntQuizTkexamPrepInfoPopup(ExamDtlVO vo, UserContext userCtx);

	QuizMainView loadStdntQuizTkexamPopup(ExamDtlVO vo, UserContext userCtx);

	void stdntSsnlQstnTempSave(Map<String, Object> params);

	void stdntQstnBulkTempSave(Map<String, Object> params);

	void stdntQuizExampprSbmsn(Map<String, Object> params);

	void stdntQuizTkexamMntsModify(Map<String, Object> params);

	QuizMainView loadStdntQuizEvlExampprPopup(Map<String, Object> params);

	/*****************************************************
     *						관리자 화면	 					*
     ******************************************************/

	QuizMainView loadAdmExrcsQstnListView();

	QuizMainView getSmstrChrtList(ExamBscVO vo);

	QuizMainView getSbjctList(SubjectVO vo);

	QuizMainView getLctrWknoList(SubjectVO vo);

	QuizMainView getAdmExrcsSddnQstnBscList(QuizPageInfo pageInfo);

	QuizMainView loadAdmExrcsQstnRegistView();

	QuizMainView loadAdmExrcsQstnModifyView(ExrcsSddnQstnBscVO vo, UserContext userCtx);

	QuizMainView loadAdmSddnQuizListView();

	QuizMainView loadAdmSddnQuizRegistView(ExrcsSddnQstnBscVO vo, UserContext userCtx);

	QuizMainView loadAdmSddnQuizModifyView(ExrcsSddnQstnBscVO vo, UserContext userCtx);

}
