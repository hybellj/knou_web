package knou.lms.exam.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamQbankQstnVO;

public interface ExamQbankQstnService {

    /*****************************************************
     * TODO 문제은행 문제 정보 조회
     * @param ExamQbankQstnVO
     * @return ExamQbankQstnVO
     * @throws Exception
     ******************************************************/
    public ExamQbankQstnVO select(ExamQbankQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 문제 목록 조회
     * @param ExamQbankQstnVO
     * @return List<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    public List<ExamQbankQstnVO> list(ExamQbankQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 문제 목록 조회 페이징
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamQbankQstnVO> listPaging(ExamQbankQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 특정 분류코드 문제 순서 조회
     * @param ExamQbankQstnVO
     * @return ExamQbankQstnVO
     * @throws Exception
     ******************************************************/
    public ExamQbankQstnVO selectQbankQstnNos(ExamQbankQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 문제 등록
     * @param ExamQbankQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertQbankQstn(ExamQbankQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 문제 수정
     * @param ExamQbankQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQbankQstn(ExamQbankQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 문제 삭제 상태로 수정
     * @param ExamQbankQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQbankQstnDelYn(ExamQbankQstnVO vo) throws Exception;
    
}
