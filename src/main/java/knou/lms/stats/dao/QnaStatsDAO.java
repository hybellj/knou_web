package knou.lms.stats.dao;

import java.util.List;

import knou.lms.stats.vo.QnaStatsVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("qnaStatsDAO")
public interface QnaStatsDAO {

    /**
     * 질의응답 총괄현황 목록을 조회한다.
     *
     * @param vo 검색조건
     * @return 질의응답 총괄현황 목록
     */
    List<EgovMap> admQnaStatsList(QnaStatsVO vo);
}
