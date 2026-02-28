package knou.lms.asmt.service;

import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;

public interface AsmtStuService {

    // 과제 조회
    public ProcessResultVO<AsmtVO> selectAsmnt(AsmtVO vo) throws Exception;

    // 단건 조회
    public ProcessResultVO<AsmtVO> selectObject(AsmtVO vo) throws Exception;

    // 다건 조회
    public ProcessResultVO<AsmtVO> selectList(AsmtVO vo) throws Exception;

    // 페이징 조회
    public ProcessResultVO<AsmtVO> selectListPaging(AsmtVO vo) throws Exception;

    // 과제 등록
    public void insertAsmnt(AsmtVO vo) throws Exception;

    // (개인)참여자 조회
    public ProcessResultVO<AsmtVO> selectJoinIndi(AsmtVO vo) throws Exception;

    // 상호평가 조회
    public ProcessResultVO<AsmtVO> selectEval(AsmtVO vo) throws Exception;

    // 상호평가 등록
    public ProcessResultVO<AsmtVO> insertEval(AsmtVO vo) throws Exception;

    // 우수과제 조회
    public ProcessResultVO<AsmtVO> selectBest(AsmtVO vo) throws Exception;

}
