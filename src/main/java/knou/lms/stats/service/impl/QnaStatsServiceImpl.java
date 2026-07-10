package knou.lms.stats.service.impl;

import java.util.List;

import javax.annotation.Resource;

import knou.lms.common.dto.ResultDTO;
import knou.lms.stats.dao.QnaStatsDAO;
import knou.lms.stats.service.QnaStatsService;
import knou.lms.stats.vo.QnaStatsVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

@Service("qnaStatsService")
public class QnaStatsServiceImpl implements QnaStatsService {

    @Resource(name="qnaStatsDAO")
    private QnaStatsDAO qnaStatsDAO;

    /**
     * 질의응답 총괄현황 목록을 조회한다.
     */
    @Override
    public ResultDTO<EgovMap> admQnaStatsList(QnaStatsVO vo) throws Exception {
        return new ResultDTO<EgovMap>().setReturnList(qnaStatsDAO.admQnaStatsList(vo));
    }

    /**
     * 질의응답 총괄현황 엑셀 다운로드 목록을 조회한다.
     */
    @Override
    public List<EgovMap> qnaStatsExcelList(QnaStatsVO vo) throws Exception {
        List<EgovMap> list = qnaStatsDAO.admQnaStatsList(vo);
        for(int i = 0; i < list.size(); i++) {
            list.get(i).put("no", list.size() - i);
        }
        return list;
    }
}
