package knou.lms.forum2.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.vo.FileVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.forum2.vo.*;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.DscsDAO;
import knou.lms.forum2.service.DscsService;

@Service("dscsService")
public class DscsServiceImpl extends ServiceBase implements DscsService {

    @Resource(name = "dscsDAO")
    private DscsDAO dscsDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Override
    public List<DscsVO> selectDscsDvclasList(DscsVO vo) throws Exception {
        return dscsDAO.selectDscsDvclasList(vo);
    }

    /**
     * 토론목록조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsListVO> selectDscsList(DscsListVO vo) throws Exception {
        ProcessResultVO<DscsListVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<DscsListVO> list = dscsDAO.selectDscsList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 토론단건상세조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public DscsVO selectDscs(DscsVO vo) throws Exception {
        DscsVO resultVo = dscsDAO.selectDscs(vo);
        // 부토론 존재여부 체크
        if (resultVo.getByteamDscsUseyn().equalsIgnoreCase("Y")) {
            List<DscsTeamDscsVO> teamList = dscsDAO.selectTeamDscsList(vo.getDscsId());
            for (DscsTeamDscsVO teamDscs : teamList) {
                AtflVO teamAtflParam = new AtflVO();
                teamAtflParam.setAtflRepoId(CommConst.REPO_DSCS);
                teamAtflParam.setRefId(teamDscs.getDscsId());
                teamDscs.setFileList(attachFileService.selectAtflListByRefId(teamAtflParam));
            }
            resultVo.setTeamDscsList(teamList);
        }
        // 첨부파일 목록 조회
        AtflVO atflParam = new AtflVO();
        atflParam.setAtflRepoId(CommConst.REPO_DSCS);
        atflParam.setRefId(resultVo.getDscsId());
        resultVo.setFileList(attachFileService.selectAtflListByRefId(atflParam));
        return resultVo;
    }

    /**
     * 토론성적공개여부 수정
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsVO> modifyDscsMrkOyn(DscsVO vo) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        int affected = dscsDAO.updateDscsMrkOyn(vo);
        if (affected > 0) {
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess();
        } else {
            resultVO.setResultFailed("update target not found");
        }

        return resultVO;
    }

    /**
     * 토론성적반영비율 수정
     * @param list
     * @throws Exception
     */
    @Override
    public void updateDscsMrkRfltrt(List<DscsVO> list) throws Exception {
        dscsDAO.updateDscsMrkRfltrt(list);
    }

    /**
     * 토론등록/수정
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsVO> saveDscs(DscsVO vo) throws Exception {
        if (StringUtil.isNull(vo.getOknokStngyn())) {
            vo.setOknokStngyn("N");
        }
        boolean isTeamDiscussion = "TEAM".equalsIgnoreCase(vo.getDscsUnitTycd()) || "Y".equalsIgnoreCase(vo.getDscsUnitTycd());
        vo.setDscsUnitTycd(isTeamDiscussion ? "TEAM" : "GNRL");

        if (StringUtil.isNull(vo.getDscsId())) {
            return doInsertDscs(vo, isTeamDiscussion);
        } else {
            return doUpdateDscs(vo, isTeamDiscussion);
        }
    }

    /**
     * 토론 등록 (신규)
     */
    private ProcessResultVO<DscsVO> doInsertDscs(DscsVO vo, boolean isTeamDiscussion) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        List<DscsDvclasSelVO> dvclasSelList = vo.getDvclasSelList();
        if (dvclasSelList == null || dvclasSelList.isEmpty()) {
            resultVO.setResultFailed("등록 시 분반 정보가 필요합니다.");
            return resultVO;
        }

        Map<String, String> lrnGrpMapByDvclasNo = new HashMap<>();
        Map<String, String> lrnGrpNmMapByDvclasNo = new HashMap<>();
        Map<String, String> byteamDscsUseynMapByDvclasNo = new HashMap<>();
        List<DscsLrnGrpVO> lrnGrpInfoList = vo.getLrnGrpInfoList();
        if (lrnGrpInfoList != null) {
            for (DscsLrnGrpVO info : lrnGrpInfoList) {
                if (info == null) {
                    continue;
                }
                if (!StringUtil.isNull(info.getDvclasNo()) && !StringUtil.isNull(info.getLrnGrpId())) {
                    lrnGrpMapByDvclasNo.put(info.getDvclasNo(), info.getLrnGrpId());
                }
                if (!StringUtil.isNull(info.getDvclasNo()) && !StringUtil.isNull(info.getLrnGrpnm())) {
                    lrnGrpNmMapByDvclasNo.put(info.getDvclasNo(), info.getLrnGrpnm());
                }
                if (!StringUtil.isNull(info.getDvclasNo())) {
                    byteamDscsUseynMapByDvclasNo.put(info.getDvclasNo(),
                            StringUtil.isNull(info.getByteamDscsUseyn()) ? "N" : info.getByteamDscsUseyn());
                }
            }
        }

