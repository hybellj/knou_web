package knou.lms.api.vo;

import java.util.Date;

import knou.lms.common.vo.DefaultVO;

public class CntsPreviewVO extends DefaultVO {
    private static final long serialVersionUID = 1L;
    private String year;
    private String semester;
    private String gubun;
    private String contCd;
    private String scCd;
    private String scNm;
    private String seqName;
    private int week;
    private String lbnTm;
    private String lecNote2;
    private Date insertAt;
    private Date modifyAt;
    private String pageInfo;

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getYear() {
        return year;
    }

    public String getSemester() {
        return semester;
    }

    public String getGubun() {
        return gubun;
    }

    public String getContCd() {
        return contCd;
    }

    public String getScCd() {
        return scCd;
    }

    public String getScNm() {
        return scNm;
    }

    public String getSeqName() {
        return seqName;
    }

    public int getWeek() {
        return week;
    }

    public String getLbnTm() {
        return lbnTm;
    }

    public String getLecNote2() {
        return lecNote2;
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

    public void setContCd(String contCd) {
        this.contCd = contCd;
    }

    public void setScCd(String scCd) {
        this.scCd = scCd;
    }

    public void setScNm(String scNm) {
        this.scNm = scNm;
    }

    public void setSeqName(String seqName) {
        this.seqName = seqName;
    }

    public void setWeek(int week) {
        this.week = week;
    }

    public void setLbnTm(String lbnTm) {
        this.lbnTm = lbnTm;
    }

    public void setLecNote2(String lecNote2) {
        this.lecNote2 = lecNote2;
    }

    public void setInsertAt(Date insertAt) {
        this.insertAt = insertAt;
    }

    public void setModifyAt(Date modifyAt) {
        this.modifyAt = modifyAt;
    }

    public String getPageInfo() {
        return pageInfo;
    }

    public void setPageInfo(String pageInfo) {
        this.pageInfo = pageInfo;
    }
    
}
