package knou.lms.common.vo;

public class OrgCfgCtgrVO extends DefaultVO {
    
    private static final long serialVersionUID = 6151864291923366229L;
    private String orgId;
	private String cfgCtgrCd;
	private String ctgrNm;  
	private String ctgrDesc;  
	private String useYn;
	
	public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
	public String getCfgCtgrCd() {
		return cfgCtgrCd;
	}
	public void setCfgCtgrCd(String cfgCtgrCd) {
		this.cfgCtgrCd = cfgCtgrCd;
	}
	public String getCtgrNm() {
		return ctgrNm;
	}
	public void setCtgrNm(String ctgrNm) {
		this.ctgrNm = ctgrNm;
	}
	public String getCtgrDesc() {
		return ctgrDesc;
	}
	public void setCtgrDesc(String ctgrDesc) {
		this.ctgrDesc = ctgrDesc;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
}
