package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgRcptnAgreVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgRcptnAgreDAO")
public interface MsgRcptnAgreDAO {

    List<MsgRcptnAgreVO> selectRcptnAgreList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectAdminRcptnAgreList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectAdminRcptnAgreExcelList(MsgRcptnAgreVO vo);

}
