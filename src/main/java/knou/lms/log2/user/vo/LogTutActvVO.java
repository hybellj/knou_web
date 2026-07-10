package knou.lms.log2.user.vo;

import java.util.Date;

public class LogTutActvVO {

    // 멤버 변수 (제시해주신 컬럼 순서)
    private String tutActvId;       // TUT_ACTV_ID (LogUserActvVO의 userActvId와 같이 사용)
    private String userId;          // USER_ID
    private String sessId;          // SESS_ID
    private String sessSdttm;       // SESS_SDTTM
    private String sessEdttm;       // SESS_EDTTM
    private String tutActvTycd;     // TUT_ACTV_TYCD
    private String tutActvDttm;     // TUT_ACTV_DTTM
    private String tutReqMenu;      // TUT_REQ_MENU
    private String tutReqUrl;       // TUT_REQ_URL
    private String tutReqCts;       // TUT_REQ_CTS
    private String tutReqTycd;      // TUT_REQ_TYCD
    private String tutCntnIp;       // TUT_CNTN_IP
    private String tutCntnDvcTycd;  // TUT_CNTN_DVC_TYCD
    private String tutCntnBrwsr;    // TUT_CNTN_BRWSR
    private String rgtrId;          // RGTR_ID
    private String regDttm;         // REG_DTTM
    private String mdfrId;          // MDFR_ID
    private String modDttm;         // MOD_DTTM
    private String sbjctId;         // SBJCT_ID
    
    private Date lgnDatetime;    
    private String dayOfWeek;
    private String hourOfDay;
    private String	traceId;

    /**
     * LogUserActvVO를 파라미터로 받아 모든 필드를 매핑하는 정적 팩토리 메서드
     */
    public static LogTutActvVO createLogVO(LogUserActvVO userActvVO) {
    	
        if (userActvVO == null) return null;

        LogTutActvVO tut = new LogTutActvVO();

        // 1. ID 로그 같이 사용 (동일 ID 매핑)
        tut.setTutActvId(userActvVO.getUserActvId());
        
        // 2. 기본 사용자 및 세션 정보
        tut.setUserId(userActvVO.getUserId());
        tut.setSessId(userActvVO.getSessId());
        tut.setSessSdttm(userActvVO.getSessSdttm());
        tut.setSessEdttm(userActvVO.getSessEdttm()); // 값이 있다면 매핑

        // 3. 활동 및 요청 정보 (이름 매칭 주의)
        tut.setTutActvTycd("TUT_ACTV");           // 기본값 세팅 (필요 시 수정)
        tut.setTutReqMenu(userActvVO.getUserReqMenu());
        tut.setTutReqUrl(userActvVO.getUserReqUrl());
        tut.setTutReqTycd(userActvVO.getReqTycd());   // GET, POST 등
        tut.setSbjctId(userActvVO.getSbjctId());
        
        // 4. 접속 환경 정보
        tut.setTutCntnIp(userActvVO.getCntnIp());
        tut.setTutCntnDvcTycd(userActvVO.getCntnDvcTycd());
        tut.setTutCntnBrwsr(userActvVO.getCntnBrwsr());

        // 5. 등록 및 수정 정보
        tut.setRgtrId(userActvVO.getRgtrId());
        tut.setMdfrId(userActvVO.getMdfrId());

        // 6. DB NOT NULL 방어 (빈 값일 경우 기본값 강제 할당)
        if (tut.getTutReqCts() == null) tut.setTutReqCts("-");
        
        tut.dayOfWeek = userActvVO.getDayOfWeek();
        tut.hourOfDay = userActvVO.getHourOfDay();
        tut.lgnDatetime = userActvVO.getLgnDatetime();
        tut.traceId = userActvVO.getTraceId();
        
        return tut;
    }  

	public String getTraceId() {
		return traceId;
	}

	public void setTraceId(String traceId) {
		this.traceId = traceId;
	}

	public Date getLgnDatetime() {
		return lgnDatetime;
	}

	public void setLgnDatetime(Date lgnDatetime) {
		this.lgnDatetime = lgnDatetime;
	}

	public String getDayOfWeek() {
		return dayOfWeek;
	}

	public void setDayOfWeek(String dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}

	public String getHourOfDay() {
		return hourOfDay;
	}

	public void setHourOfDay(String hourOfDay) {
		this.hourOfDay = hourOfDay;
	}

	public String getTutActvId() {
		return tutActvId;
	}

	public void setTutActvId(String tutActvId) {
		this.tutActvId = tutActvId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSessId() {
		return sessId;
	}

	public void setSessId(String sessId) {
		this.sessId = sessId;
	}

	public String getSessSdttm() {
		return sessSdttm;
	}

	public void setSessSdttm(String sessSdttm) {
		this.sessSdttm = sessSdttm;
	}

	public String getSessEdttm() {
		return sessEdttm;
	}

	public void setSessEdttm(String sessEdttm) {
		this.sessEdttm = sessEdttm;
	}

	public String getTutActvTycd() {
		return tutActvTycd;
	}

	public void setTutActvTycd(String tutActvTycd) {
		this.tutActvTycd = tutActvTycd;
	}

	public String getTutActvDttm() {
		return tutActvDttm;
	}

	public void setTutActvDttm(String tutActvDttm) {
		this.tutActvDttm = tutActvDttm;
	}

	public String getTutReqMenu() {
		return tutReqMenu;
	}

	public void setTutReqMenu(String tutReqMenu) {
		this.tutReqMenu = tutReqMenu;
	}

	public String getTutReqUrl() {
		return tutReqUrl;
	}

	public void setTutReqUrl(String tutReqUrl) {
		this.tutReqUrl = tutReqUrl;
	}

	public String getTutReqCts() {
		return tutReqCts;
	}

	public void setTutReqCts(String tutReqCts) {
		this.tutReqCts = tutReqCts;
	}

	public String getTutReqTycd() {
		return tutReqTycd;
	}

	public void setTutReqTycd(String tutReqTycd) {
		this.tutReqTycd = tutReqTycd;
	}

	public String getTutCntnIp() {
		return tutCntnIp;
	}

	public void setTutCntnIp(String tutCntnIp) {
		this.tutCntnIp = tutCntnIp;
	}

	public String getTutCntnDvcTycd() {
		return tutCntnDvcTycd;
	}

	public void setTutCntnDvcTycd(String tutCntnDvcTycd) {
		this.tutCntnDvcTycd = tutCntnDvcTycd;
	}

	public String getTutCntnBrwsr() {
		return tutCntnBrwsr;
	}

	public void setTutCntnBrwsr(String tutCntnBrwsr) {
		this.tutCntnBrwsr = tutCntnBrwsr;
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

	public String getSbjctId() {
		return sbjctId;
	}

	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
	}

}