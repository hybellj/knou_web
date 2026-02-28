package knou.lms.forum.service;

import java.util.List;

import knou.lms.forum.vo.ForumMutVO;

public interface ForumMutService {

    // 나의 상호평가 결과
    public ForumMutVO selectMutResult(ForumMutVO vo) throws Exception;

    // 상호평가 등록
    public void forumMutInsert(ForumMutVO vo) throws Exception;

    // 상호평가 수정
    public void forumMutUpdate(ForumMutVO vo) throws Exception;

    // 상호평가 조회
    public ForumMutVO selectMut(ForumMutVO vo) throws Exception;
    
    // 상호평가 목록 조회
    public List<ForumMutVO> selectForumMutResultList(ForumMutVO vo) throws Exception;

}
