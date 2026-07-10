package knou.lms.log2.user.vo;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import knou.framework.common.SessionInfo;
import knou.framework.util.CommonUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.user.vo.UserVO;

// TB_LMS_LOG_USER_ACTV (로그 사용자활동)
public class LogUserActvVO extends DefaultVO {

    private static final long serialVersionUID = 9169428961607751473L;

    /**
     * 사용자활동ID
     */
    private String userActvId;

//    /** 사용자ID */
//    private String userId;
//
//    /** 교과목개설ID */
//    private String sbjctId;

    /**
     * 요청유형코드
     */
    private String reqTycd;

    /**
     * 사용자요청URL
     */
    private String userReqUrl;

    /**
     * 사용자요청메뉴
     */
    private String userReqMenu;

    /**
     * 사용자요청내용
     */
    private String userReqCts;

    /**
     * 사용자유형코드
     */
    private String userTycd;

    /**
     * 로그 기준 학기기수아이디
     */
    private String smstrChrtId;

    /**
     * 접속IP
     */
    private String cntnIp;

    /**
     * 접속기기유형코드
     */
    private String cntnDvcTycd;

    /**
     * 접속브라우저
     */
    private String cntnBrwsr;

    /**
     * 활동일시 (YYYYMMDDHH24MISS)
     */
    private String actvDttm;

    /**
     * 세션ID
     */
    private String sessId;

    /**
     * 세션시작일시 (YYYYMMDDHH24MISS)
     */
    private String sessSdttm;

    /**
     * 세션종료일시 (YYYYMMDDHH24MISS)
     */
    private String sessEdttm;

//    /** 등록자ID */
//    private String rgtrId;
//
//    /** 등록일시 (YYYYMMDDHH24MISS) */
//    private String regDttm;
//
//    /** 수정자ID */
//    private String mdfrId;
//
//    /** 수정일시 (YYYYMMDDHH24MISS) */
//    private String modDttm;

    private String traceId;

    private Date lgnDatetime;

    private String dayOfWeek;
    private String hourOfDay;

    private String naviPosnm; /* 내비게이션위치명 */

    public LogUserActvVO() {
    }

    public static LogUserActvVO createLogVO(String userActvId, UserVO loginUser, HttpServletRequest request, long start, long end, boolean success, Exception error) {
        return createLogVOOrigin(userActvId, loginUser, request);
    }

    public static LogUserActvVO createLogVOOrigin(String userActvId, UserVO loginUser, HttpServletRequest request) {

        LogUserActvVO vo = new LogUserActvVO();

        // 1. ID 생성 (IdGenUtil 활용)
        vo.userActvId = userActvId;

        // 2. 사용자 정보 매핑 (로그인하지 않은 경우 'GUEST' 처리) ---------------- 일단 저장프로세스만 만들고 정확한 설정은 업무를 만들면서 진행
        if(loginUser != null) {
//        	vo.userId = loginUser.getUserId();
            vo.setUserId(loginUser.getUserId());
//        	vo.sbjctId = request.getParameter("sbjctId");
            vo.setSbjctId(request.getParameter("sbjctId"));
            vo.setOrgId(loginUser.getOrgId());
            vo.setDeptId(loginUser.getDeptId());
            vo.setUserRprsId(loginUser.getUserRprsId());
            vo.userTycd = loginUser.getUserTycd();
//        	vo.rgtrId = loginUser.getUserId();
            vo.setRgtrId(loginUser.getUserId());
        } else {
//        	vo.userId = "GUEST";
            vo.setUserId("GUEST");
//        	vo.sbjctId = "";
            vo.setSbjctId("");
            vo.setOrgId("");
            vo.setDeptId("");
            vo.setUserRprsId("");
            vo.userTycd = "GUEST";
//        	vo.rgtrId = "SYSTEM";
            vo.setRgtrId("SYSTEM");
        }

        String smstrChrtId = request.getParameter("smstrChrtId");
        if(smstrChrtId == null || "".equals(smstrChrtId)) {
            smstrChrtId = SessionInfo.getCurTerm(request);
        }
        vo.setSmstrChrtId(smstrChrtId);

        vo.reqTycd = request.getMethod();
        vo.userReqUrl = request.getRequestURI();
        vo.userReqMenu = request.getRequestURI();
        vo.userReqCts = request.getRequestURI();
        vo.cntnIp = CommonUtil.getIpAddress(request);
        vo.cntnDvcTycd = CommonUtil.getDeviceType(request);
        vo.cntnBrwsr = CommonUtil.getBrowser(request);
        vo.sessId = request.getSession().getId();

        LocalDateTime now = LocalDateTime.now();

        vo.lgnDatetime = Timestamp.valueOf(now);
        vo.dayOfWeek = now.getDayOfWeek()
                .getDisplayName(java.time.format.TextStyle.FULL, Locale.KOREAN);
        vo.hourOfDay = String.format("%02d", now.getHour());

        HttpSession session = request.getSession(false);

        if(session != null) {
            long creationTime = session.getCreationTime();

            String sessionStartDttm = LocalDateTime.ofInstant(
                    Instant.ofEpochMilli(creationTime),
                    ZoneId.systemDefault()
            ).format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));

