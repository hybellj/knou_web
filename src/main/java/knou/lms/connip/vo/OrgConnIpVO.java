package knou.lms.connip.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("orgConnIpVO")
public class OrgConnIpVO extends DefaultVO {

	private static final long serialVersionUID = 7398798073781591165L;

	private String  orgId;
	private String  connIp;
	private String  useYn;
	private String  bandYn;
	private String  bandVal;
	private String  remoteIp;
	private String  lineNo;

	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	
	public String getConnIp() {
		return connIp;
	}
	public void setConnIp(String connIp) {
		this.connIp = connIp;
	}
	
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	
	public String getRemoteIp() {
		return remoteIp;
	}
	public void setRemoteIp(String remoteIp) {
		this.remoteIp = remoteIp;
	}
	
	public String getBandYn() {
		return bandYn;
	}
	public void setBandYn(String bandYn) {
		this.bandYn = bandYn;
	}
	
	public String getBandVal() {
		return bandVal;
	}
	public void setBandVal(String bandVal) {
		this.bandVal = bandVal;
	}
	
	public String getLineNo() {
		return lineNo;
	}
	public void setLineNo(String lineNo) {
		this.lineNo = lineNo;
	}

}
