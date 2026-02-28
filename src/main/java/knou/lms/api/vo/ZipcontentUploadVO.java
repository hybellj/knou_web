package knou.lms.api.vo;

import knou.lms.common.vo.DefaultVO;

public class ZipcontentUploadVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String zipcontentLogSn;
    private String curriCode;
    private String week;
    private String pageSeq;
    private String uploadPath;
    private String uploadFileNm;
    private long uploadSize;
    private String rgtrId;
    private String regDttm;

    public String getZipcontentLogSn() {
        return zipcontentLogSn;
    }
    public void setZipcontentLogSn(String zipcontentLogSn) {
        this.zipcontentLogSn = zipcontentLogSn;
    }

    public String getCurriCode() {
        return curriCode;
    }
    public void setCurriCode(String curriCode) {
        this.curriCode = curriCode;
    }

    public String getWeek() {
        return week;
    }
    public void setWeek(String week) {
        this.week = week;
    }

    public String getPageSeq() {
        return pageSeq;
    }
    public void setPageSeq(String pageSeq) {
        this.pageSeq = pageSeq;
    }

    public String getUploadPath() {
        return uploadPath;
    }
    public void setUploadPath(String uploadPath) {
        this.uploadPath = uploadPath;
    }

    public String getUploadFileNm() {
        return uploadFileNm;
    }
    public void setUploadFileNm(String uploadFileNm) {
        this.uploadFileNm = uploadFileNm;
    }

    public long getUploadSize() {
        return uploadSize;
    }
    public void setUploadSize(long uploadSize) {
        this.uploadSize = uploadSize;
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

}