package knou.lms.exam.facade;

import java.util.Map;

import knou.framework.context2.UserContext;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.TkexamVO;
import knou.lms.exam.web.view.QuizMainView;

public interface QuizFacadeService {

	QuizMainView loadProfQuizRegistView(ExamBscVO vo) throws Exception;

	QuizMainView loadProfQuizModifyView(ExamBscVO vo) throws Exception;

	QuizMainView loadProfBfrQuizCopyPopup(ExamBscVO vo) throws Exception;

	QuizMainView loadProfQuizQstnMngView(ExamBscVO vo, UserContext userCtx) throws Exception;

	QuizMainView loadProfQuizQstnCopyPopup(ExamDtlVO vo) throws Exception;

	QuizMainView loadProfQuizExampprPreviewPopup(ExamBscVO vo) throws Exception;

	QuizMainView loadProfQuizRetkexamMngView(ExamBscVO vo) throws Exception;

	QuizMainView loadProfQuizTkexamHstryPopup(TkexamVO vo) throws Exception;

	QuizMainView loadProfQuizExampprEvlPopup(Map<String, Object> params) throws Exception;

	QuizMainView loadProfQuizEvlMngView(ExamBscVO vo) throws Exception;

	QuizMainView loadProfQuizMemoPopup(Map<String, Object> params) throws Exception;

	QuizMainView loadProfQuizExampprBulkPrintPopup(Map<String, Object> params) throws Exception;

}
