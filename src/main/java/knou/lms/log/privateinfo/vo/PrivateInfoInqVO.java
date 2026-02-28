package knou.lms.log.privateinfo.vo;

import knou.lms.common.vo.DefaultVO;

public class PrivateInfoInqVO extends DefaultVO {

    private static final long serialVersionUID = -7176954069432986947L;
    /** tb_log_private_info_inq_log */
    private Integer inqLogSn;           // 개인정보조회 로그 고유번호
    private String  inqDttm;            // 조회 로그 일시
    private String  menuCd;             // 메뉴 코드
    private String  divCd;              // 구분 코드
    private String  userId;             // 사용자 번호
    private String  userNm;             // 사용자 이름
    private String  modChgUserId;       // 모드전환 사용자 번호
    private String  modChgUserNm;       // 모드전환 사용자 이름
    private String  inqCts;             // 조회 내용
    private String  connUrl;            // 연결 URL
    private String  connIp;             // 접속 IP
    
    public Integer getInqLogSn() {
        return inqLogSn;
    }
    public void setInqLogSn(Integer inqLogSn) {
        this.inqLogSn = inqLogSn;
    }
    public String getInqDttm() {
        return inqDttm;
    }
    public void setInqDttm(String inqDttm) {
        this.inqDttm = inqDttm;
    }
    public String getMenuCd() {
        return menuCd;
    }
    public void setMenuCd(String menuCd) {
        this.menuCd = menuCd;
    }
    public String getDivCd() {
        return divCd;
    }
    public void setDivCd(String divCd) {
        this.divCd = divCd;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    public String getModChgUserId() {
        return modChgUserId;
    }
    public void setModChgUserId(String modChgUserId) {
        this.modChgUserId = modChgUserId;
    }
    public String getModChgUserNm() {
        return modChgUserNm;
    }
    public void setModChgUserNm(String modChgUserNm) {
        this.modChgUserNm = modChgUserNm;
    }
    public String getInqCts() {
        return inqCts;
    }
    public void setInqCts(String inqCts) {
        this.inqCts = inqCts;
    }
    public String getConnUrl() {
        return connUrl;
    }
    public void setConnUrl(String connUrl) {
        this.connUrl = connUrl;
    }
    public String getConnIp() {
        return connIp;
    }
    public void setConnIp(String connIp) {
        this.connIp = connIp;
    }
    
}
