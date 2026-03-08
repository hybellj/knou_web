package knou.lms.msg.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.msg.vo.MsgSndrDsctnVO;

@Mapper("msgSndrDsctnDAO")
public interface MsgSndrDsctnDAO {

    int selectSndrDsctnCnt(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo);

    MsgSndrDsctnVO selectSndrDsctnSummary(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnYrList(MsgSndrDsctnVO vo);

    List<EgovMap> selectSndrDsctnSmstrList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnDeptList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnSbjctList(MsgSndrDsctnVO vo);
}
