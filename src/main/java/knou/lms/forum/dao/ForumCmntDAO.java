package knou.lms.forum.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumCmntVO;

@Mapper("forumCmntDAO")
public interface ForumCmntDAO {

    // 토론 댓글 등록
    public void insertCmnt(ForumCmntVO vo) throws Exception;

    // 토론방 댓글 수정
    public void updateCmnt(ForumCmntVO vo) throws Exception;

    // 토론방 댓글 삭제
    public void deleteCmnt(ForumCmntVO vo) throws Exception;

    // 토론 댓글 목록
	public List<ForumCmntVO> cmntList(ForumAtclVO vo) throws Exception;
	
	// 토론 댓글 조회
	public ForumCmntVO forumCmntSelect(ForumCmntVO vo) throws Exception;

}
