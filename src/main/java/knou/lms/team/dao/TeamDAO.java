package knou.lms.team.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;

@Mapper("teamDAO")
public interface TeamDAO {

    public List<TeamVO> list(TeamVO vo) throws Exception;

    // 팀토론 토론방 팀리스트
    public List<TeamVO> teamList(TeamVO vo) throws Exception;

    // 팀 마지막 이름 조회
    public int selectLastTeamNm(TeamVO vo) throws Exception;

    // 팀 등록
    public void insert(TeamVO vo) throws Exception;

    // 팀원 등록
    public void insertStd(TeamVO vo) throws Exception;

    // 팀 리스트
    public List<TeamVO> listTeam(TeamVO vo) throws Exception;

    // 팀 정보 조회
    public TeamVO select(TeamVO vo) throws Exception;

    // 팀원 삭제
    public void deleteStd(TeamVO vo) throws Exception;

    // 팀 삭제
    public void delete(TeamVO vo) throws Exception;

    // 팀 정보의 전체 카운트
    public int count(TeamVO vo) throws Exception;

    // 팀원 조회
    public TeamVO selectTeamCtgrStd(TeamVO vo) throws Exception;

    public List<TeamVO> listStd(TeamVO vo) throws Exception;

    public List<TeamMemberVO> teamStdList(TeamVO vo) throws Exception;
    
    public List<TeamVO> selectTeamList(TeamVO vo) throws Exception;

    public List<TeamMemberVO> selectTeamMemberList(TeamVO pVo) throws Exception;

    // 토론 성적 분포 현황
    public EgovMap selectScoreChart(TeamVO vo) throws Exception;

    // 팀 분류 코드에 해당하는 팀 분류 조회
    public int selectTeamCtgrCd(TeamVO vo) throws Exception;

    // group_concat함수 최대 길이 세팅
	public void setGroupConcatMaxLen() throws Exception;
	
	public void update(TeamVO vo) throws Exception;

}
