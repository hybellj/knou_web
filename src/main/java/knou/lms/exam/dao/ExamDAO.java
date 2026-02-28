package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.ExamGrpVO;
import knou.lms.exam.vo.ExamTrgtrVO;
import knou.lms.exam.vo.ExamVO;

@Mapper("examDAO")
public interface ExamDAO {

	/**
	* 교수퀴즈목록조회
	*
	* @param sbjctId 		과목아이디
	* @param searchValue 	검색내용(퀴즈명)
	* @param listScale	 	페이지크기
	* @return 퀴즈목록 페이징
	* @throws Exception
	*/
	public List<EgovMap> profQuizListPaging(ExamBscVO vo) throws Exception;

	/**
	 * 퀴즈기본조회
	 *
	 * @param examBscId 	시험기본아이디
	 * @return 시험평가대체정보
	 * @throws Exception
	 */
	public ExamBscVO quizBscSelect(ExamBscVO vo) throws Exception;

	/**
	 * 퀴즈상세조회
	 *
	 * @param examBscId 	시험기본아이디
	 * @param examDtlId 	시험상세아이디
	 * @return 시험평가대체정보
	 * @throws Exception
	 */
	public ExamDtlVO quizDtlSelect(ExamDtlVO vo) throws Exception;

	/**
	 * 시험기본등록
	 *
	 * @param ExamBscVO
	 * @throws Exception
	 */
	public void examBscRegist(ExamBscVO vo) throws Exception;

	/**
	 * 시험상세등록
	 *
	 * @param ExamDtlVO
	 * @throws Exception
	 */
	public void examDtlRegist(ExamDtlVO vo) throws Exception;

	/**
	 * 시험상세삭제
	 *
	 * @param examBscId	시험기본아이디
	 * @throws Exception
	 */
    public void examDtlDelete(String examBscId) throws Exception;

	/**
	 * 시험그룹등록
	 *
	 * @param ExamGrpVO
	 * @throws Exception
	 */
	public void examGrpRegist(ExamGrpVO vo) throws Exception;

	/**
	 * 시험대상자등록
	 *
	 * @param ExamTrgtrVO
	 * @throws Exception
	 */
	public void examTrgtrRegist(ExamTrgtrVO vo) throws Exception;

	/**
	 * 시험대상자삭제
	 *
	 * @param examBscId	시험기본아이디
	 * @throws Exception
	 */
    public void examTrgtrDelete(String examBscId) throws Exception;

	/**
	 * 시험기본수정
	 *
	 * @param ExamBscVO
	 * @throws Exception
	 */
	public void examBscModify(ExamBscVO vo) throws Exception;

	/**
	 * 시험상세수정
	 *
	 * @param ExamDtlVO
	 * @throws Exception
	 */
	public void examDtlModify(ExamDtlVO vo) throws Exception;

	/**
	 * 성적반영퀴즈목록조회
	 *
	 * @param ExamBscVO
	 * @return 성적 반영퀴즈 목록
	 * @throws Exception
	 */
    public List<ExamBscVO> mrkRfltQuizList(ExamBscVO vo) throws Exception;

    /**
	 * 시험평가대체삭제
	 *
	 * @param examSbstId	시험대체아이디
	 * @throws Exception
	 */
    public void examEvlSbstDelete(String examSbstId) throws Exception;

    /**
	* 교수권한과목퀴즈목록조회
	*
	* @param orgId 			기관아이디
	* @param userId 		교수아이디
	* @param dgrsYr 		학사년도
	* @param dgrsSmstrChrt 	학기
	* @param sbjctId	 	과목아이디
	* @param searchValue 	검색내용(퀴즈명)
	* @param listScale	 	페이지크기
	* @return 퀴즈목록 페이징
	* @throws Exception
	*/
	public List<ExamBscVO> profAuthrtSbjctQuizList(ExamBscVO vo) throws Exception;

	/**
	* 퀴즈그룹과목목록조회
	*
	* @param examBscId 	시험기본아이디
	* @return 과목 목록
	* @throws Exception
	*/
	public List<EgovMap> quizGrpSbjctList(String examBscId) throws Exception;

	/**
	* 시험기본아이디조회
	*
	* @param examGrpId		시험그룹아이디
	* @param sbjctId		과목아이디
	* @return examBscId 	시험기본아이디
	* @throws Exception
	*/
	public String examBscIdSelect(ExamBscVO vo) throws Exception;

