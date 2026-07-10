package knou.lms.msg.dao;

import knou.lms.msg.vo.AutoAlimMsgVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("autoAlimMsgDAO")
public interface AutoAlimMsgDAO {

    List<AutoAlimMsgVO> selectAutoAlimMsgList(AutoAlimMsgVO vo);

    AutoAlimMsgVO selectAutoAlimMsg(AutoAlimMsgVO vo);

    int insertAutoAlimMsg(AutoAlimMsgVO vo);

    int updateAutoAlimMsg(AutoAlimMsgVO vo);

    int deleteAutoAlimMsg(AutoAlimMsgVO vo);

    List<AutoAlimMsgVO> selectAutoAlimMsgTrgtListByMsgId(AutoAlimMsgVO vo);

    int insertAutoAlimMsgTrgt(AutoAlimMsgVO vo);

    int deleteAutoAlimMsgTrgtByMsgId(AutoAlimMsgVO vo);
}
