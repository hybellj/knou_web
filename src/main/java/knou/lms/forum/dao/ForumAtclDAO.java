package knou.lms.forum.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumMutVO;
import knou.lms.forum.vo.ForumVO;

@Mapper("forumAtclDAO")
public interface ForumAtclDAO {

    // 토론 게시글 수 카운팅
    public int forumAtclCount(ForumAtclVO vo) throws Exception;

    // 토론 게시글의 검색된 수를 카운팅
    public int count(ForumAtclVO vo) throws Exception;

    // 토론 게시글의 전체 목록 조회
    public List<ForumAtclVO> listPageing(ForumAtclVO vo) throws Exception;

    // 토론 게시글 등록
    public void insertAtcl(ForumAtclVO vo) throws Exception;

    // 토론 게시글 조회
    public ForumAtclVO selectAtcl(ForumAtclVO vo) throws Exception;

    // 토론 게시글 수정
    public void updateAtcl(ForumAtclVO vo) throws Exception;

    // 토론 게시글 삭제
    public void deleteAtcl(ForumAtclVO vo) throws Exception;

    // 나의 상호평가 결과
    public ForumAtclVO selectMutResult(ForumAtclVO vo) throws Exception;

    // 특정 수강생의 토론 게시글 조회
    public List<ForumAtclVO> selectAtclUserList(ForumMutVO vo) throws Exception;

    // 토론 게시글 목록 조회
    public List<ForumAtclVO> forumAtclList(ForumAtclVO vo) throws Exception;
 
    // 본인의 토론글 등록 갯수
	public int myAtclCnt(ForumAtclVO vo) throws Exception;
	
	// 토론 게시글 엑셀목록 조회
    public List<EgovMap> forumAtclExcalList(ForumAtclVO vo) throws Exception;

}
