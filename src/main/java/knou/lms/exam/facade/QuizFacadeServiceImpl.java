package knou.lms.exam.facade;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.service.ExampprService;
import knou.lms.exam.service.ExrcsSddnQstnBscService;
import knou.lms.exam.service.QstnService;
import knou.lms.exam.service.QstnVwitmService;
import knou.lms.exam.service.TkexamAnswShtService;
import knou.lms.exam.service.TkexamHstryService;
import knou.lms.exam.service.TkexamRsltService;
import knou.lms.exam.service.TkexamService;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.ExrcsSddnQstnBscVO;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;
import knou.lms.exam.vo.TkexamHstryVO;
import knou.lms.exam.vo.TkexamVO;
import knou.lms.exam.web.view.QuizMainView;
import knou.lms.exam.web.view.QuizPageInfo;
import knou.lms.lecture2.service.LectureScheduleService;
import knou.lms.org.service.OrgService;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

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

    @Resource(name="tkexamAnswShtService")
    private TkexamAnswShtService tkexamAnswShtService;

    @Resource(name="exrcsSddnQstnBscService")
    private ExrcsSddnQstnBscService exrcsSddnQstnBscService;

    @Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;

    @Resource(name="orgService")
    private OrgService orgService;

    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    /*****************************************************
     *						교수 화면	 					*
     ******************************************************/

    @Override
	public QuizMainView getProfQuizList(QuizPageInfo pageInfo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 교수퀴즈목록조회
    	quizMainView.setResultDTO(examService.profQuizListPaging(pageInfo));

		return quizMainView;
	}

    @Override
    public void quizMrkOynModify(ExamBscVO vo) {
    	// 시험기본수정
    	examService.examBscModify(vo);
    }

    @Override
    public void quizMrkRfltrtListModify(List<ExamBscVO> list) {
    	// 퀴즈성적반영비율목록수정
    	examService.quizMrkRfltrtListModify(list);
    }

	@Override
	public QuizMainView loadProfQuizRegistView(ExamBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();

		// 과목분반목록조회
		egovListMap.put("dvclasList", examService.sbjctDvclasList(vo.getSbjctId()));

		// 강의주차목록조회
		egovListMap.put("lctrWknoList", examService.lctrWknoList(vo.getSbjctId()));

		quizMainView.setEgovListMap(egovListMap);

        return quizMainView;
    }

	@Override
	public QuizMainView quizRegist(ExamBscVO vo, Map<String, String> subMap) {
		QuizMainView quizMainView = new QuizMainView();

		// 퀴즈등록
		quizMainView.setExamBscVO(examService.quizRegist(vo, subMap));

		return quizMainView;
	}

    @Override
    public QuizMainView loadProfQuizModifyView(ExamBscVO vo) {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈정보조회
        quizMainView.setExamBscVO(examService.quizSelect(vo));

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();

		// 퀴즈그룹과목목록조회
		egovListMap.put("dvclasList", examService.quizGrpSbjctList(vo.getExamBscId()));

		// 강의주차목록조회
		egovListMap.put("lctrWknoList", examService.lctrWknoList(vo.getSbjctId()));

		quizMainView.setEgovListMap(egovListMap);

        return quizMainView;
    }

    @Override
    public QuizMainView quizModify(ExamBscVO vo, Map<String, String> subMap) {
    	QuizMainView quizMainView = new QuizMainView();

		// 퀴즈수정
		quizMainView.setExamBscVO(examService.quizModify(vo, subMap));

		return quizMainView;
    }

    @Override
    public void quizDelete(ExamBscVO vo) {
    	// 퀴즈삭제
    	examService.quizDelete(vo);
    }

    @Override
    public QuizMainView loadProfBfrQuizCopyPopup(ExamBscVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 학기기수목록조회
    	quizMainView.setEgovList(examService.qstnCopySmstrList(vo.getOrgId(), ""));

    	return quizMainView;
    }

    @Override
    public QuizMainView getProfAuthrtSbjctQuizList(Map<String, Object> params) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 교수권한과목퀴즈목록조회
    	quizMainView.setEgovList(examService.profAuthrtSbjctQuizList(params));

    	return quizMainView;
    }

    @Override
    public QuizMainView getQuizSelect(ExamBscVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 퀴즈정보조회
    	quizMainView.setExamBscVO(examService.quizSelect(vo));

    	return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizQstnMngView(ExamBscVO vo, UserContext userCtx) {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈정보조회
        quizMainView.setExamBscVO(examService.quizSelect(vo));

        if("QUIZ_TEAM".equals(quizMainView.getExamBscVO().getExamGbncd())) {
            // 퀴즈팀목록조회
            quizMainView.setEgovList(examService.quizTeamList(vo.getExamBscId()));

            // 퀴즈팀문제출제완료여부조회
            quizMainView.setIsQstnsCmptn(examService.quizTeamQstnsCmptnynSelect(vo.getExamBscId()));
        }

        try {
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
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        return quizMainView;
    }

    @Override
    public QuizMainView getQuizTeamGrpSubQuizList(ExamDtlVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 퀴즈팀그룹부퀴즈목록조회
    	quizMainView.setExamDtlList(examService.quizTeamGrpSubQuizList(vo));

    	return quizMainView;
    }

    @Override
    public QuizMainView getQuizQstnList(QstnVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 문항목록조회
    	List<QstnVO> qstnList = qstnService.qstnList(vo);
    	if(qstnList != null && !qstnList.isEmpty() && qstnList.size() > 0) {
    		// 문항개수조회
            int qstnCnt = qstnService.qstnCntSelect(vo);
            if(qstnCnt >= 0) {
                qstnList.get(0).setQstnCnt(qstnCnt);
            }
            quizMainView.setQstnList(qstnList);
        }

    	return quizMainView;
    }

    @Override
    public QuizMainView getQuizQstnVwitmList(QstnVwitmVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 문항보기항목목록조회
    	quizMainView.setQstnVwitmList(qstnVwitmService.qstnVwitmList(vo));

    	return quizMainView;
    }

    @Override
    public void quizQstnRegist(QstnVO vo, String qstnsStr) {
    	// 퀴즈문항등록
    	qstnService.quizQstnRegist(vo, qstnsStr);
    }

    @Override
    public void quizQstnModify(QstnVO vo, String qstnsStr) {
    	// 퀴즈문항수정
    	qstnService.quizQstnModify(vo, qstnsStr);
    }

    @Override
    public void qstnSeqnoModify(QstnVO vo) {
    	// 문항순번수정
    	qstnService.qstnSeqnoModify(vo);
    }

    @Override
    public void qstnCnddtSeqnoModify(QstnVO vo) {
    	// 문항후보순번수정
    	qstnService.qstnCnddtSeqnoModify(vo);
    }

    @Override
    public QuizMainView qstnSelect(QstnVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 문항조회
    	quizMainView.setQstnVO(qstnService.qstnSelect(vo));

    	return quizMainView;
    }

    @Override
    public void quizQstnDelete(QstnVO vo) {
    	// 퀴즈문항삭제
    	qstnService.quizQstnDelete(vo);
    }

    @Override
    public void quizQstnScrModify(QstnVO vo) {
    	// 퀴즈문항점수수정
    	qstnService.quizQstnScrModify(vo);
    }

    @Override
    public void quizQstnScrBulkModify(QstnVO vo) {
    	// 퀴즈문항점수일괄수정
    	qstnService.quizQstnScrBulkModify(vo);
    }

    @Override
    public void cmptnYQuizQstnScrBulkModify(List<Map<String, Object>> list) {
    	// 출제완료퀴즈문항점수일괄수정
    	qstnService.cmptnYQuizQstnScrBulkModify(list);
    }

    @Override
    public void quizQstnCopy(List<Map<String, Object>> list) {
    	// 퀴즈문항가져오기
    	qstnService.quizQstnCopy(list);
    }

    @Override
    public void quizQstnsCmptnModify(ExamBscVO vo) {
    	// 퀴즈문제출제완료수정
    	examService.quizQstnsCmptnModify(vo);
    }

    @Override
    public Integer tkexamStrtUserCntSelect(ExamDtlVO vo) {
    	// 시험응시시작사용자수조회
    	return examService.tkexamStrtUserCntSelect(vo);
    }

    @Override
    public void quizQstnOptionModify(QstnVO vo, String qstnsStr) {
    	// 퀴즈문항옵션수정
    	qstnService.quizQstnOptionModify(vo,qstnsStr);
    }

    @Override
    public QuizMainView loadProfQuizQstnCopyPopup(ExamDtlVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 학기기수목록조회
    	quizMainView.setEgovList(examService.qstnCopySmstrList(vo.getOrgId(), ""));

    	return quizMainView;
    }

    @Override
    public QuizMainView getCopyQstnSbjctList(SbjctVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 문제가져오기과목목록조회
    	quizMainView.setEgovList(examService.qstnCopySbjctList(vo.getSmstrChrtId(), vo.getSbjctId()));

    	return quizMainView;
    }

    @Override
    public QuizMainView getCopyQstnQuizList(ExamDtlVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 문제가져오기퀴즈목록조회
    	quizMainView.setExamDtlList(examService.qstnCopyQuizList(vo.getSbjctId()));

    	return quizMainView;
    }

    @Override
    public QuizMainView getQstnCopyQuizQstnList(QstnVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 교수문항복사퀴즈문항목록조회
    	quizMainView.setEgovList(qstnService.profQstnCopyQuizQstnList(vo));

    	return quizMainView;
    }

    @Override
    public QuizMainView getQstnExcelSampleData(QstnVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 문항엑셀샘플데이터
    	quizMainView.setQstnExcelSampleData(qstnService.qstnExcelSampleData(vo));

    	return quizMainView;
    }

    @Override
    public QuizMainView qstnExcelUpload(QstnVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 문항엑셀업로드
    	quizMainView.setResultDTO(qstnService.qstnExcelUpload(vo));

    	return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizExampprPreviewPopup(ExamBscVO vo) {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈 정보 조회
        ExamBscVO bscVO = examService.quizSelect(vo);
        quizMainView.setExamBscVO(bscVO);

        // 팀 퀴즈
        if("QUIZ_TEAM".equals(bscVO.getExamGbncd())) {
            // 퀴즈팀목록조회
            quizMainView.setEgovList(examService.quizTeamList(vo.getExamBscId()));
        }

        // 교수미리보기문항목록조회
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("examBscId", vo.getExamBscId());
        if(vo.getExamDtlVO() != null && vo.getExamDtlVO().getExamDtlId() != null) {
        	params.put("examDtlId", vo.getExamDtlVO().getExamDtlId());
        } else {
        	params.put("examDtlId", bscVO.getExamDtlVO().getExamDtlId());
        }
        quizMainView.setQstnList(qstnService.profPreviewQstnList(params));

        List<Map<String, Object>> filteredList = quizMainView.getQstnList().stream()
        	    .map(item -> {
        	        Map<String, Object> map = new LinkedHashMap<>();
        	        map.put("qstnId",       item.getQstnId());
        	        map.put("qstnSeqno",    item.getQstnSeqno());
        	        map.put("searchValue",	item.getSearchValue());
        	        return map;
        	    })
        	    .collect(Collectors.toList());

        // 교수미리보기문항보기항목목록조회
        quizMainView.setQstnVwitmList(qstnVwitmService.profPreviewQstnVwitmList(filteredList));

        return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizRetkexamMngView(ExamBscVO vo) {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈 정보 조회
        ExamBscVO bscVO = examService.quizSelect(vo);
        quizMainView.setExamBscVO(bscVO);

        // 팀 퀴즈
        if("QUIZ_TEAM".equals(bscVO.getExamGbncd())) {
            // 퀴즈팀목록조회
            quizMainView.setEgovList(examService.quizTeamList(vo.getExamBscId()));
        }

        return quizMainView;
	}

    @Override
    public QuizMainView getQuizTkexamList(Map<String, Object> params) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 퀴즈응시목록조회
    	quizMainView.setEgovList(tkexamService.quizTkexamList(params));

    	return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizTkexamHstryPopup(TkexamVO vo) {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈응시자조회
        quizMainView.setEgovMap(tkexamService.quizExamneeSelect(vo.getExamDtlId(), vo.getUserId()));

        // 교수퀴즈응시이력목록조회
        quizMainView.setEgovList(tkexamHstryService.profQuizTkexamHstryList(vo.getExamDtlId(), vo.getUserId()));

        return quizMainView;
    }

    @Override
    public QuizMainView loadProfQuizExampprEvlPopup(Map<String, Object> params) {
        QuizMainView quizMainView = new QuizMainView();

        // 퀴즈 정보 조회
        ExamBscVO bscVO = new ExamBscVO();
        bscVO.setExamBscId((String) params.get("examBscId"));
        ExamDtlVO dtl = new ExamDtlVO();
        dtl.setExamDtlId((String) params.get("examDtlId"));
        bscVO.setExamDtlVO(dtl);
        quizMainView.setExamBscVO(examService.quizSelect(bscVO));

        // 퀴즈응시자조회
        quizMainView.setEgovMap(tkexamService.quizExamneeSelect((String) params.get("examDtlId"), (String) params.get("userId")));

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        // 퀴즈응시목록조회
        String userId = (String) params.get("userId");
        params.remove("userId");
        egovListMap.put("tkexamList", tkexamService.quizTkexamList(params));
        params.put("userId", userId);

        // 시험응시시험지답안목록조회
        egovListMap.put("answShtList", exampprService.tkexamExampprAnswShtList((String) quizMainView.getEgovMap().get("tkexamId"), (String) params.get("userId")));
        quizMainView.setEgovListMap(egovListMap);

        return quizMainView;
    }

    @Override
    public void quizRetkexamSetting(List<ExamDtlVO> list) {
    	// 퀴즈재응시설정
    	tkexamService.quizRetkexamSetting(list);
    }

	@Override
	public QuizMainView loadProfQuizEvlMngView(ExamBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 퀴즈 정보 조회
		ExamBscVO bscVO = examService.quizSelect(vo);
		quizMainView.setExamBscVO(bscVO);

		return quizMainView;
	}

	@Override
	public QuizMainView loadProfQuizMemoPopup(Map<String, Object> params) {
		QuizMainView quizMainView = new QuizMainView();

		// 퀴즈 정보 조회
		ExamBscVO bscVO = new ExamBscVO();
		bscVO.setExamBscId((String) params.get("examBscId"));
		bscVO = examService.quizSelect(bscVO);
		bscVO.getExamDtlVO().setExamDtlId((String) params.get("examDtlId"));
		quizMainView.setExamBscVO(bscVO);

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 퀴즈응시자조회
		eMap.put("examnee", tkexamService.quizExamneeSelect((String) params.get("examDtlId"), (String) params.get("userId")));

		// 교수메모조회
		eMap.put("profMemo", tkexamRsltService.profMemoSelect((String) params.get("tkexamId"), (String) params.get("userId")));
		quizMainView.seteMap(eMap);

		return quizMainView;
	}

	@Override
	public void profMemoModify(Map<String, Object> params) {
		// 교수메모수정
		tkexamRsltService.profMemoModify(params);
	}

	@Override
	public void quizExampprInit(Map<String, Object> params) {
		// 퀴즈시험지초기화
		tkexamService.quizExampprInit(params);
	}

	@Override
	public void quizEvlScrBulkModify(List<Map<String, Object>> list) {
		// 교수퀴즈평가점수일괄수정
		tkexamRsltService.profQuizEvlScrBulkModify(list);
	}

	@Override
	public void quizScrExcelUpload(ExamBscVO vo) {
		// 퀴즈성적엑셀업로드
		tkexamRsltService.quizScrExcelUpload(vo);
	}

	@Override
	public QuizMainView getQuizTkexamStatus(ExamBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 사용자시험응시현황조회
		quizMainView.setEgovMap(tkexamService.userTkexamStatusSelect(vo.getExamBscId(), vo.getSbjctId()));

		return quizMainView;
	}

	@Override
	public QuizMainView getQuizExampprBulkExcelDown(ExamBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 퀴즈정보조회
		quizMainView.setExamBscVO(examService.quizSelect(vo));
		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
		String examGbncd = StringUtil.nvl(quizMainView.getExamBscVO().getExamGbncd());
		// 팀 퀴즈, 팀 퀴즈 중간고사, 팀 퀴즈 기말고사
		if("QUIZ_TEAM".equals(examGbncd) || "QUIZ_EXAM_MID_TEAM".equals(examGbncd) || "QUIZ_EXAM_LST_TEAM".equals(examGbncd)) {
			// 퀴즈팀목록조회
			egovListMap.put("teamList", examService.quizTeamList(vo.getExamBscId()));
		}

		// 시험지일괄엑셀다운퀴즈대상자목록조회
		egovListMap.put("trgtr", examService.exampprBulkExcelDownQuizTrgtrList(vo));

		// 시험지일괄엑셀다운퀴즈문항목록
		egovListMap.put("qstn", exampprService.exampprBulkExcelDownQuizQstnList(vo));
		quizMainView.setEgovListMap(egovListMap);

		return quizMainView;
	}

	@Override
	public QuizMainView loadProfQuizExampprBulkPrintPopup(Map<String, Object> params) {
		QuizMainView quizMainView = new QuizMainView();

		// 퀴즈 정보 조회
		ExamBscVO bscVO = new ExamBscVO();
		bscVO.setExamBscId((String) params.get("examBscId"));
		quizMainView.setExamBscVO(examService.quizSelect(bscVO));

		// 퀴즈응시목록조회
		quizMainView.setEgovList(tkexamService.quizTkexamList(params));

		return quizMainView;
	}

	@Override
	public QuizMainView getTkexamExampprAnswShtList(TkexamVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 시험응시시험지답안목록조회
		quizMainView.setEgovList(exampprService.tkexamExampprAnswShtList(vo.getTkexamId(), vo.getUserId()));

		return quizMainView;
	}

	@Override
	public void tkexamAnswShtScrModify(List<Map<String, Object>> list) {
		// 시험응시답안점수수정
		tkexamAnswShtService.tkexamAnswShtScrModify(list);
	}

	@Override
	public QuizMainView getQuizQstnStatusChart(Map<String, Object> params) {
		QuizMainView quizMainView = new QuizMainView();

		Map<String, ResultDTO<EgovMap>> resultMap = new HashMap<String, ResultDTO<EgovMap>>();
		// 퀴즈문항분포바차트
		resultMap.put("barChart", qstnService.quizQstnDistributionBarChart(params));

		// 퀴즈문항정답현황파이차트
		resultMap.put("pieChart", qstnService.quizQstnCransStatusPieChart(params));
		quizMainView.setResultMap(resultMap);

		return quizMainView;
	}

	@Override
	public QuizMainView getProfExrcsSddnQstnBscList(QuizPageInfo pageInfo) {
		QuizMainView quizMainView = new QuizMainView();

		// 교수연습돌발문항기본목록페이징
		quizMainView.setResultDTO(exrcsSddnQstnBscService.profExrcsSddnQstnBscListPaging(pageInfo));

		return quizMainView;
	}

	@Override
	public QuizMainView loadProfExrcsQstnExampprPreviewPopup(ExrcsSddnQstnBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 연습돌발문항기본조회
		quizMainView.setEgovMap(exrcsSddnQstnBscService.exrcsSddnQstnBscSelect(vo));

        // 문항 목록 조회
        QstnVO qstnVO = new QstnVO();
        qstnVO.setExrcsSddnQstnBscId(vo.getExrcsSddnQstnBscId());
        qstnVO.setQstnGbncd(vo.getQstnGbncd());
        quizMainView.setQstnList(qstnService.qstnList(qstnVO));

        // 문항보기항목 목록 조회
        quizMainView.setQstnVwitmList(qstnVwitmService.qstnVwitmBulkList(qstnVO));

		return quizMainView;
	}

	@Override
	public QuizMainView loadProfExrcsQstnRegistView(ExrcsSddnQstnBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 과목분반목록조회
        quizMainView.setEgovList(examService.sbjctDvclasList(vo.getSbjctId()));

		return quizMainView;
	}

	@Override
	public QuizMainView exrcsQstnRegist(ExrcsSddnQstnBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 연습문제등록
		quizMainView.setExrcsSddnQstnBscVO(exrcsSddnQstnBscService.exrcsQstnRegist(vo));

		return quizMainView;
	}

	@Override
	public QuizMainView loadProfExrcsQstnModifyView(ExrcsSddnQstnBscVO vo, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		// 과목분반목록조회
        quizMainView.setEgovList(examService.sbjctDvclasList(vo.getSbjctId()));

        // 연습돌발문항기본조회
        quizMainView.setEgovMap(exrcsSddnQstnBscService.exrcsSddnQstnBscSelect(vo));

        try {
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
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return quizMainView;
	}

	@Override
	public QuizMainView exrcsQstnModify(ExrcsSddnQstnBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 연습문제수정
		quizMainView.setExrcsSddnQstnBscVO(exrcsSddnQstnBscService.exrcsQstnModify(vo));

		return quizMainView;
	}

	@Override
	public void exrcsQstnBulkQstnRegist(QstnVO vo, String qstnsStr) {
		// 연습문제일괄문항등록
		qstnService.exrcsQstnBulkQstnRegist(vo, qstnsStr);
	}

	@Override
	public void exrcsQstnBulkQstnModify(QstnVO vo, String qstnsStr) {
		// 연습문제일괄문항수정
		qstnService.exrcsQstnBulkQstnModify(vo, qstnsStr);
	}

	@Override
	public void exrcsQstnBulkQstnSeqnoModify(QstnVO vo) {
		// 연습문제일괄문항순번수정
		qstnService.exrcsQstnBulkQstnSeqnoModify(vo);
	}

	@Override
	public void exrcsQstnBulkQstnDelete(QstnVO vo) {
		// 연습문제일괄문항삭제
		qstnService.exrcsQstnBulkQstnDelete(vo);
	}

	@Override
    public QuizMainView loadProfExrcsQstnCopyPopup(ExrcsSddnQstnBscVO vo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 학기기수목록조회
    	quizMainView.setEgovList(examService.qstnCopySmstrList(vo.getOrgId(), ""));

    	return quizMainView;
    }

	@Override
	public QuizMainView getQstnCopyExrcsQstnList(ExrcsSddnQstnBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

    	// 문제가져오기연습문제목록조회
    	quizMainView.setExrcsQstnBscList(exrcsSddnQstnBscService.qstnCopyExrcsQstnList(vo.getSbjctId()));

    	return quizMainView;
	}

	@Override
	public QuizMainView getProfQstnCopyExrcsQstnList(QstnVO vo) {
		QuizMainView quizMainView = new QuizMainView();

    	// 교수문항복사연습문제목록조회
		quizMainView.setEgovList(qstnService.profQstnCopyExrcsQstnList(vo));

    	return quizMainView;
	}

	@Override
	public void profExrcsQstnCopy(List<Map<String, Object>> list) {
		// 연습문제일괄가져오기
		qstnService.exrcsQstnBulkCopy(list);
	}

	@Override
	public void exrcsQstnsCmptnModify(ExrcsSddnQstnBscVO vo) {
		// 연습문제출제완료수정
		exrcsSddnQstnBscService.exrcsQstnsCmptnModify(vo);
	}

	@Override
	public QuizMainView loadProfSddnQuizRegistView(ExrcsSddnQstnBscVO vo, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		SubjectDTO sbjctDto = new SubjectDTO(userCtx, vo.getSbjctId());

		// 교수강의주차일정목록조회
		quizMainView.setEgovList(lectureScheduleService.profLectureScheduleList(sbjctDto));
		try {
			Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
	        // 문항답변유형코드 목록 조회
	        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
	        qstnRspnsTycdList.removeIf(item -> !("ONE_CHC".equals(item.getCd()) || "MLT_CHC".equals(item.getCd())));
	        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

	        // 문항난이도유형코드 목록 조회
	        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_DFCTLV_TYCD").getReturnList();
	        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
	        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

	        quizMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return quizMainView;
	}

	@Override
	public void sddnQuizRegist(ExrcsSddnQstnBscVO vo, QstnVO qstn, String qstnsStr) {
		// 돌발퀴즈등록
		exrcsSddnQstnBscService.sddnQuizRegist(vo, qstn, qstnsStr);
	}

	@Override
	public QuizMainView loadProfSddnQuizModifyView(ExrcsSddnQstnBscVO vo, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		SubjectDTO sbjctDto = new SubjectDTO(userCtx, vo.getSbjctId());

		// 연습돌발문항기본조회
		quizMainView.setEgovMap(exrcsSddnQstnBscService.exrcsSddnQstnBscSelect(vo));

		// 교수강의주차일정목록조회
		quizMainView.setEgovList(lectureScheduleService.profLectureScheduleList(sbjctDto));

		try {
			Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
	        // 문항답변유형코드 목록 조회
	        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
	        qstnRspnsTycdList.removeIf(item -> !("ONE_CHC".equals(item.getCd()) || "MLT_CHC".equals(item.getCd())));
	        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

	        // 문항난이도유형코드 목록 조회
	        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_DFCTLV_TYCD").getReturnList();
	        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
	        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

	        quizMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return quizMainView;
	}

	@Override
	public void sddnQuizModify(ExrcsSddnQstnBscVO vo, QstnVO qstn, String qstnsStr) {
		// 돌발퀴즈수정
		exrcsSddnQstnBscService.sddnQuizModify(vo, qstn, qstnsStr);
	}

	@Override
	public int getLctrWknoRegistQstnCntSelect(Map<String, Object> params) {
		// 강의주차등록문항수조회
		return qstnService.lctrWknoRegistQstnCntSelect(params);
	}

	/*****************************************************
     *						학생 화면	 					*
     ******************************************************/

	@Override
	public QuizMainView getStdntQuizList(QuizPageInfo pageInfo) {
    	QuizMainView quizMainView = new QuizMainView();

    	// 학생퀴즈목록조회
    	quizMainView.setResultDTO(examService.stdntQuizListPaging(pageInfo));

		return quizMainView;
	}

	@Override
	public QuizMainView loadStdntQuizInfoView(ExamBscVO bsc, ExamDtlVO dtl, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("examBscId", bsc.getExamBscId());
		map.put("examDtlId", dtl.getExamDtlId());
		map.put("sbjctId", bsc.getSbjctId());
		map.put("userId", userCtx.getUserId());

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 학생퀴즈조회
		eMap.put("vo", examService.stdntQuizSelect(map));

        // 학생시험응시결과조회
        eMap.put("rslt", tkexamRsltService.stdntTkexamRsltSelect(map));
        quizMainView.seteMap(eMap);

		return quizMainView;
	}

	@Override
	public QuizMainView getStdntQuizTkexamHstryList(TkexamHstryVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 학생퀴즈응시이력조회
		quizMainView.setEgovList(tkexamHstryService.stdntQuizTkexamHstryList(vo));

		return quizMainView;
	}

	@Override
	public QuizMainView loadStdntQuizTkexamPrepInfoPopup(ExamDtlVO vo, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("examBscId", vo.getExamBscId());
		map.put("examDtlId", vo.getExamDtlId());
		map.put("sbjctId", vo.getSbjctId());
		map.put("userId", userCtx.getUserId());

		// 학생퀴즈조회
        quizMainView.setEgovMap(examService.stdntQuizSelect(map));

		return quizMainView;
	}

	@Override
	public QuizMainView loadStdntQuizTkexamPopup(ExamDtlVO vo, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("examBscId", vo.getExamBscId());
		map.put("examDtlId", vo.getExamDtlId());
		map.put("sbjctId", vo.getSbjctId());
		map.put("userId", userCtx.getUserId());
		map.put("rgtrId", userCtx.getUserId());
		map.put("ip", userCtx.getIP());

		// 학생퀴즈조회
        quizMainView.setEgovMap(examService.stdntQuizSelect(map));

        // 학생퀴즈응시
        quizMainView.setResultDTO(tkexamService.stdntQuizTkexam(map));

		return quizMainView;
	}

	@Override
	public void stdntSsnlQstnTempSave(Map<String, Object> params) {
		// 학생단일문항임시저장
		tkexamAnswShtService.stdntSsnlQstnTempSave(params);
	}

	@Override
	public void stdntQstnBulkTempSave(Map<String, Object> params) {
		// 학생문항일괄임시저장
		tkexamAnswShtService.stdntQstnBulkTempSave(params);
	}

	@Override
	public void stdntQuizExampprSbmsn(Map<String, Object> params) {
		// 학생퀴즈시험지제출
		tkexamAnswShtService.stdntQuizExampprSbmsn(params);
	}

	@Override
	public void stdntQuizTkexamMntsModify(Map<String, Object> params) {
		// 퀴즈시험지이력등록
		tkexamAnswShtService.quizExampprHstryRegist(params, "EXAMPPR_TMP_SAVE");
	}

	@Override
	public QuizMainView loadStdntQuizEvlExampprPopup(Map<String, Object> params) {
		QuizMainView quizMainView = new QuizMainView();

        // 퀴즈 정보 조회
        ExamBscVO bscVO = new ExamBscVO();
        bscVO.setExamBscId((String) params.get("examBscId"));
        quizMainView.setExamBscVO(examService.quizSelect(bscVO));

        // 퀴즈응시자조회
        quizMainView.setEgovMap(tkexamService.quizExamneeSelect((String) params.get("examDtlId"), (String) params.get("userId")));

        // 시험응시시험지답안목록조회
        quizMainView.setEgovList(exampprService.tkexamExampprAnswShtList((String) quizMainView.getEgovMap().get("tkexamId"), (String) params.get("userId")));

        return quizMainView;
	}

	/*****************************************************
     *						관리자 화면	 					*
     ******************************************************/

	@Override
	public QuizMainView loadAdmExrcsQstnListView() {
		QuizMainView quizMainView = new QuizMainView();

		// 기관목록조회
		quizMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		quizMainView.setEgovMap(egovMap);

		return quizMainView;
	}

	@Override
	public QuizMainView getSmstrChrtList(ExamBscVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 학기기수목록조회
    	quizMainView.setEgovList(examService.qstnCopySmstrList(vo.getOrgId(), vo.getDgrsYr()));

		return quizMainView;
	}

	@Override
	public QuizMainView getSbjctList(SubjectVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 과목목록조회
    	quizMainView.setEgovList(examService.smstrChrtSbjctList(vo.getOrgId(), vo.getSmstrChrtId(), vo.getSbjctYr()));

		return quizMainView;
	}

	@Override
	public QuizMainView getLctrWknoList(SubjectVO vo) {
		QuizMainView quizMainView = new QuizMainView();

		// 강의주차목록조회
		quizMainView.setEgovList(examService.lctrWknoList(vo.getSbjctId()));

		return quizMainView;
	}

	@Override
	public QuizMainView getAdmExrcsSddnQstnBscList(QuizPageInfo pageInfo) {
		QuizMainView quizMainView = new QuizMainView();

		// 관리자연습돌발문항기본목록페이징
		quizMainView.setResultDTO(exrcsSddnQstnBscService.admExrcsSddnQstnBscListPaging(pageInfo));

		return quizMainView;
	}

	@Override
	public QuizMainView loadAdmExrcsQstnRegistView() {
		QuizMainView quizMainView = new QuizMainView();

		// 기관목록조회
		quizMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		quizMainView.setEgovMap(egovMap);

		return quizMainView;
	}

	@Override
	public QuizMainView loadAdmExrcsQstnModifyView(ExrcsSddnQstnBscVO vo, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		// 기관목록조회
		quizMainView.setOrgList(orgService.orgListSelect());

		try {
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
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));			// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());							// 현재학기
		egovMap.put("vo", exrcsSddnQstnBscService.exrcsSddnQstnBscSelect(vo));	// 연습돌발문항기본조회
		quizMainView.setEgovMap(egovMap);

		return quizMainView;
	}

	@Override
	public QuizMainView loadAdmSddnQuizListView() {
		QuizMainView quizMainView = new QuizMainView();

		// 기관목록조회
		quizMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		quizMainView.setEgovMap(egovMap);

		return quizMainView;
	}

	@Override
	public QuizMainView loadAdmSddnQuizRegistView(ExrcsSddnQstnBscVO vo, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		// 기관목록조회
		quizMainView.setOrgList(orgService.orgListSelect());

		try {
			Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
	        // 문항답변유형코드 목록 조회
	        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
	        qstnRspnsTycdList.removeIf(item -> !("ONE_CHC".equals(item.getCd()) || "MLT_CHC".equals(item.getCd())));
	        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

	        // 문항난이도유형코드 목록 조회
	        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_DFCTLV_TYCD").getReturnList();
	        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
	        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

	        quizMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		quizMainView.setEgovMap(egovMap);

		return quizMainView;
	}

	@Override
	public QuizMainView loadAdmSddnQuizModifyView(ExrcsSddnQstnBscVO vo, UserContext userCtx) {
		QuizMainView quizMainView = new QuizMainView();

		// 기관목록조회
		quizMainView.setOrgList(orgService.orgListSelect());

		try {
			Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
	        // 문항답변유형코드 목록 조회
	        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
	        qstnRspnsTycdList.removeIf(item -> !("ONE_CHC".equals(item.getCd()) || "MLT_CHC".equals(item.getCd())));
	        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

	        // 문항난이도유형코드 목록 조회
	        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_DFCTLV_TYCD").getReturnList();
	        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
	        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

	        quizMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));			// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());							// 현재학기
		egovMap.put("vo", exrcsSddnQstnBscService.exrcsSddnQstnBscSelect(vo));	// 연습돌발문항기본조회
		quizMainView.setEgovMap(egovMap);

		return quizMainView;
	}

}
