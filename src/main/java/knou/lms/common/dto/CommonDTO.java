package knou.lms.common.dto;

import java.util.List;

import knou.framework.context2.UserContext;

public class CommonDTO {
	
	/*
	 * public CommonDTO(UserContext userCtx) { this.userId =
	 * userCtx.getLoginUser().getUserId(); this.orgId =
	 * userCtx.getLoginUser().getOrgId(); }
	 */
	
	/*
	 * public CommonDTO(String userId, String sbjctId) { this.userId = userId;
	 * this.sbjctId = sbjctId; }
	 */
	
	public CommonDTO(UserContext userCtx) {
		this.setProfIds(userCtx.getProfIds());
		this.setStdntIds(userCtx.getStdntIds());
		this.userId = userCtx.getLoginUser().getUserId();
		this.orgId = userCtx.getLoginUser().getOrgId();
	}
	
	/*
	 * public CommonDTO(String userId, String sbjctId, int limitTop) { this.userId =
	 * userId; this.sbjctId = sbjctId; this.limitTop = limitTop; }
	 */
	
	/*
	 * public CommonDTO(UserContext userCtx, int limitTop) { this.userId =
	 * userCtx.getLoginUser().getUserId(); this.limitTop = limitTop; }
	 */
	
	public CommonDTO() {}
	
	//	기관
    String	orgId;
    String	orgnm;
    
    //	사용자
	String	userId;
	String	usernm;
	String	deptId;
	String	stdntNo;
	String	rprsId;
	
	//	교수 ids
	List<String> profIds;
	
	//	학생 ids
	List<String> stdntIds;
	
	//	학기기수
	String	smstrChrtId;
	String	dgrsYr;
	String	dgrsSmstrChrt;
	String	smstrChrtnm;
	String	yrSmstr; // 연도학기
	
	//	등록일
	String	fromRegDttm; 	//	등록일부터
	String	toRegDttm;		//	등록일까지
	
	String	searchFrom; 	//	등록일부터 	asis 호환을 위해
	String	searchTo;		//	등록일까지	asis 호환을 위해
	
	String	searchValue;	//	검색어	asis 호환을 위해
	String	searchText;		// 	검색어 	asis 호환을 위해
	
	int limitTop = 3 ; 		// default 3;
	
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getOrgnm() {
		return orgnm;
	}
	public void setOrgnm(String orgnm) {
		this.orgnm = orgnm;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUsernm() {
		return usernm;
	}
	public void setUsernm(String usernm) {
		this.usernm = usernm;
	}
	public String getDeptId() {
		return deptId;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public String getStdntNo() {
		return stdntNo;
	}
	public void setStdntNo(String stdntNo) {
		this.stdntNo = stdntNo;
	}
	public String getRprsId() {
		return rprsId;
	}
	public void setRprsId(String rprsId) {
		this.rprsId = rprsId;
	}
	public String getSmstrChrtId() {
		return smstrChrtId;
	}
	public void setSmstrChrtId(String smstrChrtId) {
		this.smstrChrtId = smstrChrtId;
	}
	public String getDgrsYr() {
		return dgrsYr;
	}
	public void setDgrsYr(String dgrsYr) {
		this.dgrsYr = dgrsYr;
	}
	public String getDgrsSmstrChrt() {
		return dgrsSmstrChrt;
	}
	public void setDgrsSmstrChrt(String dgrsSmstrChrt) {
		this.dgrsSmstrChrt = dgrsSmstrChrt;
	}
	public String getSmstrChrtnm() {
		return smstrChrtnm;
	}
	public void setSmstrChrtnm(String smstrChrtnm) {
		this.smstrChrtnm = smstrChrtnm;
	}
	public String getYrSmstr() {
		return yrSmstr;
	}
	public void setYrSmstr(String yrSmstr) {
		this.yrSmstr = yrSmstr;
	}
	public String getFromRegDttm() {
		return fromRegDttm;
	}
	public void setFromRegDttm(String fromRegDttm) {
		this.fromRegDttm = fromRegDttm;
	}
	public String getToRegDttm() {
		return toRegDttm;
	}
	public void setToRegDttm(String toRegDttm) {
		this.toRegDttm = toRegDttm;
	}
	public String getSearchFrom() {
		return searchFrom;
	}
	public void setSearchFrom(String searchFrom) {
		this.searchFrom = searchFrom;
	}
	public String getSearchTo() {
		return searchTo;
	}
	public int getLimitTop() {
		return limitTop;
	}
	public void setLimitTop(int limitTop) {
		this.limitTop = limitTop;
	}
	public void setSearchTo(String searchTo) {
		this.searchTo = searchTo;
	}
	public String getSearchValue() {
		return searchValue;
	}
	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}
	public String getSearchText() {
		return searchText;
	}
	public void setSearchText(String searchText) {
		this.searchText = searchText;
	}

	public List<String> getProfIds() {
		return profIds;
	}

	public void setProfIds(List<String> profIds) {
		this.profIds = profIds;
	}

	public List<String> getStdntIds() {
		return stdntIds;
	}

	public void setStdntIds(List<String> stdntIds) {
		this.stdntIds = stdntIds;
	}
}