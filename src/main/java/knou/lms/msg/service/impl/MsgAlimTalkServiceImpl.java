package knou.lms.msg.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgAlimTalkDAO;
import knou.lms.msg.service.MsgAlimTalkService;
import knou.lms.msg.service.MsgRcptnAuthService;
import knou.lms.msg.vo.MsgAlimTalkVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Service("msgAlimTalkService")
public class MsgAlimTalkServiceImpl extends ServiceBase implements MsgAlimTalkService {

    @Resource(name = "msgAlimTalkDAO")
    private MsgAlimTalkDAO msgAlimTalkDAO;

    @Resource(name = "msgRcptnAuthService")
    private MsgRcptnAuthService msgRcptnAuthService;

    private static final String STSCD_RSRV = "RSRV";
    private static final String STSCD_SCS  = "SCS";
    private static final String STSCD_RJCT = "RJCT";
    private static final String RJCT_RSLT_CTS = "수신거부";

    /*****************************************************
     * 알림톡 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgAlimTalkVO> selectAlimTalkRcvnListPage(MsgAlimTalkVO vo) throws Exception {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgAlimTalkVO> list = msgAlimTalkDAO.selectAlimTalkRcvnList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 알림톡 수신 상세 조회
     * @param vo
     * @return MsgAlimTalkVO
     ******************************************************/
    @Override
    public MsgAlimTalkVO selectAlimTalkRcvnDtl(MsgAlimTalkVO vo) {
        return msgAlimTalkDAO.selectAlimTalkRcvnDtl(vo);
    }

    /*****************************************************
     * 알림톡 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateAlimTalkReadDttm(MsgAlimTalkVO vo) {
        return msgAlimTalkDAO.updateAlimTalkReadDttm(vo);
    }

    /*****************************************************
     * 알림톡 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateAlimTalkRcvrDelyn(MsgAlimTalkVO vo) {
        return msgAlimTalkDAO.updateAlimTalkRcvrDelyn(vo);
    }

    /*****************************************************
     * 알림톡 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgAlimTalkVO> selectAlimTalkSndngListPage(MsgAlimTalkVO vo) throws Exception {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgAlimTalkVO> list = msgAlimTalkDAO.selectAlimTalkSndngList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 알림톡 발신 상세 조회
     * @param vo
     * @return MsgAlimTalkVO
     ******************************************************/
    @Override
    public MsgAlimTalkVO selectAlimTalkSndngDtl(MsgAlimTalkVO vo) {
        return msgAlimTalkDAO.selectAlimTalkSndngDtl(vo);
    }

    /*****************************************************
     * 알림톡 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgAlimTalkVO> selectAlimTalkSndngRcvrListPage(MsgAlimTalkVO vo) throws Exception {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgAlimTalkVO> list = msgAlimTalkDAO.selectAlimTalkSndngRcvrList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 알림톡 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateAlimTalkSndngrDelyn(MsgAlimTalkVO vo) {
        return msgAlimTalkDAO.updateAlimTalkSndngrDelyn(vo);
    }

    /*****************************************************
     * 알림톡 발신 등록
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int registAlimTalkSndng(MsgAlimTalkVO vo) throws Exception {
        String msgId = IdGenerator.getNewId(IdPrefixType.MSG.getCode());
        vo.setMsgId(msgId);
        vo.setMsgTycd(vo.getMblSndngTycd());

        msgAlimTalkDAO.insertMsg(vo);

        return registSndngRcvrs(vo, vo.getRgtrId());
    }

    /*****************************************************
     * 알림톡 발신 수정
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int modifyAlimTalkSndng(MsgAlimTalkVO vo) throws Exception {
        int updated = msgAlimTalkDAO.updateMsg(vo);
        if (updated == 0) {
            throw new Exception("msg.error.noauth");
        }
        msgAlimTalkDAO.deleteMblSndng(vo);
        msgAlimTalkDAO.deleteRcvTrgtr(vo);

        return registSndngRcvrs(vo, vo.getMdfrId());
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateMsgRsrvCncl(MsgAlimTalkVO vo) {
        int cancelledCnt = msgAlimTalkDAO.updateAlimTalkSndngRsrvCncl(vo);
        if (cancelledCnt == 0) {
            return 0;
        }
        return msgAlimTalkDAO.updateMsgRsrvCncl(vo);
    }

    /*****************************************************
     * 알림톡 발송 수신자 등록
     * @param vo
     * @param rgtrId
     * @return int
     * @throws Exception
     ******************************************************/
    private int registSndngRcvrs(MsgAlimTalkVO vo, String rgtrId) throws Exception {
        JSONArray rcvrArr = parseRcvrListJson(vo.getRcvrListJson());
        if (rcvrArr.isEmpty()) {
            throw new Exception("msg.alimTalk.msg.requiredRcvr");
        }
        boolean isReservation = isReservation(vo);

        List<MsgAlimTalkVO> receivers = buildSndngRcvrList(vo, rgtrId, rcvrArr, isReservation);
        if (receivers.isEmpty()) {
            throw new Exception("msg.alimTalk.msg.requiredRcvr");
        }
        insertSndngRcvrs(receivers);

        return receivers.size();
    }

