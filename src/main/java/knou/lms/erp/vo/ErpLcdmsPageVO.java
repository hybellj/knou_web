package knou.lms.erp.vo;

import java.util.Date;

public class ErpLcdmsPageVO {

    private String year;
    private String semester;
    private String gubun;
    private String courseCode;
    private String contCd;
    private int week;
    private String uploadGbn;
    private String pageCnt;
    private String pageNm;
    private String url;
    private String lbnTm;
    private String iniUploadDt;
    private String flUploadDt;
    private Date insertAt;
    private Date modifyAt;
    private String lmsOpenYn;
    private String lmsAttendYn;

    public String getYear() {
        return year;
    }

    public String getSemester() {
        return semester;
    }

    public String getGubun() {
        return gubun;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public String getContCd() {
        return contCd;
    }

    public int getWeek() {
        return week;
    }

    public String getUploadGbn() {
        return uploadGbn;
    }

    public String getPageCnt() {
        return pageCnt;
    }

    public String getPageNm() {
        return pageNm;
    }

    public String getUrl() {
        return url;
    }

    public String getLbnTm() {
        return lbnTm;
    }

    public String getIniUploadDt() {
        return iniUploadDt;
    }

    public String getFlUploadDt() {
        return flUploadDt;
    }

    public Date getInsertAt() {
        return insertAt;
    }

    public Date getModifyAt() {
        return modifyAt;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public void setGubun(String gubun) {
        this.gubun = gubun;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public void setContCd(String contCd) {
        this.contCd = contCd;
    }

    public void setWeek(int week) {
        this.week = week;
    }

    public void setUploadGbn(String uploadGbn) {
        this.uploadGbn = uploadGbn;
    }

    public void setPageCnt(String pageCnt) {
        this.pageCnt = pageCnt;
    }

    public void setPageNm(String pageNm) {
        this.pageNm = pageNm;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setLbnTm(String lbnTm) {
        this.lbnTm = lbnTm;
    }

    public void setIniUploadDt(String iniUploadDt) {
        this.iniUploadDt = iniUploadDt;
    }

    public void setFlUploadDt(String flUploadDt) {
        this.flUploadDt = flUploadDt;
    }

    public void setInsertAt(Date insertAt) {
        this.insertAt = insertAt;
    }

    public void setModifyAt(Date modifyAt) {
        this.modifyAt = modifyAt;
    }

	public String getLmsOpenYn() {
		return lmsOpenYn;
	}

	public void setLmsOpenYn(String lmsOpenYn) {
		this.lmsOpenYn = lmsOpenYn;
	}

	public String getLmsAttendYn() {
		return lmsAttendYn;
	}

	public void setLmsAttendYn(String lmsAttendYn) {
		this.lmsAttendYn = lmsAttendYn;
	}
    
    
}
