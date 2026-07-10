package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgSmsVO;

import java.util.List;

public interface MsgSmsService {

    ProcessResultVO<MsgSmsVO> selectSmsRcvnListPage(MsgSmsVO vo) throws Exception;

    MsgSmsVO selectSmsRcvnDtl(MsgSmsVO vo);

    int updateSmsReadDttm(MsgSmsVO vo);

    int updateSmsRcvrDelyn(MsgSmsVO vo);

    ProcessResultVO<MsgSmsVO> selectSmsSndngListPage(MsgSmsVO vo) throws Exception;

    MsgSmsVO selectSmsSndngDtl(MsgSmsVO vo);

    ProcessResultVO<MsgSmsVO> selectSmsSndngRcvrListPage(MsgSmsVO vo) throws Exception;

    int updateSmsSndngrDelyn(MsgSmsVO vo);

    int registSmsSndng(MsgSmsVO vo);

    int modifySmsSndng(MsgSmsVO vo);

    int updateMsgRsrvCncl(MsgSmsVO vo);

    List<MsgSmsVO> selectMsgRcvTrgtrList(MsgSmsVO vo);

    int updateMblSndngRslt(MsgSmsVO vo);

}
