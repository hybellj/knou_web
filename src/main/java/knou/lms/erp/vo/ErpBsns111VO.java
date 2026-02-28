package knou.lms.erp.vo;

public class ErpBsns111VO {
    private String sendNo;           /* 발송번호 */
    private String sendSeq;          /* 발송순번 */
    private String recprPersNo;      /* 수신자개인번호 */
    private String recprNm;          /* 수신자명 */
    private String recprHandpNo;     /* 수신자휴대전화번호 */
    private String sendDttm;         /* 발송일시 */
    private String smsSendRsltCtnt;  /* sms발송결과내용 */
    private String pushSendRsltCtnt; /* push발송결과내용 */
    private String smsCtnt;          /* sms내용 */
    private String pushCtnt;         /* push내용 */
    private String inptId;           /* 입력id */
    private String inptDttm;         /* 입력일시 */
    private String inptIp;           /* 입력ip */
    private String inptMenuId;       /* 입력메뉴id */
    private String modId;            /* 수정id */
    private String modIp;            /* 수정ip */
    private String modMenuId;        /* 수정메뉴id */
    private int    refMsgIfId;       /* 참조메세지id */
    private String cfmYn;            /* 확인여부 */

    public String getSendNo() {
        return sendNo;
    }

    public void setSendNo(String sendNo) {
        this.sendNo = sendNo;
    }

    public String getSendSeq() {
        return sendSeq;
    }

    public void setSendSeq(String sendSeq) {
        this.sendSeq = sendSeq;
    }

    public String getRecprPersNo() {
        return recprPersNo;
    }

    public void setRecprPersNo(String recprPersNo) {
        this.recprPersNo = recprPersNo;
    }

    public String getRecprNm() {
        return recprNm;
    }

    public void setRecprNm(String recprNm) {
        this.recprNm = recprNm;
    }

    public String getRecprHandpNo() {
        return recprHandpNo;
    }

    public void setRecprHandpNo(String recprHandpNo) {
        this.recprHandpNo = recprHandpNo;
    }

    public String getSendDttm() {
        return sendDttm;
    }

    public void setSendDttm(String sendDttm) {
        this.sendDttm = sendDttm;
    }

    public String getSmsSendRsltCtnt() {
        return smsSendRsltCtnt;
    }

    public void setSmsSendRsltCtnt(String smsSendRsltCtnt) {
        this.smsSendRsltCtnt = smsSendRsltCtnt;
    }

    public String getPushSendRsltCtnt() {
        return pushSendRsltCtnt;
    }

    public void setPushSendRsltCtnt(String pushSendRsltCtnt) {
        this.pushSendRsltCtnt = pushSendRsltCtnt;
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

    public String getInptId() {
        return inptId;
    }

    public void setInptId(String inptId) {
        this.inptId = inptId;
    }

    public String getInptDttm() {
        return inptDttm;
    }

    public void setInptDttm(String inptDttm) {
        this.inptDttm = inptDttm;
    }

    public String getInptIp() {
        return inptIp;
    }

    public void setInptIp(String inptIp) {
        this.inptIp = inptIp;
    }

    public String getInptMenuId() {
        return inptMenuId;
    }

    public void setInptMenuId(String inptMenuId) {
        this.inptMenuId = inptMenuId;
    }

    public String getModId() {
        return modId;
    }

    public void setModId(String modId) {
        this.modId = modId;
    }

    public String getModIp() {
        return modIp;
    }

    public void setModIp(String modIp) {
        this.modIp = modIp;
    }

    public String getModMenuId() {
        return modMenuId;
    }

    public void setModMenuId(String modMenuId) {
        this.modMenuId = modMenuId;
    }

    public int getRefMsgIfId() {
        return refMsgIfId;
    }

    public void setRefMsgIfId(int refMsgIfId) {
        this.refMsgIfId = refMsgIfId;
    }

    public String getCfmYn() {
        return cfmYn;
    }

    public void setCfmYn(String cfmYn) {
        this.cfmYn = cfmYn;
    }
}
