package knou.lms.forum2.dao;

import knou.lms.forum.vo.ForumEzGraderTeamVO;
import knou.lms.forum.vo.ForumJoinUserVO;
import knou.lms.forum.vo.ForumMutVO;
import knou.lms.forum.vo.ForumVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("forum2JoinUserDAO")
public interface ForumJoinUserDAO {
    
    /*****************************************************
     * TODO 토론 현황 조회
     * @param ForumJoinUserVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectForumScoreStatus(ForumJoinUserVO vo) throws Exception;
    
    /*****************************************************
     * TODO 토론 참여 목록 조회
     * @param ForumJoinUserVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<ForumJoinUserVO> listPaging(ForumJoinUserVO vo) throws Exception;
    
    /*****************************************************
     * TODO 토론 참여 점수 저장
     * @param ForumJoinUserVO
     * @return void
     * @throws Exception
     ******************************************************/
    public int insertStdScore(ForumJoinUserVO vo) throws Exception;
    
    /*****************************************************
     * TODO 토론 참여 목록 조회
     * @param ForumJoinUserVO
     * @return List<ForumJoinUserVO>
     * @throws Exception
     ******************************************************/
    public List<ForumJoinUserVO> listStdScore(ForumJoinUserVO vo) throws Exception;
    
    /*****************************************************
     * TODO 토론 참여 정보 조회
     * @param ForumJoinUserVO
     * @return ForumJoinUserVO
     * @throws Exception
     ******************************************************/
    public ForumJoinUserVO selectForumJoinUser(ForumJoinUserVO vo) throws Exception;

    // 성적분포현황차트
    public List<?> forumJoinUserList(ForumJoinUserVO vo) throws Exception;

    // 교수 메모 팝업창 정보
    public ForumJoinUserVO selectProfMemo(ForumJoinUserVO vo) throws Exception;

    // 교수 메모 수정
    public void editForumProfMemo(ForumJoinUserVO vo) throws Exception;

    public List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception;

    public List<ForumEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo) throws Exception;

    public int getForumJoinUser(ForumJoinUserVO vo) throws Exception;

    // 메모
    public ForumJoinUserVO getMemo(ForumVO vo) throws Exception;

    // 넘겨 받은 글자수에 해당하는 토론 참여자 조회
    public int getSelectCtsLen(ForumJoinUserVO vo) throws Exception;

    // 참여자가 없을 때 토론 참여자 테이블 삽입
	public void chkStdNoInsert(ForumMutVO vo) throws Exception;

	// 모든 토론 참여자를 토론 참여자 테이블에 삽입
	public void insertJoinUser(ForumVO vo) throws Exception;

	// DSCS_PTCP 미등록 학생 목록 조회 (insertJoinUser loop용)
	public List<ForumJoinUserVO> selectStudentsNotInPtcp(ForumVO vo) throws Exception;

	// 토론참여자 단건 INSERT (PK: DSCS_PTCP_ID IdGenerator 사용)
	public int insertForumJoinUser(ForumJoinUserVO vo) throws Exception;

	// 참여형 일괄평가
	public void participateScore(ForumJoinUserVO vo) throws Exception;
	
	// 학습자 팀 수정
	public void updateStdTeam(ForumJoinUserVO vo) throws Exception;
	
	// 평가여부 초기화
    public void updateJoinUserEvalN(ForumJoinUserVO vo) throws Exception;

}
