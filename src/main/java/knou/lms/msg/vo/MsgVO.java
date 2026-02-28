package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 메시지 알림 VO
 */
public class MsgVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    // 조회 조건
    private String userId;          // 수신자 아이디 (로그인 사용자)
    private String sndngTycd;        // 알림 유형 코드 (PUSH, SMS, SHRTNT, ALIM_TALK)
    private int listCnt = 5;        // 조회 건수 (기본 5건)

    // TB_LMS_MSG 테이블 필드
    private String msgId;              // 메시지아이디 (PK)
    private String sbjctOfrngId;       // 과목개설아이디
    private String msgTmpltId;         // 메시지템플릿아이디
    private String msgTycd;            // 메시지유형코드
    private String msgCtsGbncd;        // 메시지내용구분코드
    private String dgrsYr;             // 학위연도
    private String smstr;              // 학기
    private String ttl;                // 제목
    private String txtCts;             // 텍스트내용
    private String htmlCts;            // HTML내용
    private String sndngOnlyyn;        // 발신전용여부
    private String msgTagnm;           // 메시지태그명
    private String reqSdttm;           // 요청시작일시
    private String reqEdttm;           // 요청종료일시
    private String rsrvSndngSdttm;     // 예약발신시작일시
    private String rsrvSndngCnclDttm;  // 예약발신취소일시
    private String rsrvSndngCnclRsn;   // 예약발신취소사유
    private Integer sndngRetryMaxCnt;  // 발신재시도최대수
    private String rgtrId;             // 등록자아이디
    private String regDttm;            // 등록일시
    private String mdfrId;             // 수정자아이디
    private String modDttm;            // 수정일시

    // 발신 공통 필드 (발신 테이블)
    private String sndngId;         // 발신 아이디
    private String sndngrId;        // 발신자 아이디
    private String sndngnm;         // 발신자명
    private String sndngTtl;        // 발신 제목
    private String sndngCts;        // 발신 내용
    private String sndngDttm;       // 발신 일시
    private String sndngDttmFmt;    // 발신 일시 (포맷팅)
    private String readDttm;        // 열람 일시
    private String readYn;          // 읽음 여부 (Y/N)

    // 과목 정보 (V_MSG_NOTI_UNIFIED 뷰에서 조인)
    private String sbjctnm;         // 과목명

    // 발신 유형별 건수
    private int pushCnt;            // PUSH 읽지않은 건수
    private int smsCnt;             // SMS 읽지않은 건수
    private int shrtntCnt;          // 쪽지 읽지않은 건수
    private int alimtalkCnt;        // 알림톡 읽지않은 건수
    private int totalUnreadCnt;     // 전체 읽지않은 건수

    // Getters and Setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getSndngTycd() {
        return sndngTycd;
    }

    public void setSndngTycd(String sndngTycd) {
        this.sndngTycd = sndngTycd;
    }

    public int getListCnt() {
        return listCnt;
    }

    public void setListCnt(int listCnt) {
        this.listCnt = listCnt;
    }

    public String getMsgId() {
        return msgId;
    }

    public void setMsgId(String msgId) {
        this.msgId = msgId;
    }

    public String getSndngId() {
        return sndngId;
    }

    public void setSndngId(String sndngId) {
        this.sndngId = sndngId;
    }

    public String getSndngrId() {
        return sndngrId;
    }

    public void setSndngrId(String sndngrId) {
        this.sndngrId = sndngrId;
    }

    public String getSndngnm() {
        return sndngnm;
    }

    public void setSndngnm(String sndngnm) {
        this.sndngnm = sndngnm;
    }

    public String getSndngTtl() {
        return sndngTtl;
    }

    public void setSndngTtl(String sndngTtl) {
        this.sndngTtl = sndngTtl;
    }

    public String getSndngCts() {
        return sndngCts;
    }

    public void setSndngCts(String sndngCts) {
        this.sndngCts = sndngCts;
    }

    public String getSndngDttm() {
        return sndngDttm;
    }

    public void setSndngDttm(String sndngDttm) {
        this.sndngDttm = sndngDttm;
    }

    public String getSndngDttmFmt() {
        return sndngDttmFmt;
    }

    public void setSndngDttmFmt(String sndngDttmFmt) {
        this.sndngDttmFmt = sndngDttmFmt;
    }

    public String getReadDttm() {
        return readDttm;
    }

    public void setReadDttm(String readDttm) {
        this.readDttm = readDttm;
    }

    public String getReadYn() {
        return readYn;
    }

    public void setReadYn(String readYn) {
        this.readYn = readYn;
    }

    public int getPushCnt() {
        return pushCnt;
    }

    public void setPushCnt(int pushCnt) {
        this.pushCnt = pushCnt;
    }

    public int getSmsCnt() {
        return smsCnt;
    }

    public void setSmsCnt(int smsCnt) {
        this.smsCnt = smsCnt;
    }

    public int getShrtntCnt() {
        return shrtntCnt;
    }

    public void setShrtntCnt(int shrtntCnt) {
        this.shrtntCnt = shrtntCnt;
    }

    public int getAlimtalkCnt() {
        return alimtalkCnt;
    }

    public void setAlimtalkCnt(int alimtalkCnt) {
        this.alimtalkCnt = alimtalkCnt;
    }

    public int getTotalUnreadCnt() {
        return totalUnreadCnt;
    }

    public void setTotalUnreadCnt(int totalUnreadCnt) {
        this.totalUnreadCnt = totalUnreadCnt;
    }

    // TB_LMS_MSG 테이블 필드 Getters and Setters
    public String getSbjctOfrngId() {
        return sbjctOfrngId;
    }

    public void setSbjctOfrngId(String sbjctOfrngId) {
        this.sbjctOfrngId = sbjctOfrngId;
    }

    public String getMsgTmpltId() {
        return msgTmpltId;
    }

    public void setMsgTmpltId(String msgTmpltId) {
        this.msgTmpltId = msgTmpltId;
    }

    public String getMsgTycd() {
        return msgTycd;
    }

    public void setMsgTycd(String msgTycd) {
        this.msgTycd = msgTycd;
    }

    public String getMsgCtsGbncd() {
        return msgCtsGbncd;
    }

    public void setMsgCtsGbncd(String msgCtsGbncd) {
        this.msgCtsGbncd = msgCtsGbncd;
    }

    public String getDgrsYr() {
        return dgrsYr;
    }

    public void setDgrsYr(String dgrsYr) {
        this.dgrsYr = dgrsYr;
    }

    public String getSmstr() {
        return smstr;
    }

    public void setSmstr(String smstr) {
        this.smstr = smstr;
    }

    public String getTtl() {
        return ttl;
    }

    public void setTtl(String ttl) {
        this.ttl = ttl;
    }

    public String getTxtCts() {
        return txtCts;
    }

    public void setTxtCts(String txtCts) {
        this.txtCts = txtCts;
    }

    public String getHtmlCts() {
        return htmlCts;
    }

    public void setHtmlCts(String htmlCts) {
        this.htmlCts = htmlCts;
    }

    public String getSndngOnlyyn() {
        return sndngOnlyyn;
    }

    public void setSndngOnlyyn(String sndngOnlyyn) {
        this.sndngOnlyyn = sndngOnlyyn;
    }

    public String getMsgTagnm() {
        return msgTagnm;
    }

    public void setMsgTagnm(String msgTagnm) {
        this.msgTagnm = msgTagnm;
    }

    public String getReqSdttm() {
        return reqSdttm;
    }

    public void setReqSdttm(String reqSdttm) {
        this.reqSdttm = reqSdttm;
    }

    public String getReqEdttm() {
        return reqEdttm;
    }

    public void setReqEdttm(String reqEdttm) {
        this.reqEdttm = reqEdttm;
    }

    public String getRsrvSndngSdttm() {
        return rsrvSndngSdttm;
    }

    public void setRsrvSndngSdttm(String rsrvSndngSdttm) {
        this.rsrvSndngSdttm = rsrvSndngSdttm;
    }

    public String getRsrvSndngCnclDttm() {
        return rsrvSndngCnclDttm;
    }

    public void setRsrvSndngCnclDttm(String rsrvSndngCnclDttm) {
        this.rsrvSndngCnclDttm = rsrvSndngCnclDttm;
    }

    public String getRsrvSndngCnclRsn() {
        return rsrvSndngCnclRsn;
    }

    public void setRsrvSndngCnclRsn(String rsrvSndngCnclRsn) {
        this.rsrvSndngCnclRsn = rsrvSndngCnclRsn;
    }

    public Integer getSndngRetryMaxCnt() {
        return sndngRetryMaxCnt;
    }

    public void setSndngRetryMaxCnt(Integer sndngRetryMaxCnt) {
        this.sndngRetryMaxCnt = sndngRetryMaxCnt;
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

    public String getSbjctnm() {
        return sbjctnm;
    }

    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }
}