        if (isTeamDiscussion && lrnGrpMapByDvclasNo.isEmpty()) {
            resultVO.setResultFailed("팀토론 등록 시 분반별 학습그룹 정보가 필요합니다.");
            return resultVO;
        }

        String firstDscsId = null;
        for (DscsDvclasSelVO dvclasSelVO : dvclasSelList) {
            // 분반별 과목개설ID 를 등록한다.
            vo.setSbjctId(dvclasSelVO.getSbjctId());
            if (dvclasSelVO == null) {
                continue;
            }
            if (!"Y".equalsIgnoreCase(dvclasSelVO.getCheckedYn())) {
                continue;
            }

            String dvclasNo = dvclasSelVO.getDvclasNo();
            String dvclsNo = dvclasNo;
            if (StringUtil.isNull(dvclsNo)) {
                resultVO.setResultFailed("등록 시 분반 정보가 필요합니다.");
                return resultVO;
            }

            if (isTeamDiscussion) {
                String lrnGrpId = lrnGrpMapByDvclasNo.get(dvclasNo);
                String lrnGrpnm = lrnGrpNmMapByDvclasNo.get(dvclasNo);
                if (StringUtil.isNull(lrnGrpId) || StringUtil.isNull(lrnGrpnm)) {
                    resultVO.setResultFailed("팀토론 등록 시 분반별 학습그룹 정보가 필요합니다.");
                    return resultVO;
                }
                String dscsGrpId = IdGenerator.getNewId(IdPrefixType.DSGRP.getCode());
                vo.setDscsGrpId(dscsGrpId);
                vo.setLrnGrpId(lrnGrpId);
                vo.setDscsGrpnm(lrnGrpnm);
                dscsDAO.insertDscsGrp(vo);
            } else {
                vo.setDscsGrpId(null);
                vo.setLrnGrpId(null);
                vo.setDscsGrpnm(null);
            }

            String byteamDscsUseyn = byteamDscsUseynMapByDvclasNo.getOrDefault(dvclasNo, "N");
            String origDscsTtl = vo.getDscsTtl();
            String origDscsCts = vo.getDscsCts();
            String newDscsId = IdGenerator.getNewId(IdPrefixType.DSCS.getCode());
            vo.setDscsId(newDscsId);
            vo.setDvclsNo(dvclsNo);
            vo.setByteamDscsUseyn(byteamDscsUseyn);
            vo.setUpDscsId(null);
            vo.setTeamId(null);
            dscsDAO.insertDscs(vo); // 부모(또는 단일) 토론 INSERT

            // 팀별 부주제 설정 시: 팀수만큼 자식 토론 생성
            if ("Y".equalsIgnoreCase(byteamDscsUseyn)) {
                List<DscsTeamDscsVO> teamForumDtlList = vo.getTeamForumDtlList();
                if (teamForumDtlList != null) {
                    for (DscsTeamDscsVO teamDtl : teamForumDtlList) {
                        if (teamDtl == null || !dvclasNo.equals(teamDtl.getDvclasNo())) {
                            continue;
                        }
                        String childDscsId = IdGenerator.getNewId(IdPrefixType.DSCS.getCode());
                        vo.setDscsId(childDscsId);
                        vo.setUpDscsId(newDscsId);
                        vo.setTeamId(teamDtl.getTeamId());
                        vo.setDscsTtl(teamDtl.getDscsTtl());
                        vo.setDscsCts(teamDtl.getDscsCts());
                        vo.setByteamDscsUseyn("N");
                        dscsDAO.insertDscs(vo);

                        // 팀별 첨부파일 저장 (refId = 자식 토론 ID)
                        if (!StringUtil.isNull(teamDtl.getTeamUploadFiles())) {
                            List<AtflVO> teamFiles = FileUtil.getUploadAtflList(
                                    teamDtl.getTeamUploadFiles(), teamDtl.getTeamUploadPath());
                            for (AtflVO atflVO : teamFiles) {
                                atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                                atflVO.setRefId(childDscsId);
                                atflVO.setRgtrId(vo.getRgtrId());
                                atflVO.setMdfrId(vo.getMdfrId());
                                atflVO.setAtflRepoId(CommConst.REPO_DSCS);
                            }
                            if (!teamFiles.isEmpty()) {
                                attachFileService.insertAtflList(teamFiles);
                            }
                        }
                    }
                }
                // 다음 분반 루프를 위해 원복
                vo.setUpDscsId(null);
                vo.setTeamId(null);
                vo.setDscsTtl(origDscsTtl);
                vo.setDscsCts(origDscsCts);
                vo.setByteamDscsUseyn(byteamDscsUseyn);
            }

            if (firstDscsId == null) {
                // 입력된 분반 선택 순서 기준으로 첫 번째 DSCS를 대표 dscsId로 사용
                firstDscsId = newDscsId;
            }
        }

