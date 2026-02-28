package knou.lms.exam.service;

import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.ExamStarePaperVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.forum.vo.ForumVO;
import knou.lms.std.vo.StdVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface ExamService {

	/**
     * 교수퀴즈목록조회
     *
     * @param sbjctId	 과목아이디
     * @param searchValue  검색내용(퀴즈명)
     * @return 퀴즈목록 페이징
     * @throws Exception
     */
    public ProcessResultVO<EgovMap> profQuizListPaging(ExamBscVO vo) throws Exception;

	/**
	* 퀴즈정보조회
	*
	* @param examBscId 퀴즈기본아이디
	* @return 퀴즈 정보
	* @throws Exception
	*/
	public ExamBscVO quizSelect(ExamBscVO vo) throws Exception;

	/**
	* 퀴즈등록
	*
	* @param ExamBscVO
	* @throws Exception
	*/
	public ExamBscVO quizRegist(ExamBscVO vo) throws Exception;

	/**
	 * 퀴즈수정
	 *
	 * @param ExamBscVO
	 * @throws Exception
	 */
	public ExamBscVO quizModify(ExamBscVO vo) throws Exception;

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
     * 퀴즈성적반영비율수정
     *
     * @param sbjctId	과목아이디
     * @param mdfrId	수정자아이디
     * @throws Exception
     */
    public void quizMrkRfltrtModify(ExamBscVO vo) throws Exception;

    /**
     * 퀴즈삭제
     *
     * @param examBscId		시험기본아이디
     * @param mdfrId		수정자아이디
     * @throws Exception
     */
    public void quizDelete(ExamBscVO vo) throws Exception;

    /**
	* 교수권한과목퀴즈목록조회
	*
	* @param userId 		교수아이디
	* @param dgrsYr 		학사년도
	* @param dgrsSmstrChrt 	학기
	* @param sbjctId 		과목아이디
	* @param searchValue 	검색내용(퀴즈명)
	* @param listScale	 	페이지크기
	* @return 퀴즈목록 페이징
	* @throws Exception
	*/
	public ProcessResultVO<ExamBscVO> profAuthrtSbjctQuizList(ExamBscVO vo) throws Exception;

	/**
	* 퀴즈그룹과목목록조회
	*
	* @param examBscId 	시험기본아이디
	* @return 과목 목록
	* @throws Exception
	*/
	public List<EgovMap> quizGrpSbjctList(String examBscId) throws Exception;

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
     * 퀴즈문제출제완료수정
     *
     * @param examBscId		시험기본아이디
     * @param examDtlId		시험상세아이디
     * @param searchGubun 	수정상태 ( save, edit )
     * @throws Exception
     */
	public void quizQstnsCmptnModify(ExamBscVO vo) throws Exception;

	/**
	* 퀴즈팀목록조회
	*
	* @param examBscId 	시험기본아이디
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
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamVO> list(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 목록 조회 페이징
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamVO> listPaging(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 내 강의에 등록된 시험 목록 조회
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamVO> listMyCreCrsExam(ExamVO vo) throws Exception;

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
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    public ExamVO insertExam(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 수정
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    public ExamVO updateExam(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 삭제 상태로 수정
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamDelYn(ExamVO vo) throws Exception;

    /*****************************************************
     * 퀴즈 복사
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    public void copyQuiz(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 문항 출제 완료
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamVO> updateExamSubmitYn(ExamVO vo, HttpServletRequest request) throws Exception;

    /*****************************************************
     * TODO 시험 성적 반영 점수 합산 조회
     * @param ExamVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int sumScoreRatio(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 문제 보기문항 통계 바차트
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> examQstnBarChart(ExamStarePaperVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 문제 정답 통계 파이차트
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> examQstnPieChart(ExamStarePaperVO vo) throws Exception;

    /*****************************************************
     * TODO 시험지 문항 전체정답처리 및 성적 점수 수정
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQstnAllRightScore(ExamStarePaperVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 성적 공개 여부 수정
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamScoreOpen(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 시험 암호화용 파라미터 정보 조회
     * @param ExamVO
     * @return ExamVO
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
     * 시험 응시 사전 등록
     * @param vo
     * @param crsCreCd
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamStare(ExamVO vo, String crsCreCd) throws Exception;

    /*****************************************************
     * TODO 대체 과제, 토론, 퀴즈 삭제시 시험 대체코드 삭제
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void examInsDelete(String insRefCd) throws Exception;

    /*****************************************************
     * TODO 대체 과제, 토론, 퀴즈 등록, 수정
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public ExamVO examInsRefManage(ExamVO examVO, AsmtVO asmtVO, ForumVO forumVO, HttpServletRequest request) throws Exception;

    /*****************************************************
     * TODO 시험지 랜덤 등록
     * @param ExamVO, List<StdVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertRandomPaper(ExamVO vo, List<StdVO> stdList) throws Exception;

    public void setScoreRatio(ExamVO vo) throws Exception;

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
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> listSetInsRef(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 중간/기말 대체평가 연결
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void setInsRef(ExamVO vo) throws Exception;

    /*****************************************************
     * TODO 중간/기말 대체평가 연결해제
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void setInsRefCancel(ExamVO vo) throws Exception;

}
