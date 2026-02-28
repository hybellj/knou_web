package knou.lms.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LessonStudyPageVO extends DefaultVO {
    private static final long serialVersionUID = 8452563747261206789L;
    
    /** tb_lms_lesson_study_page */
    private String  lessonCntsId;
    private String  stdId;
    private int     pageCnt;
    private String  crsCreCd;
    private int     studyCnt;
    private int     studySessionTm;
    private String  studyStartDttm;
    private String  studySessionDttm;
    private String  studySessionLoc;
    private String  lessonTimeId;
    private String  lessonScheduleId;
    private Integer prgrRatio;              // 진도 비율

    public String getLessonCntsId() {
        return lessonCntsId;
    }

    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public int getPageCnt() {
        return pageCnt;
    }

    public void setPageCnt(int pageCnt) {
        this.pageCnt = pageCnt;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public int getStudyCnt() {
        return studyCnt;
    }

    public void setStudyCnt(int studyCnt) {
        this.studyCnt = studyCnt;
    }

    public int getStudySessionTm() {
        return studySessionTm;
    }

    public void setStudySessionTm(int studySessionTm) {
        this.studySessionTm = studySessionTm;
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

    public String getLessonTimeId() {
        return lessonTimeId;
    }

    public void setLessonTimeId(String lessonTimeId) {
        this.lessonTimeId = lessonTimeId;
    }

    public String getLessonScheduleId() {
        return lessonScheduleId;
    }

    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }

    public Integer getPrgrRatio() {
        return prgrRatio;
    }

    public void setPrgrRatio(Integer prgrRatio) {
        this.prgrRatio = prgrRatio;
    }
    
    

}
