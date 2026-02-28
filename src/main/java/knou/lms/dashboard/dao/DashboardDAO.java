package knou.lms.dashboard.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.vo.DefaultVO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.vo.DashboardAdminVO;
import knou.lms.dashboard.vo.DashboardVO;
import knou.lms.dashboard.vo.MainCreCrsVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.resh.vo.ReshVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Mapper("dashboardDAO")
public interface DashboardDAO {

    public List<ReshVO> listSysReschRecent(ReshVO vo) throws Exception;

    /**
     * 현재학기 조회
     * @param vo
     * @return
     * @throws Exception
     */
    public List<TermVO> listCurTerm(TermVO vo) throws Exception;

    /**
     * ***************************************************
     * 수강생 학기 목록
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<TermVO> listStdTerm(TermVO vo) throws Exception;

    /**
     * ***************************************************
     * 수강생 메인 수강과목 부가 자료 조회
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<MainCreCrsVO> listStdCorsData(MainCreCrsVO vo) throws Exception;

    /**
     * 수강생 메인 시험정보 조회
     * @param vo
     * @return
     * @throws Exception
     */
    public List<ExamVO> listCorExamData(MainCreCrsVO vo) throws Exception;

    /**
     * 수강생 강의 주차 목록 조회
     * @param vo
     * @return
     * @throws Exception
     */
    public List<LessonScheduleVO> listLessonSchedule(MainCreCrsVO vo) throws Exception;

    /**
     * 수강생 강의 주차 목록 조회
     * @param vo
     * @return
     * @throws Exception
     */
    public List<LessonStudyStateVO> listLessonStudyState(MainCreCrsVO vo) throws Exception;

    /**
     * ***************************************************
     * 교수 학기 목록
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<TermVO> listProfTerm(TermVO vo) throws Exception;

    /**
     * ***************************************************
     * 교수학기목록조회
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<TermVO> profSmstrList(TermVO vo) throws Exception;

    /**
     * ***************************************************
     * 교수 메인 수강과목 부가 자료 조회
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<MainCreCrsVO> listProfCorsData(MainCreCrsVO vo) throws Exception;

    /**
     * ***************************************************
     * 미완료 강의 조회
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<EgovMap> listStdUncompletedLesson(DefaultVO vo) throws Exception;

    /**
     * ***************************************************
     * 대시보드 현황 (교수)
     * @param vo
     * @return EgovMap
     * @throws Exception
     *****************************************************
     */
    public EgovMap dashboardStatProf(DefaultVO vo) throws Exception;

    /**
     * ***************************************************
     * 대시보드 현황 (학생)
     * @param vo
     * @return EgovMap
     * @throws Exception
     *****************************************************
     */
    public EgovMap dashboardStatStu(DefaultVO vo) throws Exception;

    /**
     * ***************************************************
     * 관리자 학기 목록
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<TermVO> listAdminTerm(TermVO vo) throws Exception;

    /**
     * ***************************************************
     * 관리자 메인 개설과목 자료 조회
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<DashboardAdminVO> listAdminCorsData(DashboardAdminVO vo) throws Exception;

    /**
     * 관리자 메인 개설과목 자료 카운트
     * @param StatVO
     * @return int
     * @throws Exception
     */
    public int countAdminCorsData(DashboardAdminVO vo) throws Exception;

    /**
     * ***************************************************
     *  관리자메인 사용자 목록
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<DashboardAdminVO> listAdminUserCorsData(DashboardAdminVO vo) throws Exception;

    /**
     * ***************************************************
     * 관리자메인 사용자 카운트
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public int countAdminUserData(DashboardAdminVO vo) throws Exception;

    /*****************************************************
     * 관리자메인 법정과목 목록
     * @param ContentsVO
     * @return List<ContentsVO>
     * @throws Exception
     ******************************************************/
    public List<DashboardAdminVO> listAdminLegalCorsData(DashboardAdminVO vo) throws Exception;

    /*****************************************************
     * 관리자메인 법정과목 카운트
     * @param ContentsVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int countAdminLegalCorsData(DashboardAdminVO vo) throws Exception;

    /*****************************************************
     * 관리자메인 공계강좌 목록
     * @param ContentsVO
     * @return List<ContentsVO>
     * @throws Exception
     ******************************************************/
    public List<DashboardAdminVO> listAdminOpenCorsData(DashboardAdminVO vo) throws Exception;

