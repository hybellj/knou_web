package knou.lms.log.haksa.vo;

public class AisLinkLogVO {

    private String orgId;            // 기관 ID (AIS_LINK_ID 조회용)
    private String aisLinkTycd;      // 학사정보시스템연동유형코드 (AIS_LINK_ID 조회용)
    private boolean success;         // 연동 성공 여부 (RSLT_CD/AIS_LINK_SCSYN 산출용)
    private int addCnt;              // 신규 건수 (ADDCNT)
    private int modCnt;              // 수정 건수 (MODCNT)
    private int delCnt;              // 삭제 건수 (DELCNT)
    private String rgtrId;           // 등록자 ID

    private String logAisLinkId;     // 로그 PK (LODLA, 서비스에서 생성)
    private String aisLinkId;        // 학사정보시스템연동 ID (서비스에서 조회)
    private String rsltCd;           // 결과 코드 OK/FAIL (서비스에서 산출)
    private String aisLinkScsyn;     // 성공 여부 Y/N (서비스에서 산출)
    private String aisLinkRsltCts;   // 연동 결과 내용 (성공 메시지 / 실패 사유)

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getAisLinkTycd() {
        return aisLinkTycd;
    }

    public void setAisLinkTycd(String aisLinkTycd) {
        this.aisLinkTycd = aisLinkTycd;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getAddCnt() {
        return addCnt;
    }

    public void setAddCnt(int addCnt) {
        this.addCnt = addCnt;
    }

    public int getModCnt() {
        return modCnt;
    }

    public void setModCnt(int modCnt) {
        this.modCnt = modCnt;
    }

    public int getDelCnt() {
        return delCnt;
    }

    public void setDelCnt(int delCnt) {
        this.delCnt = delCnt;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getLogAisLinkId() {
        return logAisLinkId;
    }

    public void setLogAisLinkId(String logAisLinkId) {
        this.logAisLinkId = logAisLinkId;
    }

    public String getAisLinkId() {
        return aisLinkId;
    }

    public void setAisLinkId(String aisLinkId) {
        this.aisLinkId = aisLinkId;
    }

    public String getRsltCd() {
        return rsltCd;
    }

    public void setRsltCd(String rsltCd) {
        this.rsltCd = rsltCd;
    }

    public String getAisLinkScsyn() {
        return aisLinkScsyn;
    }

    public void setAisLinkScsyn(String aisLinkScsyn) {
        this.aisLinkScsyn = aisLinkScsyn;
    }

    public String getAisLinkRsltCts() {
        return aisLinkRsltCts;
    }

    public void setAisLinkRsltCts(String aisLinkRsltCts) {
        this.aisLinkRsltCts = aisLinkRsltCts;
    }
}
