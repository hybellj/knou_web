package knou.lms.msg.facade;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgRcptnAgreVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MsgRcptnAgreFacadeService {

    ProcessResultVO<MsgRcptnAgreVO> selectRcptnAgreListPage(MsgRcptnAgreVO vo) throws Exception;

    List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo);

    ProcessResultVO<MsgRcptnAgreVO> selectAdminRcptnAgreListPage(MsgRcptnAgreVO vo) throws Exception;

    List<MsgRcptnAgreVO> selectAdminRcptnAgreExcelList(MsgRcptnAgreVO vo);

    List<OrgInfoVO> selectActiveOrgList() throws Exception;

    List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception;

    List<OrgInfoVO> selectProfSbjctOrgList(String userId);

    MsgRcptnAgreVO loadListViewInfo(MsgRcptnAgreVO vo) throws Exception;

    EgovMap loadFilterOptions(MsgRcptnAgreVO vo) throws Exception;
}
