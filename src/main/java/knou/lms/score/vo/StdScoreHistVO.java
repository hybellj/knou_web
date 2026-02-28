package knou.lms.score.vo;

import knou.lms.common.vo.DefaultVO;

public class StdScoreHistVO extends DefaultVO {
	private static final long serialVersionUID = 8047732320507174771L;
	private String scoreHistSn;
    private String crsCreCd;
    private String userId;
    private String stdNo;
    private String chgCts;
    private String chgDttm;
    private String rgtrId;
    private String mdfrId;

    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }
    public String getChgCts() {
        return chgCts;
    }
    public void setChgCts(String chgCts) {
        this.chgCts = chgCts;
    }
    public String getRgtrId() {
        return rgtrId;
    }
    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }
    public String getMdfrId() {
        return mdfrId;
    }
    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
	public String getScoreHistSn() {
		return scoreHistSn;
	}
	public void setScoreHistSn(String scoreHistSn) {
		this.scoreHistSn = scoreHistSn;
	}
	public String getChgDttm() {
		return chgDttm;
	}
	public void setChgDttm(String chgDttm) {
		this.chgDttm = chgDttm;
	}
}
