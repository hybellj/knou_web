package knou.lms.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LessonCntsRecomVO extends DefaultVO {
    
    /** tb_lms_lesson_cnts_recom */
    private String  lessonCntsId;   // 학습콘텐츠 아이디
    private String  stdNo;          // 수강생 번호
    
    public String getLessonCntsId() {
        return lessonCntsId;
    }
    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
    }
    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }

}
