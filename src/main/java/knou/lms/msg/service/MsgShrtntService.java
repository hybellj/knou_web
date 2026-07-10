package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgShrtntVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MsgShrtntService {

    ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo) throws Exception;

    MsgShrtntVO selectShrtntRcvnDtl(MsgShrtntVO vo);

    int updateShrtntReadDttm(MsgShrtntVO vo);

    int updateShrtntRcvrDelyn(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo) throws Exception;

    MsgShrtntVO selectShrtntSndngDtl(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo) throws Exception;

    int updateShrtntSndngrDelyn(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo);

    int registShrtntSndng(MsgShrtntVO vo) throws Exception;

    int modifyShrtntSndng(MsgShrtntVO vo) throws Exception;

    int updateMsgRsrvCncl(MsgShrtntVO vo);


    List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo);





}
