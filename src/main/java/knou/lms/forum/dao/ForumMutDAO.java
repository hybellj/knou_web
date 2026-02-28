package knou.lms.forum.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.forum.vo.ForumMutVO;

@Mapper("forumMutDAO")
public interface ForumMutDAO {

    // 나의 상호평가 결과
    public ForumMutVO selectMutResult(ForumMutVO vo) throws Exception;

    // 상호평가 등록
    public int forumMutInsert(ForumMutVO vo) throws Exception;

    // 상호평가 수정
    public int forumMutUpdate(ForumMutVO vo) throws Exception;

    // 상호평가 조회
    public ForumMutVO selectMut(ForumMutVO vo) throws Exception;
    
    // 상호평가 목록 조회
    public List<ForumMutVO> selectForumMutResultList(ForumMutVO vo) throws Exception;

}
