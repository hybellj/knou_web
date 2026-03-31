package knou.lms.exam.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.QstnDAO;
import knou.lms.exam.dao.QstnVwitmDAO;
import knou.lms.exam.dao.TkexamAnswShtDAO;
import knou.lms.exam.service.QstnService;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;

@Service("qstnService")
public class QstnServiceImpl extends ServiceBase implements QstnService {

	@Resource(name="qstnDAO")
	private QstnDAO qstnDAO;

	@Resource(name="qstnVwitmDAO")
	private QstnVwitmDAO qstnVwitmDAO;

	@Resource(name="tkexamAnswShtDAO")
	private TkexamAnswShtDAO tkexamAnswShtDAO;

	@Resource(name="attachFileService")
	private AttachFileService attachFileService;

	@Resource(name="cmmnCdService")
	private CmmnCdService cmmnCdService;

	/**
	 * 문항목록조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return 문항 목록
	 * @throws Exception
	 */
	@Override
	public List<QstnVO> qstnList(QstnVO vo) throws Exception {
		return qstnDAO.qstnList(vo);
	}

	/**
	 * 문항개수조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return int
	 * @throws Exception
	 */
	@Override
	public int qstnCntSelect(QstnVO vo) throws Exception {
		return qstnDAO.qstnCntSelect(vo);
	}

