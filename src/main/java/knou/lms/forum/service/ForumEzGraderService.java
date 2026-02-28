package knou.lms.forum.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.vo.ForumEzGraderQstnVO;
import knou.lms.forum.vo.ForumEzGraderRsltVO;
import knou.lms.forum.vo.ForumEzGraderTeamVO;
import knou.lms.forum.vo.ForumEzGraderVO;
import knou.lms.forum.vo.ForumJoinUserVO;

public interface ForumEzGraderService {

    // 토론 참여 대상 리스트 조회
    public abstract List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception;
    
    // 토론 참여 team 리스트 조회
    public abstract List<ForumEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo) throws Exception;
    
    // ezGrader 평가 정보 조회.
    public abstract EgovMap selectEzgEvalInfo(ForumEzGraderVO vo) throws Exception;
    
    // ezGrader 평가 문항 목록(등급 포함) 조회.
    public abstract List<ForumEzGraderQstnVO> listEzgEvalQstn(ForumEzGraderVO vo) throws Exception;
    
    // 평가점수 저장 처리.
    public abstract ProcessResultVO<DefaultVO> saveEvalScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception;
    
    // ezGrader 평가 결과 조회.
    public abstract ForumEzGraderRsltVO selectEzgEvalRslt(ForumEzGraderRsltVO vo) throws Exception;
    
    // 평가점수 삭제 처리.
    public abstract ProcessResultVO<DefaultVO> deleteEvalScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception;
    
    // 점수 저장 처리.
    public abstract ProcessResultVO<DefaultVO> saveScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception;
    
    // 점수 삭제 처리.
    public abstract ProcessResultVO<DefaultVO> deleteScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception;

}
