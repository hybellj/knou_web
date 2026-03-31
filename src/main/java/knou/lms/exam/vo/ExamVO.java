package knou.lms.exam.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ExamVO extends DefaultVO {

    private static final long serialVersionUID = -523935686222564979L;

    /*****************************************************
     * 신규 작성 VO 영역
     *****************************************************/
    private String  examBscId;          // 시험기본 ID
    private String  examDtlId;          // 시험기본 ID
    private String  examTycd;           // 시험유형코드
    private String  examGbncd;          // 시험구분코드
    private String  examGbnnm;          // 시험구분코드명
    private String  tkexamMthdCd;       // 시험응시방법코드
    private String  tkexamMthdNm;       // 시험응시방법코드명
    private String  examTtl;            // 시험제목
    private String  examPsblSdttm;      // 시험 시작일
    private String  examPsblEdttm;      // 시험 종료일
    private String  examDrtn;           // 시험일시(기간)
    private Integer examMnts;           // 시험시간(분)
    private Integer mrkRfltrt;          // 반영비율
    private String  tkexamCmptnynTot;   // 응시현황 (완료/전체)
    private String  evlynTot;           // 평가현황 (평가/전체)
    private String  examQstnsCmptnyn;   // 출제상태
    private String  mrkOyn;             // 성적공개
    private String  sbjctId;            // 과목 ID
    private String  sbjctnm;            // 과목명
    private String  dvclasNcknm;        // 분반명
    private String  smstrChrtId;        // 학수번호

    private String  crsCreCd;           // 과목 코드 (파라미터)
    private String  tabType;            // 메뉴 탭 지정 (파라미터)
    private String  mrkRfltyn;          // 성적반영여부
    private String  exampprOyn;         // 시험지공개여부
    private String  byteamSubrexamUseyn; // 팀시험여부
    private String  lrnGrpSubsbjctUseyn; // 부 주제여부
    private String  examSbstTynm;       // 시험대체코드명
    private Integer absnceTot;          // 결시인원 COUNT
    private Integer dsblTot;            // 장애인/고령자 COUNT

    private String  teamId;             // 팀 ID
    private String  teamnm;             // 팀명
    private String  deptId;             // 학과 ID
    private String  deptnm;             // 학과명
    private String  userRprsId;         // 사용자 대표 ID
    private String  stdntNo;            // 학번
    private String  userId;             // 사용자 ID
    private String  usernm;             // 사용자 이름
    private String  mobileNo;           // 사용자 전화번호
    private String  email;              // 사용자 이메일
    private String  ldryn;              // 역할 (팀장/팀원)
    private String  examScr;            // 시험 점수 레이블
    private String  totScr;             // 총 점수 (평가점수)
    private String  tkexamCmptnyn;      // 응시상태
    private Integer tkexamCnt;          // 응시횟수
    private String  evlyn;              // 평가여부
    private String  rgtrId;             // 등록자 ID
    private String  mdfrId;             // 수정자 ID
    private String  tkexamId;           // 시험 응시 ID
    private String  tkexamSdttm;        // 시험 응시 시작일
    private String  tkexamEdttm;        // 시험 응시 종료일
    private String  tkexamCmptnGbncd;   // 시험 응시 상태코드

    private String  lrnGrpId;           // 그룹 ID
    private String  lrnGrpnm;           // 그룹 명
    private String  ldrnm;              // 리더 명
    private Integer teamMbrTot;         // 팀 인원 COUNT

    private ExamDtlVO examDtlVO;        // 시험상세정보VO
    private List<String> lrnGrpIds;		// 팀 시험 등록용 학습그룹아이디:개설과목아이디 목록

    private String  examEvlSbstId;      // 시험 대체 평가 ID
    private String  examEvlSbstnm;      // 시험 대체 평가명
    private String  gbn;                // 구분 (ASMT: 과제, QUIZ: 퀴즈)
    private String  asmtId;             // 과제 ID
    private String  asmtTtl;            // 과제 제목
    private String  asmtSbmsnSdttm;     // 과제 제출 시작일시
    private String  asmtSbmsnEdttm;     // 과제 제출 종료일시
    private String  evlScrTycd;         // 평가점수유형코드
    private String  evlScrTynm;         // 평가점수유형명
    private String  regDttm;            // 등록일시

    private String  absnceTtl;          // 결시 사유
    private String  absnceCts;          // 결시 사유
    private String  absnceRfltrt;       // 결시 반영비율
    private String  aplyStsStts;        // 신청 승인 상태 (Y/N)

    private String  aplyStscd;          // 신청상태 코드
    private String  aplyStsnm;          // 신청상태명 (1:신청, 2:재신청, 3:승인, 4:거절)
    private String  aprvCts;            // 승인내용
    private String  aprvdttm;           // 승인일시
    private String  autzrId;            // 승인자 ID

    private String  profnm;             // 교수 이름
    private String  tutnm;              // 튜터 이름

    /*****************************************************
     * Getter / Setter
     *****************************************************/

    public String getExamBscId() {
        return examBscId;
    }
    public void setExamBscId(String examBscId) {
        this.examBscId = examBscId;
    }
    public String getExamDtlId() {
        return examDtlId;
    }
    public void setExamDtlId(String examDtlId) {
        this.examDtlId = examDtlId;
    }
    public String getExamTycd() {
        return examTycd;
    }
    public void setExamTycd(String examTycd) {
        this.examTycd = examTycd;
    }
    public String getExamGbncd() {
        return examGbncd;
    }
    public void setExamGbncd(String examGbncd) {
        this.examGbncd = examGbncd;
    }
    public String getExamGbnnm() {
        return examGbnnm;
    }
    public void setExamGbnnm(String examGbnnm) {
        this.examGbnnm = examGbnnm;
    }
    public String getTkexamMthdCd() {
        return tkexamMthdCd;
    }
    public void setTkexamMthdCd(String tkexamMthdCd) {
        this.tkexamMthdCd = tkexamMthdCd;
    }
    public String getTkexamMthdNm() {
        return tkexamMthdNm;
    }
    public void setTkexamMthdNm(String tkexamMthdNm) {
        this.tkexamMthdNm = tkexamMthdNm;
    }
    public String getExamTtl() {
        return examTtl;
    }
    public void setExamTtl(String examTtl) {
        this.examTtl = examTtl;
    }
    public String getExamDrtn() {
        return examDrtn;
    }
    public void setExamDrtn(String examDrtn) {
        this.examDrtn = examDrtn;
    }
    public Integer getExamMnts() {
        return examMnts;
    }
    public void setExamMnts(Integer examMnts) {
        this.examMnts = examMnts;
    }
    public Integer getMrkRfltrt() {
        return mrkRfltrt;
    }
    public void setMrkRfltrt(Integer mrkRfltrt) {
        this.mrkRfltrt = mrkRfltrt;
    }
    public String getTkexamCmptnynTot() {
        return tkexamCmptnynTot;
    }
    public void setTkexamCmptnynTot(String tkexamCmptnynTot) {
        this.tkexamCmptnynTot = tkexamCmptnynTot;
    }
    public String getEvlynTot() {
        return evlynTot;
    }
    public void setEvlynTot(String evlynTot) {
        this.evlynTot = evlynTot;
    }
    public String getExamQstnsCmptnyn() {
        return examQstnsCmptnyn;
    }
    public void setExamQstnsCmptnyn(String examQstnsCmptnyn) {
        this.examQstnsCmptnyn = examQstnsCmptnyn;
    }
    public String getMrkOyn() {
        return mrkOyn;
    }
    public void setMrkOyn(String mrkOyn) {
        this.mrkOyn = mrkOyn;
    }
    public String getSbjctId() {
        return sbjctId;
    }
    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }
    public String getSbjctnm() {
        return sbjctnm;
    }
    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }
    public String getDvclasNcknm() {
        return dvclasNcknm;
    }
    public void setDvclasNcknm(String dvclasNcknm) {
        this.dvclasNcknm = dvclasNcknm;
    }
    public String getSmstrChrtId() {
        return smstrChrtId;
    }
    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getTabType() {
        return tabType;
    }
    public void setTabType(String tabType) {
        this.tabType = tabType;
    }

    public String getMrkRfltyn() {
        return mrkRfltyn;
    }
    public void setMrkRfltyn(String mrkRfltyn) {
        this.mrkRfltyn = mrkRfltyn;
    }
    public String getExamPsblSdttm() {
        return examPsblSdttm;
    }
    public void setExamPsblSdttm(String examPsblSdttm) {
        this.examPsblSdttm = examPsblSdttm;
    }
    public String getExamPsblEdttm() {
        return examPsblEdttm;
    }
    public void setExamPsblEdttm(String examPsblEdttm) {
        this.examPsblEdttm = examPsblEdttm;
    }
    public String getExampprOyn() {
        return exampprOyn;
    }
    public void setExampprOyn(String exampprOyn) {
        this.exampprOyn = exampprOyn;
    }
    public String getByteamSubrexamUseyn() {
        return byteamSubrexamUseyn;
    }
    public void setByteamSubrexamUseyn(String byteamSubrexamUseyn) {
        this.byteamSubrexamUseyn = byteamSubrexamUseyn;
    }
    public String getLrnGrpSubsbjctUseyn() {
        return lrnGrpSubsbjctUseyn;
    }
    public void setLrnGrpSubsbjctUseyn(String lrnGrpSubsbjctUseyn) {
        this.lrnGrpSubsbjctUseyn = lrnGrpSubsbjctUseyn;
    }
    public String getExamSbstTynm() {
        return examSbstTynm;
    }
    public void setExamSbstTynm(String examSbstTynm) {
        this.examSbstTynm = examSbstTynm;
    }
    public Integer getAbsnceTot() {
        return absnceTot;
    }
    public void setAbsnceTot(Integer absnceTot) {
        this.absnceTot = absnceTot;
    }
    public Integer getDsblTot() {
        return dsblTot;
    }
    public void setDsblTot(Integer dsblTot) {
        this.dsblTot = dsblTot;
    }
    public String getTeamId() {
        return teamId;
    }
    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }
    public String getTeamnm() {
        return teamnm;
    }
    public void setTeamnm(String teamnm) {
        this.teamnm = teamnm;
    }
    public String getDeptId() {
        return deptId;
    }
    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }
    public String getDeptnm() {
        return deptnm;
    }
    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }
    public String getUserRprsId() {
        return userRprsId;
    }
    public void setUserRprsId(String userRprsId) {
        this.userRprsId = userRprsId;
    }
    public String getStdntNo() {
        return stdntNo;
    }
    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getUsernm() {
        return usernm;
    }
    public void setUsernm(String usernm) {
        this.usernm = usernm;
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
    public String getLdryn() {
        return ldryn;
    }
    public void setLdryn(String ldryn) {
        this.ldryn = ldryn;
    }
    public String getExamScr() {
        return examScr;
    }
    public void setExamScr(String examScr) {
        this.examScr = examScr;
    }
    public String getTotScr() {
        return totScr;
    }
    public void setTotScr(String totScr) {
        this.totScr = totScr;
    }
    public String getTkexamCmptnyn() {
        return tkexamCmptnyn;
    }
    public void setTkexamCmptnyn(String tkexamCmptnyn) {
        this.tkexamCmptnyn = tkexamCmptnyn;
    }
    public Integer getTkexamCnt() {
        return tkexamCnt;
    }
    public void setTkexamCnt(Integer tkexamCnt) {
        this.tkexamCnt = tkexamCnt;
    }
    public String getEvlyn() {
        return evlyn;
    }
    public void setEvlyn(String evlyn) {
        this.evlyn = evlyn;
    }
    public String getRgtrId() {
        return rgtrId;
    }
    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }
    public String getMdfrId() {
        return mdfrId;
    }
    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }
    public String getLrnGrpId() {
        return lrnGrpId;
    }
    public void setLrnGrpId(String lrnGrpId) {
        this.lrnGrpId = lrnGrpId;
    }
    public String getLrnGrpnm() {
        return lrnGrpnm;
    }
    public void setLrnGrpnm(String lrnGrpnm) {
        this.lrnGrpnm = lrnGrpnm;
    }
    public String getLdrnm() {
        return ldrnm;
    }
    public void setLdrnm(String ldrnm) {
        this.ldrnm = ldrnm;
    }
    public Integer getTeamMbrTot() {
        return teamMbrTot;
    }
    public void setTeamMbrTot(Integer teamMbrTot) {
        this.teamMbrTot = teamMbrTot;
    }
    public String getTkexamId() {
        return tkexamId;
    }
    public void setTkexamId(String tkexamId) {
        this.tkexamId = tkexamId;
    }
    public String getTkexamSdttm() {
        return tkexamSdttm;
    }
    public void setTkexamSdttm(String tkexamSdttm) {
        this.tkexamSdttm = tkexamSdttm;
    }
    public String getTkexamEdttm() {
        return tkexamEdttm;
    }
    public void setTkexamEdttm(String tkexamEdttm) {
        this.tkexamEdttm = tkexamEdttm;
    }
    public String getTkexamCmptnGbncd() {
        return tkexamCmptnGbncd;
    }
    public void setTkexamCmptnGbncd(String tkexamCmptnGbncd) {
        this.tkexamCmptnGbncd = tkexamCmptnGbncd;
    }
    public ExamDtlVO getExamDtlVO() {
        return examDtlVO;
    }
    public void setExamDtlVO(ExamDtlVO examDtlVO) {
        this.examDtlVO = examDtlVO;
    }
    public List<String> getLrnGrpIds() {
        return lrnGrpIds;
    }
    public void setLrnGrpIds(List<String> lrnGrpIds) {
        this.lrnGrpIds = lrnGrpIds;
    }
    public String getExamEvlSbstId() {
        return examEvlSbstId;
    }
    public void setExamEvlSbstId(String examEvlSbstId) {
        this.examEvlSbstId = examEvlSbstId;
    }
    public String getExamEvlSbstnm() {
        return examEvlSbstnm;
    }
    public void setExamEvlSbstnm(String examEvlSbstnm) {
        this.examEvlSbstnm = examEvlSbstnm;
    }
    public String getGbn() {
        return gbn;
    }
    public void setGbn(String gbn) {
        this.gbn = gbn;
    }
    public String getAsmtId() {
        return asmtId;
    }
    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }
    public String getAsmtTtl() {
        return asmtTtl;
    }
    public void setAsmtTtl(String asmtTtl) {
        this.asmtTtl = asmtTtl;
    }
    public String getAsmtSbmsnSdttm() {
        return asmtSbmsnSdttm;
    }
    public void setAsmtSbmsnSdttm(String asmtSbmsnSdttm) {
        this.asmtSbmsnSdttm = asmtSbmsnSdttm;
    }
    public String getAsmtSbmsnEdttm() {
        return asmtSbmsnEdttm;
    }
    public void setAsmtSbmsnEdttm(String asmtSbmsnEdttm) {
        this.asmtSbmsnEdttm = asmtSbmsnEdttm;
    }
    public String getEvlScrTycd() {
        return evlScrTycd;
    }
    public void setEvlScrTycd(String evlScrTycd) {
        this.evlScrTycd = evlScrTycd;
    }
    public String getEvlScrTynm() {
        return evlScrTynm;
    }
    public void setEvlScrTynm(String evlScrTynm) {
        this.evlScrTynm = evlScrTynm;
    }
    public String getRegDttm() {
        return regDttm;
    }
    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getAbsnceTtl() {
        return absnceTtl;
    }
    public void setAbsnceTtl(String absnceTtl) {
        this.absnceTtl = absnceTtl;
    }
    public String getAbsnceCts() {
        return absnceCts;
    }
    public void setAbsnceCts(String absnceCts) {
        this.absnceCts = absnceCts;
    }
    public String getAbsnceRfltrt() {
        return absnceRfltrt;
    }
    public void setAbsnceRfltrt(String absnceRfltrt) {
        this.absnceRfltrt = absnceRfltrt;
    }
    public String getAplyStsStts() {
        return aplyStsStts;
    }
    public void setAplyStsStts(String aplyStsStts) {
        this.aplyStsStts = aplyStsStts;
    }
    public String getAplyStscd() {
        return aplyStscd;
    }
    public void setAplyStscd(String aplyStscd) {
        this.aplyStscd = aplyStscd;
    }
    public String getAplyStsnm() {
        return aplyStsnm;
    }
    public void setAplyStsnm(String aplyStsnm) {
        this.aplyStsnm = aplyStsnm;
    }
    public String getAprvCts() {
        return aprvCts;
    }
    public void setAprvCts(String aprvCts) {
        this.aprvCts = aprvCts;
    }
    public String getAprvdttm() {
        return aprvdttm;
    }
    public void setAprvdttm(String aprvdttm) {
        this.aprvdttm = aprvdttm;
    }
    public String getAutzrId() {
        return autzrId;
    }
    public void setAutzrId(String autzrId) {
        this.autzrId = autzrId;
    }
    public String getProfnm() {
        return profnm;
    }
    public void setProfnm(String profnm) {
        this.profnm = profnm;
    }
    public String getTutnm() {
        return tutnm;
    }
    public void setTutnm(String tutnm) {
        this.tutnm = tutnm;
    }

    /*****************************************************
     * 기존에 있던 VO 영역
     *****************************************************/
    /** tb_lms_exam */
    private String  examCd;                 // 시험 번호
    private String  examCtgrCd;             // 시험 분류 코드
    private String  examTitle;              // 제목
    private String  examCts;                // 내용
    private String  examTypeCd;             // 시험 유형 코드 (QUIZ : 퀴즈, ASMNT : 과제, FORUM : 토론, EXAM : 실시간 시험 링크)
    private String  examTypeNm;             // 시험 유형명
    private String  examStareTypeCd;        // 시험 응시 유형 코드
    private String  examStareTypeNm;        // 시험 응시 유형명
    private String  insRefCd;               // 대체 참조 번호
    private String  examTmTypeCd;           // 시험 시간 배정 방식 (남은시간배정, 전체시간배정)
    private String  viewTmTypeCd;           // 시험 시간 노출 타입 (left 왼쪽, preogress 프로그레스)
    private String  viewQstnTypeCd;         // 문제 표시 방식 (each 문제 표시, all 전체 문제 표시)
    private String  qstnSetTypeCd;          // 시험 문제 출제 방식 (random 랜덤형, same 동일문항형)
    private Integer examStareTm;            // 시험 응시 시간
    private String  emplRandomYn;           // 보기 문항 랜덤 여부
    private String  scoreAplyYn;            // 성적 반영 여부
    private String  useYn;                  // 사용 여부
    private String  examSubmitYn;           // 시험 문제 제출 완료 여부
    private String  tmLimitYn;              // 제한시간 배정 여부
    private String  gradeViewYn;            // 시험지 공개 여부
    private String  declsRegYn;             // 분반 등록 여부
    private String  pushNoticeYn;           // 푸시 알림 여부
    private String  avgScoreOpenYn;         // 평균 성적 공개 여부
    private String  stareTmUseYn;           // 응시 시간 사용 여부
    private Integer stareLimitCnt;          // 응시 제한 횟수
    private Integer stareCritPrgrRatio;     // 응시 기준 진도 율
    private Integer scoreRatio;             // 성적 반영 비율
    private String  examStartDttm;          // 시험 시작 일시
    private String  examEndDttm;            // 시험 종료 일시
    private String  reExamYn;               // 재시험 여부
    private String  reExamStartDttm;        // 재시험 시작 일시
    private String  reExamEndDttm;          // 재시험 종료 일시
    private Integer reExamAplyRatio;        // 재시험 적용 비율
    private Integer reExamStareTm;          // 재시험 응시시간
    private Float   passScore;              // 통과 점수
    private String  dsbdYn;                 // 장애 여부
    private Integer dsbdTm;                 // 장애인 배려 추가 시간
    private String  scoreOpenYn;            // 성적 공개 여부
    private String  scoreOpenDttm;          // 성적 공개 일자
    private String  secCertCd;              // OTP, 공인 인증 등 운영 인증 서비스 코드
    private Integer dsblAddTm;              // 장애인 시험 추가시간
    private String  imdtAnsrViewYn;         // 즉시답안보기
    private String  delYn;                  // 삭제 여부
    private String  regYn;                  // 등록 여부
    
    /** tb_lms_exam_cre_crs_rltn */
    private String  grpCd;                  // 그룹 코드
    
    private Integer examTotalUserCnt;       // 시험 총 인원수
    private Integer examJoinUserCnt;        // 시험 참여 인원수 (완료)
    private Integer examStartUserCnt;       // 시험 시작 인원수
    private Integer examQstnCnt;            // 시험 문항 수
    private String  examStatus;             // 시험 진행 상황
    private String  erpExamStatus;          // 실시간 시험 진행 상황
    private Integer examEvalCnt;            // 평가한 인원수
    
    private String  stdId;                  // 학습자 번호
    private Integer stareCnt;               // 제출 횟수
    private String  startDttm;              // 시작 일시
    private String  endDttm;                // 종료 일시
    private Float   totGetScore;            // 점수
    private String  stareStatusCd;          // 제출 현황
    
    private String  stdIds;
    private List<String> stdIdList;
    
    private List<String> crsCreCds;         // 분반 같이 등록용 과목 리스트
    private String  declsGrpCd;             // 분반 공동 등록시 사용할 그릅코드
    private String  crsCd;
    private Integer sumScoreRatio;
    private String  examCds;
    private String  scoreRatios;
    private String  termCd;
    private String  termNm;
    private String  tchNm;
    private String  tutorNm;
    private List<String> examCdList;
    
    //파일 업로드
    private Integer thumbFileSn;
    
    private String  insStartDttm;           // 대체 과제 시작 일시
    private String  insEndDttm;             // 대체 과제 종료 일시
    private String  insRefNm;               // 대체 과제명
    private String  insRefTypeNm;           // 대체 과제 유형명
    private Integer insJoinUserCnt;         // 대체 과제 제출자 수
    private Integer insEvalUserCnt;         // 대체 과제 평가자 수
    private Integer examSubsTotalCnt;       // 대체 과제 총 인원 수
    private String  insJoinYn;              // 대체 과제 참여 여부
    private Integer insScore;               // 대체 과제 점수
    private String  insSubmitYn;            // 대체 참여 가능 여부
    private String  insDelYn;               // 대체 과제 삭제 여부
    
    private String  examAbsentYn;           // 결시원 신청 여부
    private String  examAbsentApproveYn;    // 결시원 승인 여부
    private String  examAbsentCd;           // 결시코드
    private String  siteCd;
    private String  crsDeptNm;              // 과목 개설 학과
    private String  declsNo;                // 분반
    private String  periodAfterWriteYn;     // 토론 기간 후 허용 여부
    private String  stuReExamYn;            // 학습자 재시험 가능 여부
    private String  reExamStatus;           // 재시험 기간 체크
    private String  extSendAcptYn;          // 과제 연장제출 허용 여부
    private String  extSendDttm;            // 과제 연장제출 일시
    private String  stuEvalYn;              // 학습자 평가 여부

    // 시험 세부 등록용
    private String  startDate;
    private String  startHH;
    private String  startMM;
    private String  endDate;
    private String  endHH;
    private String  endMM;
    
    private String  examType;
    
    private String  creYear;
    private String  creTerm;
    
    private String  insTitle;
    private String  insCts;
    private String  insScoreAplyYn;
    private String  insScoreOpenYn;
    private String  insTypeCd;
    private String  stareYn;
    private String  parExamCd;
    private String  hstyTypeCd;
    private String  todayYn;
    
    private String  midExamWaitYn;
    private String  lastExamWaitYn;
    private String  stareSn;                 // 수강생 번호 + 시험고유번호
    
    private String  parExamEndDttm;
    private String  copyExamCd;
    private String  lessonScheduleId;
    private String  lessonScheduleNm;
    
    public String getExamCd() {
        return examCd;
    }
    public void setExamCd(String examCd) {
        this.examCd = examCd;
    }
    public String getExamCtgrCd() {
        return examCtgrCd;
    }
    public void setExamCtgrCd(String examCtgrCd) {
        this.examCtgrCd = examCtgrCd;
    }
    public String getExamTitle() {
        return examTitle;
    }
    public void setExamTitle(String examTitle) {
        this.examTitle = examTitle;
    }
    public String getExamCts() {
        return examCts;
    }
    public void setExamCts(String examCts) {
        this.examCts = examCts;
    }
    public String getExamTypeCd() {
        return examTypeCd;
    }
    public void setExamTypeCd(String examTypeCd) {
        this.examTypeCd = examTypeCd;
    }
    public String getExamTypeNm() {
        return examTypeNm;
    }
    public void setExamTypeNm(String examTypeNm) {
        this.examTypeNm = examTypeNm;
    }
    public String getExamStareTypeCd() {
        return examStareTypeCd;
    }
    public void setExamStareTypeCd(String examStareTypeCd) {
        this.examStareTypeCd = examStareTypeCd;
    }
    public String getExamStareTypeNm() {
        return examStareTypeNm;
    }
    public void setExamStareTypeNm(String examStareTypeNm) {
        this.examStareTypeNm = examStareTypeNm;
    }
    public String getInsRefCd() {
        return insRefCd;
    }
    public void setInsRefCd(String insRefCd) {
        this.insRefCd = insRefCd;
    }
    public String getExamTmTypeCd() {
        return examTmTypeCd;
    }
    public void setExamTmTypeCd(String examTmTypeCd) {
        this.examTmTypeCd = examTmTypeCd;
    }
    public String getViewTmTypeCd() {
        return viewTmTypeCd;
    }
    public void setViewTmTypeCd(String viewTmTypeCd) {
        this.viewTmTypeCd = viewTmTypeCd;
    }
    public String getViewQstnTypeCd() {
        return viewQstnTypeCd;
    }
    public void setViewQstnTypeCd(String viewQstnTypeCd) {
        this.viewQstnTypeCd = viewQstnTypeCd;
    }
    public String getQstnSetTypeCd() {
        return qstnSetTypeCd;
    }
    public void setQstnSetTypeCd(String qstnSetTypeCd) {
        this.qstnSetTypeCd = qstnSetTypeCd;
    }
    public Integer getExamStareTm() {
        return examStareTm;
    }
    public void setExamStareTm(Integer examStareTm) {
        this.examStareTm = examStareTm;
    }
    public String getEmplRandomYn() {
        return emplRandomYn;
    }
    public void setEmplRandomYn(String emplRandomYn) {
        this.emplRandomYn = emplRandomYn;
    }
    public String getScoreAplyYn() {
        return scoreAplyYn;
    }
    public void setScoreAplyYn(String scoreAplyYn) {
        this.scoreAplyYn = scoreAplyYn;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getExamSubmitYn() {
        return examSubmitYn;
    }
    public void setExamSubmitYn(String examSubmitYn) {
        this.examSubmitYn = examSubmitYn;
    }
    public String getTmLimitYn() {
        return tmLimitYn;
    }
    public void setTmLimitYn(String tmLimitYn) {
        this.tmLimitYn = tmLimitYn;
    }
    public String getGradeViewYn() {
        return gradeViewYn;
    }
    public void setGradeViewYn(String gradeViewYn) {
        this.gradeViewYn = gradeViewYn;
    }
    public String getDeclsRegYn() {
        return declsRegYn;
    }
    public void setDeclsRegYn(String declsRegYn) {
        this.declsRegYn = declsRegYn;
    }
    public String getPushNoticeYn() {
        return pushNoticeYn;
    }
    public void setPushNoticeYn(String pushNoticeYn) {
        this.pushNoticeYn = pushNoticeYn;
    }
    public String getAvgScoreOpenYn() {
        return avgScoreOpenYn;
    }
    public void setAvgScoreOpenYn(String avgScoreOpenYn) {
        this.avgScoreOpenYn = avgScoreOpenYn;
    }
    public String getStareTmUseYn() {
        return stareTmUseYn;
    }
    public void setStareTmUseYn(String stareTmUseYn) {
        this.stareTmUseYn = stareTmUseYn;
    }
    public Integer getStareLimitCnt() {
        return stareLimitCnt;
    }
    public void setStareLimitCnt(Integer stareLimitCnt) {
        this.stareLimitCnt = stareLimitCnt;
    }
    public Integer getStareCritPrgrRatio() {
        return stareCritPrgrRatio;
    }
    public void setStareCritPrgrRatio(Integer stareCritPrgrRatio) {
        this.stareCritPrgrRatio = stareCritPrgrRatio;
    }
    public Integer getScoreRatio() {
        return scoreRatio;
    }
    public void setScoreRatio(Integer scoreRatio) {
        this.scoreRatio = scoreRatio;
    }
    public String getExamStartDttm() {
        return examStartDttm;
    }
    public void setExamStartDttm(String examStartDttm) {
        this.examStartDttm = examStartDttm;
    }
    public String getExamEndDttm() {
        return examEndDttm;
    }
    public void setExamEndDttm(String examEndDttm) {
        this.examEndDttm = examEndDttm;
    }
    public String getReExamYn() {
        return reExamYn;
    }
    public void setReExamYn(String reExamYn) {
        this.reExamYn = reExamYn;
    }
    public String getReExamStartDttm() {
        return reExamStartDttm;
    }
    public void setReExamStartDttm(String reExamStartDttm) {
        this.reExamStartDttm = reExamStartDttm;
    }
    public String getReExamEndDttm() {
        return reExamEndDttm;
    }
    public void setReExamEndDttm(String reExamEndDttm) {
        this.reExamEndDttm = reExamEndDttm;
    }
    public Integer getReExamAplyRatio() {
        return reExamAplyRatio;
    }
    public void setReExamAplyRatio(Integer reExamAplyRatio) {
        this.reExamAplyRatio = reExamAplyRatio;
    }
    public Float getPassScore() {
        return passScore;
    }
    public void setPassScore(Float passScore) {
        this.passScore = passScore;
    }
    public String getDsbdYn() {
        return dsbdYn;
    }
    public void setDsbdYn(String dsbdYn) {
        this.dsbdYn = dsbdYn;
    }
    public Integer getDsbdTm() {
        return dsbdTm;
    }
    public void setDsbdTm(Integer dsbdTm) {
        this.dsbdTm = dsbdTm;
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
    public String getSecCertCd() {
        return secCertCd;
    }
    public void setSecCertCd(String secCertCd) {
        this.secCertCd = secCertCd;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getRegYn() {
        return regYn;
    }
    public void setRegYn(String regYn) {
        this.regYn = regYn;
    }
    public String getGrpCd() {
        return grpCd;
    }
    public void setGrpCd(String grpCd) {
        this.grpCd = grpCd;
    }
    public Integer getExamTotalUserCnt() {
        return examTotalUserCnt;
    }
    public void setExamTotalUserCnt(Integer examTotalUserCnt) {
        this.examTotalUserCnt = examTotalUserCnt;
    }
    public Integer getExamJoinUserCnt() {
        return examJoinUserCnt;
    }
    public void setExamJoinUserCnt(Integer examJoinUserCnt) {
        this.examJoinUserCnt = examJoinUserCnt;
    }
    public Integer getExamQstnCnt() {
        return examQstnCnt;
    }
    public void setExamQstnCnt(Integer examQstnCnt) {
        this.examQstnCnt = examQstnCnt;
    }
    public String getExamStatus() {
        return examStatus;
    }
    public void setExamStatus(String examStatus) {
        this.examStatus = examStatus;
    }
    public Integer getExamEvalCnt() {
        return examEvalCnt;
    }
    public void setExamEvalCnt(Integer examEvalCnt) {
        this.examEvalCnt = examEvalCnt;
    }
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public Integer getStareCnt() {
        return stareCnt;
    }
    public void setStareCnt(Integer stareCnt) {
        this.stareCnt = stareCnt;
    }
    public String getStartDttm() {
        return startDttm;
    }
    public void setStartDttm(String startDttm) {
        this.startDttm = startDttm;
    }
    public String getEndDttm() {
        return endDttm;
    }
    public void setEndDttm(String endDttm) {
        this.endDttm = endDttm;
    }
    public Float getTotGetScore() {
        return totGetScore;
    }
    public void setTotGetScore(Float totGetScore) {
        this.totGetScore = totGetScore;
    }
    public String getStareStatusCd() {
        return stareStatusCd;
    }
    public void setStareStatusCd(String stareStatusCd) {
        this.stareStatusCd = stareStatusCd;
    }
    public String getStdIds() {
        return stdIds;
    }
    public void setStdIds(String stdNos) {
        this.stdIds = stdNos;
    }
    public List<String> getStdIdList() {
        return stdIdList;
    }
    public void setStdIdList(List<String> stdNoList) {
        this.stdIdList = stdNoList;
    }
    public List<String> getCrsCreCds() {
        return crsCreCds;
    }
    public void setCrsCreCds(List<String> crsCreCds) {
        this.crsCreCds = crsCreCds;
    }
    public String getDeclsGrpCd() {
        return declsGrpCd;
    }
    public void setDeclsGrpCd(String declsGrpCd) {
        this.declsGrpCd = declsGrpCd;
    }
    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }
    public Integer getSumScoreRatio() {
        return sumScoreRatio;
    }
    public void setSumScoreRatio(Integer sumScoreRatio) {
        this.sumScoreRatio = sumScoreRatio;
    }
    public String getExamCds() {
        return examCds;
    }
    public void setExamCds(String examCds) {
        this.examCds = examCds;
    }
    public String getScoreRatios() {
        return scoreRatios;
    }
    public void setScoreRatios(String scoreRatios) {
        this.scoreRatios = scoreRatios;
    }
    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }
    public String getTermNm() {
        return termNm;
    }
    public void setTermNm(String termNm) {
        this.termNm = termNm;
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
    public List<String> getExamCdList() {
        return examCdList;
    }
    public void setExamCdList(List<String> examCdList) {
        this.examCdList = examCdList;
    }
    public Integer getThumbFileSn() {
        return thumbFileSn;
    }
    public void setThumbFileSn(Integer thumbFileSn) {
        this.thumbFileSn = thumbFileSn;
    }
    public String getInsEndDttm() {
        return insEndDttm;
    }
    public void setInsEndDttm(String insEndDttm) {
        this.insEndDttm = insEndDttm;
    }
    public String getInsRefNm() {
        return insRefNm;
    }
    public void setInsRefNm(String insRefNm) {
        this.insRefNm = insRefNm;
    }
    public String getExamAbsentYn() {
        return examAbsentYn;
    }
    public void setExamAbsentYn(String examAbsentYn) {
        this.examAbsentYn = examAbsentYn;
    }
    public String getExamAbsentApproveYn() {
        return examAbsentApproveYn;
    }
    public void setExamAbsentApproveYn(String examAbsentApproveYn) {
        this.examAbsentApproveYn = examAbsentApproveYn;
    }
    public String getSiteCd() {
        return siteCd;
    }
    public void setSiteCd(String siteCd) {
        this.siteCd = siteCd;
    }
    public String getCrsDeptNm() {
        return crsDeptNm;
    }
    public void setCrsDeptNm(String crsDeptNm) {
        this.crsDeptNm = crsDeptNm;
    }
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    public String getInsStartDttm() {
        return insStartDttm;
    }
    public void setInsStartDttm(String insStartDttm) {
        this.insStartDttm = insStartDttm;
    }
    public String getPeriodAfterWriteYn() {
        return periodAfterWriteYn;
    }
    public void setPeriodAfterWriteYn(String periodAfterWriteYn) {
        this.periodAfterWriteYn = periodAfterWriteYn;
    }
    public String getStuReExamYn() {
        return stuReExamYn;
    }
    public void setStuReExamYn(String stuReExamYn) {
        this.stuReExamYn = stuReExamYn;
    }
    public String getReExamStatus() {
        return reExamStatus;
    }
    public void setReExamStatus(String reExamStatus) {
        this.reExamStatus = reExamStatus;
    }
    public String getExtSendAcptYn() {
        return extSendAcptYn;
    }
    public void setExtSendAcptYn(String extSendAcptYn) {
        this.extSendAcptYn = extSendAcptYn;
    }
    public String getExtSendDttm() {
        return extSendDttm;
    }
    public void setExtSendDttm(String extSendDttm) {
        this.extSendDttm = extSendDttm;
    }
    public String getStartDate() {
        return startDate;
    }
    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }
    public String getStartHH() {
        return startHH;
    }
    public void setStartHH(String startHH) {
        this.startHH = startHH;
    }
    public String getStartMM() {
        return startMM;
    }
    public void setStartMM(String startMM) {
        this.startMM = startMM;
    }
    public String getEndDate() {
        return endDate;
    }
    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }
    public String getEndHH() {
        return endHH;
    }
    public void setEndHH(String endHH) {
        this.endHH = endHH;
    }
    public String getEndMM() {
        return endMM;
    }
    public void setEndMM(String endMM) {
        this.endMM = endMM;
    }
    public Integer getInsJoinUserCnt() {
        return insJoinUserCnt;
    }
    public void setInsJoinUserCnt(Integer insJoinUserCnt) {
        this.insJoinUserCnt = insJoinUserCnt;
    }
    public Integer getInsEvalUserCnt() {
        return insEvalUserCnt;
    }
    public void setInsEvalUserCnt(Integer insEvalUserCnt) {
        this.insEvalUserCnt = insEvalUserCnt;
    }
    public Integer getExamSubsTotalCnt() {
        return examSubsTotalCnt;
    }
    public void setExamSubsTotalCnt(Integer examSubsTotalCnt) {
        this.examSubsTotalCnt = examSubsTotalCnt;
    }
    public String getStuEvalYn() {
        return stuEvalYn;
    }
    public void setStuEvalYn(String stuEvalYn) {
        this.stuEvalYn = stuEvalYn;
    }
    public String getExamType() {
        return examType;
    }
    public void setExamType(String examType) {
        this.examType = examType;
    }
    public String getInsRefTypeNm() {
        return insRefTypeNm;
    }
    public void setInsRefTypeNm(String insRefTypeNm) {
        this.insRefTypeNm = insRefTypeNm;
    }
    public String getInsJoinYn() {
        return insJoinYn;
    }
    public void setInsJoinYn(String insJoinYn) {
        this.insJoinYn = insJoinYn;
    }
    public Integer getInsScore() {
        return insScore;
    }
    public void setInsScore(Integer insScore) {
        this.insScore = insScore;
    }
    public String getExamAbsentCd() {
        return examAbsentCd;
    }
    public void setExamAbsentCd(String examAbsentCd) {
        this.examAbsentCd = examAbsentCd;
    }
    public String getInsSubmitYn() {
        return insSubmitYn;
    }
    public void setInsSubmitYn(String insSubmitYn) {
        this.insSubmitYn = insSubmitYn;
    }
    public String getInsDelYn() {
        return insDelYn;
    }
    public void setInsDelYn(String insDelYn) {
        this.insDelYn = insDelYn;
    }
    public Integer getReExamStareTm() {
        return reExamStareTm;
    }
    public void setReExamStareTm(Integer reExamStareTm) {
        this.reExamStareTm = reExamStareTm;
    }
    public Integer getDsblAddTm() {
        return dsblAddTm;
    }
    public void setDsblAddTm(Integer dsblAddTm) {
        this.dsblAddTm = dsblAddTm;
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
    public String getInsTitle() {
        return insTitle;
    }
    public void setInsTitle(String insTitle) {
        this.insTitle = insTitle;
    }
    public String getInsCts() {
        return insCts;
    }
    public void setInsCts(String insCts) {
        this.insCts = insCts;
    }
    public String getInsScoreAplyYn() {
        return insScoreAplyYn;
    }
    public void setInsScoreAplyYn(String insScoreAplyYn) {
        this.insScoreAplyYn = insScoreAplyYn;
    }
    public String getInsScoreOpenYn() {
        return insScoreOpenYn;
    }
    public void setInsScoreOpenYn(String insScoreOpenYn) {
        this.insScoreOpenYn = insScoreOpenYn;
    }
    public String getInsTypeCd() {
        return insTypeCd;
    }
    public void setInsTypeCd(String insTypeCd) {
        this.insTypeCd = insTypeCd;
    }
    public String getStareYn() {
        return stareYn;
    }
    public void setStareYn(String stareYn) {
        this.stareYn = stareYn;
    }
    public String getParExamCd() {
        return parExamCd;
    }
    public void setParExamCd(String parExamCd) {
        this.parExamCd = parExamCd;
    }
    public String getHstyTypeCd() {
        return hstyTypeCd;
    }
    public void setHstyTypeCd(String hstyTypeCd) {
        this.hstyTypeCd = hstyTypeCd;
    }
    public String getTodayYn() {
        return todayYn;
    }
    public void setTodayYn(String todayYn) {
        this.todayYn = todayYn;
    }
    public String getMidExamWaitYn() {
        return midExamWaitYn;
    }
    public void setMidExamWaitYn(String midExamWaitYn) {
        this.midExamWaitYn = midExamWaitYn;
    }
    public String getLastExamWaitYn() {
        return lastExamWaitYn;
    }
    public void setLastExamWaitYn(String lastExamWaitYn) {
        this.lastExamWaitYn = lastExamWaitYn;
    }
    public String getStareSn() {
        return stareSn;
    }
    public void setStareSn(String stareSn) {
        this.stareSn = stareSn;
    }
    public String getParExamEndDttm() {
        return parExamEndDttm;
    }
    public void setParExamEndDttm(String parExamEndDttm) {
        this.parExamEndDttm = parExamEndDttm;
    }
    public String getCopyExamCd() {
        return copyExamCd;
    }
    public void setCopyExamCd(String copyExamCd) {
        this.copyExamCd = copyExamCd;
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
    public String getImdtAnsrViewYn() {
        return imdtAnsrViewYn;
    }
    public void setImdtAnsrViewYn(String imdtAnsrViewYn) {
        this.imdtAnsrViewYn = imdtAnsrViewYn;
    }
    public String getErpExamStatus() {
        return erpExamStatus;
    }
    public void setErpExamStatus(String erpExamStatus) {
        this.erpExamStatus = erpExamStatus;
    }
    public Integer getExamStartUserCnt() {
        return examStartUserCnt;
    }
    public void setExamStartUserCnt(Integer examStartUserCnt) {
        this.examStartUserCnt = examStartUserCnt;
    }
}
