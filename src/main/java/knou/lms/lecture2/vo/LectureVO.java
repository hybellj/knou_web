package knou.lms.lecture2.vo;

import org.apache.ibatis.type.Alias;

@Alias("lectureVO")
public class LectureVO {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -304529545861670958L;
	private	String	sbjctId;
	private	String	stdntId;
	
    private String lctrId;
    private String lctrWknoSchdlId;
    private String lctrnm;
    private Integer lctrSeqno;
    private String lctrGbncd;
    private String prgRfltyn;
    private String lctrSdttm;
    private String lctrEdttm;
    private Integer rcmdAtndlcMnts;
    private String prgrtGbncd;
    private String inqyn;
    private String otsdprdAtndlcyn;
    private Integer otsdprdAtndlcDayCnt;
    private String otsdprdAtndlcRcgStscd;
    private String atndlcStsChkyn;
    private String atndlcNwinUseyn;
    private Integer atndlcScnds;
    private String mkupClasGbncd;
    private String vdoclasSdttm;
    private String vdoclasEdttm;
    private String vdoclasRmPswd;
    private String vdoclasExpln;
    private String vdoclasRmCntnId;
    private String delyn;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;

    // 기본 생성자
    public LectureVO() {}

    // Getter / Setter
    public String getLctrId() { return lctrId; }
    public void setLctrId(String lctrId) { this.lctrId = lctrId; }  

