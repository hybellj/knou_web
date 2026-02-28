package knou.lms.forum.service;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.vo.ForumVO;

public interface ForumService {

    // 토론 개수 조회
    int count(ForumVO vo) throws Exception;

    // 토론 목록 조회
    ProcessResultVO<ForumVO> list(ForumVO vo) throws Exception;

    // 토론정보 조회
    public ForumVO selectForum(ForumVO vo) throws Exception;

    // 토론정보 수정
    public void updateForum(ForumVO vo) throws Exception;

    // 토론정보 등록
    public void insertForum(ForumVO vo, HttpServletRequest request) throws Exception;
    
    // 토론정보 복사
    public void copyForum(ForumVO vo) throws Exception;

    public ProcessResultVO<ForumVO> listMyCreCrsForum(ForumVO vo) throws Exception;

    // 토론 정보 조회
    public ForumVO select(ForumVO vo) throws Exception;
    
    // 시험 토론 등록, 수정
    public ProcessResultVO<ForumVO> examForumManage(ForumVO vo, HttpServletRequest request) throws Exception;

    // 토론 삭제
    public void deleteForum(ForumVO vo) throws Exception;

    // 개설과정토론 연결 삭제
    public void deleteForumCreCrsRltn(ForumVO vo) throws Exception;

    // 토론 참여자 테이블에 수강생 등록
    void insertForumJoinUser(ForumVO vo) throws Exception;

    // 성적분포현황 BarChart
    public EgovMap viewScoreChart(ForumVO vo) throws Exception;

    // 토론 정보 조회
    public ProcessResultVO<ForumVO> viewForum(ForumVO vo) throws Exception;

    // 성적반영비율 초기화
	public void setScoreRatio(ForumVO forumVO) throws Exception;

	public String selectStdNo(ForumVO vo) throws Exception;

}
