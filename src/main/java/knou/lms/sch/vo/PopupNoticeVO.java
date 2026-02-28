package knou.lms.sch.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

/**
 * TB_LMS_POPUP_NTC (팝업공지)
 * TB_LMS_POPUP_NTC_PSTN_SIZE (팝업공지 위치크기)
 *
 */
@Alias("popupNoticeVO")
public class PopupNoticeVO extends DefaultVO {

    private static final long serialVersionUID = 982223308311754452L;

    private String  popupNtcId;		// 팝업공지 아이디 (구 popupNtcId)
    private String  popupNtcTtl;	// 팝업공지 제목 (구 noticeTitle)
    private String  popupNtcCts;	// 팝업공지 내용 (구 noticeCnts)
    private String  popupNtcTycd;	// 팝업공지유형 코드 (구 popTypeCd)
    private String  popupNtcTrgtCd;	// 팝업공지대상 코드(구 popTargetCd)
    private String[] popupNtcTrgtCdList; // 팝업공지 아이디 목록 (구 popTargetCdList)
    
    private String	popupNtcUrl;	// 팝업공지 url
    private String	popupNtcOpnrUrl;// 팝업공지오프너 url
    
    private String  popupNtcSdttm;	// 팝업공지 시작일시 (구 popStartDttm)
    private String  popupNtcEdttm;	// 팝업공지 종료일시 (구 popEndDttm)
    
    private Integer popupNtcTdstopDayCnt;	// 팝업공지 'N일동안 닫기' 일 수 (구 noMoreDay)
    private String  popupNtcTdstopUseyn;	// 팝업공지 '오늘은 그만보기' 사용여부 (구 noMoreDayUseYn)
    
    private String  sttyeduAtndlcTrgtyn;	// 법정교육 수강대상 여부 (구 legalStdOpenYn)
    private String  snglSessUseyn;			// 단독세션 사용여부(구 oneSessionYn)

    
    /* 팝업공지 위치 크기 관련 */
    private String  popupWinWdthsz;		// 팝업창 가로크기 (구 xSize)
    private String  popupWinHght;		// 팝업창 높이 (구 ySize)
    private String  popupWinWdthRatio;	// 팝업창 가로비율 (구 xPercent)
    private String  popupWinHghtRatio;	// 팝업창 세로비율 (구 xPercent)
    private String  popupWinXcrd;		// 팝업창 X좌표 (구 xPos)
    private String  popupWinYcrd;		// 팝업창 Y좌표 (구 yPos)
    
    private String  popupNtcIdList;		// 
    
    private String  useyn;			// 사용여부
    
    // 불필요시 삭제
    private String   lectEvalUrl;    // 강의평가 URL

	public String getPopupNtcId() {
		return popupNtcId;
	}

	public void setPopupNtcId(String popupNtcId) {
		this.popupNtcId = popupNtcId;
	}

	public String getPopupNtcTtl() {
		return popupNtcTtl;
	}

	public void setPopupNtcTtl(String popupNtcTtl) {
		this.popupNtcTtl = popupNtcTtl;
	}

	public String getPopupNtcCts() {
		return popupNtcCts;
	}

	public void setPopupNtcCts(String popupNtcCts) {
		this.popupNtcCts = popupNtcCts;
	}

	public String getPopupNtcTycd() {
		return popupNtcTycd;
	}

	public void setPopupNtcTycd(String popupNtcTycd) {
		this.popupNtcTycd = popupNtcTycd;
	}

	public String getPopupNtcTrgtCd() {
		return popupNtcTrgtCd;
	}

	public void setPopupNtcTrgtCd(String popupNtcTrgtCd) {
		this.popupNtcTrgtCd = popupNtcTrgtCd;
	}

	public String[] getPopupNtcTrgtCdList() {
		return popupNtcTrgtCdList;
	}