    /*****************************************************
     * 관리자메인 공계강좌 카운트
     * @param ContentsVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int countAdminOpenCorsData(DashboardAdminVO vo) throws Exception;

    /**
     * 대시보드 현재 주차
     * @param vo
     * @return EgovMap
     * @throws Exception
     */
    public EgovMap dashboardCurrentWeek(TermVO vo) throws Exception;

    /**
     * 사용자 로그인수 정보 조회
     * @param vo
     * @return EgovMap
     * @throws Exception
     */
    public EgovMap selectLoginCntInfo(UsrUserInfoVO vo) throws Exception;

    /**
     * 수업운영 게시판 답변 현황 조회
     * @param vo
     * @return EgovMap
     * @throws Exception
     */
    public EgovMap selectBbsAnsStatus(UsrUserInfoVO vo) throws Exception;

    /**
     * 수업운영 점수 현황 (교수)
     * @param vo
     * @return EgovMap
     * @throws Exception
     */
    public EgovMap selectOprScoreProfStatus(UsrUserInfoVO vo) throws Exception;

    /**
     * 수업운영 점수 현황 (조교)
     * @param vo
     * @return EgovMap
     * @throws Exception
     */
    public EgovMap selectOprScoreAssistStatus(UsrUserInfoVO vo) throws Exception;

    /*****************************************************
     * 관리자 메인 > 과목별 학습현황
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonStatusByCrs(DashboardVO vo) throws Exception;

    /*****************************************************
     * 관리자 메인 > 학생별 학습현황
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonStatusByStd(DashboardVO vo) throws Exception;

    /*****************************************************
     * 관리자 메인 > 사용자 검색 수
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public int countAdminDashUser(DashboardVO vo) throws Exception;

    /*****************************************************
     * 관리자 메인 > 사용자 검색
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listPagingAdminDashUser(DashboardVO vo) throws Exception;

    /**
     * ***************************************************
     * 위젯 설정 팝업
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public List<DashboardVO> listWidgetSettingPop(DashboardVO vo) throws Exception;

    /**
     * ***************************************************
     * 위젯 삭제
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public void delete(DashboardVO vo) throws Exception;
    public void deleteSub(DashboardVO vo) throws Exception;

    /*****************************************************
     * TODO 위젯 설정 변경
     * @param DashboardVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void widgetStngChange(DashboardVO vo) throws Exception;

    /*****************************************************
     * 대시보드 위젯 조회
     * @param vo
     * @return DashboardVO
     * @throws Exception
     ******************************************************/
    public EgovMap widgetStngSelect(DashboardVO vo) throws Exception;
    public int widgetStngUseCntSelect(DashboardVO vo) throws Exception;
    public EgovMap widgetDefaultStngSelect(DashboardVO vo) throws Exception;

    /*****************************************************
     * 대시보드 색상 조회
     * @param vo
     * @return DashboardVO
     * @throws Exception
     ******************************************************/
    public EgovMap widgetStngColrSelect(DashboardVO vo) throws Exception;

    /*****************************************************
     * 대시보드 위젯 사용자 조회
     * @param vo
     * @return DashboardVO
     * @throws Exception
     ******************************************************/
    public String getUserId(DashboardVO vo) throws Exception;

    /*****************************************************
     * 대시보드 위젯 팝업 조회
     * @param vo
     * @return DashboardVO
     * @throws Exception
     ******************************************************/
    public EgovMap widgetStngPopView(DashboardVO vo) throws Exception;
    public EgovMap widgetStngColrPopView(DashboardVO vo) throws Exception;

    /*****************************************************
     * 관리자 메인 > 사용자 검색
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public EgovMap lgnUsrCntSelect(DashboardVO vo) throws Exception;
    public EgovMap totStdntCntSelect(DashboardVO vo) throws Exception;

    /*****************************************************
     * 관리자 메인 > 사용자 검색
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> sbjctList(DashboardVO vo) throws Exception;
}
