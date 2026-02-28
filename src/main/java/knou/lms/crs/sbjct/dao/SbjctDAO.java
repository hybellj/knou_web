package knou.lms.crs.sbjct.dao;

import java.util.List;

import knou.lms.crs.sbjct.vo.*;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("sbjctDAO")
public interface SbjctDAO {

    List<SbjctListVO> selectSbjctList(SbjctListVO sbjctListVO) throws Exception;

    int updateSbjctUseYn(SbjctListVO sbjctListVO) throws Exception;

    int deleteSbjct(SbjctListVO sbjctListVO) throws Exception;

    List<DgrsYrChrtVO> selectDgrsYrChrtList(@Param("orgId") String orgId) throws Exception;
}
