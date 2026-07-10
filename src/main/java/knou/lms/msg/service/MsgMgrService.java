package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.io.InputStream;
import java.util.List;

public interface MsgMgrService {

    List<MsgMgrVO> selectYrList(MsgMgrVO vo);

    List<EgovMap> selectSmstrList(MsgMgrVO vo);

    List<MsgMgrVO> selectSbjctList(MsgMgrVO vo);

    List<MsgMgrVO> selectStdntYrList(MsgMgrVO vo);

    List<EgovMap> selectStdntSmstrList(MsgMgrVO vo);

    List<MsgMgrVO> selectStdntSbjctList(MsgMgrVO vo);

    List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception;

    List<OrgInfoVO> selectProfSbjctOrgList(String userId);

    ProcessResultVO<MsgMgrVO> selectRcvrSearchListPage(MsgMgrVO vo) throws Exception;

    List<MsgMgrVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception;

    List<MsgMgrVO> selectRcvrByUserIds(MsgMgrVO vo);

    List<EgovMap> selectUserTycdList();

}