            vo.sessSdttm = sessionStartDttm;
        }

        return vo;
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

    public String getUserActvId() {
        return userActvId;
    }

    public void setUserActvId(String userActvId) {
        this.userActvId = userActvId;
    }

    public String getReqTycd() {
        return reqTycd;
    }

    public void setReqTycd(String reqTycd) {
        this.reqTycd = reqTycd;
    }

    public String getUserReqUrl() {
        return userReqUrl;
    }

    public void setUserReqUrl(String userReqUrl) {
        this.userReqUrl = userReqUrl;
    }

    public String getUserReqMenu() {
        return userReqMenu;
    }

    public void setUserReqMenu(String userReqMenu) {
        this.userReqMenu = userReqMenu;
    }

    public String getUserReqCts() {
        return userReqCts;
    }

    public void setUserReqCts(String userReqCts) {
        this.userReqCts = userReqCts;
    }

    public String getUserTycd() {
        return userTycd;
    }

    public void setUserTycd(String userTycd) {
        this.userTycd = userTycd;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getCntnIp() {
        return cntnIp;
    }

    public void setCntnIp(String cntnIp) {
        this.cntnIp = cntnIp;
    }

    public String getCntnDvcTycd() {
        return cntnDvcTycd;
    }

    public void setCntnDvcTycd(String cntnDvcTycd) {
        this.cntnDvcTycd = cntnDvcTycd;
    }

    public String getCntnBrwsr() {
        return cntnBrwsr;
    }

    public void setCntnBrwsr(String cntnBrwsr) {
        this.cntnBrwsr = cntnBrwsr;
    }

    public String getActvDttm() {
        return actvDttm;
    }

    public void setActvDttm(String actvDttm) {
        this.actvDttm = actvDttm;
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

    public String getNaviPosnm() {
        return naviPosnm;
    }

    public void setNaviPosnm(String naviPosnm) {
        this.naviPosnm = naviPosnm;
    }

    @Override
    public String toString() {
        return "LogUserActvVO{" +
                "userActvId='" + userActvId + '\'' +
//	            ", userId='" + userId + '\'' +
//	            ", sbjctId='" + sbjctId + '\'' +
                ", userId='" + getUserId() + '\'' +
                ", sbjctId='" + getSbjctId() + '\'' +
                ", reqTycd='" + reqTycd + '\'' +
                ", userReqUrl='" + userReqUrl + '\'' +
                ", userReqMenu='" + userReqMenu + '\'' +
                ", userReqCts='" + userReqCts + '\'' +
                ", userTycd='" + userTycd + '\'' +
                ", cntnIp='" + cntnIp + '\'' +
                ", cntnDvcTycd='" + cntnDvcTycd + '\'' +
                ", cntnBrwsr='" + cntnBrwsr + '\'' +
                ", actvDttm='" + actvDttm + '\'' +
                ", sessId='" + sessId + '\'' +
                ", sessSdttm='" + sessSdttm + '\'' +
                ", sessEdttm='" + sessEdttm + '\'' +
//	            ", rgtrId='" + rgtrId + '\'' +
//	            ", regDttm='" + regDttm + '\'' +
//	            ", mdfrId='" + mdfrId + '\'' +
//	            ", modDttm='" + modDttm + '\'' +
                ", rgtrId='" + getRgtrId() + '\'' +
                ", regDttm='" + getRegDttm() + '\'' +
                ", mdfrId='" + getMdfrId() + '\'' +
                ", modDttm='" + getModDttm() + '\'' +
                ", lgnDatetime=" + lgnDatetime +
                ", dayOfWeek='" + dayOfWeek + '\'' +
                ", hourOfDay='" + hourOfDay + '\'' +
                ", naviPosnm='" + naviPosnm + '\'' +
                '}';
    }
}
