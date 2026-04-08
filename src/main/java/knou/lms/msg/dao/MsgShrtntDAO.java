package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgShrtntVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgShrtntDAO")
public interface MsgShrtntDAO {

    int selectShrtntRcvnCnt(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntRcvnList(MsgShrtntVO vo);

    MsgShrtntVO selectShrtntRcvnDetail(MsgShrtntVO vo);

    int updateShrtntReadDttm(MsgShrtntVO vo);

    int updateShrtntRcvrDelyn(MsgShrtntVO vo);

    int selectShrtntSndngCnt(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngList(MsgShrtntVO vo);

    MsgShrtntVO selectShrtntSndngDetail(MsgShrtntVO vo);

    int selectShrtntSndngRcvrCnt(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngRcvrList(MsgShrtntVO vo);

    int updateShrtntSndngrDelyn(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo);

    int insertMsg(MsgShrtntVO vo);

    int insertRcvTrgtr(MsgShrtntVO vo);

    int insertShrtntSndng(MsgShrtntVO vo);

    int updateMsg(MsgShrtntVO vo);

    int deleteRcvTrgtr(MsgShrtntVO vo);

    int deleteShrtntSndng(MsgShrtntVO vo);

    int updateMsgRsrvCncl(MsgShrtntVO vo);

    List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo);

    int selectShrtntRcvrSearchAllCnt(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntRcvrSearchAllList(MsgShrtntVO vo);

    int selectShrtntRcvrSearchCnt(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntRcvrSearchList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntYrList(MsgShrtntVO vo);

    List<EgovMap> selectShrtntSmstrList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntDeptList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSbjctList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntRcvrByUserIds(MsgShrtntVO vo);
}
