package knou.lms.exam.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamIndustryConVO;
import knou.lms.exam.vo.ExamStareVO;
import knou.lms.exam.vo.ExamVO;

public interface ExamStareService {

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
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamStareVO> listExamStareStd(ExamStareVO vo) throws Exception;
    
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
     * TODO 재시험 설정
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> setReExamStare(ExamStareVO vo, HttpServletRequest request) throws Exception;
    
    /*****************************************************
     * TODO 중간/기말 실시간시험 재시험 등록, 수정, 삭제
     * @param ExamVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> setMidEndReExamStare(ExamVO vo, HttpServletRequest request) throws Exception;
    
    /*****************************************************
     * TODO 시험 초기화
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> initExamStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 답안 성적 반영
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> updateExamStareScore(ExamStareVO vo) throws Exception;
    
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
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> listExamStareStdPageing(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 중간 기말 참여 현황 목록
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listExamStareStatus(ExamVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험응시 수정
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험응시 교수 메모 수정
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamStareMemo(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업로드 된 엑셀 파일로 시험 성적 업데이트
     * @param ExamStareVO, List<?>
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> updateExampleExcelStareScore(ExamStareVO vo, List<?> stdNoList) throws Exception;
    
    /*****************************************************
     * 시험 응시 가능여부 등의 정보 조회
     * @param ExamStareVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void checkStdExamStare(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 실시간 시험 미응시 학생 목록
     * @param List<EgovMap>
     * @return void
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReExamStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 실시간 시험 미응시 학생 목록 페이징
     * @param ProcessResultVO<EgovMap>
     * @return void
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> listPagingReExamStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 실시간 시험 재시험 등록현황
     * @param EgovMap
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReExamConfigStatus(ExamStareVO vo) throws Exception;
    
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
     * @return ProcessResultVO<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamIndustryConVO> selectHaksaTerm(ExamIndustryConVO vo) throws Exception;
    
    /*****************************************************
     * 수업일정 차시 정보 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public ExamIndustryConVO selectLessonSchedule(ExamIndustryConVO vo) throws Exception;
    
    /*****************************************************
     * 진행중인 과목명 조회
     * @param ExamIndustryConVO
     * @return ProcessResultVO<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamIndustryConVO> selectCreCrsNm(ExamIndustryConVO vo) throws Exception;

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
     * 개별 학습자 시험 재시험 설정 취소
     * @param ExamStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void resetReExamStareByStd(ExamStareVO vo) throws Exception;
    
    /*****************************************************
     * 특정 학습자 시험 응시 여부
     * @param ExamStareVO
     * @return ExamStareVO
     * @throws Exception
     ******************************************************/
    public ExamStareVO examStareByStdNo(ExamStareVO vo) throws Exception;
}
