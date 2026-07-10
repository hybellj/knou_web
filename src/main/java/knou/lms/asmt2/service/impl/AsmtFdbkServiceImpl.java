package knou.lms.asmt2.service.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.asmt2.dao.AsmtFdbkDAO;
import knou.lms.asmt2.service.AsmtFdbkService;
import knou.lms.asmt2.vo.AsmtFdbkVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service("asmtFdbkService")
public class AsmtFdbkServiceImpl extends EgovAbstractServiceImpl implements AsmtFdbkService {
    @Resource(name="asmtFdbkDAO")
    private AsmtFdbkDAO asmtFdbkDAO;
    @Resource(name="attachFileService")
    private AttachFileService attachFileService;
    @Autowired
    private AsmtFdbkService asmtFdbkService;

    /**
     * 과제 피드백 등록
     *
     * @param vo
     * @param fdbkUsersJson
     * @throws Exception
     */
    @Override
    public void asmtFdbkRegist(AsmtFdbkVO vo, String fdbkUsersJson) throws Exception {

        ObjectMapper mapper = new ObjectMapper();
        List<AsmtFdbkVO> fdbkUserList = mapper.readValue(fdbkUsersJson, new TypeReference<List<AsmtFdbkVO>>() {
        });

        for(AsmtFdbkVO item : fdbkUserList) {
            item.setAsmtFdbkId(IdGenUtil.genNewId(IdPrefixType.ASFDK));
            item.setAsmtId(vo.getAsmtId());
            item.setFdbkCts(vo.getFdbkCts());
            item.setRgtrId(vo.getRgtrId());
        }

        asmtFdbkDAO.asmtFdbkBulkRegist(fdbkUserList);

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        for(AsmtFdbkVO fdbkVO : fdbkUserList) {
            // 첨부파일
            if(uploadFileList.size() > 0) {
                for(AtflVO atflVO : uploadFileList) {
                    atflVO.setRefId(fdbkVO.getAsmtFdbkId());
                    atflVO.setRgtrId(vo.getRgtrId());
                    atflVO.setMdfrId(vo.getMdfrId());
                    atflVO.setAtflRepoId(CommConst.REPO_ASMT); // 첨부파일 저장소 아이디
                }

                // 첨부파일 저장
                attachFileService.insertAtflList(uploadFileList);
            }
        }

    }

    /**
     * 과제 피드백 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> asmtFdbkList(AsmtFdbkVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        List<EgovMap> fdbkList = asmtFdbkDAO.asmtFdbkList(vo);

        for(EgovMap fdbk : fdbkList) {
            // 첨부파일
            Number fileCnt = (Number) fdbk.get("fileCnt");
            if(fileCnt != null && fileCnt.intValue() > 0) {
                AtflVO atflVO = new AtflVO();
                atflVO.setRefId((String) fdbk.get("asmtFdbkId"));

                List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
                fdbk.put("fileList", fileList);
            }
        }
        resultVO.setReturnList(fdbkList);
        return resultVO;
    }

    /**
     * 과제 피드백 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void asmtFdbkModify(AsmtFdbkVO vo) throws Exception {
        if(vo.getAsmtFdbkId() == null || "".equals(vo.getAsmtFdbkId())) {
            vo.setAsmtFdbkId(IdGenUtil.genNewId(IdPrefixType.ASFDK));
        }
        // 과제피드백수정
        asmtFdbkDAO.asmtFdbkModify(vo);

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());

        // 첨부파일
        if(uploadFileList.size() > 0) {
            for(AtflVO atflVO : uploadFileList) {
                atflVO.setRefId(vo.getAsmtFdbkId());
                atflVO.setRgtrId(vo.getRgtrId());
                atflVO.setMdfrId(vo.getMdfrId());
                atflVO.setAtflRepoId(CommConst.REPO_ASMT);
            }

            // 첨부파일 저장
            attachFileService.insertAtflList(uploadFileList);
        }

        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(vo.getDelFileIds());

    }

    /**
     * 과제 피드백 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> asmtFdbkSelect(AsmtFdbkVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        EgovMap fdbk = asmtFdbkDAO.asmtFdbkSelect(vo);

        // 첨부파일
        Number fileCnt = (Number) fdbk.get("fileCnt");
        if(fdbk != null && fileCnt != null && fileCnt.intValue() > 0) {
            AtflVO atflVO = new AtflVO();
            atflVO.setRefId((String) fdbk.get("asmtFdbkId"));

            List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
            fdbk.put("fileList", fileList);
        }

        resultVO.setReturnVO(fdbk);

        return resultVO;
    }

    /**
     * 과제 피드백 삭제
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void asmtFdbkDelete(AsmtFdbkVO vo) throws Exception {
        asmtFdbkDAO.asmtFdbkDelete(vo);

    }

    /**
     * 과제 이지그레이더 피드백 등록
     *
     * @param vo
     */
    @Override
    public void asmtEzgFdbkRegist(AsmtFdbkVO vo) {
        List<String> userIdList = new ArrayList<>();

        if(!StringUtil.isNull(vo.getUserIds())) {
            userIdList = Arrays.stream(vo.getUserIds().split(","))
                    .map(String::trim)
                    .filter(s -> !StringUtil.isNull(s))
                    .distinct()
                    .collect(Collectors.toList());
        } else if(!StringUtil.isNull(vo.getUserId())) {
            userIdList.add(vo.getUserId());
        }

        if(userIdList.isEmpty()) {
            return;
        }

        List<AsmtFdbkVO> fdbkList = new ArrayList<>();

        for(String userId : userIdList) {
            AsmtFdbkVO item = new AsmtFdbkVO();

            item.setAsmtFdbkId(IdGenUtil.genNewId(IdPrefixType.ASFDK));
            item.setAsmtId(vo.getAsmtId());
            item.setUserId(userId);
            item.setTeamId(vo.getTeamId());
            item.setFdbkCts(vo.getFdbkCts());
            item.setRgtrId(vo.getRgtrId());
            item.setMdfrId(vo.getMdfrId());

            fdbkList.add(item);
        }

        asmtFdbkDAO.asmtFdbkBulkRegist(fdbkList);
    }
}