	/**
	* 퀴즈학습그룹부과제목록조회
	*
	* @param lrnGrpId 	학습그룹아이디
	* @param examBscId 	시험기본아이디
	* @return 퀴즈 부과제 목록
	* @throws Exception
	*/
	public List<ExamDtlVO> quizLrnGrpSubAsmtList(ExamDtlVO vo) throws Exception;

	/**
	 * 퀴즈팀목록조회
	 *
	 * @param examBscId		시험기본아이디
	 * @return 퀴즈 팀 목록
	 * @throws Exception
	 */
    public List<EgovMap> quizTeamList(String examBscId) throws Exception;

    /**
	* 퀴즈팀문제출제완료여부조회
	*
	* @param examBscId 시험기본아이디
	* @throws Exception
	*/
	public Boolean quizTeamQstnsCmptnynSelect(String examBscId) throws Exception;

	/**
	 * 시험응시시작사용자수조회
	 *
	 * @param examBscId 시험기본아이디
	 * @param examDtlId 시험상세아이디
	 * @throws Exception
	 */
	public Integer tkexamStrtUserCntSelect(ExamDtlVO vo) throws Exception;

	/**
	 * 과목분반목록조회
	 *
	 * @param sbjctId		과목아이디
	 * @return 과목분반목록
	 * @throws Exception
	 */
	public List<EgovMap> sbjctDvclasList(String sbjctId) throws Exception;

	/**
	 * 퀴즈성적반영비율목록수정
	 *
	 * @param List<ExamBscVO>
	 * @throws Exception
	 */
	public void quizMrkRfltrtListModify(List<ExamBscVO> list) throws Exception;

	/**
	 * 퀴즈재응시목록수정
	 *
	 * @param List<ExamDtlVO>
	 * @throws Exception
	 */
	public void quizRetkexamListModify(List<ExamDtlVO> list) throws Exception;





    /*****************************************************
     * TODO 시험 정보 조회
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    public ExamVO select(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 목록 조회
     * @param ExamVO
     * @return List<ExamVO>
     * @throws Exception
     ******************************************************/
    public List<ExamVO> list(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 목록 조회 페이징
     * @param ExamVO
     * @return List<ExamVO>
     * @throws Exception
     ******************************************************/
    public List<ExamVO> listPaging(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 내 강의에 등록된 시험 목록 조회
     * @param ExamVO
     * @return List<ExamVO>
     * @throws Exception
     ******************************************************/
    public List<ExamVO> listMyCreCrsExam(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험과 같이 등록된 분반 또는 다른 과목 목록 조회
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listExamCreCrsDecls(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 등록
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExam(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 강의 연결 등록
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamCreCrsRltn(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 수정
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExam(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 삭제 상태로 수정
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamDelYn(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 강의 연결 삭제 상태로 수정
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamCreCrsRltnDelYn(ExamVO vo) throws Exception;

    /*****************************************************
     * 퀴즈 복사
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void copyQuiz(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 강의 연결 조회
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public ExamVO selectCreCrsExamRltn(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 성적 반영 점수 합산 조회
     * @param ExamVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int sumScoreRatio(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 대체 과제 코드로 시험 정보 조회
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    public ExamVO selectByInsRefCd(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 암호화용 파라미터 정보 조회
     * @param ExamVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectExamEncryptoInfo(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험과목 정보 조회
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    public ExamVO selectCreCrsByExam(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 중간/기말 대체 목록 조회
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listExamByInsRef(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 중간/기말 수시, 외국어 시험 목록 조회
     * @param ExamVO
     * @return List<ExamVO>
     * @throws Exception
     ******************************************************/
    public List<ExamVO> listExamByEtc(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 응시 유형 카운트
     * @param ExamVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectStareTypeCount(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 성적 반영 퀴즈 카운트
     * @param ExamVO
     * @return List<ExamVO>
     * @throws Exception
     ******************************************************/
    public List<ExamVO> listQuizScoreAply(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 기타, 대체 과제 정보 조회
     * @param ExamVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectExamInsInfo(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 기타, 대체 과제 미참여자 목록 조회
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listExamInsUser(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 재시험 설정 취소
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void resetReExam(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 대체 과제 코드 삭제
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void resetInsRef(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 중간/기말 시작 여부
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    public ExamVO selectExamWait(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 중간/기말 대체평가 연결 가능 목록
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listSetInsRef(ExamVO vo) throws Exception;

}
