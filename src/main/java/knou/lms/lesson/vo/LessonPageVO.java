package knou.lms.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LessonPageVO extends DefaultVO {
    private static final long serialVersionUID = 4448992326624640840L;
    
    /** tb_lms_lesson_page */
    private String  lessonScheduleId;       // 학습일정 아이디
    private String  crsCreCd;               // 과정 개설 코드
    private String  lessonCntsId;           // 학습콘텐츠 아이디
    private String  lessonTimeId;           // 교시 아이디
    private String  pageCnt;                // 페이지순서
    private String  uploadGbn;              // 업로드구분
    private String  pageNm;                 // 페이지명
    private String  url;                    // URL
    private String  rgtrId;                  // 등록자번호
    private String  regDttm;                // 등록일시
    private String  mdfrId;                  // 수정자번호
    private String  modDttm;                // 수정일시
    private int     videoTm;                // 비디오시간  
    private String  atndYn;                 // 출석반영여부
    private String  openYn;                 // 오픈여부
    
    private String  studySessionLoc;

    public String getLessonScheduleId() {
        return lessonScheduleId;
    }

    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getLessonCntsId() {
        return lessonCntsId;
    }

    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
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

    public String getUploadGbn() {
        return uploadGbn;
    }

    public void setUploadGbn(String uploadGbn) {
        this.uploadGbn = uploadGbn;
    }

    public String getPageNm() {
        return pageNm;
    }

    public void setPageNm(String pageNm) {
        this.pageNm = pageNm;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
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

    public String getStudySessionLoc() {
        return studySessionLoc;
    }

    public void setStudySessionLoc(String studySessionLoc) {
        this.studySessionLoc = studySessionLoc;
    }

    public int getVideoTm() {
        return videoTm;
    }

    public void setVideoTm(int videoTm) {
        this.videoTm = videoTm;
    }

    public String getAtndYn() {
        return atndYn;
    }

    public String getOpenYn() {
        return openYn;
    }

    public void setAtndYn(String atndYn) {
        this.atndYn = atndYn;
    }

    public void setOpenYn(String openYn) {
        this.openYn = openYn;
    }
    
    
    
}
