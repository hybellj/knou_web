package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgEmlVO;

import java.util.List;

public interface MsgEmlService {

    ProcessResultVO<MsgEmlVO> selectEmlRcvnListPage(MsgEmlVO vo) throws Exception;

    MsgEmlVO selectEmlRcvnDtl(MsgEmlVO vo);

    int updateEmlReadDttm(MsgEmlVO vo);

    int updateEmlRcvrDelyn(MsgEmlVO vo);

    ProcessResultVO<MsgEmlVO> selectEmlSndngListPage(MsgEmlVO vo) throws Exception;

    MsgEmlVO selectEmlSndngDtl(MsgEmlVO vo);

    ProcessResultVO<MsgEmlVO> selectEmlSndngRcvrListPage(MsgEmlVO vo) throws Exception;

    int updateEmlSndngrDelyn(MsgEmlVO vo);

    int registEmlSndng(MsgEmlVO vo) throws Exception;

    int modifyEmlSndng(MsgEmlVO vo) throws Exception;

    int updateMsgRsrvCncl(MsgEmlVO vo);

    List<MsgEmlVO> selectMsgRcvTrgtrList(MsgEmlVO vo);
}
