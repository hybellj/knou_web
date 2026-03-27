package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgShrtntVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MsgShrtntService {

    ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo);

    MsgShrtntVO selectShrtntRcvnDetail(MsgShrtntVO vo);

    int updateShrtntReadDttm(MsgShrtntVO vo);

    int updateShrtntRcvrDelyn(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo);

    MsgShrtntVO selectShrtntSndngDetail(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo);

    int updateShrtntSndngrDelyn(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo);

    int registShrtntSndng(MsgShrtntVO vo) throws Exception;

    int modifyShrtntSndng(MsgShrtntVO vo) throws Exception;

    int updateMsgRsrvCncl(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntRcvrSearchListPage(MsgShrtntVO vo);

    List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntYrList(MsgShrtntVO vo);

    List<EgovMap> selectShrtntSmstrList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntDeptList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSbjctList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntRcvrByUserIds(MsgShrtntVO vo);
}