        if (StringUtil.isNull(firstDscsId)) {
            resultVO.setResultFailed("팀토론 등록 시 유효한 분반 정보가 없습니다.");
            return resultVO;
        }
        vo.setDscsId(firstDscsId);

        // 첨부파일 저장 (대표 dscsId 기준)
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        for (AtflVO atflVO : uploadFileList) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(firstDscsId);
            atflVO.setRgtrId(vo.getRgtrId());
            atflVO.setMdfrId(vo.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_DSCS);
        }
        if (!uploadFileList.isEmpty()) {
            attachFileService.insertAtflList(uploadFileList);
        }

        resultVO.setResultSuccess();
        return resultVO;
    }

    /**
     * 토론 수정
     */
    private ProcessResultVO<DscsVO> doUpdateDscs(DscsVO vo, boolean isTeamDiscussion) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        // 현재 DB 상태 조회 (변경 전 유형 판별용)
        DscsVO currentParam = new DscsVO();
        currentParam.setDscsId(vo.getDscsId());
        DscsVO currentVO = dscsDAO.selectDscs(currentParam);
        boolean wasTeam   = "TEAM".equalsIgnoreCase(currentVO.getDscsUnitTycd());
        boolean wasByteam = "Y".equalsIgnoreCase(currentVO.getByteamDscsUseyn());

        // byteamDscsUseyn 은 lrnGrpInfoList 를 통해 전달됨 (direct form field 없음)
        String newByteam = "N";
        List<DscsLrnGrpVO> lrnGrpInfoForByteam = vo.getLrnGrpInfoList();
        if (lrnGrpInfoForByteam != null && !lrnGrpInfoForByteam.isEmpty()) {
            DscsLrnGrpVO firstGrp = lrnGrpInfoForByteam.get(0);
            if (firstGrp != null && "Y".equalsIgnoreCase(firstGrp.getByteamDscsUseyn())) {
                newByteam = "Y";
            }
        } else if (!StringUtil.isNull(vo.getByteamDscsUseyn())) {
            newByteam = "Y".equalsIgnoreCase(vo.getByteamDscsUseyn()) ? "Y" : "N";
        }
        vo.setByteamDscsUseyn(newByteam); // updateForum() 에서 BYTEAM_DSCS_USEYN 업데이트용

        // 2-2: TEAM → GNRL 전환 시 자식 논리 삭제
        if (wasTeam && !isTeamDiscussion) {
            dscsDAO.updateChildDscsDelYn(vo);
        }
        // 2-1: TEAM 유지, byteamDscsUseyn Y → N 시 자식 논리 삭제
        else if (wasTeam && isTeamDiscussion && wasByteam && "N".equals(newByteam)) {
            dscsDAO.updateChildDscsDelYn(vo);
        }

        // 2-4: TEAM 유지 + byteamDscsUseyn Y → Y 시 자식 토론 제목/내용 UPDATE
        if (wasTeam && isTeamDiscussion && "Y".equals(newByteam)) {
            List<DscsTeamDscsVO> teamForumDtlList = vo.getTeamForumDtlList();
            if (teamForumDtlList != null) {
                for (DscsTeamDscsVO teamDtl : teamForumDtlList) {
                    if (teamDtl == null || StringUtil.isNull(teamDtl.getTeamId())) continue;
                    teamDtl.setUpDscsId(vo.getDscsId());
                    teamDtl.setMdfrId(vo.getMdfrId());
                    teamDtl.setRgtrId(vo.getRgtrId());
                    dscsDAO.updateChildDscsDtls(teamDtl);
                    // 팀별 첨부파일 저장 (refId = JS에서 전달된 자식 토론 ID)
                    if (!StringUtil.isNull(teamDtl.getTeamUploadFiles()) && !StringUtil.isNull(teamDtl.getDscsId())) {
                        List<AtflVO> teamFiles = FileUtil.getUploadAtflList(
                                teamDtl.getTeamUploadFiles(), teamDtl.getTeamUploadPath());
                        for (AtflVO atflVO : teamFiles) {
                            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                            atflVO.setRefId(teamDtl.getDscsId());
                            atflVO.setRgtrId(vo.getRgtrId());
                            atflVO.setMdfrId(vo.getMdfrId());
                            atflVO.setAtflRepoId(CommConst.REPO_DSCS);
                        }
                        if (!teamFiles.isEmpty()) {
                            attachFileService.insertAtflList(teamFiles);
                        }
                    }
                }
            }
        }

        // 2-3: GNRL → TEAM 전환 시 팀그룹 생성 + 자식 토론 생성
        if (!wasTeam && isTeamDiscussion) {
            // 수정 모드 기존 분반/과목 유지
            vo.setDvclsNo(currentVO.getDvclsNo());
            vo.setSbjctId(currentVO.getSbjctId());

            // lrnGrpInfoList[0] 에서 현재 분반의 학습그룹 정보 취득
            List<DscsLrnGrpVO> lrnGrpInfoList = vo.getLrnGrpInfoList();
            if (lrnGrpInfoList != null && !lrnGrpInfoList.isEmpty()) {
                DscsLrnGrpVO grpInfo = lrnGrpInfoList.get(0);
                String lrnGrpId = grpInfo.getLrnGrpId();
                String lrnGrpnm = grpInfo.getLrnGrpnm();
                if (!StringUtil.isNull(lrnGrpId)) {
                    String dscsGrpId = IdGenerator.getNewId(IdPrefixType.DSGRP.getCode());
                    vo.setDscsGrpId(dscsGrpId);
                    vo.setLrnGrpId(lrnGrpId);
                    vo.setDscsGrpnm(lrnGrpnm);
                    dscsDAO.insertDscsGrp(vo);
                }
            }

            // byteamDscsUseyn='Y' 이면 팀별 자식 토론 생성
            if ("Y".equals(newByteam)) {
                List<DscsTeamDscsVO> teamForumDtlList = vo.getTeamForumDtlList();
                if (teamForumDtlList != null) {
                    String parentDscsId = vo.getDscsId();
                    String origDscsTtl  = vo.getDscsTtl();
                    String origDscsCts  = vo.getDscsCts();
                    for (DscsTeamDscsVO teamDtl : teamForumDtlList) {
                        if (teamDtl == null) continue;
                        vo.setDscsId(IdGenerator.getNewId(IdPrefixType.DSCS.getCode()));
                        vo.setUpDscsId(parentDscsId);
                        vo.setTeamId(teamDtl.getTeamId());
                        vo.setDscsTtl(teamDtl.getDscsTtl());
                        vo.setDscsCts(teamDtl.getDscsCts());
                        vo.setByteamDscsUseyn("N");
                        dscsDAO.insertDscs(vo);
                        // 팀별 첨부파일 저장 (refId = 신규 자식 토론 ID)
                        String childDscsId = vo.getDscsId();
                        if (!StringUtil.isNull(teamDtl.getTeamUploadFiles())) {
                            List<AtflVO> teamFiles = FileUtil.getUploadAtflList(
                                    teamDtl.getTeamUploadFiles(), teamDtl.getTeamUploadPath());
                            for (AtflVO atflVO : teamFiles) {
                                atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                                atflVO.setRefId(childDscsId);
                                atflVO.setRgtrId(vo.getRgtrId());
                                atflVO.setMdfrId(vo.getMdfrId());
                                atflVO.setAtflRepoId(CommConst.REPO_DSCS);
                            }
                            if (!teamFiles.isEmpty()) {
                                attachFileService.insertAtflList(teamFiles);
                            }
                        }
                    }
                    // 원복
                    vo.setDscsId(parentDscsId);
                    vo.setUpDscsId(null);
                    vo.setTeamId(null);
                    vo.setDscsTtl(origDscsTtl);
                    vo.setDscsCts(origDscsCts);
                    vo.setByteamDscsUseyn(newByteam);
                }
            }
        } else {
            vo.setDvclsNo(null); // GNRL→TEAM 전환 외 수정 시 분반 변경 금지
        }

        dscsDAO.updateDscs(vo);

        // 첨부파일 저장
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        for (AtflVO atflVO : uploadFileList) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(vo.getDscsId());
            atflVO.setRgtrId(vo.getRgtrId());
            atflVO.setMdfrId(vo.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_DSCS);
        }
        if (!uploadFileList.isEmpty()) {
            attachFileService.insertAtflList(uploadFileList);
        }
        // 첨부파일 삭제
        String[] delFileIds = vo.getDelFileIds();
        if (delFileIds != null && delFileIds.length > 0 && !StringUtil.isNull(delFileIds[0])) {
            attachFileService.deleteAtflByAtflIds(delFileIds);
        }

        resultVO.setResultSuccess();
        return resultVO;
    }

    // 내 강의에 등록된 토론 목록 조회
    @Override
    public ProcessResultVO<DscsVO> selectProfSbjctDscsList(DscsVO vo) throws Exception {

        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<DscsVO> forumList = dscsDAO.selectProfSbjctDscsList(vo);

        if(forumList.size() > 0) {
            paginationInfo.setTotalRecordCount(forumList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(forumList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 토론삭제
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsVO> deleteDscs(DscsVO vo) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        int affected = dscsDAO.deleteDscs(vo);
        if (affected > 0) {
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess();
        } else {
            resultVO.setResultFailed("delete target not found");
        }

        return resultVO;
    }

    /**
     * 팀토론토론방OPEN여부 수정
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsTeamDscsVO> modifyTeamDscsOyn(DscsTeamDscsVO vo) throws Exception {
        ProcessResultVO<DscsTeamDscsVO> resultVO = new ProcessResultVO<>();

        int affected = dscsDAO.updateTeamDscsOyn(vo);
        if (affected > 0) {
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess();
        } else {
            resultVO.setResultFailed("update target not found");
        }

        return resultVO;
    }

    /**
     * 학습그룹 팀 목록 조회 (팀 토론 부주제 설정용)
     */
    @Override
    public ProcessResultVO<DscsTeamDscsVO> selectDscsLrnGrpTeamList(DscsTeamDscsVO vo) throws Exception {
        ProcessResultVO<DscsTeamDscsVO> resultVO = new ProcessResultVO<>();
        List<DscsTeamDscsVO> list = dscsDAO.selectDscsLrnGrpTeamList(vo);
        resultVO.setReturnList(list);
        return resultVO;
    }

    /**
     * 토론복사
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsVO> copyDscs(DscsVO vo) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        String newDscsId = IdGenerator.getNewId(IdPrefixType.DSCS.getCode());
        vo.setDscsId(newDscsId);

        /*TODO : 26.3.26
        파라미터매핑프로젝트표준확정필요
        */
        dscsDAO.copyDscs(vo);

        DscsVO detailParam = new DscsVO();
        detailParam.setDscsId(newDscsId);
        DscsVO detailVO = dscsDAO.selectDscs(detailParam);

        // TODO : 26.3.26 파일정보 복사(물리 파일 처리 확인 필요)
        /*
        FileVO copyFileVO;
        copyFileVO = new FileVO();
        copyFileVO.setOrgId(orgId);
        copyFileVO.setRepoCd("FORUM");
        copyFileVO.setFileBindDataSn(forumCd);
        copyFileVO.setCopyFileBindDataSn(copyForumCd);
        copyFileVO.setRgtrId(rgtrId);

        sysFileService.copyFileInfoFromOrigin(copyFileVO);
        */

        resultVO.setReturnVO(detailVO);
        resultVO.setResultSuccess();

        return resultVO;
    }

    // 성적반영비율 초기화
    @Override
    public void setScoreRatio(DscsVO vo) throws Exception {
        List<DscsVO> scoreAplyList = dscsDAO.getScoreRatio(vo);

        if( scoreAplyList != null && !scoreAplyList.isEmpty() && scoreAplyList.size() > 0) {
            int scoreAplyCnt = scoreAplyList.size();
            int share = 100 / scoreAplyCnt;
            int rest = 100 % scoreAplyCnt;
            int cnt = 0;
            Integer scoreRatio = 0;
            for(DscsVO forumVO : scoreAplyList) {
                if(cnt == 0) {
                    scoreRatio = share + rest;
                } else {
                    scoreRatio = share;
                }
                vo.setMrkRfltrt(scoreRatio);
                vo.setDscsId(forumVO.getDscsId());
                dscsDAO.setScoreRatio(vo);
                cnt++;
            }
        }
    }

    // 성적분포현황 BarChart
    @Override
    public EgovMap viewScoreChart(DscsVO vo) throws Exception {
        EgovMap scoreMap = dscsDAO.selectScoreChart(vo);
        return scoreMap;
    }

    // 교수 학기기수 목록 조회 (토론 복사 팝업용)
    @Override
    public List<EgovMap> selectProfSmstrChrtList(DscsVO vo) throws Exception {
        return dscsDAO.selectProfSmstrChrtList(vo);
    }

    // 학기기수별 과목 목록 조회 (토론 복사 팝업용)
    @Override
    public List<EgovMap> selectProfSmstrChrtSbjctList(DscsVO vo) throws Exception {
        return dscsDAO.selectProfSmstrChrtSbjctList(vo);
    }
}
