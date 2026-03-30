package knou.lms.forum2.service.impl;

import knou.framework.util.IdGenerator;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.ForumEzGraderDAO;
import knou.lms.forum2.dao.Forum2DAO;
import knou.lms.forum2.service.ForumEzGraderService;
import knou.lms.forum.vo.*;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import knou.lms.forum2.vo.Forum2TeamDscsVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Service("forum2EzGraderService")
public class ForumEzGraderServiceImpl extends EgovAbstractServiceImpl implements ForumEzGraderService {

    @Resource(name = "forum2EzGraderDAO")
    private ForumEzGraderDAO forumEzGraderDAO;

    @Resource(name = "forum2DAO")
    private Forum2DAO forum2DAO;

    // 토론 참여 대상 리스트 조회
    @Override
    public List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception {
        return forumEzGraderDAO.listForumJoinUser(vo);
    }

    // 토론 참여 대상 TEAM 조회
    @Override
    public List<DscsEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo, String byteamDscsUseyn) throws Exception {
        List<DscsEzGraderTeamVO> memberList;

        if ("Y".equals(byteamDscsUseyn)) {
            // 팀별부토론: 부모 forumCd로 자식 토론 목록 조회 후 자식 DSCS_ID별로 팀원 조회
            List<Forum2TeamDscsVO> childList = forum2DAO.selectTeamDscsList(vo.getForumCd());
            memberList = new ArrayList<>();
            if (childList != null) {
                for (Forum2TeamDscsVO child : childList) {
                    ForumJoinUserVO childVo = new ForumJoinUserVO();
                    childVo.setForumCd(child.getDscsId());
                    childVo.setCrsCreCd(vo.getCrsCreCd());
                    childVo.setSearchKey(vo.getSearchKey());
                    childVo.setSearchSort(vo.getSearchSort());
                    List<DscsEzGraderTeamVO> partial = forumEzGraderDAO.listForumJoinTeam(childVo);
                    if (partial != null) memberList.addAll(partial);
                }
            }
        } else {
            memberList = forumEzGraderDAO.listForumJoinTeam(vo);
        }

        if (memberList != null && !memberList.isEmpty()) {
            for (DscsEzGraderTeamVO teamVo : memberList) {
                String teamStdIds = "";
                if (teamVo.getTeamMembers() != null && !teamVo.getTeamMembers().isEmpty()) {
                    int idx = 0;
                    for (ForumJoinUserVO joinUserVo : teamVo.getTeamMembers()) {
                        if (idx > 0) {
                            teamStdIds += ",";
                        }
                        teamStdIds += joinUserVo.getStdId();
                        idx++;
                    }
                }
                teamVo.setTeamStdIds(teamStdIds);
            }
        }
        return memberList;
    }

    // 평가점수 저장 처리 (TB_LMS_DSCS_PTCP 직접 저장)
    @Override
    public ProcessResultVO<DefaultVO> saveEvalScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        // 문항별 점수 합산 (evalScores가 @# 구분자로 전달된 경우)
        if (vo.getEvalScores() != null && !"".equals(vo.getEvalScores())) {
            String[] arrEvalScore = vo.getEvalScores().split("@#");
            int evalTotal = 0;
            for (String score : arrEvalScore) {
                evalTotal += Integer.parseInt(score);
            }
            vo.setEvalTotal(evalTotal);
            vo.setEvalScore(evalTotal);
        }

        // 점수 저장
        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            // 개인: TB_LMS_DSCS_PTCP MERGE
            String newForumSendCd = IdGenerator.getNewId("SEND");
            vo.setForumSendCd(newForumSendCd);
            vo.setEvalYn("Y");
            forumEzGraderDAO.updateJoinUserScore(vo);
        } else {
            // 팀: 팀원 전체에 동일 점수 부여
            forumEzGraderDAO.deleteTeamStdScore(vo);
            forumEzGraderDAO.insertStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 평가 결과 조회 (TB_LMS_DSCS_PTCP)
    @Override
    public ForumEzGraderRsltVO selectEzgEvalRslt(ForumEzGraderRsltVO vo) throws Exception {
        return forumEzGraderDAO.selectEzgEvalRslt(vo);
    }

    // 평가점수 삭제 처리 (점수를 0으로 초기화)
    @Override
    public ProcessResultVO<DefaultVO> deleteEvalScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            // 개인: 점수 0, evalYn=N으로 초기화
            vo.setEvalYn("N");
            vo.setEvalScore(0);
            vo.setForumSendCd("");
            forumEzGraderDAO.updateJoinUserScore(vo);
        } else {
            // 팀: 팀원 전체 점수 0으로 초기화
            vo.setEvalScore(0);
            forumEzGraderDAO.initStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 점수 저장 처리
    @Override
    public ProcessResultVO<DefaultVO> saveScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            String newForumSendCd = IdGenerator.getNewId("SEND");
            vo.setForumSendCd(newForumSendCd);
            vo.setEvalYn("Y");
            forumEzGraderDAO.updateJoinUserScore(vo);
        } else {
//            forumEzGraderDAO.deleteTeamStdScore(vo);
            forumEzGraderDAO.insertStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 점수 삭제 처리 (점수를 0으로 초기화)
    @Override
    public ProcessResultVO<DefaultVO> deleteScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            // 평가완료되었는지 조회
            vo.setEvalUserId(vo.getRgtrId());
            ForumEzGraderRsltVO rsltVo = forumEzGraderDAO.selectEzgEvalRslt(vo);
            if (rsltVo == null) {
                resultVo.setReturnVO(vo);
                resultVo.setResult(1);
                return resultVo;
            }

            // 평가점수를 0으로 업데이트. evalYn = N으로 업데이트
            vo.setEvalYn("N");
            vo.setEvalScore(0);
            vo.setForumSendCd("");
            forumEzGraderDAO.updateJoinUserScore(vo);
        } else {
            // 팀: 팀원 전체 점수 0으로 초기화
            vo.setEvalScore(0);
            forumEzGraderDAO.initStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }
}
