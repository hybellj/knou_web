package knou.lms.team.dao;

import knou.lms.team.vo.TeamGrpMgrVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("teamGrpMgrDAO")
public interface TeamGrpMgrDAO {
    // 팀 그룹 등록
    public void teamGrpRegist(TeamGrpMgrVO vo);

    // 팀 등록
    public void teamRegist(TeamGrpMgrVO vo);

    // 팀 멤버 등록
    public void teamMbrRegist(TeamGrpMgrVO vo);

    // 팀 그룹 목록 페이징
    public List<TeamGrpMgrVO> listTeamGrpPaging(TeamGrpMgrVO vo);

    // 팀 그룹 목록 카운트
    public int countTeamGrp(TeamGrpMgrVO vo);

    // 수강생 목록 조회
    public List<EgovMap> listAtndlcUser(TeamGrpMgrVO vo);

    // 수강생 목록 카운트
    public int countAtndlcUser(TeamGrpMgrVO vo);

    // 팀 및 팀원 목록 조회
    public List<EgovMap> listTeamAndMbr(TeamGrpMgrVO vo);

    // 학습자 팀 식별자(ID) 조회 및 검증
    public String findLearnerTeamId(TeamGrpMgrVO vo);

    // 특정 팀의 소속 여부 및 인원 확인
    public int countUserInTeam(TeamGrpMgrVO vo);

    // 팀원 목록 조회
    public List<EgovMap> listTeamMembers(TeamGrpMgrVO vo);

    // 팀 그룹 수정
    public void updateTeamGrpInfo(TeamGrpMgrVO vo);

    // 팀 수정
    public void updateTeamInfo(TeamGrpMgrVO vo);

    // 팀 그룹 삭제
    public void updateTeamGrpDelyn(TeamGrpMgrVO vo);

    // 팀 삭제
    public void deleteTeam(TeamGrpMgrVO vo);

    // 팀 멤버 삭제
    public void deleteTeamMbr(TeamGrpMgrVO vo);
}
