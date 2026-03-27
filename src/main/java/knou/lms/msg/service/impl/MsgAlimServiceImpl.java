package knou.lms.msg.service.impl;

import knou.framework.common.ServiceBase;
import knou.lms.msg.dao.MsgAlimDAO;
import knou.lms.msg.service.MsgAlimService;
import knou.lms.msg.vo.MsgAlimVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("msgAlimService")
public class MsgAlimServiceImpl extends ServiceBase implements MsgAlimService {

    @Resource(name = "msgAlimDAO")
    private MsgAlimDAO msgAlimDAO;

    private static final int DEFAULT_LIST_CNT = 5;

    private void ensureListCnt(MsgAlimVO vo) {
        if (vo.getListCnt() <= 0) {
            vo.setListCnt(DEFAULT_LIST_CNT);
        }
    }

    /*****************************************************
     * 알림 유형별 읽지 않은 건수 조회
     * @param vo
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap selectAlimUnrdCnt(MsgAlimVO vo) {
        return msgAlimDAO.selectAlimUnrdCnt(vo);
    }

    /*****************************************************
     * 쪽지 최근 목록 조회
     * @param vo
     * @return List<MsgAlimVO>
     ******************************************************/
    @Override
    public List<MsgAlimVO> selectShrtntList(MsgAlimVO vo) {
        ensureListCnt(vo);
        return msgAlimDAO.selectShrtntList(vo);
    }

    /*****************************************************
     * 모바일 채널(PUSH/SMS/ALIM_TALK) 최근 목록 조회
     * @param vo
     * @return List<MsgAlimVO>
     ******************************************************/
    @Override
    public List<MsgAlimVO> selectMblSndngList(MsgAlimVO vo) {
        ensureListCnt(vo);
        return msgAlimDAO.selectMblSndngList(vo);
    }

}
