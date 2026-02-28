package knou.lms.common.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;

public class OrgCfgVO extends DefaultVO{

    private static final long serialVersionUID = -5686593167571899216L;
    private String  orgId;
	private String 	cfgCd;
	private String 	cfgCtgrCd;
	private String  cfgCtgrCdNm;
	private String 	cfgNm;
	private String 	cfgVal;
	private String 	cfgDesc;
	private int        codeOdr;
	private String 	useYn;
	
	private String 	cdVl;
	
	private List<OrgCfgVO> orgCfgLangList;
	
	public String getOrgId() {
	    return orgId;
	}
	public void setOrgId(String orgId) {
	    this.orgId= orgId;
	}
	public String getCfgCd() {
		return cfgCd;
	}
	public void setCfgCd(String cfgCd) {
		this.cfgCd = cfgCd;
	}
	public String getCfgCtgrCd() {
		return cfgCtgrCd;
	}
	public void setCfgCtgrCd(String cfgCtgrCd) {
		this.cfgCtgrCd = cfgCtgrCd;
	}
	public String getCfgCtgrCdNm() {
        return cfgCtgrCdNm;
    }
    public void setCfgCtgrCdNm(String cfgCtgrCdNm) {
        this.cfgCtgrCdNm = cfgCtgrCdNm;
    }
	public String getCfgNm() {
		return cfgNm;
	}
	public void setCfgNm(String cfgNm) {
		this.cfgNm = cfgNm;
	}
	public String getCfgVal() {
		return cfgVal;
	}
	public void setCfgVal(String cfgVal) {
		this.cfgVal = cfgVal;
	}
	public String getCfgDesc() {
		return cfgDesc;
	}
	public void setCfgDesc(String cfgDesc) {
		this.cfgDesc = cfgDesc;
	}
	
	public int getCodeOdr() {
        return codeOdr;
    }

    public void setCodeOdr(int codeOdr) {
        this.codeOdr = codeOdr;
    }
	
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	
	public List<OrgCfgVO> getOrgCfgLangList() {
	    if(ValidationUtils.isEmpty(orgCfgLangList)) orgCfgLangList = new ArrayList<OrgCfgVO>();
	    return orgCfgLangList;
	}
	public void setOrgCfgLangList(List<OrgCfgVO> orgCfgLangList) {
	    this.orgCfgLangList = orgCfgLangList;
	}
	public String getCdVl() {
		return cdVl;
	}
	public void setCdVl(String cdVl) {
		this.cdVl = cdVl;
	}
}
