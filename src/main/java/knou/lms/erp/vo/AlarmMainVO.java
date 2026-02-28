package knou.lms.erp.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

/**
 * 알림 화면 관련 VO
 */
@Alias("alarmMainVO")
public class AlarmMainVO extends DefaultVO {
    private static final long serialVersionUID = -3778243142654401244L;

    private String alarmType;
    private String alarmNo;
    private String alarmSeq;
    private String userId;
    private String userNm;
    private String userEmail;
    private String sysCd;
    private String orgId;
    private String bussGbn;
    private String deptCd;
    private String phoneOne;
    private String phoneTwo;
    private String rcvUserInfoStr;  //수신자번호;수신자명;수신자핸드폰번호;이메일주소|수신자번호;수신자명;수신자핸드폰번호;이메일주소|.....
    private String userGbn;
    private String sendReceive;
    private String selfSndYn;           //본인발송유무
    
    private String smsSndRcv;           //SMS 보냄받음
    private String pushSndRcv;          //PUSH 보냄받음
    private String emailSndRcv;         //EMAIL 보냄받음
    private String noteSndRcv;          //쪽지 보냄받음
            
    private String smsStartSendDttm;    //SMS 요청시작일자
    private String smsEndSendDttm;      //SMS 요청종료일자
    private String smsSrchGbn;          //SMS 검색조건 구분
    private String smsSrchWd;           //SMS 검색어
    private String smsDeptCd;           //SMS 로그인 부서코드
    private String smsDeptNm;           //SMS 로그인 부서이름
    private String smsBussGbn;          //SMS 업무구분
    private String smsSelfSndYn;        //SMS 본인발송 유무
    
    private String pushStartSendDttm;   //PUSH 요청시작일자
    private String pushEndSendDttm;     //PUSH 요청종료일자
    private String pushSrchGbn;         //PUSH 검색조건 구분
    private String pushSrchWd;          //PUSH 검색어
    private String pushDeptCd;          //PUSH 로그인 부서코드
    private String pushDeptNm;          //PUSH 로그인 부서이름
    private String pushBussGbn;         //PUSH 업무구분
    private String pushSelfSndYn;       //PUSH 본인발송 유무
    
    private String emailStartSendDttm;  //EMAIL 요청시작일자
    private String emailEndSendDttm;    //EMAIL 요청종료일자
    private String emailSrchGbn;        //EMAIL 검색조건 구분
    private String emailSrchWd;         //EMAIL 검색어
    private String emailDeptCd;         //EMAIL 로그인 부서코드
    private String emailDeptNm;         //EMAIL 로그인 부서이름
    private String emailBussGbn;        //EMAIL 업무구분
    private String emailSelfSndYn;      //EMAIL 본인발송 유무
    
    private String noteStartSendDttm;   //쪽지 요청시작일자
    private String noteEndSendDttm;     //쪽지 요청종료일자
    private String noteSrchGbn;         //쪽지 검색조건 구분
    private String noteSrchWd;          //쪽지 검색어
    private String noteDeptCd;          //쪽지 로그인 부서코드
    private String noteDeptNm;          //쪽지 로그인 부서이름
    private String noteBussGbn;         //쪽지 업무구분
    
    private String fileNo;              //파일번호
    private String smsSubject;
    private String pushSubject;
    private String emailSubject;
    private String subject;             //제목
    private String ctnt;                //내용
    private String smsCtnt;
    private String pushCtnt;
    private String emailCtnt;
    private String noteCtnt;
    private String sendDttm;            //발송일시
    private String sndrPersNo;          //발송자 개인번호
    private String sndrDeptCd;          //발송자 부서코드
    private String sndrNm;              //발송자명
    private String sndrEmailAddr;       //발송자 이메일 주소
    private String sndrPhoneNo;         //발송자 전화번호
    private String logDesc;             //로그설명
    private String rcvJsonData;         //수신 정보 (JSON)
    private String detialYn;            //상세정보 페이지 유무
    private int searchPeriodDays;       //검색기간날짜
    private String token;
    private String readJsonData;        //일기 정보 (JSON)
    private String courseCd;            //과목코드
    private String smsMenuId;           //SMS메뉴ID
    private String pushMenuId;          //PUSH메뉴ID
    private String emailMenuId;         //EMAIL메뉴ID
    private String popUpType;           //팝업타입
    private String staffGbn;            /* 1, 3 : 교수,  2 : 직원, 4 : 조교 */
    private int sendCnt;
    
