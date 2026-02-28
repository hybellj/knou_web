package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.exam.vo.ExamQbankQstnVO;

@Mapper("examQbankQstnDAO")
public interface ExamQbankQstnDAO {

    /*****************************************************
     * TODO 문제은행 문제 정보 조회
     * @param ExamQbankQstnVO
     * @return ExamQbankQstnVO
     * @throws Exception
     ******************************************************/
    public ExamQbankQstnVO select(ExamQbankQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 문제 정보 조회
     * @param ExamQbankQstnVO
     * @return ExamQbankQstnVO
     * @throws Exception
     ******************************************************/
    public EgovMap egovSelect(ExamQbankQstnVO vo) throws Exception;
    
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
     * @return List<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    public List<ExamQbankQstnVO> listPaging(ExamQbankQstnVO vo) throws Exception;
    
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
     * TODO 문제은행 문항키 가져오기
     * @param 
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectKey() throws Exception;
    
    /*****************************************************
     * TODO 문제은행 문제 순서 변경
     * @param ExamQbankQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQstnNo(ExamQbankQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 문제은행 문제 삭제 상태로 수정
     * @param ExamQbankQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQbankQstnDelYn(ExamQbankQstnVO vo) throws Exception;
    
}
