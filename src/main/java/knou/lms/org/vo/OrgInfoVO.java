package knou.lms.org.vo;

import knou.lms.common.vo.DefaultVO;

public class OrgInfoVO extends DefaultVO {
    private static final long serialVersionUID = 8475527214874530966L;

    private String orgBizNo;

    // 전체운영자 입력
    private String userPass;
    private String userPassConfirm;
    private String email;
    private String mobileNo;

    private Integer admCnt;
    
    // DB 스키마 리팩토링
    private String orgRgtrId;		// 기관 등록번호
    private String orgnm;			// 기관명
    private String orgShrtnm;		// 기관 약어명
    private String orgNcnm;			// 기관 별칭
    private String orgTycd;			// 기관 유형코드
    private String zipCd;			// 우편 번호
    private String addr1;			// 주소1
    private String addr2;			// 주소2
    private String dmnnm;			// 도메인명
    
    private String sdttm;			// 시작일시
    private String edttm;			// 종료일시
    
    private String bscLangCd;		// 기본언어코드
    private String ofcTelno;		// 사무실전화번호 
    private String rprsTelno;		// 대표전화번호
    private String chrgrnm;			// 담당자명
    private String chrgrCntct;		// 담당자연락처
    private String chargrEml;		// 담당자이메일
    
    private String mltLgnyn;		// 다중로그인여부
    private String pswdChgUseyn;	// 비밀번호변경 사용여부
    private Integer pswdUseDayCnt;	// 비밀번호 사용일수
    private String mbridTycd;		// 회원아이디 유형코드
    private String joinUseyn;		// 회원가입 사용여부
    private String siteUsgCd;		// 사이트 용도 코드
    
    private String cprghtCts;		// 저작권 내용
    
    private String hmpgUrl;			// 홈페이지 URL
    
    private String orgSysTycd;		//
    private String orgZip;
    private String orgAddr;
    private String useyn;
    
    
	public String getOrgBizNo() {
		return orgBizNo;
	}
	public void setOrgBizNo(String orgBizNo) {
		this.orgBizNo = orgBizNo;
	}
	public String getUserPass() {
		return userPass;
	}
	public void setUserPass(String userPass) {
		this.userPass = userPass;
	}
	public String getUserPassConfirm() {
		return userPassConfirm;
	}
	public void setUserPassConfirm(String userPassConfirm) {
		this.userPassConfirm = userPassConfirm;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMobileNo() {
		return mobileNo;
	}
	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}
	public Integer getAdmCnt() {
		return admCnt;
	}
	public void setAdmCnt(Integer admCnt) {
		this.admCnt = admCnt;
	}
	public String getOrgRgtrId() {
		return orgRgtrId;
	}
	public void setOrgRgtrId(String orgRgtrId) {
		this.orgRgtrId = orgRgtrId;
	}
	public String getOrgnm() {
		return orgnm;
	}
	public void setOrgnm(String orgnm) {
		this.orgnm = orgnm;
	}
	public String getOrgShrtnm() {
		return orgShrtnm;
	}
	public void setOrgShrtnm(String orgShrtnm) {
		this.orgShrtnm = orgShrtnm;
	}
	public String getOrgNcnm() {
		return orgNcnm;
	}
	public void setOrgNcnm(String orgNcnm) {
		this.orgNcnm = orgNcnm;
	}
	public String getOrgTycd() {
		return orgTycd;
	}
	public void setOrgTycd(String orgTycd) {
		this.orgTycd = orgTycd;
	}
	public String getZipCd() {
		return zipCd;
	}
	public void setZipCd(String zipCd) {
		this.zipCd = zipCd;
	}
	public String getAddr1() {
		return addr1;
	}
	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
	public String getDmnnm() {
		return dmnnm;
	}
	public void setDmnnm(String dmnnm) {
		this.dmnnm = dmnnm;
	}
	public String getSdttm() {
		return sdttm;
	}
	public void setSdttm(String sdttm) {
		this.sdttm = sdttm;
	}
	public String getEdttm() {
		return edttm;
	}
	public void setEdttm(String edttm) {
		this.edttm = edttm;
	}
	public String getBscLangCd() {
		return bscLangCd;
	}
	public void setBscLangCd(String bscLangCd) {
		this.bscLangCd = bscLangCd;
	}
	public String getOfcTelno() {
		return ofcTelno;
	}
	public void setOfcTelno(String ofcTelno) {
		this.ofcTelno = ofcTelno;
	}
	public String getRprsTelno() {
		return rprsTelno;
	}
	public void setRprsTelno(String rprsTelno) {
		this.rprsTelno = rprsTelno;
	}
	public String getChrgrnm() {
		return chrgrnm;
	}
	public void setChrgrnm(String chrgrnm) {
		this.chrgrnm = chrgrnm;
	}
	public String getChrgrCntct() {
		return chrgrCntct;
	}
	public void setChrgrCntct(String chrgrCntct) {
		this.chrgrCntct = chrgrCntct;
	}
	public String getChargrEml() {
		return chargrEml;
	}
	public void setChargrEml(String chargrEml) {
		this.chargrEml = chargrEml;
	}
	public String getMltLgnyn() {
		return mltLgnyn;
	}
	public void setMltLgnyn(String mltLgnyn) {
		this.mltLgnyn = mltLgnyn;
	}
	public String getPswdChgUseyn() {
		return pswdChgUseyn;
	}
	public void setPswdChgUseyn(String pswdChgUseyn) {
		this.pswdChgUseyn = pswdChgUseyn;
	}
	public Integer getPswdUseDayCnt() {
		return pswdUseDayCnt;
	}
	public void setPswdUseDayCnt(Integer pswdUseDayCnt) {
		this.pswdUseDayCnt = pswdUseDayCnt;
	}
	public String getMbridTycd() {
		return mbridTycd;
	}
	public void setMbridTycd(String mbridTycd) {
		this.mbridTycd = mbridTycd;
	}
	public String getJoinUseyn() {
		return joinUseyn;
	}
	public void setJoinUseyn(String joinUseyn) {
		this.joinUseyn = joinUseyn;
	}
	public String getSiteUsgCd() {
		return siteUsgCd;
	}
	public void setSiteUsgCd(String siteUsgCd) {
		this.siteUsgCd = siteUsgCd;
	}
	public String getCprghtCts() {
		return cprghtCts;
	}
	public void setCprghtCts(String cprghtCts) {
		this.cprghtCts = cprghtCts;
	}
	public String getHmpgUrl() {
		return hmpgUrl;
	}
	public void setHmpgUrl(String hmpgUrl) {
		this.hmpgUrl = hmpgUrl;
	}
	public String getOrgSysTycd() {
		return orgSysTycd;
	}
	public void setOrgSysTycd(String orgSysTycd) {
		this.orgSysTycd = orgSysTycd;
	}
	public String getOrgZip() {
		return orgZip;
	}
	public void setOrgZip(String orgZip) {
		this.orgZip = orgZip;
	}
	public String getOrgAddr() {
		return orgAddr;
	}
	public void setOrgAddr(String orgAddr) {
		this.orgAddr = orgAddr;
	}
	public String getUseyn() {
		return useyn;
	}
	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}
    
}