    public String getPopUpType() {
        return popUpType;
    }

    public void setPopUpType(String popUpType) {
        this.popUpType = popUpType;
    }

    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getAlarmType() {
        return alarmType;
    }
    
    public void setAlarmType(String alarmType) {
        this.alarmType = alarmType;
    }
    
    public String getAlarmNo() {
        return alarmNo;
    }
    
    public void setAlarmNo(String alarmNo) {
        this.alarmNo = alarmNo;
    }
    
    public String getAlarmSeq() {
        return alarmSeq;
    }
    
    public void setAlarmSeq(String alarmSeq) {
        this.alarmSeq = alarmSeq;
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
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
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
    
    public String getDeptCd() {
        return deptCd;
    }
    
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }
    
    public String getPhoneOne() {
        return phoneOne;
    }
    
    public void setPhoneOne(String phoneOne) {
        this.phoneOne = phoneOne;
    }
    
    public String getPhoneTwo() {
        return phoneTwo;
    }
    
    public void setPhoneTwo(String phoneTwo) {
        this.phoneTwo = phoneTwo;
    }
    
    public String getRcvUserInfoStr() {
        return rcvUserInfoStr;
    }
    
    public void setRcvUserInfoStr(String rcvUserInfoStr) {
        this.rcvUserInfoStr = rcvUserInfoStr;
    }
    
    public String getUserGbn() {
        return userGbn;
    }
    
    public void setUserGbn(String userGbn) {
        this.userGbn = userGbn;
    }
    
    public String getSendReceive() {
        return sendReceive;
    }
    
    public void setSendReceive(String sendReceive) {
        this.sendReceive = sendReceive;
    }
    
    public String getSelfSndYn() {
        return selfSndYn;
    }
    
    public void setSelfSndYn(String selfSndYn) {
        this.selfSndYn = selfSndYn;
    }
    
    public String getSmsSndRcv() {
        return smsSndRcv;
    }
    
    public void setSmsSndRcv(String smsSndRcv) {
        this.smsSndRcv = smsSndRcv;
    }
    
    public String getPushSndRcv() {
        return pushSndRcv;
    }
    
    public void setPushSndRcv(String pushSndRcv) {
        this.pushSndRcv = pushSndRcv;
    }
    
    public String getEmailSndRcv() {
        return emailSndRcv;
    }
    
    public void setEmailSndRcv(String emailSndRcv) {
        this.emailSndRcv = emailSndRcv;
    }
    
    public String getNoteSndRcv() {
        return noteSndRcv;
    }
    
    public void setNoteSndRcv(String noteSndRcv) {
        this.noteSndRcv = noteSndRcv;
    }
    
    public String getSmsStartSendDttm() {
        return smsStartSendDttm;
    }
    
    public void setSmsStartSendDttm(String smsStartSendDttm) {
        this.smsStartSendDttm = smsStartSendDttm;
    }
    
    public String getSmsEndSendDttm() {
        return smsEndSendDttm;
    }
    
    public void setSmsEndSendDttm(String smsEndSendDttm) {
        this.smsEndSendDttm = smsEndSendDttm;
    }
    
    public String getSmsSrchGbn() {
        return smsSrchGbn;
    }
    
    public void setSmsSrchGbn(String smsSrchGbn) {
        this.smsSrchGbn = smsSrchGbn;
    }
    
    public String getSmsSrchWd() {
        return smsSrchWd;
    }
    
    public void setSmsSrchWd(String smsSrchWd) {
        this.smsSrchWd = smsSrchWd;
    }
    
    public String getSmsDeptCd() {
        return smsDeptCd;
    }
    
    public void setSmsDeptCd(String smsDeptCd) {
        this.smsDeptCd = smsDeptCd;
    }
    
    public String getSmsDeptNm() {
        return smsDeptNm;
    }
    
    public void setSmsDeptNm(String smsDeptNm) {
        this.smsDeptNm = smsDeptNm;
    }
    
    public String getPushStartSendDttm() {
        return pushStartSendDttm;
    }
    
    public void setPushStartSendDttm(String pushStartSendDttm) {
        this.pushStartSendDttm = pushStartSendDttm;
    }
    
