package knou.lms.forum2.service.impl;

import java.util.HashMap;
import java.util.LinkedHashMap;
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
import knou.lms.forum2.policy.DscsPeriodPolicy;
import knou.lms.forum2.vo.*;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
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
    private static final String TEAM_CHILD_PLACEHOLDER = "-";

    @Resource(name = "dscsDAO")
    private DscsDAO dscsDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /**
     * 토론 분반 목록을 조회한다.
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<DscsVO> selectDscsDvclasList(DscsVO vo) {
        return dscsDAO.selectDscsDvclasList(vo);
    }

    /**
     * 학습자 토론 목록 조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsListVO> selectStdntDscsList(DscsListVO vo) throws Exception {
        ProcessResultVO<DscsListVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<DscsListVO> list = dscsDAO.selectStdntDscsList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 교수자 토론 목록 조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsListVO> selectProfDscsList(DscsListVO vo) throws Exception {
        ProcessResultVO<DscsListVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<DscsListVO> list = dscsDAO.selectProfDscsList(vo);
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
    public DscsVO selectDscs(DscsVO vo) {
        DscsVO resultVo = dscsDAO.selectDscs(vo);
        if ("TEAM".equalsIgnoreCase(resultVo.getDscsUnitTycd()) && StringUtil.isNotNull(resultVo.getTeamGrpId())) {
            String byteamDscsUseyn = normalizeYn(resultVo.getByteamDscsUseyn());
            List<DscsTeamDscsVO> teamList = dscsDAO.selectTeamDscsList(resultVo.getDscsId());
            if (teamList == null || teamList.isEmpty()) {
                DscsTeamDscsVO teamParam = new DscsTeamDscsVO();
                teamParam.setUpDscsId(resultVo.getDscsId());
                teamParam.setTeamGrpId(resultVo.getTeamGrpId());
                teamParam.setByteamDscsUseyn(byteamDscsUseyn);
                teamList = dscsDAO.selectDscsTeamGrpTeamList(teamParam);
            }
            for (DscsTeamDscsVO teamDscs : teamList) {
                teamDscs.setByteamDscsUseyn(byteamDscsUseyn);
                if ("Y".equalsIgnoreCase(byteamDscsUseyn) && StringUtil.isNotNull(teamDscs.getDscsId())) {
                    AtflVO teamAtflParam = new AtflVO();
                    teamAtflParam.setAtflRepoId(CommConst.REPO_DSCS);
                    teamAtflParam.setRefId(teamDscs.getDscsId());
                    teamDscs.setFileList(attachFileService.selectAtflListByRefId(teamAtflParam));
                }
            }
            normalizeTeamChildDisplay(teamList, byteamDscsUseyn);
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
     * 팀토론 상세 입력 목록을 팀 ID 기준 맵으로 변환한다.
     * @param teamDscsDtlList
     * @param dvclasNo
     * @return
     */
    private Map<String, DscsTeamDscsVO> buildTeamDtlMap(List<DscsTeamDscsVO> teamDscsDtlList, String dvclasNo) {
        Map<String, DscsTeamDscsVO> detailMap = new LinkedHashMap<>();
        if (teamDscsDtlList == null) {
            return detailMap;
        }
        for (DscsTeamDscsVO teamDtl : teamDscsDtlList) {
            if (teamDtl == null || StringUtil.isNull(teamDtl.getTeamId())) {
                continue;
            }
            if (StringUtil.isNotNull(dvclasNo) && !dvclasNo.equals(teamDtl.getDvclasNo())) {
                continue;
            }
            detailMap.put(teamDtl.getTeamId(), teamDtl);
        }
        return detailMap;
    }

    /**
     * 부모 토론과 팀그룹 기준으로 생성 대상 팀 목록을 조회한다.
     * @param parentDscsId
     * @param teamGrpId
     * @return
     */
    private List<DscsTeamDscsVO> loadExpectedTeams(String parentDscsId, String teamGrpId) {
        DscsTeamDscsVO teamParam = new DscsTeamDscsVO();
        teamParam.setUpDscsId(parentDscsId);
        teamParam.setTeamGrpId(teamGrpId);
        return dscsDAO.selectDscsTeamGrpTeamList(teamParam);
    }

    /**
     * 지정한 팀 자식토론의 첨부파일을 삭제한다.
     * @param dscsId
     * @throws Exception
     */
    private void removeTeamChildAttachments(String dscsId) throws Exception {
        if (StringUtil.isNull(dscsId)) {
            return;
        }
        AtflVO atflParam = new AtflVO();
        atflParam.setAtflRepoId(CommConst.REPO_DSCS);
        atflParam.setRefId(dscsId);
        List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflParam);
        if (fileList == null || fileList.isEmpty()) {
            return;
        }
        String[] atflIds = new String[fileList.size()];
        for (int i = 0; i < fileList.size(); i++) {
            atflIds[i] = fileList.get(i).getAtflId();
        }
        attachFileService.deleteAtflByAtflIds(atflIds);
    }

    /**
     * 팀 자식토론 목록의 첨부파일을 일괄 삭제한다.
     * @param childList
     * @throws Exception
     */
    private void removeTeamChildAttachments(List<DscsTeamDscsVO> childList) throws Exception {
        if (childList == null) {
            return;
        }
        for (DscsTeamDscsVO child : childList) {
            if (child == null || StringUtil.isNull(child.getDscsId())) {
                continue;
            }
            removeTeamChildAttachments(child.getDscsId());
        }
    }

    /**
     * Y/N 값을 정규화한다.
     * @param value
     * @return
     */
    private String normalizeYn(String value) {
        return "Y".equalsIgnoreCase(StringUtil.nvl(value)) ? "Y" : "N";
    }

    /**
     * 팀별 부주제 미사용 시 화면 표시용 제목과 내용을 초기화한다.
     * 팀별 부주제 사용 여부는 부모 토론의 BYTEAM_DSCS_USEYN 값만 기준으로 한다.
     * @param teamList 팀 자식토론 목록
     * @param byteamDscsUseyn 부모 토론의 팀별 부주제 사용 여부
     */
    private void normalizeTeamChildDisplay(List<DscsTeamDscsVO> teamList, String byteamDscsUseyn) {
        if (teamList == null) {
            return;
        }
        boolean useTeamSubject = "Y".equalsIgnoreCase(byteamDscsUseyn);
        for (DscsTeamDscsVO item : teamList) {
            if (item == null) {
                continue;
            }
            item.setByteamDscsUseyn(useTeamSubject ? "Y" : "N");
            if (useTeamSubject) {
                continue;
            }
            item.setDscsTtl("");
            item.setDscsCts("");
        }
    }

    /**
     * 요청값과 현재 토론 정보를 기준으로 적용할 팀그룹 정보를 찾는다.
     * @param vo
     * @param currentVO
     * @return
     */
    private DscsTeamGrpVO findMatchedTeamGrpInfo(DscsVO vo, DscsVO currentVO) {
        List<DscsTeamGrpVO> teamGrpInfoList = vo.getTeamGrpInfoList();
        if (teamGrpInfoList == null || teamGrpInfoList.isEmpty()) {
            return null;
        }

        String targetDvclasNo = StringUtil.isNotNull(vo.getDvclasNo()) ? vo.getDvclasNo() : currentVO.getDvclasNo();
        if (StringUtil.isNotNull(targetDvclasNo)) {
            for (DscsTeamGrpVO info : teamGrpInfoList) {
                if (info != null && targetDvclasNo.equals(info.getDvclasNo())) {
                    return info;
                }
            }
        }

        String targetTeamGrpId = StringUtil.isNotNull(vo.getTeamGrpId()) ? vo.getTeamGrpId() : currentVO.getTeamGrpId();
        if (StringUtil.isNotNull(targetTeamGrpId)) {
            for (DscsTeamGrpVO info : teamGrpInfoList) {
                if (info != null && targetTeamGrpId.equals(info.getTeamGrpId())) {
                    return info;
                }
            }
        }

        return teamGrpInfoList.get(0);
    }

    /**
     * 요청값과 현재 토론 정보를 기준으로 팀별 토론 사용 여부를 결정한다.
     * @param vo
     * @param currentVO
     * @return
     */
    private String resolveByteamDscsUseyn(DscsVO vo, DscsVO currentVO) {
        DscsTeamGrpVO matchedInfo = findMatchedTeamGrpInfo(vo, currentVO);
        if (matchedInfo != null && StringUtil.isNotNull(matchedInfo.getByteamDscsUseyn())) {
            return "Y".equalsIgnoreCase(matchedInfo.getByteamDscsUseyn()) ? "Y" : "N";
        }
        return "N";
    }

    /**
     * 부모 토론에 연결된 팀 자식토론과 첨부파일을 삭제한다.
     * @param vo
     * @param parentDscsId
     * @throws Exception
     */
    private void deleteTeamChildDscs(DscsVO vo, String parentDscsId) throws Exception {
        if (StringUtil.isNull(parentDscsId)) {
            return;
        }
        List<DscsTeamDscsVO> existingChildren = dscsDAO.selectTeamDscsList(parentDscsId);
        removeTeamChildAttachments(existingChildren);
        DscsVO deleteVO = new DscsVO();
        deleteVO.setDscsId(parentDscsId);
        deleteVO.setRgtrId(vo.getRgtrId());
        deleteVO.setMdfrId(vo.getMdfrId());
        dscsDAO.deleteChildDscs(deleteVO);
    }

    /**
     * 팀 정보 기준으로 자식토론을 신규 생성한다.
     * @param vo
     * @param parentDscsId
     * @param teamRow
     * @param teamDtl
     * @param byteamDscsUseyn
     * @throws Exception
     */
    private void insertTeamChildDscs(DscsVO vo, String parentDscsId, DscsTeamDscsVO teamRow, DscsTeamDscsVO teamDtl, String byteamDscsUseyn) {
        String childDscsId = IdGenerator.getNewId(IdPrefixType.DSCS.getCode());
        vo.setDscsId(childDscsId);
        vo.setUpDscsId(parentDscsId);
        vo.setTeamId(teamRow.getTeamId());
        vo.setByteamDscsUseyn("N");
        if ("Y".equalsIgnoreCase(byteamDscsUseyn) && teamDtl != null) {
            vo.setDscsTtl(StringUtil.nvl(teamDtl.getDscsTtl()));
            vo.setDscsCts(StringUtil.nvl(teamDtl.getDscsCts()));
        } else {
            vo.setDscsTtl(TEAM_CHILD_PLACEHOLDER);
            vo.setDscsCts(TEAM_CHILD_PLACEHOLDER);
        }
        dscsDAO.insertDscs(vo);

        if ("Y".equalsIgnoreCase(byteamDscsUseyn) && teamDtl != null && StringUtil.isNotNull(teamDtl.getTeamUploadFiles())) {
            List<AtflVO> teamFiles = FileUtil.getUploadAtflList(teamDtl.getTeamUploadFiles(), teamDtl.getTeamUploadPath());
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

    /**
     * 팀토론의 자식토론을 현재 팀 구성과 입력값에 맞게 생성 또는 수정한다.
     * @param vo
     * @param currentVO
     * @param parentDscsId
     * @param teamGrpId
     * @param dvclasNo
     * @param byteamDscsUseyn
     * @throws Exception
     */
    private void upsertTeamChildDscs(DscsVO vo, DscsVO currentVO, String parentDscsId, String teamGrpId, String dvclasNo, String byteamDscsUseyn) throws Exception {
        List<DscsTeamDscsVO> expectedTeams = loadExpectedTeams(parentDscsId, teamGrpId);
        Map<String, DscsTeamDscsVO> detailMap = buildTeamDtlMap(vo.getTeamDscsDtlList(), dvclasNo);
        Map<String, DscsTeamDscsVO> existingMap = new LinkedHashMap<>();
        List<DscsTeamDscsVO> existingChildren = dscsDAO.selectTeamDscsList(parentDscsId);
        if (existingChildren != null) {
            for (DscsTeamDscsVO item : existingChildren) {
                existingMap.put(item.getTeamId(), item);
            }
        }

        String originalDscsId = vo.getDscsId();
        String originalUpDscsId = vo.getUpDscsId();
        String originalTeamId = vo.getTeamId();
        String originalDscsTtl = vo.getDscsTtl();
        String originalDscsCts = vo.getDscsCts();
        String originalByteam = vo.getByteamDscsUseyn();

        for (DscsTeamDscsVO teamRow : expectedTeams) {
            DscsTeamDscsVO teamDtl = detailMap.get(teamRow.getTeamId());
            DscsTeamDscsVO existing = existingMap.get(teamRow.getTeamId());
            String childTitle = ("Y".equalsIgnoreCase(byteamDscsUseyn) && teamDtl != null)
                    ? StringUtil.nvl(teamDtl.getDscsTtl())
                    : TEAM_CHILD_PLACEHOLDER;
            String childContents = ("Y".equalsIgnoreCase(byteamDscsUseyn) && teamDtl != null)
                    ? StringUtil.nvl(teamDtl.getDscsCts())
                    : TEAM_CHILD_PLACEHOLDER;

            if (existing == null || StringUtil.isNull(existing.getDscsId())) {
                insertTeamChildDscs(vo, parentDscsId, teamRow, teamDtl, byteamDscsUseyn);
            } else {
                DscsTeamDscsVO updateVO = new DscsTeamDscsVO();
                updateVO.setUpDscsId(parentDscsId);
                updateVO.setTeamId(teamRow.getTeamId());
                updateVO.setDscsId(existing.getDscsId());
                updateVO.setDscsTtl(childTitle);
                updateVO.setDscsCts(childContents);
                updateVO.setByteamDscsUseyn("N");
                updateVO.setRgtrId(vo.getRgtrId());
                updateVO.setMdfrId(vo.getMdfrId());
                dscsDAO.updateChildDscsDtls(updateVO);
                if (!"Y".equalsIgnoreCase(byteamDscsUseyn)) {
                    removeTeamChildAttachments(existing.getDscsId());
                } else if (teamDtl != null) {
                    if (StringUtil.isNotNull(teamDtl.getDelFileIdStr())) {
                        attachFileService.deleteAtflByAtflIds(teamDtl.getDelFileIdStr().split(","));
                    }
                    if (StringUtil.isNotNull(teamDtl.getTeamUploadFiles())) {
                        List<AtflVO> teamFiles = FileUtil.getUploadAtflList(teamDtl.getTeamUploadFiles(), teamDtl.getTeamUploadPath());
                        for (AtflVO atflVO : teamFiles) {
                            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                            atflVO.setRefId(existing.getDscsId());
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

        vo.setDscsId(originalDscsId);
        vo.setUpDscsId(originalUpDscsId);
        vo.setTeamId(originalTeamId);
        vo.setDscsTtl(originalDscsTtl);
        vo.setDscsCts(originalDscsCts);
        vo.setByteamDscsUseyn(originalByteam);
    }

    /**
     * 토론성적공개여부 수정
     */
    @Override
    public ProcessResultVO<DscsVO> modifyDscsMrkOyn(DscsVO vo) {
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
    public void updateDscsMrkRfltrt(List<DscsVO> list) {
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
        // 찬반토론 설정값이 없는 경우 기본값을 보정한다.
        if (StringUtil.isNull(vo.getOknokStngyn())) {
            vo.setOknokStngyn("N");
        }
        // 저장 로직에서 사용할 토론 구분값을 TEAM/GNRL로 정규화한다.
        boolean isTeamDiscussion = "TEAM".equalsIgnoreCase(vo.getDscsUnitTycd()) || "Y".equalsIgnoreCase(vo.getDscsUnitTycd());
        vo.setDscsUnitTycd(isTeamDiscussion ? "TEAM" : "GNRL");

        // 토론 ID 존재 여부로 등록/수정 저장 절차를 분기한다.
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

        // 서비스 직접 호출에 대비해 등록 대상 분반 목록을 방어적으로 확인한다.
        List<DscsDvclasSelVO> dvclasSelList = vo.getDvclasSelList();
        String baseSbjctId = vo.getSbjctId();
        Map<String, DscsVO> validDvclasMap = new HashMap<>();
        List<DscsVO> validDvclasList = dscsDAO.selectDscsDvclasList(vo);
        if(validDvclasList != null) {
            for(DscsVO validDvclas : validDvclasList) {
                if(validDvclas == null || StringUtil.isNull(validDvclas.getSbjctId())) {
                    continue;
                }
                validDvclasMap.put(validDvclas.getSbjctId(), validDvclas);
            }
        }
        if (dvclasSelList == null || dvclasSelList.isEmpty()) {
            resultVO.setResultFailed("등록 시 분반 정보가 필요합니다.");
            return resultVO;
        }

        // 분반별 팀 분류와 학습그룹별 토론 사용 여부를 저장 처리용 map으로 구성한다.
        Map<String, String> teamGrpMapByDvclasNo = new HashMap<>();
        Map<String, String> teamGrpNmMapByDvclasNo = new HashMap<>();
        Map<String, String> byteamDscsUseynMapByDvclasNo = new HashMap<>();
        List<DscsTeamGrpVO> teamGrpInfoList = vo.getTeamGrpInfoList();
        if (teamGrpInfoList != null) {
            for (DscsTeamGrpVO info : teamGrpInfoList) {
                if (info == null) {
                    continue;
                }
                if (!StringUtil.isNull(info.getDvclasNo()) && !StringUtil.isNull(info.getTeamGrpId())) {
                    teamGrpMapByDvclasNo.put(info.getDvclasNo(), info.getTeamGrpId());
                }
                if (!StringUtil.isNull(info.getDvclasNo()) && !StringUtil.isNull(info.getTeamGrpnm())) {
                    teamGrpNmMapByDvclasNo.put(info.getDvclasNo(), info.getTeamGrpnm());
                }
                if (!StringUtil.isNull(info.getDvclasNo())) {
                    byteamDscsUseynMapByDvclasNo.put(
                            info.getDvclasNo(),
                            StringUtil.isNull(info.getByteamDscsUseyn()) ? "N" : info.getByteamDscsUseyn()
                    );
                }
            }
        }

        // 팀토론은 분반별 팀 분류 정보가 있어야 자식 토론을 생성할 수 있다.
        if (isTeamDiscussion && teamGrpMapByDvclasNo.isEmpty()) {
            resultVO.setResultFailed("팀토론 등록 시 분반별 학습그룹 정보가 필요합니다.");
            return resultVO;
        }

        String firstDscsId = null;
        for (DscsDvclasSelVO dvclasSelVO : dvclasSelList) {
            if (dvclasSelVO == null) {
                continue;
            }
            if (!"Y".equalsIgnoreCase(dvclasSelVO.getCheckedYn())) {
                continue;
            }
            DscsVO validDvclas = validDvclasMap.get(dvclasSelVO.getSbjctId());
            if(validDvclas == null) {
                resultVO.setResultFailed(getMessage("forum.alert.select.dvclas"));
                return resultVO;
            }
            vo.setSbjctId(validDvclas.getSbjctId());

            String dvclasNo = validDvclas.getDvclasNo();
            // 선택된 분반의 분반 번호는 부모 토론 생성의 필수 기준값이다.
            if (StringUtil.isNull(dvclasNo)) {
                resultVO.setResultFailed("등록 시 분반 정보가 필요합니다.");
                return resultVO;
            }

            if (isTeamDiscussion) {
                String teamGrpId = teamGrpMapByDvclasNo.get(dvclasNo);
                String teamGrpnm = teamGrpNmMapByDvclasNo.get(dvclasNo);
                // 팀토론은 분반별 팀 분류 ID/명이 모두 있어야 그룹 정보를 생성할 수 있다.
                if (StringUtil.isNull(teamGrpId) || StringUtil.isNull(teamGrpnm)) {
                    resultVO.setResultFailed("팀토론 등록 시 분반별 학습그룹 정보가 필요합니다.");
                    return resultVO;
                }
                // 분반별 부모 토론과 연결될 토론 그룹을 생성한다.
                String dscsGrpId = IdGenerator.getNewId(IdPrefixType.DSGRP.getCode());
                vo.setDscsGrpId(dscsGrpId);
                vo.setTeamGrpId(teamGrpId);
                vo.setDscsGrpnm(teamGrpnm);
                dscsDAO.insertDscsGrp(vo);
            } else {
                vo.setDscsGrpId(null);
                vo.setTeamGrpId(null);
                vo.setDscsGrpnm(null);
            }

            String byteamDscsUseyn = byteamDscsUseynMapByDvclasNo.getOrDefault(dvclasNo, "N");
            String origDscsTtl = vo.getDscsTtl();
            String origDscsCts = vo.getDscsCts();
            String newDscsId = IdGenerator.getNewId(IdPrefixType.DSCS.getCode());
            vo.setDscsId(newDscsId);
            vo.setDvclasNo(dvclasNo);
            vo.setByteamDscsUseyn(isTeamDiscussion ? byteamDscsUseyn : "N");
            vo.setUpDscsId(null);
            vo.setTeamId(null);
            // 선택 분반별 부모 토론을 생성한다.
            dscsDAO.insertDscs(vo);

            if (isTeamDiscussion) {
                // 팀 목록 기준으로 자식 토론을 생성하고 학습그룹별 부주제를 반영한다.
                upsertTeamChildDscs(vo, null, newDscsId, vo.getTeamGrpId(), dvclasNo, byteamDscsUseyn);
            }

            if (firstDscsId == null) {
                firstDscsId = newDscsId;
            }
        }

        // 선택된 분반이 하나도 저장되지 않은 경우 저장 실패로 반환한다.
        vo.setSbjctId(baseSbjctId);
        if (StringUtil.isNull(firstDscsId)) {
            resultVO.setResultFailed("팀토론 등록 시 유효한 분반 정보가 없습니다.");
            return resultVO;
        }
        vo.setDscsId(firstDscsId);

        // 부모 토론 첨부파일은 최초 생성된 토론 ID에 연결한다.
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

        // 기존 토론 상태를 기준으로 일반/팀토론 전환 및 팀 분류 변경 여부를 판단한다.
        DscsVO currentParam = new DscsVO();
        currentParam.setDscsId(vo.getDscsId());
        DscsVO currentVO = dscsDAO.selectDscs(currentParam);
        // 토론 수정은 참여기간 시작 전에만 허용한다.
        if (currentVO == null) {
            resultVO.setResultFailed("update target not found");
            return resultVO;
        }
        if (!DscsPeriodPolicy.canProfEditDscs(currentVO)) {
            resultVO.setResultFailed(getMessage(DscsPeriodPolicy.MSG_KEY_BEFORE_ONLY));
            return resultVO;
        }
        String parentDscsId = currentVO.getDscsId();
        boolean wasTeam = "TEAM".equalsIgnoreCase(currentVO.getDscsUnitTycd());

        DscsTeamGrpVO matchedGrpInfo = findMatchedTeamGrpInfo(vo, currentVO);
        String newDvclasNo = StringUtil.isNotNull(vo.getDvclasNo()) ? vo.getDvclasNo() : currentVO.getDvclasNo();
        String newSbjctId = StringUtil.isNotNull(vo.getSbjctId()) ? vo.getSbjctId() : currentVO.getSbjctId();
        String currentTeamGrpId = StringUtil.nvl(currentVO.getTeamGrpId());
        String nextTeamGrpId = matchedGrpInfo != null ? StringUtil.nvl(matchedGrpInfo.getTeamGrpId()) : StringUtil.nvl(vo.getTeamGrpId());
        String nextTeamGrpnm = matchedGrpInfo != null ? StringUtil.nvl(matchedGrpInfo.getTeamGrpnm()) : StringUtil.nvl(vo.getDscsGrpnm());
        boolean teamGrpChanged = wasTeam && isTeamDiscussion && StringUtil.isNotNull(nextTeamGrpId) && !nextTeamGrpId.equals(currentTeamGrpId);
        String newByteam = resolveByteamDscsUseyn(vo, currentVO);

        vo.setDvclasNo(newDvclasNo);
        vo.setSbjctId(newSbjctId);
        vo.setByteamDscsUseyn(isTeamDiscussion ? newByteam : "N");
        vo.setDscsId(parentDscsId);

        // 팀토론에서 일반토론으로 변경되는 경우 기존 자식 토론을 정리한다.
        if (wasTeam && !isTeamDiscussion) {
            deleteTeamChildDscs(vo, parentDscsId);
        }

        if (isTeamDiscussion) {
            // 팀토론은 저장 시점에 사용할 팀 분류 ID가 반드시 필요하다.
            if (StringUtil.isNull(nextTeamGrpId)) {
                resultVO.setResultFailed("팀토론은 팀그룹 정보가 필요합니다.");
                return resultVO;
            }
            vo.setTeamGrpId(nextTeamGrpId);
            // 신규 팀토론 전환, 팀 분류 변경, 그룹 누락 시 새 토론 그룹을 생성한다.
            if (!wasTeam || teamGrpChanged || StringUtil.isNull(currentVO.getDscsGrpId())) {
                String dscsGrpId = IdGenerator.getNewId(IdPrefixType.DSGRP.getCode());
                vo.setDscsGrpId(dscsGrpId);
                vo.setDscsGrpnm(nextTeamGrpnm);
                dscsDAO.insertDscsGrp(vo);
            }
        } else {
            vo.setTeamGrpId(null);
            vo.setDscsGrpId(null);
        }

        // 팀 분류가 변경되면 기존 자식 토론을 삭제하고 새 팀 목록 기준으로 재생성한다.
        if (wasTeam && isTeamDiscussion && teamGrpChanged) {
            deleteTeamChildDscs(vo, parentDscsId);
        }

        vo.setDscsId(parentDscsId);
        // 부모 토론 정보를 수정한다.
        dscsDAO.updateDscs(vo);

        if (isTeamDiscussion) {
            // 팀토론 자식 토론을 현재 팀 목록과 학습그룹별 부주제 설정에 맞게 동기화한다.
            upsertTeamChildDscs(vo, currentVO, parentDscsId, vo.getTeamGrpId(), newDvclasNo, newByteam);
        }

        vo.setDscsId(parentDscsId);
        // 부모 토론 첨부파일을 추가한다.
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        for (AtflVO atflVO : uploadFileList) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(parentDscsId);
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

    /**
     * 교수자 과목 토론 목록을 페이징 조회한다.
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DscsVO> selectProfSbjctDscsList(DscsVO vo) {

        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<DscsVO> dscsList = dscsDAO.selectProfSbjctDscsList(vo);

        if(dscsList.size() > 0) {
            paginationInfo.setTotalRecordCount(dscsList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(dscsList);
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
    public ProcessResultVO<DscsVO> deleteDscs(DscsVO vo) {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        // 토론 삭제는 참여기간 시작 전에만 허용한다.
        DscsVO currentParam = new DscsVO();
        currentParam.setDscsId(vo.getDscsId());
        DscsVO currentVO = dscsDAO.selectDscs(currentParam);
        if (currentVO == null) {
            resultVO.setResultFailed("delete target not found");
            return resultVO;
        }
        if (!DscsPeriodPolicy.canProfEditDscs(currentVO)) {
            resultVO.setResultFailed(getMessage(DscsPeriodPolicy.MSG_KEY_BEFORE_ONLY));
            return resultVO;
        }

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
    public ProcessResultVO<DscsTeamDscsVO> modifyTeamDscsOyn(DscsTeamDscsVO vo) {
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
     * 팀그룹 팀 목록 조회 (팀 토론 부주제 설정용)
     */
    @Override
    public ProcessResultVO<DscsTeamDscsVO> selectDscsTeamGrpTeamList(DscsTeamDscsVO vo) {
        ProcessResultVO<DscsTeamDscsVO> resultVO = new ProcessResultVO<>();
        List<DscsTeamDscsVO> list = dscsDAO.selectDscsTeamGrpTeamList(vo);
        String byteamDscsUseyn = normalizeYn(vo.getByteamDscsUseyn());
        if (list != null) {
            for (DscsTeamDscsVO item : list) {
                if (item == null) {
                    continue;
                }
                item.setByteamDscsUseyn(byteamDscsUseyn);
                if (!"Y".equalsIgnoreCase(byteamDscsUseyn) || StringUtil.isNull(item.getDscsId())) {
                    continue;
                }
                AtflVO atflParam = new AtflVO();
                atflParam.setAtflRepoId(CommConst.REPO_DSCS);
                atflParam.setRefId(item.getDscsId());
                item.setFileList(attachFileService.selectAtflListByRefId(atflParam));
            }
        }
        normalizeTeamChildDisplay(list, byteamDscsUseyn);
        resultVO.setReturnList(list);
        return resultVO;
    }

    /**
     * 성적 반영 비율을 반영 대상 토론 수 기준으로 초기화한다.
     * @param dscsVO
     * @throws Exception
     */
    @Override
    public void setScoreRatio(DscsVO dscsVO) {
        List<DscsVO> scoreAplyList = dscsDAO.getScoreRatio(dscsVO);

        if( scoreAplyList != null && !scoreAplyList.isEmpty() && scoreAplyList.size() > 0) {
            int scoreAplyCnt = scoreAplyList.size();
            int share = 100 / scoreAplyCnt;
            int rest = 100 % scoreAplyCnt;
            int cnt = 0;
            Integer scoreRatio = 0;
            for(DscsVO dscsScoreVO : scoreAplyList) {
                if(cnt == 0) {
                    scoreRatio = share + rest;
                } else {
                    scoreRatio = share;
                }
                dscsVO.setMrkRfltrt(scoreRatio);
                dscsVO.setDscsId(dscsScoreVO.getDscsId());
                dscsDAO.setScoreRatio(dscsVO);
                cnt++;
            }
        }
    }

    /**
     * 토론 성적 분포 차트 데이터를 조회한다.
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public EgovMap viewScoreChart(DscsVO vo) {
        EgovMap scoreMap = dscsDAO.selectScoreChart(vo);
        return scoreMap;
    }

    /**
     * 토론 복사용 교수 학기기수 목록을 조회한다.
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> selectProfSmstrChrtList(DscsVO vo) {
        return dscsDAO.selectProfSmstrChrtList(vo);
    }

    /**
     * 토론 복사용 학기기수별 과목 목록을 조회한다.
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> selectProfSmstrChrtSbjctList(DscsVO vo) {
        return dscsDAO.selectProfSmstrChrtSbjctList(vo);
    }

    /**
     * 과목별토론목록조회
     * @param	DscsVO
     * @return 	과목별토론목록s
     */
	@Override
	public List<EgovMap> bySubjectDscsList(DscsVO vo) {
		 return dscsDAO.bySubjectDscsList(vo);
	}

    private String getMessage(String messageKey) {
        return messageSource.getMessage(messageKey, null, messageKey, LocaleContextHolder.getLocale());
    }

}
