package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgPushVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgPushDAO")
public interface MsgPushDAO {

    List<MsgPushVO> selectPushRcvnList(MsgPushVO vo);

    MsgPushVO selectPushRcvnDtl(MsgPushVO vo);

    int updatePushReadDttm(MsgPushVO vo);

    int updatePushRcvrDelyn(MsgPushVO vo);

    List<MsgPushVO> selectPushSndngList(MsgPushVO vo);

    MsgPushVO selectPushSndngDtl(MsgPushVO vo);

    List<MsgPushVO> selectPushSndngRcvrList(MsgPushVO vo);

    int updatePushSndngrDelyn(MsgPushVO vo);

    int insertMsg(MsgPushVO vo);

    int insertRcvTrgtr(MsgPushVO vo);

    int insertMblSndng(MsgPushVO vo);

    int updateMsg(MsgPushVO vo);

    int deleteRcvTrgtr(MsgPushVO vo);

    int deleteMblSndng(MsgPushVO vo);

    int updatePushSndngRsrvCncl(MsgPushVO vo);

    int updateMsgRsrvCncl(MsgPushVO vo);

    List<MsgPushVO> selectMsgRcvTrgtrList(MsgPushVO vo);







}
