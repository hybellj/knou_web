package knou.lms.mut.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mut.vo.MutEvalRltnVO;
import knou.lms.mut.vo.MutEvalVO;

public interface MutEvalService {

    // 조회
    public ProcessResultVO<MutEvalVO> selectMut(MutEvalVO vo) throws Exception;

    // 단건 조회
    public ProcessResultVO<MutEvalVO> selectObject(MutEvalVO vo) throws Exception;

    // 다건 조회
    public ProcessResultVO<MutEvalVO> selectList(MutEvalVO vo) throws Exception;

    // 페이징 조회
    public ProcessResultVO<MutEvalVO> selectListPaging(MutEvalVO vo) throws Exception;

    // 사용여부 수정
    public ProcessResultVO<MutEvalVO> updateUseYn(MutEvalVO vo)throws Exception;

    // 삭제
    public ProcessResultVO<MutEvalVO> updateDelYn(MutEvalVO vo)throws Exception;

    // 등록
    public ProcessResultVO<MutEvalVO> regEvalQstn(HttpServletRequest request, MutEvalVO vo) throws Exception;

    // 루브릭 관리자 등록 + 본인 등록 조회
    public List<MutEvalVO> selectRegList(MutEvalRltnVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 정보 강의 연결 조회
     * @param MutEvalRltnVO
     * @return List<MutEvalVO>
     * @throws Exception
     ******************************************************/
    public List<MutEvalVO> listMutEvalByCrsCreCd(MutEvalRltnVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 정보 조회
     * @param MutEvalVO
     * @return MutEvalVO
     * @throws Exception
     ******************************************************/
    public MutEvalVO selectMutEval(MutEvalVO vo) throws Exception;

}
