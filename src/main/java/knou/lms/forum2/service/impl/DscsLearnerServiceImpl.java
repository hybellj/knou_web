package knou.lms.forum2.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.StringUtil;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.service.DscsLearnerService;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.forum2.vo.DscsVO;
import knou.lms.team.service.TeamGrpMgrService;

/**
 * 학습자 토론 업무 규칙을 처리하는 서비스 구현체.
 */
@Service("dscsLearnerService")
public class DscsLearnerServiceImpl extends ServiceBase implements DscsLearnerService {

    @Resource(name = "dscsService")
    private DscsService dscsService;

    @Resource(name = "dscsJoinUserService")
    private DscsJoinUserService dscsJoinUserService;

    @Resource(name = "teamGrpMgrService")
    private TeamGrpMgrService teamGrpMgrService;

    /**
     * 요청 teamId가 현재 학습자의 팀 토론 접근 범위에 포함되는지 검증한다.
     */
    @Override
    public String sanitizeLearnerTeamId(DscsVO loadedVO, String requestedTeamId, String userId) {
        // 팀 토론이 아니거나 학습자가 소속되지 않은 팀이면 teamId를 사용하지 않는다.
        String teamId = StringUtil.nvl(requestedTeamId);
        if (loadedVO == null || StringUtil.isNull(teamId)) {
            return "";
        }
        if (!"TEAM".equals(StringUtil.nvl(loadedVO.getDscsUnitTycd()))) {
            return "";
        }
        if (StringUtil.isNotNull(loadedVO.getUpDscsId())) {
            String childTeamId = StringUtil.nvl(loadedVO.getTeamId());
            return childTeamId.equals(teamId) && teamGrpMgrService.isUserInTeam(childTeamId, userId) ? teamId : "";
        }
        return teamId.equals(getLearnerTeamId(loadedVO, userId)) ? teamId : "";
    }

    /**
     * 토론 팀 그룹 기준으로 학습자가 소속된 팀 ID를 조회한다.
     */
    @Override
    public String getLearnerTeamId(DscsVO loadedVO, String userId) {
        if (loadedVO == null || !"TEAM".equals(StringUtil.nvl(loadedVO.getDscsUnitTycd()))) {
            return "";
        }
        return teamGrpMgrService.findLearnerTeamId(loadedVO.getTeamGrpId(), userId);
    }

    /**
     * 팀 토론이면 학습자 팀에 매핑된 하위 토론 ID를 반환한다.
     */
    @Override
    public String resolveLearnerTargetDscsId(DscsVO loadedVO, String learnerTeamId) {
        // 팀별 하위 토론이 있으면 피드백/참여 상태 조회 대상도 하위 토론으로 맞춘다.
        if (loadedVO == null) {
            return "";
        }
        if (!"TEAM".equals(StringUtil.nvl(loadedVO.getDscsUnitTycd())) || StringUtil.isNull(learnerTeamId)) {
            return StringUtil.nvl(loadedVO.getDscsId());
        }

        List<DscsTeamDscsVO> teamDscsList = loadedVO.getTeamDscsList();
        if (teamDscsList == null) {
            return StringUtil.nvl(loadedVO.getDscsId());
        }

        for (DscsTeamDscsVO teamDscsVO : teamDscsList) {
            if (teamDscsVO == null) {
                continue;
            }
            if (learnerTeamId.equals(StringUtil.nvl(teamDscsVO.getTeamId()))
                    && StringUtil.isNotNull(teamDscsVO.getDscsId())) {
                return teamDscsVO.getDscsId();
            }
        }
        return StringUtil.nvl(loadedVO.getDscsId());
    }

    /**
     * 현재 학습자의 기본 참여 상태 VO를 구성한다.
     */
    @Override
    public DscsJoinUserVO buildMyJoinUser(DscsVO loadedVO, String userId) {
        return buildJoinUserForStd(loadedVO, userId, userId);
    }

    /**
     * 지정한 토론 ID 기준으로 현재 학습자의 참여 상태 VO를 구성한다.
     */
    @Override
    public DscsJoinUserVO buildMyJoinUser(DscsVO loadedVO, String userId, String targetDscsId) {
        return buildJoinUserForStd(loadedVO, userId, userId, targetDscsId);
    }

    /**
     * 특정 학생의 기본 참여 상태 VO를 구성한다.
     */
    @Override
    public DscsJoinUserVO buildJoinUserForStd(DscsVO loadedVO, String stdId, String userId) {
        return buildJoinUserForStd(loadedVO, stdId, userId, loadedVO.getDscsId());
    }

    /**
     * 지정한 토론 ID 기준으로 특정 학생의 참여 상태 VO를 조회하거나 기본값으로 구성한다.
     */
    @Override
    public DscsJoinUserVO buildJoinUserForStd(DscsVO loadedVO, String stdId, String userId, String targetDscsId) {
        String dscsId = StringUtil.nvl(targetDscsId, loadedVO.getDscsId());
        DscsJoinUserVO joinUserVO = new DscsJoinUserVO();
        joinUserVO.setDscsId(dscsId);
        joinUserVO.setSbjctId(loadedVO.getSbjctId());
        joinUserVO.setStdId(stdId);
        joinUserVO.setUserId(userId);
        joinUserVO = dscsJoinUserService.selectDscsJoinUser(joinUserVO);

        if (joinUserVO == null) {
            joinUserVO = new DscsJoinUserVO();
            joinUserVO.setDscsId(dscsId);
            joinUserVO.setSbjctId(loadedVO.getSbjctId());
            joinUserVO.setStdId(stdId);
            joinUserVO.setJoinStatus("");
            joinUserVO.setActlCnt(0);
            joinUserVO.setCmntCnt(0);
            joinUserVO.setDscsFdbkCnt(0);
            joinUserVO.setDscsMyAtclCnt(0);
            joinUserVO.setDscsMyCmntCnt(0);
        }

        return joinUserVO;
    }

    /**
     * 활동 수 기준으로 학습자 참여 여부를 판단한다.
     */
    @Override
    public boolean hasLearnerJoined(DscsJoinUserVO joinUserVO) {
        if (joinUserVO == null) {
            return false;
        }
        return safeInt(joinUserVO.getActlCnt()) > 0;
    }


    /**
     * null Integer 값을 0으로 보정한다.
     */
    private int safeInt(Integer value) {
        return value == null ? 0 : value.intValue();
    }
}
