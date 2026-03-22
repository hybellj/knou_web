package knou.lms.forum2.dao;

import knou.lms.forum.vo.*;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("forum2EzGraderDAO")
public interface ForumEzGraderDAO {

    // 토론 참여 대상 리스트 조회
    public List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception;

    // 토론 참여 team 리스트 조회
    public List<ForumEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo) throws Exception;

    // 평가 정보 조회.
    public EgovMap selectEzgEvalInfo(ForumEzGraderVO vo) throws Exception;

    // 평가 문항 목록(등급 포함) 조회.
    public List<ForumEzGraderQstnVO> listEzgEvalQstn(ForumEzGraderVO vo) throws Exception;

    // 평가점수 등록
    public void insertEvalRslt(ForumEzGraderRsltVO vo) throws Exception;

    // 평가점수  수정
    public void updateEvalRslt(ForumEzGraderRsltVO vo) throws Exception;

    // 팀원 모두에게 평가점수 등록
    public void insertEvalRsltToAllTeamMember(ForumEzGraderRsltVO vo) throws Exception;

    // 토론 참여 유저(미제출자 포함)에 평가점수 부여
    public void updateJoinUserScore(ForumEzGraderRsltVO vo) throws Exception;

    // 팀원 총 평가점수  삭제
    public void deleteTeamStdScore(ForumEzGraderRsltVO vo) throws Exception;

    // 팀원 모두에게 총  평가점수 부여
    public void insertStdScoreToAllTeamMember(ForumEzGraderRsltVO vo) throws Exception;

    // 평가 결과 조회
    public ForumEzGraderRsltVO selectEzgEvalRslt(ForumEzGraderRsltVO vo) throws Exception;

    // 문항별 배점 총합 조회
    public ForumEzGraderQstnVO selectSumAllotScore(ForumEzGraderRsltVO vo) throws Exception;

    // 팀원에 부여된 초기 점수 조회
    public List<ForumEzGraderRsltVO> listTeamMeberInitScore(ForumEzGraderRsltVO vo) throws Exception;

    // 팀원 모두에게 문항별 평가한 내용을 토대로 총  평가점수 부여 (점수 초기화)
    public void initStdScoreToAllTeamMember(ForumEzGraderRsltVO paramVO) throws Exception;

}
