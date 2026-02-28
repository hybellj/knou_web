package knou.lms.system.config.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("sysCfgVO")
public class SysCfgVO extends DefaultVO {

	private static final long serialVersionUID = 3119537605164735030L;
	
	private String cfgCd;
	private String cfgCtgrCd;
	private String cfgNm;
	private String cfgVal;
	private String cfgDesc;
	private String useYn;

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

	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	
}
