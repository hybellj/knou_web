package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvyVO extends DefaultVO {

	private static final long serialVersionUID = 2104210451561325970L;

	// TB_LMS_SRVY ( 설문 )
	private String  srvyId;					// 설문아이디
	private String  srvyGrpId;				// 설문그룹아이디
	private String  lctrWknoSchdlId;		// 강의주차일정아이디
	private String  upSrvyId;				// 상위설문아이디
	private String  srvyWrtTycd;			// 설문작성유형코드
	private String  srvyGbncd;				// 설문구분코드
	private String  srvyTycd;				// 설문유형코드
	private String  srvyTrgtGbncd;			// 설문대상구분코드
	private String  srvyTtl;				// 설문제목
	private String  srvyCts;				// 설문내용
	private String  srvyQstnsCmptnyn;		// 설문문제출제완료여부
	private String  rsltOpenTycd;			// 결과공개유형코드
	private String  dvclasRegyn;			// 분반등록여부
	private String  srvySdttm;				// 설문시작일시
	private String  srvyEdttm;				// 설문종료일시
	private String  evlScrTycd;				// 평가점수유형코드
	private String  useyn;					// 사용여부
	private String  delyn;					// 삭제여부
	private String  mrkRfltyn;				// 성적반영여부
	private Integer mrkRfltrt;				// 성적반영비율
	private String  mrkOyn;					// 성적공개여부
	private String  byteamSubsrvyUseyn;		// 팀별부설문사용여부

	public String getSrvyId() {
		return srvyId;
	}
	public String getSrvyGrpId() {
		return srvyGrpId;
	}
	public String getLctrWknoSchdlId() {
		return lctrWknoSchdlId;
	}
	public String getUpSrvyId() {
		return upSrvyId;
	}
	public String getSrvyWrtTycd() {
		return srvyWrtTycd;
	}
	public String getSrvyGbncd() {
		return srvyGbncd;
	}
	public String getSrvyTycd() {
		return srvyTycd;
	}
	public String getSrvyTrgtGbncd() {
		return srvyTrgtGbncd;
	}
	public String getSrvyTtl() {
		return srvyTtl;
	}
	public String getSrvyCts() {
		return srvyCts;
	}
	public String getSrvyQstnsCmptnyn() {
		return srvyQstnsCmptnyn;
	}
	public String getRsltOpenTycd() {
		return rsltOpenTycd;
	}
	public String getDvclasRegyn() {
		return dvclasRegyn;
	}
	public String getSrvySdttm() {
		return srvySdttm;
	}
	public String getSrvyEdttm() {
		return srvyEdttm;
	}
	public String getEvlScrTycd() {
		return evlScrTycd;
	}
	public String getUseyn() {
		return useyn;
	}
	public String getDelyn() {
		return delyn;
	}
	public String getMrkRfltyn() {
		return mrkRfltyn;
	}
	public Integer getMrkRfltrt() {
		return mrkRfltrt;
	}
	public String getMrkOyn() {
		return mrkOyn;
	}
	public String getByteamSubsrvyUseyn() {
		return byteamSubsrvyUseyn;
	}
	public void setSrvyId(String srvyId) {
		this.srvyId = srvyId;
	}
	public void setSrvyGrpId(String srvyGrpId) {
		this.srvyGrpId = srvyGrpId;
	}
	public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
		this.lctrWknoSchdlId = lctrWknoSchdlId;
	}
	public void setUpSrvyId(String upSrvyId) {
		this.upSrvyId = upSrvyId;
	}
	public void setSrvyWrtTycd(String srvyWrtTycd) {
		this.srvyWrtTycd = srvyWrtTycd;
	}
	public void setSrvyGbncd(String srvyGbncd) {
		this.srvyGbncd = srvyGbncd;
	}
	public void setSrvyTycd(String srvyTycd) {
		this.srvyTycd = srvyTycd;
	}
	public void setSrvyTrgtGbncd(String srvyTrgtGbncd) {
		this.srvyTrgtGbncd = srvyTrgtGbncd;
	}
	public void setSrvyTtl(String srvyTtl) {
		this.srvyTtl = srvyTtl;
	}
	public void setSrvyCts(String srvyCts) {
		this.srvyCts = srvyCts;
	}
	public void setSrvyQstnsCmptnyn(String srvyQstnsCmptnyn) {
		this.srvyQstnsCmptnyn = srvyQstnsCmptnyn;
	}
	public void setRsltOpenTycd(String rsltOpenTycd) {
		this.rsltOpenTycd = rsltOpenTycd;
	}
	public void setDvclasRegyn(String dvclasRegyn) {
		this.dvclasRegyn = dvclasRegyn;
	}
	public void setSrvySdttm(String srvySdttm) {
		this.srvySdttm = srvySdttm;
	}
	public void setSrvyEdttm(String srvyEdttm) {
		this.srvyEdttm = srvyEdttm;
	}
	public void setEvlScrTycd(String evlScrTycd) {
		this.evlScrTycd = evlScrTycd;
	}
	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}
	public void setMrkRfltyn(String mrkRfltyn) {
		this.mrkRfltyn = mrkRfltyn;
	}
	public void setMrkRfltrt(Integer mrkRfltrt) {
		this.mrkRfltrt = mrkRfltrt;
	}
	public void setMrkOyn(String mrkOyn) {
		this.mrkOyn = mrkOyn;
	}
	public void setByteamSubsrvyUseyn(String byteamSubsrvyUseyn) {
		this.byteamSubsrvyUseyn = byteamSubsrvyUseyn;
	}

}
