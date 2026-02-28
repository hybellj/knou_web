package knou.lms.resh.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ReshVO extends DefaultVO {

    private static final long serialVersionUID = 6162532701879562769L;
    
    /** tb_lms_resch */
    private String  reschCd;            // 설문 고유번호
    private String  reschCtgrCd;        // 설문 분류 코드
    private String  reschTplCd;         // 설문 템플릿 고유번호
    private String  reschTplYn;         // 설문 템플릿 여부
    private String  orgId;              // 기관 코드
    private String  reschTitle;         // 설문 제목
    private String  reschCts;           // 설문 내용
    private String  reschTypeCd;        // 강의실, 홈페이지 등 구분
    private String  joinTrgt;           // 참여 대상
    private String  reschStartDttm;     // 설문 시작 일시
    private String  reschEndDttm;       // 설문 종료 일시
    private String  rsltTypeCd;         // 결과 공개 유형 코드
    private String  scoreViewYn;        // 성적 조회 여부
    private String  declsRegYn;         // 분반 등록 여부
    private String  itemCopyYn;         // 문항 복사 여부
    private String  itemCopyReschCd;    // 뭏낭 복사 설문 고유번호
    private String  useYn;              // 사용 여부
    private String  delYn;              // 삭제 여부
    private String  reschSubmitYn;      // 설문 출제 완료 여부
    private String  scoreAplyYn;        // 성적반영여부
    private int     scoreRatio;         // 성적반영비율
    private String  scoreOpenYn;        // 성적공개여부
    private String  extJoinYn;          // 연장 제출 허용 여부
    private String  extEndDttm;         // 연장 제출 마감 일시
    private String  evalCtgr;           // 평가 방법
    private Integer score;
    private String  joinDttm;
    
    /** tb_lms_resch_cre_crs_rltn */
    private String  crsCreCd;           // 개설 강좌 코드
    private String  grpCd;              // 그룹 코드
    
    private Integer reschTotalUserCnt;  // 설문 총 인원 수
    private Integer reschJoinUserCnt;   // 설문 참여 인원 수
    private Integer reschEvalCnt;       // 평가한 인원수
    private Integer reschQstnCnt;       // 설문 문항 수
    private String  reschStatus;        // 설문 진행 상황
    private String  userId;             // 사용자 번호
    private String  joinYn;             // 사용자 참여 여부
    private List<String> crsCreCds;     // 분반 같이 등록용 과목 리스트
    private String  declsGrpCd;         // 분반 공동 등록시 사용할 그릅코드
    private String  termCd;             // 학기 코드
    private String  stdNo;
    private Integer homeReschTotalUserCnt;  // 전체 설문 총 인원 수
    private Integer homeReschJoinUserCnt;   // 전체 설문 참여 인원 수
    private String isNew;               // 7일내 작성글 여부
    
    private String  reschCds;           // 성적 반영비율 저장용
    private String  scoreRatios;        // 성적 반영비율 저장용
    private String  declsNo;            // 분반
    
    private String  creYear;
    private String  creTerm;
    private String  copyReschCd;
    private String  grscDegrCorsGbn;
    private String  grscDegrCorsGbnNm;
    
    public String getReschCd() {
        return reschCd;
    }
    public void setReschCd(String reschCd) {
        this.reschCd = reschCd;
    }
    public String getReschCtgrCd() {
        return reschCtgrCd;
    }
    public void setReschCtgrCd(String reschCtgrCd) {
        this.reschCtgrCd = reschCtgrCd;
    }
    public String getReschTplCd() {
        return reschTplCd;
    }
    public void setReschTplCd(String reschTplCd) {
        this.reschTplCd = reschTplCd;
    }
    public String getReschTplYn() {
        return reschTplYn;
    }
    public void setReschTplYn(String reschTplYn) {
        this.reschTplYn = reschTplYn;
    }
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
    public String getReschTitle() {
        return reschTitle;
    }
    public void setReschTitle(String reschTitle) {
        this.reschTitle = reschTitle;
    }
    public String getReschCts() {
        return reschCts;
    }
    public void setReschCts(String reschCts) {
        this.reschCts = reschCts;
    }
    public String getReschTypeCd() {
        return reschTypeCd;
    }
    public void setReschTypeCd(String reschTypeCd) {
        this.reschTypeCd = reschTypeCd;
    }
    public String getJoinTrgt() {
        return joinTrgt;
    }
    public void setJoinTrgt(String joinTrgt) {
        this.joinTrgt = joinTrgt;
    }
    public String getReschStartDttm() {
        return reschStartDttm;
    }
    public void setReschStartDttm(String reschStartDttm) {
        this.reschStartDttm = reschStartDttm;
    }
    public String getReschEndDttm() {
        return reschEndDttm;
    }
    public void setReschEndDttm(String reschEndDttm) {
        this.reschEndDttm = reschEndDttm;
    }
    public String getRsltTypeCd() {
        return rsltTypeCd;
    }
    public void setRsltTypeCd(String rsltTypeCd) {
        this.rsltTypeCd = rsltTypeCd;
    }
    public String getScoreViewYn() {
        return scoreViewYn;
    }
    public void setScoreViewYn(String scoreViewYn) {
        this.scoreViewYn = scoreViewYn;
    }
    public String getDeclsRegYn() {
        return declsRegYn;
    }
    public void setDeclsRegYn(String declsRegYn) {
        this.declsRegYn = declsRegYn;
    }
    public String getItemCopyYn() {
        return itemCopyYn;
    }
    public void setItemCopyYn(String itemCopyYn) {
        this.itemCopyYn = itemCopyYn;
    }
    public String getItemCopyReschCd() {
        return itemCopyReschCd;
    }
    public void setItemCopyReschCd(String itemCopyReschCd) {
        this.itemCopyReschCd = itemCopyReschCd;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getGrpCd() {
        return grpCd;
    }
    public void setGrpCd(String grpCd) {
        this.grpCd = grpCd;
    }
    public Integer getReschTotalUserCnt() {
        return reschTotalUserCnt;
    }
    public void setReschTotalUserCnt(Integer reschTotalUserCnt) {
        this.reschTotalUserCnt = reschTotalUserCnt;
    }
    public Integer getReschJoinUserCnt() {
        return reschJoinUserCnt;
    }
    public void setReschJoinUserCnt(Integer reschJoinUserCnt) {
        this.reschJoinUserCnt = reschJoinUserCnt;
    }
    public Integer getReschQstnCnt() {
        return reschQstnCnt;
    }
    public void setReschQstnCnt(Integer reschQstnCnt) {
        this.reschQstnCnt = reschQstnCnt;
    }
    public String getReschStatus() {
        return reschStatus;
    }
    public void setReschStatus(String reschStatus) {
        this.reschStatus = reschStatus;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getJoinYn() {
        return joinYn;
    }
    public void setJoinYn(String joinYn) {
        this.joinYn = joinYn;
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
    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }
    public String getReschSubmitYn() {
        return reschSubmitYn;
    }
    public void setReschSubmitYn(String reschSubmitYn) {
        this.reschSubmitYn = reschSubmitYn;
    }
    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }
    public Integer getHomeReschTotalUserCnt() {
        return homeReschTotalUserCnt;
    }
    public void setHomeReschTotalUserCnt(Integer homeReschTotalUserCnt) {
        this.homeReschTotalUserCnt = homeReschTotalUserCnt;
    }
    public Integer getHomeReschJoinUserCnt() {
        return homeReschJoinUserCnt;
    }
    public void setHomeReschJoinUserCnt(Integer homeReschJoinUserCnt) {
        this.homeReschJoinUserCnt = homeReschJoinUserCnt;
    }
    public String getIsNew() {
        return isNew;
    }
    public void setIsNew(String isNew) {
        this.isNew = isNew;
    }
    public String getScoreAplyYn() {
        return scoreAplyYn;
    }
    public void setScoreAplyYn(String scoreAplyYn) {
        this.scoreAplyYn = scoreAplyYn;
    }
    public int getScoreRatio() {
        return scoreRatio;
    }
    public void setScoreRatio(int scoreRatio) {
        this.scoreRatio = scoreRatio;
    }
    public String getScoreOpenYn() {
        return scoreOpenYn;
    }
    public void setScoreOpenYn(String scoreOpenYn) {
        this.scoreOpenYn = scoreOpenYn;
    }
    public Integer getReschEvalCnt() {
        return reschEvalCnt;
    }
    public void setReschEvalCnt(Integer reschEvalCnt) {
        this.reschEvalCnt = reschEvalCnt;
    }
    public String getReschCds() {
        return reschCds;
    }
    public void setReschCds(String reschCds) {
        this.reschCds = reschCds;
    }
    public String getScoreRatios() {
        return scoreRatios;
    }
    public void setScoreRatios(String scoreRatios) {
        this.scoreRatios = scoreRatios;
    }
    public String getExtJoinYn() {
        return extJoinYn;
    }
    public void setExtJoinYn(String extJoinYn) {
        this.extJoinYn = extJoinYn;
    }
    public String getExtEndDttm() {
        return extEndDttm;
    }
    public void setExtEndDttm(String extEndDttm) {
        this.extEndDttm = extEndDttm;
    }
    public String getEvalCtgr() {
        return evalCtgr;
    }
    public void setEvalCtgr(String evalCtgr) {
        this.evalCtgr = evalCtgr;
    }
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    public Integer getScore() {
        return score;
    }
    public void setScore(Integer score) {
        this.score = score;
    }
    public String getJoinDttm() {
        return joinDttm;
    }
    public void setJoinDttm(String joinDttm) {
        this.joinDttm = joinDttm;
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
    public String getCopyReschCd() {
        return copyReschCd;
    }
    public void setCopyReschCd(String copyReschCd) {
        this.copyReschCd = copyReschCd;
    }
    public String getGrscDegrCorsGbn() {
        return grscDegrCorsGbn;
    }
    public void setGrscDegrCorsGbn(String grscDegrCorsGbn) {
        this.grscDegrCorsGbn = grscDegrCorsGbn;
    }
    public String getGrscDegrCorsGbnNm() {
        return grscDegrCorsGbnNm;
    }
    public void setGrscDegrCorsGbnNm(String grscDegrCorsGbnNm) {
        this.grscDegrCorsGbnNm = grscDegrCorsGbnNm;
    }
    
}
