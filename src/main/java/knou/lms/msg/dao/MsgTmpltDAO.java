package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgTmpltVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("msgTmpltDAO")
public interface MsgTmpltDAO {

    List<MsgTmpltVO> selectTmpltList(MsgTmpltVO vo);

    MsgTmpltVO selectTmplt(MsgTmpltVO vo);

    int insertTmplt(MsgTmpltVO vo);

    int updateTmplt(MsgTmpltVO vo);

    int deleteTmplt(MsgTmpltVO vo);

    int deleteAllTmplt(MsgTmpltVO vo);

    List<MsgTmpltVO> selectTmpltExcelList(MsgTmpltVO vo);
}
