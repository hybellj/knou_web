package knou.lms.msg.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.msg.vo.MsgAlimVO;

@Mapper("msgAlimDAO")
public interface MsgAlimDAO {

    EgovMap selectAlimUnrdCnt(MsgAlimVO vo);

    List<MsgAlimVO> selectShrtntList(MsgAlimVO vo);

    List<MsgAlimVO> selectPushList(MsgAlimVO vo);

    List<MsgAlimVO> selectSmsList(MsgAlimVO vo);

    List<MsgAlimVO> selectAlimtalkList(MsgAlimVO vo);

}