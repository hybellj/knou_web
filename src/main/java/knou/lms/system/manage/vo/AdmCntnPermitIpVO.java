package knou.lms.system.manage.vo;

public class AdmCntnPermitIpVO{

    /**
	 * 
	 */
	private static final long serialVersionUID = -8759604291997653638L;

	/** 관리자접속허용IPID */
    private String admCntnPrmIpId;

    /** 차단값(IP 또는 대역) */
    private String bandVl;

    /** 차단확인여부 */
    private String bandChkyn;

    /** 접속허용IP구분코드 */
    private String cntnPrmIpGbncd;

    /** 사용여부 */
    private String useyn;

    /** 등록자ID */
    private String rgtrId;

    /** 등록일시 */
    private String regDttm;

    /** 수정자ID */
    private String mdfrId;

    /** 수정일시 */
    private String modDttm;

    /** 삭제여부 */
    private String delyn;

    public String getAdmCntnPrmIpId() {
        return admCntnPrmIpId;
    }

    public void setAdmCntnPrmIpId(String admCntnPrmIpId) {
        this.admCntnPrmIpId = admCntnPrmIpId;
    }

    public String getBandVl() {
        return bandVl;
    }

    public void setBandVl(String bandVl) {
        this.bandVl = bandVl;
    }

    public String getBandChkyn() {
        return bandChkyn;
    }

    public void setBandChkyn(String bandChkyn) {
        this.bandChkyn = bandChkyn;
    }

    public String getCntnPrmIpGbncd() {
        return cntnPrmIpGbncd;
    }

    public void setCntnPrmIpGbncd(String cntnPrmIpGbncd) {
        this.cntnPrmIpGbncd = cntnPrmIpGbncd;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
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

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }
}