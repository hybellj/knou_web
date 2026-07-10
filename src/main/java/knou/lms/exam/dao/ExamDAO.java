package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.ExamGrpVO;
import knou.lms.exam.vo.ExamTrgtrVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.exam.web.view.QuizPageInfo;

@Mapper("examDAO")
public interface ExamDAO {

    /*****************************************************
     * 신규 작성 DAO 영역
     *****************************************************/
    /************************ 교수 ************************/
    // 시험기본등록 (시험 화면 전용)
    public void examBscRegist2(ExamBscVO vo);

    // 시험 상세 등록 (수정용)
    public void examDtlRegist2(ExamDtlVO vo);

    // 시험 대상자 등록 (수정용)
    public void examTrgtrRegist2(ExamTrgtrVO vo);

    // 시험 그룹 등록
    public void examGrpRegist2(ExamVO vo);

    // 대체 시험 등록
    public void examSbstRegist(ExamVO vo);

    // 대체 과제 등록
    public void sbstAsmtRegist(ExamVO vo);

    // 대체 시험 기본(퀴즈) 등록
    public void sbstQuizBscRegist(ExamVO vo);

    // 대체 시험 상세(퀴즈) 등록
    public void sbstQuizDtlRegist(ExamVO vo);

    // 온라인시험퀴즈 등록
    public void onlnExamquizRegist(ExamVO vo);

    // 교수 시험목록 조회
    public List<ExamVO> listProfExam (ExamVO vo);

    // 교수 시험목록 페이징
    public List<ExamVO> listProfExamPaging(ExamVO vo);

    // 교수 시험 상세조회
    public ExamVO selectProfExamDtl(ExamVO vo);

    // 교수 팀 시험 상세조회
    public List<ExamVO> selectProfExamTeamDtl (ExamVO vo);

    // 교수 시험목록 카운트
    public int countProfExam(ExamVO vo);

    // 시험 평가대상자 목록 페이징
    public List<ExamVO> listTkexamUserPaging(ExamVO vo);

    // 시험 평가대상자 카운트
    public int countTkexamUser(ExamVO vo);

    // 시험 평가대상자 목록 조회
    public List<EgovMap> tkexamUserList(Map<String, Object> vo);

    // 팀 시험여부 조회
    public ExamVO selectBscTeamYn (ExamVO vo);

    // 성적 반영 시험 목록
    public List<ExamBscVO> mrkRfltExamList(ExamBscVO vo);

    // 사용자 시험 응시현황 (파이)차트데이터 조회
    public EgovMap selectUserTkexamStatusForPieChart(@Param("examBscId") String examBscId, @Param("sbjctId") String sbjctId);

    // 사용자 시험 응시현황 (가로선)차트데이터 조회
    public List<EgovMap> selectUserTkexamStatusForHrChart(@Param("examBscId") String examBscId, @Param("sbjctId") String sbjctId);

    // 교수 시험대체 목록 페이징
    public List<ExamVO> listProfSbstPaging(ExamVO vo);

    // 교수 시험대체 목록 카운트
    public int countProfSbst(ExamVO vo);

    // 교수 시험대체 대상자 목록 페이징
    public List<ExamVO> listProfSbstUserPaging(ExamVO vo);

    // 교수 시험대체 대상자 목록 카운트
    public int countProfSbstUser(ExamVO vo);

    // 교수 시험대체 과제 조회
    public ExamVO selectProfSbstAsmt(ExamVO vo);

    // 교수 시험대체 퀴즈 조회
    public ExamVO selectProfSbstQuiz(ExamVO vo);

    // 교수 시험대체 퀴즈 조회
    public String selectSbstQuizExamQstnsCmptnyn(ExamVO vo);

    // 교수 시험 결시자 목록 페이징
    public List<ExamVO> listProfAbsnceUserPaging(ExamVO vo);

    // 교수 시험 결시자 목록 카운트
    public int countProfAbsnceUser(ExamVO vo);

    // 교수 시험 결시자 목록 조회
    public List<EgovMap> listProfAbsnceUser(Map<String, Object> vo);

    // 결시자 결시신청 결과 조회
    public ExamVO selectAbsnceRslt (ExamVO vo);

    // 결시자 결시신청 이력 목록 페이징
    public List<ExamVO> listAbsnceUserHstrPaging(ExamVO vo);

    // 결시자 결시신청 이력 목록 카운트
    public int countAbsnceUserHstr(ExamVO vo);

