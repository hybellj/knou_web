package knou.lms.msg.service;

import java.util.List;

import knou.lms.msg.vo.MsgSndngCostVO;

public interface MsgSndngCostService {

    List<MsgSndngCostVO> selectSndngCostList() throws Exception;

    int insertSndngCost(MsgSndngCostVO vo) throws Exception;

    int updateSndngCost(MsgSndngCostVO vo) throws Exception;
}
