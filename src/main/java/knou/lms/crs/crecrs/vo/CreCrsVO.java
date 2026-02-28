package knou.lms.crs.crecrs.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crsCtgr.vo.CrsCtgrVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.org.vo.OrgCodeVO;

public class CreCrsVO extends DefaultVO {

    private static final long serialVersionUID = 4082505823708268628L;

    private int fileSn;
    private String  curCrsCreCd;
    private String  crsCreCd;                  // 과정 개설 코드
    private String  crsCd;                     // 과정 코드
    private String  crsCreNm;                  // 과정 개설 명
    private String  crsCreNmEng;               // 과정 개설 영문명
    private String  creYear;                   // 개설 년도
    private String  creTerm;                   // 개설 학기(기수)
    private String  creTermNm;                 // 개설 학기(기수)명
    private String  declsNo;                   // 분반 번호
    private String  crsCreDesc;                // 과정 개설 설명
    private String  crsOperTypeCd;             // 과정 운영 유형 코드
    private String  deptCd;                    // 부서 코드
    private String  deptNm;                    // 부서명
    private double  credit;                   // 학점
    private String  compDvCd;                  // 이수구분코드
    private String  compDvNm;                  // 이수구분코드명
    private String  progressTypeCd;            // 강의형식코드
    private String  learningControl;           // 학습제어
    private String  midAttendChkUseYn;         // 중간출석여부
    private String  certYn;                    // 수료증 출력여부
    private String  certScoreYn;               // 수료증조건
    private String  cpltHandlType;             // 수료 처리 형태
    private Integer cpltScore;                 // 수료 점수
    private Integer certScoreDel;              // 수료 점수 DEL
    private Integer attdRatioDel;              // 술석 비율 DEL
    private Integer asmtRatioDel;              // 과제 비율 DEL
    private Integer forumRatioDel;             // 토론 비율 DEL
    private Integer examRatioDel;              // 시험 비율 DEL
    private Integer projRatioDel;              // 팀활동 비율 DEL
    private Integer etcRatioDel;               // 기타 비율 DEL
    private String  enrlAplcMthd;              // 수강 신청 방법
    private String  nopLimitYn;                // 인원 제한 여부
    private Integer enrlNop;                   // 수강 인원
    private String  enrlCertStatus;            // 수강 인증 상태
    private String  enrlAplcStartDttm;         // 수강 신청 시작 일시
    private String  enrlAplcEndDttm;           // 수강 신청 종료 일시
    private String  enrlStartDttm;             // 수강 시작 일시
    private String  enrlEndDttm;               // 수강 종료 일시
    private String  auditEndDttm;              // 청강 종료 일시
    private String  scoreHandlStartDttm;       // 성적 처리 시작 일시
    private String  scoreHandlEndDttm;         // 성적 처리 종료 일시
    private String  scoreOpenYn;               // 성적 공개 여부
    private String  scoreOpenDttm;             // 성적 공개 일자
    private String  scoreViewReschYn;          // 성적 조회 설문 여부
    private String  scoreViewReschCd;          // 성적 조회 설문 고유 번호
    private String  useYn;                     // 사용 여부
    private String  haksaDataYn;               // 학사 자료 여부
    private String  keyword;                   // 키워드
    private String  delYn;                     // 삭제 여부
    private String  uniCd = "";                // 학부대학원구분 (C:학부, G:대학원)
    private String  univGbn;                   // 대학구분 (1:대학, 2:대학원, 3:일반대학원, 4:경영전문대학원)
    private String  crsCreCds;
    private String  grdtScYn;

    private String  gubun;
    private String  crsTypeCd;
    private String  termType;
    private String  stdTotalCnt;
    private String  userNm;

    private String  termStatus;
    private String  crsYear;
    private String  termCd;
    private String  searchValue;

    private String[] sqlForeach;    // where in을 위한 배열 파라미터

    private String  tchNm;          // 교수명
    private String  tchNo;          // 교수사번
    private String  tutorNm;        // 조교명
    private String  crsTypeNm;      // 과정 유형 코드명
    private String  crsOperTypeNm;  // 과정 운영 유형 코드명
    private String  monitoringYn;   // 모니터링 여부

    private Integer lessonCnt;      // 강의 수
    private Integer stdCnt;         // 수강생 수

    private String  professorNo;
    private String  professorNm;
    private String  associateNo;
    private String  associateNm;
    private String  tutorNo;

    private String   repUserId;     // 대표교수 번호
    private String   repUserNm;     // 대표교수 명
    private String   crsTypeCds;
    private String[] crsTypeCdList;

    private List<String> declsList; // 학기제 개설과목 등록에서 사용
    private String  crsTerm;
    private String  sysTypeCd;

    // 평가 비율
    private String scoreEvalType = "RELATIVE";  // 평가방법(relative: 상대평가, absolute: 절대평가, pf: pass & fail)
    private String scoreGradeType = "FIXED";    // 등급 부여방법(fixed: 고정, ratio: 비율)
    private Double passScore = 0.0;
    private String scoreEvalTypeNm;

    private int fixedA;                         // 고정등급 A
    private int fixedB;                         // 고정등급 B
    private int fixedC;                         // 고정등급 C
    private int fixedD;                         // 고정등급 D
    private int fixedF;                         // 고정등급 E

    private int ratioA1;                        // 비율등A+
    private int ratioA2;                        // 비율등급A
    private int ratioB;                         // 비율등급b

    private String scoreTypeCdStr;              // 성적 평가 설정 문자열
    private String scoreTypeNmStr;              // 성적 평가 설정 문자열
    private String scoreRatioStr;               // 성적 평가 비율 문자열

    private int declsCnt;                       // 분반 개수 체크

    /** 과정, 테마 분류에서 사용하는 변수 */
    private String crsCtgrCd;
    private String creTmCtgrNm;
    private String  parCrsCtgrCd;
    private String  parCreTmCtgrCd;

    private String parCrsCtgrCdLvl1;
    private String parCrsCtgrCdLvl2;
    private String parCrsCtgrCdLvl3;
    private String parCreTmCtgrCdLvl1;
    private String parCreTmCtgrCdLvl2;
    private String parCreTmCtgrCdLvl3;
    private String parCrsCtgrNmLvl1;
    private String parCrsCtgrNmLvl2;
    private String parCrsCtgrNmLvl3;
    private String parCreTmCtgrNmLvl1;
    private String parCreTmCtgrNmLvl2;
    private String parCreTmCtgrNmLvl3;
    private String creTmCtgrNmVal;
    private String creTmCtgrCdVal;
    private String creTmCtgrCd;                 // 과정 분류 코드

    /** 학기 주차에서 사용 */
    private Integer cnt;

    private String regNm;
    private String modNm;

