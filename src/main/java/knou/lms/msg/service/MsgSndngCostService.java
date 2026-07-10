package knou.lms.msg.service;

import java.util.List;

import knou.lms.msg.vo.MsgSndngCostVO;

public interface MsgSndngCostService {

    List<MsgSndngCostVO> selectSndngCostList();

    int insertSndngCost(MsgSndngCostVO vo);

    int updateSndngCost(MsgSndngCostVO vo);
}