	/**
     * 퀴즈문항등록
     *
     * @param QstnVO
     * @throws Exception
     */
    @Override
    public void quizQstnRegist(QstnVO vo) throws Exception {
    	// 1. 문항 등록
    	vo.setQstnId(IdGenUtil.genNewId(IdPrefixType.QSTN));
    	qstnDAO.qstnRegist(vo);

    	// 2. 문항보기항목 일괄등록
    	if (vo.getQstns() != null && !vo.getQstns().isEmpty()) {
            List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();

            for (Map<String, Object> map : vo.getQstns()) {
                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(vo.getQstnId());
                vwitm.setQstnVwitmGbncd(vo.getQstnGbncd());
                vwitm.setRgtrId(vo.getRgtrId());
                vwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
                vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
                vwitm.setCransYn((String) map.get("cransYn"));
                vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));

                vwitmList.add(vwitm);
            }
            qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);
        }
    }

    /**
     * 퀴즈문항수정
     *
     * @param QstnVO
     * @throws Exception
     */
    @Override
    public void quizQstnModify(QstnVO vo) throws Exception {
    	// 1. 문항 수정
    	qstnDAO.qstnModify(vo);

    	// 2. 기존 문항보기항목 삭제
    	QstnVwitmVO vwitmDeleteVO = new QstnVwitmVO();
    	vwitmDeleteVO.setQstnId(vo.getQstnId());
    	qstnVwitmDAO.qstnVwitmDelete(vwitmDeleteVO);

    	// 3. 신규 문항보기항목 일괄등록
        if (vo.getQstns() != null && !vo.getQstns().isEmpty()) {
            List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();

            for (Map<String, Object> map : vo.getQstns()) {
                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(vo.getQstnId());
                vwitm.setQstnVwitmGbncd(vo.getQstnGbncd());
                vwitm.setRgtrId(vo.getRgtrId());
                vwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
                vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
                vwitm.setCransYn((String) map.get("cransYn"));
                vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));

                vwitmList.add(vwitm);
            }
            qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);
        }
    }

    /**
     * 문항순번수정
     *
     * @param examDtlId 		시험상세아이디
     * @param qstnSeqno 		변경할 문항순번
     * @param searchKey 		문항순번
     * @throws Exception
     */
    @Override
    public void qstnSeqnoModify(QstnVO vo) throws Exception {
    	qstnDAO.qstnSeqnoModify(vo);
    }

    /**
	 * 문항후보순번수정
	 *
	 * @param examDtlId 		시험상세아이디
	 * @param qstnId	 		문항아이디
	 * @param qstnSeqno 		문항순번
	 * @param qstnCnddtSeqno 	변경할 문항후보순번
	 * @throws Exception
	 */
    @Override
	public void qstnCnddtSeqnoModify(QstnVO vo) throws Exception {
		qstnDAO.qstnCnddtSeqnoModify(vo);
	}

	/**
	 * 문항조회
	 *
	 * @param examDtlId 시험상세아이디
	 * @param qstnId 	문항아이디
	 * return 문항 정보
	 * @throws Exception
	 */
    @Override
	public QstnVO qstnSelect(QstnVO vo) throws Exception {
		QstnVO qstn = qstnDAO.qstnSelect(vo);
		if(qstn != null) {
			QstnVwitmVO vwitm = new QstnVwitmVO();
			vwitm.setQstnId(qstn.getQstnId());
			List<QstnVwitmVO> vwitmList = qstnVwitmDAO.qstnVwitmList(vwitm);
			qstn.setVwitmList(vwitmList);
		}

		return qstn;
	}

	/**
     * 퀴즈문항삭제
     *
     * @param QstnVO
     * @throws Exception
     */
    @Override
    public void quizQstnDelete(QstnVO vo) throws Exception {
    	// 1. 문항 삭제여부 수정
    	qstnDAO.qstnDelynModify(vo);

    	// 2. 문항 미삭제 순번 수정
    	qstnDAO.qstnDelNSeqnoModify(vo);
    }

    /**
     * 퀴즈문항점수수정
     *
     * @param examDtlId		시험상세아이디
     * @throws Exception
     */
    @Override
    public void quizQstnScrModify(QstnVO vo) throws Exception {
    	qstnDAO.quizQstnScrModify(vo);
    }

    /**
	 * 퀴즈문항점수일괄수정
	 *
	 * @param examDtlId		시험상세아이디
	 * @throws Exception
	 */
    @Override
	public void quizQstnScrBulkModify(QstnVO vo) throws Exception {
    	qstnDAO.quizQstnScrBulkModify(vo);
	}

    /**
	 * 출제완료퀴즈문항점수일괄수정
	 *
     * @param examDtlId 시험상세아이디
     * @param qstnSeqno 문항순번
     * @param qstnScr 	문항점수
	 * @throws Exception
	 */
	public void cmptnYQuizQstnScrBulkModify(List<Map<String, Object>> list) throws Exception {
		qstnDAO.cmptnYQuizQstnScrBulkModify(list);
	}

    /**
     * 교수문항복사퀴즈문항목록조회
     *
     * @param examDtlId 	시험상세아이디
     * @return 퀴즈문항목록
     * @throws Exception
     */
    @Override
	public List<EgovMap> profQstnCopyQuizQstnList(QstnVO vo) throws Exception {
    	return qstnDAO.profQstnCopyQuizQstnList(vo);
    }

    /**
     * 퀴즈문항가져오기
     *
     * @param copyQstnId 	복사문항아이디
     * @param examDtlId 	시험상세아이디
     * @throws Exception
     */
    @Override
	public void quizQstnCopy(List<Map<String, Object>> list) throws Exception {
    	for(Map<String, Object> map : list) {
    		map.put("qstnId", IdGenUtil.genNewId(IdPrefixType.QSTN));
		}

    	// 1. 문항 등록
    	qstnDAO.quizQstnCopy(list);

    	// 2 문항보기항목 등록
    	qstnVwitmDAO.quizQstnVwitmCopy(list);
	}

    /**
     * 퀴즈문항분포바차트
     *
     * @param examDtlId 	시험상세아이디
     * @param qstnId 		문항아이디
     * @param exampprId		시험지아이디
     * @return 퀴즈문항분포
     * @throws Exception
     */
    @Override
	public ProcessResultVO<EgovMap> quizQstnDistributionBarChart(Map<String, Object> params) throws Exception {
    	ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

    	List<EgovMap> returnList = new ArrayList<>();
        EgovMap returnMap = new EgovMap();

        // 1. 문항조회
        QstnVO qstn = new QstnVO();
        qstn.setQstnId((String) params.get("qstnId"));
        qstn.setExamDtlId((String) params.get("examDtlId"));
        qstn = qstnDAO.qstnSelect(qstn);

        // 2. 문항보기항목목록조회
        QstnVwitmVO vwitm = new QstnVwitmVO();
        vwitm.setQstnId(qstn.getQstnId());
        List<QstnVwitmVO> vwitmList = qstnVwitmDAO.qstnVwitmList(vwitm);

        // 3. 시험응시답안목록조회
        List<EgovMap> answShtList = tkexamAnswShtDAO.qstnTkexamAnswShtCtsList(qstn.getQstnId(), (String) params.get("exampprId"));

        EgovMap emplMap = new EgovMap();
        String[] emplAlphabetArray = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J"};

        //보기 항목 세팅
        for(int i = 0; i < vwitmList.size(); i++) {
            emplMap.put(emplAlphabetArray[i], 0);
        }

        BigDecimal stareAnsrTotalCnt = new BigDecimal(0);

        // 단일, 다중, OX선택형
        if("ONE_CHC".equals(qstn.getQstnRspnsTycd()) || "MLT_CHC".equals(qstn.getQstnRspnsTycd()) || "OX_CHC".equals(qstn.getQstnRspnsTycd())) {
	        for(EgovMap map : answShtList) {
	        	for(int i = 0; i < String.valueOf(map.get("answShtCts")).split("@#").length; i++) {
	        		int answShtno = Integer.parseInt(String.valueOf(map.get("answShtCts")).split("@#")[i]);
	        		int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[answShtno-1]);
	        		int baseSeqno = Integer.parseInt(String.valueOf(map.get("baseDsplySeqno")).split("@#")[answShtno-1]);

	        		// 화면표시순서와 기준순서 일치시
	        		if(dsplySeqno == baseSeqno) {
	        			String emplAlphabet = StringUtil.nvl(emplAlphabetArray[i]).toLowerCase();
	        			emplMap.put(emplAlphabetArray[i], Integer.parseInt(StringUtil.nvl(emplMap.get(emplAlphabet), "0")) + 1);

	        		// 화면표시순서와 기존순서 불일치시
	        		} else {
	        			int ansrCnt = Arrays.asList(String.valueOf(map.get("baseDsplySeqno")).split("@#")).indexOf(String.valueOf(dsplySeqno));
	        			String emplAlphabet = StringUtil.nvl(emplAlphabetArray[ansrCnt]).toLowerCase();
	        			emplMap.put(emplAlphabetArray[ansrCnt], Integer.parseInt(StringUtil.nvl(emplMap.get(emplAlphabet), "0")) + 1);
	        		}

	        		stareAnsrTotalCnt = stareAnsrTotalCnt.add(BigDecimal.ONE);
	        	}
        	}
        }

        returnMap.put("emplMap", JsonUtil.getJsonString(emplMap));
        returnMap.put("examQstnList", vwitmList);
        returnList.add(returnMap);
        resultVO.setReturnList(returnList);

    	return resultVO;
    }

	/**
     * 퀴즈문항정답현황파이차트
     *
     * @param examDtlId 	시험상세아이디
     * @param qstnId 		문항아이디
     * @param exampprId		시험지아이디
     * @return 퀴즈문항분포
     * @throws Exception
     */
    @Override
	public ProcessResultVO<EgovMap> quizQstnCransStatusPieChart(Map<String, Object> params) throws Exception {
    	ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

    	List<EgovMap> returnList = new ArrayList<>();
        EgovMap returnMap = new EgovMap();

        // 1. 문항조회
        QstnVO qstn = new QstnVO();
        qstn.setQstnId((String) params.get("qstnId"));
        qstn.setExamDtlId((String) params.get("examDtlId"));
        qstn = qstnDAO.qstnSelect(qstn);

        // 2. 문항보기항목목록조회
        QstnVwitmVO vwitm = new QstnVwitmVO();
        vwitm.setQstnId(qstn.getQstnId());
        List<QstnVwitmVO> vwitmList = qstnVwitmDAO.qstnVwitmList(vwitm);

        // 3. 시험응시답안목록조회
        List<EgovMap> answShtList = tkexamAnswShtDAO.qstnTkexamAnswShtCtsList(qstn.getQstnId(), (String) params.get("exampprId"));

        // VO 리스트를 문항보기항목순번 기준으로 Map으로 변환
        Map<Integer, QstnVwitmVO> voMap = vwitmList.stream().collect(Collectors.toMap(QstnVwitmVO::getQstnVwitmSeqno, vo -> vo));

        List<String> backgroundColorArray = new ArrayList<>();
        backgroundColorArray.add("#36a2eb");
        backgroundColorArray.add("#ff6384");
        EgovMap emplMap = new EgovMap();
        emplMap.put("정답", 0);
        emplMap.put("오답", 0);

        for(EgovMap map : answShtList) {
        	boolean isCrans = false;
        	// 단일, 다중선택형
        	if("ONE_CHC".equals(qstn.getQstnRspnsTycd()) || "MLT_CHC".equals(qstn.getQstnRspnsTycd())) {
	        	if("ONE_CHC".equals(qstn.getQstnRspnsTycd()) && "CRANS_MLT".equals(qstn.getCransTycd())) {
	        		isCrans = true;
	        	} else {
	        		for(int i = 0; i < String.valueOf(map.get("answShtCts")).split("@#").length; i++) {
	        			int answShtno = Integer.parseInt(String.valueOf(map.get("answShtCts")).split("@#")[i]);
	        			int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[answShtno-1]);

	        			QstnVwitmVO vwitmVO = voMap.get(dsplySeqno);
	        			isCrans = "Y".equals(vwitmVO.getCransYn());
        				if("N".equals(vwitmVO.getCransYn())) break;
	        		}
	        	}

		    // OX선택형
	        } else if("OX_CHC".equals(qstn.getQstnRspnsTycd())) {
	        	for(int i = 0; i < String.valueOf(map.get("answShtCts")).split("@#").length; i++) {
        			int answShtno = Integer.parseInt(String.valueOf(map.get("answShtCts")).split("@#")[i]);
        			int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[answShtno-1]);

        			QstnVwitmVO vwitmVO = voMap.get(dsplySeqno);
        			isCrans = "Y".equals(vwitmVO.getCransYn());
        		}

	        // 서술형
	        } else if("LONG_TEXT".equals(qstn.getQstnRspnsTycd())) {
	        	int scr = Integer.parseInt(StringUtil.nvl(map.get("scr"), "0"));
	        	isCrans = scr > 0;

	        // 단답형
	        } else if("SHORT_TEXT".equals(qstn.getQstnRspnsTycd())) {
	        	for(int i = 0; i < String.valueOf(map.get("answShtCts")).split("@#").length; i++) {
	        		String answShtCts = String.valueOf(map.get("answShtCts")).split("@#")[i];
        			int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[i]);

        			// 정답순서에상관없이
        			if("CRANS_NOT_INORDER".equals(qstn.getCransTycd())) {
        				isCrans = voMap.entrySet().stream()
        					    .filter(entry ->
        					        Arrays.asList(entry.getValue().getQstnVwitmCts().split("\\|")).contains(answShtCts)
        					    )
        					    .map(Map.Entry::getKey)
        					    .findFirst()
        					    .map(key -> {
        					        voMap.remove(key);
        					        return true;
        					    })
        					    .orElse(false);  // 없으면 false

        				if(!isCrans) break;

        			// 정답순서에맞춰서
					} else if("CRANS_INORDER".equals(qstn.getCransTycd())) {
						QstnVwitmVO vwitmVO = voMap.get(dsplySeqno);
						isCrans = Arrays.asList(vwitmVO.getQstnVwitmCts().split("\\|")).contains(answShtCts);
						if(!isCrans) break;
					}
        		}

	        // 연결형
	        } else if("LINK".equals(qstn.getQstnRspnsTycd())) {
	        	for(int i = 0; i < String.valueOf(map.get("answShtCts")).split("@#").length; i++) {
	        		String answShtCts = String.valueOf(map.get("answShtCts")).split("@#")[i];
        			int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[i]);

        			QstnVwitmVO vwitmVO = voMap.get(dsplySeqno);
					isCrans = Arrays.asList(vwitmVO.getQstnVwitmCts().split("\\|")).contains(answShtCts);
					if(!isCrans) break;
        		}
	        }

        	if(isCrans) {
    			emplMap.put("정답", Integer.parseInt(StringUtil.nvl(emplMap.get("정답"), "0")) + 1);
    		} else {
    			emplMap.put("오답", Integer.parseInt(StringUtil.nvl(emplMap.get("오답"), "0")) + 1);
    		}
        }

        returnMap.put("backgroundColorArray", JsonUtil.getJsonString(backgroundColorArray));
        returnMap.put("emplMap", JsonUtil.getJsonString(emplMap));
        returnMap.put("examQstnList", vwitmList);
        returnList.add(returnMap);
        resultVO.setReturnList(returnList);

    	return resultVO;
    }

    /**
	* 퀴즈문항엑셀샘플데이터
	*
	* @param examDtlId	시험상세아이디
	* @param excelGrid 	엑셀그리드
	* @throws Exception
	*/
	public HashMap<String, Object> quizQstnExcelSampleData(ExamDtlVO vo) throws Exception {
		List<EgovMap> resultList = new ArrayList<EgovMap>();

        // 문항 1-1 ( 단일선택형 )
		EgovMap egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "1");
        egovMap.put("qstnCnddtSeqno", "1");
        egovMap.put("qstnTtl", "1-1번 문항");
        egovMap.put("qstnCts", "1-1번 문항에 대한 답을 선택하세요.");
        egovMap.put("qstnRspnsTycd", "ONE_CHC");
        egovMap.put("qstnVwitmSeqno", "1");
        egovMap.put("qstnVwitmCts", "단일선택형 1번 보기");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "N");
        egovMap.put("qstnDfctlvTycd", "MIDDLE");
        egovMap.put("qstnScr", "25");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "2");
        egovMap.put("qstnVwitmCts", "단일선택형 2번 보기");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "N");
        egovMap.put("qstnDfctlvTycd", "");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "3");
        egovMap.put("qstnVwitmCts", "단일선택형 3번 보기");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "Y");
        egovMap.put("qstnDfctlvTycd", "");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "4");
        egovMap.put("qstnVwitmCts", "단일선택형 4번 보기");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "N");
        egovMap.put("qstnDfctlvTycd", "");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        // 문항 1-2 ( 다중선택형 )
        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "2");
        egovMap.put("qstnTtl", "1-2번 문항");
        egovMap.put("qstnCts", "1-2번 문항에 대한 답을 선택하세요.");
        egovMap.put("qstnRspnsTycd", "MLT_CHC");
        egovMap.put("qstnVwitmSeqno", "1");
        egovMap.put("qstnVwitmCts", "다중선택형 1번 보기");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "Y");
        egovMap.put("qstnDfctlvTycd", "HIGH");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "2");
        egovMap.put("qstnVwitmCts", "다중선택형 2번 보기");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "N");
        egovMap.put("qstnDfctlvTycd", "");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "3");
        egovMap.put("qstnVwitmCts", "다중선택형 3번 보기");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "N");
        egovMap.put("qstnDfctlvTycd", "");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "4");
        egovMap.put("qstnVwitmCts", "다중선택형 4번 보기");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "Y");
        egovMap.put("qstnDfctlvTycd", "");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        // 문항 2-1 ( OX선택형 )
        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "2");
        egovMap.put("qstnCnddtSeqno", "1");
        egovMap.put("qstnTtl", "2-1번 문항");
        egovMap.put("qstnCts", "2-1번 문항에 대한 답을 선택하세요.");
        egovMap.put("qstnRspnsTycd", "OX_CHC");
        egovMap.put("qstnVwitmSeqno", "");
        egovMap.put("qstnVwitmCts", "");
        egovMap.put("qstnVwitmCransCts", "O");
        egovMap.put("cransYn", "");
        egovMap.put("qstnDfctlvTycd", "NONE");
        egovMap.put("qstnScr", "25");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        // 문항 2-2 ( 서술형 )
        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "2");
        egovMap.put("qstnTtl", "2-2번 문항");
        egovMap.put("qstnCts", "2-2번 문항에 대한 답을 입력하세요.");
        egovMap.put("qstnRspnsTycd", "LONG_TEXT");
        egovMap.put("qstnVwitmSeqno", "");
        egovMap.put("qstnVwitmCts", "");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "");
        egovMap.put("qstnDfctlvTycd", "LOW");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        // 문항 3-1 ( 단답형 )
        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "3");
        egovMap.put("qstnCnddtSeqno", "1");
        egovMap.put("qstnTtl", "3-1번 문항");
        egovMap.put("qstnCts", "3-1번 문항에 대한 답을 입력하세요.");
        egovMap.put("qstnRspnsTycd", "SHORT_TEXT");
        egovMap.put("qstnVwitmSeqno", "1");
        egovMap.put("qstnVwitmCts", "1번정답1|1번정답2|1번정답3");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "");
        egovMap.put("qstnDfctlvTycd", "LOW");
        egovMap.put("qstnScr", "25");
        egovMap.put("cransTycd", "CRANS_INORDER");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "2");
        egovMap.put("qstnVwitmCts", "2번정답1|2번정답2");
        egovMap.put("qstnVwitmCransCts", "");
        egovMap.put("cransYn", "");
        egovMap.put("qstnDfctlvTycd", "LOW");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        // 문항 4-1 ( 연결형 )
        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "4");
        egovMap.put("qstnCnddtSeqno", "1");
        egovMap.put("qstnTtl", "4-1번 문항");
        egovMap.put("qstnCts", "4-1번 문항에 대한 답을 끌어서 넣으세요.");
        egovMap.put("qstnRspnsTycd", "LINK");
        egovMap.put("qstnVwitmSeqno", "1");
        egovMap.put("qstnVwitmCts", "1번보기내용");
        egovMap.put("qstnVwitmCransCts", "1번정답내용");
        egovMap.put("cransYn", "");
        egovMap.put("qstnDfctlvTycd", "MIDDLE");
        egovMap.put("qstnScr", "25");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "2");
        egovMap.put("qstnVwitmCts", "2번보기내용");
        egovMap.put("qstnVwitmCransCts", "2번정답내용");
        egovMap.put("cransYn", "");
        egovMap.put("qstnDfctlvTycd", "");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "");
        egovMap.put("qstnCnddtSeqno", "");
        egovMap.put("qstnTtl", "");
        egovMap.put("qstnCts", "");
        egovMap.put("qstnRspnsTycd", "");
        egovMap.put("qstnVwitmSeqno", "3");
        egovMap.put("qstnVwitmCts", "3번보기내용");
        egovMap.put("qstnVwitmCransCts", "3번정답내용");
        egovMap.put("cransYn", "");
        egovMap.put("qstnDfctlvTycd", "");
        egovMap.put("qstnScr", "");
        egovMap.put("cransTycd", "");
        resultList.add(egovMap);

        String[] searchValues = {
                "⊙ 주의사항 : 엑셀로 문항 등록시 기존 등록된 퀴즈 문항은 삭제됩니다."
        		, "1. 문항순번 : 정수로 1부터 시작"
        		, "2. 문항후보순번 : 문항 단위로, 정수로 1부터 시작. 문항이 넘어가면 다시 1부터 시작"
        		, "3. 문항명 : 해당 문항에 대한 제목"
        		, "4. 문항내용 : 해당 문항에 대한 내용"
        		, "5. 문항답변유형코드 : 단일선택형(ONE_CHC), 다중선택형(MLT_CHC), OX선택형(OX_CHC), 연결형(LINK), 단답형(SHORT_TEXT), 서술형(LONG_TEXT)"
        		, "6. 문항보기항목순번 : 문항 단위로, 정수로 1부터 시작. 서술형(LONG_TEXT) OR 연결형(LINK)은 빈칸으로 입력\r\n"
        		+ "단일선택형(ONE_CHC), 다중선택형(MLT_CHC), 연결형(LINK)은 최대 10까지, 단답형(SHORT_TEXT)은 최대 5까지"
        		, "7. 문항보기항목내용 : 단일선택형(ONE_CHC), 다중선택형(MLT_CHC)은 해당 순번의 정답내용 입력\r\n"
        		+ "단답형(SHORT_TEXT)은 해당 순번의 정답내용을 \"|\"로 구분하여 최대 5개까지 입력, 입력한 내용중에 하나만 맞아도 정답\r\n"
        		+ "연결형(LINK)은 해당 순번의 보기내용 입력\r\n"
        		+ "OX선택형(OX_CHC)과 서술형(LONG_TEXT)은 빈칸으로 입력"
        		, "8. 문항보기항목정답내용 : 연결형(LINK)은 해당 순번과 연결할 정답내용 입력\r\n"
        		+ "OX선택형(OX_CHC)은 O, X 중 정답으로 사용할 값 입력\r\n"
        		+ "나머지 문항답변유형코드는 빈칸으로 입력"
        		, "9. 정답여부 : 단일선택형(ONE_CHC), 다중선택형(MLT_CHC)만 정답으로 사용할 문항에 Y입력, 빈칸으로 입력시 N 처리"
        		, "10. 문항난이도 : 상관없음(NONE), 하(LOW), 중(MIDDLE), 상(HIGH), 빈칸으로 입력시 NONE 처리"
        		, "11. 문항점수 : 문항순번 단위로, 해당 문항의 점수 소수점 최대 2자리까지 입력"
        		, "12. 정답유형코드 : 단답형(SHORT_TEXT)만 정답순서에맞춰서(CRANS_INORDER), 정답순서에상관없이(CRANS_NOT_INORDER)"
        };

		//POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "퀴즈 문항 엑셀 업로드 양식");
        map.put("sheetName", "sample");
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", resultList);

        return map;
	}

	/**
	* 퀴즈문항엑셀업로드
	*
	* @param examDtlId 		시험상세아이디
    * @param uploadFiles 	파일목록
    * @param uploadPath 	파일경로
    * @param excelGrid 		엑셀그리드
	* @throws Exception
	*/
	@Override
	public ProcessResultVO<ExamDtlVO> quizQstnExcelUpload(ExamDtlVO vo) throws Exception {
		ProcessResultVO<ExamDtlVO> resultVO = new ProcessResultVO<ExamDtlVO>();

		List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        List<String> fileIdList = new ArrayList<>();

        // 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(vo.getExamDtlId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getRgtrId());
        		atflVO.setAtflRepoId(CommConst.REPO_EXAM);
        		fileIdList.add(atflVO.getAtflId());
        	}

        	// 첨부파일 저장
        	attachFileService.insertAtflList(uploadFileList);
        }

        AtflVO atflVO = uploadFileList.get(0);

        //엑셀 읽기위한 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("startRaw", 18);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("atflVO", atflVO);
        map.put("searchKey", "excelUpload");

        //엑셀 리더
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        List<Map<String, Object>> list = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);

        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(fileIdList.toArray(new String[0]));

        if(list.size() > 0) {
        	// 문항후보순번 중복확인
        	List<String> qstnSeqnoList = list.stream()
        		.map(qstn -> qstn.get("A"))
        		.filter(v -> v != null && !v.toString().isEmpty())
        		.map(Object::toString)
        		.collect(Collectors.toList());

        	boolean hasDuplicate = qstnSeqnoList.size() != new HashSet<>(qstnSeqnoList).size();
        	if(hasDuplicate) {
        		Set<String> seen = new HashSet<>();
        		Set<String> duplicates = qstnSeqnoList.stream()
        				.filter(v -> !seen.add(v))
        				.collect(Collectors.toSet());

        		resultVO.setResult(-1);
        		resultVO.setMessage(duplicates + " 문항순번은 중복 입력된 번호입니다.");
        		return resultVO;
        	}

        	// 문항검사
        	String qstnSeqno = "";	// 문항순번
        	for(int i = 0; i < list.size(); i++) {
        		Map<String, Object> qstn = list.get(i);
        		if(qstn.get("A") != null && !"".equals(qstn.get("A").toString().trim())) qstnSeqno = qstn.get("A").toString().trim();

        		if(qstn.get("B") != null && !"".equals(qstn.get("B").toString().trim())) {
        			String qstnRspnsTycd = !"".equals(qstn.get("E")) ? qstn.get("E").toString().trim() : "";
        			// 문항답변유형코드 빈값
        			if("".equals(qstnRspnsTycd)) {
        				resultVO.setResult(-1);
        				resultVO.setMessage((i+18) + "번 줄의 문항답변유형코드를 입력해주세요.");
        				return resultVO;
        			}

        			// 문항답변유형코드 목록 조회
	        	    List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(vo.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
        	        qstnRspnsTycdList.removeIf(item -> "SRVY".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
        	        // 문항답변유형코드일치여부
        	        boolean isMatched = qstnRspnsTycdList.stream()
        	        	    .anyMatch(cd -> cd.getCd().contains(qstnRspnsTycd));
        	        if(!isMatched) {
        	        	resultVO.setResult(-1);
        	        	resultVO.setMessage((i+18) + "번 줄의 문항답변유형코드가 일치하지 않습니다.");
        	        	return resultVO;
        	        }

        	        // 서술형, OX선택형 제외
        	        if(!"LONG_TEXT".equals(qstnRspnsTycd) && !"OX_CHC".equals(qstnRspnsTycd)) {
        	        	for(int k = i; k < list.size(); k++) {
        	        		String nextQstn = !"".equals(list.get(k).get("E")) ? list.get(k).get("E").toString().trim() : "";
        	        		if (!"".equals(nextQstn) && k > i) break;
        	        		String qstnVwitmSeqno = !"".equals(list.get(k).get("F")) ? list.get(k).get("F").toString().trim() : "";
        	        		if("".equals(qstnVwitmSeqno)) {
        	        			resultVO.setResult(-1);
        	        			resultVO.setMessage((k+18) + "번 줄의 문항보기항목순번이 없습니다.");
        	        			return resultVO;
        	        		}
        	        		String qstnVwitmCts = !"".equals(list.get(k).get("G")) ? list.get(k).get("G").toString().trim() : "";
        	        		if("".equals(qstnVwitmCts)) {
        	        			resultVO.setResult(-1);
        	        			resultVO.setMessage((k+18) + "번 줄의 문항보기항목내용이 없습니다.");
        	        			return resultVO;
        	        		}
        	        	}
        	        }

        	        // 단답형
        	        if("SHORT_TEXT".equals(qstnRspnsTycd)) {
        	        	for(int k = i; k < list.size(); k++) {
        	        		String nextQstn = !"".equals(list.get(k).get("E")) ? list.get(k).get("E").toString().trim() : "";
        	        		if (!"".equals(nextQstn) && k > i) break;
        	        		String qstnVwitmCts = !"".equals(list.get(k).get("G")) ? list.get(k).get("G").toString().trim() : "";
        	        		if(qstnVwitmCts.split("\\|").length > 5) {
        	        			resultVO.setResult(-1);
        	        			resultVO.setMessage((k+18) + "번 줄의 문항보기항목내용은 최대 5개까지 등록 할 수 있습니다.");
        	        			return resultVO;
        	        		}
        	        	}

        	        	String cransTycd = !"".equals(qstn.get("L")) ? qstn.get("L").toString().trim() : "";
        	        	if("".equals(cransTycd)) {
        	        		resultVO.setResult(-1);
        	        		resultVO.setMessage((i+18) + "번 줄의 정답유형코드를 입력해주세요.");
        	        		return resultVO;
        	        	}
        	        }

        	        // 단일, 다중선택형
        	        if("ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd)) {
        	        	int cransYnCnt = 0;	// 정답여부 Y 카운트
        	        	for(int k = i; k < list.size(); k++) {
        	        		String nextQstn = !"".equals(list.get(k).get("E")) ? list.get(k).get("E").toString().trim() : "";
        	        		if (!"".equals(nextQstn) && k > i) break;
        	        		String cransYn = !"".equals(list.get(k).get("I")) ? list.get(k).get("I").toString().trim() : "";
        	        		if("".equals(cransYn)) {
        	                	resultVO.setResult(-1);
        	                	resultVO.setMessage((k+18) + "번 줄의 기타입력여부가 없습니다.");
        	                	return resultVO;
        	                }
        	                if("Y".equals(cransYn)) cransYnCnt++;
        	        	}
        	        	if(cransYnCnt > 1 && "ONE_CHC".equals(qstnRspnsTycd)) {
        	        		String qstnCnddtSeqno = qstn.get("B").toString().trim();
        	        		resultVO.setResult(-1);
        	        		resultVO.setMessage(qstnSeqno + "문항 " + qstnCnddtSeqno + "후보문항의 정답은 1개만 선택가능합니다.");
        	        		return resultVO;
        	        	}
        	        }
        		}
        	}

        	// 기존 문항보기항목전체삭제
        	qstnVwitmDAO.qstnVwitmAllDelete(vo);

        	// 기존 문항전체삭제
        	qstnDAO.qstnAllDelete(vo);

        	// 퀴즈문항 등록용 for문
        	String qstnRspnsTycd = "";
        	String qstnScr = "";
        	// 일괄등록용 목록
        	List<QstnVO> qstnList = new ArrayList<QstnVO>();			// 문항목록
        	List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();	// 문항보기항목목록
        	for(int i = 0; i < list.size(); i++) {
        		Map<String, Object> qstn = list.get(i);
        		if(qstn.get("A") != null && !"".equals(qstn.get("A").toString().trim())) {
        			qstnSeqno = qstn.get("A").toString().trim();
        			qstnScr = !"".equals(qstn.get("K")) ? qstn.get("K").toString().trim() : "0";
        		}

        		// 문항
        		if(qstn.get("B") != null && !"".equals(qstn.get("B").toString().trim())) {
        			qstnRspnsTycd = qstn.get("E").toString().trim();	// 문항답변유형코드
        			String qstnCnddtSeqno = qstn.get("B").toString().trim();
        			String qstnTtl = !"".equals(qstn.get("C")) ? qstn.get("C").toString().trim() : qstnSeqno+"-"+qstnCnddtSeqno+"번 문항";	// 문항명
        			String qstnDfctlvTycd = !"".equals(qstn.get("J")) ? qstn.get("J").toString().trim() : "NONE";	// 문항난이도유형코드
        			String cransTycd = "MLT_CHC".equals(qstnRspnsTycd) ? "CRANS_MLT" : !"".equals(qstn.get("L")) ? qstn.get("L").toString().trim() : "";	// 정답유형코드
        			QstnVO qstnVO = new QstnVO();
        			String qstnId = IdGenUtil.genNewId(IdPrefixType.QSTN);
        			qstnVO.setQstnId(qstnId);
        			qstnVO.setExamDtlId(vo.getExamDtlId());
        			qstnVO.setQstnTtl(qstnTtl);
        			qstnVO.setQstnCts(qstn.get("D").toString().trim());
        			qstnVO.setQstnSeqno(Integer.parseInt(qstnSeqno));
        			qstnVO.setQstnCnddtSeqno(Integer.parseInt(qstnCnddtSeqno));
        			qstnVO.setQstnGbncd("TXT");
        			qstnVO.setQstnRspnsTycd(qstnRspnsTycd);
        			qstnVO.setQstnScr(new BigDecimal(qstnScr));
        			qstnVO.setQstnDfctlvTycd(qstnDfctlvTycd);
        			qstnVO.setCransTycd(cransTycd);
        			qstnVO.setRgtrId(vo.getRgtrId());
        			qstnList.add(qstnVO);

        			// 문항보기항목
        			for(int k = i; k < list.size(); k++) {
        				String nextQstn = !"".equals(list.get(k).get("E")) ? list.get(k).get("E").toString() : "";
        				if (!"".equals(nextQstn) && k > i) break;
        				// 서술형, OX선택형 아닌경우
        				if(!"LONG_TEXT".equals(qstnRspnsTycd) && !"OX_CHC".equals(qstnRspnsTycd)) {
        					String cransYn = "ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd) ? list.get(k).get("I").toString().trim() : "Y";	// 정답여부
        					String qstnVwitmCts = "LINK".equals(qstnRspnsTycd) ? list.get(k).get("G").toString().trim() + "|" + list.get(k).get("H").toString().trim() : list.get(k).get("G").toString().trim();	// 문항보기항목내용
        					QstnVwitmVO vwitmVO = new QstnVwitmVO();
        					vwitmVO.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
        					vwitmVO.setQstnId(qstnId);
        					vwitmVO.setQstnVwitmGbncd(qstnVO.getQstnGbncd());
        					vwitmVO.setQstnVwitmCts(qstnVwitmCts);
        					vwitmVO.setCransYn(cransYn);
        					vwitmVO.setQstnVwitmSeqno(Integer.parseInt(list.get(k).get("F").toString().trim()));
        					vwitmVO.setRgtrId(vo.getRgtrId());
        					vwitmList.add(vwitmVO);
        				// OX선택형
        				} else if("OX_CHC".equals(qstnRspnsTycd)) {
        					for(int seq = 1; seq <= 2; seq++) {
        						String qstnVwitmCts = seq == 1 ? "O" : "X";
        						String cransYn = qstnVwitmCts.equals(list.get(k).get("H").toString().trim()) ? "Y" : "N";
        						QstnVwitmVO vwitmVO = new QstnVwitmVO();
            					vwitmVO.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
            					vwitmVO.setQstnId(qstnId);
            					vwitmVO.setQstnVwitmGbncd(qstnVO.getQstnGbncd());
            					vwitmVO.setQstnVwitmCts(qstnVwitmCts);
            					vwitmVO.setCransYn(cransYn);
            					vwitmVO.setQstnVwitmSeqno(seq);
            					vwitmVO.setRgtrId(vo.getRgtrId());
            					vwitmList.add(vwitmVO);
        					}
        				}
        			}
        		}
        	}

        	if(qstnList.size() > 0) qstnDAO.qstnBulkRegist(qstnList); 				// 문항일괄등록
        	if(vwitmList.size() > 0) qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);	// 문항보기항목일괄등록
        }

        resultVO.setResult(1);
        return resultVO;
	}

	/**
	 * 퀴즈문항옵션수정
	 *
	 * @param QstnVO
	 * @throws Exception
	 */
	@Override
	public void quizQstnOptionModify(QstnVO vo) throws Exception {
		// 문항수정
		qstnDAO.qstnModify(vo);

		// 문항보기항목목록조회
		QstnVwitmVO vwitmVO = new QstnVwitmVO();
		vwitmVO.setQstnId(vo.getQstnId());
		List<QstnVwitmVO> vwitmList = qstnVwitmDAO.qstnVwitmList(vwitmVO);

		// 문항보기항목일괄수정
		List<QstnVwitmVO> modifyVwitmList = new ArrayList<QstnVwitmVO>();
        if (vo.getQstns() != null && !vo.getQstns().isEmpty()) {
            for (Map<String, Object> map : vo.getQstns()) {
            	QstnVwitmVO result = vwitmList.stream()
            		    .filter(vwitm -> vwitm.getQstnVwitmSeqno() == (Integer) map.get("qstnVwitmSeqno"))
            		    .findFirst()
            		    .orElse(null);

                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(vo.getQstnId());
                vwitm.setQstnVwitmGbncd(vo.getQstnGbncd());
                vwitm.setMdfrId(vo.getMdfrId());
                vwitm.setQstnVwitmId(result.getQstnVwitmId());
                vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
                vwitm.setCransYn((String) map.get("cransYn"));
                vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));

                modifyVwitmList.add(vwitm);
            }
            qstnVwitmDAO.qstnVwitmBulkModify(modifyVwitmList);
        }

        // 문항시험응시답안목록조회
        List<Map<String, Object>> answModifyList = new ArrayList<Map<String,Object>>();
     	List<EgovMap> answShtList = tkexamAnswShtDAO.qstnTkexamAnswShtCtsList(vo.getQstnId(), null);
        for(EgovMap answ : answShtList) {
        	boolean isCrans = true;
        	Map<String, Object> answMap = new HashMap<String, Object>();
        	answMap.put("tkexamAnswShtId", answ.get("tkexamAnswShtId"));
        	answMap.put("exampprId", answ.get("exampprId"));
        	answMap.put("qstnId", vo.getQstnId());
        	answMap.put("userId", answ.get("userId"));
        	answMap.put("rgtrId", vo.getMdfrId());
        	// 모두에게 점수 주기
        	if("allCrans".equals(vo.getSearchKey())) {
        		answMap.put("scr", isCrans ? vo.getQstnScr() : "0");
        		answModifyList.add(answMap);
 				continue;
 			}

        	// 단일, 다중, OX선택형
        	if("ONE_CHC".equals(vo.getQstnRspnsTycd()) || "MLT_CHC".equals(vo.getQstnRspnsTycd()) || "OX_CHC".equals(vo.getQstnRspnsTycd())) {
        		// 단일선택형 전체정답인 경우
	        	if("ONE_CHC".equals(vo.getQstnRspnsTycd()) && "CRANS_MLT".equals(vo.getCransTycd())) {
	        		answMap.put("scr", vo.getQstnScr());
	        	} else {
	        		for(int i = 0; i < String.valueOf(answ.get("answShtCts")).split("@#").length; i++) {
	        			int answShtno = Integer.parseInt(String.valueOf(answ.get("answShtCts")).split("@#")[i]);
	        			int dsplySeqno = Integer.parseInt(String.valueOf(answ.get("qstnVwitmDsplySeq")).split("@#")[answShtno-1]);

	        			// 이전문항보기항목
	        			QstnVwitmVO prevVwitm = vwitmList.stream()
	        					.filter(vwitm -> vwitm.getQstnVwitmSeqno() == dsplySeqno)
	        					.findFirst()
	        					.orElse(null);
	        			// 수정문항보기항목
	        			QstnVwitmVO newVwitm = modifyVwitmList.stream()
	        					.filter(vwitm -> vwitm.getQstnVwitmSeqno() == dsplySeqno)
	        					.findFirst()
	        					.orElse(null);

	        			// 이전, 현재 정답 모두 점수 주기
	        			if("prevCrans".equals(vo.getSearchKey())) {
	        				if("N".equals(newVwitm.getCransYn()) && "N".equals(prevVwitm.getCransYn())) {
	        					isCrans = false;
	        					break;
	        				}
	        			// 현재 정답에만 점수 주기
	        			} else if("newCrans".equals(vo.getSearchKey())) {
	        				if("N".equals(newVwitm.getCransYn())) {
	        					isCrans = false;
	        					break;
	        				}
	        			}
	        		}
	        		answMap.put("scr", isCrans ? vo.getQstnScr() : "0");
	        	}

	        // 서술형
	        } else if("LONG_TEXT".equals(vo.getQstnRspnsTycd())) {
	        	answMap.put("scr", "allCrans".equals(vo.getSearchKey()) ? vo.getQstnScr() : "0");

	        // 단답형
	        } else if("SHORT_TEXT".equals(vo.getQstnRspnsTycd())) {
	        	for(int i = 0; i < String.valueOf(answ.get("answShtCts")).split("@#").length; i++) {
	        		String answShtCts = String.valueOf(answ.get("answShtCts")).split("@#")[i];
        			int dsplySeqno = Integer.parseInt(String.valueOf(answ.get("qstnVwitmDsplySeq")).split("@#")[i]);

        			// 정답순서에상관없이
        			if("CRANS_NOT_INORDER".equals(vo.getCransTycd())) {
        				// 이전문항보기항목
        				boolean prevCrans = false;
        				Iterator<QstnVwitmVO> prevIterator = vwitmList.iterator();

        				while (prevIterator.hasNext()) {
        					QstnVwitmVO vwitm = prevIterator.next();

        				    if (vwitm.getQstnVwitmCts() != null &&
        				        Arrays.asList(vwitm.getQstnVwitmCts().split("\\|")).contains(answShtCts)) {

        				    	prevIterator.remove();
        				    	prevCrans = true;
        				        break;
        				    }
        				}

        				// 수정문항보기항목
        				boolean newCrans = false;
        				Iterator<QstnVwitmVO> newIterator = modifyVwitmList.iterator();

        				while (newIterator.hasNext()) {
        					QstnVwitmVO vwitm = newIterator.next();

        				    if (vwitm.getQstnVwitmCts() != null &&
        				        Arrays.asList(vwitm.getQstnVwitmCts().split("\\|")).contains(answShtCts)) {

        				    	newIterator.remove();
        				    	newCrans = true;
        				        break;
        				    }
        				}

        				// 이전, 현재 정답 모두 점수 주기
	        			if("prevCrans".equals(vo.getSearchKey())) {
	        				if(!prevCrans && !newCrans) {
	        					isCrans = false;
	        					break;
	        				}
	        			// 현재 정답에만 점수 주기
	        			} else if("newCrans".equals(vo.getSearchKey())) {
	        				if(!newCrans) {
	        					isCrans = false;
	        					break;
	        				}
	        			}

        			// 정답순서에맞춰서
					} else if("CRANS_INORDER".equals(vo.getCransTycd())) {
						// 이전문항보기항목
	        			QstnVwitmVO prevVwitm = vwitmList.stream()
	        					.filter(vwitm -> vwitm.getQstnVwitmSeqno() == dsplySeqno)
	        					.findFirst()
	        					.orElse(null);
	        			// 수정문항보기항목
	        			QstnVwitmVO newVwitm = modifyVwitmList.stream()
	        					.filter(vwitm -> vwitm.getQstnVwitmSeqno() == dsplySeqno)
	        					.findFirst()
	        					.orElse(null);

						boolean prevCrans = Arrays.asList(prevVwitm.getQstnVwitmCts().split("\\|")).contains(answShtCts);
						boolean newCrans = Arrays.asList(newVwitm.getQstnVwitmCts().split("\\|")).contains(answShtCts);
						// 이전, 현재 정답 모두 점수 주기
	        			if("prevCrans".equals(vo.getSearchKey())) {
	        				if(!prevCrans && !newCrans) {
	        					isCrans = false;
	        					break;
	        				}
	        			// 현재 정답에만 점수 주기
	        			} else if("newCrans".equals(vo.getSearchKey())) {
	        				if(!newCrans) {
	        					isCrans = false;
	        					break;
	        				}
	        			}
					}
        		}
	        	answMap.put("scr", isCrans ? vo.getQstnScr() : "0");

	        // 연결형
	        } else if("LINK".equals(vo.getQstnRspnsTycd())) {
	        	for(int i = 0; i < String.valueOf(answ.get("answShtCts")).split("@#").length; i++) {
	        		String answShtCts = String.valueOf(answ.get("answShtCts")).split("@#")[i];
        			int dsplySeqno = Integer.parseInt(String.valueOf(answ.get("qstnVwitmDsplySeq")).split("@#")[i]);

        			// 이전문항보기항목
        			QstnVwitmVO prevVwitm = vwitmList.stream()
        					.filter(vwitm -> vwitm.getQstnVwitmSeqno() == dsplySeqno)
        					.findFirst()
        					.orElse(null);
        			// 수정문항보기항목
        			QstnVwitmVO newVwitm = modifyVwitmList.stream()
        					.filter(vwitm -> vwitm.getQstnVwitmSeqno() == dsplySeqno)
        					.findFirst()
        					.orElse(null);

        			boolean prevCrans = Arrays.asList(prevVwitm.getQstnVwitmCts().split("\\|")).contains(answShtCts);
					boolean newCrans = Arrays.asList(newVwitm.getQstnVwitmCts().split("\\|")).contains(answShtCts);
					// 이전, 현재 정답 모두 점수 주기
        			if("prevCrans".equals(vo.getSearchKey())) {
        				if(!prevCrans && !newCrans) {
        					isCrans = false;
        					break;
        				}
        			// 현재 정답에만 점수 주기
        			} else if("newCrans".equals(vo.getSearchKey())) {
        				if(!newCrans) {
        					isCrans = false;
        					break;
        				}
        			}
        		}
	        	answMap.put("scr", isCrans ? vo.getQstnScr() : "0");
	        }

        	answModifyList.add(answMap);
        }
        // 시험응시답안점수수정
        tkexamAnswShtDAO.tkexamAnswShtScrModify(answModifyList);
	}

}
