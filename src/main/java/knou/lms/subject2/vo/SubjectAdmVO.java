package knou.lms.subject2.vo;

import java.io.Serializable;

public class SubjectAdmVO implements Serializable  {
	/** 과목관리 ID */
    private String sbjctAdmId;

    /** 과목개설 ID */
    private String subjectId;

    /** 사용자 ID */
    private String userId;

    public String getSbjctAdmId() {
		return sbjctAdmId;
	}

	public void setSbjctAdmId(String sbjctAdmId) {
		this.sbjctAdmId = sbjctAdmId;
	}

	public String getSbjctId() {
		return subjectId;
	}

	public void setSbjctId(String subjectId) {
		this.subjectId = subjectId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSbjctAdmTycd() {
		return sbjctAdmTycd;
	}

	public void setSbjctAdmTycd(String sbjctAdmTycd) {
		this.sbjctAdmTycd = sbjctAdmTycd;
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

	/** 과목관리 유형코드 */
    private String sbjctAdmTycd;

    /** 등록자 ID */
    private String rgtrId;

    /** 등록일시 */
    private String regDttm;

    /** 수정자 ID */
    private String mdfrId;

    /** 수정일시 */
    private String modDttm;
}
