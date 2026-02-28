package knou.lms.team.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.ValidationUtils;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.team.dao.TeamCtgrDAO;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamVO;

@Service("teamCtgrService")
public class TeamCtgrServiceImpl extends ServiceBase implements TeamCtgrService {

    @Resource(name = "teamCtgrDAO")
    private TeamCtgrDAO teamCtgrDAO;

    @Override
    public List<TeamCtgrVO> list(TeamCtgrVO vo) throws Exception {
        return teamCtgrDAO.list(vo);
    }

    // 팀 리스트 조회(토론)
    @Override
    public TeamCtgrVO select(TeamCtgrVO vo) throws Exception {
//        int teamCnt = teamCtgrDAO.selectTeamCtgr(vo);
//        if(teamCnt == 0) {
//            // 팀 분류 테이블에 등록
//            teamCtgrDAO.insertTeamCtgr(vo);
//        }
        
        TeamCtgrVO tcvo = teamCtgrDAO.select(vo);
        if(ValidationUtils.isNotEmpty(tcvo)) {
            vo = tcvo;
        } else {
            throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
        }
        return vo;
    }


    /*****************************************************
     * <p>
     * TODO 팀 배정 완료된 팀 분류 목록
     * </p>
     * 팀 배정 완료된 팀 분류 목록
     * 
     * @param TeamCtgrVO
     * @return List<TeamCtgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<TeamCtgrVO> listComplateTeamByCrsCreCd(TeamCtgrVO vo) throws Exception {
        return teamCtgrDAO.listComplateTeamByCrsCreCd(vo);
    }

    // 팀 분류 등록
    @Override
    public void insertTeamCtgr(TeamCtgrVO vo) throws Exception {
        teamCtgrDAO.insertTeamCtgr(vo);
    }

    // 팀 분류 수정
    @Override
    public void updateTeamCtgr(TeamCtgrVO vo) throws Exception {
        teamCtgrDAO.updateTeamCtgr(vo);
    }

    // 팀 분류 조회
    @Override
    public ProcessResultVO<TeamCtgrVO> teamListDiv(TeamCtgrVO vo) throws Exception {
        
        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
 
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<TeamCtgrVO> teamList = teamCtgrDAO.teamListDiv(vo);
        
        if(teamList.size() > 0) {
            paginationInfo.setTotalRecordCount(teamList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<TeamCtgrVO> returnVO = new ProcessResultVO<>();
        
        returnVO.setReturnList(teamList);
        returnVO.setPageInfo(paginationInfo);
        
        return returnVO;
    }

    // 팀 분류 정보
    @Override
    public TeamCtgrVO selectTeamForm(TeamCtgrVO vo) throws Exception {
        return teamCtgrDAO.selecTeamForm(vo);
    }

    // 팀 구성 삭제 - 팀원
    @Override
    public void delTeamMember(TeamCtgrVO vo) throws Exception {
        teamCtgrDAO.delTeamMember(vo);
    }

    // 팀 구성 삭제 - 팀
    @Override
    public void delTeam(TeamCtgrVO vo) throws Exception {
        teamCtgrDAO.delTeam(vo);
    }

    // 팀 구성 삭제
    @Override
    public void delTeamAll(TeamCtgrVO vo) throws Exception {
        teamCtgrDAO.delTeamMember(vo);
        teamCtgrDAO.delTeam(vo);
        teamCtgrDAO.delete(vo);
    }

    // 팀 토론의 팀 리스트
    @Override
    public List<TeamCtgrVO> teamList(TeamCtgrVO vo) throws Exception {
        return teamCtgrDAO.teamList(vo);
    }

    @Override
    public int selectTeam(TeamCtgrVO vo) throws Exception {
        return teamCtgrDAO.selectTeam(vo);
    }

    // 팀구성 완료 여부 세팅
	@Override
	public void setTeamSetYn(TeamVO vo) throws Exception {
		teamCtgrDAO.setTeamSetYn(vo);
	}

	// 팀 구성된 총 인원
	@Override
	public int totalTeamMember(TeamCtgrVO vo) throws Exception {
		return teamCtgrDAO.totalTeamMember(vo);
	}

}
