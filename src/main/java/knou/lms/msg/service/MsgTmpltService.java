package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgTmpltVO;

import java.util.List;

public interface MsgTmpltService {

    ProcessResultVO<MsgTmpltVO> selectTmpltListPage(MsgTmpltVO vo);

    MsgTmpltVO selectTmplt(MsgTmpltVO vo);

    int registTmplt(MsgTmpltVO vo);

    int modifyTmplt(MsgTmpltVO vo);

    int deleteTmplt(MsgTmpltVO vo, String userId, boolean isAdmin) throws Exception;

    int deleteAllTmplt(MsgTmpltVO vo);

    List<MsgTmpltVO> selectTmpltExcelList(MsgTmpltVO vo);
}
