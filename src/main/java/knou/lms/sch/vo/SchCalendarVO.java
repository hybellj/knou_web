package knou.lms.sch.vo;

import knou.lms.common.vo.DefaultVO;

public class SchCalendarVO  extends DefaultVO {

    private static final long serialVersionUID = -4167997069698228913L;
    private String   calendarId;
    private String   scheduleId;
    private String   scheduleGubun;
    private String   prefix;
    private String   title;
    private String   content;
    private String   startDt;
    private String   endDt;
    // oracle에서 해당 명칭이 예약어라서 변경
//    private String   start;
//    private String   end;
    private String   startFmt;
    private String   endFmt;
    private String   name;
    private String   declsNo;
    private String   bgColor;
    
    private String   classUserTypeGubun;
    private String[] userTypes;
    private String   userId;
    private String   uniCd;     // 학부구분
    private String  useYn;
    
    private String  creYear;


    public String getCalendarId() {
        return calendarId;
    }
    public void setCalendarId(String calendarId) {
        this.calendarId = calendarId;
    }
    public String getScheduleId() {
        return scheduleId;
    }
    public void setScheduleId(String scheduleId) {
        this.scheduleId = scheduleId;
    }
    public String getScheduleGubun() {
        return scheduleGubun;
    }
    public void setScheduleGubun(String scheduleGubun) {
        this.scheduleGubun = scheduleGubun;
    }
    public String getPrefix() {
        return prefix;
    }
    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
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

	/*
	 * public String getStart() { return start; } public void setStart(String start)
	 * { this.start = start; } public String getEnd() { return end; } public void
	 * setEnd(String end) { this.end = end; }
	 */
    
    public String getName() {
        return name;
    }
    public String getStartFmt() {
		return startFmt;
	}
	public void setStartFmt(String startFmt) {
		this.startFmt = startFmt;
	}
	public String getEndFmt() {
		return endFmt;
	}
	public void setEndFmt(String endFmt) {
		this.endFmt = endFmt;
	}
	public void setName(String name) {
        this.name = name;
    }
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    public String getBgColor() {
        return bgColor;
    }
    public void setBgColor(String bgColor) {
        this.bgColor = bgColor;
    }
    public String getClassUserTypeGubun() {
        return classUserTypeGubun;
    }
    public void setClassUserTypeGubun(String classUserTypeGubun) {
        this.classUserTypeGubun = classUserTypeGubun;
    }
    public String[] getUserTypes() {
        return userTypes;
    }
    public void setUserTypes(String[] userTypes) {
        this.userTypes = userTypes;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getUniCd() {
        return uniCd;
    }
    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getCreYear() {
        return creYear;
    }
    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }

}
