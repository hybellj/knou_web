package knou.lms.crs.term.vo;

import knou.lms.common.vo.DefaultVO;

public class CrsTermLessonVO extends DefaultVO {
    private static final long serialVersionUID = 8502979470754269304L;

    private String		termCd;             // 학기 / 기수 코드
    private String		enrlType;           // 수강 유형 (online,offline,mix)
    private Integer		lsnOdr;             // 목차 순서
    private String		startDt;            // 주차 시작일
    private String		endDt;              // 주차 종료일
    private String		rgtrId;              // 등록자 번호
    private String		regDttm;            // 등록 일시
    private String		mdfrId;              // 수정자 번호
    private String		modDttm;            // 수정 일시
    private String		gubun;              // 구분
    private Integer		cnt;                // 개수
    private Integer		orderCnt;           // 실존 하는 값의 주차 개수
    private Integer		onlineCnt;          // 학기 주차 전체 저장할때 쓰임
    private Integer		offlineCnt;         // 학기 주차 전체 저장할때 쓰임
    private Integer		orgLsnOdr;          // 학기 주차 삭제 후 update문에 쓰임
    private String		uniGbn;				// 대학구분
    private String		ltDetmFrDt;         // 강의인정시작일자
    private String		ltDetmToDt;         // 강의인정종료일자
    private String		crsCreCd;			// 과목개설코드
    private Integer		lessonOrder;		// 목차순서
    private String		lessonObject;		// 학습목표
    private String		lessonContents;		// 학습내용
    private String[]	startDtString;
    private String[]	endDtString;
    private String[]	offStartDtString;
    private String[]	offEndDtString;
    private String[]	reviewStatus;
    private String		offStartDt;         // 오프라인주차  시작일
    private String		offEndDt;           // 오프라인주차  종료일
    private int[]		onlineLsnOrder;     // 학기 주차 삭제 후 update문에 쓰임
    private int[]		offLsnOrder;        // 학기 주차 삭제 후 update문에 쓰임
    private String		reviewStartDttm;    // 복습학습시작일시
    private String		reviewEndDttm;      // 복습학습종료일시

    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }

    public String getEnrlType() {
        return enrlType;
    }
    public void setEnrlType(String enrlType) {
        this.enrlType = enrlType;
    }

    public Integer getLsnOdr() {
        return lsnOdr;
    }
    public void setLsnOdr(Integer lsnOdr) {
        this.lsnOdr = lsnOdr;
    }

    public String getStartDt() {
        return startDt;
    }
    public void setStartDt(String startDt) {
        this.startDt = startDt;
    }

    public String getEndDt() {
        return endDt;
    }
    public void setEndDt(String endDt) {
        this.endDt = endDt;
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

    public String getGubun() {
        return gubun;
    }
    public void setGubun(String gubun) {
        this.gubun = gubun;
    }

    public Integer getCnt() {
        return cnt;
    }
    public void setCnt(Integer cnt) {
        this.cnt = cnt;
    }

    public Integer getOrderCnt() {
        return orderCnt;
    }
    public void setOrderCnt(Integer orderCnt) {
        this.orderCnt = orderCnt;
    }

    public String[] getStartDtString() {
        return startDtString;
    }
    public void setStartDtString(String[] startDtString) {
        this.startDtString = startDtString;
    }

    public String[] getEndDtString() {
        return endDtString;
    }
    public void setEndDtString(String[] endDtString) {
        this.endDtString = endDtString;
    }

    public Integer getOnlineCnt() {
        return onlineCnt;
    }
    public void setOnlineCnt(Integer onlineCnt) {
        this.onlineCnt = onlineCnt;
    }

    public Integer getOfflineCnt() {
        return offlineCnt;
    }
    public void setOfflineCnt(Integer offlineCnt) {
        this.offlineCnt = offlineCnt;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public Integer getLessonOrder() {
        return lessonOrder;
    }
    public void setLessonOrder(Integer lessonOrder) {
        this.lessonOrder = lessonOrder;
    }

    public String getLessonObject() {
        return lessonObject;
    }
    public void setLessonObject(String lessonObject) {
        this.lessonObject = lessonObject;
    }

    public String getLessonContents() {
        return lessonContents;
    }
    public void setLessonContents(String lessonContents) {
        this.lessonContents = lessonContents;
    }

    public String[] getOffStartDtString() {
        return offStartDtString;
    }
    public void setOffStartDtString(String[] offStartDtString) {
        this.offStartDtString = offStartDtString;
    }

    public String[] getOffEndDtString() {
        return offEndDtString;
    }
    public void setOffEndDtString(String[] offEndDtString) {
        this.offEndDtString = offEndDtString;
    }

    public String[] getReviewStatus() {
        return reviewStatus;
    }
    public void setReviewStatus(String[] reviewStatus) {
        this.reviewStatus = reviewStatus;
    }
    
    public String getOffStartDt() {
        return offStartDt;
    }
    public void setOffStartDt(String offStartDt) {
        this.offStartDt = offStartDt;
    }

    public String getOffEndDt() {
        return offEndDt;
    }
    public void setOffEndDt(String offEndDt) {
        this.offEndDt = offEndDt;
    }

    public Integer getOrgLsnOdr() {
        return orgLsnOdr;
    }
    public void setOrgLsnOdr(int orgLsnOdr) {
        this.orgLsnOdr = orgLsnOdr;
    }

    public void setOrgLsnOdr(Integer orgLsnOdr) {
        this.orgLsnOdr = orgLsnOdr;
    }

    public int[] getOnlineLsnOrder() {
        return onlineLsnOrder;
    }
    public void setOnlineLsnOrder(int[] onlineLsnOrder) {
        this.onlineLsnOrder = onlineLsnOrder;
    }

    public int[] getOffLsnOrder() {
        return offLsnOrder;
    }
    public void setOffLsnOrder(int[] offLsnOrder2) {
        this.offLsnOrder = offLsnOrder2;
    }

    public String getUniGbn() {
        return uniGbn;
    }
    public void setUniGbn(String uniGbn) {
        this.uniGbn = uniGbn;
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

    public String getReviewStartDttm() {
        return reviewStartDttm;
    }
    public void setReviewStartDttm(String reviewStartDttm) {
        this.reviewStartDttm = reviewStartDttm;
    }

    public String getReviewEndDttm() {
        return reviewEndDttm;
    }
    public void setReviewEndDttm(String reviewEndDttm) {
        this.reviewEndDttm = reviewEndDttm;
    }

}
