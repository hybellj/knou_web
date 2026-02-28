package knou.lms.lesson.vo;

import java.util.List;
import java.util.Map;

import knou.lms.common.vo.DefaultVO;

public class LessonScheduleVO extends DefaultVO {
    private static final long serialVersionUID = 4448992326624640847L;

    /** tb_lms_lesson_schedule */
    private String  lessonScheduleId;    // 학습일정 아이디
    private String  crsCreNm;            // 과정 개설 명
    private String  crsCreCd;            // 과정 개설 코드
    private String  lessonScheduleNm;    // 학습일정 명
    private Integer lessonScheduleOrder; // 학습일정순서
    private String  enrlType;			  // 수강 유형 (online,offline,mix)
    private String  lessonObject;        // 학습목표
    private String  lessonSummary;       // 학습개요
    private String  lessonRefData;       // 학습참고자료
    private String  lessonStartDt;       // 학습시작일자
    private String  lessonEndDt;         // 학습종료일자
    private String  openYn;              // 오픈여부
    private String  delYn;               // 삭제 여부
    private int     lbnTm;               // 학습시간
    private String  ltNote;              // 강의노트
    private String  ltNoteOfferYn;       // 강의노트 사용여부
    private String  startDtYn;           // 학습시작일 여부
    private String  endDtYn;             // 학습종료일 여부
    private String ltDetmFrDt;           // 강의인정시작일자
    private String ltDetmToDt;           // 강의인정종료일자
    private String ltDetmToDtMax;        // 강의인정종료일자 마지막일

    private String studyStatusCd;
    private String studyStatusCdBak;
    
    private String wekClsfGbn;
    private int    prgrVideoCnt;
    private int    videoCnt;
    private String prgrYn;
    private String lessonCntsId;
    private String lbnTmStr;
    private String lcdmsLinkYn;

    private String                      stdId;
    private List<LessonTimeVO>          listLessonTime;
    private String                      lessonScheduleProgress; // 주차 진행 상태
    private String                      examStareTypeCd;        // 주차 시험 타입
    private Integer                     studyTotalTm;           // 학생 주차별 학습시간
    private Integer                     studyAfterTm;           // 학생 주차별 기간외 학습시간
    private Map<String, Object>         studyElementMap;
    private String                      lessonScheduleStat;    // 주차 학습가능 상태
    private String                      allLessonOpenYn;
    private String                      lessonScheduleEnd14Yn; // 14주차 종료여부
    
