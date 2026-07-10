package knou.lms.team.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.team.vo.TeamGrpMgrVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface TeamGrpMgrService {
    // 팀 그룹 등록
    public TeamGrpMgrVO teamGrpRegist(TeamGrpMgrVO vo);

    // 팀 그룹 목록 페이징
    public ProcessResultVO<TeamGrpMgrVO> listTeamGrpPaging(TeamGrpMgrVO vo);

    // 수강생 목록 조회
    public List<EgovMap> listAtndlcUser(TeamGrpMgrVO vo);

    // 수강생 목록 카운트
    public int countAtndlcUser(TeamGrpMgrVO vo);

    // 팀 및 팀원 목록 조회
    public List<EgovMap> listTeamAndMbr(TeamGrpMgrVO vo);

    // 학습자 팀 식별자(ID) 조회 및 검증
    public String findLearnerTeamId(String teamGrpId, String userId);

    // 특정 팀의 소속 여부 및 인원 확인
    public boolean isUserInTeam(String teamId, String userId);

    // 팀원 목록 조회
    public List<EgovMap> listTeamMembers(String teamId);

    // 팀 그룹 수정
    public void updateTeamGrpInfo(TeamGrpMgrVO vo);

    // 팀 그룹 삭제
    public void updateTeamGrpDelyn(TeamGrpMgrVO vo);
}
