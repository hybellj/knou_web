package knou.lms.crs.sbjct.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.sbjct.vo.*;

import java.util.List;

public interface SbjctService {

    ProcessResultVO<SbjctListVO> selectSbjctList(SbjctListVO sbjctListVO) throws Exception;

    int updateSbjctUseYn(SbjctListVO updateVo) throws Exception;

    int deleteSbjct(SbjctListVO deleteVo) throws Exception;

    List<DgrsYrChrtVO> selectDgrsYrChrtList(String orgId) throws Exception;

    public List<SbjctVO> list(SbjctVO vo) throws Exception;
}
