package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.exam.vo.ExamOathVO;

@Mapper("examOathDAO")
public interface ExamOathDAO {

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
     * @return List<ExamOathVO>
     * @throws Exception
     ******************************************************/
    public List<ExamOathVO> listOathByCreCrsPaging(ExamOathVO vo) throws Exception;
    
}
