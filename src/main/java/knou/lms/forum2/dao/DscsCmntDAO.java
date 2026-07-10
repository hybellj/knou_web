package knou.lms.forum2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsCmntVO;

@Mapper("dscsCmntDAO")
public interface DscsCmntDAO {

    // 댓글 등록
    public void insertCmnt(DscsCmntVO vo);
    // 댓글 수정
    public void updateCmnt(DscsCmntVO vo);
    // 댓글 삭제
    public void deleteCmnt(DscsCmntVO vo);
    // 댓글 숨김
    public void hideCmnt(DscsCmntVO vo);
    // 댓글 목록 조회
	public List<DscsCmntVO> cmntList(DscsAtclVO vo);
    // EZ-Grader 토론 활동 댓글 목록 조회
    public List<DscsCmntVO> listEzgActivityCmnt(DscsAtclVO vo);
    // 댓글 조회
	public DscsCmntVO selectCmnt(DscsCmntVO vo);
}