    public String getPushEndSendDttm() {
        return pushEndSendDttm;
    }
    
    public void setPushEndSendDttm(String pushEndSendDttm) {
        this.pushEndSendDttm = pushEndSendDttm;
    }
    
    public String getPushSrchGbn() {
        return pushSrchGbn;
    }
    
    public void setPushSrchGbn(String pushSrchGbn) {
        this.pushSrchGbn = pushSrchGbn;
    }
    
    public String getPushSrchWd() {
        return pushSrchWd;
    }
    
    public void setPushSrchWd(String pushSrchWd) {
        this.pushSrchWd = pushSrchWd;
    }
    
    public String getPushDeptCd() {
        return pushDeptCd;
    }
    
    public void setPushDeptCd(String pushDeptCd) {
        this.pushDeptCd = pushDeptCd;
    }
    
    public String getPushDeptNm() {
        return pushDeptNm;
    }
    
    public void setPushDeptNm(String pushDeptNm) {
        this.pushDeptNm = pushDeptNm;
    }
    
    public String getEmailStartSendDttm() {
        return emailStartSendDttm;
    }
    
    public void setEmailStartSendDttm(String emailStartSendDttm) {
        this.emailStartSendDttm = emailStartSendDttm;
    }
    
    public String getEmailEndSendDttm() {
        return emailEndSendDttm;
    }
    
    public void setEmailEndSendDttm(String emailEndSendDttm) {
        this.emailEndSendDttm = emailEndSendDttm;
    }
    
    public String getEmailSrchGbn() {
        return emailSrchGbn;
    }
    
    public void setEmailSrchGbn(String emailSrchGbn) {
        this.emailSrchGbn = emailSrchGbn;
    }
    
    public String getEmailSrchWd() {
        return emailSrchWd;
    }
    
    public void setEmailSrchWd(String emailSrchWd) {
        this.emailSrchWd = emailSrchWd;
    }
    
    public String getEmailDeptCd() {
        return emailDeptCd;
    }
    
    public void setEmailDeptCd(String emailDeptCd) {
        this.emailDeptCd = emailDeptCd;
    }
    
    public String getEmailDeptNm() {
        return emailDeptNm;
    }
    
    public void setEmailDeptNm(String emailDeptNm) {
        this.emailDeptNm = emailDeptNm;
    }
    
    public String getNoteStartSendDttm() {
        return noteStartSendDttm;
    }
    
    public void setNoteStartSendDttm(String noteStartSendDttm) {
        this.noteStartSendDttm = noteStartSendDttm;
    }
    
    public String getNoteEndSendDttm() {
        return noteEndSendDttm;
    }
    
    public void setNoteEndSendDttm(String noteEndSendDttm) {
        this.noteEndSendDttm = noteEndSendDttm;
    }
    
    public String getNoteSrchGbn() {
        return noteSrchGbn;
    }
    
    public void setNoteSrchGbn(String noteSrchGbn) {
        this.noteSrchGbn = noteSrchGbn;
    }
    
    public String getNoteSrchWd() {
        return noteSrchWd;
    }
    
    public void setNoteSrchWd(String noteSrchWd) {
        this.noteSrchWd = noteSrchWd;
    }
    
    public String getNoteDeptCd() {
        return noteDeptCd;
    }
    
    public void setNoteDeptCd(String noteDeptCd) {
        this.noteDeptCd = noteDeptCd;
    }
    
    public String getNoteDeptNm() {
        return noteDeptNm;
    }
    
    public void setNoteDeptNm(String noteDeptNm) {
        this.noteDeptNm = noteDeptNm;
    }
    
    public String getFileNo() {
        return fileNo;
    }
    