    public String getSbjctId() {
		return sbjctId;
	}

	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
	}

	public String getStdntId() {
		return stdntId;
	}

	public void setStdntId(String stdntId) {
		this.stdntId = stdntId;
	}

	public String getLctrWknoSchdlId() { return lctrWknoSchdlId; }
    public void setLctrWknoSchdlId(String lctrWknoSchdlId) { this.lctrWknoSchdlId = lctrWknoSchdlId; }

    public String getLctrnm() { return lctrnm; }
    public void setLctrnm(String lctrnm) { this.lctrnm = lctrnm; }

    public Integer getLctrSeqno() { return lctrSeqno; }
    public void setLctrSeqno(Integer lctrSeqno) { this.lctrSeqno = lctrSeqno; }

    public String getLctrGbncd() { return lctrGbncd; }
    public void setLctrGbncd(String lctrGbncd) { this.lctrGbncd = lctrGbncd; }

    public String getPrgRfltyn() { return prgRfltyn; }
    public void setPrgRfltyn(String prgRfltyn) { this.prgRfltyn = prgRfltyn; }

    public String getLctrSdttm() { return lctrSdttm; }
    public void setLctrSdttm(String lctrSdttm) { this.lctrSdttm = lctrSdttm; }

    public String getLctrEdttm() { return lctrEdttm; }
    public void setLctrEdttm(String lctrEdttm) { this.lctrEdttm = lctrEdttm; }

    public Integer getRcmdAtndlcMnts() { return rcmdAtndlcMnts; }
    public void setRcmdAtndlcMnts(Integer rcmdAtndlcMnts) { this.rcmdAtndlcMnts = rcmdAtndlcMnts; }

    public String getPrgrtGbncd() { return prgrtGbncd; }
    public void setPrgrtGbncd(String prgrtGbncd) { this.prgrtGbncd = prgrtGbncd; }

    public String getInqyn() { return inqyn; }
    public void setInqyn(String inqyn) { this.inqyn = inqyn; }

    public String getOtsdprdAtndlcyn() { return otsdprdAtndlcyn; }
    public void setOtsdprdAtndlcyn(String otsdprdAtndlcyn) { this.otsdprdAtndlcyn = otsdprdAtndlcyn; }

    public Integer getOtsdprdAtndlcDayCnt() { return otsdprdAtndlcDayCnt; }
    public void setOtsdprdAtndlcDayCnt(Integer otsdprdAtndlcDayCnt) { this.otsdprdAtndlcDayCnt = otsdprdAtndlcDayCnt; }

    public String getOtsdprdAtndlcRcgStscd() { return otsdprdAtndlcRcgStscd; }
    public void setOtsdprdAtndlcRcgStscd(String otsdprdAtndlcRcgStscd) { this.otsdprdAtndlcRcgStscd = otsdprdAtndlcRcgStscd; }

    public String getAtndlcStsChkyn() { return atndlcStsChkyn; }
    public void setAtndlcStsChkyn(String atndlcStsChkyn) { this.atndlcStsChkyn = atndlcStsChkyn; }

    public String getAtndlcNwinUseyn() { return atndlcNwinUseyn; }
    public void setAtndlcNwinUseyn(String atndlcNwinUseyn) { this.atndlcNwinUseyn = atndlcNwinUseyn; }

    public Integer getAtndlcScnds() { return atndlcScnds; }
    public void setAtndlcScnds(Integer atndlcScnds) { this.atndlcScnds = atndlcScnds; }

    public String getMkupClasGbncd() { return mkupClasGbncd; }
    public void setMkupClasGbncd(String mkupClasGbncd) { this.mkupClasGbncd = mkupClasGbncd; }

    public String getVdoclasSdttm() { return vdoclasSdttm; }
    public void setVdoclasSdttm(String vdoclasSdttm) { this.vdoclasSdttm = vdoclasSdttm; }

    public String getVdoclasEdttm() { return vdoclasEdttm; }
    public void setVdoclasEdttm(String vdoclasEdttm) { this.vdoclasEdttm = vdoclasEdttm; }

    public String getVdoclasRmPswd() { return vdoclasRmPswd; }
    public void setVdoclasRmPswd(String vdoclasRmPswd) { this.vdoclasRmPswd = vdoclasRmPswd; }

    public String getVdoclasExpln() { return vdoclasExpln; }
    public void setVdoclasExpln(String vdoclasExpln) { this.vdoclasExpln = vdoclasExpln; }

    public String getVdoclasRmCntnId() { return vdoclasRmCntnId; }
    public void setVdoclasRmCntnId(String vdoclasRmCntnId) { this.vdoclasRmCntnId = vdoclasRmCntnId; }

    public String getDelyn() { return delyn; }
    public void setDelyn(String delyn) { this.delyn = delyn; }

    public String getRgtrId() { return rgtrId; }
    public void setRgtrId(String rgtrId) { this.rgtrId = rgtrId; }

    public String getRegDttm() { return regDttm; }
    public void setRegDttm(String regDttm) { this.regDttm = regDttm; }

    public String getMdfrId() { return mdfrId; }
    public void setMdfrId(String mdfrId) { this.mdfrId = mdfrId; }

    public String getModDttm() { return modDttm; }
    public void setModDttm(String modDttm) { this.modDttm = modDttm; }

    // toString() 메서드 구현
    @Override
    public String toString() {
        return "LectureVO {" +
        		"lctrId='" + lctrId + '\'' +
                ", stdntId='" + stdntId + '\'' +
                ", sbjctId='" + sbjctId + '\'' +
                ", lctrWknoSchdlId='" + lctrWknoSchdlId + '\'' +
                ", lctrnm='" + lctrnm + '\'' +
                ", lctrSeqno=" + lctrSeqno +
                ", lctrGbncd='" + lctrGbncd + '\'' +
                ", prgRfltyn='" + prgRfltyn + '\'' +
                ", lctrSdttm='" + lctrSdttm + '\'' +
                ", lctrEdttm='" + lctrEdttm + '\'' +
                ", rcmdAtndlcMnts=" + rcmdAtndlcMnts +
                ", prgrtGbncd='" + prgrtGbncd + '\'' +
                ", inqyn='" + inqyn + '\'' +
                ", otsdprdAtndlcyn='" + otsdprdAtndlcyn + '\'' +
                ", otsdprdAtndlcDayCnt=" + otsdprdAtndlcDayCnt +
                ", otsdprdAtndlcRcgStscd='" + otsdprdAtndlcRcgStscd + '\'' +
                ", atndlcStsChkyn='" + atndlcStsChkyn + '\'' +
                ", atndlcNwinUseyn='" + atndlcNwinUseyn + '\'' +
                ", atndlcScnds=" + atndlcScnds +
                ", mkupClasGbncd='" + mkupClasGbncd + '\'' +
                ", vdoclasSdttm='" + vdoclasSdttm + '\'' +
                ", vdoclasEdttm='" + vdoclasEdttm + '\'' +
                ", vdoclasRmPswd='" + vdoclasRmPswd + '\'' +
                ", vdoclasExpln='" + vdoclasExpln + '\'' +
                ", vdoclasRmCntnId='" + vdoclasRmCntnId + '\'' +
                ", delyn='" + delyn + '\'' +
                ", rgtrId='" + rgtrId + '\'' +
                ", regDttm='" + regDttm + '\'' +
                ", mdfrId='" + mdfrId + '\'' +
                ", modDttm='" + modDttm + '\'' +
                '}';
    }
}