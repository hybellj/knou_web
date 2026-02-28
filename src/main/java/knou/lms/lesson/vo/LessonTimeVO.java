package knou.lms.lesson.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;
import knou.lms.seminar.vo.SeminarVO;

public class LessonTimeVO extends DefaultVO {
    private static final long serialVersionUID = 8955366066203437010L;
    
    /** tb_lms_lesson_time */
    private String  lessonTimeId;           // 교시 아이디
    private String  lessonScheduleId;       // 학습일정 아이디
    private String  lessonTimeNm;           // 교시명
    private Integer lessonTimeOrder;        // 교시순서
    private String  stdyMethod;
    private String  prevTimeId;
    private String  nextTimeId;
    
    private List<LessonCntsVO> listLessonCnts;
    private List<SeminarVO> listSeminar;
    
    private String  copyLessonTimeId;
    
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
    public String getLessonTimeNm() {
        return lessonTimeNm;
    }
    public void setLessonTimeNm(String lessonTimeNm) {
        this.lessonTimeNm = lessonTimeNm;
    }
    public Integer getLessonTimeOrder() {
        return lessonTimeOrder;
    }
    public void setLessonTimeOrder(Integer lessonTimeOrder) {
        this.lessonTimeOrder = lessonTimeOrder;
    }
    public List<LessonCntsVO> getListLessonCnts() {
        return listLessonCnts;
    }
    public void setListLessonCnts(List<LessonCntsVO> listLessonCnts) {
        this.listLessonCnts = listLessonCnts;
    }
    public String getStdyMethod() {
        return stdyMethod;
    }
    public void setStdyMethod(String stdyMethod) {
        this.stdyMethod = stdyMethod;
    }
    public String getPrevTimeId() {
        return prevTimeId;
    }
    public void setPrevTimeId(String prevTimeId) {
        this.prevTimeId = prevTimeId;
    }
    public String getNextTimeId() {
        return nextTimeId;
    }
    public void setNextTimeId(String nextTimeId) {
        this.nextTimeId = nextTimeId;
    }
    public List<SeminarVO> getListSeminar() {
        return listSeminar;
    }
    public void setListSeminar(List<SeminarVO> listSeminar) {
        this.listSeminar = listSeminar;
    }
    public String getCopyLessonTimeId() {
        return copyLessonTimeId;
    }
    public void setCopyLessonTimeId(String copyLessonTimeId) {
        this.copyLessonTimeId = copyLessonTimeId;
    }

}
