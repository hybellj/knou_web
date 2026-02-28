package knou.lms.team.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.team.dao.TeamMemberDAO;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;

@Service("teamMemberService")
public class TeamMemberServiceImpl extends ServiceBase implements TeamMemberService {

    @Resource(name="teamMemberDAO")
    private TeamMemberDAO teamMemberDAO;

    /*****************************************************
     * <p>
     * TODO 내 소속 팀 조회
     * </p>
     * 내 소속 팀 조회
     * 
     * @param TeamMemberVO
     * @return List<TeamMemberVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<TeamMemberVO> listMyTeamStd(TeamMemberVO vo) throws Exception {
        return teamMemberDAO.listMyTeamStd(vo);
    }

    /*****************************************************
     * <p>
     * TODO 팀원 목록 조회
     * </p>
     * 팀원 목록 조회
     * 
     * @param TeamMemberVO
     * @return List<TeamMemberVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<TeamMemberVO> list(TeamMemberVO vo) throws Exception {
        return teamMemberDAO.list(vo);
    }

    // 팀원 조회
    @Override
    public List<TeamMemberVO> selectTeamMemberList(TeamVO vo) throws Exception {
        return teamMemberDAO.selectTeamMemberList(vo);
    }

    // 팀 구성된 팀원수
	@Override
	public int count(TeamVO vo) throws Exception {
		return teamMemberDAO.count(vo);
	}

	// 해당 토론의 소속팀 가져오기
	@Override
	public String getMeTeamNm(TeamMemberVO vo) throws Exception {
		return teamMemberDAO.getMeTeamNm(vo);
	}

	// 팀원 리스트
	@Override
	public String[] getTeamMemberList(TeamMemberVO vo) throws Exception {
		return teamMemberDAO.getTeamMemberList(vo);
	}
    
}
