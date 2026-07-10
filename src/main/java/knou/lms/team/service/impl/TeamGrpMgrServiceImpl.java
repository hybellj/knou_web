package knou.lms.team.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.team.dao.TeamGrpMgrDAO;
import knou.lms.team.service.TeamGrpMgrService;
import knou.lms.team.vo.TeamGrpMgrVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("teamGrpMgrService")
public class TeamGrpMgrServiceImpl extends ServiceBase implements TeamGrpMgrService {

    @Resource(name="teamGrpMgrDAO")
    private TeamGrpMgrDAO teamGrpMgrDAO;

    /*****************************************************
     * 팀 그룹 등록
     * @param vo
     ******************************************************/
    public TeamGrpMgrVO teamGrpRegist(TeamGrpMgrVO vo) {
        // 1. 팀 그룹 등록
        vo.setTeamGrpId(IdGenUtil.genNewId(IdPrefixType.TEMGR)); // 팀 그룹 ID 생성
        teamGrpMgrDAO.teamGrpRegist(vo);

        // 2. 팀 등록
        List<TeamGrpMgrVO> teamDataList = vo.getTeamDataList();
        if (teamDataList != null) {
            for (TeamGrpMgrVO teamData : teamDataList) {
                teamData.setTeamGrpId(vo.getTeamGrpId());
                teamData.setTeamId(IdGenUtil.genNewId(IdPrefixType.TEAM)); // 팀 ID 생성
                teamData.setRgtrId(vo.getRgtrId());
                teamData.setSbjctId(vo.getSbjctId());
                teamGrpMgrDAO.teamRegist(teamData);

                // 3. 팀 멤버 등록
                String teamListStr  = StringUtil.nvl(teamData.getTeamList());
                String ldrynListStr = StringUtil.nvl(teamData.getLdrynList());
                if (!teamListStr.isEmpty()) {
                    String[] userIds  = teamListStr.split(",");
                    String[] ldrynArr = ldrynListStr.isEmpty() ? new String[0] : ldrynListStr.split(",");
                    for (int i = 0; i < userIds.length; i++) {
                        teamData.setTeamMbrId(IdGenUtil.genNewId(IdPrefixType.TEMBR)); // 팀 멤버 ID 생성
                        teamData.setUserId(userIds[i].trim());
                        teamData.setLdryn(i < ldrynArr.length ? ldrynArr[i].trim() : "N");
                        teamGrpMgrDAO.teamMbrRegist(teamData);
                    }
                }
            }
        }
        return vo;
    }

