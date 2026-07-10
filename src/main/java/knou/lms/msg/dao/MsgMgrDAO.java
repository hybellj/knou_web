package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgMgrDAO")
public interface MsgMgrDAO {

    List<OrgInfoVO> selectProfSbjctOrgList(String userId);

    List<EgovMap> selectSmstrList(MsgMgrVO vo);

    List<MsgMgrVO> selectSbjctList(MsgMgrVO vo);

    List<MsgMgrVO> selectStdntYrList(MsgMgrVO vo);

    List<EgovMap> selectStdntSmstrList(MsgMgrVO vo);

    List<MsgMgrVO> selectStdntSbjctList(MsgMgrVO vo);

    List<MsgMgrVO> selectRcvrSearchList(MsgMgrVO vo);

    List<MsgMgrVO> selectRcvrSearchAllList(MsgMgrVO vo);

    List<MsgMgrVO> selectRcvrByUserIds(MsgMgrVO vo);

    List<EgovMap> selectUserTycdList();

}
