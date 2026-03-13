package knou.lms.msg.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgRcptnAgreVO;

public interface MsgRcptnAgreService {

    ProcessResultVO<MsgRcptnAgreVO> selectRcptnAgreListPage(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreYrList(MsgRcptnAgreVO vo);

    List<EgovMap> selectRcptnAgreSmstrList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreDeptList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreSbjctList(MsgRcptnAgreVO vo);
}
