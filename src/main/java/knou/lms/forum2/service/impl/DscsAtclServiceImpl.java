package knou.lms.forum2.service.impl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.forum2.dao.DscsAtclDAO;
import knou.lms.forum2.dao.DscsCmntDAO;
import knou.lms.forum2.dao.DscsJoinUserDAO;
import knou.lms.forum2.policy.DscsAccessPolicy;
import knou.lms.forum2.policy.DscsPeriodPolicy;
import knou.lms.forum2.service.DscsAtclService;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsCmntVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsVO;

@Service("dscsAtclService")
public class DscsAtclServiceImpl extends ServiceBase implements DscsAtclService {

    private static final Logger LOGGER = LoggerFactory.getLogger(DscsAtclServiceImpl.class);

    @Resource(name = "dscsAtclDAO")
    private DscsAtclDAO dscsAtclDAO;

    @Resource(name = "dscsCmntDAO")
    private DscsCmntDAO dscsCmntDAO;

    @Resource(name = "dscsJoinUserDAO")
    private DscsJoinUserDAO dscsJoinUserDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Resource(name = "dscsService")
    private DscsService dscsService;

    @Resource(name = "dscsAccessPolicy")
    private DscsAccessPolicy dscsAccessPolicy;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /**
     * 토론 게시글 페이징 목록을 조회한다.
     * @param vo
     * @return
     */
    private ProcessResultVO<DscsAtclVO> listPageing(DscsAtclVO vo) {
        ProcessResultVO<DscsAtclVO> resultList = new ProcessResultVO<>();

        // 페이징 정보를 조회 조건에 반영한다.
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        if (vo.getStdList() != null) {
            String[] stdArray = vo.getStdList().split(",");
            if (stdArray[0].equals("")) {
                stdArray = null;
            }
            vo.setSqlForeach(stdArray);
        }
        int totalCount = dscsAtclDAO.count(vo);
        paginationInfo.setTotalRecordCount(totalCount);

        List<DscsAtclVO> dscsAtclList = dscsAtclDAO.listPageing(vo);
        if (dscsAtclList != null) {
            for (DscsAtclVO row : dscsAtclList) {
                AtflVO atflParam = new AtflVO();
                atflParam.setAtflRepoId(CommConst.REPO_DSCS);
                atflParam.setRefId(row.getDscsAtclId());
                row.setFileList(attachFileService.selectAtflListByRefId(atflParam));
                row.setViewAll(vo.isViewAll());
                List<DscsCmntVO> cmntList = dscsCmntDAO.cmntList(row);
                row.setCmntList(cmntList);
            }
        }

        resultList.setResult(1);
        resultList.setReturnList(dscsAtclList);
        resultList.setPageInfo(paginationInfo);

        return resultList;
    }

