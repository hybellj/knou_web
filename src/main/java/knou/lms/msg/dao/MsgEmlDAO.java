package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgEmlVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("msgEmlDAO")
public interface MsgEmlDAO {

    List<MsgEmlVO> selectEmlRcvnList(MsgEmlVO vo);

    MsgEmlVO selectEmlRcvnDtl(MsgEmlVO vo);

    int updateEmlReadDttm(MsgEmlVO vo);

    int updateEmlRcvrDelyn(MsgEmlVO vo);

    List<MsgEmlVO> selectEmlSndngList(MsgEmlVO vo);

    MsgEmlVO selectEmlSndngDtl(MsgEmlVO vo);

    List<MsgEmlVO> selectEmlSndngRcvrList(MsgEmlVO vo);

    int updateEmlSndngrDelyn(MsgEmlVO vo);

    int insertMsg(MsgEmlVO vo);

    int insertRcvTrgtr(MsgEmlVO vo);

    int insertEmlSndng(MsgEmlVO vo);

    int updateMsg(MsgEmlVO vo);

    int deleteRcvTrgtr(MsgEmlVO vo);

    int deleteEmlSndng(MsgEmlVO vo);

    int updateEmlSndngRsrvCncl(MsgEmlVO vo);

    int updateMsgRsrvCncl(MsgEmlVO vo);

    List<MsgEmlVO> selectMsgRcvTrgtrList(MsgEmlVO vo);
}
