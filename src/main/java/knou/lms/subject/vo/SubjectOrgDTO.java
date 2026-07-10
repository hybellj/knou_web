package knou.lms.subject.vo;

import java.util.List;

/**
 * 교수/학생 운영,수강 과목의 기관 정보 DTO
 */
public class SubjectOrgDTO {
	private String orgId;			// 기관아이디
	private String orgnm;			// 기관명
	private String userTycd;		// 사용자구분
	private String sbjctAdmTycd;	// 과목관리자유형코드
	private String userId;			// 사용자아이디
	private List<String> orgUserTycdList;	// 기관의 사용자구분 목록

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

	public String getUserTycd() {
		return userTycd;
	}

	public void setUserTycd(String userTycd) {
		this.userTycd = userTycd;
	}

	public String getSbjctAdmTycd() {
		return sbjctAdmTycd;
	}

	public void setSbjctAdmTycd(String sbjctAdmTycd) {
		this.sbjctAdmTycd = sbjctAdmTycd;
	}

	public List<String> getOrgUserTycdList() {
		return orgUserTycdList;
	}

	public void setOrgUserTycdList(List<String> orgUserTycdList) {
		this.orgUserTycdList = orgUserTycdList;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}


}
