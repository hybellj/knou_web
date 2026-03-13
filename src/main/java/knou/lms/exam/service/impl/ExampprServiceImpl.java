package knou.lms.exam.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.annotation.Resource;

import org.apache.commons.lang3.ObjectUtils;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.exam.dao.ExampprDAO;
import knou.lms.exam.service.ExampprService;
import knou.lms.exam.vo.ExamBscVO;

@Service("exampprService")
public class ExampprServiceImpl extends ServiceBase implements ExampprService {

	@Resource
	private ExampprDAO exampprDAO;

	/**
	* 시험응시시험지답안목록조회
	*
	* @param tkexamId 	시험응시아이디
    * @param userId 	사용자아이디
	* @return 퀴즈응시답안목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> tkexamExampprAnswShtList(String tkexamId, String userId) throws Exception {
		// 시험응시시험지답안목록조회
		List<EgovMap> list = exampprDAO.tkexamExampprAnswShtList(tkexamId, userId);

		// 정답 여부 확인
		for(EgovMap map : list) {
			String qstnRspnsTycd = String.valueOf(map.get("qstnRspnsTycd"));	// 문항답변유형코드

			// 단일, 다중선택형
			if("ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd)) {
				// 문항보기항목 개수
				String vwitmSeqnoStr = Objects.toString(map.get("qstnVwitmDsplySeq"), "");
				int vwitmCnt = vwitmSeqnoStr.isEmpty() ? 0 : vwitmSeqnoStr.split("@#").length;
				// 정답항목 개수
				String cransNoStr = Objects.toString(map.get("cransNo"), "");
				int cransCnt = cransNoStr.isEmpty() ? 0 : cransNoStr.split("@#").length;
				// 전체정답시
				if("CRANS_MLT".equals(map.get("cransTycd")) && vwitmCnt == cransCnt) {
					map.put("ansrYn", "Y");
				} else {
					// 답안 제출시
					if(ObjectUtils.isNotEmpty(map.get("answShtCts"))) {
						String answShtCts = String.valueOf(map.get("answShtCts"));					// 제출답안
						String qstnVwitmDsplySeq = String.valueOf(map.get("qstnVwitmDsplySeq"));	// 문항보기항목화면표시순번
						String cransNo = String.valueOf(map.get("cransNo"));						// 정답번호

						// 문항보기항목화면표시순번 목록화
						List<String> displayList = Arrays.asList(qstnVwitmDsplySeq.split("@#"));

						// 제출답안 정렬 목록화
						List<Integer> answList = Arrays.stream(answShtCts.split("@#"))
														        .map(val -> Integer.parseInt(displayList.get(Integer.parseInt(val) - 1)))
														        .filter(idx -> idx > 0)
														        .sorted()
														        .collect(Collectors.toList());

						// 정답번호 정렬 목록화
						List<Integer> cransList = Arrays.stream(cransNo.split("@#"))
															.map(Integer::parseInt)
															.sorted()
															.collect(Collectors.toList());

						if(answList.equals(cransList)) {
							map.put("ansrYn", "Y");
						}
					}
				}

			// 연결형
			} else if("LINK".equals(qstnRspnsTycd)) {
				String answShtCts = String.valueOf(map.get("answShtCts"));					// 제출답안
				String qstnVwitmDsplySeq = String.valueOf(map.get("qstnVwitmDsplySeq"));	// 문항보기항목화면표시순번
				String cransCts = String.valueOf(map.get("cransCts"));						// 정답내용

				// 문항보기항목화면표시순번 목록화
				List<Integer> displayList = Arrays.stream(qstnVwitmDsplySeq.split("@#"))
												        .map(Integer::parseInt)
												        .collect(Collectors.toList());

				// 제출답안 목록화
				List<String> answList = Arrays.asList(answShtCts.split("@#"));

				// 정답내용 정렬 목록화
				List<String> cransList = Arrays.stream(cransCts.split("@#"))
				        .map(item -> item.split("\\|")[1])
				        .collect(Collectors.collectingAndThen(
				            Collectors.toList(),
				            (List<String> crans) -> displayList.stream()
				                .map(i -> crans.get(i - 1))
				                .collect(Collectors.toList())
				        ));

				if(answList.equals(cransList)) {
					map.put("ansrYn", "Y");
				}

			// OX선택형
			} else if("OX_CHC".equals(qstnRspnsTycd)) {
				String answShtCts = String.valueOf(map.get("answShtCts"));					// 제출답안
				String qstnVwitmDsplySeq = String.valueOf(map.get("qstnVwitmDsplySeq"));	// 문항보기항목화면표시순번
				String cransNo = String.valueOf(map.get("cransNo"));						// 정답번호

				// 문항보기항목화면표시순번 목록화
				String[] displayList = qstnVwitmDsplySeq.split("@#");
				if(displayList[Integer.parseInt(answShtCts) - 1].equals(cransNo)) {
					map.put("ansrYn", "Y");
				}

			// 단답형
			} else if("SHORT_TEXT".equals(qstnRspnsTycd)) {
				String answShtCts = String.valueOf(map.get("answShtCts"));					// 제출답안
				String qstnVwitmDsplySeq = String.valueOf(map.get("qstnVwitmDsplySeq"));	// 문항보기항목화면표시순번
				String cransCts = String.valueOf(map.get("cransCts"));						// 정답내용

				// 문항보기항목화면표시순번 목록화
				List<Integer> displayList = Arrays.stream(qstnVwitmDsplySeq.split("@#"))
						.map(Integer::parseInt)
						.collect(Collectors.toList());

				// 제출답안 목록화
				List<String> answList = Arrays.asList(answShtCts.split("@#"));

				// 정답내용 정렬 목록화
				List<String> cransList = Arrays.stream(cransCts.split("@#"))
						.collect(Collectors.collectingAndThen(
								Collectors.toList(),
								(List<String> list2) -> displayList.stream()
								.map(i -> list2.get(i - 1))
								.collect(Collectors.toList())
								));

				// 순서에 상관없이 정답
				if("cransNotInorder".equals(map.get("cransTycd"))) {
					List<String> remainCrans = new ArrayList<>(cransList);

					boolean isMatch = answList.stream()
					        .allMatch(answ -> {
					            for (int i = 0; i < remainCrans.size(); i++) {
					                if (Arrays.asList(remainCrans.get(i).split("\\|")).contains(answ)) {
					                    remainCrans.remove(i);
					                    return true;
					                }
					            }
					            return false;
					        });

					if(isMatch) {
						map.put("ansrYn", "Y");
					}

				// 순서에 맞게 정답
				} else {
					boolean isMatch = IntStream.range(0, answList.size())
					        .allMatch(i -> Arrays.asList(cransList.get(i).split("\\|"))
					                             .contains(answList.get(i)));

					if(isMatch) {
						map.put("ansrYn", "Y");
					}
				}

			}
		}

		return list;
	}

	/**
	* 시험지일괄엑셀다운퀴즈문항목록
	*
	* @param examBscId 	시험기본아이디
    * @param sbjctId 	과목아이디
	* @return 시험지일괄엑셀다운퀴즈문항목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> exampprBulkExcelDownQuizQstnList(ExamBscVO vo) throws Exception {
		return exampprDAO.exampprBulkExcelDownQuizQstnList(vo);
	}

}