    private String creCrsCnt;
    private String creCnt;

    private String  crsNm;                      // 과목 : 과정 명
    private String  enrlCertMthd;               // 과목 : 수강 인증 방법
    private String  certIssueYn;                // 과목 : 수료증 발급 여부
    private String  crsOperMthdCd;              // 과목 : 과정 운영 방법

    private String  crsCtgrNm;                  // 과목 분류 :  분류 명

    /** 운영자 */
    private String userId;                      // 운영자 :  분류 명
    private String tchType;                     // 운영자 :  강사유형
    private String tchTypeNm;
    private String repYn;                       // 운영자 :  대표여부
    private String haksaYn;                     // 운영자 :  학사데이터 여부
    private String tchNoStr;                    // 운영자 :  저장 후 쓰일 함수
    private String tchTypeStr;                  // 운영자 :  저장 후 쓰일 함수

    /** 수강생 */
    private String stdId;                       // 수강생 :  수강생 번호
    private String orgId;
    private String enrlSts;
    private String enrlAplcDttm;
    private String enrlCancelDttm;
    private String enrlCertDttm;
    private String enrlCpltDttm;
    private String eduNo;
    private String cpltNo;
    private String getCredit;
    private String docReceiptYn;
    private String docReceiptNo;
    private String empNo;
    private String scoreEcltYn;
    private String  searchAuthGrp;
    private String  mobileNo;
    private String  email;
    private String tchTotalCnt;                 // 운영자 : 개설 과목 총 운영자
    private String ofceTelno;                   // 사무실번호

    /** 주차 */
    private String  lessonScheduleId;
    private String  lessonScheduleNm;           // 학습일정명
    private String lessonScheduleOrder;         // 학습일정순서
    private String  lessonObject;               // 학습목표
    private String  lessonSummary;              // 학습개요
    private String  lessonRepData;              // 학습참고자료
    private String  lessonStartDt;              // 학습시작일
    private String  lessonEndDt;                // 학습종료일
    private String  lessonTimeId;               // 교시ID
    private String  lessonCntsId;               // 강의컨텐츠 ID

    /** 강의계획서 */
    private String  lessonOrder;
    private String  startDt;
    private String  endDt;
    private String  lessonContents;

    /** 차시 상세화면에서 메인으로 돌아올때 쓰는 변수 */
    private String  lessonScheduleIdVal;

    private String  dDay;
    private String  enrlYn;

    private List<CreCrsVO>  creList;
    private List<OrgCodeVO> orgList;
    private List<CrsCtgrVO> crsCtgrList;
    private List<LessonScheduleVO> lessonScheduleList;
    private ProcessResultVO<CreCrsVO> coResultList;

    private String crsOperTypeCdNm;
    private String compDvCdNm;
    private String progressTypeCdNm;
    private String learningControlNm;
    private String orgNm;

    private String enrlDttm;
    private String stdTotalCntEnrlNop;

    private String tcEmail;

    private String certInfoId;                  // 수료증 ID
    private String certName;                    // 수료증 이름
    private String certContentJson;             // 수료증 내용 JSON
    private String printDirec;                  // 수료증 출력방향

    private String[] tchNoArr;
    private String[] tchTypeArr;

    private String deleteUserId;                // 삭제 수강생 리스트
    private String type;
    private String mngtDeptCd;
    private String mngtDeptNm;

    private String auditYn;
    private String scoreStatus;
    private String repeatYn;
    private String tmswPreScYn;
    private String tmswPreTransYn;
    private String gvupYn;
    private String preScYn;
    private String suppScYn;

    // TB_HOME_BBS_INFO
    private String bbsId;
    // private String orgId;
    private String bbsCd;
    private String bbsNm;
    private String bbsDesc;
    private String bbsTypeCd;
    private String dfltLangCd;
    private String menuCd;
    private int    mainImgFileSn;
    private String sysUseYn;
    private String sysDefaultYn;
    private String writeUseYn;
    private String cmntUseYn;
    private String ansrUseYn;
    private String notiUseYn;
    private String goodUseYn;
    private String atchUseYn;
    private int    atchFileCnt;
    private int    atchFileSizeLimit;
    private String atchCvsnUseYn;
    private String editorUseYn;
    private String mobileUseYn;
    private String secrtAtclUseYn;
    private String viwrUseYn;
    private String nmbrViewYn;
    private String nmbrCreYn;
    private String headUseYn;
    private int    listViewCnt;
    // private String useYn;
    // private String delYn;
    private String lockUseYn;
    private String atclId;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;
    private String haksaYear;
    private String haksaTerm;
    private String lcdmsLinkYn;
    private String erpLessonYn;
    private String transTermCd;

    private String crdts;
    private String kywd;

    private String crsId;
    private String sbjctnm;
    private String sbjctYr;

    private String dvclasNo;		// 분반번호
    private String crsMstrId;		// 과정마스터아이디
    private String smstrChrtId;		// 학기기수아이디

    public String getLcdmsLinkYn() {
		return lcdmsLinkYn;
	}
	public void setLcdmsLinkYn(String lcdmsLinkYn) {
		this.lcdmsLinkYn = lcdmsLinkYn;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    public String getCrsCreNm() {
        return crsCreNm;
    }
    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }

    public String getCrsCreNmEng() {
        return crsCreNmEng;
    }
    public void setCrsCreNmEng(String crsCreNmEng) {
        this.crsCreNmEng = crsCreNmEng;
    }

