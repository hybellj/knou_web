package knou.lms.erp.vo;

import java.util.List;
import java.util.Map;

import knou.lms.common.vo.DefaultVO;
import knou.lms.user.vo.UsrUserInfoVO;

/**
 * 통합메시지 쪽지 VO
 */
public class ErpMessageMsgVO extends DefaultVO {
    private static final long serialVersionUID = 1858671632020309139L;
    private String msgNo;                       /* 쪽지 번호 */
    private String msgSeq;                      /* 쪽지 순번 */
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
    private String sndrDeptCd;                  /* 발송자 부서 코드 */
    private String sndrDeptNm;                  /* 발송부서명 */    
    private String sndrNm;                      /* 발송자명 */
    private String fileNo;                      /* 첨부파일 번호 */
    private String readYn;                      /* 읽기 여부 */
    private String readDttm;                    /* 수신 일시 */
    private String delYn;                       /* 삭제 여부 */
    private String canYn;                       /* 취소발송 여부 */
    private String logDesc;                     //로그설명 
    private String rcvInfoStr;                  //수신자 기본정보 
    private String delInfoStr;                  //삭제 정보     
    private String uploadFiles;                 //파일업로드정보
    private String sendCancelYn;                //발송취소버튼유무
    private int sucessNum;                      //성공건수 
    private String sendResult;                  //발송결과 
    private String sendCancelDttm;              //발송취소일시 
    private String sendReceive;                 //발송 또는 수신  또는 휴지통
    private int rowNum;                         //일렬번호 
    private int rcvNum;                         //수신자수
    private String fileYn;                      //첨부파일 유무
    private String sendReadDttm;                //보낸일시 또는 수신일시
    private String noteType;                    //V : 상세정보 조회 D : 발송 취소 조회 화면
    private int noteTotCount;                   /* 전체 갯수 */
    private int noteReadCount;                  /* 읽은 갯수 */
    private int noteUnreadCount;                /* 안읽은 갯수 */
    private int noteDeleteCount;                /* 삭제한 갯수 */
    private int noteCancelCount;                /* 발송 취소한 갯수 */              
    private String selfSndYn;                   /* 본인 발송 유무 */
    private int searchPeriodDays;               /* 검색기간날짜 */
    private String msgGbn = "N";                /* 메시지 구분 */
    private List<Map<String, String>> readList; /* 일기 데이터 */
    private String fileSaveNm;                  /* 파일 저장 명 */
    private String regIp;
    private String modIp;
    private String msgLogNo;
    private String courseCd;
    
    private List<UsrUserInfoVO> usrUserInfoList; // 수신자 목록 발송
    
    public String getMsgNo() {
        return msgNo;
    }

    public void setMsgNo(String msgNo) {
        this.msgNo = msgNo;
    }

    public String getMsgSeq() {
        return msgSeq;
    }

    public void setMsgSeq(String msgSeq) {
        this.msgSeq = msgSeq;
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

    public String getFileNo() {
        return fileNo;
    }

    public void setFileNo(String fileNo) {
        this.fileNo = fileNo;
    }

    public String getReadYn() {
        return readYn;
    }

    public void setReadYn(String readYn) {
        this.readYn = readYn;
    }

    public String getReadDttm() {
        return readDttm;
    }

    public void setReadDttm(String readDttm) {
        this.readDttm = readDttm;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getLogDesc() {
        return logDesc;
    }

    public void setLogDesc(String logDesc) {
        this.logDesc = logDesc;
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

    public String getUploadFiles() {
        return uploadFiles;
    }

    public void setUploadFiles(String uploadFiles) {
        this.uploadFiles = uploadFiles;
    }

    public String getSendCancelYn() {
        return sendCancelYn;
    }

    public void setSendCancelYn(String sendCancelYn) {
        this.sendCancelYn = sendCancelYn;
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

    public String getSendCancelDttm() {
        return sendCancelDttm;
    }

    public void setSendCancelDttm(String sendCancelDttm) {
        this.sendCancelDttm = sendCancelDttm;
    }

    public String getSendReceive() {
        return sendReceive;
    }

    public void setSendReceive(String sendReceive) {
        this.sendReceive = sendReceive;
    }

    public int getRowNum() {
        return rowNum;
    }

    public void setRowNum(int rowNum) {
        this.rowNum = rowNum;
    }

    public int getRcvNum() {
        return rcvNum;
    }

    public void setRcvNum(int rcvNum) {
        this.rcvNum = rcvNum;
    }

    public String getFileYn() {
        return fileYn;
    }

    public void setFileYn(String fileYn) {
        this.fileYn = fileYn;
    }

    public String getSendReadDttm() {
        return sendReadDttm;
    }

    public void setSendReadDttm(String sendReadDttm) {
        this.sendReadDttm = sendReadDttm;
    }

    public String getNoteType() {
        return noteType;
    }

    public void setNoteType(String noteType) {
        this.noteType = noteType;
    }

    public int getNoteTotCount() {
        return noteTotCount;
    }

    public void setNoteTotCount(int noteTotCount) {
        this.noteTotCount = noteTotCount;
    }

    public int getNoteReadCount() {
        return noteReadCount;
    }

    public void setNoteReadCount(int noteReadCount) {
        this.noteReadCount = noteReadCount;
    }

    public int getNoteUnreadCount() {
        return noteUnreadCount;
    }

    public void setNoteUnreadCount(int noteUnreadCount) {
        this.noteUnreadCount = noteUnreadCount;
    }

    public int getNoteDeleteCount() {
        return noteDeleteCount;
    }

    public void setNoteDeleteCount(int noteDeleteCount) {
        this.noteDeleteCount = noteDeleteCount;
    }

    public int getNoteCancelCount() {
        return noteCancelCount;
    }

    public void setNoteCancelCount(int noteCancelCount) {
        this.noteCancelCount = noteCancelCount;
    }

    public String getCanYn() {
        return canYn;
    }

    public void setCanYn(String canYn) {
        this.canYn = canYn;
    }

    public String getSndrDeptNm() {
        return sndrDeptNm;
    }

    public void setSndrDeptNm(String sndrDeptNm) {
        this.sndrDeptNm = sndrDeptNm;
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

    public String getFileSaveNm() {
        return fileSaveNm;
    }

    public void setFileSaveNm(String fileSaveNm) {
        this.fileSaveNm = fileSaveNm;
    }

    public String getRegIp() {
        return regIp;
    }

    public String getModIp() {
        return modIp;
    }

    public void setRegIp(String regIp) {
        this.regIp = regIp;
    }

    public void setModIp(String modIp) {
        this.modIp = modIp;
    }

    public String getMsgLogNo() {
        return msgLogNo;
    }

    public void setMsgLogNo(String msgLogNo) {
        this.msgLogNo = msgLogNo;
    }

    public String getCourseCd() {
        return courseCd;
    }

    public void setCourseCd(String courseCd) {
        this.courseCd = courseCd;
    }

    public List<UsrUserInfoVO> getUsrUserInfoList() {
        return usrUserInfoList;
    }

    public void setUsrUserInfoList(List<UsrUserInfoVO> usrUserInfoList) {
        this.usrUserInfoList = usrUserInfoList;
    }

	
}