    /*****************************************************
     * 팀 그룹 목록 페이징
     * @param vo
     * @return ProcessResultVO<TeamGrpMgrVO>
     ******************************************************/
    @Override
    public ProcessResultVO<TeamGrpMgrVO> listTeamGrpPaging(TeamGrpMgrVO vo) {
        ProcessResultVO<TeamGrpMgrVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = teamGrpMgrDAO.countTeamGrp(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<TeamGrpMgrVO> resultList = teamGrpMgrDAO.listTeamGrpPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 수강생 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listAtndlcUser(TeamGrpMgrVO vo) {
        return teamGrpMgrDAO.listAtndlcUser(vo);
    }

    /*****************************************************
     * 수강생 목록 카운트
     * @param vo
     * @return int
     ******************************************************/
    public int countAtndlcUser(TeamGrpMgrVO vo) {
        return teamGrpMgrDAO.countAtndlcUser(vo);
    }

    /*****************************************************
     * 팀 및 팀원 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listTeamAndMbr(TeamGrpMgrVO vo) {
        return teamGrpMgrDAO.listTeamAndMbr(vo);
    }

    /**
     * 학습자 팀 식별자(ID) 조회 및 검증
     * @param teamGrpId
     * @param userId
     * @return
     * @throws Exception
     */
    @Override
    public String findLearnerTeamId(String teamGrpId, String userId) {
        TeamGrpMgrVO vo = new TeamGrpMgrVO();
        vo.setTeamGrpId(teamGrpId);
        vo.setUserId(userId);
        return StringUtil.nvl(teamGrpMgrDAO.findLearnerTeamId(vo));
    }

    /**
     * 특정 팀의 소속 여부 및 인원 확인
     * @param teamId
     * @param userId
     * @return
     * @throws Exception
     */
    @Override
    public boolean isUserInTeam(String teamId, String userId) {
        TeamGrpMgrVO vo = new TeamGrpMgrVO();
        vo.setTeamId(teamId);
        vo.setUserId(userId);
        return teamGrpMgrDAO.countUserInTeam(vo) > 0;
    }

    /**
     * 팀원 목록 조회
     * @param teamId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> listTeamMembers(String teamId) {
        TeamGrpMgrVO vo = new TeamGrpMgrVO();
        vo.setTeamId(teamId);
        return teamGrpMgrDAO.listTeamMembers(vo);
    }

    /*****************************************************
     * 팀 그룹 수정
     * @param vo
     ******************************************************/
    public void updateTeamGrpInfo(TeamGrpMgrVO vo) {
        // 1. 팀 멤버 전체 삭제
        teamGrpMgrDAO.deleteTeamMbr(vo);
        List<TeamGrpMgrVO> teamDataList = vo.getTeamDataList();

        switch (vo.getUsingyn()) {
            // Case A. 팀 그룹이 사용중일 때
            case "Y" :
                // A-2. 팀 수정 반복문
                for (TeamGrpMgrVO teamData : teamDataList) {
                    teamData.setTeamGrpId(vo.getTeamGrpId());
                    teamData.setRgtrId(vo.getRgtrId());
                    teamData.setSbjctId(vo.getSbjctId());
                    teamData.setMdfrId(vo.getMdfrId());
                    // A-3. 팀 수정
                    teamGrpMgrDAO.updateTeamInfo(teamData);

                    // A-4. teamList, ldrynList 콤마 분리
                    String teamListStr  = StringUtil.nvl(teamData.getTeamList());
                    String ldrynListStr = StringUtil.nvl(teamData.getLdrynList());
                    String[] userIds  = teamListStr.split(",");
                    String[] ldrynArr = ldrynListStr.isEmpty() ? new String[0] : ldrynListStr.split(",");
                    // A-5. 팀 멤버 등록 반복문
                    for (int i = 0; i < userIds.length; i++) {
                        teamData.setTeamMbrId(IdGenUtil.genNewId(IdPrefixType.TEMBR)); // 팀 멤버 ID 생성
                        teamData.setUserId(userIds[i].trim());
                        teamData.setLdryn(i < ldrynArr.length ? ldrynArr[i].trim() : "N");
                        // A-6. 팀 멤버 등록
                        teamGrpMgrDAO.teamMbrRegist(teamData);
                    }
                }
                // A-7. 팀 그룹 수정
                teamGrpMgrDAO.updateTeamGrpInfo(vo);

                break;
            // Case B. 팀 그룹이 미사용일 때
            case "N" :
                // B-2. 팀 전체 삭제
                teamGrpMgrDAO.deleteTeam(vo);

                // B-3. 팀 그룹 수정
                teamGrpMgrDAO.updateTeamGrpInfo(vo);

                // B-4. 팀 등록 반복문
                for (TeamGrpMgrVO teamData : teamDataList) {
                    teamData.setTeamGrpId(vo.getTeamGrpId());
                    teamData.setTeamId(IdGenUtil.genNewId(IdPrefixType.TEAM)); // 팀 ID 생성
                    teamData.setRgtrId(vo.getRgtrId());
                    teamData.setSbjctId(vo.getSbjctId());
                    teamData.setMdfrId(vo.getMdfrId());
                    // B-5. 팀 등록
                    teamGrpMgrDAO.teamRegist(teamData);

                    // B-6. teamList, ldrynList 콤마 분리
                    String teamListStr  = StringUtil.nvl(teamData.getTeamList());
                    String ldrynListStr = StringUtil.nvl(teamData.getLdrynList());
                    String[] userIds  = teamListStr.split(",");
                    String[] ldrynArr = ldrynListStr.isEmpty() ? new String[0] : ldrynListStr.split(",");
                    // B-7. 팀 멤버 등록 반복문
                    for (int i = 0; i < userIds.length; i++) {
                        teamData.setTeamMbrId(IdGenUtil.genNewId(IdPrefixType.TEMBR)); // 팀 멤버 ID 생성
                        teamData.setUserId(userIds[i].trim());
                        teamData.setLdryn(i < ldrynArr.length ? ldrynArr[i].trim() : "N");
                        // B-8. 팀 멤버 등록
                        teamGrpMgrDAO.teamMbrRegist(teamData);
                    }
                }
                break;
        }
    }

    /*****************************************************
     * 팀 그룹 삭제
     * @param vo
     ******************************************************/
    public void updateTeamGrpDelyn(TeamGrpMgrVO vo) {
        // 팀 그룹 삭제 (논리삭제)
        teamGrpMgrDAO.updateTeamGrpDelyn(vo);
        // 팀 멤버 삭제
        teamGrpMgrDAO.deleteTeamMbr(vo);
        // 팀 삭제
        teamGrpMgrDAO.deleteTeam(vo);
    }
}
