package knou.lms.forum2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.forum2.vo.DscsAtclVO;

@Mapper("dscsAtclDAO")
public interface DscsAtclDAO {

    // 게시글 목록 수 조회
    public int count(DscsAtclVO vo);
    // 게시글 페이징 목록 조회
    public List<DscsAtclVO> listPageing(DscsAtclVO vo);
    // 게시글 등록
    public void insertAtcl(DscsAtclVO vo);
    // 게시글 단건 조회
    public DscsAtclVO selectAtcl(DscsAtclVO vo);
    // 게시글 수정
    public void updateAtcl(DscsAtclVO vo);
    // 게시글 삭제 처리
    public void deleteAtcl(DscsAtclVO vo);
    // 게시글 숨김 처리
    public void hideAtcl(DscsAtclVO vo);
    // 본인 게시글 작성 상태 조회
    public DscsAtclVO selectMyAtclStatus(DscsAtclVO vo);
    // EZ-Grader 토론 활동 게시글 목록 조회
    public List<DscsAtclVO> listEzgActivityAtcl(DscsAtclVO vo);
    // 본인 토론글 등록 수 조회
    public int myAtclCnt(DscsAtclVO vo);
}
