package knou.lms.forum2.service;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.vo.*;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface ForumEzGraderService {

    // 토론 참여 대상 리스트 조회
    public abstract List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception;

    // 토론 참여 team 리스트 조회
    public abstract List<DscsEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo, String byteamDscsUseyn) throws Exception;

    // 평가점수 저장 처리
    public abstract ProcessResultVO<DefaultVO> saveEvalScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception;

    // 평가 결과 조회
    public abstract ForumEzGraderRsltVO selectEzgEvalRslt(ForumEzGraderRsltVO vo) throws Exception;

    // 평가점수 삭제 처리
    public abstract ProcessResultVO<DefaultVO> deleteEvalScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception;

    // 점수 저장 처리
    public abstract ProcessResultVO<DefaultVO> saveScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception;

    // 점수 삭제 처리
    public abstract ProcessResultVO<DefaultVO> deleteScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception;

}
