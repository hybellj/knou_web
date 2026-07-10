package knou.lms.forum2.service;

import java.util.Map;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsVO;

public interface DscsAtclService {

    // 학습자 토론 게시글 목록을 조회한다.
    public ProcessResultVO<DscsAtclVO> stdntAtclList(DscsVO dscsVO, String userId);
    // 교수자 토론 게시글 목록을 조회한다.
    public ProcessResultVO<DscsAtclVO> profAtclList(DscsVO dscsVO);
    // 교수자 토론 게시글을 등록한다.
    public ProcessResultVO<DefaultVO> profAtclRegist(DscsAtclVO vo, String teamId, String userId);
    // 학습자 토론 게시글을 등록한다.
    public ProcessResultVO<DefaultVO> stdntAtclRegist(DscsAtclVO vo, String teamId, String userId);
    // 교수자 토론 게시글을 수정한다.
    public ProcessResultVO<DefaultVO> profAtclModify(DscsAtclVO vo, String userId);
    // 학습자 토론 게시글을 수정한다.
    public ProcessResultVO<DefaultVO> stdntAtclModify(DscsAtclVO vo, String teamId, String userId);
    // 교수자 토론 게시글을 삭제한다.
    public ProcessResultVO<DefaultVO> profAtclDelete(DscsAtclVO vo, String userId);
    // 학습자 토론 게시글을 삭제한다.
    public ProcessResultVO<DefaultVO> stdntAtclDelete(DscsAtclVO vo, String teamId, String userId);
    // 교수자 토론 게시글을 숨김 처리한다.
    public ProcessResultVO<DefaultVO> profAtclHide(DscsAtclVO vo, String userId);
    // 본인 게시글 작성 상태를 조회한다.
    public DscsAtclVO selectMyAtclStatus(DscsAtclVO vo);
    // EZ-Grader 토론 활동 그룹 목록 조회
    public ProcessResultVO<Map<String, Object>> listEzgActivity(DscsAtclVO vo);
}
