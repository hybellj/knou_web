package knou.lms.forum2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsFdbkVO;

import java.util.List;

public interface DscsFdbkService {

    // 피드백 조회
    public List<DscsFdbkVO> selectFdbk(DscsFdbkVO vo);
    // 피드백 등록
    public ProcessResultVO<DscsFdbkVO> insertFdbk(DscsFdbkVO vo);
    // 피드백 수정
    public ProcessResultVO<DscsFdbkVO> updateFdbk(DscsFdbkVO vo);
    // 피드백 삭제
    public ProcessResultVO<DscsFdbkVO> deleteFdbk(DscsFdbkVO vo);
    // 피드백 개수 조회
    public int cntFdbk(DscsFdbkVO vo);
}
