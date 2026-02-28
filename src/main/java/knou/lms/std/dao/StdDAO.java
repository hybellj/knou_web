package knou.lms.std.dao;

import knou.lms.asmt.vo.AsmtVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.std.vo.LearnStopRiskIndexVO;
import knou.lms.std.vo.StdVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

@Mapper("stdDAO")
public interface StdDAO {

    /*****************************************************
     * 학습자 정보 조회
     * @param StdVO
     * @return StdVO
     * @throws Exception
     ******************************************************/
    public StdVO select(StdVO vo) throws Exception;

    /*****************************************************
     * 학습자 목록 조회
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> list(StdVO vo) throws Exception;

    /*****************************************************
     * 학습자 목록 조회 페이징
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listPageing(StdVO vo) throws Exception;

    // 해당과목 학습자 수
    public int count(StdVO vo) throws Exception;

    // 수강생 목록
    public List<StdVO> stdList(StdVO vo) throws Exception;

    /*****************************************************
     * 강의실 학생 조회
     * @param StdVO
     * @return StdVO
     * @throws Exception
     ******************************************************/
    public StdVO selectStd(StdVO vo) throws Exception;

    /*****************************************************
     * 수강정보 > 수강생 정보 목록
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listStudentInfo(StdVO vo) throws Exception;

    /*****************************************************
     * 수강정보 > 수강생 정보 목록 페이징
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listStudentInfoPaging(StdVO vo) throws Exception;

    /*****************************************************
     * 수강정보 > 수강생 정보 목록 수
     * @param StdVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int countStudentInfo(StdVO vo) throws Exception;

    /*****************************************************
     * 수강정보 > 장애학생 정보 목록 페이징
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listDisablilityStudentInfoPaging(StdVO vo) throws Exception;

    /*****************************************************
     * 수강정보 > 장애학생 정보 목록 수
     * @param StdVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int countDisablilityStudentInfo(StdVO vo) throws Exception;

    /*****************************************************
     * 수강정보 > 수강생 정보 엑셀 리스트
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listStudentInfoExcel(StdVO vo) throws Exception;

    /*****************************************************
     * 수강생 학습현황 > 이전, 다음 수강생 정보
     * @param StdVO
     * @return StdVO
     * @throws Exception
     ******************************************************/
    public StdVO prevNextStudentInfo(StdVO vo) throws Exception;

    /*****************************************************
     * 수강생 학습현황 > 수강생 정보
     * @param StdVO
     * @return StdVO
     * @throws Exception
     ******************************************************/
    public StdVO selectStudentInfo(StdVO vo) throws Exception;

    /*****************************************************
     * 강의실 학습요소 참여현황 목록
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listStdJoinStatus(StdVO vo) throws Exception;

    /*****************************************************
     * 주차별 학생 출석현황
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listAttendByLessonSchedule(StdVO vo) throws Exception;

    /*****************************************************
     * 강의실 출석현황
     * @param StdVO
     * @return List<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    public List<Map<String, Object>> listAttend(StdVO vo) throws Exception;

    /*****************************************************
     * 주차별 미학습자 비율
     * @param StdVO
     * @return Map<String, Object>
     * @throws Exception
     ******************************************************/
    public Map<String, Object> noAttendRateByWeek(StdVO vo) throws Exception;

    /*****************************************************
     * 주차 미학습자 목록
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listNoStudyWeek(StdVO vo) throws Exception;

    /*****************************************************
     * 학생 학습 진도율
     * @param StdVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectStdLessonProgress(StdVO vo) throws Exception;

    /*****************************************************
     * 제출/참여 이력 목록 (과제)
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listSubmitHistoryAsmnt(StdVO vo) throws Exception;

    /*****************************************************
     * 제출/참여 이력 목록 (과제 파일)
     * @param AsmntVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listAsmntSbmtFile(AsmtVO vo) throws Exception;

    /*****************************************************
     * 제출/참여 이력 목록 (과제 활동이력)
     * @param AsmntVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listAsmntJoinHsty(AsmtVO vo) throws Exception;

    /*****************************************************
     * 제출/참여 이력 목록 (퀴즈)
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listSubmitHistoryQuiz(StdVO vo) throws Exception;

    /*****************************************************
     * 제출/참여 이력 목록 (설문)
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listSubmitHistoryResch(StdVO vo) throws Exception;

    /*****************************************************
     * 제출/참여 이력 목록 (토론)
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listSubmitHistoryForum(StdVO vo) throws Exception;


    /**
     * 학습자 상세 정보를 조회한다.
     *
     * @param StdVO
     * @return StdVO
     * @throws Exception
     */
    public StdVO selectDetail(StdVO vo) throws Exception;

    public void deleteStd(StdVO stdvo) throws Exception;

    public StdVO stdSelect(StdVO vo) throws Exception;

    public void mergeStd(StdVO stdvo) throws Exception;

    public void mergeStdBatch(List<StdVO> list) throws Exception;

    public List<StdVO> listPaging(StdVO vo) throws Exception;

    public List<StdVO> exList(StdVO vo) throws Exception;

    /**
     * 강의실 목록
     *
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listCrsCre(CreCrsVO vo) throws Exception;

    /**
     * 강의실 수강생 사용자목록(by stdNo)
     *
     * @return List<StdVO>
     * @throws Exception
     */
    public List<StdVO> listUserByStdNo(StdVO vo) throws Exception;

    /**
     * 임시 수강생 등록
     *
     * @param StdVO
     * @return
     * @throws Exception
     */
    public void insertTmpStd(StdVO vo) throws Exception;

    /**
     * 학기 수강생 전체 조회
     *
     * @return List<StdVO>
     * @throws Exception
     */
    public List<StdVO> selectStdAll(StdVO vo) throws Exception;

    /*****************************************************
     * 강의평가 참여여부 조회
     * @param StdVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectLectEvalJoinCnt(StdVO vo) throws Exception;

    /*****************************************************
     * 학업중단 위험지수 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countLearnStopRiskIndex(LearnStopRiskIndexVO vo) throws Exception;

    /*****************************************************
     * 학업중단 위험지수 페이징 목록
     * @param vo
     * @return List<LearnStopRiskIndexVO>
     * @throws Exception
     ******************************************************/
    public List<LearnStopRiskIndexVO> listPagingLearnStopRiskIndex(LearnStopRiskIndexVO vo) throws Exception;

    /*****************************************************
     * 학업중단 위험지수 등록
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public void mergeLearnStopRiskIndex(List<LearnStopRiskIndexVO> list) throws Exception;

    /**
     * 강의실 등록 모든 학생 조회
     *
     * @return List<StdVO>
     * @throws Exception
     */
    public List<StdVO> listRegistStd(StdVO vo) throws Exception;

    /*****************************************************
     * 수강생별 학습기록 수강생 조회
     * @param vo
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listStudentRecord(StdVO vo) throws Exception;

    /*****************************************************
     * 수강생별 과목 목록 조회
     * @param vo
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listStudentCreCrs(StdVO vo) throws Exception;

    /*****************************************************
     * 수강생목록 전체 조회(선수강과목 이관용)
     * @param vo
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listStdForTrans(StdVO vo) throws Exception;

    /**
     * 수강생 목록 저장(선수강과목 이관용)
     *
     * @param List<StdVO>
     * @return
     * @throws Exception
     */
    public void insertStdListForTrans(List<StdVO> stdList) throws Exception;
}
