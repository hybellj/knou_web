package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.exam.vo.ExamIndustryConVO;
import knou.lms.exam.vo.ExamStareVO;
import knou.lms.exam.vo.ExamVO;

@Mapper("examStareDAO")
public interface ExamStareDAO {
    
    /*****************************************************
     * 시험응시 리스트 조회
     * @param ExamStareVO
     * @return List<ExamStareVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStareVO> list(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 시험응시 학습자 리스트 조회
     * @param ExamStareVO
     * @return List<ExamStareVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStareVO> listExamStareStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 시험응시 학습자 리스트 조회
     * @param ExamStareVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listExamStareStdEgov(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험응시 학습자 정보 조회
     * @param ForumStareVO
     * @return ExamStareVO
     * @throws Exception
     ******************************************************/
    public ExamStareVO selectExamStareStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 현황 조회
     * @param ForumStareVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectExamScoreStatus(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 시험 미응시 학습자 리스트 조회
     * @param ExamStareVO
     * @return List<ExamStareVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStareVO> listExamNonStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험응시 등록
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 시험응시 일괄 등록
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamStareBatch(List<ExamStareVO> list) throws Exception;
    
    /*****************************************************
     * TODO 시험응시 수정
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 재시험 설정
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReExamStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학습자별 재시험 설정
     * @param ExamStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReExamStareByStdNo(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학습자 토탈 시험 점수 수정
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStareScore(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 설정 대상 학습자 번호 조회
     * @param ForumStareVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listExamTargetStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 응시 시작
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStart(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 응시 가능여부 등의 정보 조회
     * @param ForumStareVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectExamStdStareInfo(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 응시 임시저장
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStareTempSave(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험에 응시한 학습자의 점수대역별 통계정보 조회
     * @param ForumStareVO
     * @return List<ExamStareVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStareVO> listStuExamScoreStatus(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 정보 및 학생의 시험 응시정보 조회
     * @param ForumStareVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectStuExamInfo(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험응시 학습자 리스트 조회
     * @param ForumStareVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listExamStareStdPageing(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험응시 학습자  명수를 카운트
     * @param ForumStareVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int listExamStareStdCount(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 중간 기말 참여 현황 목록
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listExamStareStatus(ExamVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험응시 교수 메모 수정
     * @param ExamStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStareMemo(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 엑셀 성적 등록
     * @param ExamStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStareExcel(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 응시 전체 삭제
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteAllStare(ExamVO vo) throws Exception;
    
    /*****************************************************
     * 실시간 시험 미응시 학생 목록 수
     * @param EgovMap
     * @return int
     * @throws Exception
     ******************************************************/
    public int countPagingReExamStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 실시간 시험 미응시 학생 목록
     * @param EgovMap
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReExamStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 실시간 시험 미응시 학생 목록 페이징
     * @param EgovMap
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listPagingReExamStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 실시간 시험 재시험 등록현황
     * @param EgovMap
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReExamConfigStatus(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 시험 재시험 설정 취소
     * @param ExamStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void resetReExamStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 개별 학습자 시험 재시험 설정 취소
     * @param ExamStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void resetReExamStareByStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 학사 년도 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public List<ExamIndustryConVO> selectHaksaYear(ExamIndustryConVO vo) throws Exception;
    
    /*****************************************************
     * 학사 학기 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public List<ExamIndustryConVO> selectHaksaTerm(ExamIndustryConVO vo) throws Exception ;
    
    /*****************************************************
     * 진행중인 과목명 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public List<ExamIndustryConVO> selectCreCrsNm(ExamIndustryConVO vo) throws Exception;
    
    /*****************************************************
     * 수업일정 차시 정보 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public ExamIndustryConVO selectLessonSchedule(ExamIndustryConVO vo) throws Exception;

    /*****************************************************
     * 산업체위탁생학습진행현황 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public List<ExamIndustryConVO> selectIndustryConLearningList(ExamIndustryConVO vo) throws Exception;   
    
    /*****************************************************
     * 대체평가 대상자 목록
     * @param ExamStareVO
     * @return List<ExamStareVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStareVO> listExamNoStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 특정 학습자 시험 응시 여부
     * @param ExamStareVO
     * @return ExamStareVO
     * @throws Exception
     ******************************************************/
    public ExamStareVO examStareByStdNo(ExamStareVO vo) throws Exception;
}
