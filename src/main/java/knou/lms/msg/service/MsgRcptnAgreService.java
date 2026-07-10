package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgRcptnAgreVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MsgRcptnAgreService {

    ProcessResultVO<MsgRcptnAgreVO> selectRcptnAgreListPage(MsgRcptnAgreVO vo) throws Exception;

    List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo);

    ProcessResultVO<MsgRcptnAgreVO> selectAdminRcptnAgreListPage(MsgRcptnAgreVO vo) throws Exception;

    List<MsgRcptnAgreVO> selectAdminRcptnAgreExcelList(MsgRcptnAgreVO vo);

}
