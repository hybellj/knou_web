package knou.lms.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LessonStudyMemoVO extends DefaultVO {
    private static final long serialVersionUID = 4737384494845667150L;

    /** tb_lms_lesson_study_memo */
    private String  studyMemoId;       // 학습메모 아이디
    private String  stdId;             // 수강생 번호
    private String  userId;            // 사용자 번호
    private String  crsCreCd;          // 과정 개설 코드
    private String  lessonScheduleId;  // 학습일정 아이디
    private Integer lessonScheduleOrder;
    private String  lessonScheduleNm;  // 주차명
    private String  lessonCntsId;      // 학습콘텐츠 아이디
    private String  lessonCntsNm;      // 학습콘텐츠명
    private Integer lessonTimeOrder;
    private String  lessonTimeNm;      // 교시명
    private String  studySessionLoc;   // 최근 학습 위치
    private String  memoTitle;         // 메모제목
    private String  memoCnts;          // 메모내용

    public String getStudyMemoId() {
        return studyMemoId;
    }

    public void setStudyMemoId(String studyMemoId) {
        this.studyMemoId = studyMemoId;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getLessonScheduleId() {
        return lessonScheduleId;
    }

    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }

    public String getLessonCntsId() {
        return lessonCntsId;
    }

    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
    }

    public String getStudySessionLoc() {
        return studySessionLoc;
    }

    public void setStudySessionLoc(String studySessionLoc) {
        this.studySessionLoc = studySessionLoc;
    }

    public String getMemoTitle() {
        return memoTitle;
    }

    public void setMemoTitle(String memoTitle) {
        this.memoTitle = memoTitle;
    }

    public String getMemoCnts() {
        return memoCnts;
    }

    public void setMemoCnts(String memoCnts) {
        this.memoCnts = memoCnts;
    }

    public String getLessonScheduleNm() {
        return lessonScheduleNm;
    }

    public void setLessonScheduleNm(String lessonScheduleNm) {
        this.lessonScheduleNm = lessonScheduleNm;
    }

    public String getLessonCntsNm() {
        return lessonCntsNm;
    }

    public void setLessonCntsNm(String lessonCntsNm) {
        this.lessonCntsNm = lessonCntsNm;
    }

    public String getLessonTimeNm() {
        return lessonTimeNm;
    }

    public void setLessonTimeNm(String lessonTimeNm) {
        this.lessonTimeNm = lessonTimeNm;
    }

    public Integer getLessonScheduleOrder() {
        return lessonScheduleOrder;
    }

    public void setLessonScheduleOrder(Integer lessonScheduleOrder) {
        this.lessonScheduleOrder = lessonScheduleOrder;
    }

    public Integer getLessonTimeOrder() {
        return lessonTimeOrder;
    }

    public void setLessonTimeOrder(Integer lessonTimeOrder) {
        this.lessonTimeOrder = lessonTimeOrder;
    }

}
