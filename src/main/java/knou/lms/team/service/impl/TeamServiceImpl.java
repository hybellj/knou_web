package knou.lms.team.service.impl;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.asmt.dao.AsmtDAO;
import knou.lms.asmt.dao.AsmtStuTeamDAO;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.forum.dao.ForumDAO;
import knou.lms.forum.dao.ForumJoinUserDAO;
import knou.lms.forum.vo.ForumJoinUserVO;
import knou.lms.forum.vo.ForumVO;
import knou.lms.team.dao.TeamCtgrDAO;
import knou.lms.team.dao.TeamDAO;
import knou.lms.team.dao.TeamMemberDAO;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service("teamService")
public class TeamServiceImpl extends ServiceBase implements TeamService {

    @Resource(name="teamDAO")
    private TeamDAO teamDAO;

    @Resource(name="teamCtgrDAO")
    private TeamCtgrDAO teamCtgrDAO;

    @Resource(name="teamMemberDAO")
    private TeamMemberDAO teamMemberDAO;

    @Resource(name="asmtDAO")
    private AsmtDAO asmtDAO;

    @Resource(name="forumDAO")
    private ForumDAO forumDAO;

    @Resource(name="asmtStuTeamDAO")
    private AsmtStuTeamDAO asmtStuTeamDAO;

    @Resource(name="forumJoinUserDAO")
    private ForumJoinUserDAO forumJoinUserDAO;

    @Override
    public List<TeamVO> list(TeamVO vo) throws Exception {
        return teamDAO.list(vo);
    }

    // 팀토론 토론방 팀리스트
    @Override
    public List<TeamVO> teamList(TeamVO vo) throws Exception {
        return teamDAO.teamList(vo);
    }

