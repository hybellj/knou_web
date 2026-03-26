package knou.lms.msg.facade;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgRcptnAgreVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MsgRcptnAgreFacadeService {

    ProcessResultVO<MsgRcptnAgreVO> selectRcptnAgreListPage(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreYrList(MsgRcptnAgreVO vo);

    List<EgovMap> selectRcptnAgreSmstrList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreDeptList(MsgRcptnAgreVO vo);

    List<MsgRcptnAgreVO> selectRcptnAgreSbjctList(MsgRcptnAgreVO vo);

    List<OrgInfoVO> selectActiveOrgList() throws Exception;
}
