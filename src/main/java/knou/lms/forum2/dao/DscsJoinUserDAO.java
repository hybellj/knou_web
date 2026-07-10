package knou.lms.forum2.dao;

import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsVO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("dscsJoinUserDAO")
public interface DscsJoinUserDAO {

    // 토론 참여 목록 조회
    public List<DscsJoinUserVO> listPaging(DscsJoinUserVO vo);
    // 토론 참여 점수 반영
    public int insertStdScore(DscsJoinUserVO vo);
    // 토론 참여 점수 배치 반영
    public int insertStdScoreBatch(@Param("list") List<DscsJoinUserVO> list);
    // 토론 참여 점수 목록 조회
    public List<DscsJoinUserVO> listStdScore(DscsJoinUserVO vo);
    // 토론 참여 점수 대상 목록 조회
    public List<DscsJoinUserVO> listStdScoreByTargets(@Param("list") List<DscsJoinUserVO> list);
    // 글자수 기준 토론 참여자 대상 조회
    public List<DscsJoinUserVO> listCtsLenScoreTargets(@Param("list") List<DscsJoinUserVO> list, @Param("ctsLen") Long ctsLen, @Param("chkCmnt") String chkCmnt);
    // 토론 참여 정보 조회
    public DscsJoinUserVO selectDscsJoinUser(DscsJoinUserVO vo);
    // 토론 참여자 목록 조회
    public List<?> dscsJoinUserList(DscsJoinUserVO vo);
    // 교수 메모 조회
    public DscsJoinUserVO selectProfMemo(DscsJoinUserVO vo);
    // 교수 메모 수정
    public void editDscsProfMemo(DscsJoinUserVO vo);
    // 토론 참여자 미존재 시 등록
    public int ensureJoinUser(DscsJoinUserVO vo);
    // 메모 조회
    public DscsJoinUserVO getMemo(DscsVO vo);
    // 글자수 기준 토론 참여자 조회
    public int getSelectCtsLen(DscsJoinUserVO vo);
    // 기존 토론 참여자 정보 갱신
	public void updateExistingJoinUsers(DscsVO vo);
    // 미등록 학생 목록 조회
	public List<DscsJoinUserVO> selectStudentsNotInPtcp(DscsVO vo);
    // 토론 참여자 배치 등록
    public int insertDscsJoinUserBatch(@Param("list") List<DscsJoinUserVO> list);
    // 참여 여부 기준 점수 배치 반영
	public void participateScoreBatch(DscsJoinUserVO vo);
}
