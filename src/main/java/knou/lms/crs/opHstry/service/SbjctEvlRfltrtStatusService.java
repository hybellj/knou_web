package knou.lms.crs.opHstry.service;

import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.opHstry.vo.SbjctEvlRfltrtStatusVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface SbjctEvlRfltrtStatusService {

    /**
     * 과목별 평가비중 시행현황 목록을 조회한다.
     *
     * @param vo 검색조건
     * @return 조회 결과 목록
     * @throws Exception 조회 중 오류 발생 시
     */
    ResultDTO<EgovMap> sbjctEvlRfltrtStatusList(SbjctEvlRfltrtStatusVO vo) throws Exception;

    /**
     * 과목별 평가비중 시행현황 엑셀 다운로드 목록을 조회한다.
     *
     * @param vo 검색조건
     * @return 엑셀 다운로드 목록
     * @throws Exception 조회 중 오류 발생 시
     */
    List<EgovMap> sbjctEvlRfltrtStatusExcelList(SbjctEvlRfltrtStatusVO vo) throws Exception;
}
