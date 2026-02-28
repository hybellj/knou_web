package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.exam.vo.ExamQstnVO;

@Mapper("examQstnDAO")
public interface ExamQstnDAO {

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
     * @param ExamVO
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
     * TODO 문제 조회
     * @param ExamQstnVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap egovSelect(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 전체 목록 조회
     * @param ExamQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> egovList(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 순서 변경
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQstnNo(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 순서 특정 번호로 변경
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQstnNoToNo(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 후보 순서 변경
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateSubNo(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 후보 순서 특정 번호로 변경
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateSubNoToNo(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 등록
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamQstn(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 등록
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamQstnEgov(EgovMap vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 수정
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstn(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 삭제 상태로 수정
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstnDelYn(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문항 키 가져오기
     * @param 
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectKey() throws Exception;
    
    /*****************************************************
     * TODO 문제 점수 수정
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstnScore(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 후보 번호 다음값 가져오기
     * @param ExamQstnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectNextSubNo(ExamQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제 후보 번호 다음 값 개수 카운트
     * @param ExamQstnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectOtherSubCount(ExamQstnVO vo) throws Exception;
    
}