    // 과목 아이디 기준 결시 목록 조회 (거절건 제외)
    public List<EgovMap> listAbsnceBySbjctId(String sbjctId);

    // 장애인/고령자 시험 지원 목록 페이징
    public List<ExamVO> listDsblUserPaging(ExamVO vo);

    // 장애인/고령자 시험 지원 목록 카운트
    public int countDsblUser(ExamVO vo);

    // 장애인/고령자 시험 지원 목록 조회
    public List<EgovMap> dsblUserList(Map<String, Object> vo);

    // 장애인/고령자 시험 지원 상세 조회
    public ExamVO selectDsblDtl (ExamVO vo);

    // 교수 퀴즈 관리 퀴즈 목록 페이징
    public List<ExamVO> listExamQuizPaging(ExamVO vo);

    // 교수 퀴즈 관리 퀴즈 목록 카운트
    public int countExamQuiz(ExamVO vo);

    // 교수 퀴즈관리 퀴즈 조회
    public ExamVO selectProfQuizMng (ExamVO vo);

    // 수강생 시험 응시현황 목록 페이징
    public List<ExamVO> listUserTkexamStatPaging(ExamVO vo);

    // 수강생 시험 응시현황 목록 카운트
    public int countUserTkexamStat(ExamVO vo);

    // 중간, 기말 시험 ID 목록 조회
    public List<EgovMap> listExamMidLst(String sbjctId);

    // 대체 과제 ID 조회
    public String selectAsmtSbstId(String asmtId);

    // 퀴즈 시험아이디 조회
    public String selectExamQuizBscId(String examBscId);

    // 시험지 조회
    public List<EgovMap> selectExamppr(String examBscId);

    // 성적 공개여부 수정
    public void updateMrkOyn(ExamVO vo);

    // 시험 성적 반영비율 수정
    public void examMrkRfltrtListModify(List<ExamBscVO> list);

    // 시험 기본정보 수정
    public void updateExamBscInfo(ExamVO vo);

    // 시험 기본정보 (그룹) 수정
    public void updateExamBscGrp(ExamVO vo);

    // 시험 상세정보 수정
    public void updateExamDtlInfo(ExamVO vo);

    // 대체 시험 수정
    public void updateExamSbst(ExamVO vo);

    // 대체 과제 수정
    public void updateSbstAsmt(ExamVO vo);

    // 대체 시험(퀴즈) 기본정보 수정
    public void updateExamSbstBsc(ExamVO vo);

    // 대체 시험(퀴즈) 기본정보 수정
    public void updateExamQstnsCmptnyn(ExamVO vo);

    // 시험 기본정보 삭제
    public void deleteExamBscInfo(ExamVO vo);

    // 시험 상세정보 삭제
    public void deleteExamDtlInfo(ExamVO vo);

    // 시험 대상자 삭제
    public void deleteExamTrgtr(ExamVO vo);

    // 시험 대상자 삭제
    public void removeExamOnqz(ExamVO vo);

    // 대체 시험 삭제
    public void deleteExamSbst(ExamVO vo);

    // 대체 과제 삭제
    public void deleteSbstAsmt(ExamVO vo);

    // 시험 그룹 삭제
    public void deleteExamGrp(ExamVO vo);

    /************************ 학습자 ************************/

