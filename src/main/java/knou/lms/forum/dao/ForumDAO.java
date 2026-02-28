package knou.lms.forum.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.forum.vo.ForumVO;

@Mapper("forumDAO")
public interface ForumDAO {

    // 토론 개수 조회
    public int count(ForumVO vo) throws Exception;

    // 토론정보 전체 목록 조회
    public List<ForumVO> list(ForumVO vo) throws Exception;

    // 토론정보 조회
    public ForumVO selectForum(ForumVO vo) throws Exception;

    // 토론정보 수정
    public void updateForum(ForumVO vo) throws Exception;

    // 토론정보 등록
    public void insertForum(ForumVO vo) throws Exception;
    
    // 토론정보 복사
    public void copyForum(ForumVO vo) throws Exception;

    // 토론팀 연결 조회
    public ForumVO selectTeamRltn(ForumVO vo) throws Exception;

    // 토론팀 연결 삭제
    public void insertTeamCopyPrcs(ForumVO vo) throws Exception;

    public void updatePrcsStatusCd(ForumVO vo) throws Exception;

    public void deleteTeamRltn(ForumVO beforeTeamRltn) throws Exception;

    // 토론 정보 조회
    public ForumVO select(ForumVO vo) throws Exception;

    // 내 강의에 등록된 토론 목록 조회
    public List<ForumVO> listMyCreCrsForum(ForumVO vo) throws Exception;

    // 토론 삭제
    public void deleteForum(ForumVO vo) throws Exception;

    // 
    public void deleteForumCreCrsRltn(ForumVO vo);

    // 토론 참여자 테이블에 수강생 등록
    public void insertForumJoinUser(ForumVO vo) throws Exception;

    // 성적분포현황 BarChart
    public EgovMap selectScoreChart(ForumVO vo) throws Exception;

    // 토론정보 조회
    public ForumVO viewForum(ForumVO vo) throws Exception;

    // 메모
    public ForumVO getMemo(ForumVO vo) throws Exception;

	// 성적반영비율 토론 리스트
	public List<ForumVO> getScoreRatio(ForumVO vo) throws Exception;

    // 성적반영비율 초기화
	public void setScoreRatio(ForumVO vo) throws Exception;

	public String selectStdNo(ForumVO vo) throws Exception;
	
	// 팀 분류코드와 연결된 토론 목록 조회
	public List<ForumVO> listForumByTeamCtgrCd(ForumVO vo) throws Exception;
	
}