    /**
     * 학습자 토론 게시글 목록을 조회한다.
     * @param dscsVO
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DscsAtclVO> stdntAtclList(DscsVO dscsVO, String userId) {
        ProcessResultVO<DscsAtclVO> resultVO = new ProcessResultVO<>();

        String selectedDscsId = StringUtil.nvl(dscsVO.getDscsId());
        String configDscsId = selectedDscsId;
        if ("TEAM".equals(StringUtil.nvl(dscsVO.getDscsUnitTycd()))) {
            configDscsId = StringUtil.nvl(dscsVO.getUpDscsId(), selectedDscsId);
        }

        DscsVO configVO = new DscsVO();
        configVO.setDscsId(configDscsId);
        DscsVO loadedVO = dscsService.selectDscs(configVO);

        DscsAtclVO dscsAtclVO = new DscsAtclVO();
        dscsAtclVO.setDscsId(selectedDscsId);
        dscsAtclVO.setSearchValue(dscsVO.getSearchValue());
        dscsAtclVO.setPageIndex(dscsVO.getPageIndex());
        dscsAtclVO.setListScale(dscsVO.getListScale());
        dscsAtclVO.setSbjctId(loadedVO.getSbjctId());
        dscsAtclVO.setUserId(userId);

        if ("Y".equals(StringUtil.nvl(loadedVO.getOatclInqyn()))) {
            DscsAtclVO myAtclVO = new DscsAtclVO();
            myAtclVO.setDscsId(selectedDscsId);
            myAtclVO.setSbjctId(loadedVO.getSbjctId());
            myAtclVO.setUserId(userId);

            if (dscsAtclDAO.myAtclCnt(myAtclVO) == 0) {
                PagingInfo pagingInfo = new PagingInfo();
                pagingInfo.setCurrentPageNo(dscsVO.getPageIndex());
                pagingInfo.setRecordCountPerPage(dscsVO.getListScale());
                pagingInfo.setPageSize(dscsVO.getPageScale());
                pagingInfo.setTotalRecordCount(0);
                resultVO.setPageInfo(pagingInfo);
                resultVO.setResult(1);
                return resultVO;
            }
        }

        resultVO = listPageing(dscsAtclVO);
        clearInactiveContent(resultVO);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수자 토론 게시글 목록을 조회한다.
     * @param dscsVO
     * @return
     */
    @Override
    public ProcessResultVO<DscsAtclVO> profAtclList(DscsVO dscsVO) {
        DscsAtclVO dscsAtclVO = new DscsAtclVO();
        dscsAtclVO.setDscsId(dscsVO.getDscsId());
        dscsAtclVO.setSearchValue(dscsVO.getSearchValue());
        dscsAtclVO.setPageIndex(dscsVO.getPageIndex());
        dscsAtclVO.setListScale(dscsVO.getListScale());
        dscsAtclVO.setSbjctId(dscsVO.getSbjctId());
        dscsAtclVO.setViewAll(true);

        ProcessResultVO<DscsAtclVO> resultVO = listPageing(dscsAtclVO);
        resultVO.setResult(1);
        return resultVO;
    }

