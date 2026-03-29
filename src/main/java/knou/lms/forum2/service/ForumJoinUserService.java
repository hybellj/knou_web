package knou.lms.forum2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.vo.ForumEzGraderTeamVO;
import knou.lms.forum.vo.ForumJoinUserVO;
import knou.lms.forum.vo.ForumMutVO;
import knou.lms.forum.vo.ForumVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface ForumJoinUserService {

    /*****************************************************
     * TODO 토론 현황 조회
     * @param ForumJoinUserVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectForumScoreStatus(ForumJoinUserVO vo) throws Exception;
    
    /*****************************************************
     * 토론 참여 목록 조회
     * @param ForumJoinUserVO
     * @return List<ForumJoinUserVO>
     * @throws Exception
     ******************************************************/
    public List<ForumJoinUserVO> list(ForumJoinUserVO vo) throws Exception;
    
    /*****************************************************
     * 토론 참여 목록 조회
     * @param ForumJoinUserVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ForumJoinUserVO> listPaging(ForumJoinUserVO vo, String byteamDscsUseyn) throws Exception;
    
    /*****************************************************
     * 토론 참여 성적 반영
     * @param ForumJoinUserVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateForumJoinUserScore(ForumJoinUserVO vo) throws Exception;
    
    /*****************************************************
     * TODO 토론 참여 정보 조회
     * @param ForumJoinUserVO
     * @return ForumJoinUserVO
     * @throws Exception
     ******************************************************/
    public ForumJoinUserVO selectForumJoinUser(ForumJoinUserVO vo) throws Exception;

    // 성적분포현황차트
    public List<?> forumJoinUserList(ForumJoinUserVO vo) throws Exception;

    // 성적평가 성적 등록
    public void addStdScore(ForumJoinUserVO vo) throws Exception;

    // 교수 메모 팝업창 정보
    public ForumJoinUserVO selectProfMemo(ForumJoinUserVO vo) throws Exception;

    // 교수 메모 수정
    public void editForumProfMemo(ForumJoinUserVO vo) throws Exception;

    // 토론 참여자 페이징 목록 조회
    public ProcessResultVO<ForumJoinUserVO> listPageing(ForumJoinUserVO vo) throws Exception;

    // 엑셀 성적등록 엑셀 업로드
    public void updateExampleExcelScore(ForumJoinUserVO vo, List<?> stdNoList, String forumCtgrCd) throws Exception;

    public List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception;

    public List<ForumEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo) throws Exception;

    // 메모
    public ForumJoinUserVO getMemo(ForumVO vo) throws Exception;

    // 글자수로 점수 주기
    public void updateForumJoinUserLenScore(ForumJoinUserVO vo) throws Exception;

    // 참여자가 없을 때 토론 참여자 테이블 삽입
	public void chkStdNoInsert(ForumMutVO vo) throws Exception;

	// 모든 토론 참여자를 토론 참여자 테이블에 삽입
	public void insertJoinUser(ForumVO vo) throws Exception;

	// 참여형 일괄평가
	public void participateScore(ForumJoinUserVO vo) throws Exception;

	// 개별 평가점수
	public void setScoreRatio(ForumJoinUserVO vo) throws Exception;

}
