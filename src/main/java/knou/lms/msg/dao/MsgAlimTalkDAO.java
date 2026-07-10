package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgAlimTalkVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgAlimTalkDAO")
public interface MsgAlimTalkDAO {

    List<MsgAlimTalkVO> selectAlimTalkRcvnList(MsgAlimTalkVO vo);

    MsgAlimTalkVO selectAlimTalkRcvnDtl(MsgAlimTalkVO vo);

    int updateAlimTalkReadDttm(MsgAlimTalkVO vo);

    int updateAlimTalkRcvrDelyn(MsgAlimTalkVO vo);

    List<MsgAlimTalkVO> selectAlimTalkSndngList(MsgAlimTalkVO vo);

    MsgAlimTalkVO selectAlimTalkSndngDtl(MsgAlimTalkVO vo);

    List<MsgAlimTalkVO> selectAlimTalkSndngRcvrList(MsgAlimTalkVO vo);

    int updateAlimTalkSndngrDelyn(MsgAlimTalkVO vo);

    int insertMsg(MsgAlimTalkVO vo);

    int insertRcvTrgtr(MsgAlimTalkVO vo);

    int insertMblSndng(MsgAlimTalkVO vo);

    int updateMsg(MsgAlimTalkVO vo);

    int deleteRcvTrgtr(MsgAlimTalkVO vo);

    int deleteMblSndng(MsgAlimTalkVO vo);

    int updateAlimTalkSndngRsrvCncl(MsgAlimTalkVO vo);

    int updateMsgRsrvCncl(MsgAlimTalkVO vo);

    List<MsgAlimTalkVO> selectMsgRcvTrgtrList(MsgAlimTalkVO vo);







}