    public String getCreYear() {
        return creYear;
    }
    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }

    public String getCreTerm() {
        return creTerm;
    }
    public void setCreTerm(String creTerm) {
        this.creTerm = creTerm;
    }

    public String getCreTermNm() {
        return creTermNm;
    }
    public void setCreTermNm(String creTermNm) {
        this.creTermNm = creTermNm;
    }

    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }

    public String getCrsCreDesc() {
        return crsCreDesc;
    }
    public void setCrsCreDesc(String crsCreDesc) {
        this.crsCreDesc = crsCreDesc;
    }

    public String getCrsOperTypeCd() {
        return crsOperTypeCd;
    }
    public void setCrsOperTypeCd(String crsOperTypeCd) {
        this.crsOperTypeCd = crsOperTypeCd;
    }

    public String getDeptCd() {
        return deptCd;
    }
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }

    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public double getCredit() {
        return credit;
    }
    public void setCredit(double credit) {
        this.credit = credit;
    }

    public String getCompDvCd() {
        return compDvCd;
    }
    public void setCompDvCd(String compDvCd) {
        this.compDvCd = compDvCd;
    }

    public String getCompDvNm() {
        return compDvNm;
    }
    public void setCompDvNm(String compDvNm) {
        this.compDvNm = compDvNm;
    }

    public String getProgressTypeCd() {
        return progressTypeCd;
    }
    public void setProgressTypeCd(String progressTypeCd) {
        this.progressTypeCd = progressTypeCd;
    }

    public String getLearningControl() {
        return learningControl;
    }
    public void setLearningControl(String learningControl) {
        this.learningControl = learningControl;
    }

    public String getMidAttendChkUseYn() {
        return midAttendChkUseYn;
    }
    public void setMidAttendChkUseYn(String midAttendChkUseYn) {
        this.midAttendChkUseYn = midAttendChkUseYn;
    }

    public String getCertYn() {
        return certYn;
    }
    public void setCertYn(String certYn) {
        this.certYn = certYn;
    }

    public String getCertScoreYn() {
        return certScoreYn;
    }
    public void setCertScoreYn(String certScoreYn) {
        this.certScoreYn = certScoreYn;
    }

    public String getCpltHandlType() {
        return cpltHandlType;
    }
    public void setCpltHandlType(String cpltHandlType) {
        this.cpltHandlType = cpltHandlType;
    }

    public Integer getCpltScore() {
        return cpltScore;
    }
    public void setCpltScore(Integer cpltScore) {
        this.cpltScore = cpltScore;
    }

    public Integer getCertScoreDel() {
        return certScoreDel;
    }
    public void setCertScoreDel(Integer certScoreDel) {
        this.certScoreDel = certScoreDel;
    }

    public Integer getAttdRatioDel() {
        return attdRatioDel;
    }
    public void setAttdRatioDel(Integer attdRatioDel) {
        this.attdRatioDel = attdRatioDel;
    }

    public Integer getAsmtRatioDel() {
        return asmtRatioDel;
    }
    public void setAsmtRatioDel(Integer asmtRatioDel) {
        this.asmtRatioDel = asmtRatioDel;
    }

    public Integer getForumRatioDel() {
        return forumRatioDel;
    }
    public void setForumRatioDel(Integer forumRatioDel) {
        this.forumRatioDel = forumRatioDel;
    }

    public Integer getExamRatioDel() {
        return examRatioDel;
    }
    public void setExamRatioDel(Integer examRatioDel) {
        this.examRatioDel = examRatioDel;
    }

    public Integer getProjRatioDel() {
        return projRatioDel;
    }
    public void setProjRatioDel(Integer projRatioDel) {
        this.projRatioDel = projRatioDel;
    }

    public Integer getEtcRatioDel() {
        return etcRatioDel;
    }
    public void setEtcRatioDel(Integer etcRatioDel) {
        this.etcRatioDel = etcRatioDel;
    }

    public String getEnrlAplcMthd() {
        return enrlAplcMthd;
    }
    public void setEnrlAplcMthd(String enrlAplcMthd) {
        this.enrlAplcMthd = enrlAplcMthd;
    }

    public String getNopLimitYn() {
        return nopLimitYn;
    }
    public void setNopLimitYn(String nopLimitYn) {
        this.nopLimitYn = nopLimitYn;
    }

    public Integer getEnrlNop() {
        return enrlNop;
    }
    public void setEnrlNop(Integer enrlNop) {
        this.enrlNop = enrlNop;
    }

    public String getEnrlCertStatus() {
        return enrlCertStatus;
    }
    public void setEnrlCertStatus(String enrlCertStatus) {
        this.enrlCertStatus = enrlCertStatus;
    }

    public String getEnrlAplcStartDttm() {
        return enrlAplcStartDttm;
    }
    public void setEnrlAplcStartDttm(String enrlAplcStartDttm) {
        this.enrlAplcStartDttm = enrlAplcStartDttm;
    }

    public String getEnrlAplcEndDttm() {
        return enrlAplcEndDttm;
    }
    public void setEnrlAplcEndDttm(String enrlAplcEndDttm) {
        this.enrlAplcEndDttm = enrlAplcEndDttm;
    }

    public String getEnrlStartDttm() {
        return enrlStartDttm;
    }
    public void setEnrlStartDttm(String enrlStartDttm) {
        this.enrlStartDttm = enrlStartDttm;
    }

    public String getEnrlEndDttm() {
        return enrlEndDttm;
    }
    public void setEnrlEndDttm(String enrlEndDttm) {
        this.enrlEndDttm = enrlEndDttm;
    }

    public String getAuditEndDttm() {
        return auditEndDttm;
    }
    public void setAuditEndDttm(String auditEndDttm) {
        this.auditEndDttm = auditEndDttm;
    }

    public String getScoreHandlStartDttm() {
        return scoreHandlStartDttm;
    }
    public void setScoreHandlStartDttm(String scoreHandlStartDttm) {
        this.scoreHandlStartDttm = scoreHandlStartDttm;
    }

    public String getScoreHandlEndDttm() {
        return scoreHandlEndDttm;
    }
    public void setScoreHandlEndDttm(String scoreHandlEndDttm) {
        this.scoreHandlEndDttm = scoreHandlEndDttm;
    }

    public String getScoreOpenYn() {
        return scoreOpenYn;
    }
    public void setScoreOpenYn(String scoreOpenYn) {
        this.scoreOpenYn = scoreOpenYn;
    }

    public String getScoreOpenDttm() {
        return scoreOpenDttm;
    }
    public void setScoreOpenDttm(String scoreOpenDttm) {
        this.scoreOpenDttm = scoreOpenDttm;
    }

    public String getScoreViewReschYn() {
        return scoreViewReschYn;
    }
    public void setScoreViewReschYn(String scoreViewReschYn) {
        this.scoreViewReschYn = scoreViewReschYn;
    }

    public String getScoreViewReschCd() {
        return scoreViewReschCd;
    }
    public void setScoreViewReschCd(String scoreViewReschCd) {
        this.scoreViewReschCd = scoreViewReschCd;
    }

    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getHaksaDataYn() {
        return haksaDataYn;
    }
    public void setHaksaDataYn(String haksaDataYn) {
        this.haksaDataYn = haksaDataYn;
    }

    public String getKeyword() {
        return keyword;
    }
    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getGubun() {
        return gubun;
    }
    public void setGubun(String gubun) {
        this.gubun = gubun;
    }

    public String getCrsTypeCd() {
        return crsTypeCd;
    }
    public void setCrsTypeCd(String crsTypeCd) {
        this.crsTypeCd = crsTypeCd;
    }

    public String getTermType() {
        return termType;
    }
    public void setTermType(String termType) {
        this.termType = termType;
    }

    public String getStdTotalCnt() {
        return stdTotalCnt;
    }
    public void setStdTotalCnt(String stdTotalCnt) {
        this.stdTotalCnt = stdTotalCnt;
    }

    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getTermStatus() {
        return termStatus;
    }
    public void setTermStatus(String termStatus) {
        this.termStatus = termStatus;
    }

    public String getCrsYear() {
        return crsYear;
    }
    public void setCrsYear(String crsYear) {
        this.crsYear = crsYear;
    }

    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }

    public String getSearchValue() {
        return searchValue;
    }
    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String[] getSqlForeach() {
        return sqlForeach;
    }
    public void setSqlForeach(String[] sqlForeach) {
        this.sqlForeach = sqlForeach;
    }

    public String getTchNm() {
        return tchNm;
    }
    public void setTchNm(String tchNm) {
        this.tchNm = tchNm;
    }

    public String getTutorNm() {
        return tutorNm;
    }
    public void setTutorNm(String tutorNm) {
        this.tutorNm = tutorNm;
    }

    public String getCrsTypeNm() {
        return crsTypeNm;
    }
    public void setCrsTypeNm(String crsTypeNm) {
        this.crsTypeNm = crsTypeNm;
    }

    public String getCrsOperTypeNm() {
        return crsOperTypeNm;
    }
    public void setCrsOperTypeNm(String crsOperTypeNm) {
        this.crsOperTypeNm = crsOperTypeNm;
    }

    public String getMonitoringYn() {
        return monitoringYn;
    }
    public void setMonitoringYn(String monitoringYn) {
        this.monitoringYn = monitoringYn;
    }

    public Integer getLessonCnt() {
        return lessonCnt;
    }
    public void setLessonCnt(Integer lessonCnt) {
        this.lessonCnt = lessonCnt;
    }

    public Integer getStdCnt() {
        return stdCnt;
    }
    public void setStdCnt(Integer stdCnt) {
        this.stdCnt = stdCnt;
    }

    public String getProfessorNm() {
        return professorNm;
    }
    public void setProfessorNm(String professorNm) {
        this.professorNm = professorNm;
    }

    public String getAssociateNm() {
        return associateNm;
    }
    public void setAssociateNm(String associateNm) {
        this.associateNm = associateNm;
    }

    public String getRepUserId() {
        return repUserId;
    }
    public void setRepUserId(String repUserId) {
        this.repUserId = repUserId;
    }

    public String getRepUserNm() {
        return repUserNm;
    }
    public void setRepUserNm(String repUserNm) {
        this.repUserNm = repUserNm;
    }

    public String[] getCrsTypeCdList() {
        return crsTypeCdList;
    }
    public void setCrsTypeCdList(String[] crsTypeCdList) {
        this.crsTypeCdList = crsTypeCdList;
    }

    public String getCrsTypeCds() {
        return crsTypeCds;
    }
    public void setCrsTypeCds(String crsTypeCds) {
        this.crsTypeCds = crsTypeCds;
    }

    public List<String> getDeclsList() {
        return declsList;
    }
    public void setDeclsList(List<String> declsList) {
        this.declsList = declsList;
    }


    public String getCrsTerm() {
        return crsTerm;
    }
    public void setCrsTerm(String crsTerm) {
        this.crsTerm = crsTerm;
    }

    public String getSysTypeCd() {
        return sysTypeCd;
    }
    public void setSysTypeCd(String sysTypeCd) {
        this.sysTypeCd = sysTypeCd;
    }

    public String getScoreEvalType() {
        return scoreEvalType;
    }
    public void setScoreEvalType(String scoreEvalType) {
        this.scoreEvalType = scoreEvalType;
    }

    public String getScoreGradeType() {
        return scoreGradeType;
    }
    public void setScoreGradeType(String scoreGradeType) {
        this.scoreGradeType = scoreGradeType;
    }

    public Double getPassScore() {
        return passScore;
    }
    public void setPassScore(Double passScore) {
        this.passScore = passScore;
    }

    public int getFixedA() {
        return fixedA;
    }
    public void setFixedA(int fixedA) {
        this.fixedA = fixedA;
    }

    public int getFixedB() {
        return fixedB;
    }
    public void setFixedB(int fixedB) {
        this.fixedB = fixedB;
    }

    public int getFixedC() {
        return fixedC;
    }
    public void setFixedC(int fixedC) {
        this.fixedC = fixedC;
    }

    public int getFixedD() {
        return fixedD;
    }
    public void setFixedD(int fixedD) {
        this.fixedD = fixedD;
    }

    public int getFixedF() {
        return fixedF;
    }
    public void setFixedF(int fixedF) {
        this.fixedF = fixedF;
    }

    public int getRatioA1() {
        return ratioA1;
    }
    public void setRatioA1(int ratioA1) {
        this.ratioA1 = ratioA1;
    }

    public int getRatioA2() {
        return ratioA2;
    }
    public void setRatioA2(int ratioA2) {
        this.ratioA2 = ratioA2;
    }

    public int getRatioB() {
        return ratioB;
    }
    public void setRatioB(int ratioB) {
        this.ratioB = ratioB;
    }

    public String getScoreTypeCdStr() {
        return scoreTypeCdStr;
    }
    public void setScoreTypeCdStr(String scoreTypeCdStr) {
        this.scoreTypeCdStr = scoreTypeCdStr;
    }

    public String getScoreTypeNmStr() {
        return scoreTypeNmStr;
    }
    public void setScoreTypeNmStr(String scoreTypeNmStr) {
        this.scoreTypeNmStr = scoreTypeNmStr;
    }

    public String getScoreRatioStr() {
        return scoreRatioStr;
    }
    public void setScoreRatioStr(String scoreRatioStr) {
        this.scoreRatioStr = scoreRatioStr;
    }

    public int getDeclsCnt() {
        return declsCnt;
    }
    public void setDeclsCnt(int declsCnt) {
        this.declsCnt = declsCnt;
    }

    public String getCrsCtgrCd() {
        return crsCtgrCd;
    }
    public void setCrsCtgrCd(String crsCtgrCd) {
        this.crsCtgrCd = crsCtgrCd;
    }

    public String getCreTmCtgrNm() {
        return creTmCtgrNm;
    }
    public void setCreTmCtgrNm(String creTmCtgrNm) {
        this.creTmCtgrNm = creTmCtgrNm;
    }

    public String getParCrsCtgrCd() {
        return parCrsCtgrCd;
    }
    public void setParCrsCtgrCd(String parCrsCtgrCd) {
        this.parCrsCtgrCd = parCrsCtgrCd;
    }

    public String getParCreTmCtgrCd() {
        return parCreTmCtgrCd;
    }
    public void setParCreTmCtgrCd(String parCreTmCtgrCd) {
        this.parCreTmCtgrCd = parCreTmCtgrCd;
    }

    public String getParCrsCtgrCdLvl1() {
        return parCrsCtgrCdLvl1;
    }
    public void setParCrsCtgrCdLvl1(String parCrsCtgrCdLvl1) {
        this.parCrsCtgrCdLvl1 = parCrsCtgrCdLvl1;
    }

    public String getParCrsCtgrCdLvl2() {
        return parCrsCtgrCdLvl2;
    }
    public void setParCrsCtgrCdLvl2(String parCrsCtgrCdLvl2) {
        this.parCrsCtgrCdLvl2 = parCrsCtgrCdLvl2;
    }

    public String getParCrsCtgrCdLvl3() {
        return parCrsCtgrCdLvl3;
    }
    public void setParCrsCtgrCdLvl3(String parCrsCtgrCdLvl3) {
        this.parCrsCtgrCdLvl3 = parCrsCtgrCdLvl3;
    }

    public String getParCreTmCtgrCdLvl1() {
        return parCreTmCtgrCdLvl1;
    }
    public void setParCreTmCtgrCdLvl1(String parCreTmCtgrCdLvl1) {
        this.parCreTmCtgrCdLvl1 = parCreTmCtgrCdLvl1;
    }

    public String getParCreTmCtgrCdLvl2() {
        return parCreTmCtgrCdLvl2;
    }
    public void setParCreTmCtgrCdLvl2(String parCreTmCtgrCdLvl2) {
        this.parCreTmCtgrCdLvl2 = parCreTmCtgrCdLvl2;
    }

    public String getParCreTmCtgrCdLvl3() {
        return parCreTmCtgrCdLvl3;
    }
    public void setParCreTmCtgrCdLvl3(String parCreTmCtgrCdLvl3) {
        this.parCreTmCtgrCdLvl3 = parCreTmCtgrCdLvl3;
    }

    public String getParCrsCtgrNmLvl1() {
        return parCrsCtgrNmLvl1;
    }
    public void setParCrsCtgrNmLvl1(String parCrsCtgrNmLvl1) {
        this.parCrsCtgrNmLvl1 = parCrsCtgrNmLvl1;
    }

    public String getParCrsCtgrNmLvl2() {
        return parCrsCtgrNmLvl2;
    }
    public void setParCrsCtgrNmLvl2(String parCrsCtgrNmLvl2) {
        this.parCrsCtgrNmLvl2 = parCrsCtgrNmLvl2;
    }

    public String getParCrsCtgrNmLvl3() {
        return parCrsCtgrNmLvl3;
    }
    public void setParCrsCtgrNmLvl3(String parCrsCtgrNmLvl3) {
        this.parCrsCtgrNmLvl3 = parCrsCtgrNmLvl3;
    }

    public String getParCreTmCtgrNmLvl1() {
        return parCreTmCtgrNmLvl1;
    }
    public void setParCreTmCtgrNmLvl1(String parCreTmCtgrNmLvl1) {
        this.parCreTmCtgrNmLvl1 = parCreTmCtgrNmLvl1;
    }

    public String getParCreTmCtgrNmLvl2() {
        return parCreTmCtgrNmLvl2;
    }
    public void setParCreTmCtgrNmLvl2(String parCreTmCtgrNmLvl2) {
        this.parCreTmCtgrNmLvl2 = parCreTmCtgrNmLvl2;
    }

    public String getParCreTmCtgrNmLvl3() {
        return parCreTmCtgrNmLvl3;
    }
    public void setParCreTmCtgrNmLvl3(String parCreTmCtgrNmLvl3) {
        this.parCreTmCtgrNmLvl3 = parCreTmCtgrNmLvl3;
    }

    public String getCreTmCtgrNmVal() {
        return creTmCtgrNmVal;
    }
    public void setCreTmCtgrNmVal(String creTmCtgrNmVal) {
        this.creTmCtgrNmVal = creTmCtgrNmVal;
    }

    public String getCreTmCtgrCdVal() {
        return creTmCtgrCdVal;
    }
    public void setCreTmCtgrCdVal(String creTmCtgrCdVal) {
        this.creTmCtgrCdVal = creTmCtgrCdVal;
    }

    public Integer getCnt() {
        return cnt;
    }
    public void setCnt(Integer cnt) {
        this.cnt = cnt;
    }

    public String getRegNm() {
        return regNm;
    }
    public void setRegNm(String regNm) {
        this.regNm = regNm;
    }

    public String getModNm() {
        return modNm;
    }
    public void setModNm(String modNm) {
        this.modNm = modNm;
    }

    public String getCreCrsCnt() {
        return creCrsCnt;
    }
    public void setCreCrsCnt(String creCrsCnt) {
        this.creCrsCnt = creCrsCnt;
    }

    public String getCreCnt() {
        return creCnt;
    }
    public void setCreCnt(String creCnt) {
        this.creCnt = creCnt;
    }

    public String getCrsNm() {
        return crsNm;
    }
    public void setCrsNm(String crsNm) {
        this.crsNm = crsNm;
    }

    public String getEnrlCertMthd() {
        return enrlCertMthd;
    }
    public void setEnrlCertMthd(String enrlCertMthd) {
        this.enrlCertMthd = enrlCertMthd;
    }

    public String getCertIssueYn() {
        return certIssueYn;
    }
    public void setCertIssueYn(String certIssueYn) {
        this.certIssueYn = certIssueYn;
    }

    public String getCrsOperMthdCd() {
        return crsOperMthdCd;
    }
    public void setCrsOperMthdCd(String crsOperMthdCd) {
        this.crsOperMthdCd = crsOperMthdCd;
    }

    public String getCrsCtgrNm() {
        return crsCtgrNm;
    }
    public void setCrsCtgrNm(String crsCtgrNm) {
        this.crsCtgrNm = crsCtgrNm;
    }

    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTchType() {
        return tchType;
    }
    public void setTchType(String tchType) {
        this.tchType = tchType;
    }

    public String getRepYn() {
        return repYn;
    }
    public void setRepYn(String repYn) {
        this.repYn = repYn;
    }

    public String getHaksaYn() {
        return haksaYn;
    }
    public void setHaksaYn(String haksaYn) {
        this.haksaYn = haksaYn;
    }

    public String getTchNoStr() {
        return tchNoStr;
    }
    public void setTchNoStr(String tchNoStr) {
        this.tchNoStr = tchNoStr;
    }

    public String getTchTypeStr() {
        return tchTypeStr;
    }
    public void setTchTypeStr(String tchTypeStr) {
        this.tchTypeStr = tchTypeStr;
    }

    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getEnrlSts() {
        return enrlSts;
    }
    public void setEnrlSts(String enrlSts) {
        this.enrlSts = enrlSts;
    }

    public String getEnrlAplcDttm() {
        return enrlAplcDttm;
    }
    public void setEnrlAplcDttm(String enrlAplcDttm) {
        this.enrlAplcDttm = enrlAplcDttm;
    }

    public String getEnrlCancelDttm() {
        return enrlCancelDttm;
    }
    public void setEnrlCancelDttm(String enrlCancelDttm) {
        this.enrlCancelDttm = enrlCancelDttm;
    }

    public String getEnrlCertDttm() {
        return enrlCertDttm;
    }
    public void setEnrlCertDttm(String enrlCertDttm) {
        this.enrlCertDttm = enrlCertDttm;
    }

    public String getEnrlCpltDttm() {
        return enrlCpltDttm;
    }
    public void setEnrlCpltDttm(String enrlCpltDttm) {
        this.enrlCpltDttm = enrlCpltDttm;
    }

    public String getEduNo() {
        return eduNo;
    }
    public void setEduNo(String eduNo) {
        this.eduNo = eduNo;
    }

    public String getCpltNo() {
        return cpltNo;
    }
    public void setCpltNo(String cpltNo) {
        this.cpltNo = cpltNo;
    }

    public String getGetCredit() {
        return getCredit;
    }
    public void setGetCredit(String getCredit) {
        this.getCredit = getCredit;
    }

    public String getDocReceiptYn() {
        return docReceiptYn;
    }
    public void setDocReceiptYn(String docReceiptYn) {
        this.docReceiptYn = docReceiptYn;
    }

    public String getDocReceiptNo() {
        return docReceiptNo;
    }
    public void setDocReceiptNo(String docReceiptNo) {
        this.docReceiptNo = docReceiptNo;
    }

    public String getEmpNo() {
        return empNo;
    }
    public void setEmpNo(String empNo) {
        this.empNo = empNo;
    }

    public String getScoreEcltYn() {
        return scoreEcltYn;
    }
    public void setScoreEcltYn(String scoreEcltYn) {
        this.scoreEcltYn = scoreEcltYn;
    }

    public String getSearchAuthGrp() {
        return searchAuthGrp;
    }
    public void setSearchAuthGrp(String searchAuthGrp) {
        this.searchAuthGrp = searchAuthGrp;
    }

    public String getMobileNo() {
        return mobileNo;
    }
    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getTchTotalCnt() {
        return tchTotalCnt;
    }
    public void setTchTotalCnt(String tchTotalCnt) {
        this.tchTotalCnt = tchTotalCnt;
    }

    public String getLessonScheduleId() {
        return lessonScheduleId;
    }
    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }

    public String getLessonScheduleNm() {
        return lessonScheduleNm;
    }
    public void setLessonScheduleNm(String lessonScheduleNm) {
        this.lessonScheduleNm = lessonScheduleNm;
    }

    public String getLessonScheduleOrder() {
        return lessonScheduleOrder;
    }
    public void setLessonScheduleOrder(String lessonScheduleOrder) {
        this.lessonScheduleOrder = lessonScheduleOrder;
    }

    public String getLessonObject() {
        return lessonObject;
    }
    public void setLessonObject(String lessonObject) {
        this.lessonObject = lessonObject;
    }

    public String getLessonSummary() {
        return lessonSummary;
    }
    public void setLessonSummary(String lessonSummary) {
        this.lessonSummary = lessonSummary;
    }

    public String getLessonRepData() {
        return lessonRepData;
    }
    public void setLessonRepData(String lessonRepData) {
        this.lessonRepData = lessonRepData;
    }

    public String getLessonStartDt() {
        return lessonStartDt;
    }
    public void setLessonStartDt(String lessonStartDt) {
        this.lessonStartDt = lessonStartDt;
    }

    public String getLessonEndDt() {
        return lessonEndDt;
    }
    public void setLessonEndDt(String lessonEndDt) {
        this.lessonEndDt = lessonEndDt;
    }

    public String getLessonOrder() {
        return lessonOrder;
    }
    public void setLessonOrder(String lessonOrder) {
        this.lessonOrder = lessonOrder;
    }

    public String getStartDt() {
        return startDt;
    }
    public void setStartDt(String startDt) {
        this.startDt = startDt;
    }

    public String getEndDt() {
        return endDt;
    }
    public void setEndDt(String endDt) {
        this.endDt = endDt;
    }

    public String getLessonContents() {
        return lessonContents;
    }
    public void setLessonContents(String lessonContents) {
        this.lessonContents = lessonContents;
    }

    public String getLessonScheduleIdVal() {
        return lessonScheduleIdVal;
    }
    public void setLessonScheduleIdVal(String lessonScheduleIdVal) {
        this.lessonScheduleIdVal = lessonScheduleIdVal;
    }

    public String getdDay() {
        return dDay;
    }
    public void setdDay(String dDay) {
        this.dDay = dDay;
    }

    public String getEnrlYn() {
        return enrlYn;
    }
    public void setEnrlYn(String enrlYn) {
        this.enrlYn = enrlYn;
    }

    public String getCurCrsCreCd() {
        return curCrsCreCd;
    }
    public void setCurCrsCreCd(String curCrsCreCd) {
        this.curCrsCreCd = curCrsCreCd;
    }

    public List<CreCrsVO> getCreList() {
        return creList;
    }
    public void setCreList(List<CreCrsVO> creList) {
        this.creList = creList;
    }

    public List<OrgCodeVO> getOrgList() {
        return orgList;
    }
    public void setOrgList(List<OrgCodeVO> orgList) {
        this.orgList = orgList;
    }

    public String getTchTypeNm() {
        return tchTypeNm;
    }
    public void setTchTypeNm(String tchTypeNm) {
        this.tchTypeNm = tchTypeNm;
    }

    public int getFileSn() {
        return fileSn;
    }
    public void setFileSn(int fileSn) {
        this.fileSn = fileSn;
    }

    public String getCrsOperTypeCdNm() {
        return crsOperTypeCdNm;
    }
    public void setCrsOperTypeCdNm(String crsOperTypeCdNm) {
        this.crsOperTypeCdNm = crsOperTypeCdNm;
    }

    public String getCompDvCdNm() {
        return compDvCdNm;
    }
    public void setCompDvCdNm(String compDvCdNm) {
        this.compDvCdNm = compDvCdNm;
    }

    public String getProgressTypeCdNm() {
        return progressTypeCdNm;
    }
    public void setProgressTypeCdNm(String progressTypeCdNm) {
        this.progressTypeCdNm = progressTypeCdNm;
    }

    public String getLearningControlNm() {
        return learningControlNm;
    }
    public void setLearningControlNm(String learningControlNm) {
        this.learningControlNm = learningControlNm;
    }

    public String getOrgNm() {
        return orgNm;
    }
    public void setOrgNm(String orgNm) {
        this.orgNm = orgNm;
    }

    public List<CrsCtgrVO> getCrsCtgrList() {
        return crsCtgrList;
    }
    public void setCrsCtgrList(List<CrsCtgrVO> crsCtgrList) {
        this.crsCtgrList = crsCtgrList;
    }

    public ProcessResultVO<CreCrsVO> getCoResultList() {
        return coResultList;
    }
    public void setCoResultList(ProcessResultVO<CreCrsVO> coResultList) {
        this.coResultList = coResultList;
    }

    public String getCreTmCtgrCd() {
        return creTmCtgrCd;
    }
    public void setCreTmCtgrCd(String creTmCtgrCd) {
        this.creTmCtgrCd = creTmCtgrCd;
    }

    public String getEnrlDttm() {
        return enrlDttm;
    }
    public void setEnrlDttm(String enrlDttm) {
        this.enrlDttm = enrlDttm;
    }

    public String getStdTotalCntEnrlNop() {
        return stdTotalCntEnrlNop;
    }
    public void setStdTotalCntEnrlNop(String stdTotalCntEnrlNop) {
        this.stdTotalCntEnrlNop = stdTotalCntEnrlNop;
    }

    public String getUniCd() {
        return uniCd;
    }
    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }

    public String getOfceTelno() {
        return ofceTelno;
    }
    public void setOfceTelno(String ofceTelno) {
        this.ofceTelno = ofceTelno;
    }
    public String getTcEmail() {
        return tcEmail;
    }
    public void setTcEmail(String tcEmail) {
        this.tcEmail = tcEmail;
    }

    public String getCertInfoId() {
        return certInfoId;
    }
    public void setCertInfoId(String certInfoId) {
        this.certInfoId = certInfoId;
    }

    public String getCertName() {
        return certName;
    }
    public void setCertName(String certName) {
        this.certName = certName;
    }

    public String getCertContentJson() {
        return certContentJson;
    }
    public void setCertContentJson(String certContentJson) {
        this.certContentJson = certContentJson;
    }

    public String getPrintDirec() {
        return printDirec;
    }
    public void setPrintDirec(String printDirec) {
        this.printDirec = printDirec;
    }

    public String[] getTchNoArr() {
        return tchNoArr;
    }
    public void setTchNoArr(String[] tchNoArr) {
        this.tchNoArr = tchNoArr;
    }

    public String[] getTchTypeArr() {
        return tchTypeArr;
    }
    public void setTchTypeArr(String[] tchTypeArr) {
        this.tchTypeArr = tchTypeArr;
    }

    public String getDeleteUserId() {
        return deleteUserId;
    }
    public void setDeleteUserId(String deleteUserId) {
        this.deleteUserId = deleteUserId;
    }

    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }

    public String getMngtDeptCd() {
        return mngtDeptCd;
    }
    public void setMngtDeptCd(String mngtDeptCd) {
        this.mngtDeptCd = mngtDeptCd;
    }

    public String getAuditYn() {
        return auditYn;
    }
    public void setAuditYn(String auditYn) {
        this.auditYn = auditYn;
    }

    public String getScoreStatus() {
        return scoreStatus;
    }
    public void setScoreStatus(String scoreStatus) {
        this.scoreStatus = scoreStatus;
    }

    public String getMngtDeptNm() {
        return mngtDeptNm;
    }
    public void setMngtDeptNm(String mngtDeptNm) {
        this.mngtDeptNm = mngtDeptNm;
    }

    public String getTchNo() {
        return tchNo;
    }
    public void setTchNo(String tchNo) {
        this.tchNo = tchNo;
    }

    public String getCrsCreCds() {
        return crsCreCds;
    }
    public void setCrsCreCds(String crsCreCds) {
        this.crsCreCds = crsCreCds;
    }

    public String getRepeatYn() {
        return repeatYn;
    }
    public void setRepeatYn(String repeatYn) {
        this.repeatYn = repeatYn;
    }

    public String getTmswPreScYn() {
        return tmswPreScYn;
    }
    public void setTmswPreScYn(String tmswPreScYn) {
        this.tmswPreScYn = tmswPreScYn;
    }

    public String getGvupYn() {
        return gvupYn;
    }
    public void setGvupYn(String gvupYn) {
        this.gvupYn = gvupYn;
    }

    public String getScoreEvalTypeNm() {
        return scoreEvalTypeNm;
    }
    public void setScoreEvalTypeNm(String scoreEvalTypeNm) {
        this.scoreEvalTypeNm = scoreEvalTypeNm;
    }

    public String getLessonTimeId() {
        return lessonTimeId;
    }
    public void setLessonTimeId(String lessonTimeId) {
        this.lessonTimeId = lessonTimeId;
    }

    public String getLessonCntsId() {
        return lessonCntsId;
    }
    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
    }

    public String getProfessorNo() {
        return professorNo;
    }
    public void setProfessorNo(String professorNo) {
        this.professorNo = professorNo;
    }

    public String getAssociateNo() {
        return associateNo;
    }
    public void setAssociateNo(String associateNo) {
        this.associateNo = associateNo;
    }

    public String getTutorNo() {
        return tutorNo;
    }
    public void setTutorNo(String tutorNo) {
        this.tutorNo = tutorNo;
    }

    public String getBbsId() {
        return bbsId;
    }
    public void setBbsId(String bbsId) {
        this.bbsId = bbsId;
    }

    public String getBbsCd() {
        return bbsCd;
    }
    public void setBbsCd(String bbsCd) {
        this.bbsCd = bbsCd;
    }

    public String getBbsNm() {
        return bbsNm;
    }
    public void setBbsNm(String bbsNm) {
        this.bbsNm = bbsNm;
    }

    public String getBbsDesc() {
        return bbsDesc;
    }
    public void setBbsDesc(String bbsDesc) {
        this.bbsDesc = bbsDesc;
    }

    public String getBbsTypeCd() {
        return bbsTypeCd;
    }
    public void setBbsTypeCd(String bbsTypeCd) {
        this.bbsTypeCd = bbsTypeCd;
    }

    public String getDfltLangCd() {
        return dfltLangCd;
    }
    public void setDfltLangCd(String dfltLangCd) {
        this.dfltLangCd = dfltLangCd;
    }

    public String getMenuCd() {
        return menuCd;
    }
    public void setMenuCd(String menuCd) {
        this.menuCd = menuCd;
    }

    public int getMainImgFileSn() {
        return mainImgFileSn;
    }
    public void setMainImgFileSn(int mainImgFileSn) {
        this.mainImgFileSn = mainImgFileSn;
    }

    public String getSysUseYn() {
        return sysUseYn;
    }
    public void setSysUseYn(String sysUseYn) {
        this.sysUseYn = sysUseYn;
    }

    public String getSysDefaultYn() {
        return sysDefaultYn;
    }
    public void setSysDefaultYn(String sysDefaultYn) {
        this.sysDefaultYn = sysDefaultYn;
    }

    public String getWriteUseYn() {
        return writeUseYn;
    }
    public void setWriteUseYn(String writeUseYn) {
        this.writeUseYn = writeUseYn;
    }

    public String getCmntUseYn() {
        return cmntUseYn;
    }
    public void setCmntUseYn(String cmntUseYn) {
        this.cmntUseYn = cmntUseYn;
    }

    public String getAnsrUseYn() {
        return ansrUseYn;
    }
    public void setAnsrUseYn(String ansrUseYn) {
        this.ansrUseYn = ansrUseYn;
    }

    public String getNotiUseYn() {
        return notiUseYn;
    }
    public void setNotiUseYn(String notiUseYn) {
        this.notiUseYn = notiUseYn;
    }

    public String getGoodUseYn() {
        return goodUseYn;
    }
    public void setGoodUseYn(String goodUseYn) {
        this.goodUseYn = goodUseYn;
    }

    public String getAtchUseYn() {
        return atchUseYn;
    }
    public void setAtchUseYn(String atchUseYn) {
        this.atchUseYn = atchUseYn;
    }

    public int getAtchFileCnt() {
        return atchFileCnt;
    }
    public void setAtchFileCnt(int atchFileCnt) {
        this.atchFileCnt = atchFileCnt;
    }

    public int getAtchFileSizeLimit() {
        return atchFileSizeLimit;
    }
    public void setAtchFileSizeLimit(int atchFileSizeLimit) {
        this.atchFileSizeLimit = atchFileSizeLimit;
    }

    public String getAtchCvsnUseYn() {
        return atchCvsnUseYn;
    }
    public void setAtchCvsnUseYn(String atchCvsnUseYn) {
        this.atchCvsnUseYn = atchCvsnUseYn;
    }

    public String getEditorUseYn() {
        return editorUseYn;
    }
    public void setEditorUseYn(String editorUseYn) {
        this.editorUseYn = editorUseYn;
    }

    public String getMobileUseYn() {
        return mobileUseYn;
    }
    public void setMobileUseYn(String mobileUseYn) {
        this.mobileUseYn = mobileUseYn;
    }

    public String getSecrtAtclUseYn() {
        return secrtAtclUseYn;
    }
    public void setSecrtAtclUseYn(String secrtAtclUseYn) {
        this.secrtAtclUseYn = secrtAtclUseYn;
    }

    public String getViwrUseYn() {
        return viwrUseYn;
    }
    public void setViwrUseYn(String viwrUseYn) {
        this.viwrUseYn = viwrUseYn;
    }

    public String getNmbrViewYn() {
        return nmbrViewYn;
    }
    public void setNmbrViewYn(String nmbrViewYn) {
        this.nmbrViewYn = nmbrViewYn;
    }

    public String getNmbrCreYn() {
        return nmbrCreYn;
    }
    public void setNmbrCreYn(String nmbrCreYn) {
        this.nmbrCreYn = nmbrCreYn;
    }

    public String getHeadUseYn() {
        return headUseYn;
    }
    public void setHeadUseYn(String headUseYn) {
        this.headUseYn = headUseYn;
    }

    public int getListViewCnt() {
        return listViewCnt;
    }
    public void setListViewCnt(int listViewCnt) {
        this.listViewCnt = listViewCnt;
    }

    public String getLockUseYn() {
        return lockUseYn;
    }
    public void setLockUseYn(String lockUseYn) {
        this.lockUseYn = lockUseYn;
    }

    public String getAtclId() {
        return atclId;
    }
    public void setAtclId(String atclId) {
        this.atclId = atclId;
    }

    public String getRgtrId() {
        return rgtrId;
    }
    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }
    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getMdfrId() {
        return mdfrId;
    }
    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getModDttm() {
        return modDttm;
    }
    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }
    public String getHaksaYear() {
        return haksaYear;
    }
    public void setHaksaYear(String haksaYear) {
        this.haksaYear = haksaYear;
    }
    public String getHaksaTerm() {
        return haksaTerm;
    }
    public void setHaksaTerm(String haksaTerm) {
        this.haksaTerm = haksaTerm;
    }
    public List<LessonScheduleVO> getLessonScheduleList() {
        return lessonScheduleList;
    }
    public void setLessonScheduleList(List<LessonScheduleVO> lessonScheduleList) {
        this.lessonScheduleList = lessonScheduleList;
    }
    public String getErpLessonYn() {
        return erpLessonYn;
    }
    public void setErpLessonYn(String erpLessonYn) {
        this.erpLessonYn = erpLessonYn;
    }
	public String getTmswPreTransYn() {
		return tmswPreTransYn;
	}
	public void setTmswPreTransYn(String tmswPreTransYn) {
		this.tmswPreTransYn = tmswPreTransYn;
	}
	public String getTransTermCd() {
		return transTermCd;
	}
	public void setTransTermCd(String transTermCd) {
		this.transTermCd = transTermCd;
	}
    public String getUnivGbn() {
        return univGbn;
    }
    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }
    public String getPreScYn() {
        return preScYn;
    }
    public void setPreScYn(String preScYn) {
        this.preScYn = preScYn;
    }
    public String getSuppScYn() {
        return suppScYn;
    }
    public void setSuppScYn(String suppScYn) {
        this.suppScYn = suppScYn;
    }
    public String getGrdtScYn() {
        return grdtScYn;
    }
    public void setGrdtScYn(String grdtScYn) {
        this.grdtScYn = grdtScYn;
    }
	public String getCrdts() {
		return crdts;
	}
	public void setCrdts(String crdts) {
		this.crdts = crdts;
	}
	public String getKywd() {
		return kywd;
	}
	public void setKywd(String kywd) {
		this.kywd = kywd;
	}
	public String getCrsId() {
		return crsId;
	}
	public void setCrsId(String crsId) {
		this.crsId = crsId;
	}
	public String getSbjctnm() {
		return sbjctnm;
	}
	public void setSbjctnm(String sbjctnm) {
		this.sbjctnm = sbjctnm;
	}
	public String getSbjctYr() {
		return sbjctYr;
	}
	public void setSbjctYr(String sbjctYr) {
		this.sbjctYr = sbjctYr;
	}
	public String getDvclasNo() {
		return dvclasNo;
	}
	public String getCrsMstrId() {
		return crsMstrId;
	}
	public String getSmstrChrtId() {
		return smstrChrtId;
	}
	public void setDvclasNo(String dvclasNo) {
		this.dvclasNo = dvclasNo;
	}
	public void setCrsMstrId(String crsMstrId) {
		this.crsMstrId = crsMstrId;
	}
	public void setSmstrChrtId(String smstrChrtId) {
		this.smstrChrtId = smstrChrtId;
	}


}
