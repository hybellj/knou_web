package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgPushVO;

import java.util.List;

public interface MsgPushService {

    ProcessResultVO<MsgPushVO> selectPushRcvnListPage(MsgPushVO vo) throws Exception;

    MsgPushVO selectPushRcvnDtl(MsgPushVO vo);

    int updatePushReadDttm(MsgPushVO vo);

    int updatePushRcvrDelyn(MsgPushVO vo);

    ProcessResultVO<MsgPushVO> selectPushSndngListPage(MsgPushVO vo) throws Exception;

    MsgPushVO selectPushSndngDtl(MsgPushVO vo);

    ProcessResultVO<MsgPushVO> selectPushSndngRcvrListPage(MsgPushVO vo) throws Exception;

    int updatePushSndngrDelyn(MsgPushVO vo);

    int registPushSndng(MsgPushVO vo) throws Exception;

    int modifyPushSndng(MsgPushVO vo) throws Exception;

    int updateMsgRsrvCncl(MsgPushVO vo);


    List<MsgPushVO> selectMsgRcvTrgtrList(MsgPushVO vo);





}
