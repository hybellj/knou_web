package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgRcptnAgreVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgRcptnAgreDAO")
public interface MsgRcptnAgreDAO {

    int selectRcptnAgreCnt(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreYrList(MsgRcptnAgreVO vo);

    List<EgovMap> selectRcptnAgreSmstrList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreDeptList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreSbjctList(MsgRcptnAgreVO vo);
}
