package knou.lms.msg.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgShrtntDAO;
import knou.lms.msg.service.MsgRcptnAuthService;
import knou.lms.msg.service.MsgShrtntService;
import knou.lms.msg.vo.MsgShrtntVO;
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

@Service("msgShrtntService")
public class MsgShrtntServiceImpl extends ServiceBase implements MsgShrtntService {

    @Resource(name = "msgShrtntDAO")
    private MsgShrtntDAO msgShrtntDAO;

    @Resource(name = "msgRcptnAuthService")
    private MsgRcptnAuthService msgRcptnAuthService;

    private static final String MSG_TYCD_SHRTNT = "SHRTNT";

    private static final String STSCD_RSRV = "RSRV";
    private static final String STSCD_SCS  = "SCS";
    private static final String STSCD_RJCT = "RJCT";
    private static final String RJCT_RSLT_CTS = "수신거부";

    /*****************************************************
     * 쪽지 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgShrtntVO> list = msgShrtntDAO.selectShrtntRcvnList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 쪽지 수신 상세 조회
     * @param vo
     * @return MsgShrtntVO
     ******************************************************/
    @Override
    public MsgShrtntVO selectShrtntRcvnDtl(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntRcvnDtl(vo);
    }

    /*****************************************************
     * 쪽지 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateShrtntReadDttm(MsgShrtntVO vo) {
        return msgShrtntDAO.updateShrtntReadDttm(vo);
    }

    /*****************************************************
     * 쪽지 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateShrtntRcvrDelyn(MsgShrtntVO vo) {
        return msgShrtntDAO.updateShrtntRcvrDelyn(vo);
    }

    /*****************************************************
     * 쪽지 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgShrtntVO> list = msgShrtntDAO.selectShrtntSndngList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 상세 조회
     * @param vo
     * @return MsgShrtntVO
     ******************************************************/
    @Override
    public MsgShrtntVO selectShrtntSndngDtl(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntSndngDtl(vo);
    }

    /*****************************************************
     * 쪽지 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgShrtntVO> list = msgShrtntDAO.selectShrtntSndngRcvrList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateShrtntSndngrDelyn(MsgShrtntVO vo) {
        return msgShrtntDAO.updateShrtntSndngrDelyn(vo);
    }

    /*****************************************************
     * 쪽지 발신 수신자 엑셀 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntSndngRcvrExcelList(vo);
    }

    /*****************************************************
     * 쪽지 발신 등록
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int registShrtntSndng(MsgShrtntVO vo) throws Exception {
        String msgId = IdGenerator.getNewId(IdPrefixType.MSG.getCode());
        vo.setMsgId(msgId);
        vo.setMsgTycd(MSG_TYCD_SHRTNT);

        msgShrtntDAO.insertMsg(vo);

        return registSndngRcvrs(vo, vo.getRgtrId());
    }

    /*****************************************************
     * 쪽지 발신 수정
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int modifyShrtntSndng(MsgShrtntVO vo) throws Exception {
        int updated = msgShrtntDAO.updateMsg(vo);
        if (updated == 0) {
            throw new Exception("msg.error.noauth");
        }
        msgShrtntDAO.deleteShrtntSndng(vo);
        msgShrtntDAO.deleteRcvTrgtr(vo);

        return registSndngRcvrs(vo, vo.getMdfrId());
    }

    /*****************************************************
     * 쪽지 발송 수신자 등록
     * @param vo
     * @param rgtrId
     * @return int
     * @throws Exception
     ******************************************************/
    private int registSndngRcvrs(MsgShrtntVO vo, String rgtrId) throws Exception {
        JSONArray rcvrArr = parseRcvrListJson(vo.getRcvrListJson());
        if (rcvrArr.isEmpty()) {
            throw new Exception("msg.shrtnt.msg.requiredRcvr");
        }
        boolean isReservation = isReservation(vo);

        List<MsgShrtntVO> receivers = buildSndngRcvrList(vo, rgtrId, rcvrArr, isReservation);
        if (receivers.isEmpty()) {
            throw new Exception("msg.shrtnt.msg.requiredRcvr");
        }
        insertSndngRcvrs(receivers);

        return receivers.size();
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
     * 예약발송 여부 판정
     * @param vo
     * @return boolean
     ******************************************************/
    private boolean isReservation(MsgShrtntVO vo) {
        return vo.getRsrvSndngSdttm() != null && !vo.getRsrvSndngSdttm().isEmpty();
    }

    /*****************************************************
     * 수신자 목록 insert용 VO 리스트 조립
     * @param vo
     * @param rgtrId
     * @param rcvrArr
     * @param isReservation
     * @return List<MsgShrtntVO>
     ******************************************************/
    private List<MsgShrtntVO> buildSndngRcvrList(MsgShrtntVO vo, String rgtrId, JSONArray rcvrArr, boolean isReservation) {
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
                            new ArrayList<>(seenUserIds), CommConst.MSG_CHNL_SHRTNT)
            );
        }

        List<MsgShrtntVO> receivers = new ArrayList<>(uniqRcvrs.size());
        for (JSONObject rcvr : uniqRcvrs) {
            MsgShrtntVO rcvrVO = new MsgShrtntVO();
            rcvrVO.setMsgId(vo.getMsgId());
            rcvrVO.setRcvrId((String) rcvr.get("userId"));
            rcvrVO.setRcvrnm((String) rcvr.get("usernm"));
            rcvrVO.setRgtrId(rgtrId);
            rcvrVO.setMsgShrtntSndngId(IdGenerator.getNewId(IdPrefixType.SHRTNT.getCode()));
            rcvrVO.setSndngTtl(vo.getTtl());
            rcvrVO.setSndngCts(vo.getTxtCts());
            rcvrVO.setSndngrId(vo.getSndngrId());
            rcvrVO.setSndngnm(vo.getSndngnm());
            rcvrVO.setUpMsgShrtntSndngId(vo.getUpMsgShrtntSndngId());

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
    private void insertSndngRcvrs(List<MsgShrtntVO> receivers) {
        for (MsgShrtntVO rcvrVO : receivers) {
            msgShrtntDAO.insertRcvTrgtr(rcvrVO);
            msgShrtntDAO.insertShrtntSndng(rcvrVO);
        }
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateMsgRsrvCncl(MsgShrtntVO vo) {
        int cancelledCnt = msgShrtntDAO.updateShrtntSndngRsrvCncl(vo);
        if (cancelledCnt == 0) {
            return 0;
        }
        return msgShrtntDAO.updateMsgRsrvCncl(vo);
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo) {
        return msgShrtntDAO.selectMsgRcvTrgtrList(vo);
    }


}
