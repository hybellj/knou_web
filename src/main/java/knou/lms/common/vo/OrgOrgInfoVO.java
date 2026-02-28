package knou.lms.common.vo;

import knou.framework.common.CommConst;


public class OrgOrgInfoVO extends DefaultVO{

	private static final long serialVersionUID = -7605381152519680765L;

	private String  orgNm;
	private String  orgDomain;
	private String  domainNm;
	private String  startDttm;
	private String  endDttm;
	private String  useYn;
	private String  sysTypeCd;
	private String  dfltLangCd;
	private String  productCd;
	private String  layoutTplCd;
	private String  colorTplCd;
	private Integer limitNopCnt;
	private String  tplCd;
	private String  autoMakeYn;
	private String  durationYn;
	private String  wwwFooter;
	private String  admFooter;
	private String  menuVer;
	private String  emailAddr;
	private String  emailNm;
	private String  rprstPhoneNo;
	private String  rprstDomain;
	private String  subLogo1Url;
	private String  subLogo2Url;
	private String  chrgPrsnInfo;
	private String  mbrIdType;
	private String  mbrAplcUseYn;
	private int logCnt;
	private String[] contextArr;
	private String 	contextName;
	private String productServiceType;
	
	//개설신청번호
	private Integer aplcSn;
	//통합회원 사용여부
	private String  itgrtMbrUseYn;
	
	//사이트 용도
	private String  siteUsageCd;
	
	//컨텐츠 권한 코드
	private String  conAuthCd;
	
	//DB 암호화 키
	private String  dbEncKey = CommConst.DB_ENCRYPTION_KEY;

