package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgShrtntDAO;
import knou.lms.msg.service.MsgShrtntService;
import knou.lms.msg.vo.MsgShrtntVO;

@Service("msgShrtntService")
public class MsgShrtntServiceImpl extends ServiceBase implements MsgShrtntService {

    @Resource(name = "msgShrtntDAO")
    private MsgShrtntDAO msgShrtntDAO;

    private PaginationInfo initPagination(MsgShrtntVO vo) {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex() + 1);
        vo.setLastIndex(paginationInfo.getFirstRecordIndex() + vo.getListScale());
        return paginationInfo;
    }

    /** 쪽지 수신 목록 조회 (페이징) */
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();
        PaginationInfo paginationInfo = initPagination(vo);

        paginationInfo.setTotalRecordCount(msgShrtntDAO.selectShrtntRcvnCnt(vo));
        resultVO.setReturnList(msgShrtntDAO.selectShrtntRcvnList(vo));
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 쪽지 수신 상세 조회
     * @param vo
     * @return
     */
    @Override
    public MsgShrtntVO selectShrtntRcvnDetail(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntRcvnDetail(vo);
    }

    /**
     * 쪽지 읽음 처리
     * @param vo
     * @return
     */
    @Override
    public int updateShrtntReadDttm(MsgShrtntVO vo) {
        return msgShrtntDAO.updateShrtntReadDttm(vo);
    }

    /**
     * 쪽지 수신자 삭제 (논리)
     * @param vo
     * @return
     */
    @Override
    public int updateShrtntRcvrDelyn(MsgShrtntVO vo) {
        return msgShrtntDAO.updateShrtntRcvrDelyn(vo);
    }

    /** 쪽지 발신 목록 조회 (페이징) */
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();
        PaginationInfo paginationInfo = initPagination(vo);

        paginationInfo.setTotalRecordCount(msgShrtntDAO.selectShrtntSndngCnt(vo));
        resultVO.setReturnList(msgShrtntDAO.selectShrtntSndngList(vo));
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 쪽지 발신 상세 조회
     * @param vo
     * @return
     */
    @Override
    public MsgShrtntVO selectShrtntSndngDetail(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntSndngDetail(vo);
    }

    /** 쪽지 발신 수신자 목록 조회 (페이징) */
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();
        PaginationInfo paginationInfo = initPagination(vo);

        paginationInfo.setTotalRecordCount(msgShrtntDAO.selectShrtntSndngRcvrCnt(vo));
        resultVO.setReturnList(msgShrtntDAO.selectShrtntSndngRcvrList(vo));
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 쪽지 발신자 삭제 (논리)
     * @param vo
     * @return
     */
    @Override
    public int updateShrtntSndngrDelyn(MsgShrtntVO vo) {
        return msgShrtntDAO.updateShrtntSndngrDelyn(vo);
    }

    /**
     * 쪽지 발신 수신자 엑셀 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntSndngRcvrExcelList(vo);
    }

    /**
     * 쪽지 발신 등록
     * @param vo
     * @return
     */
    @Override
    public int registShrtntSndng(MsgShrtntVO vo) throws Exception {
        String msgId = IdGenerator.getNewId(IdPrefixType.MSG.getCode());
        vo.setMsgId(msgId);
        vo.setMsgTycd("SHRTNT");

        msgShrtntDAO.insertMsg(vo);

        return insertReceivers(vo, vo.getRgtrId());
    }

    /**
     * 쪽지 발신 수정
     * @param vo
     * @return
     */
    @Override
    public int modifyShrtntSndng(MsgShrtntVO vo) throws Exception {
        msgShrtntDAO.updateMsg(vo);
        msgShrtntDAO.deleteRcvTrgtr(vo);

        return insertReceivers(vo, vo.getMdfrId());
    }

    private int insertReceivers(MsgShrtntVO vo, String rgtrId) throws Exception {
        JSONParser parser = new JSONParser();
        JSONArray rcvrArr = (JSONArray) parser.parse(vo.getRcvrListJson());

        boolean isReservation = vo.getRsrvSndngSdttm() != null && !vo.getRsrvSndngSdttm().isEmpty();

        for (int i = 0; i < rcvrArr.size(); i++) {
            JSONObject rcvr = (JSONObject) rcvrArr.get(i);

            MsgShrtntVO rcvrVO = new MsgShrtntVO();
            rcvrVO.setMsgId(vo.getMsgId());
            rcvrVO.setRcvrId((String) rcvr.get("userId"));
            rcvrVO.setRcvrnm((String) rcvr.get("usernm"));
            rcvrVO.setRgtrId(rgtrId);

            msgShrtntDAO.insertRcvTrgtr(rcvrVO);

            if (!isReservation) {
                String shrtntId = IdGenerator.getNewId(IdPrefixType.SHTNT.getCode());
                rcvrVO.setMsgShrtntSndngId(shrtntId);
                rcvrVO.setSndngTtl(vo.getTtl());
                rcvrVO.setSndngCts(vo.getTxtCts());
                rcvrVO.setSndngrId(vo.getSndngrId());
                rcvrVO.setSndngnm(vo.getSndngnm());
                rcvrVO.setUpMsgShrtntSndngId(vo.getUpMsgShrtntSndngId());

                msgShrtntDAO.insertShrtntSndng(rcvrVO);
            }
        }

        return rcvrArr.size();
    }

    /**
     * 예약 발신 취소
     * @param vo
     * @return
     */
    @Override
    public int updateMsgRsrvCncl(MsgShrtntVO vo) {
        return msgShrtntDAO.updateMsgRsrvCncl(vo);
    }

    /** 받는 사람 검색 목록 조회 (페이징) */
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntRcvrSearchListPage(MsgShrtntVO vo) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();
        PaginationInfo paginationInfo = initPagination(vo);

        if ("Y".equals(vo.getAdminYn())) {
            paginationInfo.setTotalRecordCount(msgShrtntDAO.selectShrtntRcvrSearchAllCnt(vo));
            resultVO.setReturnList(msgShrtntDAO.selectShrtntRcvrSearchAllList(vo));
        } else {
            paginationInfo.setTotalRecordCount(msgShrtntDAO.selectShrtntRcvrSearchCnt(vo));
            resultVO.setReturnList(msgShrtntDAO.selectShrtntRcvrSearchList(vo));
        }
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 수신 대상자 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo) {
        return msgShrtntDAO.selectMsgRcvTrgtrList(vo);
    }

    /**
     * 학사년도 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgShrtntVO> selectShrtntYrList(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntYrList(vo);
    }

    /**
     * 학기 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<EgovMap> selectShrtntSmstrList(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntSmstrList(vo);
    }

    /**
     * 학과 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgShrtntVO> selectShrtntDeptList(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntDeptList(vo);
    }

    /**
     * 운영과목 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgShrtntVO> selectShrtntSbjctList(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntSbjctList(vo);
    }

    /**
     * 엑셀 업로드 수신자 조회 (아이디 목록 기준)
     * @param vo
     * @return
     */
    @Override
    public List<MsgShrtntVO> selectShrtntRcvrByUserIds(MsgShrtntVO vo) {
        return msgShrtntDAO.selectShrtntRcvrByUserIds(vo);
    }
}
