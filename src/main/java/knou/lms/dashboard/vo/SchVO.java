package knou.lms.dashboard.vo;

import java.util.List;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("schVO")
public class SchVO extends DefaultVO {

    private static final long serialVersionUID = -4167997069698228913L;
    
    private String calendarId;
    private String scheduleId;
    private String scheduleGubun;
    private String prefix;
    private String title;
    private String startDt;
    private String endDt;
    private String start;
    private String end;
    private String name;
    private String tchType;
    private String deptCd;
    private String deptNm;
    private String declsNo;
    private String declsNm;
    private String bgColor;

    private String orgId;
    private String classUserTypeGubun;
    private String[] userTypes;
    private String userId;
    private String calendarJson;
    private String scheduleJson;
    private String pageGubn;
    private String content;
    private String uniCd;                   // 학부구분
    private String useYn;
    private String termCd;
    private String[] sqlForeach;


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
    
    public String getStart() {
        return start;
    }
    public void setStart(String start) {
        this.start = start;
    }
    
    public String getEnd() {
        return end;
    }
    public void setEnd(String end) {
        this.end = end;
    }
    
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    
    public String getTchType() {
        return tchType;
    }
    public void setTchType(String tchType) {
        this.tchType = tchType;
    }
    
    public String getDeptCd() {
        return deptCd;
    }
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }
    
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    
    public String getDeclsNm() {
        return declsNm;
    }
    public void setDeclsNm(String declsNm) {
        this.declsNm = declsNm;
    }
    
    public String getBgColor() {
        return bgColor;
    }
    public void setBgColor(String bgColor) {
        this.bgColor = bgColor;
    }
    
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
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
    
    public String getCalendarJson() {
        return calendarJson;
    }
    public void setCalendarJson(String calendarJson) {
        this.calendarJson = calendarJson;
    }
    
    public String getScheduleJson() {
        return scheduleJson;
    }
    public void setScheduleJson(String scheduleJson) {
        this.scheduleJson = scheduleJson;
    }
    
    public String getPageGubn() {
        return pageGubn;
    }
    public void setPageGubn(String pageGubn) {
        this.pageGubn = pageGubn;
    }
    
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
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

    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }

    public String[] getSqlForeach() {
        return sqlForeach;
    }
    public void setSqlForeach(String[] sqlForeach) {
        this.sqlForeach = sqlForeach;
    }

}
