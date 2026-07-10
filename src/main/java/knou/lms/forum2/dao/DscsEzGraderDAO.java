package knou.lms.forum2.dao;

import knou.lms.forum2.vo.DscsEzGraderRsltVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("dscsEzGraderDAO")
public interface DscsEzGraderDAO {

    // 토론 참여자 리스트 조회
    public List<DscsJoinUserVO> listDscsJoinUser(DscsJoinUserVO vo);
    // 토론 참여 팀 리스트 조회
    public List<DscsEzGraderTeamVO> listDscsJoinTeam(DscsJoinUserVO vo);
    // 토론 참여자 평가 점수 부여
    public void updateJoinUserScore(DscsEzGraderRsltVO vo);
    // 팀 전체 평가 점수 삭제
    public void deleteTeamStdScore(DscsEzGraderRsltVO vo);
    // 팀 전체 초기 평가 점수 부여
    public void insertStdScoreToAllTeamMember(DscsEzGraderRsltVO vo);
    // 평가 결과 조회
    public DscsEzGraderRsltVO selectEzgEvalRslt(DscsEzGraderRsltVO vo);
    // 팀 전체 점수 초기화
    public void initStdScoreToAllTeamMember(DscsEzGraderRsltVO vo);
}
