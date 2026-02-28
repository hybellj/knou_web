package knou.lms.exam.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.apache.commons.lang3.ObjectUtils;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.exam.dao.ExampprDAO;
import knou.lms.exam.service.ExampprService;

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
	public List<EgovMap> tkexamExampprAnswShtList(String tkexamId, String userId) throws Exception {
		// 시험응시시험지답안목록조회
		List<EgovMap> list = exampprDAO.tkexamExampprAnswShtList(tkexamId, userId);

		// 정답 여부 확인
		for(EgovMap map : list) {
			String qstnRspnsTycd = String.valueOf(map.get("qstnRspnsTycd"));	// 문항답변유형코드

			// 단일, 다중선택형
			if("ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd)) {
				// 문항보기항목 개수
				String vwitmSeqnoStr = Objects.toString(map.get("qstnVwitmDsplySeqno"), "");
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
						System.out.println("@@@@@@@@@@");
						String answShtCts = String.valueOf(map.get("answShtCts"));						// 제출답안
						String qstnVwitmDsplySeqno = String.valueOf(map.get("qstnVwitmDsplySeqno"));	// 문항보기항목화면표시순번
						String cransNo = String.valueOf(map.get("cransNo"));							// 정답번호
						System.out.println(qstnRspnsTycd);
						System.out.println(answShtCts);
						System.out.println(qstnVwitmDsplySeqno);
						System.out.println(cransNo);

						List<String> displayList = Arrays.asList(qstnVwitmDsplySeqno.split("@#"));

						List<Integer> convertAnswList = Arrays.stream(answShtCts.split("@#"))
																.map(val -> displayList.indexOf(val) + 1)
																.filter(idx -> idx > 0)
																.sorted()
																.collect(Collectors.toList());

						List<Integer> cransList = Arrays.stream(cransNo.split("@#"))
															.map(Integer::parseInt)
															.sorted()
															.collect(Collectors.toList());

						System.out.println("#############");
						System.out.println(displayList);
						System.out.println(convertAnswList);
						System.out.println(cransList);

						System.out.println(convertAnswList.equals(cransList));
					}
				}
			// 서술형
			} else if("LONG_TEXT".equals(qstnRspnsTycd)) {

			// 연결형
			} else if("LINK".equals(qstnRspnsTycd)) {

			// OX선택형
			} else if("OX_CHC".equals(qstnRspnsTycd)) {

			// 단답형
			} else if("SHORT_TEXT".equals(qstnRspnsTycd)) {

			}
		}

		return list;
	}

}
