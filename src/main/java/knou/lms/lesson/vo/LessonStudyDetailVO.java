package knou.lms.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LessonStudyDetailVO extends DefaultVO {
    
    private static final long serialVersionUID = -7361151306345574520L;
    
    /** tb_lms_lesson_study_detail */
    private String  studyDetailId;      // 학습기록상세 아이디
    private String  stdId;              // 수강생 번호
    private String  lessonCntsId;       // 학습콘텐츠 아이디
    private Integer studyTm;            // 학습 시간(초)
    private String  studyBrowserCd;     // 학습브라우저코드
    private String  studyDeviceCd;      // 학습기기코드
    private String  studyClientEnv;     // 학습자환경
    private String  regIp;              // 등록자 IP
    private Integer studyCnt;           // 학습 횟수
    
    public String getStudyDetailId() {
        return studyDetailId;
    }
    public void setStudyDetailId(String studyDetailId) {
        this.studyDetailId = studyDetailId;
    }
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
    public Integer getStudyTm() {
        return studyTm;
    }
    public void setStudyTm(Integer studyTm) {
        this.studyTm = studyTm;
    }
    public String getStudyBrowserCd() {
        return studyBrowserCd;
    }
    public void setStudyBrowserCd(String studyBrowserCd) {
        this.studyBrowserCd = studyBrowserCd;
    }
    public String getStudyDeviceCd() {
        return studyDeviceCd;
    }
    public void setStudyDeviceCd(String studyDeviceCd) {
        this.studyDeviceCd = studyDeviceCd;
    }
    public String getStudyClientEnv() {
        return studyClientEnv;
    }
    public void setStudyClientEnv(String studyClientEnv) {
        this.studyClientEnv = studyClientEnv;
    }
    public String getRegIp() {
        return regIp;
    }
    public void setRegIp(String regIp) {
        this.regIp = regIp;
    }
    public Integer getStudyCnt() {
        return studyCnt;
    }
    public void setStudyCnt(Integer studyCnt) {
        this.studyCnt = studyCnt;
    }

}
