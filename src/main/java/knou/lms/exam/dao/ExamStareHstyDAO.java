package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.exam.vo.ExamStareHstyVO;
import knou.lms.exam.vo.ExamVO;

@Mapper("examStareHstyDAO")
public interface ExamStareHstyDAO {

    /*****************************************************
     * TODO 시험 참여 이력 조회
     * @param ExamStareHstyVO
     * @return List<ExamStareHstyVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStareHstyVO> listExamStareHsty(ExamStareHstyVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 참여 이력 등록
     * @param ExamStareHstyVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamStareHsty(ExamStareHstyVO vo) throws Exception;
    
    /*****************************************************
     * 시험 참여 이력 등록 일괄
     * @param ExamStareHstyVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamStareHstyBatch(ExamStareHstyVO vo) throws Exception;
    
    
    /*****************************************************
     * TODO 마지막 저장 시간으로 부터 현재 시간의 차이를 초로 조회
     * @param ExamStareHstyVO
     * @return ExamStareHstyVO
     * @throws Exception
     ******************************************************/
    public ExamStareHstyVO selectLastStareTm(ExamStareHstyVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 응시 이력 전체 삭제
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteAllStareHsty(ExamVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 참여 이력 코드 조회
     * @param ExamStareHstyVO
     * @return ExamStareHstyVO
     * @throws Exception
     ******************************************************/
    public ExamStareHstyVO selectStareHsty(ExamStareHstyVO vo) throws Exception;
    
}
