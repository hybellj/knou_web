package knou.lms.api.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.api.vo.ApiCountInfoVO;
import knou.lms.api.vo.ApiListInfoVO;
import knou.lms.api.vo.ZipcontentUploadVO;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonPageVO;

/***************************************************
 * <pre>
 * 업무 그룹명 : API
 * 서부 업무명 : API
 * 설         명 : API
 * 작   성   자 : mediopiatech
 * 작   성   일 : 2023. 4. 24
 * Copyright ⓒ MediopiaTec All Right Reserved
 * ======================================
 * </pre>
 ***************************************************/

@Mapper("apiDAO")
public interface ApiDAO {
    
    /*****************************************************
     * API 학기 조회
     * @param ApiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectApiTerm(ApiCountInfoVO vo) throws Exception;
    
    /*****************************************************
     * ZIP 콘텐츠 업로드 기록
     * @param ZipcontentUploadVO
     * @throws Exception
     ******************************************************/
    public void insertZipcontUploadLog(ZipcontentUploadVO vo) throws Exception;

    /*****************************************************
     * 강의공지 읽지않은 건수 : NOTICE
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectStuNoticeCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * Q&A 읽지 않은 건수 : QNA
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectStuQnaCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 1:1 상담 읽지않은 건수 : SECRET
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectStuSecretCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 과제 미제출 건수
     * 
     * @param apiCountInfoVO 
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectStuAsmtCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 토론 미제출 건수
     * 
     * @param apiCountInfoVO 
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectStuForumCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 퀴즈 미제출 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectStuQuizCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 설문 미제출 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectStuReschCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 담당과목의 Q&A 미답변 건수, 담당과목의 1:1 상담 미답변 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectProfBbsCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;    

    /*****************************************************
     * 신청받은 결시원 개수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectProfExamAbsentRequestCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;    

    /*****************************************************
     * 재확인 신청 받은 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectProfScoreObjtRequestCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;   

    /*****************************************************
     * 장애인지원신청 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ApiCountInfoVO selectDisabledPersonRequestCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;    

    /*****************************************************
     * 전체 학생 진도율 정보 입력
     * 
     * @param 
     * @throws Exception
     ******************************************************/
    public void insertStdProgressRatio() throws Exception;    

    /*****************************************************
     * 전체 학생 출석율 정보 입력
     * 
     * @param 
     * @throws Exception
     ******************************************************/
    public void insertStdAttendRatio() throws Exception;    

    /*****************************************************
     * 강의실 전체 공지사항 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectAllNoticeList(ApiListInfoVO apiListInfoVO) throws Exception;    

    /*****************************************************
     * 학생별로 과목 공지사항 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectStuLessonNoticeList(ApiListInfoVO apiListInfoVO) throws Exception;    

    /*****************************************************
     * 학생 과목 QNA 내역
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectStuLessonQnaList(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 조교, 교수 강의 공지사항 내역
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectProfLessonNoticeList(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 조교, 교수 강의 Q&A 내역
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectProfLessonQnaList(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 직원 과목 QNA 내역
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectStaffLessonQnaList(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 실시간 세미나 내역
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectRealSeminarList(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 학생 학습 진도율 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ApiListInfoVO selectStdAvgAllProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 수강과목 내역 및 과목별 진도율
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectStdDetailProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;
    public List<ApiListInfoVO> selectCollDetailProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;
    public List<ApiListInfoVO> selectGridDetailProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 학부, 대학원 평균 진도율
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ApiListInfoVO selectTotProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    // 대학교
    public ApiListInfoVO selectTotCollProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    // 대학원
    public ApiListInfoVO selectTotGradProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 교수  학습 나의 평균 진도율 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ApiListInfoVO selectProfAvgProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 교수 과목별 평균 진도율 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectProfSubjectProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 교수 학과별 주차별 출석현황 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectProfDepartPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 학과장 학과별 주차별 출석현황 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectDeanDepartPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 전체 주차별 출석현황 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectTotalPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 주차별 학습현황 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 교수  과목별 출석현황 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectProfSubjectPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 학과장  과목별 출석현황 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectDeanSubjectPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 학생 수강 과목 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectStuCrsCreNmList(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 미리보기 콘텐츠 조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public LessonCntsVO selectPreviewCnts(LessonCntsVO vo) throws Exception;

    /*****************************************************
     * 미리보기 콘텐츠 페이지 조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public List<LessonPageVO> listPreviewLessonPage(LessonPageVO vo) throws Exception;

    /*****************************************************
     * 주차별 수강 현황 목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectWeekList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 주차별 수강 현황 카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectWeekCount(ApiListInfoVO apiListInfoVO) throws Exception;
    
    /*****************************************************
     * 학습활동 과제 목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectTotalAsmntList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동 과제 카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalAsmntCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 학습활동 토론목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectTotalForumList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동 토론카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalForumCount(ApiListInfoVO apiListInfoVO) throws Exception;    

    /*****************************************************
     * 학습활동 퀴즈목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectTotalQuizList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동 퀴즈카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalQuizCount(ApiListInfoVO apiListInfoVO) throws Exception;
    
    /*****************************************************
     * 학습활동 설문목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectTotalReschList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동 설문카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalReschCount(ApiListInfoVO apiListInfoVO) throws Exception;
    
    /*****************************************************
     * 학습활동 세미나목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectTotalSeminarList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동 세미나카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalSeminarCount(ApiListInfoVO apiListInfoVO) throws Exception;
    
    /*****************************************************
     * 학습진도목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectLearnProgressList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습진도카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectLearnProgressCount(ApiListInfoVO apiListInfoVO) throws Exception;
    
    /*****************************************************
     * 학습활동이력  과제 목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectAcademyAsmntList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동이력  과제 카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademyAsmntCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 학습활동이력  토론목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectAcademyForumList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동이력  토론카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademyForumCount(ApiListInfoVO apiListInfoVO) throws Exception;    

    /*****************************************************
     * 학습활동이력  퀴즈목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectAcademyQuizList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동이력  퀴즈카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademyQuizCount(ApiListInfoVO apiListInfoVO) throws Exception;
    
    /*****************************************************
     * 학습활동이력  설문목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectAcademyReschList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동이력  설문카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademyReschCount(ApiListInfoVO apiListInfoVO) throws Exception;
    
    /*****************************************************
     * 학습활동이력  세미나목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public List<ApiListInfoVO> selectAcademySeminarList(ApiListInfoVO apiListInfoVO)throws Exception;
    /*****************************************************
     * 학습활동이력  세미나카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademySeminarCount(ApiListInfoVO apiListInfoVO) throws Exception;
}