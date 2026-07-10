package knou.lms.msg.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgEmlDAO;
import knou.lms.msg.service.MsgEmlService;
import knou.lms.msg.service.MsgRcptnAuthService;
import knou.lms.msg.vo.MsgEmlVO;
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

@Service("msgEmlService")
public class MsgEmlServiceImpl extends ServiceBase implements MsgEmlService {

    @Resource(name = "msgEmlDAO")
    private MsgEmlDAO msgEmlDAO;

    @Resource(name = "msgRcptnAuthService")
    private MsgRcptnAuthService msgRcptnAuthService;

    private static final String MSG_TYCD_EML = "EML";
    private static final String CHNL_EML = "EML";

    private static final String STSCD_RSRV = "RSRV";
    private static final String STSCD_SCS  = "SCS";
    private static final String STSCD_RJCT = "RJCT";
    private static final String RJCT_RSLT_CTS = "수신거부";

    /*****************************************************
     * 이메일 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgEmlVO> selectEmlRcvnListPage(MsgEmlVO vo) throws Exception {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgEmlVO> list = msgEmlDAO.selectEmlRcvnList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 이메일 수신 상세 조회
     * @param vo
     * @return MsgEmlVO
     ******************************************************/
    @Override
    public MsgEmlVO selectEmlRcvnDtl(MsgEmlVO vo) {
        return msgEmlDAO.selectEmlRcvnDtl(vo);
    }

    /*****************************************************
     * 이메일 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateEmlReadDttm(MsgEmlVO vo) {
        return msgEmlDAO.updateEmlReadDttm(vo);
    }

    /*****************************************************
     * 이메일 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateEmlRcvrDelyn(MsgEmlVO vo) {
        return msgEmlDAO.updateEmlRcvrDelyn(vo);
    }

    /*****************************************************
     * 이메일 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgEmlVO> selectEmlSndngListPage(MsgEmlVO vo) throws Exception {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgEmlVO> list = msgEmlDAO.selectEmlSndngList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 이메일 발신 상세 조회
     * @param vo
     * @return MsgEmlVO
     ******************************************************/
    @Override
    public MsgEmlVO selectEmlSndngDtl(MsgEmlVO vo) {
        return msgEmlDAO.selectEmlSndngDtl(vo);
    }

    /*****************************************************
     * 이메일 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgEmlVO> selectEmlSndngRcvrListPage(MsgEmlVO vo) throws Exception {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgEmlVO> list = msgEmlDAO.selectEmlSndngRcvrList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 이메일 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateEmlSndngrDelyn(MsgEmlVO vo) {
        return msgEmlDAO.updateEmlSndngrDelyn(vo);
    }

    /*****************************************************
     * 이메일 발신 등록
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int registEmlSndng(MsgEmlVO vo) throws Exception {
        String msgId = IdGenerator.getNewId(IdPrefixType.MSG.getCode());
        vo.setMsgId(msgId);
        vo.setMsgTycd(MSG_TYCD_EML);

        msgEmlDAO.insertMsg(vo);

        return registSndngRcvrs(vo, vo.getRgtrId());
    }

    /*****************************************************
     * 이메일 발신 수정
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int modifyEmlSndng(MsgEmlVO vo) throws Exception {
        int updated = msgEmlDAO.updateMsg(vo);
        if (updated == 0) {
            throw new Exception("msg.error.noauth");
        }
        msgEmlDAO.deleteEmlSndng(vo);
        msgEmlDAO.deleteRcvTrgtr(vo);

        return registSndngRcvrs(vo, vo.getMdfrId());
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateMsgRsrvCncl(MsgEmlVO vo) {
        int cancelledCnt = msgEmlDAO.updateEmlSndngRsrvCncl(vo);
        if (cancelledCnt == 0) {
            return 0;
        }
        return msgEmlDAO.updateMsgRsrvCncl(vo);
    }

    /*****************************************************
     * 이메일 발송 수신자 등록
     * @param vo
     * @param rgtrId
     * @return int
     * @throws Exception
     ******************************************************/
    private int registSndngRcvrs(MsgEmlVO vo, String rgtrId) throws Exception {
        JSONArray rcvrArr = parseRcvrListJson(vo.getRcvrListJson());
        if (rcvrArr.isEmpty()) {
            throw new Exception("msg.eml.msg.requiredRcvr");
        }
        boolean isReservation = isReservation(vo);

        List<MsgEmlVO> receivers = buildSndngRcvrList(vo, rgtrId, rcvrArr, isReservation);
        if (receivers.isEmpty()) {
            throw new Exception("msg.eml.msg.requiredRcvr");
        }
        insertSndngRcvrs(receivers);

        return receivers.size();
    }

    /*****************************************************
     * 예약발송 여부 판정
     * @param vo
     * @return boolean
     ******************************************************/
    private boolean isReservation(MsgEmlVO vo) {
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
     * @param isReservation
     * @return List<MsgEmlVO>
     ******************************************************/
    private List<MsgEmlVO> buildSndngRcvrList(MsgEmlVO vo, String rgtrId, JSONArray rcvrArr, boolean isReservation) {
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
                            new ArrayList<>(seenUserIds), CHNL_EML)
            );
        }

        List<MsgEmlVO> receivers = new ArrayList<>(uniqRcvrs.size());
        for (JSONObject rcvr : uniqRcvrs) {
            MsgEmlVO rcvrVO = new MsgEmlVO();
            rcvrVO.setMsgId(vo.getMsgId());
            rcvrVO.setRcvrId((String) rcvr.get("userId"));
            rcvrVO.setRcvrnm((String) rcvr.get("usernm"));
            rcvrVO.setRgtrId(rgtrId);
            rcvrVO.setMsgEmlSndngId(IdGenerator.getNewId(IdPrefixType.EML.getCode()));
            rcvrVO.setSndngTtl(vo.getTtl());
            String htmlCts = vo.getHtmlCts();
            rcvrVO.setSndngCts(htmlCts != null && !htmlCts.isEmpty() ? htmlCts : vo.getTxtCts());
            rcvrVO.setSndngrId(vo.getSndngrId());
            rcvrVO.setSndngnm(vo.getSndngnm());
            rcvrVO.setSndngEml(vo.getSndngEml());
            rcvrVO.setBfrMsgEmlSndngId(vo.getBfrMsgEmlSndngId());

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
    private void insertSndngRcvrs(List<MsgEmlVO> receivers) {
        for (MsgEmlVO rcvrVO : receivers) {
            msgEmlDAO.insertRcvTrgtr(rcvrVO);
            msgEmlDAO.insertEmlSndng(rcvrVO);
        }
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgEmlVO>
     ******************************************************/
    @Override
    public List<MsgEmlVO> selectMsgRcvTrgtrList(MsgEmlVO vo) {
        return msgEmlDAO.selectMsgRcvTrgtrList(vo);
    }
}
