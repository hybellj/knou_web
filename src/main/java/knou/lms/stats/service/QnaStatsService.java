package knou.lms.stats.service;

import java.util.List;

import knou.lms.common.dto.ResultDTO;
import knou.lms.stats.vo.QnaStatsVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface QnaStatsService {

    /**
     * 질의응답 총괄현황 목록을 조회한다.
     *
     * @param vo 검색조건
     * @return 조회 결과 목록
     * @throws Exception 조회 중 오류 발생 시
     */
    ResultDTO<EgovMap> admQnaStatsList(QnaStatsVO vo) throws Exception;

    /**
     * 질의응답 총괄현황 엑셀 다운로드 목록을 조회한다.
     *
     * @param vo 검색조건
     * @return 엑셀 다운로드 목록
     * @throws Exception 조회 중 오류 발생 시
     */
    List<EgovMap> qnaStatsExcelList(QnaStatsVO vo) throws Exception;
}
