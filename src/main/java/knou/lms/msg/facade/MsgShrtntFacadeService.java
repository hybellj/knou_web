package knou.lms.msg.facade;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.vo.AtflVO;
import knou.lms.msg.vo.MsgShrtntVO;
import knou.lms.org.vo.OrgInfoVO;

public interface MsgShrtntFacadeService {

    List<OrgInfoVO> selectActiveOrgList() throws Exception;

    List<AtflVO> selectAtflListByRefId(String refId) throws Exception;

    ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo);

    MsgShrtntVO selectShrtntRcvnDetailWithFiles(MsgShrtntVO vo) throws Exception;

    int updateShrtntReadDttm(MsgShrtntVO vo);

    int updateShrtntRcvrDelyn(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo);

    MsgShrtntVO selectShrtntSndngDetailWithFiles(MsgShrtntVO vo) throws Exception;

    ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo);

    int updateShrtntSndngrDelyn(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo);

    void registShrtntSndngWithFiles(MsgShrtntVO vo, List<AtflVO> fileList) throws Exception;

    void modifyShrtntSndngWithFiles(MsgShrtntVO vo, List<AtflVO> fileList, String[] delFileIds) throws Exception;

    int updateMsgRsrvCncl(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntRcvrSearchListPage(MsgShrtntVO vo);

    List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntYrList(MsgShrtntVO vo);

    List<EgovMap> selectShrtntSmstrList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntDeptList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSbjctList(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntRcvrByUserIds(MsgShrtntVO vo);
}
