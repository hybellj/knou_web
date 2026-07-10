package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgAlimTalkVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MsgAlimTalkService {

    ProcessResultVO<MsgAlimTalkVO> selectAlimTalkRcvnListPage(MsgAlimTalkVO vo) throws Exception;

    MsgAlimTalkVO selectAlimTalkRcvnDtl(MsgAlimTalkVO vo);

    int updateAlimTalkReadDttm(MsgAlimTalkVO vo);

    int updateAlimTalkRcvrDelyn(MsgAlimTalkVO vo);

    ProcessResultVO<MsgAlimTalkVO> selectAlimTalkSndngListPage(MsgAlimTalkVO vo) throws Exception;

    MsgAlimTalkVO selectAlimTalkSndngDtl(MsgAlimTalkVO vo);

    ProcessResultVO<MsgAlimTalkVO> selectAlimTalkSndngRcvrListPage(MsgAlimTalkVO vo) throws Exception;

    int updateAlimTalkSndngrDelyn(MsgAlimTalkVO vo);

    int registAlimTalkSndng(MsgAlimTalkVO vo) throws Exception;

    int modifyAlimTalkSndng(MsgAlimTalkVO vo) throws Exception;

    int updateMsgRsrvCncl(MsgAlimTalkVO vo);


    List<MsgAlimTalkVO> selectMsgRcvTrgtrList(MsgAlimTalkVO vo);





}
