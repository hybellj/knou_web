package knou.lms.forum.service;

import java.util.List;

import knou.lms.forum.vo.ForumCmntVO;

public interface ForumCmntService {

    // 토론 댓글 등록
    public void insertCmnt(ForumCmntVO vo) throws Exception;

    // 토론방 댓글 수정
    public void updateCmnt(ForumCmntVO vo) throws Exception;

    // 토론방 댓글 삭제
    public void deleteCmnt(ForumCmntVO vo) throws Exception;
    
    // 토론 댓글 조회
    public ForumCmntVO forumCmntSelect(ForumCmntVO vo) throws Exception;

}
