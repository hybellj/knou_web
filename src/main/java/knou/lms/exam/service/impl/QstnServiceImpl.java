package knou.lms.exam.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.QstnDAO;
import knou.lms.exam.dao.QstnVwitmDAO;
import knou.lms.exam.dao.TkexamAnswShtDAO;
import knou.lms.exam.service.QstnService;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;

@Service("qstnService")
public class QstnServiceImpl extends ServiceBase implements QstnService {

	@Resource(name="qstnDAO")
	private QstnDAO qstnDAO;

	@Resource(name="qstnVwitmDAO")
	private QstnVwitmDAO qstnVwitmDAO;

	@Resource(name="tkexamAnswShtDAO")
	private TkexamAnswShtDAO tkexamAnswShtDAO;

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
        List<String> backgroundColorArray = new ArrayList<String>();

        //보기 항목 세팅 및 백그라운드 색배치
        for(int i = 0; i < vwitmList.size(); i++) {
            emplMap.put(emplAlphabetArray[i], 0);
            backgroundColorArray.add("rgba(153, 102, 255, .8)");
        }

        BigDecimal stareAnsrTotalCnt = new BigDecimal(0);

        // 단일, 다중선택형
        if("ONE_CHC".equals(qstn.getQstnRspnsTycd()) || "MLT_CHC".equals(qstn.getQstnRspnsTycd())) {
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

        //각보기별 답변 백분율
        for(int i = 0; i < vwitmList.size(); i++) {
        	String emplVal = StringUtil.nvl(emplMap.get(StringUtil.nvl(emplAlphabetArray[i]).toLowerCase()));
        	BigDecimal emplTotalCnt = (emplVal == null || emplVal.isEmpty()) ? BigDecimal.ZERO : new BigDecimal(emplVal);

        	long percent = 0L;
        	if (stareAnsrTotalCnt.compareTo(BigDecimal.ZERO) != 0) {
        	    percent = Math.round(
        	        emplTotalCnt
        	            .divide(stareAnsrTotalCnt, 10, RoundingMode.HALF_UP)
        	            .multiply(new BigDecimal("100"))
        	            .doubleValue()
        	    );
        	}
            emplMap.put(emplAlphabetArray[i], percent);
        }

        returnMap.put("backgroundColorArray", JsonUtil.getJsonString(backgroundColorArray));
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

}
