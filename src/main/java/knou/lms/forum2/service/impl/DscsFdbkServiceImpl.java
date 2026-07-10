package knou.lms.forum2.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.forum2.dao.DscsFdbkDAO;
import knou.lms.forum2.service.DscsFdbkService;
import knou.lms.forum2.vo.DscsFdbkVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Service("dscsFdbkService")
public class DscsFdbkServiceImpl extends ServiceBase implements DscsFdbkService {

    @Resource(name="dscsFdbkDAO")
    private DscsFdbkDAO dscsFdbkDAO;

    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

    // 피드백 등록
    @Override
    public ProcessResultVO<DscsFdbkVO> insertFdbk(DscsFdbkVO vo) {
        ProcessResultVO<DscsFdbkVO> resultVO = new ProcessResultVO<DscsFdbkVO>();

        setFdbkAudit(vo);
        List<String> targetStdIds = getTargetStdIds(vo);

        if(!targetStdIds.isEmpty()) {
            for(String stdId : targetStdIds) {
                vo.setStdId(stdId);
                vo.setDscsFdbkId(IdGenerator.getNewId(IdPrefixType.DSFDK.getCode()));

                // 토론 피드백(tb_lms_forum_fdbk) 테이블 데이터 등록
                dscsFdbkDAO.insertFdbk(vo);

                // 파일 저장
                List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
                for (AtflVO atflVO : uploadFileList) {
                    atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                    atflVO.setRefId(vo.getDscsFdbkId());
                    atflVO.setRgtrId(vo.getUserId());
                    atflVO.setMdfrId(vo.getUserId());
                    atflVO.setAtflRepoId(CommConst.REPO_DSCS);
                }
                if (!uploadFileList.isEmpty()) {
                    attachFileService.insertAtflList(uploadFileList);
                }
            }
        }
        resultVO.setResult(1);

        return resultVO;
    }

    // 피드백 등록 대상자 목록 조회. stdIds 우선, 기존 stdId 파라미터는 호환용으로 사용한다.
    private List<String> getTargetStdIds(DscsFdbkVO vo) {
        Set<String> targetStdIds = new LinkedHashSet<String>();
        if (vo.getStdIdList() != null) {
            for (String stdId : vo.getStdIdList()) {
                addTargetStdId(targetStdIds, stdId);
            }
        }

        if (targetStdIds.isEmpty()) {
            addTargetStdIds(targetStdIds, vo.getStdIds());
        }

        if (targetStdIds.isEmpty()) {
            addTargetStdIds(targetStdIds, vo.getStdId());
        }

        return new ArrayList<String>(targetStdIds);
    }

    // 피드백 등록/수정 기준 작업자 번호를 공통으로 정리한다.
    private void setFdbkAudit(DscsFdbkVO vo) {
        String userId = vo.getUserId();
        if ((vo.getRgtrId() == null || "".equals(vo.getRgtrId())) && userId != null && !"".equals(userId)) {
            vo.setRgtrId(userId);
        }
        if ((vo.getMdfrId() == null || "".equals(vo.getMdfrId())) && userId != null && !"".equals(userId)) {
            vo.setMdfrId(userId);
        }
    }

    // 콤마로 전달된 피드백 대상 학습자 ID를 분리한다.
    private void addTargetStdIds(Set<String> targetStdIds, String stdIds) {
        if (stdIds == null || "".equals(stdIds.trim())) {
            return;
        }

        String[] stdArr = stdIds.split(",");
        for (String stdId : stdArr) {
            addTargetStdId(targetStdIds, stdId);
        }
    }

    // 단일 피드백 대상 학습자 ID를 중복 없이 추가한다.
    private void addTargetStdId(Set<String> targetStdIds, String stdId) {
        if (stdId == null || "".equals(stdId.trim())) {
            return;
        }
        targetStdIds.add(stdId.trim());
    }

    // 피드백 조회
    @Override
    public List<DscsFdbkVO> selectFdbk(DscsFdbkVO vo) {
        List<DscsFdbkVO> dscsFdbkList = dscsFdbkDAO.selectFdbk(vo);

        if(dscsFdbkList != null) {
            for(DscsFdbkVO vo1 : dscsFdbkList) {
                AtflVO atflParam = new AtflVO();
                atflParam.setAtflRepoId(CommConst.REPO_DSCS);
                atflParam.setRefId(vo1.getDscsFdbkId());
                List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflParam);
                vo1.setFileList(fileList);
            }
        }

        return dscsFdbkList;
    }

    // 피드백 수정
    @Override
    public ProcessResultVO<DscsFdbkVO> updateFdbk(DscsFdbkVO vo) {
        ProcessResultVO<DscsFdbkVO> resultVO = new ProcessResultVO<DscsFdbkVO>();

        setFdbkAudit(vo);
        dscsFdbkDAO.updateFdbk(vo);

        // 파일 저장
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        for (AtflVO atflVO : uploadFileList) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(vo.getDscsFdbkId());
            atflVO.setRgtrId(vo.getUserId());
            atflVO.setMdfrId(vo.getUserId());
            atflVO.setAtflRepoId(CommConst.REPO_DSCS);
        }
        if (!uploadFileList.isEmpty()) {
            attachFileService.insertAtflList(uploadFileList);
        }

        resultVO.setResult(1);

        return resultVO;
    }

    // 피드백 삭제
    @Override
    public ProcessResultVO<DscsFdbkVO> deleteFdbk(DscsFdbkVO vo) {
        ProcessResultVO<DscsFdbkVO> resultVO = new ProcessResultVO<DscsFdbkVO>();

        setFdbkAudit(vo);
        vo.setDelYn("Y");
        dscsFdbkDAO.updateFdbk(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    // 피드백 개수 조회
    @Override
    public int cntFdbk(DscsFdbkVO vo) {
        return dscsFdbkDAO.cntFdbk(vo);
    }

}
