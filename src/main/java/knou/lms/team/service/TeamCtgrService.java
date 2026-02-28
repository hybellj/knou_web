package knou.lms.team.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamVO;

public interface TeamCtgrService {
    
    public List<TeamCtgrVO> list(TeamCtgrVO vo) throws Exception;

    // 팀 리스트 조회(토론)
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

    // 팀 분류 조회
    public ProcessResultVO<TeamCtgrVO> teamListDiv(TeamCtgrVO vo) throws Exception;

    // 팀 분류 정보
    public TeamCtgrVO selectTeamForm(TeamCtgrVO vo) throws Exception;

    // 팀 구성 삭제 - 팀원
    public void delTeamMember(TeamCtgrVO vo) throws Exception;

    // 팀 구성 삭제 - 팀
    public void delTeam(TeamCtgrVO vo) throws Exception;
    
    // 팀 구성 삭제
    public void delTeamAll(TeamCtgrVO vo) throws Exception;

    // 팀 토론의 팀 리스트
    public List<TeamCtgrVO> teamList(TeamCtgrVO vo) throws Exception;

    // 팀 조회
    public int selectTeam(TeamCtgrVO vo) throws Exception;

    // 팀구성 완료 여부 세팅
	public void setTeamSetYn(TeamVO vo) throws Exception;

	// 팀 구성된 총 인원
	public int totalTeamMember(TeamCtgrVO vo) throws Exception;

}
