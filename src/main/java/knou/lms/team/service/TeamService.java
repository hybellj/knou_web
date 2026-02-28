package knou.lms.team.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;

public interface TeamService {
    
    public List<TeamVO> list(TeamVO vo) throws Exception;

    // 팀토론 토론방 팀리스트
    public List<TeamVO> teamList(TeamVO vo) throws Exception;

    // 팀 자동 생성
    public void addAutoTeam(TeamVO vo) throws Exception;

    // 팀 리스트
    public List<TeamVO> listTeam(TeamVO vo) throws Exception;

    // 팀 삭제
    public void removeTeam(TeamVO vo) throws Exception;

    // 팀 정보 조회
    public TeamVO select(TeamVO vo) throws Exception;

    // 팀원 조회
    public TeamVO selectTeamCtgrStd(TeamVO vo) throws Exception;

    // 팀원 리스트
    public List<TeamVO> listStd(TeamVO vo) throws Exception;

    // 현재 팀원 리스트
    public List<TeamMemberVO> teamStdList(TeamVO vo) throws Exception;

    // 팀,팀원 조회
    public List<TeamVO> teamTeamMemberList(TeamVO vo) throws Exception;

    // 팀 추가
    public void addTeam(TeamVO vo) throws Exception;

    // 토론 성적 분포 현황
    public EgovMap viewScoreChart(TeamVO vo) throws Exception;

    // 팀 분류 코드에 해당하는 팀 분류 조회
    public int selectTeamCtgrCd(TeamVO vo) throws Exception;

	public void setGroupConcatMaxLen() throws Exception;
	
	public void updateUseTeamMember(TeamVO vo) throws Exception;

}
