package knou.lms.crs.score.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.crs.score.vo.ScoreItemConfVO;

@Mapper("scoreItemConfDAO")
public interface ScoreItemConfDAO {

    /***************************************************** 
     * 성적항목설정 목록 조회
     * @param vo
     * @return List<ScoreItemConfVO>
     * @throws Exception
     ******************************************************/
    public List<ScoreItemConfVO> list(ScoreItemConfVO vo) throws Exception;
    
}
