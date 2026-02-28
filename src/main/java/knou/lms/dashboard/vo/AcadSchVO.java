package knou.lms.dashboard.vo;

import knou.lms.common.vo.DefaultVO;

public class AcadSchVO extends DefaultVO {

    private static final long serialVersionUID = -1163265801965152887L;
    
    /** tb_home_acad_sch */
    private String  acadSchSn;          // 학사일정아이디
    private String  uniCd;              // 공통/학부/대학원 구분
    private String  calendarCtgr;       // 일정 분류
    private String  calendarRefCd;      // 일정 참조 코드
    private String  schStartDt;         // 일정시작일자
    private String  schEndDt;           // 일정종료일자
    private String  acadSchNm;          // 학사일정명
    private String  schCnts;            // 일정 내용
    private String  schCntsType;        // 일정내용 구분
    private String  useYn;              // 사용 여부
    
    private String  yyyyMM;             // 조회년월
    private String  startWeek;          // 요일(일정시작일시)
    private String  endWeek;            // 요일(일정종료일시)
    
    public String getAcadSchSn() {
        return acadSchSn;
    }
    public void setAcadSchSn(String acadSchSn) {
        this.acadSchSn = acadSchSn;
    }
    public String getCalendarCtgr() {
        return calendarCtgr;
    }
    public void setCalendarCtgr(String calendarCtgr) {
        this.calendarCtgr = calendarCtgr;
    }
    public String getCalendarRefCd() {
        return calendarRefCd;
    }
    public void setCalendarRefCd(String calendarRefCd) {
        this.calendarRefCd = calendarRefCd;
    }
    public String getSchStartDt() {
        return schStartDt;
    }
    public void setSchStartDt(String schStartDt) {
        this.schStartDt = schStartDt;
    }
    public String getSchEndDt() {
        return schEndDt;
    }
    public void setSchEndDt(String schEndDt) {
        this.schEndDt = schEndDt;
    }
    public String getAcadSchNm() {
        return acadSchNm;
    }
    public void setAcadSchNm(String acadSchNm) {
        this.acadSchNm = acadSchNm;
    }
    public String getSchCnts() {
        return schCnts;
    }
    public void setSchCnts(String schCnts) {
        this.schCnts = schCnts;
    }
    public String getSchCntsType() {
        return schCntsType;
    }
    public void setSchCntsType(String schCntsType) {
        this.schCntsType = schCntsType;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getYyyyMM() {
        return yyyyMM;
    }
    public void setYyyyMM(String yyyyMM) {
        this.yyyyMM = yyyyMM;
    }
    public String getStartWeek() {
        return startWeek;
    }
    public void setStartWeek(String startWeek) {
        this.startWeek = startWeek;
    }
    public String getEndWeek() {
        return endWeek;
    }
    public void setEndWeek(String endWeek) {
        this.endWeek = endWeek;
    }
	public String getUniCd() {
		return uniCd;
	}
	public void setUniCd(String uniCd) {
		this.uniCd = uniCd;
	}
    
}
