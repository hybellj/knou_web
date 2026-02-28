package knou.lms.erp.vo;


import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

/**
 * SMS LOG 관련 VO
 */
@Alias("alarmSmsLogVO")
public class AlarmSmsLogVO extends DefaultVO {
    private static final long serialVersionUID = 8830185324748955749L;
    private String smsLogNo;        /* SMS 로그 번호 */
    private String smsNo;           /* SMS 번호 */
    private String logGbn;          /* 로그 구분 */
    private String userId;          /* 사용자 번호 */
    private String userNm;          /* 사용자 이름 */
    private String sysCd;           /* 시스템 코드 */    
    private String orgId;           /* 기관 코드 */ 
    private String bussGbn;         /* 업무구분 */  
    private String subject;         /* 제목 */
    private String ctnt;            /* 내용 */
    private String sendDttm;        /* 발송 일시 */     
    private String sndrPersNo;      /* 발송자 개인번호 */
    private String sndrDeptCd;      /* 발송자 부서 코드 */
    private String sndrNm;          /* 발송자명 */
    private String sndrPhoneNo;     /* 발송자 전화번호 */
    private int rcvNum;             /* 대상자 수 */
    private String logDesc;         /* 로그설명 */
    
    public String getSmsLogNo() {
        return smsLogNo;
    }

    public void setSmsLogNo(String smsLogNo) {
        this.smsLogNo = smsLogNo;
    }

    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public String getSysCd() {
        return sysCd;
    }
    
    public void setSysCd(String sysCd) {
        this.sysCd = sysCd;
    }
    
    public String getOrgId() {
        return orgId;
    }
    
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
    
    public String getBussGbn() {
        return bussGbn;
    }
    
    public void setBussGbn(String bussGbn) {
        this.bussGbn = bussGbn;
    }
    
    public String getSubject() {
        return subject;
    }
    
    public void setSubject(String subject) {
        this.subject = subject;
    }
    
    public String getCtnt() {
        return ctnt;
    }
    
    public void setCtnt(String ctnt) {
        this.ctnt = ctnt;
    }
    
    public String getSendDttm() {
        return sendDttm;
    }
    
    public void setSendDttm(String sendDttm) {
        this.sendDttm = sendDttm;
    }
    
    public String getSndrPersNo() {
        return sndrPersNo;
    }
    
    public void setSndrPersNo(String sndrPersNo) {
        this.sndrPersNo = sndrPersNo;
    }
    
    public String getSndrDeptCd() {
        return sndrDeptCd;
    }
    
    public void setSndrDeptCd(String sndrDeptCd) {
        this.sndrDeptCd = sndrDeptCd;
    }
    
    public String getSndrNm() {
        return sndrNm;
    }
    
    public void setSndrNm(String sndrNm) {
        this.sndrNm = sndrNm;
    }
    
    public String getSndrPhoneNo() {
        return sndrPhoneNo;
    }
    
    public void setSndrPhoneNo(String sndrPhoneNo) {
        this.sndrPhoneNo = sndrPhoneNo;
    }

    public String getSmsNo() {
        return smsNo;
    }

    public void setSmsNo(String smsNo) {
        this.smsNo = smsNo;
    }

    public String getLogGbn() {
        return logGbn;
    }

    public void setLogGbn(String logGbn) {
        this.logGbn = logGbn;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public int getRcvNum() {
        return rcvNum;
    }

    public void setRcvNum(int rcvNum) {
        this.rcvNum = rcvNum;
    }

    public String getLogDesc() {
        return logDesc;
    }

    public void setLogDesc(String logDesc) {
        this.logDesc = logDesc;
    }
    
	
}
