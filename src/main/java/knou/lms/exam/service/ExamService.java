package knou.lms.exam.service;

import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.ExamStarePaperVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.exam.web.view.QuizPageInfo;
import knou.lms.forum.vo.ForumVO;
import knou.lms.std.vo.StdVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface ExamService {

    /*****************************************************
     * 신규 작성 Service 영역
     *****************************************************/
    /************************ 교수 ************************/
    // 시험 등록
    public ExamBscVO examRegist(ExamBscVO vo);

    // 대체 시험 등록
    public ExamVO examSbstRegist(ExamVO vo);

    // 퀴즈 시험 등록
    public ExamVO examQuizRegist(ExamVO vo);

    // 교수 시험목록 페이징
    public ProcessResultVO<ExamVO> listProfExamPaging(ExamVO vo);

    // 교수 시험 상세조회
    public ExamVO selectProfExamDtl(ExamVO vo);

    // 교수 팀 시험 상세조회
    public List<ExamVO> selectProfExamTeamDtl (ExamVO vo);

    // 시험 평가대상자 목록 페이징
    public ProcessResultVO<ExamVO> listTkexamUserPaging(ExamVO vo);

    // 시험 평가대상자 목록 카운트
    public int countTkexamUser(ExamVO vo);

    // 시험 평가대상자 목록 조회
    public List<EgovMap> tkexamUserList(Map<String, Object> vo);

    // 사용자 시험 응시현황 (파이)차트데이터 조회
    public EgovMap selectUserTkexamStatusForPieChart(String examBscId, String sbjctId);

    // 사용자 시험 응시현황 (가로선)차트데이터 조회
    public List<EgovMap> selectUserTkexamStatusForHrChart(String examBscId, String sbjctId);

    // 교수 시험대체 목록 페이징
    public ProcessResultVO<ExamVO> listProfSbstPaging(ExamVO vo);

    // 교수 시험대체 대상자 목록 페이징
    public ProcessResultVO<ExamVO> listProfSbstUserPaging(ExamVO vo);

    // 교수 시험대체 과제 조회
    public ExamVO selectProfSbstAsmt(ExamVO vo);

    // 교수 시험대체 퀴즈 조회
    public ExamVO selectProfSbstQuiz(ExamVO vo);

    // 교수 시험 결시자 목록 페이징
    public ProcessResultVO<ExamVO> listProfAbsnceUserPaging(ExamVO vo);

    // 교수 시험 결시자 목록 조회
    public List<EgovMap> listProfAbsnceUser(Map<String, Object> vo);

    // 결시자 결시신청 결과 조회
    public ExamVO selectAbsnceRslt(ExamVO vo);

    // 결시자 결시신청 이력 목록 페이징
    public ProcessResultVO<ExamVO> listAbsnceUserHstrPaging(ExamVO vo);

    // 결시자 목록 조회 (과목아이디 기준)
    public List<EgovMap> listAbsnceBySbjctId(String sbjctId);

    // 장애인/고령자 시험 지원 목록 페이징
    public ProcessResultVO<ExamVO> listDsblUserPaging(ExamVO vo);

    // 장애인/고령자 시험 지원 목록 조회
    public List<EgovMap> dsblUserList(Map<String, Object> vo);

    // 장애인/고령자 시험 지원 상세 조회
    public ExamVO selectDsblDtl(ExamVO vo);

    // 교수 퀴즈 관리 퀴즈 목록 페이징
    public ProcessResultVO<ExamVO> listExamQuizPaging(ExamVO vo);

    // 교수 퀴즈관리 퀴즈 조회
    public ExamVO selectProfQuizMng (ExamVO vo);

    // 수강생 시험 응시현황 목록 페이징
    public ProcessResultVO<ExamVO> listUserTkexamStatPaging(ExamVO vo);

    // 중간, 기말 시험 ID 목록 조회
    public List<EgovMap> listExamMidLst(String sbjctId);

    // 퀴즈 시험아이디 조회
    public String selectExamQuizBscId (String examBscId);

    // 시험지 조회
    public List<EgovMap> selectExamppr(String examBscId);

    // 성적 반영비율 수정
    public void examMrkRfltrtListModify(List<ExamBscVO> list);

    // 성적 공개여부 수정
    public void updateMrkOyn(ExamVO vo);

    // 시험 수정
    public void updateExamDtlInfo(ExamVO vo);

    // 대체 시험 수정
    public void updateExamSbst(ExamVO vo);

    // 퀴즈 시험 수정
    public void modifyExamQuizDtlInfo(ExamVO vo);

    // 시험 삭제
    public void deleteExamBsc(ExamVO vo);

    // 대체 시험 삭제
    public void deleteExamSbst(ExamVO vo);

    // 퀴즈 시험 삭제
    public void removeExamQuiz(ExamVO vo);

    /************************ 학습자 ************************/

    // 학습자 결시신청 등록 (재시험 포함)
    public ExamVO registStdntAbsnce(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 등록
    public ExamVO registStdntSprtAply(ExamVO vo);

    // 학습자 시험 목록 페이징
    public ProcessResultVO<ExamVO> listStdntExamPaging(ExamVO vo);

    // 학습자 장애인/고령자 여부
    public String stdntDsblSnrYn(String userId);

    // 학습자 대체과제 ID 조회
    public String selectStdntSbstAsmtId(ExamVO vo);

    // 학습자 대체과제 피드백 기본정보 조회
    public ExamVO selectStdntSbstAsmtFdbkInfo(ExamVO vo);

    // 학습자 시험 응시기록 조회
    public List<ExamVO> selectStdntTkexamHist(ExamVO vo);

    // 학습자 시험 응시결과 조회
    public ExamVO selectStdntTkexamRslt(ExamVO vo);

    // 학습자 시험상세 ID 및 팀 ID 조회
    public ExamVO selectStdntDtlIdAndTeamId(ExamVO vo);

    // 학습자 퀴즈 상세 아이디 조회
    public String selectStdntQuizDtlId(ExamVO vo);

    // 학습자 대체 시험 조회
    public ExamVO selectStdntSbstInfo(ExamVO vo);

    // 학습자 대체 과제 제출기록 조회
    public List<ExamVO> selectStdntSbstAsmtSbmtHist(ExamVO vo);

    // 학습자 대체 과제 평가결과 조회
    public ExamVO selectStdntSbstAsmtRslt(ExamVO vo);

    // 학습자 결시신청 목록 페이징
    public ProcessResultVO<ExamVO> listStdntAbsncePaging(ExamVO vo);

    // 학습자 결시신청 기본정보 조회
    public ExamVO selectStdntAbsnceInfo(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 신청 목록 페이징
    public ProcessResultVO<ExamVO> listStdntSprtAplyPaging(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 신청 정보 조회
    public ExamVO selectStdntSprtAplyInfo(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 취소
    public void modifyStdntSprtCnclAply(ExamVO vo);

    /************************ 관리자 ************************/

    // 관리자 장애인/고령자 지원관리 신청 목록 페이징
    public ProcessResultVO<ExamVO> listAdmSprtAplyPaging(ExamVO vo);

    // 관리자 장애인/고령자 지원관리 상세보기
    public ExamVO selectAdmSprtAplyDtl(ExamVO vo);

    // 관리자 장애인/고령자 지원관리 신청 목록 전체 (엑셀용)
    public List<ExamVO> listAdmSprtAply(ExamVO vo);

    // 관리자 장애인/고령자 시험지원 신청 승인/반려
    public void modifySprtAplyStat(ExamVO vo);

    // 관리자 장애인/고령자 시험지원 취소신청 승인/반려
    public void modifySprtAplyCnclStat(ExamVO vo);

    /*****************************************************
     * 기존에 있던 Service 영역
     *****************************************************/
	// 교수퀴즈목록조회
    public ResultDTO<EgovMap> profQuizListPaging(QuizPageInfo pageInfo);

	// 퀴즈정보조회
	public ExamBscVO quizSelect(ExamBscVO vo);

	// 퀴즈등록
	public ExamBscVO quizRegist(ExamBscVO vo, Map<String, String> subMap);

	// 퀴즈수정
	public ExamBscVO quizModify(ExamBscVO vo, Map<String, String> subMap);

	// 시험기본수정
    public void examBscModify(ExamBscVO vo);

    // 시험상세수정
    public void examDtlModify(ExamDtlVO vo);

    // 퀴즈성적반영비율수정
    public void quizMrkRfltrtModify(ExamBscVO vo);

    // 퀴즈삭제
    public void quizDelete(ExamBscVO vo);

    // 교수권한과목퀴즈목록조회
	public List<EgovMap> profAuthrtSbjctQuizList(Map<String, Object> params);

	// 퀴즈그룹과목목록조회
	public List<EgovMap> quizGrpSbjctList(String examBscId);

	// 퀴즈팀그룹부퀴즈목록조회
	public List<ExamDtlVO> quizTeamGrpSubQuizList(ExamDtlVO vo);

	// 퀴즈문제출제완료수정
	public void quizQstnsCmptnModify(ExamBscVO vo);

	// 퀴즈팀목록조회
	public List<EgovMap> quizTeamList(String examBscId);

	// 퀴즈팀문제출제완료여부조회
	public Boolean quizTeamQstnsCmptnynSelect(String examBscId);

	// 시험응시시작사용자수조회
	public Integer tkexamStrtUserCntSelect(ExamDtlVO vo);

	// 과목분반목록조회
	public List<EgovMap> sbjctDvclasList(String sbjctId);

	// 퀴즈성적반영비율목록수정
	public void quizMrkRfltrtListModify(List<ExamBscVO> list);

	// 시험지일괄엑셀다운퀴즈대상자목록조회
	public List<EgovMap> exampprBulkExcelDownQuizTrgtrList(ExamBscVO vo);

	// 문제가져오기학기기수목록조회
	public List<EgovMap> qstnCopySmstrList(String orgId, String dgrsYr);

	// 문제가져오기과목목록조회
	public List<EgovMap> qstnCopySbjctList(String smstrChrtId, String sbjctId);

	// 학기기수과목목록조회
	public List<EgovMap> smstrChrtSbjctList(String orgId, String smstrChrtId, String sbjctYr);

	// 강의주차목록조회
	public List<EgovMap> lctrWknoList(String sbjctId);

	// 문제가져오기퀴즈목록조회
	public List<ExamDtlVO> qstnCopyQuizList(String sbjctId);

	// 학생퀴즈목록조회
    public ResultDTO<EgovMap> stdntQuizListPaging(QuizPageInfo pageInfo);

    // 학생퀴즈조회
 	public EgovMap stdntQuizSelect(Map<String, Object> params);






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


	public List<EgovMap> bySubjectQuizList(ExamBscVO vo) ;

	public List<EgovMap> bySubjectExamList(ExamBscVO vo) ;

}
