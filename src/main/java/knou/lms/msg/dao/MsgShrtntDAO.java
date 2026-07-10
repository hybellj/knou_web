package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgShrtntVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgShrtntDAO")
public interface MsgShrtntDAO {

    List<MsgShrtntVO> selectShrtntRcvnList(MsgShrtntVO vo);

    MsgShrtntVO selectShrtntRcvnDtl(MsgShrtntVO vo);

    int updateShrtntReadDttm(MsgShrtntVO vo);

    int updateShrtntRcvrDelyn(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngList(MsgShrtntVO vo);

    MsgShrtntVO selectShrtntSndngDtl(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngRcvrList(MsgShrtntVO vo);

    int updateShrtntSndngrDelyn(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo);

    int insertMsg(MsgShrtntVO vo);

    int insertRcvTrgtr(MsgShrtntVO vo);

    int insertShrtntSndng(MsgShrtntVO vo);

    int updateMsg(MsgShrtntVO vo);

    int deleteRcvTrgtr(MsgShrtntVO vo);

    int deleteShrtntSndng(MsgShrtntVO vo);

    int updateShrtntSndngRsrvCncl(MsgShrtntVO vo);

    int updateMsgRsrvCncl(MsgShrtntVO vo);

    List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo);







}
