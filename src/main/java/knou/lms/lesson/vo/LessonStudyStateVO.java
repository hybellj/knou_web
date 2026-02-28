package knou.lms.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LessonStudyStateVO extends DefaultVO {

    private static final long serialVersionUID = 337049569888732895L;
    private String lessonScheduleId;
    private String stdId;
    private String userId;
    private String studyStatusCd;
    private String studyStatusCdBak;
    private String crsCreCd;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;
    private int    studyTotalTm = 0;
    private int    studyAfterTm = 0;
    private Integer studyCnt;               // 학습 횟수
    private String attendReason;
    private int    lbnTm;               // 학습시간
    private String ltDetmFrDt;           // 강의인정시작일자
    private String ltDetmToDt;           // 강의인정종료일자
    private String ltDetmToDtMax;
    private String prgrYn;
    private String lessonCntsId;
    
    
    public String getLessonScheduleId() {
        return lessonScheduleId;
    }

    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
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

    public String getStudyStatusCd() {
        return studyStatusCd;
    }

    public void setStudyStatusCd(String studyStatusCd) {
        this.studyStatusCd = studyStatusCd;
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

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getStudyStatusCdBak() {
        return studyStatusCdBak;
    }

    public void setStudyStatusCdBak(String studyStatusCdBak) {
        this.studyStatusCdBak = studyStatusCdBak;
    }

    public int getStudyTotalTm() {
        return studyTotalTm;
    }

    public void setStudyTotalTm(int studyTotalTm) {
        this.studyTotalTm = studyTotalTm;
    }

    public int getStudyAfterTm() {
        return studyAfterTm;
    }

    public void setStudyAfterTm(int studyAfterTm) {
        this.studyAfterTm = studyAfterTm;
    }

    public Integer getStudyCnt() {
        return studyCnt;
    }

    public void setStudyCnt(Integer studyCnt) {
        this.studyCnt = studyCnt;
    }

    public String getAttendReason() {
        return attendReason;
    }

    public void setAttendReason(String attendReason) {
        this.attendReason = attendReason;
    }

    public int getLbnTm() {
        return lbnTm;
    }

    public String getLtDetmFrDt() {
        return ltDetmFrDt;
    }

    public String getLtDetmToDt() {
        return ltDetmToDt;
    }

    public void setLbnTm(int lbnTm) {
        this.lbnTm = lbnTm;
    }

    public void setLtDetmFrDt(String ltDetmFrDt) {
        this.ltDetmFrDt = ltDetmFrDt;
    }

    public void setLtDetmToDt(String ltDetmToDt) {
        this.ltDetmToDt = ltDetmToDt;
    }

    public String getPrgrYn() {
        return prgrYn;
    }

    public void setPrgrYn(String prgrYn) {
        this.prgrYn = prgrYn;
    }

    public String getLtDetmToDtMax() {
        return ltDetmToDtMax;
    }

    public void setLtDetmToDtMax(String ltDetmToDtMax) {
        this.ltDetmToDtMax = ltDetmToDtMax;
    }

    public String getLessonCntsId() {
        return lessonCntsId;
    }

    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
    }
    
    
}
