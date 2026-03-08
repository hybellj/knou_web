package knou.lms.msg.service.impl;

import knou.framework.common.ServiceBase;
import knou.lms.msg.dao.MsgAlimDAO;
import knou.lms.msg.service.MsgAlimService;
import knou.lms.msg.vo.MsgAlimVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    /**
     * 채널별 알림 데이터 조회
     * @param vo
     * @param chnlCd
     * @return
     */
    @Override
    public Map<String, Object> selectAlimChnlData(MsgAlimVO vo, String chnlCd) {
        Map<String, Object> data = new HashMap<>();

        EgovMap unreadCnt = selectAlimUnrdCnt(vo);
        data.put("unreadCnt", unreadCnt);

        if ("ALL".equals(chnlCd)) {
            data.put("pushList", selectPushList(vo));
            data.put("smsList", selectSmsList(vo));
            data.put("msgList", selectShrtntList(vo));
            data.put("talkList", selectAlimtalkList(vo));
        } else if ("PUSH".equals(chnlCd)) {
            data.put("pushList", selectPushList(vo));
        } else if ("SMS".equals(chnlCd)) {
            data.put("smsList", selectSmsList(vo));
        } else if ("SHRTNT".equals(chnlCd)) {
            data.put("msgList", selectShrtntList(vo));
        } else if ("ALIM_TALK".equals(chnlCd)) {
            data.put("talkList", selectAlimtalkList(vo));
        }

        return data;
    }


}
