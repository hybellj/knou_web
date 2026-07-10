package knou.lms.exam.service.impl;

import java.math.BigDecimal;
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

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

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
import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.dao.ExrcsSddnQstnBscDAO;
import knou.lms.exam.dao.QstnDAO;
import knou.lms.exam.dao.QstnVwitmDAO;
import knou.lms.exam.dao.TkexamAnswShtDAO;
import knou.lms.exam.service.QstnService;
import knou.lms.exam.vo.ExrcsSddnQstnBscVO;
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

	@Resource(name="exrcsSddnQstnBscDAO")
	private ExrcsSddnQstnBscDAO exrcsSddnQstnBscDAO;

	/**
	 * 문항목록조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return 문항 목록
	 */
	@Override
	public List<QstnVO> qstnList(QstnVO vo) {
		return qstnDAO.qstnList(vo);
	}

	/**
	 * 문항개수조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return int
	 */
	@Override
	public int qstnCntSelect(QstnVO vo) {
		return qstnDAO.qstnCntSelect(vo);
	}

	/**
     * 퀴즈문항등록
     *
     * @param QstnVO
     */
    @Override
    public void quizQstnRegist(QstnVO vo, String qstnsStr) {
    	ObjectMapper mapper = new ObjectMapper();
    	List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
    	try {
    		qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

    	// 1. 문항 등록
    	vo.setQstnId(IdGenUtil.genNewId(IdPrefixType.QSTN));
    	qstnDAO.qstnRegist(vo);

    	// 2. 문항보기항목 일괄등록
    	if (qstns != null && !qstns.isEmpty()) {
            List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();

            for (Map<String, Object> map : qstns) {
                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(vo.getQstnId());
                vwitm.setQstnVwitmGbncd("TXT");
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
     */
    @Override
    public void quizQstnModify(QstnVO vo, String qstnsStr) {
    	ObjectMapper mapper = new ObjectMapper();
    	List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
    	try {
    		qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

    	// 1. 문항 수정
    	qstnDAO.qstnModify(vo);

    	// 2. 기존 문항보기항목 삭제
    	QstnVwitmVO vwitmDeleteVO = new QstnVwitmVO();
    	vwitmDeleteVO.setQstnId(vo.getQstnId());
    	qstnVwitmDAO.qstnVwitmDelete(vwitmDeleteVO);

    	// 3. 신규 문항보기항목 일괄등록
        if (qstns != null && !qstns.isEmpty()) {
            List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();

            for (Map<String, Object> map : qstns) {
                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(vo.getQstnId());
                vwitm.setQstnVwitmGbncd("TXT");
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
     */
    @Override
    public void qstnSeqnoModify(QstnVO vo) {
    	qstnDAO.qstnSeqnoModify(vo);
    }

    /**
	 * 문항후보순번수정
	 *
	 * @param examDtlId 		시험상세아이디
	 * @param qstnId	 		문항아이디
	 * @param qstnSeqno 		문항순번
	 * @param qstnCnddtSeqno 	변경할 문항후보순번
	 */
    @Override
	public void qstnCnddtSeqnoModify(QstnVO vo) {
		qstnDAO.qstnCnddtSeqnoModify(vo);
	}

	/**
	 * 문항조회
	 *
	 * @param examDtlId 			시험상세아이디
	 * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
	 * @param qstnId 				문항아이디
	 * @param qstnGbncd 			문항구분코드
	 * return 문항 정보
	 */
    @Override
	public QstnVO qstnSelect(QstnVO vo) {
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
     */
    @Override
    public void quizQstnDelete(QstnVO vo) {
    	// 1. 문항 삭제여부 수정
    	qstnDAO.qstnDelynModify(vo);

    	// 2. 문항 미삭제 순번 수정
    	qstnDAO.qstnDelNSeqnoModify(vo);
    }

    /**
     * 퀴즈문항점수수정
     *
     * @param examDtlId		시험상세아이디
     */
    @Override
    public void quizQstnScrModify(QstnVO vo) {
    	qstnDAO.quizQstnScrModify(vo);
    }

    /**
	 * 퀴즈문항점수일괄수정
	 *
	 * @param examDtlId		시험상세아이디
	 */
    @Override
	public void quizQstnScrBulkModify(QstnVO vo) {
    	qstnDAO.quizQstnScrBulkModify(vo);
	}

    /**
	 * 출제완료퀴즈문항점수일괄수정
	 *
     * @param examDtlId 시험상세아이디
     * @param qstnSeqno 문항순번
     * @param qstnScr 	문항점수
	 */
	public void cmptnYQuizQstnScrBulkModify(List<Map<String, Object>> list) {
		qstnDAO.cmptnYQuizQstnScrBulkModify(list);
	}

    /**
     * 교수문항복사퀴즈문항목록조회
     *
     * @param examDtlId 	시험상세아이디
     * @return 퀴즈문항목록
     */
    @Override
	public List<EgovMap> profQstnCopyQuizQstnList(QstnVO vo) {
    	return qstnDAO.profQstnCopyQuizQstnList(vo);
    }

    /**
     * 퀴즈문항가져오기
     *
     * @param copyQstnId 	복사문항아이디
     * @param examDtlId 	시험상세아이디
     */
    @Override
	public void quizQstnCopy(List<Map<String, Object>> list) {
    	for(Map<String, Object> map : list) {
    		map.put("qstnId", IdGenUtil.genNewId(IdPrefixType.QSTN));
		}

    	// 1. 문항 등록
    	qstnDAO.quizQstnCopy(list);

    	// 2 문항보기항목 등록
    	qstnVwitmDAO.qstnVwitmCopy(list);
	}

    /**
     * 퀴즈문항분포바차트
     *
     * @param examDtlId 	시험상세아이디
     * @param qstnId 		문항아이디
     * @param exampprId		시험지아이디
     * @return 퀴즈문항분포
     */
    @Override
	public ResultDTO<EgovMap> quizQstnDistributionBarChart(Map<String, Object> params) {
    	List<EgovMap> returnList = new ArrayList<>();
        EgovMap returnMap = new EgovMap();

        // 1. 문항조회
        QstnVO qstn = new QstnVO();
        qstn.setQstnId((String) params.get("qstnId"));
        qstn.setExamDtlId((String) params.get("examDtlId"));
        qstn.setQstnGbncd("GENERAL");
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

        // 단일, 다중, OX선택형
        if("ONE_CHC".equals(qstn.getQstnRspnsTycd()) || "MLT_CHC".equals(qstn.getQstnRspnsTycd()) || "OX_CHC".equals(qstn.getQstnRspnsTycd())) {
	        for(EgovMap map : answShtList) {
	        	String answShtCts = (String) map.getOrDefault("answShtCts", "");
	        	if (answShtCts == null) answShtCts = "";
	        	if(!answShtCts.isEmpty()) {
	        		for(int i = 0; i < answShtCts.split("@#").length; i++) {
	        			int answShtno = Integer.parseInt(answShtCts.split("@#")[i]);
	        			int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[answShtno-1]);
	        			int baseSeqno = Integer.parseInt(String.valueOf(map.get("baseDsplySeqno")).split("@#")[answShtno-1]);

	        			// OX선택형 라벨은 O,X 고정순서
	        			if("OX_CHC".equals(qstn.getQstnRspnsTycd())) {
	        				int answIdx = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[0]) == 1 ? answShtno - 1 : answShtno == 1 ? answShtno : 0;
	        				String emplAlphabet = StringUtil.nvl(emplAlphabetArray[answIdx]).toLowerCase();
	        				emplMap.put(emplAlphabetArray[answIdx], Integer.parseInt(StringUtil.nvl(emplMap.get(emplAlphabet), "0")) + 1);
	        			} else {
	        				// 화면표시순서와 기준순서 일치시
	        				if(dsplySeqno == baseSeqno) {
	        					String emplAlphabet = StringUtil.nvl(emplAlphabetArray[answShtno - 1]).toLowerCase();
	        					emplMap.put(emplAlphabetArray[answShtno - 1], Integer.parseInt(StringUtil.nvl(emplMap.get(emplAlphabet), "0")) + 1);

	        					// 화면표시순서와 기존순서 불일치시
	        				} else {
	        					int answIdx = Arrays.asList(String.valueOf(map.get("baseDsplySeqno")).split("@#")).indexOf(String.valueOf(dsplySeqno));
	        					String emplAlphabet = StringUtil.nvl(emplAlphabetArray[answIdx]).toLowerCase();
	        					emplMap.put(emplAlphabetArray[answIdx], Integer.parseInt(StringUtil.nvl(emplMap.get(emplAlphabet), "0")) + 1);
	        				}
	        			}
	        		}
	        	}
        	}
        }

        returnMap.put("emplMap", JsonUtil.getJsonString(emplMap));
        returnMap.put("examQstnList", vwitmList);
        returnList.add(returnMap);

    	return new ResultDTO<EgovMap>().setReturnList(returnList);
    }

	/**
     * 퀴즈문항정답현황파이차트
     *
     * @param examDtlId 	시험상세아이디
     * @param qstnId 		문항아이디
     * @param exampprId		시험지아이디
     * @return 퀴즈문항분포
     */
    @Override
	public ResultDTO<EgovMap> quizQstnCransStatusPieChart(Map<String, Object> params) {
    	List<EgovMap> returnList = new ArrayList<>();
        EgovMap returnMap = new EgovMap();

        // 1. 문항조회
        QstnVO qstn = new QstnVO();
        qstn.setQstnId((String) params.get("qstnId"));
        qstn.setExamDtlId((String) params.get("examDtlId"));
        qstn.setQstnGbncd("GENERAL");
        qstn = qstnDAO.qstnSelect(qstn);

        // 2. 문항보기항목목록조회
        QstnVwitmVO vwitm = new QstnVwitmVO();
        vwitm.setQstnId(qstn.getQstnId());
        List<QstnVwitmVO> vwitmList = qstnVwitmDAO.qstnVwitmList(vwitm);

        // 3. 시험응시답안목록조회
        List<EgovMap> answShtList = tkexamAnswShtDAO.qstnTkexamAnswShtCtsList(qstn.getQstnId(), (String) params.get("exampprId"));

        // VO 리스트를 문항보기항목순번 기준으로 Map으로 변환
        Map<Integer, QstnVwitmVO> voMap = vwitmList.stream().collect(Collectors.toMap(QstnVwitmVO::getQstnVwitmSeqno, vo -> vo));

        EgovMap emplMap = new EgovMap();
        emplMap.put("정답", 0);
        emplMap.put("오답", 0);

        for(EgovMap map : answShtList) {
        	boolean isCrans = false;
        	String answShtCts = (String) map.getOrDefault("answShtCts", "");
        	if (answShtCts == null) answShtCts = "";
        	// 단일, 다중선택형
        	if("ONE_CHC".equals(qstn.getQstnRspnsTycd()) || "MLT_CHC".equals(qstn.getQstnRspnsTycd())) {
	        	if("ONE_CHC".equals(qstn.getQstnRspnsTycd()) && "CRANS_MLT".equals(qstn.getCransTycd())) {
	        		isCrans = true;
	        	} else {
	        		if(!answShtCts.isEmpty()) {
	        			for(int i = 0; i < answShtCts.split("@#").length; i++) {
	        				int answShtno = Integer.parseInt(answShtCts.split("@#")[i]);
	        				int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[answShtno-1]);

	        				QstnVwitmVO vwitmVO = voMap.get(dsplySeqno);
	        				isCrans = "Y".equals(vwitmVO.getCransYn());
	        				if("N".equals(vwitmVO.getCransYn())) break;
	        			}
	        		}
	        	}

		    // OX선택형
	        } else if("OX_CHC".equals(qstn.getQstnRspnsTycd())) {
	        	if(!answShtCts.isEmpty()) {
	        		for(int i = 0; i < answShtCts.split("@#").length; i++) {
	        			int answShtno = Integer.parseInt(answShtCts.split("@#")[i]);
	        			int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[answShtno-1]);

	        			QstnVwitmVO vwitmVO = voMap.get(dsplySeqno);
	        			isCrans = "Y".equals(vwitmVO.getCransYn());
	        		}
	        	}

	        // 서술형
	        } else if("LONG_TEXT".equals(qstn.getQstnRspnsTycd())) {
	        	int scr = Integer.parseInt(StringUtil.nvl(map.get("scr"), "0"));
	        	isCrans = scr > 0;

	        // 단답형
	        } else if("SHORT_TEXT".equals(qstn.getQstnRspnsTycd())) {
	        	for(int i = 0; i < answShtCts.split("@#").length; i++) {
	        		String finalAnswShtCts = answShtCts.split("@#")[i];
        			int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[i]);

        			// 정답순서에상관없이
        			if("CRANS_NOT_INORDER".equals(qstn.getCransTycd())) {
        				isCrans = voMap.entrySet().stream()
        					    .filter(entry ->
        					        Arrays.asList(entry.getValue().getQstnVwitmCts().split("\\|")).contains(finalAnswShtCts)
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
						isCrans = Arrays.asList(vwitmVO.getQstnVwitmCts().split("\\|")).contains(finalAnswShtCts);
						if(!isCrans) break;
					}
        		}

	        // 연결형
	        } else if("LINK".equals(qstn.getQstnRspnsTycd())) {
	        	for(int i = 0; i < String.valueOf(map.get("answShtCts")).split("@#").length; i++) {
	        		String finalAnswShtCts = answShtCts.split("@#")[i];
        			int dsplySeqno = Integer.parseInt(String.valueOf(map.get("qstnVwitmDsplySeq")).split("@#")[i]);

        			QstnVwitmVO vwitmVO = voMap.get(dsplySeqno);
					isCrans = Arrays.asList(vwitmVO.getQstnVwitmCts().split("\\|")).contains(finalAnswShtCts);
					if(!isCrans) break;
        		}
	        }

        	if(isCrans) {
    			emplMap.put("정답", Integer.parseInt(StringUtil.nvl(emplMap.get("정답"), "0")) + 1);
    		} else {
    			emplMap.put("오답", Integer.parseInt(StringUtil.nvl(emplMap.get("오답"), "0")) + 1);
    		}
        }

        returnMap.put("emplMap", JsonUtil.getJsonString(emplMap));
        returnMap.put("examQstnList", vwitmList);
        returnList.add(returnMap);

    	return new ResultDTO<EgovMap>().setReturnList(returnList);
    }

    /**
	* 문항엑셀샘플데이터
	*
	* @param examDtlId				시험상세아이디
	* @param exrcsSddnQstnBscId		연습돌발문항기본아이디
    * @param qstnGbncd				문항구분코드
	* @param excelGrid 				엑셀그리드
	*/
	public HashMap<String, Object> qstnExcelSampleData(QstnVO vo) {
		List<EgovMap> resultList = new ArrayList<EgovMap>();
		String qstnSeqno = "";

        // 문항 1-1 ( 단일선택형 )
		EgovMap egovMap = new EgovMap();
        egovMap.put("qstnSeqno", "1");
        egovMap.put("qstnCnddtSeqno", "1");
        egovMap.put("qstnTtl", "1-1번 문항");
        egovMap.put("qstnCts", "1-1번 문항에 대한 답을 선택하세요.");
        egovMap.put("qstnRspnsTycd", "ONE_CHC");
        egovMap.put("qstnVwitmSeqno", "1");
        egovMap.put("qstnVwitmCts", "단일선택형 1번 보기");
        egovMap.put("cransYn", "N");
        egovMap.put("qstnDfctlvTycd", "MIDDLE");
        egovMap.put("qstnScr", "25");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "2");
        egovMap.put("qstnVwitmCts", "단일선택형 2번 보기");
        egovMap.put("cransYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "3");
        egovMap.put("qstnVwitmCts", "단일선택형 3번 보기");
        egovMap.put("cransYn", "Y");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "4");
        egovMap.put("qstnVwitmCts", "단일선택형 4번 보기");
        egovMap.put("cransYn", "N");
        resultList.add(egovMap);

        // 문항 (퀴즈 : 1-2, 연습문제 : 2-1) ( 다중선택형 )
        egovMap = new EgovMap();
        if("GENERAL".equals(vo.getQstnGbncd())) {
        	egovMap.put("qstnCnddtSeqno", "2");
        	egovMap.put("qstnTtl", "1-2번 문항");
        	egovMap.put("qstnCts", "1-2번 문항에 대한 답을 선택하세요.");
        } else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
        	egovMap.put("qstnSeqno", "2");
        	egovMap.put("qstnTtl", "2-1번 문항");
        	egovMap.put("qstnCts", "2-1번 문항에 대한 답을 선택하세요.");
        }
        egovMap.put("qstnRspnsTycd", "MLT_CHC");
        egovMap.put("qstnVwitmSeqno", "1");
        egovMap.put("qstnVwitmCts", "다중선택형 1번 보기");
        egovMap.put("cransYn", "Y");
        egovMap.put("qstnDfctlvTycd", "HIGH");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "2");
        egovMap.put("qstnVwitmCts", "다중선택형 2번 보기");
        egovMap.put("cransYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "3");
        egovMap.put("qstnVwitmCts", "다중선택형 3번 보기");
        egovMap.put("cransYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "4");
        egovMap.put("qstnVwitmCts", "다중선택형 4번 보기");
        egovMap.put("cransYn", "Y");
        resultList.add(egovMap);

        // 문항 (퀴즈 : 2-1, 연습문제 : 3-1) ( OX선택형 )
        qstnSeqno = "EXRCS_QSTN".equals(vo.getQstnGbncd()) ? "3" : "2";
        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", qstnSeqno);
        egovMap.put("qstnCnddtSeqno", "1");
        egovMap.put("qstnTtl", qstnSeqno+"-1번 문항");
        egovMap.put("qstnCts", qstnSeqno+"-1번 문항에 대한 답을 선택하세요.");
        egovMap.put("qstnRspnsTycd", "OX_CHC");
        egovMap.put("qstnVwitmCransCts", "O");
        egovMap.put("qstnDfctlvTycd", "NONE");
        egovMap.put("qstnScr", "25");
        resultList.add(egovMap);

        // 문항 (퀴즈 : 2-2, 연습문제 : 4-1) ( 서술형 )
        egovMap = new EgovMap();
        if("GENERAL".equals(vo.getQstnGbncd())) {
        	egovMap.put("qstnCnddtSeqno", "2");
        	egovMap.put("qstnTtl", "2-2번 문항");
        	egovMap.put("qstnCts", "2-2번 문항에 대한 답을 입력하세요.");
        } else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
        	egovMap.put("qstnSeqno", "4");
        	egovMap.put("qstnTtl", "4-1번 문항");
        	egovMap.put("qstnCts", "4-1번 문항에 대한 답을 입력하세요.");
        }
        egovMap.put("qstnRspnsTycd", "LONG_TEXT");
        egovMap.put("qstnDfctlvTycd", "LOW");
        resultList.add(egovMap);

        // 문항 (퀴즈 : 3-1, 연습문제 : 5-1) ( 단답형 )
        qstnSeqno = "EXRCS_QSTN".equals(vo.getQstnGbncd()) ? "5" : "3";
        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", qstnSeqno);
        egovMap.put("qstnCnddtSeqno", "1");
        egovMap.put("qstnTtl", qstnSeqno+"-1번 문항");
        egovMap.put("qstnCts", qstnSeqno+"-1번 문항에 대한 답을 입력하세요.");
        egovMap.put("qstnRspnsTycd", "SHORT_TEXT");
        egovMap.put("qstnVwitmSeqno", "1");
        egovMap.put("qstnVwitmCts", "1번정답1|1번정답2|1번정답3");
        egovMap.put("qstnDfctlvTycd", "LOW");
        egovMap.put("qstnScr", "25");
        egovMap.put("cransTycd", "CRANS_INORDER");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "2");
        egovMap.put("qstnVwitmCts", "2번정답1|2번정답2");
        egovMap.put("qstnDfctlvTycd", "LOW");
        resultList.add(egovMap);

        // 문항 (퀴즈 : 4-1, 연습문제 : 6-1) ( 연결형 )
        qstnSeqno = "EXRCS_QSTN".equals(vo.getQstnGbncd()) ? "6" : "4";
        egovMap = new EgovMap();
        egovMap.put("qstnSeqno", qstnSeqno);
        egovMap.put("qstnCnddtSeqno", "1");
        egovMap.put("qstnTtl", qstnSeqno+"-1번 문항");
        egovMap.put("qstnCts", qstnSeqno+"-1번 문항에 대한 답을 끌어서 넣으세요.");
        egovMap.put("qstnRspnsTycd", "LINK");
        egovMap.put("qstnVwitmSeqno", "1");
        egovMap.put("qstnVwitmCts", "1번보기내용");
        egovMap.put("qstnVwitmCransCts", "1번정답내용");
        egovMap.put("qstnDfctlvTycd", "MIDDLE");
        egovMap.put("qstnScr", "25");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "2");
        egovMap.put("qstnVwitmCts", "2번보기내용");
        egovMap.put("qstnVwitmCransCts", "2번정답내용");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("qstnVwitmSeqno", "3");
        egovMap.put("qstnVwitmCts", "3번보기내용");
        egovMap.put("qstnVwitmCransCts", "3번정답내용");
        resultList.add(egovMap);

        List<String> searchValueList = new ArrayList<>();
        searchValueList.add("⊙ 주의사항 : 엑셀로 문항 등록시 기존 등록된 문항은 삭제됩니다.");
        searchValueList.add("문항순번 : 정수로 1부터 시작");
        if("GENERAL".equals(vo.getQstnGbncd())) searchValueList.add("문항후보순번 : 문항 단위로, 정수로 1부터 시작. 문항이 넘어가면 다시 1부터 시작");
        searchValueList.add("문항명 : 해당 문항에 대한 제목");
        searchValueList.add("문항내용 : 해당 문항에 대한 내용");
        searchValueList.add("문항답변유형코드 : 단일선택형(ONE_CHC), 다중선택형(MLT_CHC), OX선택형(OX_CHC), 연결형(LINK), 단답형(SHORT_TEXT), 서술형(LONG_TEXT)");
        searchValueList.add("문항보기항목순번 : 문항 단위로, 정수로 1부터 시작. 서술형(LONG_TEXT) OR 연결형(LINK)은 빈칸으로 입력\n"
                + "단일선택형(ONE_CHC), 다중선택형(MLT_CHC), 연결형(LINK)은 최대 10까지, 단답형(SHORT_TEXT)은 최대 5까지");
        searchValueList.add("문항보기항목내용 : 단일선택형(ONE_CHC), 다중선택형(MLT_CHC)은 해당 순번의 정답내용 입력\n"
                + "단답형(SHORT_TEXT)은 해당 순번의 정답내용을 \"|\"로 구분하여 최대 5개까지 입력, 입력한 내용중에 하나만 맞아도 정답\n"
                + "연결형(LINK)은 해당 순번의 보기내용 입력\n"
                + "OX선택형(OX_CHC)과 서술형(LONG_TEXT)은 빈칸으로 입력");
        searchValueList.add("문항보기항목정답내용 : 연결형(LINK)은 해당 순번과 연결할 정답내용 입력\n"
                + "OX선택형(OX_CHC)은 O, X 중 정답으로 사용할 값 입력\n"
                + "나머지 문항답변유형코드는 빈칸으로 입력");
        searchValueList.add("정답여부 : 단일선택형(ONE_CHC), 다중선택형(MLT_CHC)만 정답으로 사용할 문항에 Y입력, 빈칸으로 입력시 N 처리");
        searchValueList.add("문항난이도 : 상관없음(NONE), 하(LOW), 중(MIDDLE), 상(HIGH), 빈칸으로 입력시 NONE 처리");
        if("GENERAL".equals(vo.getQstnGbncd())) searchValueList.add("문항점수 : 문항순번 단위로, 해당 문항의 점수 소수점 최대 2자리까지 입력");
        searchValueList.add("정답유형코드 : 단답형(SHORT_TEXT)만 정답순서에맞춰서(CRANS_INORDER), 정답순서에상관없이(CRANS_NOT_INORDER)");

        // 번호 재할당 (첫번째는 주의사항이라 번호 제외)
        String[] searchValues = new String[searchValueList.size()];
        searchValues[0] = searchValueList.get(0); // 주의사항은 번호 없이
        for (int i = 1; i < searchValueList.size(); i++) {
            searchValues[i] = i + ". " + searchValueList.get(i);
        }

		//POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "문항 엑셀 업로드 양식");
        map.put("sheetName", "sample");
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", resultList);

        return map;
	}

	/**
	* 문항엑셀업로드
	*
	* @param examDtlId 				시험상세아이디
	* @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
    * @param qstnGbncd 				문항구분코드
    * @param uploadFiles 			파일목록
    * @param uploadPath 			파일경로
    * @param excelGrid 				엑셀그리드
	*/
	@Override
	public ResultDTO<EgovMap> qstnExcelUpload(QstnVO vo) {
		ResultDTO<EgovMap> resultVO = new ResultDTO<EgovMap>();
		ObjectMapper mapper = new ObjectMapper();

		List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        List<String> fileIdList = new ArrayList<>();

        // 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(StringUtil.nvl(vo.getExamDtlId(), vo.getExrcsSddnQstnBscId()));
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
        map.put("startRaw", "GENERAL".equals(vo.getQstnGbncd()) ? 18 : 16);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("atflVO", atflVO);
        map.put("searchKey", "excelUpload");

        //엑셀 리더
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
        try {
        	list = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);

        	// 첨부파일 삭제
            attachFileService.deleteAtflByAtflIds(fileIdList.toArray(new String[0]));
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        if(list.size() > 0) {
        	// 문항순번 중복확인
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

        		resultVO.setResultFailed();
        		resultVO.setMessage(duplicates + " 문항순번은 중복 입력된 번호입니다.");
        		return resultVO;
        	}

        	// 문항검사
        	String qstnSeqno = "";		// 문항순번
        	String qstnRspnsTycd = "";	// 문항답변유형코드
        	String qstnScr = "";		// 문항점수
        	for(int i = 0; i < list.size(); i++) {
        		Map<String, Object> qstn = list.get(i);
        		if(hasValue(qstn, "A")) qstnSeqno = str(qstn, "A");

        		if(hasValue(qstn, "B")) {
        			// 일반퀴즈
        			if("GENERAL".equals(vo.getQstnGbncd())) {
        				qstnRspnsTycd = str(qstn, "E");
        			// 연습문제
        			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
        				qstnRspnsTycd = str(qstn, "D");
        			}
        			final String finalQstnRspnsTycd = qstnRspnsTycd;
        			// 문항답변유형코드 빈값
        			if("".equals(finalQstnRspnsTycd)) {
        				resultVO.setResultFailed();
        				resultVO.setMessage((i+18) + "번 줄의 문항답변유형코드를 입력해주세요.");
        				return resultVO;
        			}

	        	    List<CmmnCdVO> qstnRspnsTycdList = new ArrayList<CmmnCdVO>();
	        	    try {
	        	    	qstnRspnsTycdList = cmmnCdService.listCode(vo.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();	// 문항답변유형코드 목록 조회
					} catch (Exception e) {
						System.out.println(e.getMessage());
					}
        	        qstnRspnsTycdList.removeIf(item -> "SRVY".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
        	        // 문항답변유형코드일치여부
        	        boolean isMatched = qstnRspnsTycdList.stream()
        	        	    .anyMatch(cd -> cd.getCd().contains(finalQstnRspnsTycd));
        	        if(!isMatched) {
        	        	resultVO.setResultFailed();
        	        	resultVO.setMessage((i+18) + "번 줄의 문항답변유형코드가 일치하지 않습니다.");
        	        	return resultVO;
        	        }

        	        String nextQstn = "";			// 문항답변유형코드
        	        String qstnVwitmSeqno = "";		// 문항보기항목순번
        	        String qstnVwitmCts = "";		// 문항보기항목내용
        	        String cransTycd = "";			// 정답유형코드
        	        String cransYn = "";			// 정답여부
        	        // 서술형, OX선택형 제외
        	        if(!"LONG_TEXT".equals(qstnRspnsTycd) && !"OX_CHC".equals(qstnRspnsTycd)) {
        	        	for(int k = i; k < list.size(); k++) {
        	        		// 일반퀴즈
        	        		if("GENERAL".equals(vo.getQstnGbncd())) {
        	        			nextQstn = str(list.get(k), "E");
        	        			qstnVwitmSeqno = str(list.get(k), "F");
        	        			qstnVwitmCts = str(list.get(k), "G");
        	        		// 연습문제
                			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
                				nextQstn = str(list.get(k), "D");
                				qstnVwitmSeqno = str(list.get(k), "E");
                				qstnVwitmCts = str(list.get(k), "F");
                			}
        	        		if (!"".equals(nextQstn) && k > i) break;
        	        		if("".equals(qstnVwitmSeqno)) {
        	        			resultVO.setResultFailed();
        	        			resultVO.setMessage((k+18) + "번 줄의 문항보기항목순번이 없습니다.");
        	        			return resultVO;
        	        		}
        	        		if("".equals(qstnVwitmCts)) {
        	        			resultVO.setResultFailed();
        	        			resultVO.setMessage((k+18) + "번 줄의 문항보기항목내용이 없습니다.");
        	        			return resultVO;
        	        		}
        	        	}
        	        }

        	        // 단답형
        	        if("SHORT_TEXT".equals(qstnRspnsTycd)) {
        	        	for(int k = i; k < list.size(); k++) {
        	        		// 일반퀴즈
        	        		if("GENERAL".equals(vo.getQstnGbncd())) {
        	        			nextQstn = str(list.get(k), "E");
        	        			qstnVwitmCts = str(list.get(k), "G");
        	        			cransTycd = str(qstn, "L");
        	        		// 연습문제
                			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
                				nextQstn = str(list.get(k), "D");
                				qstnVwitmCts = str(list.get(k), "F");
                				cransTycd = str(qstn, "J");
                			}
        	        		if (!"".equals(nextQstn) && k > i) break;
        	        		if(qstnVwitmCts.split("\\|").length > 5) {
        	        			resultVO.setResultFailed();
        	        			resultVO.setMessage((k+18) + "번 줄의 문항보기항목내용은 최대 5개까지 등록 할 수 있습니다.");
        	        			return resultVO;
        	        		}
        	        	}

        	        	if("".equals(cransTycd)) {
        	        		resultVO.setResultFailed();
        	        		resultVO.setMessage((i+18) + "번 줄의 정답유형코드를 입력해주세요.");
        	        		return resultVO;
        	        	}
        	        }

        	        // 단일, 다중선택형
        	        if("ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd)) {
        	        	int cransYnCnt = 0;	// 정답여부 Y 카운트
        	        	for(int k = i; k < list.size(); k++) {
        	        		// 일반퀴즈
        	        		if("GENERAL".equals(vo.getQstnGbncd())) {
        	        			nextQstn = str(list.get(k), "E");
        	        			cransYn = str(list.get(k), "I");
        	        		// 연습문제
                			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
                				nextQstn = str(list.get(k), "D");
                				cransYn = str(list.get(k), "H");
                			}
        	        		if (!"".equals(nextQstn) && k > i) break;
        	        		if("".equals(cransYn)) {
        	        			resultVO.setResultFailed();
        	                	resultVO.setMessage((k+18) + "번 줄의 기타입력여부가 없습니다.");
        	                	return resultVO;
        	                }
        	                if("Y".equals(cransYn)) cransYnCnt++;
        	        	}
        	        	if(cransYnCnt > 1 && "ONE_CHC".equals(qstnRspnsTycd)) {
        	        		String qstnCnddtSeqno = str(qstn, "B");
        	        		resultVO.setResultFailed();
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
        	// 일괄등록용 목록
        	List<QstnVO> qstnList = new ArrayList<QstnVO>();			// 문항목록
        	List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();	// 문항보기항목목록
        	for(int i = 0; i < list.size(); i++) {
        		Map<String, Object> qstn = list.get(i);
        		if(hasValue(qstn, "A")) {
        			qstnSeqno = str(qstn, "A");
        			qstnScr = "EXRCS_QSTN".equals(vo.getQstnGbncd()) ? "0" : hasValue(qstn, "K") ? str(qstn, "K") : "0";
        		}

        		// 문항
        		if(hasValue(qstn, "B")) {
        			String qstnCnddtSeqno = "";								// 문항후보순번
        			String qstnTtl = qstnSeqno+"-"+qstnCnddtSeqno+"번 문항";	// 문항명
        			String qsntCts = "";									// 문항내용
        			String qstnDfctlvTycd = "NONE";							// 문항난이도유형코드
        			String cransTycd = "";									// 정답유형코드
        			// 일반퀴즈
        			if("GENERAL".equals(vo.getQstnGbncd())) {
        				qstnRspnsTycd = str(qstn, "E");
        				qstnCnddtSeqno = str(qstn, "B");
        				qstnTtl = hasValue(qstn, "C") ? str(qstn, "C") : qstnTtl;
        				qsntCts = str(qstn, "D");
        				qstnDfctlvTycd = hasValue(qstn, "J") ? str(qstn, "J") : qstnDfctlvTycd;
        				cransTycd = "MLT_CHC".equals(qstnRspnsTycd) ? "CRANS_MLT" : hasValue(qstn, "L") ? str(qstn, "L") : cransTycd;
        			// 연습문제
        			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
        				qstnRspnsTycd = str(qstn, "D");
        				qstnCnddtSeqno = "1";
        				qstnTtl = hasValue(qstn, "B") ? str(qstn, "B") : qstnTtl;
        				qsntCts = str(qstn, "C");
        				qstnDfctlvTycd = hasValue(qstn, "I") ? str(qstn, "I") : qstnDfctlvTycd;
        				cransTycd = "MLT_CHC".equals(qstnRspnsTycd) ? "CRANS_MLT" : hasValue(qstn, "J") ? str(qstn, "J") : cransTycd;
        			}

        			List<ExrcsSddnQstnBscVO> exrcsSddnQstnList = new ArrayList<ExrcsSddnQstnBscVO>();
        			if("EXRCS_QSTN".equals(vo.getQstnGbncd())) exrcsSddnQstnList = exrcsSddnQstnBscDAO.exrcsSddnQstnBscListByGrpId(vo.getExrcsSddnQstnBscId());	// 연습돌발문항기본동일그룹목록조회

        			QstnVO qstnVO = new QstnVO();
        			qstnVO.setQstnTtl(qstnTtl);
        			qstnVO.setQstnCts(qsntCts);
        			qstnVO.setQstnSeqno(Integer.parseInt(qstnSeqno));
        			qstnVO.setQstnCnddtSeqno(Integer.parseInt(qstnCnddtSeqno));
        			qstnVO.setQstnGbncd(vo.getQstnGbncd());
        			qstnVO.setQstnRspnsTycd(qstnRspnsTycd);
        			qstnVO.setQstnScr(new BigDecimal(qstnScr));
        			qstnVO.setQstnDfctlvTycd(qstnDfctlvTycd);
        			qstnVO.setCransTycd(cransTycd);
        			qstnVO.setRgtrId(vo.getRgtrId());
        			// 일반퀴즈
        			if("GENERAL".equals(vo.getQstnGbncd())) {
            			qstnVO.setQstnId(IdGenUtil.genNewId(IdPrefixType.QSTN));
            			qstnVO.setExamDtlId(vo.getExamDtlId());
            			qstnList.add(qstnVO);
        			// 연습문제
        			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
        				for(ExrcsSddnQstnBscVO exrcs : exrcsSddnQstnList) {
        					QstnVO copyQstn = mapper.convertValue(qstnVO, QstnVO.class);
        					copyQstn.setQstnId(IdGenUtil.genNewId(IdPrefixType.QSTN));
        					copyQstn.setExrcsSddnQstnBscId(exrcs.getExrcsSddnQstnBscId());
                			qstnList.add(copyQstn);
        				}
        			}

        			// 문항보기항목
        			for(int k = i; k < list.size(); k++) {
        				String nextQstn = "";		// 문항답변유형코드
        				String qstnVwitmCts = "";	// 문항보기항목내용
        				String cransYn = "";		// 정답여부
        				int qstnVwitmSeqno = 1;		// 문항보기항목순번
        				// 일반퀴즈
    	        		if("GENERAL".equals(vo.getQstnGbncd())) {
    	        			nextQstn = hasValue(list.get(k), "E") ? str(list.get(k), "E") : "";
    	        		// 연습문제
            			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
            				nextQstn = hasValue(list.get(k), "D") ? str(list.get(k), "D") : "";
            			}

        				if (!"".equals(nextQstn) && k > i) break;
        				// 서술형, OX선택형 아닌경우
        				if(!"LONG_TEXT".equals(qstnRspnsTycd) && !"OX_CHC".equals(qstnRspnsTycd)) {
        					// 일반퀴즈
        	        		if("GENERAL".equals(vo.getQstnGbncd())) {
        	        			cransYn = "ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd) ? str(list.get(k), "I") : "Y";
        	        			qstnVwitmCts = "LINK".equals(qstnRspnsTycd) ? str(list.get(k), "G") + "|" + str(list.get(k), "H") : str(list.get(k), "G");
        	        			qstnVwitmSeqno = Integer.parseInt(str(list.get(k), "F"));
        	        		// 연습문제
                			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
                				cransYn = "ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd) ? str(list.get(k), "H") : "Y";
                				qstnVwitmCts = "LINK".equals(qstnRspnsTycd) ? str(list.get(k), "F") + "|" + str(list.get(k), "G") : str(list.get(k), "F");
                				qstnVwitmSeqno = Integer.parseInt(str(list.get(k), "E"));
                			}
        					QstnVwitmVO vwitmVO = new QstnVwitmVO();
        					vwitmVO.setQstnVwitmGbncd("TXT");
        					vwitmVO.setQstnVwitmCts(qstnVwitmCts);
        					vwitmVO.setCransYn(cransYn);
        					vwitmVO.setQstnVwitmSeqno(qstnVwitmSeqno);
        					vwitmVO.setRgtrId(vo.getRgtrId());
        					// 일반퀴즈
                			if("GENERAL".equals(vo.getQstnGbncd())) {
                				vwitmVO.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
            					vwitmVO.setQstnId(qstnVO.getQstnId());
            					vwitmList.add(vwitmVO);
                			// 연습문제
                			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
                				for(QstnVO qs : qstnList) {
                					if(qstnVO.getQstnSeqno() == qs.getQstnSeqno()) {
                						QstnVwitmVO copyVwitm = mapper.convertValue(vwitmVO, QstnVwitmVO.class);
                						copyVwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
                						copyVwitm.setQstnId(qs.getQstnId());
                						vwitmList.add(copyVwitm);
                					}
                				}
                			}
        				// OX선택형
        				} else if("OX_CHC".equals(qstnRspnsTycd)) {
        					for(int seq = 1; seq <= 2; seq++) {
        						qstnVwitmCts = seq == 1 ? "O" : "X";
        						// 일반퀴즈
            	        		if("GENERAL".equals(vo.getQstnGbncd())) {
            	        			cransYn = qstnVwitmCts.equals(str(list.get(k), "H")) ? "Y" : "N";
            	        		// 연습문제
                    			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
                    				cransYn = qstnVwitmCts.equals(str(list.get(k), "G")) ? "Y" : "N";
                    			}
        						QstnVwitmVO vwitmVO = new QstnVwitmVO();
            					vwitmVO.setQstnVwitmGbncd("TXT");
            					vwitmVO.setQstnVwitmCts(qstnVwitmCts);
            					vwitmVO.setCransYn(cransYn);
            					vwitmVO.setQstnVwitmSeqno(seq);
            					vwitmVO.setRgtrId(vo.getRgtrId());
            					// 일반퀴즈
                    			if("GENERAL".equals(vo.getQstnGbncd())) {
                    				vwitmVO.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
                					vwitmVO.setQstnId(qstnVO.getQstnId());
                					vwitmList.add(vwitmVO);
                    			// 연습문제
                    			} else if("EXRCS_QSTN".equals(vo.getQstnGbncd())) {
                    				for(QstnVO qs : qstnList) {
                    					if(qstnVO.getQstnSeqno() == qs.getQstnSeqno()) {
                    						QstnVwitmVO copyVwitm = mapper.convertValue(vwitmVO, QstnVwitmVO.class);
                    						copyVwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
                    						copyVwitm.setQstnId(qs.getQstnId());
                    						vwitmList.add(copyVwitm);
                    					}
                    				}
                    			}
        					}
        				}
        			}
        		}
        	}

        	if(qstnList.size() > 0) qstnDAO.qstnBulkRegist(qstnList); 				// 문항일괄등록
        	if(vwitmList.size() > 0) qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);	// 문항보기항목일괄등록
        }

        resultVO.setResultSuccess();
        return resultVO;
	}

	/**
	 * 퀴즈문항옵션수정
	 *
	 * @param QstnVO
	 */
	@Override
	public void quizQstnOptionModify(QstnVO vo, String qstnsStr) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
		try {
			qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		// 문항수정
		qstnDAO.qstnModify(vo);

		// 문항보기항목목록조회
		QstnVwitmVO vwitmVO = new QstnVwitmVO();
		vwitmVO.setQstnId(vo.getQstnId());
		List<QstnVwitmVO> vwitmList = qstnVwitmDAO.qstnVwitmList(vwitmVO);

		// 문항보기항목일괄수정
		List<QstnVwitmVO> modifyVwitmList = new ArrayList<QstnVwitmVO>();
        if (qstns != null && !qstns.isEmpty()) {
            for (Map<String, Object> map : qstns) {
            	QstnVwitmVO result = vwitmList.stream()
            		    .filter(vwitm -> vwitm.getQstnVwitmSeqno() == (Integer) map.get("qstnVwitmSeqno"))
            		    .findFirst()
            		    .orElse(null);

                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(vo.getQstnId());
                vwitm.setQstnVwitmGbncd("TXT");
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

        if(answModifyList.size() > 0) tkexamAnswShtDAO.tkexamAnswShtScrModify(answModifyList);	// 시험응시답안점수수정
	}

	/**
	 * 연습문제일괄문항등록
	 *
	 * @param QstnVO
	 * @param qstnsStr	문항보기항목정보
	 */
	@Override
	public void exrcsQstnBulkQstnRegist(QstnVO vo, String qstnsStr) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
		try {
			qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		// 일괄등록용 목록
		List<QstnVO> qstnList = new ArrayList<QstnVO>();				// 문항목록
		List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();		// 문항보기항목목록

		List<ExrcsSddnQstnBscVO> exrcsSddnQstnList = exrcsSddnQstnBscDAO.exrcsSddnQstnBscListByGrpId(vo.getExrcsSddnQstnBscId());	// 연습돌발문항기본동일그룹목록조회

		for(ExrcsSddnQstnBscVO qstn : exrcsSddnQstnList) {
			QstnVO copyQstn = mapper.convertValue(vo, QstnVO.class);
			copyQstn.setQstnId(IdGenUtil.genNewId(IdPrefixType.QSTN));
			copyQstn.setExrcsSddnQstnBscId(qstn.getExrcsSddnQstnBscId());
			qstnList.add(copyQstn);
			for (Map<String, Object> map : qstns) {
                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(copyQstn.getQstnId());
                vwitm.setQstnVwitmGbncd("TXT");
                vwitm.setRgtrId(vo.getRgtrId());
                vwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
                vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
                vwitm.setCransYn((String) map.get("cransYn"));
                vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));
                vwitmList.add(vwitm);
            }
		}

		if(qstnList.size() > 0) qstnDAO.qstnBulkRegist(qstnList);				// 문항일괄등록
		if(vwitmList.size() > 0) qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);	// 문항보기항목일괄등록
	}

	/**
	 * 연습문제일괄문항수정
	 *
	 * @param QstnVO
	 * @param qstnsStr	문항보기항목정보
	 */
    @Override
    public void exrcsQstnBulkQstnModify(QstnVO vo, String qstnsStr) {
    	ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
		try {
			qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		// 일괄등록용 목록
		List<QstnVO> qstnList = new ArrayList<QstnVO>();				// 문항목록
		List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();		// 문항보기항목목록

		List<ExrcsSddnQstnBscVO> exrcsSddnQstnList = exrcsSddnQstnBscDAO.exrcsSddnQstnBscListByGrpId(vo.getExrcsSddnQstnBscId());	// 연습돌발문항기본동일그룹목록조회

		for(ExrcsSddnQstnBscVO qstn : exrcsSddnQstnList) {
			QstnVO copyQstn = mapper.convertValue(vo, QstnVO.class);
			copyQstn.setExrcsSddnQstnBscId(qstn.getExrcsSddnQstnBscId());
			qstnList.add(copyQstn);
		}

		if(qstnList.size() > 0) {
			qstnDAO.exrcsSddnQstnBulkModify(qstnList);							// 연습돌발문항일괄수정
			qstnVwitmDAO.exrcsSddnQstnVwitmBulkDelete(qstnList);				// 연습돌발문항보기항목일괄삭제
			List<String> qstnIdList = qstnDAO.exrcsSddnQstnIdList(qstnList);	// 연습돌발문항아이디목록

			for(String qstnId : qstnIdList) {
				for (Map<String, Object> map : qstns) {
					QstnVwitmVO vwitm = new QstnVwitmVO();
					vwitm.setQstnId(qstnId);
					vwitm.setQstnVwitmGbncd("TXT");
					vwitm.setRgtrId(vo.getRgtrId());
					vwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
					vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
					vwitm.setCransYn((String) map.get("cransYn"));
					vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));
					vwitmList.add(vwitm);
				}
			}

			if(vwitmList.size() > 0) qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);	// 문항보기항목일괄등록
		}
    }

    /**
	 * 연습문제일괄문항순번수정
	 *
	 * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
	 * @param qstnSeqno 			변경할 문항순번
	 * @param searchKey 			문항순번
	 */
    @Override
	public void exrcsQstnBulkQstnSeqnoModify(QstnVO vo) {
    	ObjectMapper mapper = new ObjectMapper();
    	List<ExrcsSddnQstnBscVO> exrcsSddnQstnList = exrcsSddnQstnBscDAO.exrcsSddnQstnBscListByGrpId(vo.getExrcsSddnQstnBscId());	// 연습돌발문항기본동일그룹목록조회
    	List<QstnVO> qstnList = new ArrayList<QstnVO>();	// 문항목록

    	for(ExrcsSddnQstnBscVO qstn : exrcsSddnQstnList) {
			QstnVO copyQstn = mapper.convertValue(vo, QstnVO.class);
			copyQstn.setExrcsSddnQstnBscId(qstn.getExrcsSddnQstnBscId());
			qstnList.add(copyQstn);
		}

    	qstnDAO.exrcsQstnBulkQstnSeqnoModify(qstnList);	// 연습문제일괄문항순번수정
    }

    /**
     * 연습문제일괄문항삭제
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @param qstnSeqno 			문항순번
     */
    @Override
    public void exrcsQstnBulkQstnDelete(QstnVO vo) {
    	ObjectMapper mapper = new ObjectMapper();
    	List<ExrcsSddnQstnBscVO> exrcsSddnQstnList = exrcsSddnQstnBscDAO.exrcsSddnQstnBscListByGrpId(vo.getExrcsSddnQstnBscId());	// 연습돌발문항기본동일그룹목록조회
    	List<QstnVO> qstnList = new ArrayList<QstnVO>();	// 문항목록

    	for(ExrcsSddnQstnBscVO qstn : exrcsSddnQstnList) {
    		QstnVO copyQstn = mapper.convertValue(vo, QstnVO.class);
    		copyQstn.setExrcsSddnQstnBscId(qstn.getExrcsSddnQstnBscId());
    		qstnList.add(copyQstn);
    	}

    	qstnDAO.exrcsQstnBulkDelynModify(qstnList);		// 연습문제일괄삭제여부수정
    	qstnDAO.exrcsQstnBulkDelNSeqnoModify(qstnList); // 연습문제일괄미삭제순번수정
    }

    /**
     * 교수문항복사연습문제목록조회
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @return 연습문제목록
     */
    @Override
	public List<EgovMap> profQstnCopyExrcsQstnList(QstnVO vo) {
		return qstnDAO.profQstnCopyExrcsQstnList(vo);
	}

    /**
     * 연습문제일괄가져오기
     *
     * @param copyQstnId 			복사문항아이디
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     */
    @Override
	public void exrcsQstnBulkCopy(List<Map<String, Object>> list) {
		String exrcsSddnQstnBscId = list.get(0).get("exrcsSddnQstnBscId").toString();
		List<ExrcsSddnQstnBscVO> exrcsSddnQstnList = exrcsSddnQstnBscDAO.exrcsSddnQstnBscListByGrpId(exrcsSddnQstnBscId);	// 연습돌발문항기본동일그룹목록조회

		// 연습문제 분반 있을시 동시 추가
		List<Map<String, Object>> result = exrcsSddnQstnList.stream()
			    .flatMap(exrcs -> list.stream()
			        .map(map -> {
			            Map<String, Object> copied = new HashMap<>(map);
			            copied.put("exrcsSddnQstnBscId", exrcs.getExrcsSddnQstnBscId());
			            copied.put("qstnId", IdGenUtil.genNewId(IdPrefixType.QSTN));
			            return copied;
			        })
			    )
			    .collect(Collectors.toList());

		if(result.size() > 0) {
			qstnDAO.exrcsQstnCopy(result);			// 연습문제가져오기
			qstnVwitmDAO.qstnVwitmCopy(result);		// 문항보기항목가져오기
		}
	}

	/**
	 * 강의주차등록문항수조회
	 *
	 * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
	 * @param qstnGbncd 			문항구분코드
	 * @param sbjctId 				과목아이디
	 * @param lctrWknoSchdlId 		강의주차일정아이디
	 * @param qstnSeqno 			문항순번
	 * return int
	 */
	@Override
	public int lctrWknoRegistQstnCntSelect(Map<String, Object> params) {
		return qstnDAO.lctrWknoRegistQstnCntSelect(params);
	}

	/**
	 * 교수미리보기문항목록조회
	 *
	 * @param examBscId 	시험기본아이디
	 * @param examDtlId 	시험상세아이디
	 * return 문항목록
	 */
	@Override
	public List<QstnVO> profPreviewQstnList(Map<String, Object> params) {
		return qstnDAO.profPreviewQstnList(params);
	}

	private String str(Map<String, Object> map, String key) {
		Object obj = map.get(key);
		return (obj != null) ? obj.toString().trim() : "";
	}

	private boolean hasValue(Map<String, Object> map, String key) {
	    return !str(map, key).isEmpty();
	}

}
