package knou.lms.exam.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamOathVO;

public interface ExamOathService {
    
    /*****************************************************
     * TODO 시험 서약서 조회
     * @param ExamOathVO
     * @return ExamOathVO
     * @throws Exception
     ******************************************************/
    public ExamOathVO select(ExamOathVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 서약서 목록 조회
     * @param ExamOathVO
     * @return List<ExamOathVO>
     * @throws Exception
     ******************************************************/
    public List<ExamOathVO> list(ExamOathVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 서약서 등록
     * @param ExamOathVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(ExamOathVO vo) throws Exception;
    
    /*****************************************************
     * TODO 과목별 시험 서약서 제출 목록 조회
     * @param ExamOathVO
     * @return ProcessResultVO<ExamOathVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamOathVO> listOathByCreCrsPaging(ExamOathVO vo) throws Exception;

}
