package knou.lms.msg.facade;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.msg.service.MsgShrtntService;
import knou.lms.msg.vo.MsgShrtntVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import org.apache.poi.ss.usermodel.*;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service("msgShrtntFacadeService")
public class MsgShrtntFacadeServiceImpl extends ServiceBase implements MsgShrtntFacadeService {

    @Resource(name = "msgShrtntService")
    private MsgShrtntService msgShrtntService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    /*****************************************************
     * 기관 목록 조회
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectActiveOrgList() throws Exception {
        return orgInfoService.listActiveOrg();
    }

    /*****************************************************
     * 첨부파일 목록 조회 (refId 기준)
     * @param refId
     * @return List<AtflVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<AtflVO> selectAtflListByRefId(String refId) throws Exception {
        AtflVO atflVO = new AtflVO();
        atflVO.setRefId(refId);
        return attachFileService.selectAtflListByRefId(atflVO);
    }

    /*****************************************************
     * 쪽지 수신 목록 조회 (페이징)
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntRcvnListPage(vo);
    }

    /*****************************************************
     * 쪽지 수신 상세 조회 (첨부파일 포함)
     * @param vo
     * @return MsgShrtntVO
     * @throws Exception
     ******************************************************/
    @Override
    public MsgShrtntVO selectShrtntRcvnDetailWithFiles(MsgShrtntVO vo) throws Exception {
        MsgShrtntVO detail = msgShrtntService.selectShrtntRcvnDetail(vo);
        if (detail != null && detail.getFileCnt() > 0) {
            detail.setAtflList(selectAtflListByRefId(detail.getMsgId()));
        }
        return detail;
    }

    /*****************************************************
     * 쪽지 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateShrtntReadDttm(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntReadDttm(vo);
    }

    /*****************************************************
     * 쪽지 수신자 삭제 (논리)
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateShrtntRcvrDelyn(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntRcvrDelyn(vo);
    }

    /*****************************************************
     * 쪽지 발신 목록 조회 (페이징)
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSndngListPage(vo);
    }

    /*****************************************************
     * 쪽지 발신 상세 조회 (첨부파일 포함)
     * @param vo
     * @return MsgShrtntVO
     * @throws Exception
     ******************************************************/
    @Override
    public MsgShrtntVO selectShrtntSndngDetailWithFiles(MsgShrtntVO vo) throws Exception {
        MsgShrtntVO detail = msgShrtntService.selectShrtntSndngDetail(vo);
        if (detail != null && detail.getFileCnt() > 0) {
            detail.setAtflList(selectAtflListByRefId(detail.getMsgId()));
        }
        return detail;
    }

    /*****************************************************
     * 쪽지 발신 수신자 목록 조회 (페이징)
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSndngRcvrListPage(vo);
    }

    /*****************************************************
     * 쪽지 발신자 삭제 (논리)
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateShrtntSndngrDelyn(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntSndngrDelyn(vo);
    }

    /*****************************************************
     * 쪽지 발신 수신자 엑셀 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSndngRcvrExcelList(vo);
    }

    /*****************************************************
     * 쪽지 발신 등록 (첨부파일 포함)
     * @param vo
     * @param uploadFiles
     * @param uploadPath
     * @throws Exception
     ******************************************************/
    @Override
    public void registShrtntSndngWithFiles(MsgShrtntVO vo, String uploadFiles, String uploadPath) throws Exception {
        msgShrtntService.registShrtntSndng(vo);

        if (StringUtil.isNotNull(uploadFiles)) {
            List<AtflVO> fileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
            for (AtflVO atfl : fileList) {
                atfl.setRgtrId(vo.getRgtrId());
                atfl.setAtflRepoId(CommConst.REPO_MSG);
                atfl.setRefId(vo.getMsgId());
            }
            attachFileService.insertAtflList(fileList);
        }
    }

    /*****************************************************
     * 쪽지 발신 수정 (첨부파일 포함)
     * @param vo
     * @param uploadFiles
     * @param uploadPath
     * @param delFileIds
     * @throws Exception
     ******************************************************/
    @Override
    public void modifyShrtntSndngWithFiles(MsgShrtntVO vo, String uploadFiles, String uploadPath, String[] delFileIds) throws Exception {
        msgShrtntService.modifyShrtntSndng(vo);

        if (StringUtil.isNotNull(uploadFiles)) {
            List<AtflVO> fileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
            for (AtflVO atfl : fileList) {
                atfl.setRgtrId(vo.getMdfrId());
                atfl.setMdfrId(vo.getMdfrId());
                atfl.setAtflRepoId(CommConst.REPO_MSG);
                atfl.setRefId(vo.getMsgId());
            }
            attachFileService.insertAtflList(fileList);
        }

        if (delFileIds != null && delFileIds.length > 0) {
            attachFileService.deleteAtflByAtflIds(delFileIds);
        }
    }

    /*****************************************************
     * 엑셀 파일 파싱 후 수신자 검색
     * @param excelInputStream
     * @return List<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<MsgShrtntVO> parseExcelAndSearchRcvr(InputStream excelInputStream) throws Exception {
        Workbook workbook = WorkbookFactory.create(excelInputStream);
        Sheet sheet = workbook.getSheetAt(0);

        DataFormatter formatter = new DataFormatter();
        List<String> userIdList = new ArrayList<>();

        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;
            String userId = formatter.formatCellValue(row.getCell(0)).trim();
            if (!userId.isEmpty()) {
                userIdList.add(userId);
            }
        }
        workbook.close();

        if (userIdList.isEmpty()) {
            return new ArrayList<>();
        }

        MsgShrtntVO vo = new MsgShrtntVO();
        vo.setUserIdList(userIdList);
        return msgShrtntService.selectShrtntRcvrByUserIds(vo);
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateMsgRsrvCncl(MsgShrtntVO vo) {
        return msgShrtntService.updateMsgRsrvCncl(vo);
    }

    /*****************************************************
     * 받는 사람 검색 목록 조회 (페이징)
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntRcvrSearchListPage(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntRcvrSearchListPage(vo);
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo) {
        return msgShrtntService.selectMsgRcvTrgtrList(vo);
    }

    /*****************************************************
     * 학사년도 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectShrtntYrList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntYrList(vo);
    }

    /*****************************************************
     * 학기 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> selectShrtntSmstrList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSmstrList(vo);
    }

    /*****************************************************
     * 학과 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectShrtntDeptList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntDeptList(vo);
    }

    /*****************************************************
     * 운영과목 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectShrtntSbjctList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSbjctList(vo);
    }

    /*****************************************************
     * 엑셀 업로드 수신자 조회 (아이디 목록 기준)
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectShrtntRcvrByUserIds(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntRcvrByUserIds(vo);
    }
}
