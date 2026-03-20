package knou.lms.exam.facade;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.exam.service.*;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.TkexamVO;
import knou.lms.exam.web.view.QuizMainView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("quizFacadeService")
public class QuizFacadeServiceImpl extends ServiceBase implements QuizFacadeService {

    private static final Logger LOGGER = LoggerFactory.getLogger(QuizFacadeServiceImpl.class);

    @Resource(name="examService")
    private ExamService examService;

    @Resource(name="qstnService")
    private QstnService qstnService;

    @Resource(name="qstnVwitmService")
    private QstnVwitmService qstnVwitmService;

    @Resource(name="tkexamService")
    private TkexamService tkexamService;

    @Resource(name="tkexamHstryService")
    private TkexamHstryService tkexamHstryService;

    @Resource(name="exampprService")
    private ExampprService exampprService;

    @Resource(name="cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name="tkexamRsltService")
	private TkexamRsltService tkexamRsltService;

	@Override
	public QuizMainView loadProfQuizRegistView(ExamBscVO vo) throws Exception {
		QuizMainView quizMainView = new QuizMainView();

        // 과목분반목록조회
        quizMainView.setSbjctDcvlasList(examService.sbjctDvclasList(vo.getSbjctId()));

        return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizModifyView(ExamBscVO vo) throws Exception {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈정보조회
        quizMainView.setExamBscVO(examService.quizSelect(vo));

        // 퀴즈그룹과목목록조회
        quizMainView.setQuizGrpSbjctList(examService.quizGrpSbjctList(vo.getExamBscId()));

        return quizMainView;
    }

    @Override
    public QuizMainView loadProfBfrQuizCopyPopup(ExamBscVO vo) throws Exception {
    	QuizMainView quizMainView = new QuizMainView();

    	// 퀴즈검색용학기기수목록조회
    	quizMainView.setQuizSearchSmstrList(examService.qstnCopySmstrList());

    	return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizQstnMngView(ExamBscVO vo, UserContext userCtx) throws Exception {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈정보조회
        quizMainView.setExamBscVO(examService.quizSelect(vo));

        if("QUIZ_TEAM".equals(quizMainView.getExamBscVO().getExamGbncd())) {
            // 퀴즈팀목록조회
            quizMainView.setQuizTeamList(examService.quizTeamList(vo.getExamBscId()));

            // 퀴즈팀문제출제완료여부조회
            quizMainView.setIsQstnsCmptn(examService.quizTeamQstnsCmptnynSelect(vo.getExamBscId()));
        }

        Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
        // 문항답변유형코드 목록 조회
        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
        qstnRspnsTycdList.removeIf(item -> "SRVY".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

        // 문항난이도유형코드 목록 조회
        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_DFCTLV_TYCD").getReturnList();
        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

        quizMainView.setCmmnCdList(cmmnCdList);

        return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizQstnCopyPopup(ExamDtlVO vo) throws Exception {
    	QuizMainView quizMainView = new QuizMainView();

    	// 퀴즈검색용학기기수목록조회
    	quizMainView.setQuizSearchSmstrList(examService.qstnCopySmstrList());

    	return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizExampprPreviewPopup(ExamBscVO vo) throws Exception {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈 정보 조회
        ExamBscVO bscVO = examService.quizSelect(vo);
        quizMainView.setExamBscVO(bscVO);

        // 팀 퀴즈
        if("QUIZ_TEAM".equals(bscVO.getExamGbncd())) {
            // 퀴즈팀목록조회
            quizMainView.setQuizTeamList(examService.quizTeamList(vo.getExamBscId()));
        }

        // 문항 목록 조회
        QstnVO qstnVO = new QstnVO();
        if(vo.getExamDtlVO() != null && vo.getExamDtlVO().getExamDtlId() != null) {
            qstnVO.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
        } else {
            qstnVO.setExamDtlId(bscVO.getExamDtlVO().getExamDtlId());
        }
        quizMainView.setQstnList(qstnService.qstnList(qstnVO));

        // 문항보기항목 목록 조회
        quizMainView.setQstnVwitmList(qstnVwitmService.qstnVwitmBulkList(bscVO.getExamDtlVO().getExamDtlId()));

        return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizRetkexamMngView(ExamBscVO vo) throws Exception {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈 정보 조회
        ExamBscVO bscVO = examService.quizSelect(vo);
        quizMainView.setExamBscVO(bscVO);

        // 팀 퀴즈
        if("QUIZ_TEAM".equals(bscVO.getExamGbncd())) {
            // 퀴즈팀목록조회
            quizMainView.setQuizTeamList(examService.quizTeamList(vo.getExamBscId()));
        }

        return quizMainView;
	}

    @Override
    public QuizMainView loadProfQuizTkexamHstryPopup(TkexamVO vo) throws Exception {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈응시자조회
        quizMainView.setQuizExamnee(tkexamService.quizExamneeSelect(vo.getExamDtlId(), vo.getUserId()));

        // 교수퀴즈응시이력목록조회
        quizMainView.setTkexamHstryList(tkexamHstryService.profQuizTkexamHstryList(vo.getExamDtlId(), vo.getUserId()));

        return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizExampprEvlPopup(Map<String, Object> params) throws Exception {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈 정보 조회
        ExamBscVO bscVO = new ExamBscVO();
        bscVO.setExamBscId((String) params.get("examBscId"));
        quizMainView.setExamBscVO(examService.quizSelect(bscVO));

        // 퀴즈응시자조회
        quizMainView.setQuizExamnee(tkexamService.quizExamneeSelect((String) params.get("examDtlId"), (String) params.get("userId")));

        // 퀴즈응시목록조회
        String userId = (String) params.get("userId");
        params.remove("userId");
        quizMainView.setQuizTkexamList(tkexamService.quizTkexamList(params));
        params.put("userId", userId);

        // 시험응시시험지답안목록조회
        quizMainView.setTkexamExampprAnswShtList(exampprService.tkexamExampprAnswShtList((String) quizMainView.getQuizExamnee().get("tkexamId"), (String) params.get("userId")));

        return quizMainView;
    }

	@Override
	public QuizMainView loadProfQuizEvlMngView(ExamBscVO vo) throws Exception {
		QuizMainView quizMainView = new QuizMainView();

		// 퀴즈 정보 조회
		ExamBscVO bscVO = examService.quizSelect(vo);
		quizMainView.setExamBscVO(bscVO);

		return quizMainView;
	}

	@Override
	public QuizMainView loadProfQuizMemoPopup(Map<String, Object> params) throws Exception {
		QuizMainView quizMainView = new QuizMainView();

		// 퀴즈 정보 조회
		ExamBscVO bscVO = new ExamBscVO();
		bscVO.setExamBscId((String) params.get("examBscId"));
		bscVO = examService.quizSelect(bscVO);
		bscVO.getExamDtlVO().setExamDtlId((String) params.get("examDtlId"));
		quizMainView.setExamBscVO(bscVO);

		// 퀴즈응시자조회
		quizMainView.setQuizExamnee(tkexamService.quizExamneeSelect((String) params.get("examDtlId"), (String) params.get("userId")));

		// 교수메모조회
		quizMainView.setProfMemo(tkexamRsltService.profMemoSelect((String) params.get("tkexamId"), (String) params.get("userId")));

		return quizMainView;
	}

	@Override
	public QuizMainView loadProfQuizExampprBulkPrintPopup(Map<String, Object> params) throws Exception {
		QuizMainView quizMainView = new QuizMainView();

		// 퀴즈 정보 조회
		ExamBscVO bscVO = new ExamBscVO();
		bscVO.setExamBscId((String) params.get("examBscId"));
		quizMainView.setExamBscVO(examService.quizSelect(bscVO));

		// 퀴즈응시목록조회
		quizMainView.setQuizTkexamList(tkexamService.quizTkexamList(params));

		return quizMainView;
	}

}
