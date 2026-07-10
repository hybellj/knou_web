package knou.lms.forum2.service;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsCmntVO;

public interface DscsCmntService {

    // 교수자 토론 댓글을 등록한다.
    public ProcessResultVO<DefaultVO> profCmntRegist(DscsCmntVO vo, String userId);
    // 교수자 토론 댓글을 수정한다.
    public ProcessResultVO<DefaultVO> profCmntModify(DscsCmntVO vo, String userId);
    // 교수자 토론 댓글을 삭제한다.
    public ProcessResultVO<DefaultVO> profCmntDelete(DscsCmntVO vo, String userId);
    // 교수자 토론 댓글을 숨김 처리한다.
    public ProcessResultVO<DefaultVO> profCmntHide(DscsCmntVO vo, String userId);
    // 학습자 토론 댓글을 등록한다.
    public ProcessResultVO<DefaultVO> stdntCmntRegist(DscsCmntVO vo, String teamId, String userId);
    // 학습자 토론 댓글을 수정한다.
    public ProcessResultVO<DefaultVO> stdntCmntModify(DscsCmntVO vo, String userId);
    // 학습자 토론 댓글을 삭제한다.
    public ProcessResultVO<DefaultVO> stdntCmntDelete(DscsCmntVO vo, String userId);

}
