package knou.lms.team.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamVO;

@Mapper("teamCtgrDAO")
public interface TeamCtgrDAO {

    public List<TeamCtgrVO> list(TeamCtgrVO vo) throws Exception;

    public TeamCtgrVO select(TeamCtgrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 팀 배정 완료된 팀 분류 목록
     * @param TeamCtgrVO
     * @return List<TeamCtgrVO>
     * @throws Exception
     ******************************************************/
    public List<TeamCtgrVO> listComplateTeamByCrsCreCd(TeamCtgrVO vo) throws Exception;

    // 팀 분류 등록
    public void insertTeamCtgr(TeamCtgrVO vo) throws Exception;

    // 팀 분류 수정
    public void updateTeamCtgr(TeamCtgrVO vo) throws Exception;

    // 팀원 삭제
    public void delTeamMember(TeamCtgrVO vo) throws Exception;

    // 팀 삭제
    public void delTeam(TeamCtgrVO vo) throws Exception;

    // 팀 조회
    public int selectTeam(TeamCtgrVO vo) throws Exception;

    // 팀분류 삭제
    public void delete(TeamCtgrVO vo) throws Exception;

    // 팀 분류 조회
    public List<TeamCtgrVO> teamListDiv(TeamCtgrVO vo) throws Exception;

    // 팀분류 정보
    public TeamCtgrVO selecTeamForm(TeamCtgrVO vo) throws Exception;

    // 팀원 삭제
    public void editDelTeamMember(TeamCtgrVO vo) throws Exception;

 // 팀 토론의 팀 리스트
    public List<TeamCtgrVO> teamList(TeamCtgrVO vo) throws Exception;

    // 팀분류 조회
    public int selectTeamCtgr(TeamCtgrVO vo) throws Exception;

    // 팀구성 완료 여부 세팅
	public void setTeamSetYn(TeamVO vo) throws Exception;

	// 팀 구성된 총 인원
	public int totalTeamMember(TeamCtgrVO vo) throws Exception;
	
	// 팀분류 사용 개수
	public TeamCtgrVO teamCtgrUseCnt(TeamCtgrVO vo) throws Exception;

}
