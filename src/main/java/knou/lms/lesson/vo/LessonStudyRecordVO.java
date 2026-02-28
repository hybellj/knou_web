package knou.lms.lesson.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class LessonStudyRecordVO extends DefaultVO {
    private static final long serialVersionUID = -9015422537143936568L;    

    /** tb_lms_lesson_study_record */
    private String  stdId;                  // 수강생 번호
    private String  lessonCntsId;           // 학습콘텐츠 아이디
    private String  studyStatusCd;          // 학습 상태 코드
    private String  studyStatusCdBak;       // 학습 상태 코드 백업
    private Integer studyCnt;               // 학습 횟수
    private Integer studySessionTm;         // 최근 학습 시간(초)
    private Integer studyTotalTm;           // 총 학습 시간(초)
    private Integer studyAfterTm;           // 기간 후 학습 시간(초)
    private String  studyStartDttm;         // 학습 시작 일시
    private String  studySessionDttm;       // 최근 학습 일시
    private String  studySessionLoc;        // 최근 학습 위치
    private String  studyMaxLoc;            // 최대 학습 위치
    private Integer prgrRatio;              // 진도 비율
    
    private String  lessonScheduleId;       // 학습일정 아이디
    private String  lessonTimeId;           // 교시 아이디
    private String  pageCnt;                // 페이지번호
    private Integer cntsPlayTm;             // 콘텐츠 플레이 시간
    private String  lessonStartDt;          // 학습시작일자
    private String  lessonEndDt;            // 학습종료일자
    private int     lbnTm;                  // 학습시간
    private String  prgrYn;                 // 진도반영여부
    private int     studySumTm = 0;         // 학습시간합계
    private int     pageSessionTm = 0;      // 페이지 학습시간
    private int     pageStudyTm = 0;        // 페이지 합계시간
    private int     pageStudyCnt = 0;       // 페이지 학습횟수
    private int     pageRatio = 0;          // 페이지 학습진도율
    private int     cntsRatio = 0;          // 콘텐츠학습진도율(페이지 없는 경우)
    private String  ltDetmToDtMax;          // 강의인정종료일자 마지막일
    private String  pageAtndYn;             // 페이지 출석대상 여부
    
    private String  browserCd;
    private String  deviceCd;
    private String  agent;
    private String  userIp;
    private String  userId;
    private String  saveType;
    private String  playSpeed;
    private String  playStartDttm;
    private String  speedPlayTime;
    
    private List<LessonStudyDetailVO> listLessonStudyDetail;
    private List<LessonStudyPageVO> listLessonStudyPage;
    
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public String getLessonCntsId() {
        return lessonCntsId;
    }
    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
    }
    public String getStudyStatusCd() {
        return studyStatusCd;
    }
    public void setStudyStatusCd(String studyStatusCd) {
        this.studyStatusCd = studyStatusCd;
    }
    public String getStudyStatusCdBak() {
        return studyStatusCdBak;
    }
    public void setStudyStatusCdBak(String studyStatusCdBak) {
        this.studyStatusCdBak = studyStatusCdBak;
    }
    public Integer getStudyCnt() {
        return studyCnt;
    }
    public void setStudyCnt(Integer studyCnt) {
        this.studyCnt = studyCnt;
    }
    public Integer getStudySessionTm() {
        return studySessionTm;
    }
    public void setStudySessionTm(Integer studySessionTm) {
        this.studySessionTm = studySessionTm;
    }
    public Integer getStudyTotalTm() {
        return studyTotalTm;
    }
    public void setStudyTotalTm(Integer studyTotalTm) {
        this.studyTotalTm = studyTotalTm;
    }
    public Integer getStudyAfterTm() {
        return studyAfterTm;
    }
    public void setStudyAfterTm(Integer studyAfterTm) {
        this.studyAfterTm = studyAfterTm;
    }
    public String getStudyStartDttm() {
        return studyStartDttm;
    }
    public void setStudyStartDttm(String studyStartDttm) {
        this.studyStartDttm = studyStartDttm;
    }
    public String getStudySessionDttm() {
        return studySessionDttm;
    }
    public void setStudySessionDttm(String studySessionDttm) {
        this.studySessionDttm = studySessionDttm;
    }
    public String getStudySessionLoc() {
        return studySessionLoc;
    }
    public void setStudySessionLoc(String studySessionLoc) {
        this.studySessionLoc = studySessionLoc;
    }
    public String getStudyMaxLoc() {
        return studyMaxLoc;
    }
    public void setStudyMaxLoc(String studyMaxLoc) {
        this.studyMaxLoc = studyMaxLoc;
    }
    public Integer getPrgrRatio() {
        return prgrRatio;
    }
    public void setPrgrRatio(Integer prgrRatio) {
        this.prgrRatio = prgrRatio;
    }
    public String getLessonScheduleId() {
        return lessonScheduleId;
    }
    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }
    public String getLessonTimeId() {
        return lessonTimeId;
    }
    public void setLessonTimeId(String lessonTimeId) {
        this.lessonTimeId = lessonTimeId;
    }
    public String getPageCnt() {
        return pageCnt;
    }
    public void setPageCnt(String pageCnt) {
        this.pageCnt = pageCnt;
    }
    public Integer getCntsPlayTm() {
        return cntsPlayTm;
    }
    public void setCntsPlayTm(Integer cntsPlayTm) {
        this.cntsPlayTm = cntsPlayTm;
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
    public int getLbnTm() {
        return lbnTm;
    }
    public void setLbnTm(int lbnTm) {
        this.lbnTm = lbnTm;
    }
    public String getPrgrYn() {
        return prgrYn;
    }
    public void setPrgrYn(String prgrYn) {
        this.prgrYn = prgrYn;
    }
    public int getStudySumTm() {
        return studySumTm;
    }
    public void setStudySumTm(int studySumTm) {
        this.studySumTm = studySumTm;
    }
    public String getBrowserCd() {
        return browserCd;
    }
    public void setBrowserCd(String browserCd) {
        this.browserCd = browserCd;
    }
    public String getDeviceCd() {
        return deviceCd;
    }
    public void setDeviceCd(String deviceCd) {
        this.deviceCd = deviceCd;
    }
    public String getAgent() {
        return agent;
    }
    public void setAgent(String agent) {
        this.agent = agent;
    }
    public String getUserIp() {
        return userIp;
    }
    public void setUserIp(String userIp) {
        this.userIp = userIp;
    }
    public int getPageSessionTm() {
        return pageSessionTm;
    }
    public void setPageSessionTm(int pageSessionTm) {
        this.pageSessionTm = pageSessionTm;
    }
    public int getPageStudyCnt() {
        return pageStudyCnt;
    }
    public void setPageStudyCnt(int pageStudyCnt) {
        this.pageStudyCnt = pageStudyCnt;
    }
    public int getPageStudyTm() {
        return pageStudyTm;
    }
    public void setPageStudyTm(int pageStudyTm) {
        this.pageStudyTm = pageStudyTm;
    }
    public int getPageRatio() {
        return pageRatio;
    }
    public void setPageRatio(int pageRatio) {
        this.pageRatio = pageRatio;
    }
    public int getCntsRatio() {
        return cntsRatio;
    }
    public void setCntsRatio(int cntsRatio) {
        this.cntsRatio = cntsRatio;
    }
    public List<LessonStudyDetailVO> getListLessonStudyDetail() {
        return listLessonStudyDetail;
    }
    public void setListLessonStudyDetail(List<LessonStudyDetailVO> listLessonStudyDetail) {
        this.listLessonStudyDetail = listLessonStudyDetail;
    }
    public List<LessonStudyPageVO> getListLessonStudyPage() {
        return listLessonStudyPage;
    }
    public void setListLessonStudyPage(List<LessonStudyPageVO> listLessonStudyPage) {
        this.listLessonStudyPage = listLessonStudyPage;
    }
    public String getLtDetmToDtMax() {
        return ltDetmToDtMax;
    }
    public void setLtDetmToDtMax(String ltDetmToDtMax) {
        this.ltDetmToDtMax = ltDetmToDtMax;
    }
    public String getPageAtndYn() {
        return pageAtndYn;
    }
    public void setPageAtndYn(String pageAtndYn) {
        this.pageAtndYn = pageAtndYn;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getSaveType() {
        return saveType;
    }
    public String getPlaySpeed() {
        return playSpeed;
    }
    public void setSaveType(String saveType) {
        this.saveType = saveType;
    }
    public void setPlaySpeed(String playSpeed) {
        this.playSpeed = playSpeed;
    }
    public String getPlayStartDttm() {
        return playStartDttm;
    }
    public void setPlayStartDttm(String playStartDttm) {
        this.playStartDttm = playStartDttm;
    }
    public static long getSerialversionuid() {
        return serialVersionUID;
    }
    public String getSpeedPlayTime() {
        return speedPlayTime;
    }
    public void setSpeedPlayTime(String speedPlayTime) {
        this.speedPlayTime = speedPlayTime;
    }

}
