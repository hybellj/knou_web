package knou.lms.mrk.dao;

import knou.lms.mrk.vo.MarkObjectionApplyVO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("markObjectionApplyDAO")
public interface MarkObjectionApplyDAO {

    MarkObjectionApplyVO mrkObjctAplySelect(@Param("mrkObjctAplyId")String mrkObjctAplyId);

    List<EgovMap> mrkObjctAplyList(String sbjctId);
}
