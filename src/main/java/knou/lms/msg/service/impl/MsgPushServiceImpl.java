package knou.lms.msg.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgPushDAO;
import knou.lms.msg.service.MsgPushService;
import knou.lms.msg.service.MsgRcptnAuthService;
import knou.lms.msg.vo.MsgPushVO;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Service("msgPushService")
public class MsgPushServiceImpl extends ServiceBase implements MsgPushService {

    @Resource(name = "msgPushDAO")
    private MsgPushDAO msgPushDAO;

    @Resource(name = "msgRcptnAuthService")
    private MsgRcptnAuthService msgRcptnAuthService;

    private static final String STSCD_RSRV = "RSRV";
    private static final String STSCD_SCS  = "SCS";
    private static final String STSCD_RJCT = "RJCT";
    private static final String RJCT_RSLT_CTS = "수신거부";

    /*****************************************************
     * 푸시 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgPushVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgPushVO> selectPushRcvnListPage(MsgPushVO vo) throws Exception {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgPushVO> list = msgPushDAO.selectPushRcvnList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 푸시 수신 상세 조회
     * @param vo
     * @return MsgPushVO
     ******************************************************/
    @Override
    public MsgPushVO selectPushRcvnDtl(MsgPushVO vo) {
        return msgPushDAO.selectPushRcvnDtl(vo);
    }

    /*****************************************************
     * 푸시 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updatePushReadDttm(MsgPushVO vo) {
        return msgPushDAO.updatePushReadDttm(vo);
    }

    /*****************************************************
     * 푸시 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updatePushRcvrDelyn(MsgPushVO vo) {
        return msgPushDAO.updatePushRcvrDelyn(vo);
    }

    /*****************************************************
     * 푸시 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgPushVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgPushVO> selectPushSndngListPage(MsgPushVO vo) throws Exception {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgPushVO> list = msgPushDAO.selectPushSndngList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 푸시 발신 상세 조회
     * @param vo
     * @return MsgPushVO
     ******************************************************/
    @Override
    public MsgPushVO selectPushSndngDtl(MsgPushVO vo) {
        return msgPushDAO.selectPushSndngDtl(vo);
    }

    /*****************************************************
     * 푸시 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgPushVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgPushVO> selectPushSndngRcvrListPage(MsgPushVO vo) throws Exception {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgPushVO> list = msgPushDAO.selectPushSndngRcvrList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 푸시 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updatePushSndngrDelyn(MsgPushVO vo) {
        return msgPushDAO.updatePushSndngrDelyn(vo);
    }

    /*****************************************************
     * 푸시 발신 등록
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int registPushSndng(MsgPushVO vo) throws Exception {
        String msgId = IdGenerator.getNewId(IdPrefixType.MSG.getCode());
        vo.setMsgId(msgId);
        vo.setMsgTycd(vo.getMblSndngTycd());

        msgPushDAO.insertMsg(vo);

        return registSndngRcvrs(vo, vo.getRgtrId());
    }

    /*****************************************************
     * 푸시 발신 수정
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int modifyPushSndng(MsgPushVO vo) throws Exception {
        int updated = msgPushDAO.updateMsg(vo);
        if (updated == 0) {
            throw new Exception("msg.error.noauth");
        }
        msgPushDAO.deleteMblSndng(vo);
        msgPushDAO.deleteRcvTrgtr(vo);

        return registSndngRcvrs(vo, vo.getMdfrId());
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateMsgRsrvCncl(MsgPushVO vo) {
        int cancelledCnt = msgPushDAO.updatePushSndngRsrvCncl(vo);
        if (cancelledCnt == 0) {
            return 0;
        }
        return msgPushDAO.updateMsgRsrvCncl(vo);
    }

    /*****************************************************
     * 푸시 발송 수신자 등록
     * @param vo
     * @param rgtrId
     * @return int
     * @throws Exception
     ******************************************************/
    private int registSndngRcvrs(MsgPushVO vo, String rgtrId) throws Exception {
        JSONArray rcvrArr = parseRcvrListJson(vo.getRcvrListJson());
        if (rcvrArr.isEmpty()) {
            throw new Exception("msg.push.msg.requiredRcvr");
        }
        boolean isReservation = isReservation(vo);

        List<MsgPushVO> receivers = buildSndngRcvrList(vo, rgtrId, rcvrArr, isReservation);
        if (receivers.isEmpty()) {
            throw new Exception("msg.push.msg.requiredRcvr");
        }
        insertSndngRcvrs(receivers);

        return receivers.size();
    }

    /*****************************************************
     * 예약발송 여부 판정
     * @param vo
     * @return boolean
     ******************************************************/
    private boolean isReservation(MsgPushVO vo) {
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
     * @return List<MsgPushVO>
     ******************************************************/
    private List<MsgPushVO> buildSndngRcvrList(MsgPushVO vo, String rgtrId, JSONArray rcvrArr, boolean isReservation) {
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
                            new ArrayList<>(seenUserIds), CommConst.MSG_CHNL_PUSH)
            );
        }

        List<MsgPushVO> receivers = new ArrayList<>(uniqRcvrs.size());
        for (JSONObject rcvr : uniqRcvrs) {
            MsgPushVO rcvrVO = new MsgPushVO();
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
    private void insertSndngRcvrs(List<MsgPushVO> receivers) {
        for (MsgPushVO rcvrVO : receivers) {
            msgPushDAO.insertRcvTrgtr(rcvrVO);
            msgPushDAO.insertMblSndng(rcvrVO);
        }
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgPushVO>
     ******************************************************/
    @Override
    public List<MsgPushVO> selectMsgRcvTrgtrList(MsgPushVO vo) {
        return msgPushDAO.selectMsgRcvTrgtrList(vo);
    }

}
