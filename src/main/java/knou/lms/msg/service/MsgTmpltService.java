package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgTmpltVO;

import java.util.List;

public interface MsgTmpltService {

    ProcessResultVO<MsgTmpltVO> selectTmpltListPage(MsgTmpltVO vo) throws Exception;

    MsgTmpltVO selectTmplt(MsgTmpltVO vo);

    int insertTmplt(MsgTmpltVO vo);

    int updateTmplt(MsgTmpltVO vo);

    int deleteTmplt(MsgTmpltVO vo, String userId, boolean isAdmin);

    int deleteAllTmplt(MsgTmpltVO vo);

    List<MsgTmpltVO> selectTmpltExcelList(MsgTmpltVO vo);
}
