package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgTmpltVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("msgTmpltDAO")
public interface MsgTmpltDAO {

    int selectTmpltCnt(MsgTmpltVO vo);

    List<MsgTmpltVO> selectTmpltList(MsgTmpltVO vo);

    MsgTmpltVO selectTmplt(MsgTmpltVO vo);

    int registTmplt(MsgTmpltVO vo);

    int modifyTmplt(MsgTmpltVO vo);

    int deleteTmplt(MsgTmpltVO vo);

    int deleteAllTmplt(MsgTmpltVO vo);

    List<MsgTmpltVO> selectTmpltExcelList(MsgTmpltVO vo);
}
