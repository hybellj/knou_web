package knou.lms.msg.facade;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.msg.service.MsgShrtntService;
import knou.lms.msg.vo.MsgShrtntVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;

@Service("msgShrtntFacadeService")
public class MsgShrtntFacadeServiceImpl extends ServiceBase implements MsgShrtntFacadeService {

    @Resource(name = "msgShrtntService")
    private MsgShrtntService msgShrtntService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    /**
     * 기관 목록 조회
     */
    @Override
    public List<OrgInfoVO> selectActiveOrgList() throws Exception {
        return orgInfoService.listActiveOrg();
    }

    /**
     * 첨부파일 목록 조회 (refId 기준)
     */
    @Override
    public List<AtflVO> selectAtflListByRefId(String refId) throws Exception {
        AtflVO atflVO = new AtflVO();
        atflVO.setRefId(refId);
        return attachFileService.selectAtflListByRefId(atflVO);
    }

    /**
     * 쪽지 수신 목록 조회 (페이징)
     */
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntRcvnListPage(vo);
    }

    /**
     * 쪽지 수신 상세 조회 (첨부파일 포함)
     */
    @Override
    public MsgShrtntVO selectShrtntRcvnDetailWithFiles(MsgShrtntVO vo) throws Exception {
        MsgShrtntVO detail = msgShrtntService.selectShrtntRcvnDetail(vo);
        if (detail != null && detail.getFileCnt() > 0) {
            detail.setAtflList(selectAtflListByRefId(detail.getMsgId()));
        }
        return detail;
    }

    /**
     * 쪽지 읽음 처리
     */
    @Override
    public int updateShrtntReadDttm(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntReadDttm(vo);
    }

    /**
     * 쪽지 수신자 삭제 (논리)
     */
    @Override
    public int updateShrtntRcvrDelyn(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntRcvrDelyn(vo);
    }

    /**
     * 쪽지 발신 목록 조회 (페이징)
     */
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSndngListPage(vo);
    }

    /**
     * 쪽지 발신 상세 조회 (첨부파일 포함)
     */
    @Override
    public MsgShrtntVO selectShrtntSndngDetailWithFiles(MsgShrtntVO vo) throws Exception {
        MsgShrtntVO detail = msgShrtntService.selectShrtntSndngDetail(vo);
        if (detail != null && detail.getFileCnt() > 0) {
            detail.setAtflList(selectAtflListByRefId(detail.getMsgId()));
        }
        return detail;
    }

    /**
     * 쪽지 발신 수신자 목록 조회 (페이징)
     */
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSndngRcvrListPage(vo);
    }

    /**
     * 쪽지 발신자 삭제 (논리)
     */
    @Override
    public int updateShrtntSndngrDelyn(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntSndngrDelyn(vo);
    }

    /**
     * 쪽지 발신 수신자 엑셀 목록 조회
     */
    @Override
    public List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSndngRcvrExcelList(vo);
    }

    /**
     * 쪽지 발신 등록 (첨부파일 포함)
     */
    @Override
    public void registShrtntSndngWithFiles(MsgShrtntVO vo, List<AtflVO> fileList) throws Exception {
        msgShrtntService.registShrtntSndng(vo);

        if (fileList != null && !fileList.isEmpty()) {
            for (AtflVO atfl : fileList) {
                atfl.setRefId(vo.getMsgId());
            }
            attachFileService.insertAtflList(fileList);
        }
    }

    /**
     * 쪽지 발신 수정 (첨부파일 포함)
     */
    @Override
    public void modifyShrtntSndngWithFiles(MsgShrtntVO vo, List<AtflVO> fileList, String[] delFileIds) throws Exception {
        msgShrtntService.modifyShrtntSndng(vo);

        if (fileList != null && !fileList.isEmpty()) {
            for (AtflVO atfl : fileList) {
                atfl.setRefId(vo.getMsgId());
            }
            attachFileService.insertAtflList(fileList);
        }

        if (delFileIds != null && delFileIds.length > 0) {
            attachFileService.deleteAtflByAtflIds(delFileIds);
        }
    }

    /**
     * 예약 발신 취소
     */
    @Override
    public int updateMsgRsrvCncl(MsgShrtntVO vo) {
        return msgShrtntService.updateMsgRsrvCncl(vo);
    }

    /**
     * 받는 사람 검색 목록 조회 (페이징)
     */
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntRcvrSearchListPage(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntRcvrSearchListPage(vo);
    }

    /**
     * 수신 대상자 목록 조회
     */
    @Override
    public List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo) {
        return msgShrtntService.selectMsgRcvTrgtrList(vo);
    }

    /**
     * 학사년도 목록 조회
     */
    @Override
    public List<MsgShrtntVO> selectShrtntYrList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntYrList(vo);
    }

    /**
     * 학기 목록 조회
     */
    @Override
    public List<EgovMap> selectShrtntSmstrList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSmstrList(vo);
    }

    /**
     * 학과 목록 조회
     */
    @Override
    public List<MsgShrtntVO> selectShrtntDeptList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntDeptList(vo);
    }

    /**
     * 운영과목 목록 조회
     */
    @Override
    public List<MsgShrtntVO> selectShrtntSbjctList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSbjctList(vo);
    }

    /**
     * 엑셀 업로드 수신자 조회 (아이디 목록 기준)
     */
    @Override
    public List<MsgShrtntVO> selectShrtntRcvrByUserIds(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntRcvrByUserIds(vo);
    }
}