    // 팀 자동 생성
    @Override
    public void addAutoTeam(TeamVO vo) throws Exception {
        String teamCd = IdGenerator.getNewId("TEAM");

        try {
//            vo.setTeamCtgrCd(vo.getTeamCtgrCd());
            vo.setTeamCd(teamCd);

            vo.setTeamNm("TEAM" + Integer.toString(vo.getLastIndex() + 1));

            teamDAO.insert(vo);

            String[] stdNoList = StringUtil.split(vo.getStdNo(), ",");
            String[] userIdList = StringUtil.split(vo.getUserId(), ",");
            String stdRole = vo.getStdRole();

            TeamMemberVO tmVo = null;
            for(int i = 0; i < stdNoList.length; i++) {
                tmVo = new TeamMemberVO();
                tmVo.setTeamCd(teamCd);
                tmVo.setStdId(stdNoList[i]);
                tmVo.setUserId(userIdList[i]);
                tmVo.setRgtrId(vo.getRgtrId());
//                if(StringUtil.nvl(stdRole,"").equals(stdNoList[i])) {
//                    tmVo.setMemberRole("팀장");
//                    tmVo.setLeaderYn("Y");
//                }else {
                tmVo.setMemberRole("팀원");
                tmVo.setLeaderYn("N");
//                }
                teamMemberDAO.insertStd(tmVo);
            }
        } catch(Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public List<TeamVO> listTeam(TeamVO vo) throws Exception {
        return teamDAO.listTeam(vo);
    }

    @Override
    public void removeTeam(TeamVO vo) throws Exception {
        TeamCtgrVO tcVO = new TeamCtgrVO();
        try {
            vo = teamDAO.select(vo);
            tcVO.setTeamCtgrCd(vo.getTeamCtgrCd());

            teamDAO.deleteStd(vo);
            teamDAO.delete(vo);

            if(teamDAO.count(vo) <= 0) {
//                teamCtgrDAO.delete(tcVO);
            }
        } catch(Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    // 팀 정보 조회
    @Override
    public TeamVO select(TeamVO vo) throws Exception {
        TeamVO tcvo = teamDAO.select(vo);
        if(ValidationUtils.isNotEmpty(tcvo)) {
            vo = tcvo;
        } else {
            throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
        }
        return vo;
    }

    // 팀원 조회
    @Override
    public TeamVO selectTeamCtgrStd(TeamVO vo) throws Exception {
        TeamVO tcvo = teamDAO.selectTeamCtgrStd(vo);
        if(ValidationUtils.isNotEmpty(tcvo)) {
            vo = tcvo;
        } else {
            throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
        }
        return vo;
    }

    // 팀원 리스트
    @Override
    public List<TeamVO> listStd(TeamVO vo) throws Exception {
        return teamDAO.listStd(vo);
    }

    // 현재 팀원 리스트
    @Override
    public List<TeamMemberVO> teamStdList(TeamVO vo) throws Exception {
        return teamDAO.teamStdList(vo);
    }

    @Override
    public List<TeamVO> teamTeamMemberList(TeamVO vo) throws Exception {
        List<TeamVO> teamList = teamDAO.selectTeamList(vo);

        List<TeamMemberVO> mVo = null;
        for(TeamVO pVo : teamList) {
            mVo = new ArrayList<TeamMemberVO>();
            mVo = teamDAO.selectTeamMemberList(pVo);

            pVo.setTeamMemberList(mVo);
        }

        return teamList;
    }

    // 팀 추가
    @Override
    public void addTeam(TeamVO vo) throws Exception {
        TeamCtgrVO tcVO = new TeamCtgrVO();
        String crsCreCd = vo.getSubParam(); // CrsCreCd 값 
        tcVO.setCrsCreCd(crsCreCd);
        tcVO.setTeamCtgrCd(vo.getTeamCtgrCd());
        String teamCd = "";
        try {
            // 팀 추가 : 팀 추가 및 팀원 추가
            if("".equals(StringUtil.nvl(vo.getTeamCd()))) {
                teamCd = IdGenerator.getNewId("TEAM");
                vo.setTeamCd(teamCd);
                int teamCnt = teamDAO.selectLastTeamNm(vo);
                String teamNm = "";
                if(teamCnt == 0) {
                    teamNm = "TEAM1";
                } else {
                    teamNm = "TEAM" + Integer.toString(teamCnt + 1);
                }

                vo.setTeamNm(teamNm);
                teamDAO.insert(vo);
            } else { // 팀 수정 : 팀원 삭제 후 팀원 추가
                // 팀명 수정
                teamDAO.update(vo);
                teamCd = vo.getTeamCd();
                tcVO.setTeamCd(teamCd);
//                teamCtgrDAO.delTeamMember(tcVO);
                teamCtgrDAO.editDelTeamMember(tcVO);
            }

            vo.setTeamCd(teamCd);

            String[] stdNoList = StringUtil.split(vo.getStdNo(), ",");
            String[] userIdList = StringUtil.split(vo.getUserId(), ",");
            String stdRole = vo.getStdRole();

            TeamMemberVO tmVo = null;
            if(stdNoList.length > 0 && !"".equals(StringUtil.nvl(vo.getStdNo()))) {
                for(int i = 0; i < stdNoList.length; i++) {
                    tmVo = new TeamMemberVO();
                    tmVo.setTeamCd(teamCd);
                    tmVo.setStdId(stdNoList[i]);
                    tmVo.setUserId(userIdList[i]);
                    tmVo.setRgtrId(vo.getRgtrId());
                    if(StringUtil.nvl(stdRole, "").equals(stdNoList[i])) {
                        tmVo.setMemberRole("팀장");
                        tmVo.setLeaderYn("Y");
                    } else {
                        tmVo.setMemberRole("팀원");
                        tmVo.setLeaderYn("N");
                    }
                    teamMemberDAO.insertStd(tmVo);
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    // 토론 성적 분포 현황
    @Override
    public EgovMap viewScoreChart(TeamVO vo) throws Exception {
        EgovMap scoreMap = teamDAO.selectScoreChart(vo);
        return scoreMap;
    }

    // 팀 분류 코드에 해당하는 팀 분류 조회
    @Override
    public int selectTeamCtgrCd(TeamVO vo) throws Exception {
        return teamDAO.selectTeamCtgrCd(vo);
    }

    @Override
    public void setGroupConcatMaxLen() throws Exception {
        teamDAO.setGroupConcatMaxLen();
    }

    @Override
    public void updateUseTeamMember(TeamVO vo) throws Exception {
        TeamCtgrVO ctgrVO = new TeamCtgrVO();
        ctgrVO.setTeamCtgrCd(vo.getTeamCtgrCd());

        TeamMemberVO tmVO = new TeamMemberVO();
        tmVO.setTeamCtgrCd(vo.getTeamCtgrCd());
        List<TeamMemberVO> tmList = teamMemberDAO.listTeamMemberByCtgrCd(tmVO);

        // 팀분류 사용 개수 조회
        ctgrVO = teamCtgrDAO.teamCtgrUseCnt(ctgrVO);
        // 과제 학습자 팀 수정
        if(ctgrVO.getAsmntCnt() > 0) {
            AsmtVO asmtVO = new AsmtVO();
            asmtVO.setLrnGrpId(vo.getTeamCtgrCd());
            List<AsmtVO> aList = asmtDAO.listAsmntByTeamCtgrCd(asmtVO);
            for(AsmtVO avo : aList) {
                for(TeamMemberVO tvo : tmList) {
                    avo.setUserId(tvo.getStdId());
                    avo.setTeamId(tvo.getTeamCd());
                    asmtStuTeamDAO.updateStdTeam(avo);
                }
            }
        }
        // 토론 학습자 팀 수정
        if(ctgrVO.getForumCnt() > 0) {
            ForumVO forumVO = new ForumVO();
            forumVO.setTeamCtgrCd(vo.getTeamCtgrCd());
            List<ForumVO> fList = forumDAO.listForumByTeamCtgrCd(forumVO);
            for(ForumVO fvo : fList) {
                for(TeamMemberVO tvo : tmList) {
                    ForumJoinUserVO fuvo = new ForumJoinUserVO();
                    fuvo.setForumCd(fvo.getForumCd());
                    fuvo.setStdId(tvo.getStdId());
                    fuvo.setTeamCd(tvo.getTeamCd());
                    forumJoinUserDAO.updateStdTeam(fuvo);
                }
            }
        }
    }

}
