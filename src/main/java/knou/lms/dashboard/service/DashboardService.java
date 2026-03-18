package knou.lms.dashboard.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.vo.DashboardVO;
import knou.lms.resh.vo.ReshVO;
import knou.lms.user.vo.UsrUserInfoVO;

/**
 * *************************************************
 * <pre>
 * 업무 그룹명 : 대시보드
 * 서부 업무명 : 대시보드 서비스 interface
 * 설         명 :
 * 작   성   자 : mediopia
 * 작   성   일 : 2022. 12. 15.
 * Copyright ⓒ Mediopia Tech All Right Reserved
 * ======================================
 * 작성자/작성일 : shil / 2022. 12. 15.
 * 변경사유/내역 : 최초 작성
 * --------------------------------------
 * 변경자/변경일 :
 * 변경사유/내역 :
 * ======================================
 * </pre>
 **************************************************
 */
public interface DashboardService {

    /**
     * ***************************************************
     * 대시보드 전체설문
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public ProcessResultVO<ReshVO> listSysReschRecent(ReshVO vo) throws Exception;

   /**
    * ***************************************************
    * 현재 학기 조회
    * @param vo
    * @return
    * @throws Exception
    *****************************************************
    */
    public ProcessResultVO<TermVO> listCurTerm(TermVO vo) throws Exception;

   /**
    * ***************************************************
    * 수강생 학기목록 조회
    * @param vo
    * @return
    * @throws Exception
    *****************************************************
    */
    public ProcessResultVO<TermVO> listStdTerm(TermVO vo) throws Exception;

   /**
    * ***************************************************
    * 수강생의 과목 정보
    * @param vo
    * @return
    * @throws Exception
    *****************************************************
    */
    public ProcessResultVO<DashboardVO> stdCourseInfo(DashboardVO vo) throws Exception;

    /**
     * <p>
     * 수강생의 과목 정보(1과목)
     *
     * @param dashboardVO
     * @return
     * @throws Exception
     */
    public ProcessResultVO<DashboardVO> stdCourseInfoOne(CreCrsVO creCrsVO) throws Exception;

   /**
    * ***************************************************
    * 교수 학기목록 조회
    * @param vo
    * @return
    * @throws Exception
    *****************************************************
    */
    public ProcessResultVO<TermVO> listProfTerm(TermVO vo) throws Exception;

   /**
    * ***************************************************
    * 교수의 과목 정보
    * @param vo
    * @return
    * @throws Exception
    *****************************************************
    */
    public ProcessResultVO<DashboardVO> profCourseInfo(DashboardVO vo) throws Exception;

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
     * 관리자 메인 학기 목록
     * @param vo
     * @return
     * @throws Exception
     *****************************************************
     */
    public ProcessResultVO<TermVO> listAdminTerm(TermVO vo) throws Exception;

     /**
      * 대시보드 현재 주차
      * @param vo
      * @return EgovMap
      * @throws Exception
      */
     public EgovMap dashboardCurrentWeek(TermVO vo) throws Exception;

     /**
      * 수업운영 정보 조회
      * @param vo
      * @return EgovMap
      * @throws Exception
      */
     public EgovMap selectLessonManageInfo(HttpServletRequest request, UsrUserInfoVO vo) throws Exception;

     /*****************************************************
      * 관리자 메인 > 과목별 학습현황
      * @param vo
      * @return List<EgovMap>
      * @throws Exception
      ******************************************************/
     public List<EgovMap> listLessonStatusByCrs(DashboardVO vo) throws Exception;

     /*****************************************************
      * 관리자 메인 > 과목별 학습현황 (엑셀)
      * @param vo
      * @return List<EgovMap>
      * @throws Exception
      ******************************************************/
     public List<EgovMap> listLessonStatusByCrsExcel(HttpServletRequest request, DashboardVO vo) throws Exception;

     /*****************************************************
      * 관리자 메인 > 학생별 학습현황
      * @param vo
      * @return List<EgovMap>
      * @throws Exception
      ******************************************************/
     public List<EgovMap> listLessonStatusByStd(DashboardVO vo) throws Exception;

     /*****************************************************
      * 관리자 메인 > 사용자 검색
      * @param vo
      * @return List<EgovMap>
      * @throws Exception
      ******************************************************/
     public ProcessResultVO<EgovMap> listAdminDashUser(DashboardVO vo) throws Exception;

     /**
      * 대시보드 위젯 설정
      * @param DashboardVO
      * @return ProcessResultVO<DashboardVO>
      * @throws Exception
      */
     public ProcessResultVO<DashboardVO> listWidgetSettingPop(DashboardVO vo) throws Exception;

     /*****************************************************
      * 대시보드 위젯 삭제
      * @param DashboardVO
      * @return void
      * @throws Exception
      ******************************************************/
     public void delete(DashboardVO vo) throws Exception;

     /*****************************************************
      * 대시보드 위젯 변경
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
     public EgovMap widgetStngColrSelect(DashboardVO vo) throws Exception;

     public String getUserId(DashboardVO vo) throws Exception;

     /*****************************************************
      * 교수학기목록조회
      * @param DashboardVO
      * @return void
      * @throws Exception
      ******************************************************/
     public ProcessResultVO<TermVO> profSmstrList(TermVO vo) throws Exception;

     /*****************************************************
      * 위젯 팝업화면
      * @param DashboardVO
      * @return void
      * @throws Exception
      ******************************************************/
     public EgovMap widgetStngPopView(DashboardVO vo) throws Exception;

     /*****************************************************
      * 위젯 팝업화면
      * @param DashboardVO
      * @return void
      * @throws Exception
      ******************************************************/
     public EgovMap widgetStngColrPopView(DashboardVO vo) throws Exception;

     /*****************************************************
      * 관리자 메인 > 과목별 학습현황
      * @param vo
      * @return List<EgovMap>
      * @throws Exception
      ******************************************************/
     public EgovMap lgnUsrCntSelect(DashboardVO vo) throws Exception;
     public EgovMap totStdntCntSelect(DashboardVO vo) throws Exception;

     /*****************************************************
      * 관리자 메인 > 과목별 학습현황
      * @param vo
      * @return List<EgovMap>
      * @throws Exception
      ******************************************************/
     public List<EgovMap> sbjctList(DashboardVO vo) throws Exception;

     /*****************************************************
      * 위젯 초기화 - user 테이블 삭제
      * @param AcadSchVO
      * @return void
      * @throws Exception
      ******************************************************/
     public void widgetStngReset(DashboardVO vo) throws Exception;
}