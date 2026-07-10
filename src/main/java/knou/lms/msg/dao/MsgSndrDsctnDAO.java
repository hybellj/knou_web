package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgSndrDsctnVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgSndrDsctnDAO")
public interface MsgSndrDsctnDAO {

    List<MsgSndrDsctnVO> selectSndrDsctnList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo);

    MsgSndrDsctnVO selectSndrDsctnSmry(MsgSndrDsctnVO vo);

}
