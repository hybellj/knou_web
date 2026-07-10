package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.AutoAlimMsgVO;

import java.util.List;

public interface AutoAlimMsgService {

    ProcessResultVO<AutoAlimMsgVO> selectAutoAlimMsgListPage(AutoAlimMsgVO vo) throws Exception;

    AutoAlimMsgVO selectAutoAlimMsg(AutoAlimMsgVO vo);

    int insertAutoAlimMsg(AutoAlimMsgVO vo);

    int updateAutoAlimMsg(AutoAlimMsgVO vo);

    int deleteAutoAlimMsg(AutoAlimMsgVO vo);

    List<AutoAlimMsgVO> selectAutoAlimMsgTrgtListByMsgId(AutoAlimMsgVO vo);

    int insertAutoAlimMsgTrgt(AutoAlimMsgVO vo);

    int deleteAutoAlimMsgTrgtByMsgId(AutoAlimMsgVO vo);
}
