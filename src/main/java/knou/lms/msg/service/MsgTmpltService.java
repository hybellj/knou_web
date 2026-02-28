package knou.lms.msg.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgTmpltVO;

public interface MsgTmpltService {

    int selectTmpltCnt(MsgTmpltVO vo);

    List<MsgTmpltVO> selectTmpltList(MsgTmpltVO vo);

    ProcessResultVO<MsgTmpltVO> selectTmpltListPage(MsgTmpltVO vo);

    MsgTmpltVO selectTmplt(MsgTmpltVO vo);

    int registTmplt(MsgTmpltVO vo);

    int modifyTmplt(MsgTmpltVO vo);

    int deleteTmplt(MsgTmpltVO vo);

    int deleteAllTmplt(MsgTmpltVO vo);

    List<MsgTmpltVO> selectTmpltExcelList(MsgTmpltVO vo);
}
