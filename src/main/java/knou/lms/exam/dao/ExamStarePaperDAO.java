package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.exam.vo.ExamStarePaperVO;
import knou.lms.exam.vo.ExamVO;

@Mapper("examStarePaperDAO")
public interface ExamStarePaperDAO {

    /*****************************************************
     * TODO 응시 시험지 등록
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamStarePaper(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * 응시 시험지 등록 일괄
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamStarePaperBatch(List<ExamStarePaperVO> list) throws Exception;
    
    /*****************************************************
     * TODO 시험지 문제 목록 조회
     * @param ExamStarePaperVO
     * @return List<?>
     * @throws Exception
     ******************************************************/
    public List<?> paperQstnlist(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학생의 시험지 문제 조회
     * @param ExamStarePaperVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listStdStarePaper(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * 학생의 시험지 문제 등록 체크
     * @param ExamStarePaperVO
     * @return List<ExamStarePaperVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStarePaperVO> listStdStarePaperNotExists(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험지 문제 삭제
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteStarePaper(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험지 문제 수정
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateStarePaper(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험지의 문제 전체 삭제
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteAll(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 재시험 문항 출제
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertReExamStarePaper(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 응시 문항 초기화
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStarePaperInit(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 응시 문항 임시저장
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStarePaperTempSave(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험문제 배정된 학습자 리스트 조회
     * @param ExamStarePaperVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listStdPageing(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험지 문제 조회
     * @param ExamStarePaperVO
     * @return ExamStarePaperVO
     * @throws Exception
     ******************************************************/
    public ExamStarePaperVO select(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험지 문제 전체 삭제
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteAllPaper(ExamVO vo) throws Exception;
    
}
