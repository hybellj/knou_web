package knou.lms.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LessonCntsCmntVO extends DefaultVO {
    
    /** tb_lms_lesson_cnts_cmnt */
    private String  lessonCntsCmntId;       // 학습콘텐츠 댓글 아이디
    private String  parLessonCntsCmntId;    // 부모학습콘텐츠 댓글 아이디
    private String  lessonCntsId;           // 학습콘텐츠 아이디
    private String  stdNo;                  // 수강생 번호
    private String  cmntCts;                // 댓글 내용
    
    public String getLessonCntsCmntId() {
        return lessonCntsCmntId;
    }
    public void setLessonCntsCmntId(String lessonCntsCmntId) {
        this.lessonCntsCmntId = lessonCntsCmntId;
    }
    public String getParLessonCntsCmntId() {
        return parLessonCntsCmntId;
    }
    public void setParLessonCntsCmntId(String parLessonCntsCmntId) {
        this.parLessonCntsCmntId = parLessonCntsCmntId;
    }
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
    public String getCmntCts() {
        return cmntCts;
    }
    public void setCmntCts(String cmntCts) {
        this.cmntCts = cmntCts;
    }

}
