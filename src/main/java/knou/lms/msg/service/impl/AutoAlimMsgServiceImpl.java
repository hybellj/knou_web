package knou.lms.msg.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.AutoAlimMsgDAO;
import knou.lms.msg.service.AutoAlimMsgService;
import knou.lms.msg.vo.AutoAlimMsgVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("autoAlimMsgService")
public class AutoAlimMsgServiceImpl extends ServiceBase implements AutoAlimMsgService {

    @Resource(name = "autoAlimMsgDAO")
    private AutoAlimMsgDAO autoAlimMsgDAO;

    /*****************************************************
     * 자동알림메시지 목록 조회
     * @param vo
     * @return ProcessResultVO<AutoAlimMsgVO>
     ******************************************************/
    @Override
    public ProcessResultVO<AutoAlimMsgVO> selectAutoAlimMsgListPage(AutoAlimMsgVO vo) throws Exception {
        ProcessResultVO<AutoAlimMsgVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<AutoAlimMsgVO> list = autoAlimMsgDAO.selectAutoAlimMsgList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 자동알림메시지 상세 조회
     * @param vo
     * @return AutoAlimMsgVO
     ******************************************************/
    @Override
    public AutoAlimMsgVO selectAutoAlimMsg(AutoAlimMsgVO vo) {
        return autoAlimMsgDAO.selectAutoAlimMsg(vo);
    }

    /*****************************************************
     * 자동알림메시지 등록
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int insertAutoAlimMsg(AutoAlimMsgVO vo) {
        String autoAlimMsgId = IdGenerator.getNewId(IdPrefixType.AAMSG.getCode());
        vo.setAutoAlimMsgId(autoAlimMsgId);
        return autoAlimMsgDAO.insertAutoAlimMsg(vo);
    }

    /*****************************************************
     * 자동알림메시지 수정
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateAutoAlimMsg(AutoAlimMsgVO vo) {
        return autoAlimMsgDAO.updateAutoAlimMsg(vo);
    }

    /*****************************************************
     * 자동알림메시지 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int deleteAutoAlimMsg(AutoAlimMsgVO vo) {
        return autoAlimMsgDAO.deleteAutoAlimMsg(vo);
    }

    /*****************************************************
     * 자동알림메시지 대상 목록 조회
     * @param vo
     * @return List<AutoAlimMsgVO>
     ******************************************************/
    @Override
    public List<AutoAlimMsgVO> selectAutoAlimMsgTrgtListByMsgId(AutoAlimMsgVO vo) {
        return autoAlimMsgDAO.selectAutoAlimMsgTrgtListByMsgId(vo);
    }

    /*****************************************************
     * 자동알림메시지 대상 등록
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int insertAutoAlimMsgTrgt(AutoAlimMsgVO vo) {
        String trgtId = IdGenerator.getNewId(IdPrefixType.AATGT.getCode());
        vo.setAutoAlimMsgTrgtId(trgtId);
        return autoAlimMsgDAO.insertAutoAlimMsgTrgt(vo);
    }

    /*****************************************************
     * 자동알림메시지 대상 일괄 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int deleteAutoAlimMsgTrgtByMsgId(AutoAlimMsgVO vo) {
        return autoAlimMsgDAO.deleteAutoAlimMsgTrgtByMsgId(vo);
    }
}
