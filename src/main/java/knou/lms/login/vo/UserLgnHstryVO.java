package knou.lms.login.vo;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import knou.framework.util.CommonUtil;
import knou.lms.login.param.LoginParam;

public class UserLgnHstryVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String userLgnHstryId;   // USER_LGN_HSTRY_ID
    private String userId;           // USER_ID
    private String userSnsId;        // USER_SNS_ID
    private String acsrTycd;         // ACSR_TYCD
    private String lgnIp;            // LGN_IP
    private String lgnDttm;          // LGN_DTTM
    private String lgtDttm;          // LGT_DTTM
    private String lgnScsyn;         // LGN_SCSYN
    private String cntnDvcTycd;      // CNTN_DVC_TYCD
    private String lgnCntnBrwsr;     // LGN_CNTN_BRWSR
    private String sessId;           // SESS_ID
    private String rgtrId;           // RGTR_ID
    private String regDttm;          // REG_DTTM
    private String mdfrId;           // MDFR_ID
    private String modDttm;          // MOD_DTTM
    private String orgId;            // ORG_ID
    private String deptId;           // DEPT_ID


    private Date lgnDatetime;
    private String dayOfWeek;
    private String hourOfDay;
    private String traceId;


    public UserLgnHstryVO() {
    }

    public String getTraceId() {
        return traceId;
    }

    public void setTraceId(String traceId) {
        this.traceId = traceId;
    }

    /**
     * 정적 팩토리 메서드: 로그인 이력 객체 생성
     *
     * @param hstryId - IdGenUtil을 통해 생성된 ID
     * @param user    - 세션의 사용자 정보
     * @param request - 접속 메타데이터 추출을 위한 HttpServletRequest
     * @return UserLgnHstryVO
     */
    public static UserLgnHstryVO create(String hstryId, LoginParam param, HttpServletRequest request) {

        UserLgnHstryVO vo = new UserLgnHstryVO();

        // 1. 필수 PK 및 세션 ID 세팅
        vo.setUserLgnHstryId(hstryId);
        vo.setSessId(request.getSession().getId());

        // 2. 사용자 정보 매핑 (NULL 방어)
        if(param != null) {
            vo.setUserId(param.getUserId());
            vo.setAcsrTycd("login"); // 사용자 유형 코드 = 접속자 유형 코드?
            vo.setRgtrId(param.getUserId());
            vo.setMdfrId(param.getUserId());
        } else {
            vo.setUserId("GUEST");
            vo.setAcsrTycd("GUEST");
            vo.setRgtrId("SYSTEM");
            vo.setMdfrId("SYSTEM");
        }

        // 3. 접속 환경 정보 추출 (CommonUtil 활용 권장)
        vo.setLgnIp(CommonUtil.getIpAddress(request));
        vo.setLgnCntnBrwsr(request.getHeader("User-Agent"));
        vo.cntnDvcTycd = CommonUtil.getDeviceType(request);

        // 4. 상태 및 시간 정보 (DB에서 처리하지 않을 경우 Java에서 세팅)
        vo.setLgnScsyn("Y"); // 로그인 성공 여부 기본값

        LocalDateTime now = LocalDateTime.now();

        vo.lgnDatetime = Timestamp.valueOf(now);
        vo.dayOfWeek = now.getDayOfWeek()
                .getDisplayName(java.time.format.TextStyle.FULL, Locale.KOREAN);
        vo.hourOfDay = String.format("%02d", now.getHour());

        return vo;
    }

    // Getter / Setter

    public String getUserLgnHstryId() {
        return userLgnHstryId;
    }

    public Date getLgnDatetime() {
        return lgnDatetime;
    }

    public void setLgnDateTime(Date lgnDatetime) {
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

    public void setUserLgnHstryId(String userLgnHstryId) {
        this.userLgnHstryId = userLgnHstryId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserSnsId() {
        return userSnsId;
    }

    public void setUserSnsId(String userSnsId) {
        this.userSnsId = userSnsId;
    }

    public String getAcsrTycd() {
        return acsrTycd;
    }

    public void setAcsrTycd(String acsrTycd) {
        this.acsrTycd = acsrTycd;
    }

    public String getLgnIp() {
        return lgnIp;
    }

    public void setLgnIp(String lgnIp) {
        this.lgnIp = lgnIp;
    }

    public String getLgnDttm() {
        return lgnDttm;
    }

    public void setLgnDttm(String lgnDttm) {
        this.lgnDttm = lgnDttm;
    }

    public String getLgtDttm() {
        return lgtDttm;
    }

    public void setLgtDttm(String lgtDttm) {
        this.lgtDttm = lgtDttm;
    }

    public String getLgnScsyn() {
        return lgnScsyn;
    }

    public void setLgnScsyn(String lgnScsyn) {
        this.lgnScsyn = lgnScsyn;
    }

    public String getCntnDvcTycd() {
        return cntnDvcTycd;
    }

    public void setCntnDvcTycd(String cntnDvcTycd) {
        this.cntnDvcTycd = cntnDvcTycd;
    }

    public String getLgnCntnBrwsr() {
        return lgnCntnBrwsr;
    }

    public void setLgnCntnBrwsr(String lgnCntnBrwsr) {
        this.lgnCntnBrwsr = lgnCntnBrwsr;
    }

    public String getSessId() {
        return sessId;
    }

    public void setSessId(String sessId) {
        this.sessId = sessId;
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

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    @Override
    public String toString() {
        return "UserLgnHstryVO{" +
                "userLgnHstryId='" + userLgnHstryId + '\'' +
                ", userId='" + userId + '\'' +
                ", userSnsId='" + userSnsId + '\'' +
                ", acsrTycd='" + acsrTycd + '\'' +
                ", lgnIp='" + lgnIp + '\'' +
                ", lgnDttm='" + lgnDttm + '\'' +
                ", lgtDttm='" + lgtDttm + '\'' +
                ", lgnScsyn='" + lgnScsyn + '\'' +
                ", cntnDvcTycd='" + cntnDvcTycd + '\'' +
                ", lgnCntnBrwsr='" + lgnCntnBrwsr + '\'' +
                ", sessId='" + sessId + '\'' +
                ", rgtrId='" + rgtrId + '\'' +
                ", regDttm='" + regDttm + '\'' +
                ", mdfrId='" + mdfrId + '\'' +
                ", modDttm='" + modDttm + '\'' +
                '}';
    }

    public void setLgnFailMsg(String message) {
        this.lgnFailMsg = message;
    }

    String lgnFailMsg;

    public String getLgnFailMsg() {
        return lgnFailMsg;
    }

    public void setLgnDatetime(Date lgnDatetime) {
        this.lgnDatetime = lgnDatetime;
    }
}