    // 학습자 결시신청 등록 (재시험 포함)
    public void registStdntAbsnce(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 등록
    public void registStdntSprtAply(ExamVO vo);

    // 학습자 시험 목록 페이징
    public List<ExamVO> listStdntExamPaging(ExamVO vo);

    // 학습자 시험 목록 카운트
    public int countStdntExam(ExamVO vo);

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
    public List<ExamVO> listStdntAbsncePaging(ExamVO vo);

    // 학습자 결시신청 목록 카운트
    public int countStdntAbsnce(ExamVO vo);

    // 학습자 결시신청 기본정보 조회
    public ExamVO selectStdntAbsnceInfo(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 신청 목록 페이징
    public List<ExamVO> listStdntSprtAplyPaging(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 신청 목록 카운트
    public int countStdntSprtAply(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 신청 정보 조회
    public ExamVO selectStdntSprtAplyInfo(ExamVO vo);

    // 학습자 장애인/고령자 시험지원 취소
    public void modifyStdntSprtCnclAply(ExamVO vo);

    /************************ 관리자 ************************/

    // 관리자 장애인/고령자 지원관리 신청 목록 페이징
    public List<ExamVO> listAdmSprtAplyPaging(ExamVO vo);

    // 관리자 장애인/고령자 지원관리 신청 카운트
    public int countAdmSprtAply(ExamVO vo);

    // 관리자 장애인/고령자 지원관리 신청 목록 전체 (엑셀용)
    public List<ExamVO> listAdmSprtAply(ExamVO vo);

    // 관리자 장애인/고령자 지원관리 상세보기
    public ExamVO selectAdmSprtAplyDtl(ExamVO vo);

    // 관리자 장애인/고령자 시험지원 신청 승인/반려
    public void modifySprtAplyStat(ExamVO vo);

    // 관리자 장애인/고령자 시험지원 취소신청 승인/반려
    public void modifySprtAplyCnclStat(ExamVO vo);

    /*****************************************************
     * 기존에 있던 DAO 영역
     *****************************************************/
	// 교수퀴즈목록조회
	public List<EgovMap> profQuizListPaging(QuizPageInfo pageInfo);

	// 퀴즈기본조회
	public ExamBscVO quizBscSelect(ExamBscVO vo);

	// 퀴즈상세조회
	public ExamDtlVO quizDtlSelect(ExamDtlVO vo);

	// 시험기본등록
	public void examBscRegist(ExamBscVO vo);

	// 시험상세등록
	public void examDtlRegist(ExamDtlVO vo);

	// 시험상세삭제
    public void examDtlDelete(String examBscId);

    // 시험상세삭제여부수정
    public void examDtlDelynModify(ExamBscVO vo);

	// 시험그룹등록
	public void examGrpRegist(ExamGrpVO vo);

	// 시험대상자등록
	public void examTrgtrRegist(ExamTrgtrVO vo);

	// 시험대상자삭제
    public void examTrgtrDelete(String examBscId);

	// 시험기본수정
	public void examBscModify(ExamBscVO vo);

	// 시험상세수정
	public void examDtlModify(ExamDtlVO vo);

	// 성적반영퀴즈목록조회
    public List<ExamBscVO> mrkRfltQuizList(ExamBscVO vo);

    // 시험평가대체삭제
    public void examEvlSbstDelete(String examSbstId);

    // 교수권한과목퀴즈목록조회
	public List<EgovMap> profAuthrtSbjctQuizList(Map<String, Object> params);

	// 퀴즈그룹과목목록조회
	public List<EgovMap> quizGrpSbjctList(String examBscId);

	// 시험기본아이디조회
	public String examBscIdSelect(ExamBscVO vo);

	// 퀴즈팀그룹부퀴즈목록조회
	public List<ExamDtlVO> quizTeamGrpSubQuizList(ExamDtlVO vo);

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

	// 퀴즈재응시목록수정
	public void quizRetkexamListModify(List<ExamDtlVO> list);

	// 시험지일괄엑셀다운퀴즈대상자목록조회
	public List<EgovMap> exampprBulkExcelDownQuizTrgtrList(ExamBscVO vo);

	// 문제가져오기학기기수목록조회
	public List<EgovMap> qstnCopySmstrList(@Param("orgId") String orgId, @Param("dgrsYr") String dgrsYr);

	// 문제가져오기과목목록조회
	public List<EgovMap> qstnCopySbjctList(@Param("smstrChrtId") String smstrChrtId, @Param("sbjctId") String sbjctId);

	// 학기기수과목목록조회
	public List<EgovMap> smstrChrtSbjctList(@Param("orgId") String orgId, @Param("smstrChrtId") String smstrChrtId, @Param("sbjctYr") String sbjctYr);

	// 강의주차목록조회
	public List<EgovMap> lctrWknoList(@Param("sbjctId") String sbjctId);

	// 다른과목강의주차조회
	public String otherSbjctLctrWknoSelect(@Param("sbjctId") String sbjctId, @Param("lctrWknoSchdlId") String lctrWknoSchdlId);

	// 문제가져오기퀴즈목록조회
	public List<ExamDtlVO> qstnCopyQuizList(@Param("sbjctId") String sbjctId);

	// 학생퀴즈목록조회
	public List<EgovMap> stdntQuizListPaging(QuizPageInfo pageInfo);

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

	public List<EgovMap> bySubjectQuizList(ExamBscVO vo);

	public List<EgovMap> bySubjectExamList(ExamBscVO vo);

}
