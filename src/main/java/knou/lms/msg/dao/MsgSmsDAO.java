package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgSmsVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("msgSmsDAO")
public interface MsgSmsDAO {

    List<MsgSmsVO> selectSmsRcvnList(MsgSmsVO vo);

    MsgSmsVO selectSmsRcvnDtl(MsgSmsVO vo);

    int updateSmsReadDttm(MsgSmsVO vo);

    int updateSmsRcvrDelyn(MsgSmsVO vo);

    List<MsgSmsVO> selectSmsSndngList(MsgSmsVO vo);

    MsgSmsVO selectSmsSndngDtl(MsgSmsVO vo);

    List<MsgSmsVO> selectSmsSndngRcvrList(MsgSmsVO vo);

    int updateSmsSndngrDelyn(MsgSmsVO vo);

    int insertMsg(MsgSmsVO vo);

    int insertRcvTrgtr(MsgSmsVO vo);

    int insertMblSndng(MsgSmsVO vo);

    int updateMsg(MsgSmsVO vo);

    int deleteRcvTrgtr(MsgSmsVO vo);

    int deleteMblSndng(MsgSmsVO vo);

    int updateSmsSndngRsrvCncl(MsgSmsVO vo);

    int updateMsgRsrvCncl(MsgSmsVO vo);

    List<MsgSmsVO> selectMsgRcvTrgtrList(MsgSmsVO vo);

    int updateMblSndngRslt(MsgSmsVO vo);

}
