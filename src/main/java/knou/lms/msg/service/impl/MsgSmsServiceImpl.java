package knou.lms.msg.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgSmsDAO;
import knou.lms.msg.service.MsgSmsService;
import knou.lms.msg.service.MsgRcptnAuthService;
import knou.lms.msg.vo.MsgSmsVO;
import knou.framework.exception.BusinessException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Service("msgSmsService")
public class MsgSmsServiceImpl extends ServiceBase implements MsgSmsService {

    @Resource(name = "msgSmsDAO")
    private MsgSmsDAO msgSmsDAO;

    @Resource(name = "msgRcptnAuthService")
    private MsgRcptnAuthService msgRcptnAuthService;

    private static final String STSCD_RSRV = "RSRV";
    private static final String STSCD_SCS  = "SCS";
    private static final String STSCD_RJCT = "RJCT";
    private static final String RJCT_RSLT_CTS = "수신거부";

    /*****************************************************
     * 문자 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSmsVO> selectSmsRcvnListPage(MsgSmsVO vo) throws Exception {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgSmsVO> list = msgSmsDAO.selectSmsRcvnList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 문자 수신 상세 조회
     * @param vo
     * @return MsgSmsVO
     ******************************************************/
    @Override
    public MsgSmsVO selectSmsRcvnDtl(MsgSmsVO vo) {
        return msgSmsDAO.selectSmsRcvnDtl(vo);
    }

    /*****************************************************
     * 문자 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateSmsReadDttm(MsgSmsVO vo) {
        return msgSmsDAO.updateSmsReadDttm(vo);
    }

    /*****************************************************
     * 문자 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateSmsRcvrDelyn(MsgSmsVO vo) {
        return msgSmsDAO.updateSmsRcvrDelyn(vo);
    }

    /*****************************************************
     * 문자 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSmsVO> selectSmsSndngListPage(MsgSmsVO vo) throws Exception {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgSmsVO> list = msgSmsDAO.selectSmsSndngList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 문자 발신 상세 조회
     * @param vo
     * @return MsgSmsVO
     ******************************************************/
    @Override
    public MsgSmsVO selectSmsSndngDtl(MsgSmsVO vo) {
        return msgSmsDAO.selectSmsSndngDtl(vo);
    }

    /*****************************************************
     * 문자 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSmsVO> selectSmsSndngRcvrListPage(MsgSmsVO vo) throws Exception {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgSmsVO> list = msgSmsDAO.selectSmsSndngRcvrList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 문자 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateSmsSndngrDelyn(MsgSmsVO vo) {
        return msgSmsDAO.updateSmsSndngrDelyn(vo);
    }

    /*****************************************************
     * 문자 발신 등록
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int registSmsSndng(MsgSmsVO vo) {
        String msgId = IdGenerator.getNewId(IdPrefixType.MSG.getCode());
        vo.setMsgId(msgId);
        vo.setMsgTycd(vo.getMblSndngTycd());

        msgSmsDAO.insertMsg(vo);

        return registSndngRcvrs(vo, vo.getRgtrId());
    }

    /*****************************************************
     * 문자 발신 수정
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifySmsSndng(MsgSmsVO vo) {
        int updated = msgSmsDAO.updateMsg(vo);
        if (updated == 0) {
            throw new BusinessException("msg.error.noauth");
        }
        msgSmsDAO.deleteMblSndng(vo);
        msgSmsDAO.deleteRcvTrgtr(vo);

        return registSndngRcvrs(vo, vo.getMdfrId());
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateMsgRsrvCncl(MsgSmsVO vo) {
        int cancelledCnt = msgSmsDAO.updateSmsSndngRsrvCncl(vo);
        if (cancelledCnt == 0) {
            return 0;
        }
        return msgSmsDAO.updateMsgRsrvCncl(vo);
    }

    /*****************************************************
     * 문자 발송 수신자 등록
     * @param vo
     * @param rgtrId
     * @return int
     ******************************************************/
    private int registSndngRcvrs(MsgSmsVO vo, String rgtrId) {
        JSONArray rcvrArr = parseRcvrListJson(vo.getRcvrListJson());
        if (rcvrArr.isEmpty()) {
            throw new BusinessException("msg.sms.msg.requiredRcvr");
        }
        boolean isReservation = isReservation(vo);

        List<MsgSmsVO> receivers = buildSndngRcvrList(vo, rgtrId, rcvrArr, isReservation);
        if (receivers.isEmpty()) {
            throw new BusinessException("msg.sms.msg.requiredRcvr");
        }
        insertSndngRcvrs(receivers);

        return receivers.size();
    }

    /*****************************************************
     * 예약발송 여부 판정
     * @param vo
     * @return boolean
     ******************************************************/
    private boolean isReservation(MsgSmsVO vo) {
        return vo.getRsrvSndngSdttm() != null && !vo.getRsrvSndngSdttm().isEmpty();
    }

    /*****************************************************
     * 수신자 JSON 문자열 파싱
     * @param rcvrListJson
     * @return JSONArray
     ******************************************************/
    private JSONArray parseRcvrListJson(String rcvrListJson) {
        if (rcvrListJson == null || rcvrListJson.isEmpty()) {
            return new JSONArray();
        }
        try {
            return (JSONArray) new JSONParser().parse(rcvrListJson);
        } catch (ParseException e) {
            throw new BusinessException("msg.sms.msg.requiredRcvr");
        }
    }

    /*****************************************************
     * 수신자 목록 insert용 VO 리스트 조립
     * @param vo
     * @param rgtrId
     * @param rcvrArr
     * @return List<MsgSmsVO>
     ******************************************************/
    private List<MsgSmsVO> buildSndngRcvrList(MsgSmsVO vo, String rgtrId, JSONArray rcvrArr, boolean isReservation) {
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
        if (seenUserIds.isEmpty()) {
            rejectedSet = new HashSet<>();
        } else {
            rejectedSet = new HashSet<>(
                    msgRcptnAuthService.selectRcptnPrmNoUserIdList(
                            new ArrayList<>(seenUserIds), CommConst.MSG_CHNL_SMS)
            );
        }

        List<MsgSmsVO> receivers = new ArrayList<>(uniqRcvrs.size());
        for (JSONObject rcvr : uniqRcvrs) {
            MsgSmsVO rcvrVO = new MsgSmsVO();
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

            if (rejectedSet.contains(rcvrVO.getRcvrId())) {
                rcvrVO.setSndngStscd(STSCD_RJCT);
                rcvrVO.setSndngYn("N");
                rcvrVO.setSndngRsltCts(RJCT_RSLT_CTS);
            } else {
                rcvrVO.setSndngStscd(STSCD_RSRV);
                rcvrVO.setSndngYn("N");
            }

            receivers.add(rcvrVO);
        }

        return receivers;
    }

    /*****************************************************
     * 수신자 VO 리스트 insert
     * @param receivers
     ******************************************************/
    private void insertSndngRcvrs(List<MsgSmsVO> receivers) {
        for (MsgSmsVO rcvrVO : receivers) {
            msgSmsDAO.insertRcvTrgtr(rcvrVO);
            msgSmsDAO.insertMblSndng(rcvrVO);
        }
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgSmsVO>
     ******************************************************/
    @Override
    public List<MsgSmsVO> selectMsgRcvTrgtrList(MsgSmsVO vo) {
        return msgSmsDAO.selectMsgRcvTrgtrList(vo);
    }

    /*****************************************************
     * 문자 발송 결과 업데이트
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateMblSndngRslt(MsgSmsVO vo) {
        return msgSmsDAO.updateMblSndngRslt(vo);
    }

}
