package knou.lms.erp.vo;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

/**
 * SMS 관련 VO
 */
@Alias("alarmSmsVO")
public class AlarmSmsVO extends DefaultVO {
    private static final long serialVersionUID = 8687755537141287441L;
    private int rowNum;                         /* 일렬번호 */
    private String smsNo;                       /* SMS 번호 */
    private String smsSeq;                      /* SMS 순번 */
    private String userId;                      /* 사용자 번호 */
    private String userNm;                      /* 사용자 이름 */
    private String sysCd;                       /* 시스템 코드 */    
    private String orgId;                       /* 기관 코드 */ 
    private String bussGbn;                     /* 업무구분 */  
    private String sendRcvGbn;                  /* 수신 발신 구분 */
    private String subject;                     /* 제목 */
    private String ctnt;                        /* 내용 */
    private String sendDttm;                    /* 발송 일시 */     
    private String sndrPersNo;                  /* 발송자 개인번호 */
    private String sndrNm;                      /* 발송자명 */
    private String sndrDeptCd;                  /* 발송부서코드 */
    private String sndrDeptNm;                  /* 발송부서명 */
    private String sndrPhoneNo;                 /* 발송자 전화번호 */
    private String rcvNo;                       /* 수신자 번호 */
    private String rcvPhoneNo;                  /* 수신자 전화번호 */
    private String readYn;                      /* 읽기 여부 */
    private String delYn;                       /* 삭제 여부 */
    private String canYn;                       /* 발송취소 여부 */
    private int rcvNum;                         /* 수신자수 */
    private String rcvInfoStr;                  /* 수신자 기본정보 */
    private String delInfoStr;                  /* 삭제 정보 */
    private int sucessNum;                      /* 성공건수 */
    private String sendResult;                  /* 발송결과 */
    private String resultMsg;                   /* 결과 메세지 */
    private String sendCancelDttm;              /* 발송취소일시 */
    private String logDesc;                     /* 로그설명 */
    private String sendCancelYn;                /* 발송취소버튼유무 */
    private String sendReceive;                 /* 발송 또는 수신 */
    private String reservedDttm;                /* 수신일시 */
    private String SmsType;                     /* V : 상세조회 */
    private int smsTotCount;                    /* 전체 갯수 */
    private int smsReadCount;                   /* 읽은 갯수 */
    private int smsUnreadCount;                 /* 안읽은 갯수 */
    private int smsDeleteCount;                 /* 삭제한 갯수 */
    private int smsCancelCount;                 /* 발송 취소한 갯수 */       
    private String selfSndYn;                   /* 본인발송유무 */
    private int searchPeriodDays;               /* 검색기간날짜 */
    private String msgGbn = "S";                /* 메시지 구분 */
    private List<Map<String, String>> readList; /* 일기 데이터 */
    private String courseCd;                    // 과목코드
    private String menuId;                      // 메뉴ID
    private String smsSndType;                  //SMS 발신구분 C : 학과대표번호, P : 개인번호
    private String staffGbn;                    /* 1, 3 : 교수,  2 : 직원, 4 : 조교 */
    private String excelYn;                     /* excel 유무 */
    
    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public int getRowNum() {
        return rowNum;
    }
    
    public void setRowNum(int rowNum) {
        this.rowNum = rowNum;
    }

    public String getSmsNo() {
        return smsNo;
    }

    public void setSmsNo(String smsNo) {
        this.smsNo = smsNo;
    }

    public String getSmsSeq() {
        return smsSeq;
    }