    /**
     * 교수자 토론 게시글을 등록한다.
     * @param vo
     * @param teamId
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> profAtclRegist(DscsAtclVO vo, String teamId, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        vo.setDscsId(StringUtil.nvl(vo.getDscsId()));
        // URL 우회 방지를 위해 service 계층에서 토론방 작성 가능 기간을 최종 검증한다.
        if (!dscsAccessPolicy.canProfWriteBbs(vo.getDscsId())) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        if (StringUtil.isNull(vo.getDscsAtclId())) {
            vo.setDscsAtclId(IdGenerator.getNewId(IdPrefixType.DSATC.getCode()));
        }
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setUserId(userId);
        vo.setAtclSeqno(0);
        insertAtclWithJoinAndFiles(vo, teamId);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 학습자 토론 게시글을 등록한다.
     * @param vo
     * @param teamId
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> stdntAtclRegist(DscsAtclVO vo, String teamId, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        String requestedDscsId = StringUtil.nvl(vo.getDscsId());
        String requestedTeamId = StringUtil.nvl(teamId);
        // URL 우회 방지를 위해 service 계층에서 학습자 참여기간을 최종 검증한다.
        if (!dscsAccessPolicy.canLearnerEnterOrWrite(requestedDscsId)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        if (!dscsAccessPolicy.canLearnerWriteTeamDscs(requestedDscsId, requestedTeamId, userId)) {
            resultVO.setResult(-1);
            return resultVO;
        }
        String requestedOknokGbncd = StringUtil.nvl(vo.getOknokGbncd());
        if (!canStdntAddAtcl(requestedDscsId, userId, requestedOknokGbncd)) {
            resultVO.setResult(-1);
            return resultVO;
        }

        vo.setDscsId(requestedDscsId);
        if (StringUtil.isNull(vo.getDscsAtclId())) {
            vo.setDscsAtclId(IdGenerator.getNewId(IdPrefixType.DSATC.getCode()));
        }
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setUserId(userId);
        vo.setAtclSeqno(0);
        insertAtclWithJoinAndFiles(vo, requestedTeamId);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수자 토론 게시글을 수정한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> profAtclModify(DscsAtclVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        vo.setDscsId(StringUtil.nvl(vo.getDscsId()));
        // 게시글 ID만 넘어온 요청도 service 계층에서 실제 토론 기간을 검증한다.
        if (!dscsAccessPolicy.canProfWriteBbsByAtcl(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        vo.setMdfrId(userId);
        vo.setUserId(userId);
        vo.setAtclCtsLen(StringUtil.getContentLenth(vo.getAtclCts()));
        dscsAtclDAO.updateAtcl(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 학습자 토론 게시글을 수정한다.
     * @param vo
     * @param teamId
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> stdntAtclModify(DscsAtclVO vo, String teamId, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String requestedDscsId = StringUtil.nvl(vo.getDscsId());
        String requestedTeamId = StringUtil.nvl(teamId);
        // URL 우회 방지를 위해 기간, 팀 소속, 소유자를 service 계층에서 검증한다.
        if (!dscsAccessPolicy.canLearnerEnterOrWrite(requestedDscsId)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        if (!dscsAccessPolicy.canLearnerWriteTeamDscs(requestedDscsId, requestedTeamId, userId)) {
            resultVO.setResult(-1);
            return resultVO;
        }
        String requestedAtclId = StringUtil.nvl(vo.getDscsAtclId());
        if (!dscsAccessPolicy.isLearnerOwnAtcl(requestedDscsId, requestedAtclId, userId)) {
            resultVO.setResult(-1);
            return resultVO;
        }
        String requestedOknokGbncd = StringUtil.nvl(vo.getOknokGbncd());
        if (!canStdntEditAtclOknok(requestedDscsId, requestedAtclId, requestedOknokGbncd)) {
            resultVO.setResult(-1);
            return resultVO;
        }

        vo.setDscsId(requestedDscsId);
        vo.setDscsAtclId(requestedAtclId);
        vo.setOknokGbncd(requestedOknokGbncd);
        vo.setMdfrId(userId);
        vo.setUserId(userId);
        vo.setAtclCtsLen(StringUtil.getContentLenth(vo.getAtclCts()));
        dscsAtclDAO.updateAtcl(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수자 토론 게시글을 삭제한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> profAtclDelete(DscsAtclVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        vo.setDscsId(StringUtil.nvl(vo.getDscsId()));
        // 삭제는 종료 후에도 허용되므로 삭제/숨김 전용 정책으로 검증한다.
        if (!dscsAccessPolicy.canProfDeleteOrHideBbsByAtcl(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        vo.setMdfrId(userId);
        dscsAtclDAO.deleteAtcl(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 학습자 토론 게시글을 삭제한다.
     * @param vo
     * @param teamId
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> stdntAtclDelete(DscsAtclVO vo, String teamId, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String requestedDscsId = StringUtil.nvl(vo.getDscsId());
        String requestedTeamId = StringUtil.nvl(teamId);
        // URL 우회 방지를 위해 기간, 팀 소속, 소유자를 service 계층에서 검증한다.
        if (!dscsAccessPolicy.canLearnerEnterOrWrite(requestedDscsId)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        if (!dscsAccessPolicy.canLearnerWriteTeamDscs(requestedDscsId, requestedTeamId, userId)) {
            resultVO.setResult(-1);
            return resultVO;
        }
        String requestedAtclId = StringUtil.nvl(vo.getDscsAtclId());
        if (!dscsAccessPolicy.isLearnerOwnAtcl(requestedDscsId, requestedAtclId, userId)) {
            resultVO.setResult(-1);
            return resultVO;
        }

        vo.setDscsId(requestedDscsId);
        vo.setDscsAtclId(requestedAtclId);
        vo.setMdfrId(userId);
        dscsAtclDAO.deleteAtcl(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수자 토론 게시글을 숨김 처리한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> profAtclHide(DscsAtclVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        vo.setDscsId(StringUtil.nvl(vo.getDscsId()));
        // 숨김은 종료 후에도 허용되므로 삭제/숨김 전용 정책으로 검증한다.
        if (!dscsAccessPolicy.canProfDeleteOrHideBbsByAtcl(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        vo.setMdfrId(userId);
        dscsAtclDAO.hideAtcl(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * EZ-Grader 토론 활동 그룹 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public ProcessResultVO<Map<String, Object>> listEzgActivity(DscsAtclVO vo) {
        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<Map<String, Object>>();
        // 조회 대상 학습자 목록을 생성한다.
        String[] targetUserIds = buildEzgTargetUserIds(vo);
        List<Map<String, Object>> groups = new ArrayList<Map<String, Object>>();

        if (targetUserIds.length == 0) {
            resultVO.setResult(1);
            resultVO.setReturnList(groups);
            return resultVO;
        }

        vo.setSqlForeach(targetUserIds);
        // 삭제/숨김을 포함한 게시글 및 댓글 목록을 조회한다.
        List<DscsAtclVO> atclList = dscsAtclDAO.listEzgActivityAtcl(vo);
        List<DscsCmntVO> cmntList = dscsCmntDAO.listEzgActivityCmnt(vo);

        Map<String, DscsAtclVO> atclMap = new LinkedHashMap<String, DscsAtclVO>();
        Map<String, List<DscsCmntVO>> ownCmntMap = new LinkedHashMap<String, List<DscsCmntVO>>();
        Map<String, Map<String, Object>> commentOnlyMap = new LinkedHashMap<String, Map<String, Object>>();
        Set<String> targetSet = new HashSet<String>();

        for (String userId : targetUserIds) {
            targetSet.add(userId);
        }

        if (atclList != null) {
            for (DscsAtclVO atcl : atclList) {
                atclMap.put(atcl.getDscsAtclId(), atcl);
                attachEzgFiles(atcl);
            }
        }

        if (cmntList != null) {
            for (DscsCmntVO cmnt : cmntList) {
                DscsAtclVO atcl = atclMap.get(cmnt.getDscsAtclId());
                if (atcl == null || !targetSet.contains(StringUtil.nvl(cmnt.getStdId()))) {
                    continue;
                }

                if (StringUtil.nvl(cmnt.getStdId()).equals(StringUtil.nvl(atcl.getUserId()))) {
                    // 본인 게시글에 본인이 단 댓글은 게시글 그룹에 포함한다.
                    List<DscsCmntVO> ownCmntList = ownCmntMap.get(atcl.getDscsAtclId());
                    if (ownCmntList == null) {
                        ownCmntList = new ArrayList<DscsCmntVO>();
                        ownCmntMap.put(atcl.getDscsAtclId(), ownCmntList);
                    }
                    ownCmntList.add(cmnt);
                } else {
                    // 타인 게시글에 단 댓글은 별도 그룹으로 구성한다.
                    String sectionKey = StringUtil.nvl(atcl.getOknokGbncd(), "NONE");
                    String mapKey = cmnt.getStdId() + "|" + sectionKey;
                    Map<String, Object> group = commentOnlyMap.get(mapKey);
                    if (group == null) {
                        group = new LinkedHashMap<String, Object>();
                        group.put("groupType", "COMMENT_ONLY");
                        group.put("userId", cmnt.getStdId());
                        group.put("userNm", cmnt.getUsernm());
                        group.put("stdntNo", cmnt.getStdntNo());
                        group.put("oknokGbncd", sectionKey);
                        group.put("comments", new ArrayList<DscsCmntVO>());
                        commentOnlyMap.put(mapKey, group);
                    }
                    @SuppressWarnings("unchecked")
                    List<DscsCmntVO> comments = (List<DscsCmntVO>) group.get("comments");
                    comments.add(cmnt);
                    group.put("commentCount", comments.size());
                }
            }
        }

        // 학습자별로 본인 게시글 그룹을 먼저 배치하고 댓글 전용 그룹을 뒤에 배치한다.
        for (String userId : targetUserIds) {
            if (atclList != null) {
                for (DscsAtclVO atcl : atclList) {
                    if (!userId.equals(StringUtil.nvl(atcl.getUserId()))) {
                        continue;
                    }
                    List<DscsCmntVO> comments = ownCmntMap.get(atcl.getDscsAtclId());
                    if (comments == null) {
                        comments = new ArrayList<DscsCmntVO>();
                    }
                    Map<String, Object> group = new LinkedHashMap<String, Object>();
                    group.put("groupType", "OWN_ATCL");
                    group.put("userId", atcl.getUserId());
                    group.put("userNm", atcl.getUsernm());
                    group.put("stdntNo", atcl.getStdntNo());
                    group.put("oknokGbncd", StringUtil.nvl(atcl.getOknokGbncd(), "NONE"));
                    group.put("atcl", atcl);
                    group.put("comments", comments);
                    group.put("commentCount", comments.size());
                    groups.add(group);
                }
            }

            for (Map<String, Object> group : commentOnlyMap.values()) {
                if (userId.equals(group.get("userId"))) {
                    groups.add(group);
                }
            }
        }

        resultVO.setResult(1);
        resultVO.setReturnList(groups);
        return resultVO;
    }

    /**
     * EZ-Grader 조회 대상 학습자 목록을 생성한다.
     * @param vo
     * @return
     */
    private String[] buildEzgTargetUserIds(DscsAtclVO vo) {
        String stdList = StringUtil.nvl(vo.getStdList());
        if (!"".equals(stdList)) {
            String[] values = stdList.split(",");
            List<String> result = new ArrayList<String>();
            for (String value : values) {
                String userId = StringUtil.nvl(value).trim();
                if (!"".equals(userId)) {
                    result.add(userId);
                }
            }
            return result.toArray(new String[result.size()]);
        }

        String stdId = StringUtil.nvl(vo.getStdId());
        if (!"".equals(stdId) && !"ALL".equals(stdId)) {
            return new String[] { stdId };
        }

        String userId = StringUtil.nvl(vo.getUserId());
        if (!"".equals(userId)) {
            return new String[] { userId };
        }

        return new String[0];
    }

