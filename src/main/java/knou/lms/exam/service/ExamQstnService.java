package knou.lms.exam.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamQstnVO;

public interface ExamQstnService {

    /*****************************************************
     * TODO 시험 문제 목록 조회
     * @param ExamQstnVO
     * @return List<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    public List<ExamQstnVO> list(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 문제 랜덤 목록 조회
     * @param ExamQstnVO
     * @return List<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    public List<ExamQstnVO> randomQstnList(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 문제 순차 목록 조회
     * @param ExamQstnVO
     * @return List<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    public List<ExamQstnVO> seqQstnList(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 개수 조회
     * @param ExamQstnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int qstnCount(ExamQstnVO vo) throws Exception;

    /*****************************************************
     * TODO 문제 조회
     * @param ExamQstnVO
     * @return ExamQstnVO
     * @throws Exception
     ******************************************************/
    public ExamQstnVO select(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 순서 변경
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> editQstnNo(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 후보 순서 변경
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> editSubNo(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 등록
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamQstn(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 수정
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstn(ExamQstnVO vo) throws Exception;

    /*****************************************************
     * TODO 문제 수정 옵션 포함
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstnOption(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 삭제 상태로 수정
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstnDelYn(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 점수 수정
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstnScore(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * 문제 점수 수정 일괄
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstnScoreBatch(HttpServletRequest request, List<ExamQstnVO> list) throws Exception;
    
    /*****************************************************
     * TODO 문제 점수 1점 부여
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstnScore1(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문항 가져오기
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertCopyQstn(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 엑셀 다운로드를 위한 문제 리스트
     * @param ExamQstnVO
     * @return HashMap<String, Object>
     * @throws Exception
     ******************************************************/
    public HashMap<String, Object> exampleExcelQstnList(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업로드 된 엑셀 파일로 시험문제 등록
     * @param ExamQstnVO, List<?>
     * @return ProcessResultVO<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamQstnVO> insertExcelQstnList(ExamQstnVO vo, List<?> qstnList) throws Exception;
    
}
