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

    /**
     * 알림 유형별 읽지 않은 건수 조회
     * @param vo
     * @return
     */
    @Override
    public EgovMap selectAlimUnrdCnt(MsgAlimVO vo) {
        return msgAlimDAO.selectAlimUnrdCnt(vo);
    }

    /**
     * 쪽지 최근 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgAlimVO> selectShrtntList(MsgAlimVO vo) {
        if (vo.getListCnt() <= 0) {
            vo.setListCnt(5);
        }
        return msgAlimDAO.selectShrtntList(vo);
    }

    /**
     * PUSH 최근 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgAlimVO> selectPushList(MsgAlimVO vo) {
        if (vo.getListCnt() <= 0) {
            vo.setListCnt(5);
        }
        return msgAlimDAO.selectPushList(vo);
    }

    /**
     * SMS 최근 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgAlimVO> selectSmsList(MsgAlimVO vo) {
        if (vo.getListCnt() <= 0) {
            vo.setListCnt(5);
        }
        return msgAlimDAO.selectSmsList(vo);
    }

    /**
     * 알림톡 최근 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgAlimVO> selectAlimtalkList(MsgAlimVO vo) {
        if (vo.getListCnt() <= 0) {
            vo.setListCnt(5);
        }
        return msgAlimDAO.selectAlimtalkList(vo);
    }

}
