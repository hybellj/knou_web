package knou.lms.mrk.dao;

import knou.lms.mrk.vo.MarkObjectionApplyVO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("markObjectionApplyDAO")
public interface MarkObjectionApplyDAO {

    MarkObjectionApplyVO mrkObjctAplySelect(String mrkObjctAplyId);

    List<EgovMap> profMrkObjctAplyList(String sbjctId);

    List<EgovMap> stdMrkObjctAplyList(@Param("sbjctId")String sbjctId, @Param("userId")String userId);

    int countMrkObjctAply(MarkObjectionApplyVO vo);

    List<EgovMap> markObjctAplyListPaging(MarkObjectionApplyVO vo);

    void stdMrkObjctAplyRegist(MarkObjectionApplyVO vo);

    void stdMrkObjctAplyModify(MarkObjectionApplyVO vo);

    void stdMrkObjctAplyDelete(String mrkObjctAplyId);

}