	public void setPopupNtcTrgtCdList(String[] popupNtcTrgtCdList) {
		this.popupNtcTrgtCdList = popupNtcTrgtCdList;
	}

	public String getPopupNtcUrl() {
		return popupNtcUrl;
	}

	public void setPopupNtcUrl(String popupNtcUrl) {
		this.popupNtcUrl = popupNtcUrl;
	}

	public String getPopupNtcOpnrUrl() {
		return popupNtcOpnrUrl;
	}

	public void setPopupNtcOpnrUrl(String popupNtcOpnrUrl) {
		this.popupNtcOpnrUrl = popupNtcOpnrUrl;
	}

	public String getPopupNtcSdttm() {
		return popupNtcSdttm;
	}

	public void setPopupNtcSdttm(String popupNtcSdttm) {
		this.popupNtcSdttm = popupNtcSdttm;
	}

	public String getPopupNtcEdttm() {
		return popupNtcEdttm;
	}

	public void setPopupNtcEdttm(String popupNtcEdttm) {
		this.popupNtcEdttm = popupNtcEdttm;
	}

	public Integer getPopupNtcTdstopDayCnt() {
		return popupNtcTdstopDayCnt;
	}

	public void setPopupNtcTdstopDayCnt(Integer popupNtcTdstopDayCnt) {
		this.popupNtcTdstopDayCnt = popupNtcTdstopDayCnt;
	}

	public String getPopupNtcTdstopUseyn() {
		return popupNtcTdstopUseyn;
	}

	public void setPopupNtcTdstopUseyn(String popupNtcTdstopUseyn) {
		this.popupNtcTdstopUseyn = popupNtcTdstopUseyn;
	}

	public String getSttyeduAtndlcTrgtyn() {
		return sttyeduAtndlcTrgtyn;
	}

	public void setSttyeduAtndlcTrgtyn(String sttyeduAtndlcTrgtyn) {
		this.sttyeduAtndlcTrgtyn = sttyeduAtndlcTrgtyn;
	}

	public String getSnglSessUseyn() {
		return snglSessUseyn;
	}

	public void setSnglSessUseyn(String snglSessUseyn) {
		this.snglSessUseyn = snglSessUseyn;
	}

	public String getPopupWinWdthsz() {
		return popupWinWdthsz;
	}

	public void setPopupWinWdthsz(String popupWinWdthsz) {
		this.popupWinWdthsz = popupWinWdthsz;
	}

	public String getPopupWinHght() {
		return popupWinHght;
	}

	public void setPopupWinHght(String popupWinHght) {
		this.popupWinHght = popupWinHght;
	}

	public String getPopupWinWdthRatio() {
		return popupWinWdthRatio;
	}

	public void setPopupWinWdthRatio(String popupWinWdthRatio) {
		this.popupWinWdthRatio = popupWinWdthRatio;
	}

	public String getPopupWinHghtRatio() {
		return popupWinHghtRatio;
	}

	public void setPopupWinHghtRatio(String popupWinHghtRatio) {
		this.popupWinHghtRatio = popupWinHghtRatio;
	}

	public String getPopupWinXcrd() {
		return popupWinXcrd;
	}

	public void setPopupWinXcrd(String popupWinXcrd) {
		this.popupWinXcrd = popupWinXcrd;
	}

	public String getPopupWinYcrd() {
		return popupWinYcrd;
	}

	public void setPopupWinYcrd(String popupWinYcrd) {
		this.popupWinYcrd = popupWinYcrd;
	}

	public String getUseyn() {
		return useyn;
	}

	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}

	public String getLectEvalUrl() {
		return lectEvalUrl;
	}

	public void setLectEvalUrl(String lectEvalUrl) {
		this.lectEvalUrl = lectEvalUrl;
	}

	public String getPopupNtcIdList() {
		return popupNtcIdList;
	}

	public void setPopupNtcIdList(String popupNtcIdList) {
		this.popupNtcIdList = popupNtcIdList;
	}
}