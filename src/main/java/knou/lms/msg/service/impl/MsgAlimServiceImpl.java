package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.msg.dao.MsgAlimDAO;
import knou.lms.msg.service.MsgAlimService;
import knou.lms.msg.vo.MsgAlimVO;

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
    public List<MsgAlimVO> selectAlimPushList(MsgAlimVO vo) {
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
    public List<MsgAlimVO> selectAlimSmsList(MsgAlimVO vo) {
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
    public List<MsgAlimVO> selectAlimNotitalkList(MsgAlimVO vo) {
        if (vo.getListCnt() <= 0) {
            vo.setListCnt(5);
        }
        return msgAlimDAO.selectAlimtalkList(vo);
    }

    /**
     * 알림 읽음 상태 수정
     * @param vo
     * @return
     */
    @Override
    public int modifyAlimRead(MsgAlimVO vo) {
        int result = 0;
        String alimTycd = vo.getSndngTycd();

        if ("SHTNT".equals(alimTycd)) {
            result = msgAlimDAO.modifyShrtntReadDttm(vo);
        } else if ("PUSH".equals(alimTycd) || "SMS".equals(alimTycd) || "ALIMTALK".equals(alimTycd)) {
            result = msgAlimDAO.modifyMblReadDttm(vo);
        }

        return result;
    }

    /**
     * 메시지 등록
     * @param vo
     * @return
     */
    @Override
    public int registMsg(MsgAlimVO vo) {
        String msgId = IdGenerator.getNewId("MSG");
        vo.setMsgId(msgId);
        return msgAlimDAO.registMsg(vo);
    }
}