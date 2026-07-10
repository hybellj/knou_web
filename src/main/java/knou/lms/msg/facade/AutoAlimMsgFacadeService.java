package knou.lms.msg.facade;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.AutoAlimMsgVO;
import knou.lms.org.vo.OrgInfoVO;

import java.util.List;

public interface AutoAlimMsgFacadeService {

    List<OrgInfoVO> selectActiveOrgList() throws Exception;

    ProcessResultVO<AutoAlimMsgVO> selectAutoAlimMsgListPage(AutoAlimMsgVO vo) throws Exception;

    AutoAlimMsgVO selectAutoAlimMsgWithTrgt(AutoAlimMsgVO vo);

    void registAutoAlimMsg(AutoAlimMsgVO vo);

    void modifyAutoAlimMsg(AutoAlimMsgVO vo);

    void deleteAutoAlimMsg(AutoAlimMsgVO vo);
}
