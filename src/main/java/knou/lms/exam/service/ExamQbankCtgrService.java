package knou.lms.exam.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamQbankCtgrVO;

public interface ExamQbankCtgrService {

    /*****************************************************
     * TODO 문제은행 분류 코드 정보 조회
     * @param ExamQbankCtgrVO
     * @return ExamQbankCtgrVO
     * @throws Exception
     ******************************************************/
    public ExamQbankCtgrVO select(ExamQbankCtgrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 분류 코드 목록 조회
     * @param ExamQbankCtgrVO
     * @return List<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    public List<ExamQbankCtgrVO> list(ExamQbankCtgrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 분류 코드 목록 조회 페이징
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamQbankCtgrVO> listPaging(ExamQbankCtgrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 분류 코드 등록
     * @param ExamQbankCtgrVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertQbankCtgr(ExamQbankCtgrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 분류 코드 수정
     * @param ExamQbankCtgrVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQbankCtgr(ExamQbankCtgrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 분류 코드 삭제
     * @param ExamQbankCtgrVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteQbankCtgr(ExamQbankCtgrVO vo) throws Exception;

    /*****************************************************
     * TODO 문제은행 특정 분류코드 순서 조회
     * @param ExamQbankCtgrVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectQbankCtgrOdr(ExamQbankCtgrVO vo) throws Exception;

    /*****************************************************
     * TODO 문제은행 과목별 사용자 목록 가져오기
     * @param ExamQbankCtgrVO
     * @return List<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    public List<ExamQbankCtgrVO> listQbankCtgrUser(ExamQbankCtgrVO vo) throws Exception;
    
}
