package knou.lms.forum2.service;

import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsVO;

// 학습자 토론 화면에서 사용하는 권한, 팀 토론 대상, 게시글/댓글 저장 흐름을 처리한다.
public interface DscsLearnerService {

    // 요청 teamId가 학습자가 접근 가능한 팀 토론인지 확인하고 유효한 teamId만 반환한다.
    String sanitizeLearnerTeamId(DscsVO loadedVO, String requestedTeamId, String userId);
    // 토론 설정과 사용자 기준으로 학습자가 소속된 팀 ID를 조회한다.
    String getLearnerTeamId(DscsVO loadedVO, String userId);
    // 팀 토론인 경우 학습자 팀에 대응하는 하위 토론 ID를 반환한다.
    String resolveLearnerTargetDscsId(DscsVO loadedVO, String learnerTeamId);
    // 현재 학습자의 참여 상태 VO를 조회하거나 기본값으로 구성한다.
    DscsJoinUserVO buildMyJoinUser(DscsVO loadedVO, String userId);
    // 지정한 토론 ID 기준으로 현재 학습자의 참여 상태 VO를 조회하거나 기본값으로 구성한다.
    DscsJoinUserVO buildMyJoinUser(DscsVO loadedVO, String userId, String targetDscsId);
    // 특정 학생의 참여 상태 VO를 조회하거나 기본값으로 구성한다.
    DscsJoinUserVO buildJoinUserForStd(DscsVO loadedVO, String stdId, String userId);
    // 지정한 토론 ID 기준으로 특정 학생의 참여 상태 VO를 조회하거나 기본값으로 구성한다.
    DscsJoinUserVO buildJoinUserForStd(DscsVO loadedVO, String stdId, String userId, String targetDscsId);
    // 참여 상태 VO의 활동 수를 기준으로 학습자 참여 여부를 판단한다.
    boolean hasLearnerJoined(DscsJoinUserVO joinUserVO);
}