	public String getOrgNm() {
		return orgNm;
	}
	public void setOrgNm(String orgNm) {
		this.orgNm = orgNm;
	}
	public String getDomainNm() {
		return domainNm;
	}
	public void setDomainNm(String domainNm) {
		this.domainNm = domainNm;
	}
	public String getStartDttm() {
		return startDttm;
	}
	public void setStartDttm(String startDttm) {
		this.startDttm = startDttm;
	}
	public String getEndDttm() {
		return endDttm;
	}
	public void setEndDttm(String endDttm) {
		this.endDttm = endDttm;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getSysTypeCd()
    {
        return sysTypeCd;
    }
    public void setSysTypeCd(String sysTypeCd)
    {
        this.sysTypeCd = sysTypeCd;
    }
    public String getDfltLangCd() {
		return dfltLangCd;
	}
	public void setDfltLangCd(String dfltLangCd) {
		this.dfltLangCd = dfltLangCd;
	}
	public String getProductCd() {
		return productCd;
	}
	public void setProductCd(String productCd) {
		this.productCd = productCd;
	}
	public String getLayoutTplCd() {
		return layoutTplCd;
	}
	public void setLayoutTplCd(String layoutTplCd) {
		this.layoutTplCd = layoutTplCd;
	}
	public String getColorTplCd() {
		return colorTplCd;
	}
	public void setColorTplCd(String colorTplCd) {
		this.colorTplCd = colorTplCd;
	}
	public Integer getLimitNopCnt() {
		return limitNopCnt;
	}
	public void setLimitNopCnt(Integer limitNopCnt) {
		this.limitNopCnt = limitNopCnt;
	}
	public String getTplCd() {
		return tplCd;
	}
	public void setTplCd(String tplCd) {
		this.tplCd = tplCd;
	}
	public String getAutoMakeYn() {
		return autoMakeYn;
	}
	public void setAutoMakeYn(String autoMakeYn) {
		this.autoMakeYn = autoMakeYn;
	}
	public String getDurationYn() {
		return durationYn;
	}
	public void setDurationYn(String durationYn) {
		this.durationYn = durationYn;
	}
	public String getWwwFooter() {
		return wwwFooter;
	}
	public void setWwwFooter(String wwwFooter) {
		this.wwwFooter = wwwFooter;
	}
	public String getAdmFooter() {
		return admFooter;
	}
	public void setAdmFooter(String admFooter) {
		this.admFooter = admFooter;
	}
	public String getMenuVer() {
		return menuVer;
	}
	public void setMenuVer(String menuVer) {
		this.menuVer = menuVer;
	}
	public String getEmailAddr() {
		return emailAddr;
	}
	public void setEmailAddr(String emailAddr) {
		this.emailAddr = emailAddr;
	}
	public String getEmailNm() {
		return emailNm;
	}
	public void setEmailNm(String emailNm) {
		this.emailNm = emailNm;
	}
	public String getRprstPhoneNo() {
		return rprstPhoneNo;
	}
	public void setRprstPhoneNo(String rprstPhoneNo) {
		this.rprstPhoneNo = rprstPhoneNo;
	}
	public String getRprstDomain() {
		return rprstDomain;
	}
	public void setRprstDomain(String rprstDomain) {
		this.rprstDomain = rprstDomain;
	}
	public String getSubLogo1Url() {
		return subLogo1Url;
	}
	public void setSubLogo1Url(String subLogo1Url) {
		this.subLogo1Url = subLogo1Url;
	}
	public String getSubLogo2Url() {
		return subLogo2Url;
	}
	public void setSubLogo2Url(String subLogo2Url) {
		this.subLogo2Url = subLogo2Url;
	}
	public String getChrgPrsnInfo() {
		return chrgPrsnInfo;
	}
	public void setChrgPrsnInfo(String chrgPrsnInfo) {
		this.chrgPrsnInfo = chrgPrsnInfo;
	}
	public String getMbrIdType() {
		return mbrIdType;
	}
	public void setMbrIdType(String mbrIdType) {
		this.mbrIdType = mbrIdType;
	}
	public int getLogCnt() {
		return logCnt;
	}
	public void setLogCnt(int logCnt) {
		this.logCnt = logCnt;
	}
	public String getMbrAplcUseYn() {
		return mbrAplcUseYn;
	}
	public void setMbrAplcUseYn(String mbrAplcUseYn) {
		this.mbrAplcUseYn = mbrAplcUseYn;
	}
	public Integer getAplcSn() {
		return aplcSn;
	}
	public void setAplcSn(Integer aplcSn) {
		this.aplcSn = aplcSn;
	}
	public String getItgrtMbrUseYn() {
		return itgrtMbrUseYn;
	}
	public void setItgrtMbrUseYn(String itgrtMbrUseYn) {
		this.itgrtMbrUseYn = itgrtMbrUseYn;
	}
	public String[] getContextArr() {
		return contextArr;
	}
	public void setContextArr(String[] contextArr) {
		this.contextArr = contextArr;
	}
	public String getProductServiceType() {
		return productServiceType;
	}
	public void setProductServiceType(String productServiceType) {
		this.productServiceType = productServiceType;
	}
	public String getContextName() {
		return contextName;
	}
	public void setContextName(String contextName) {
		this.contextName = contextName;
	}
	public String getOrgDomain() {
		return orgDomain;
	}
	public void setOrgDomain(String orgDomain) {
		this.orgDomain = orgDomain;
	}
	
	public String getSiteUsageCd() {
		return siteUsageCd;
	}
	public void setSiteUsageCd(String siteUsageCd) {
		this.siteUsageCd = siteUsageCd;
	}
	public String getConAuthCd() {
		return conAuthCd;
	}
	public void setConAuthCd(String conAuthCd) {
		this.conAuthCd = conAuthCd;
	}
	/**
	 * @return the dbEncKey
	 */
	public String getDbEncKey() {
		return dbEncKey;
	}
	/**
	 * @param dbEncKey the dbEncKey to set
	 */
	public void setDbEncKey(String dbEncKey) {
		this.dbEncKey = dbEncKey;
	}
}
