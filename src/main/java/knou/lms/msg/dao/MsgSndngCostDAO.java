package knou.lms.msg.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.msg.vo.MsgSndngCostVO;

@Mapper("msgSndngCostDAO")
public interface MsgSndngCostDAO {

    List<MsgSndngCostVO> selectSndngCostList(MsgSndngCostVO vo);

    int insertSndngCost(MsgSndngCostVO vo);

    int updateSndngCost(MsgSndngCostVO vo);
}