    public String getLessonScheduleId() {
        return lessonScheduleId;
    }

    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }

    public String getCrsCreNm() {
        return crsCreNm;
    }

    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getLessonScheduleNm() {
        return lessonScheduleNm;
    }

    public void setLessonScheduleNm(String lessonScheduleNm) {
        this.lessonScheduleNm = lessonScheduleNm;
    }

    public Integer getLessonScheduleOrder() {
        return lessonScheduleOrder;
    }

    public void setLessonScheduleOrder(Integer lessonScheduleOrder) {
        this.lessonScheduleOrder = lessonScheduleOrder;
    }

    public String getLessonObject() {
        return lessonObject;
    }

    public void setLessonObject(String lessonObject) {
        this.lessonObject = lessonObject;
    }

    public String getLessonSummary() {
        return lessonSummary;
    }

    public void setLessonSummary(String lessonSummary) {
        this.lessonSummary = lessonSummary;
    }

    public String getLessonRefData() {
        return lessonRefData;
    }

    public void setLessonRefData(String lessonRefData) {
        this.lessonRefData = lessonRefData;
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

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getStudyStatusCd() {
        return studyStatusCd;
    }

    public void setStudyStatusCd(String studyStatusCd) {
        this.studyStatusCd = studyStatusCd;
    }

    public List<LessonTimeVO> getListLessonTime() {
        return listLessonTime;
    }

    public void setListLessonTime(List<LessonTimeVO> listLessonTime) {
        this.listLessonTime = listLessonTime;
    }

    public int getLbnTm() {
        return lbnTm;
    }

    public void setLbnTm(int lbnTm) {
        this.lbnTm = lbnTm;
    }

    public String getLtNote() {
        return ltNote;
    }

    public void setLtNote(String ltNote) {
        this.ltNote = ltNote;
    }

    public String getLessonScheduleProgress() {
        return lessonScheduleProgress;
    }

    public void setLessonScheduleProgress(String lessonScheduleProgress) {
        this.lessonScheduleProgress = lessonScheduleProgress;
    }

    public String getExamStareTypeCd() {
        return examStareTypeCd;
    }

    public void setExamStareTypeCd(String examStareTypeCd) {
        this.examStareTypeCd = examStareTypeCd;
    }

    public String getOpenYn() {
        return openYn;
    }

    public void setOpenYn(String openYn) {
        this.openYn = openYn;
    }

    public Integer getStudyTotalTm() {
        return studyTotalTm;
    }

    public void setStudyTotalTm(Integer studyTotalTm) {
        this.studyTotalTm = studyTotalTm;
    }

    public Map<String, Object> getStudyElementMap() {
        return studyElementMap;
    }

    public void setStudyElementMap(Map<String, Object> studyElementMap) {
        this.studyElementMap = studyElementMap;
    }

    public Integer getStudyAfterTm() {
        return studyAfterTm;
    }

    public void setStudyAfterTm(Integer studyAfterTm) {
        this.studyAfterTm = studyAfterTm;
    }

    public String getStartDtYn() {
        return startDtYn;
    }

    public void setStartDtYn(String startDtYn) {
        this.startDtYn = startDtYn;
    }

    public String getEndDtYn() {
        return endDtYn;
    }

    public void setEndDtYn(String endDtYn) {
        this.endDtYn = endDtYn;
    }

    public String getLtDetmFrDt() {
        return ltDetmFrDt;
    }

    public void setLtDetmFrDt(String ltDetmFrDt) {
        this.ltDetmFrDt = ltDetmFrDt;
    }

    public String getLtDetmToDt() {
        return ltDetmToDt;
    }

    public void setLtDetmToDt(String ltDetmToDt) {
        this.ltDetmToDt = ltDetmToDt;
    }

    public String getStudyStatusCdBak() {
        return studyStatusCdBak;
    }

    public void setStudyStatusCdBak(String studyStatusCdBak) {
        this.studyStatusCdBak = studyStatusCdBak;
    }

    public String getLessonScheduleStat() {
        return lessonScheduleStat;
    }

    public void setLessonScheduleStat(String lessonScheduleStat) {
        this.lessonScheduleStat = lessonScheduleStat;
    }

    public String getLtDetmToDtMax() {
        return ltDetmToDtMax;
    }

    public void setLtDetmToDtMax(String ltDetmToDtMax) {
        this.ltDetmToDtMax = ltDetmToDtMax;
    }

    public String getLtNoteOfferYn() {
        return ltNoteOfferYn;
    }

    public void setLtNoteOfferYn(String ltNoteOfferYn) {
        this.ltNoteOfferYn = ltNoteOfferYn;
    }

    public String getAllLessonOpenYn() {
        return allLessonOpenYn;
    }

    public void setAllLessonOpenYn(String allLessonOpenYn) {
        this.allLessonOpenYn = allLessonOpenYn;
    }

    public String getWekClsfGbn() {
        return wekClsfGbn;
    }

    public void setWekClsfGbn(String wekClsfGbn) {
        this.wekClsfGbn = wekClsfGbn;
    }

    public String getLessonScheduleEnd14Yn() {
        return lessonScheduleEnd14Yn;
    }

    public void setLessonScheduleEnd14Yn(String lessonScheduleEnd14Yn) {
        this.lessonScheduleEnd14Yn = lessonScheduleEnd14Yn;
    }

    public String getPrgrYn() {
        return prgrYn;
    }

    public void setPrgrYn(String prgrYn) {
        this.prgrYn = prgrYn;
    }

    public String getLessonCntsId() {
        return lessonCntsId;
    }

    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getEnrlType() {
        return enrlType;
    }

    public void setEnrlType(String enrlType) {
        this.enrlType = enrlType;
    }

    public String getLbnTmStr() {
        return lbnTmStr;
    }

    public void setLbnTmStr(String lbnTmStr) {
        this.lbnTmStr = lbnTmStr;
    }

    public int getPrgrVideoCnt() {
        return prgrVideoCnt;
    }

    public void setPrgrVideoCnt(int prgrVideoCnt) {
        this.prgrVideoCnt = prgrVideoCnt;
    }

	public String getLcdmsLinkYn() {
		return lcdmsLinkYn;
	}

	public void setLcdmsLinkYn(String lcdmsLinkYn) {
		this.lcdmsLinkYn = lcdmsLinkYn;
	}

    public int getVideoCnt() {
        return videoCnt;
    }

    public void setVideoCnt(int videoCnt) {
        this.videoCnt = videoCnt;
    }

}
