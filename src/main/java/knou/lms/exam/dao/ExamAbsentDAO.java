package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.exam.vo.ExamAbsentVO;

@Mapper("examAbsentDAO")
public interface ExamAbsentDAO {
    
    /*****************************************************
     * TODO 결시원 리스트 조회
     * @param ExamAbsentVO
     * @return List<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    public List<ExamAbsentVO> list(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 리스트 조회 페이징
     * @param ExamAbsentVO
     * @return List<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    public List<ExamAbsentVO> listPaging(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 정보 조회
     * @param ExamAbsentVO
     * @return ExamAbsentVO
     * @throws Exception
     ******************************************************/
    public ExamAbsentVO select(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * TODO 내 강의에 등록된 결시원 리스트 조회
     * @param ExamAbsentVO
     * @return List<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    public List<ExamAbsentVO> listMyCreCrsExamAbsent(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 등록
     * @param ExamAbsentVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertAbsent(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 수정
     * @param ExamAbsentVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateAbsent(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * 결시원 정리 (교수)
     * @param ExamAbsentVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateAllCompanionProf(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 정리
     * @param ExamAbsentVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateAllCompanion(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * TODO 관리자 > 결시원 리스트 조회
     * @param ExamAbsentVO
     * @return List<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    public List<ExamAbsentVO> listAdminExamAbsent(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * TODO 관리자 > 실시간시험 과목 결시원 미신청 목록 조회
     * @param ExamAbsentVO
     * @return List<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    public List<ExamAbsentVO> listCreCrsNotAbsent(ExamAbsentVO vo) throws Exception;

    /*****************************************************
     * 학생 전체 결시원 대상 시험 리스트 조회
     * @param ExamAbsentVO
     * @return List<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    public List<ExamAbsentVO> listAllStuAbsentExam(ExamAbsentVO vo) throws Exception;
    
    /*****************************************************
     * 학생 결시원 신청내역 체크
     * @param ExamAbsentVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectExamAbsentApplicateYn(ExamAbsentVO vo) throws Exception;
}
