package knou.lms.crs.score.service;

import java.util.List;

import knou.lms.crs.score.vo.ScoreItemConfVO;

public interface ScoreItemConfService {
    
    /***************************************************** 
     * 성적항목설정 목록 조회
     * @param vo
     * @return List<ScoreItemConfVO>
     * @throws Exception
     ******************************************************/
    public List<ScoreItemConfVO> list(ScoreItemConfVO vo) throws Exception;
    
}
