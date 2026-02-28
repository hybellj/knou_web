package knou.lms.team.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;

@Mapper("teamMemberDAO")
public interface TeamMemberDAO {

    /*****************************************************
     * TODO 내 소속 팀 조회
     * @param TeamMemberVO
     * @return List<TeamMemberVO>
     * @throws Exception
     ******************************************************/
    public List<TeamMemberVO> listMyTeamStd(TeamMemberVO vo) throws Exception;
    
    /*****************************************************
     * TODO 팀원 목록 조회
     * @param TeamMemberVO
     * @return List<TeamMemberVO>
     * @throws Exception
     ******************************************************/
    public List<TeamMemberVO> list(TeamMemberVO vo) throws Exception;

    public void insertStd(TeamMemberVO vo) throws Exception;

    // 팀원 조회
    public List<TeamMemberVO> selectTeamMemberList(TeamVO vo) throws Exception;

    // 팀 구성된 팀원수
	public int count(TeamVO vo) throws Exception;

	// 해당 토론의 소속팀 가져오기
	public String getMeTeamNm(TeamMemberVO vo) throws Exception;

	// 팀원 리스트
	public String[] getTeamMemberList(TeamMemberVO vo) throws Exception;
	
	// 팀 분류코드 내 팀원 목록 조회
	public List<TeamMemberVO> listTeamMemberByCtgrCd(TeamMemberVO vo) throws Exception;
    
}
