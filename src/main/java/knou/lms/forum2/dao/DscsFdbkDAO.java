package knou.lms.forum2.dao;

import knou.lms.forum2.vo.DscsFdbkVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("dscsFdbkDAO")
public interface DscsFdbkDAO {

    // 피드백 목록 조회
    public List<DscsFdbkVO> selectFdbk(DscsFdbkVO vo);
    // 피드백 등록
    public void insertFdbk(DscsFdbkVO vo);
    // 피드백 수정
    public void updateFdbk(DscsFdbkVO vo);
    // 피드백 개수 조회
    public int cntFdbk(DscsFdbkVO vo);
}
