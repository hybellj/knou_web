package knou.lms.msg.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.msg.vo.MsgAlimVO;

public interface MsgAlimService {

    EgovMap selectAlimUnrdCnt(MsgAlimVO vo);

    List<MsgAlimVO> selectShrtntList(MsgAlimVO vo);

    List<MsgAlimVO> selectPushList(MsgAlimVO vo);

    List<MsgAlimVO> selectSmsList(MsgAlimVO vo);

    List<MsgAlimVO> selectAlimtalkList(MsgAlimVO vo);
}