    /**
     * EZ-Grader 게시글 첨부파일 목록을 설정한다.
     * @param atcl
     */
    private void attachEzgFiles(DscsAtclVO atcl) {
        AtflVO atflParam = new AtflVO();
        atflParam.setAtflRepoId(CommConst.REPO_DSCS);
        atflParam.setRefId(atcl.getDscsAtclId());
        atcl.setFileList(attachFileService.selectAtflListByRefId(atflParam));
    }

    /**
     * 토론 게시글과 참여자, 첨부파일을 등록한다.
     * @param vo
     * @param teamId
     */
    private void insertAtclWithJoinAndFiles(DscsAtclVO vo, String teamId) {
        // 내용 길이를 저장한다.
        vo.setAtclCtsLen(StringUtil.getContentLenth(vo.getAtclCts()));

        dscsAtclDAO.insertAtcl(vo);

        // 게시글 작성 시 토론 참여자를 단건 등록한다.
        // DscsJoinUserVO.stdId는 TB_LMS_DSCS_PTCP.USER_ID와 동일하다.
        DscsJoinUserVO joinVO = new DscsJoinUserVO();
        joinVO.setDscsId(vo.getDscsId());
        joinVO.setStdId(vo.getUserId());
        joinVO.setTeamId(StringUtil.nvl(teamId));
        joinVO.setRgtrId(vo.getRgtrId());
        joinVO.setMdfrId(vo.getMdfrId());
        joinVO.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
        try {
            dscsJoinUserDAO.ensureJoinUser(joinVO);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            // UNIQUE 제약 위반은 이미 존재하는 참여자로 보고 무시한다.
            LOGGER.debug("[insertAtclWithJoinAndFiles] ensureJoinUser skip - already exists: dscsId=" + vo.getDscsId() + ", userId=" + vo.getUserId());
        }

        // 첨부파일을 등록한다.
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        for (AtflVO atflVO : uploadFileList) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(vo.getDscsAtclId());
            atflVO.setRgtrId(vo.getRgtrId());
            atflVO.setMdfrId(vo.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_DSCS);
        }
        if (!uploadFileList.isEmpty()) {
            attachFileService.insertAtflList(uploadFileList);
        }
    }

    /**
     * 삭제/숨김 처리된 게시글과 댓글의 본문 및 첨부 목록을 응답에서 제거한다.
     * @param resultVO
     */
    private void clearInactiveContent(ProcessResultVO<DscsAtclVO> resultVO) {
        if (resultVO == null || resultVO.getReturnList() == null) {
            return;
        }

        for (DscsAtclVO atclVO : resultVO.getReturnList()) {
            if (!"N".equals(StringUtil.nvl(atclVO.getDelyn()))) {
                atclVO.setAtclCts("");
                atclVO.setFileList(null);
            }
            if (atclVO.getCmntList() == null) {
                continue;
            }
            for (Object cmntObj : atclVO.getCmntList()) {
                if (!(cmntObj instanceof DscsCmntVO)) {
                    continue;
                }
                DscsCmntVO cmntVO = (DscsCmntVO) cmntObj;
                if (!"N".equals(StringUtil.nvl(cmntVO.getDelyn()))) {
                    cmntVO.setCmntCts("");
                }
            }
        }
    }

    /**
     * 기간 제한 위반 실패 응답을 생성한다.
     * @param message
     * @return
     */
    private ProcessResultVO<DefaultVO> fail(String message) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        resultVO.setResultFailed(getMessage(message));
        return resultVO;
    }

    /**
     * 메시지 코드를 현재 locale의 문구로 변환한다.
     * @param messageKey
     * @return
     */
    private String getMessage(String messageKey) {
        return messageSource.getMessage(messageKey, null, messageKey, LocaleContextHolder.getLocale());
    }

    /**
     * 학습자가 게시글을 추가할 수 있는지 확인한다.
     * @param dscsId
     * @param userId
     * @param oknokGbncd
     * @return
     */
    private boolean canStdntAddAtcl(String dscsId, String userId, String oknokGbncd) {
        DscsVO ruleVO = dscsAccessPolicy.selectRuleDscs(dscsId);
        if (ruleVO == null || !"Y".equals(StringUtil.nvl(ruleVO.getOknokStngyn()))) {
            return true;
        }
        if (!isValidOknokGbncd(oknokGbncd)) {
            return false;
        }
        if ("Y".equals(StringUtil.nvl(ruleVO.getMltOpnnRegyn()))) {
            return true;
        }

        DscsAtclVO myAtclVO = new DscsAtclVO();
        myAtclVO.setDscsId(dscsId);
        myAtclVO.setSbjctId(ruleVO.getSbjctId());
        myAtclVO.setUserId(userId);
        return dscsAtclDAO.myAtclCnt(myAtclVO) == 0;
    }

    /**
     * 학습자가 찬반 값을 변경할 수 있는지 확인한다.
     * @param dscsId
     * @param dscsAtclId
     * @param oknokGbncd
     * @return
     */
    private boolean canStdntEditAtclOknok(String dscsId, String dscsAtclId, String oknokGbncd) {
        DscsVO ruleVO = dscsAccessPolicy.selectRuleDscs(dscsId);
        if (ruleVO == null || !"Y".equals(StringUtil.nvl(ruleVO.getOknokStngyn()))) {
            return true;
        }
        if (!isValidOknokGbncd(oknokGbncd)) {
            return false;
        }

        DscsAtclVO paramVO = new DscsAtclVO();
        paramVO.setDscsId(dscsId);
        paramVO.setDscsAtclId(dscsAtclId);
        DscsAtclVO savedVO = dscsAtclDAO.selectAtcl(paramVO);
        if (savedVO == null) {
            return false;
        }
        if ("Y".equals(StringUtil.nvl(ruleVO.getOknokModyn()))) {
            return true;
        }
        return oknokGbncd.equals(StringUtil.nvl(savedVO.getOknokGbncd()));
    }

    /**
     * 찬반 구분 코드가 유효한지 확인한다.
     * @param oknokGbncd
     * @return
     */
    private boolean isValidOknokGbncd(String oknokGbncd) {
        return "OK".equals(oknokGbncd) || "NOTOK".equals(oknokGbncd);
    }

    /**
     * 본인 게시글 작성 상태를 조회한다.
     * @param vo
     * @return
     */
    @Override
    public DscsAtclVO selectMyAtclStatus(DscsAtclVO vo) {
        return dscsAtclDAO.selectMyAtclStatus(vo);
    }
}
