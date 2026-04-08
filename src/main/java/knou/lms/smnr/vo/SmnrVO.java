package knou.lms.smnr.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

public class SmnrVO extends DefaultVO {

	private static final long serialVersionUID = -6172666110851636848L;

	// TB_LMS_SMNR ( 세미나 )
	private String  	smnrId;				// 세미나아이디
	private String  	lctrWknoSchdlId;    // 강의주차일정아이디
	private String  	smnrnm;             // 세미나명
	private String  	smnrCts;            // 세미나내용
	private String  	smnrTycd;           // 세미나유형코드
	private String  	smnrSdttm;          // 세미나시작일시
	private String  	smnrEdttm;          // 세미나종료일시
	private Integer 	smnrMnts;           // 세미나시간
	private String  	smnrGbncd;          // 세미나구분코드
	private String  	autoRcdyn;          // 자동기록여부
	private String  	delyn;              // 삭제여부
	private String  	upSmnrId;			// 상위세미나아이디
	private String  	evlScrTycd;			// 평가점수유형코드
	private String  	mrkRfltyn;          // 성적반영여부
	private BigDecimal 	mrkRfltrt;          // 성적반영비율
	private String  	mrkOyn;             // 성적공개여부
	private String  	byteamSubsmnrUseyn; // 팀별부세미나사용여부
	private String		atndRcdPfltyn;		// 참석기록반영여부

	public String getSmnrId() {
		return smnrId;
	}
	public String getLctrWknoSchdlId() {
		return lctrWknoSchdlId;
	}
	public String getSmnrnm() {
		return smnrnm;
	}
	public String getSmnrCts() {
		return smnrCts;
	}
	public String getSmnrTycd() {
		return smnrTycd;
	}
	public String getSmnrSdttm() {
		return smnrSdttm;
	}
	public String getSmnrEdttm() {
		return smnrEdttm;
	}
	public Integer getSmnrMnts() {
		return smnrMnts;
	}
	public String getSmnrGbncd() {
		return smnrGbncd;
	}
	public String getAutoRcdyn() {
		return autoRcdyn;
	}
	public String getDelyn() {
		return delyn;
	}
	public String getUpSmnrId() {
		return upSmnrId;
	}
	public String getEvlScrTycd() {
		return evlScrTycd;
	}
	public String getMrkRfltyn() {
		return mrkRfltyn;
	}
	public BigDecimal getMrkRfltrt() {
		return mrkRfltrt;
	}
	public String getMrkOyn() {
		return mrkOyn;
	}
	public String getByteamSubsmnrUseyn() {
		return byteamSubsmnrUseyn;
	}
	public String getAtndRcdPfltyn() {
		return atndRcdPfltyn;
	}
	public void setSmnrId(String smnrId) {
		this.smnrId = smnrId;
	}
	public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
		this.lctrWknoSchdlId = lctrWknoSchdlId;
	}
	public void setSmnrnm(String smnrnm) {
		this.smnrnm = smnrnm;
	}
	public void setSmnrCts(String smnrCts) {
		this.smnrCts = smnrCts;
	}
	public void setSmnrTycd(String smnrTycd) {
		this.smnrTycd = smnrTycd;
	}
	public void setSmnrSdttm(String smnrSdttm) {
		this.smnrSdttm = smnrSdttm;
	}
	public void setSmnrEdttm(String smnrEdttm) {
		this.smnrEdttm = smnrEdttm;
	}
	public void setSmnrMnts(Integer smnrMnts) {
		this.smnrMnts = smnrMnts;
	}
	public void setSmnrGbncd(String smnrGbncd) {
		this.smnrGbncd = smnrGbncd;
	}
	public void setAutoRcdyn(String autoRcdyn) {
		this.autoRcdyn = autoRcdyn;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}
	public void setUpSmnrId(String upSmnrId) {
		this.upSmnrId = upSmnrId;
	}
	public void setEvlScrTycd(String evlScrTycd) {
		this.evlScrTycd = evlScrTycd;
	}
	public void setMrkRfltyn(String mrkRfltyn) {
		this.mrkRfltyn = mrkRfltyn;
	}
	public void setMrkRfltrt(BigDecimal mrkRfltrt) {
		this.mrkRfltrt = mrkRfltrt;
	}
	public void setMrkOyn(String mrkOyn) {
		this.mrkOyn = mrkOyn;
	}
	public void setByteamSubsmnrUseyn(String byteamSubsmnrUseyn) {
		this.byteamSubsmnrUseyn = byteamSubsmnrUseyn;
	}
	public void setAtndRcdPfltyn(String atndRcdPfltyn) {
		this.atndRcdPfltyn = atndRcdPfltyn;
	}
}
