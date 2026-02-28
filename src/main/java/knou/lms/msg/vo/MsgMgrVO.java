package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

public class MsgMgrVO extends DefaultVO{
	private static final long serialVersionUID = -5725599834765231281L;
	
	private String cmmnCdId;
	private String cd;         
	private String upCd;
	private String upCdnm;
	private Integer cdSeq;
	private String cdnm;       
	private String cdVl;
	private String cdEnnm;
	private String cdExpln;
	private String grpcd;      
	private String useyn;      

	
	private Boolean isRoot;	// 최상위 조회 여부
	
	public String getCmmnCdId() {
		return cmmnCdId;
	}
	public void setCmmnCdId(String cmmnCdId) {
		this.cmmnCdId = cmmnCdId;
	}
	public String getCd() {
		return cd;
	}
	public void setCd(String cd) {
		this.cd = cd;
	}
	public String getUpCd() {
		return upCd;
	}
	public void setUpCd(String upCd) {
		this.upCd = upCd;
	}
	public String getUpCdnm() {
		return upCdnm;
	}
	public void setUpCdnm(String upCdnm) {
		this.upCdnm = upCdnm;
	}
	public Integer getCdSeq() {
		return cdSeq;
	}
	public void setCdSeq(Integer cdSeq) {
		this.cdSeq = cdSeq;
	}
	public String getCdnm() {
		return cdnm;
	}
	public void setCdnm(String cdnm) {
		this.cdnm = cdnm;
	}
	public String getCdVl() {
		return cdVl;
	}
	public void setCdVl(String cdVl) {
		this.cdVl = cdVl;
	}
	public String getCdEnnm() {
		return cdEnnm;
	}
	public void setCdEnnm(String cdEnnm) {
		this.cdEnnm = cdEnnm;
	}
	public String getCdExpln() {
		return cdExpln;
	}
	public void setCdExpln(String cdExpln) {
		this.cdExpln = cdExpln;
	}
	public String getGrpcd() {
		return grpcd;
	}
	public void setGrpcd(String grpcd) {
		this.grpcd = grpcd;
	}
	public String getUseyn() {
		return useyn;
	}
	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}
	public Boolean getIsRoot() {
		return isRoot;
	}
	public void setIsRoot(Boolean isRoot) {
		this.isRoot = isRoot;
	}

	
	
}
