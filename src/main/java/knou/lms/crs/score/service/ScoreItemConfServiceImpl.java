package knou.lms.crs.score.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.crs.score.dao.ScoreItemConfDAO;
import knou.lms.crs.score.vo.ScoreItemConfVO;

@Service("scoreItemConfService")
public class ScoreItemConfServiceImpl extends ServiceBase implements ScoreItemConfService {

    @Resource(name="scoreItemConfDAO")
    private ScoreItemConfDAO scoreItemConfDAO;
    
    /***************************************************** 
     * 성적항목설정 목록 조회
     * @param vo
     * @return List<ScoreItemConfVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ScoreItemConfVO> list(ScoreItemConfVO vo) throws Exception {
        return scoreItemConfDAO.list(vo);
    }
    
}
