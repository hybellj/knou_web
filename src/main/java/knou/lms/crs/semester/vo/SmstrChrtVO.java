package knou.lms.crs.semester.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 학기기수
 * Table: TB_LMS_SMSTR_CHRT
 */
public class SmstrChrtVO extends DefaultVO {
	private static final long serialVersionUID = -5726381826420847999L;
	
	private String		smstrChrtId;			// 학기기수아이디
	
	private String		dgrsYr;					// 학위연도
	private String		dgrsSmstrChrt;			// 학위학기기수
	private String		smstrChrtnm;			// 학기기수명
	
	private String		smstrChrtGbncd;			// 학기기수구분코드
	private String		smstrChrtTycd;			// 학기기수유형코드
	private String		smstrChrtStscd;			// 학기기수상태코드
	
	private String		smstrChrtDataLnkgyn;	// 학기기수자료연계여부
	private String		oflnLrnMngyn;			// 오프라인학습관리여부
	
	private String		smstrChrtOpSdttm;		// 학기기수운영시작일시
	private String		smstrChrtOpEdttm;		// 학기기수운영종료일시
	
	private String		atndlcAplySdttm;		// 수강신청시작일시
	private String		atndlcAplyEdttm;		// 수강신청종료일시
	
	private String		atndlcModSdttm;			// 수강수정시작일시
	private String		atndlcModEdttm;			// 수강수정종료일시
	
	private String		atndlcSdttm;			// 수강시작일시
	private String		atndlcEdttm;			// 수강종료일시
	
	private String		mrkEvlSdttm;			// 성적평가시작일시
	private String		mrkEvlEdttm;			// 성적평가종료일시
	
	private String		mrkOpenSdttm;			// 성적공개시작일시
	private String		mrkOpenEdttm;			// 성적공개종료일시
	
	private String		mblAtndcUseyn;			// 모바일출석사용여부
	private String		nowSmstryn;				// 현재학기여부
	private String		rvwEdttm;				// 복습종료일시
	private String		profAccssPblSdttm;		// 교수접근가능시작일시

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

	public String getSmstrChrtGbncd() {
		return smstrChrtGbncd;
	}

	public void setSmstrChrtGbncd(String smstrChrtGbncd) {
		this.smstrChrtGbncd = smstrChrtGbncd;
	}

	public String getSmstrChrtTycd() {
		return smstrChrtTycd;
	}

	public void setSmstrChrtTycd(String smstrChrtTycd) {
		this.smstrChrtTycd = smstrChrtTycd;
	}

	public String getSmstrChrtStscd() {
		return smstrChrtStscd;
	}

	public void setSmstrChrtStscd(String smstrChrtStscd) {
		this.smstrChrtStscd = smstrChrtStscd;
	}

	public String getSmstrChrtDataLnkgyn() {
		return smstrChrtDataLnkgyn;
	}

	public void setSmstrChrtDataLnkgyn(String smstrChrtDataLnkgyn) {
		this.smstrChrtDataLnkgyn = smstrChrtDataLnkgyn;
	}

	public String getSmstrChrtnm() {
		return smstrChrtnm;
	}

	public void setSmstrChrtnm(String smstrChrtnm) {
		this.smstrChrtnm = smstrChrtnm;
	}

	public String getSmstrChrtOpSdttm() {
		return smstrChrtOpSdttm;
	}

	public void setSmstrChrtOpSdttm(String smstrChrtOpSdttm) {
		this.smstrChrtOpSdttm = smstrChrtOpSdttm;
	}

	public String getSmstrChrtOpEdttm() {
		return smstrChrtOpEdttm;
	}

	public void setSmstrChrtOpEdttm(String smstrChrtOpEdttm) {
		this.smstrChrtOpEdttm = smstrChrtOpEdttm;
	}

	public String getOflnLrnMngyn() {
		return oflnLrnMngyn;
	}

	public void setOflnLrnMngyn(String oflnLrnMngyn) {
		this.oflnLrnMngyn = oflnLrnMngyn;
	}

	public String getAtndlcAplySdttm() {
		return atndlcAplySdttm;
	}

	public void setAtndlcAplySdttm(String atndlcAplySdttm) {
		this.atndlcAplySdttm = atndlcAplySdttm;
	}

	public String getAtndlcAplyEdttm() {
		return atndlcAplyEdttm;
	}

	public void setAtndlcAplyEdttm(String atndlcAplyEdttm) {
		this.atndlcAplyEdttm = atndlcAplyEdttm;
	}

	public String getAtndlcModSdttm() {
		return atndlcModSdttm;
	}

	public void setAtndlcModSdttm(String atndlcModSdttm) {
		this.atndlcModSdttm = atndlcModSdttm;
	}

	public String getAtndlcModEdttm() {
		return atndlcModEdttm;
	}

	public void setAtndlcModEdttm(String atndlcModEdttm) {
		this.atndlcModEdttm = atndlcModEdttm;
	}

	public String getAtndlcSdttm() {
		return atndlcSdttm;
	}

	public void setAtndlcSdttm(String atndlcSdttm) {
		this.atndlcSdttm = atndlcSdttm;
	}

	public String getAtndlcEdttm() {
		return atndlcEdttm;
	}

	public void setAtndlcEdttm(String atndlcEdttm) {
		this.atndlcEdttm = atndlcEdttm;
	}

	public String getMrkEvlSdttm() {
		return mrkEvlSdttm;
	}

	public void setMrkEvlSdttm(String mrkEvlSdttm) {
		this.mrkEvlSdttm = mrkEvlSdttm;
	}

	public String getMrkEvlEdttm() {
		return mrkEvlEdttm;
	}

	public void setMrkEvlEdttm(String mrkEvlEdttm) {
		this.mrkEvlEdttm = mrkEvlEdttm;
	}

	public String getMrkOpenSdttm() {
		return mrkOpenSdttm;
	}

	public void setMrkOpenSdttm(String mrkOpenSdttm) {
		this.mrkOpenSdttm = mrkOpenSdttm;
	}

	public String getMrkOpenEdttm() {
		return mrkOpenEdttm;
	}

	public void setMrkOpenEdttm(String mrkOpenEdttm) {
		this.mrkOpenEdttm = mrkOpenEdttm;
	}

	public String getMblAtndcUseyn() {
		return mblAtndcUseyn;
	}

	public void setMblAtndcUseyn(String mblAtndcUseyn) {
		this.mblAtndcUseyn = mblAtndcUseyn;
	}

	public String getNowSmstryn() {
		return nowSmstryn;
	}

	public void setNowSmstryn(String nowSmstryn) {
		this.nowSmstryn = nowSmstryn;
	}

	public String getRvwEdttm() {
		return rvwEdttm;
	}

	public void setRvwEdttm(String rvwEdttm) {
		this.rvwEdttm = rvwEdttm;
	}

	public String getProfAccssPblSdttm() {
		return profAccssPblSdttm;
	}

	public void setProfAccssPblSdttm(String profAccssPblSdttm) {
		this.profAccssPblSdttm = profAccssPblSdttm;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