    /*****************************************************
     * 예약발송 여부 판정
     * @param vo
     * @return boolean
     ******************************************************/
    private boolean isReservation(MsgAlimTalkVO vo) {
        return vo.getRsrvSndngSdttm() != null && !vo.getRsrvSndngSdttm().isEmpty();
    }

    /*****************************************************
     * 수신자 JSON 문자열 파싱
     * @param rcvrListJson
     * @return JSONArray
     * @throws Exception
     ******************************************************/
    private JSONArray parseRcvrListJson(String rcvrListJson) throws Exception {
        if (rcvrListJson == null || rcvrListJson.isEmpty()) {
            return new JSONArray();
        }
        return (JSONArray) new JSONParser().parse(rcvrListJson);
    }

    /*****************************************************
     * 수신자 목록 insert용 VO 리스트 조립
     * @param vo
     * @param rgtrId
     * @param rcvrArr
     * @return List<MsgAlimTalkVO>
     ******************************************************/
    private List<MsgAlimTalkVO> buildSndngRcvrList(MsgAlimTalkVO vo, String rgtrId, JSONArray rcvrArr, boolean isReservation) {
        List<JSONObject> uniqRcvrs = new ArrayList<>(rcvrArr.size());
        Set<String> seenUserIds = new LinkedHashSet<>();
        for (int i = 0; i < rcvrArr.size(); i++) {
            JSONObject rcvr = (JSONObject) rcvrArr.get(i);
            String userId = (String) rcvr.get("userId");
            if (userId != null && !userId.isEmpty() && seenUserIds.add(userId)) {
                uniqRcvrs.add(rcvr);
            }
        }

        Set<String> rejectedSet;
        if (isReservation || seenUserIds.isEmpty()) {
            rejectedSet = new HashSet<>();
        } else {
            rejectedSet = new HashSet<>(
                    msgRcptnAuthService.selectRcptnPrmNoUserIdList(
                            new ArrayList<>(seenUserIds), CommConst.MSG_CHNL_ALIM_TALK)
            );
        }

        List<MsgAlimTalkVO> receivers = new ArrayList<>(uniqRcvrs.size());
        for (JSONObject rcvr : uniqRcvrs) {
            MsgAlimTalkVO rcvrVO = new MsgAlimTalkVO();
            rcvrVO.setMsgId(vo.getMsgId());
            rcvrVO.setRcvrId((String) rcvr.get("userId"));
            rcvrVO.setRcvrnm((String) rcvr.get("usernm"));
            rcvrVO.setRgtrId(rgtrId);
            rcvrVO.setMsgMblSndngId(IdGenerator.getNewId(IdPrefixType.MBL.getCode()));
            rcvrVO.setMblSndngTycd(vo.getMblSndngTycd());
            rcvrVO.setSndngTtl(vo.getTtl());
            rcvrVO.setSndngCts(vo.getTxtCts());
            rcvrVO.setSndngrId(vo.getSndngrId());
            rcvrVO.setSndngnm(vo.getSndngnm());
            rcvrVO.setSndngrPhnno(vo.getSndngrPhnno());

            if (isReservation) {
                rcvrVO.setSndngStscd(STSCD_RSRV);
                rcvrVO.setSndngYn("N");
            } else if (rejectedSet.contains(rcvrVO.getRcvrId())) {
                rcvrVO.setSndngStscd(STSCD_RJCT);
                rcvrVO.setSndngYn("N");
                rcvrVO.setSndngRsltCts(RJCT_RSLT_CTS);
            } else {
                rcvrVO.setSndngStscd(STSCD_SCS);
                rcvrVO.setSndngYn("Y");
            }

            receivers.add(rcvrVO);
        }

        return receivers;
    }

    /*****************************************************
     * 수신자 VO 리스트 insert
     * @param receivers
     ******************************************************/
    private void insertSndngRcvrs(List<MsgAlimTalkVO> receivers) {
        for (MsgAlimTalkVO rcvrVO : receivers) {
            msgAlimTalkDAO.insertRcvTrgtr(rcvrVO);
            msgAlimTalkDAO.insertMblSndng(rcvrVO);
        }
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public List<MsgAlimTalkVO> selectMsgRcvTrgtrList(MsgAlimTalkVO vo) {
        return msgAlimTalkDAO.selectMsgRcvTrgtrList(vo);
    }

}