    public void setFileNo(String fileNo) {
        this.fileNo = fileNo;
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
    
    public String getSndrEmailAddr() {
        return sndrEmailAddr;
    }
    
    public void setSndrEmailAddr(String sndrEmailAddr) {
        this.sndrEmailAddr = sndrEmailAddr;
    }
    
    public String getSndrPhoneNo() {
        return sndrPhoneNo;
    }
    
    public void setSndrPhoneNo(String sndrPhoneNo) {
        this.sndrPhoneNo = sndrPhoneNo;
    }
    
    public String getLogDesc() {
        return logDesc;
    }
    
    public void setLogDesc(String logDesc) {
        this.logDesc = logDesc;
    }
    
    public String getRcvJsonData() {
        return rcvJsonData;
    }
    
    public void setRcvJsonData(String rcvJsonData) {
        this.rcvJsonData = rcvJsonData;
    }
    
    public String getDetialYn() {
        return detialYn;
    }
    
    public void setDetialYn(String detialYn) {
        this.detialYn = detialYn;
    }
    
    public int getSearchPeriodDays() {
        return searchPeriodDays;
    }
    
    public void setSearchPeriodDays(int searchPeriodDays) {
        this.searchPeriodDays = searchPeriodDays;
    }
    
    public String getReadJsonData() {
        return readJsonData;
    }
    
    public void setReadJsonData(String readJsonData) {
        this.readJsonData = readJsonData;
    }

    public String getCourseCd() {
        return courseCd;
    }

    public void setCourseCd(String courseCd) {
        this.courseCd = courseCd;
    }

    public String getSmsMenuId() {
        return smsMenuId;
    }

    public void setSmsMenuId(String smsMenuId) {
        this.smsMenuId = smsMenuId;
    }

    public String getPushMenuId() {
        return pushMenuId;
    }

    public void setPushMenuId(String pushMenuId) {
        this.pushMenuId = pushMenuId;
    }

    public String getEmailMenuId() {
        return emailMenuId;
    }

    public void setEmailMenuId(String emailMenuId) {
        this.emailMenuId = emailMenuId;
    }

    public String getSmsSubject() {
        return smsSubject;
    }

    public void setSmsSubject(String smsSubject) {
        this.smsSubject = smsSubject;
    }

    public String getPushSubject() {
        return pushSubject;
    }

    public void setPushSubject(String pushSubject) {
        this.pushSubject = pushSubject;
    }

    public String getEmailSubject() {
        return emailSubject;
    }

    public void setEmailSubject(String emailSubject) {
        this.emailSubject = emailSubject;
    }

    public String getSmsCtnt() {
        return smsCtnt;
    }

    public void setSmsCtnt(String smsCtnt) {
        this.smsCtnt = smsCtnt;
    }

    public String getPushCtnt() {
        return pushCtnt;
    }

    public void setPushCtnt(String pushCtnt) {
        this.pushCtnt = pushCtnt;
    }

    public String getEmailCtnt() {
        return emailCtnt;
    }

    public void setEmailCtnt(String emailCtnt) {
        this.emailCtnt = emailCtnt;
    }

    public String getNoteCtnt() {
        return noteCtnt;
    }

    public void setNoteCtnt(String noteCtnt) {
        this.noteCtnt = noteCtnt;
    }

    public String getStaffGbn() {
        return staffGbn;
    }

    public void setStaffGbn(String staffGbn) {
        this.staffGbn = staffGbn;
    }

    public String getSmsBussGbn() {
        return smsBussGbn;
    }

    public void setSmsBussGbn(String smsBussGbn) {
        this.smsBussGbn = smsBussGbn;
    }

    public String getPushBussGbn() {
        return pushBussGbn;
    }

    public void setPushBussGbn(String pushBussGbn) {
        this.pushBussGbn = pushBussGbn;
    }

    public String getEmailBussGbn() {
        return emailBussGbn;
    }

    public void setEmailBussGbn(String emailBussGbn) {
        this.emailBussGbn = emailBussGbn;
    }

    public String getNoteBussGbn() {
        return noteBussGbn;
    }

    public void setNoteBussGbn(String noteBussGbn) {
        this.noteBussGbn = noteBussGbn;
    }

    public String getSmsSelfSndYn() {
        return smsSelfSndYn;
    }

    public void setSmsSelfSndYn(String smsSelfSndYn) {
        this.smsSelfSndYn = smsSelfSndYn;
    }

    public String getPushSelfSndYn() {
        return pushSelfSndYn;
    }

    public void setPushSelfSndYn(String pushSelfSndYn) {
        this.pushSelfSndYn = pushSelfSndYn;
    }

    public String getEmailSelfSndYn() {
        return emailSelfSndYn;
    }

    public void setEmailSelfSndYn(String emailSelfSndYn) {
        this.emailSelfSndYn = emailSelfSndYn;
    }

	public int getSendCnt() {
		return sendCnt;
	}

	public void setSendCnt(int sendCnt) {
		this.sendCnt = sendCnt;
	}


}
