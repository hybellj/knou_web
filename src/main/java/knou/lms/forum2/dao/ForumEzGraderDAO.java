package knou.lms.forum2.dao;

import knou.lms.forum.vo.*;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("forum2EzGraderDAO")
public interface ForumEzGraderDAO {

    // 토론 참여 대상 리스트 조회
    public List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception;

    // 토론 참여 team 리스트 조회
    public List<ForumEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo) throws Exception;

    // 토론 참여 유저(미제출자 포함)에 평가점수 부여
    public void updateJoinUserScore(ForumEzGraderRsltVO vo) throws Exception;

    // 팀원 총 평가점수 삭제
    public void deleteTeamStdScore(ForumEzGraderRsltVO vo) throws Exception;

    // 팀원 모두에게 총 평가점수 부여
    public void insertStdScoreToAllTeamMember(ForumEzGraderRsltVO vo) throws Exception;

    // 평가 결과 조회 (TB_LMS_DSCS_PTCP)
    public ForumEzGraderRsltVO selectEzgEvalRslt(ForumEzGraderRsltVO vo) throws Exception;

    // 팀원 모두에게 점수 초기화
    public void initStdScoreToAllTeamMember(ForumEzGraderRsltVO vo) throws Exception;

}