    public void setSmsSeq(String smsSeq) {
        this.smsSeq = smsSeq;
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

    public String getSendRcvGbn() {
        return sendRcvGbn;
    }

    public void setSendRcvGbn(String sendRcvGbn) {
        this.sendRcvGbn = sendRcvGbn;
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

    public String getSndrNm() {
        return sndrNm;
    }

    public void setSndrNm(String sndrNm) {
        this.sndrNm = sndrNm;
    }

    public String getSndrDeptCd() {
        return sndrDeptCd;
    }

    public void setSndrDeptCd(String sndrDeptCd) {
        this.sndrDeptCd = sndrDeptCd;
    }

    public String getSndrDeptNm() {
        return sndrDeptNm;
    }

    public void setSndrDeptNm(String sndrDeptNm) {
        this.sndrDeptNm = sndrDeptNm;
    }

    public String getSndrPhoneNo() {
        return sndrPhoneNo;
    }

    public void setSndrPhoneNo(String sndrPhoneNo) {
        this.sndrPhoneNo = sndrPhoneNo;
    }

    public String getRcvNo() {
        return rcvNo;
    }

    public void setRcvNo(String rcvNo) {
        this.rcvNo = rcvNo;
    }
    
    public String getRcvPhoneNo() {
        return rcvPhoneNo;
    }

    public void setRcvPhoneNo(String rcvPhoneNo) {
        this.rcvPhoneNo = rcvPhoneNo;
    }

    public String getReadYn() {
        return readYn;
    }

    public void setReadYn(String readYn) {
        this.readYn = readYn;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getCanYn() {
        return canYn;
    }

    public void setCanYn(String canYn) {
        this.canYn = canYn;
    }

    public int getRcvNum() {
        return rcvNum;
    }

    public void setRcvNum(int rcvNum) {
        this.rcvNum = rcvNum;
    }

    public String getRcvInfoStr() {
        return rcvInfoStr;
    }

    public void setRcvInfoStr(String rcvInfoStr) {
        this.rcvInfoStr = rcvInfoStr;
    }

    public String getDelInfoStr() {
        return delInfoStr;
    }

    public void setDelInfoStr(String delInfoStr) {
        this.delInfoStr = delInfoStr;
    }

    public int getSucessNum() {
        return sucessNum;
    }

    public void setSucessNum(int sucessNum) {
        this.sucessNum = sucessNum;
    }

    public String getSendResult() {
        return sendResult;
    }

    public void setSendResult(String sendResult) {
        this.sendResult = sendResult;
    }

    public String getResultMsg() {
        return resultMsg;
    }

    public void setResultMsg(String resultMsg) {
        this.resultMsg = resultMsg;
    }

    public String getSendCancelDttm() {
        return sendCancelDttm;
    }

    public void setSendCancelDttm(String sendCancelDttm) {
        this.sendCancelDttm = sendCancelDttm;
    }

    public String getLogDesc() {
        return logDesc;
    }

    public void setLogDesc(String logDesc) {
        this.logDesc = logDesc;
    }

    public String getSendCancelYn() {
        return sendCancelYn;
    }

    public void setSendCancelYn(String sendCancelYn) {
        this.sendCancelYn = sendCancelYn;
    }

    public String getSendReceive() {
        return sendReceive;
    }

    public void setSendReceive(String sendReceive) {
        this.sendReceive = sendReceive;
    }

    public String getReservedDttm() {
        return reservedDttm;
    }

    public void setReservedDttm(String reservedDttm) {
        this.reservedDttm = reservedDttm;
    }

    public String getSmsType() {
        return SmsType;
    }

    public void setSmsType(String smsType) {
        SmsType = smsType;
    }

    public int getSmsTotCount() {
        return smsTotCount;
    }

    public void setSmsTotCount(int smsTotCount) {
        this.smsTotCount = smsTotCount;
    }

    public int getSmsReadCount() {
        return smsReadCount;
    }

    public void setSmsReadCount(int smsReadCount) {
        this.smsReadCount = smsReadCount;
    }

    public int getSmsUnreadCount() {
        return smsUnreadCount;
    }

    public void setSmsUnreadCount(int smsUnreadCount) {
        this.smsUnreadCount = smsUnreadCount;
    }

    public int getSmsDeleteCount() {
        return smsDeleteCount;
    }

    public void setSmsDeleteCount(int smsDeleteCount) {
        this.smsDeleteCount = smsDeleteCount;
    }

    public int getSmsCancelCount() {
        return smsCancelCount;
    }

    public void setSmsCancelCount(int smsCancelCount) {
        this.smsCancelCount = smsCancelCount;
    }

    public String getSelfSndYn() {
        return selfSndYn;
    }

    public void setSelfSndYn(String selfSndYn) {
        this.selfSndYn = selfSndYn;
    }

    public int getSearchPeriodDays() {
        return searchPeriodDays;
    }

    public void setSearchPeriodDays(int searchPeriodDays) {
        this.searchPeriodDays = searchPeriodDays;
    }

    public String getMsgGbn() {
        return msgGbn;
    }

    public void setMsgGbn(String msgGbn) {
        this.msgGbn = msgGbn;
    }

    public List<Map<String, String>> getReadList() {
        return readList;
    }

    public void setReadList(List<Map<String, String>> readList) {
        this.readList = readList;
    }

    public String getCourseCd() {
        return courseCd;
    }

    public void setCourseCd(String courseCd) {
        this.courseCd = courseCd;
    }

    public String getSmsSndType() {
        return smsSndType;
    }

    public void setSmsSndType(String smsSndType) {
        this.smsSndType = smsSndType;
    }

    public String getStaffGbn() {
        return staffGbn;
    }

    public void setStaffGbn(String staffGbn) {
        this.staffGbn = staffGbn;
    }

    public String getExcelYn() {
        return excelYn;
    }

    public void setExcelYn(String excelYn) {
        this.excelYn = excelYn;
    }

}
