package knou.lms.crs.crecrs.vo;

import java.util.Date;

import knou.lms.common.vo.DefaultVO;


public class HpIntchVO extends DefaultVO {
    private static final long serialVersionUID = 1L;
    private String yy;
    private String tmGbn;
    private String stuno;
    private String deptNm;
    private String stdKorNm;
    private String hpIntchGbn;
    private String hpIntchGbnNm;
    private String scCd;
    private String scNm;
    private String ltNo;
    private String hyuStuno;
    private String cptnGbn;
    private String cptnGbnNm;
    private String tlsnAplyHp;
    private String enrollYn;
    private String urlNm;
    private String url;
    private Date insertAt;    
    private Date modifyAt;
    
    private String yr;
    private String crdtsExchUnvstdId;

	public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getYy() {
        return yy;
    }

    public String getTmGbn() {
        return tmGbn;
    }

    public String getStuno() {
        return stuno;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public String getStdKorNm() {
        return stdKorNm;
    }

    public String getHpIntchGbn() {
        return hpIntchGbn;
    }

    public String getHpIntchGbnNm() {
        return hpIntchGbnNm;
    }

    public String getScCd() {
        return scCd;
    }

    public String getScNm() {
        return scNm;
    }

    public String getLtNo() {
        return ltNo;
    }

    public String getHyuStuno() {
        return hyuStuno;
    }

    public String getCptnGbn() {
        return cptnGbn;
    }

    public String getCptnGbnNm() {
        return cptnGbnNm;
    }

    public String getTlsnAplyHp() {
        return tlsnAplyHp;
    }

    public String getEnrollYn() {
        return enrollYn;
    }

    public String getUrlNm() {
        return urlNm;
    }

    public String getUrl() {
        return url;
    }

    public Date getInsertAt() {
        return insertAt;
    }

    public Date getModifyAt() {
        return modifyAt;
    }

    public void setYy(String yy) {
        this.yy = yy;
    }

    public void setTmGbn(String tmGbn) {
        this.tmGbn = tmGbn;
    }

    public void setStuno(String stuno) {
        this.stuno = stuno;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public void setStdKorNm(String stdKorNm) {
        this.stdKorNm = stdKorNm;
    }

    public void setHpIntchGbn(String hpIntchGbn) {
        this.hpIntchGbn = hpIntchGbn;
    }

    public void setHpIntchGbnNm(String hpIntchGbnNm) {
        this.hpIntchGbnNm = hpIntchGbnNm;
    }

    public void setScCd(String scCd) {
        this.scCd = scCd;
    }

    public void setScNm(String scNm) {
        this.scNm = scNm;
    }

    public void setLtNo(String ltNo) {
        this.ltNo = ltNo;
    }

    public void setHyuStuno(String hyuStuno) {
        this.hyuStuno = hyuStuno;
    }

    public void setCptnGbn(String cptnGbn) {
        this.cptnGbn = cptnGbn;
    }

    public void setCptnGbnNm(String cptnGbnNm) {
        this.cptnGbnNm = cptnGbnNm;
    }

    public void setTlsnAplyHp(String tlsnAplyHp) {
        this.tlsnAplyHp = tlsnAplyHp;
    }

    public void setEnrollYn(String enrollYn) {
        this.enrollYn = enrollYn;
    }

    public void setUrlNm(String urlNm) {
        this.urlNm = urlNm;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setInsertAt(Date insertAt) {
        this.insertAt = insertAt;
    }

    public void setModifyAt(Date modifyAt) {
        this.modifyAt = modifyAt;
    }

	public String getYr() {
		return yr;
	}

	public void setYr(String yr) {
		this.yr = yr;
	}
    
	public String getCrdtsExchUnvstdId() {
		return crdtsExchUnvstdId;
	}

	public void setCrdtsExchUnvstdId(String crdtsExchUnvstdId) {
		this.crdtsExchUnvstdId = crdtsExchUnvstdId;
	}
}
