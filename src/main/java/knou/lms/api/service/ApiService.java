package knou.lms.api.service;

import java.util.List;

import knou.lms.api.vo.ApiCountInfoVO;
import knou.lms.api.vo.ApiListInfoVO;
import knou.lms.api.vo.CntsPreviewVO;
import knou.lms.api.vo.PagePreviewVO;
import knou.lms.api.vo.ZipcontentUploadVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.vo.MainCreCrsVO;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonPageVO;

public interface ApiService {

    /**
     * ZIP 콘텐츠 업로드 로그 저장
     * @param vo
     * @throws Exception
     */
    public void insertZipcontUploadLog(ZipcontentUploadVO vo) throws Exception;

    /*****************************************************
     * 학생들 강의 알림 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiCountInfoVO> selectStuCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 교수들 강의 알림 건수
     * 1. 담당과목의 Q&A 미답변 건수
     * 2. 담당과목의 1:1 상담 미답변 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiCountInfoVO> selectProfCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 신청받은 결시원 개수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiCountInfoVO> selectProfExamAbsentRequestCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 신청받은 결시원 개수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiCountInfoVO> selectProfScoreObjtRequestCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 장애인지원신청 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiCountInfoVO> selectDisabledPersonRequestCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception;

    /*****************************************************
     * 강의실 전체 공지사항 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAllNoticeList(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 학생별로 과목 공지사항 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStuLessonNoticeList(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 학생 과목 QNA 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStuLessonQnaList(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 조교, 교수 과목 공지사항 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectProfLessonNoticeList(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 조교, 교수 과목 Q&A 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectProfLessonQnaList(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 직원 과목 QNA 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStaffLessonQnaList(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 실시간 세미나 내역
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectRealSeminarList(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 학생 학습 진도율 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStdProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 교수 학습 진도율 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectProfProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 교수 과목별 진도율 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectProfSubjectProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 학과별 주차별 출석 현황
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectDepartPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 전체 주차별 출석 현황
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 주차별 학습 현황
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 과목별 출석현황
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectSubjectPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception;

    /*****************************************************
     * 학생 수강 과목 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStuCrsCreNmList(ApiListInfoVO apiListInfoVO)throws Exception;    

    /*****************************************************
     * 전체 학생 진도율 정보 입력
     * @param apiListInfoVO
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
     * 미리보기 콘텐츠 조회
     * @param LessonCntsVO
     * @throws Exception
     ******************************************************/
    public LessonCntsVO selectPreviewCnts(LessonCntsVO vo) throws Exception;

    /*****************************************************
     * 미리보기 콘텐츠 페이지목록 조회
     * @param LessonCntsVO
     * @throws Exception
     ******************************************************/
    public List<LessonPageVO> listPreviewLessonPage(LessonPageVO vo) throws Exception;

    /*****************************************************
     * 학생별 학습현황 목록
     * @param TermVO
     * @throws Exception
     ******************************************************/
    public List<MainCreCrsVO> listLearningStatus(TermVO vo) throws Exception;

    /*****************************************************
     * 학생별 학습현황(1과목)
     * @param CreCrsVO
     * @throws Exception
     ******************************************************/
    public List<MainCreCrsVO> listLearningStatusOne(CreCrsVO vo) throws Exception;

    /*****************************************************
     * LCDMS 콘텐츠 미리보기 조회
     * @param CntsPreviewVO
     * @throws Exception
     ******************************************************/
    public CntsPreviewVO selectLcdmsCntsPreview(CntsPreviewVO vo) throws Exception;

    /*****************************************************
     * LCDMS 콘텐츠 페이지 미리보기 목록 조회
     * @param List<PagePreviewVO>
     * @throws Exception
     ******************************************************/
    public List<PagePreviewVO> listLcdmsPagePreview(PagePreviewVO vo) throws Exception;

    /*****************************************************
     * 주차별 수강 현황(목록)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectWeekList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectWeekCount(ApiListInfoVO apiListInfoVO) throws Exception;    

    /*****************************************************
     * 전체 학습활동 현황_교수(과제)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalAsmntList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectTotalAsmntCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 전체 학습활동 현황_교수(토론)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalForumList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectTotalForumCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 전체 학습활동 현황_교수(퀴즈)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalQuizList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectTotalQuizCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 전체 학습활동 현황_교수(설문)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalReschList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectTotalReschCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 전체 학습활동 현황_교수(세미나)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalSeminarList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectTotalSeminarCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 과목별 학습진도 현황(목록)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectLearnProgressList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectLearnProgressCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 과목별 학습활동이력_학습자(과제)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademyAsmntList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectAcademyAsmntCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 과목별 학습활동이력_학습자(토론)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademyForumList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectAcademyForumCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 과목별 학습활동이력_학습자(퀴즈)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademyQuizList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectAcademyQuizCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 과목별 학습활동이력_학습자(설문)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademyReschList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectAcademyReschCount(ApiListInfoVO apiListInfoVO) throws Exception;

    /*****************************************************
     * 과목별 학습활동이력_학습자(세미나)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademySeminarList(ApiListInfoVO apiListInfoVO)throws Exception;
    public int selectAcademySeminarCount(ApiListInfoVO apiListInfoVO) throws Exception;  

}
