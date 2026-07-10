package knou.lms.mrk.vo;

// TB_LMS_MRK_PRC_EXCP_PROC (성적처리예외처리)

public class MrkProcExcpProcVO {

    private String mrkProcExcpProcId;   // 성적재산정기간설정 아이디
    private String sbjctId;             // 과목아이디
    private String procSdttm;         // 재산정 시작일시
    private String procEdttm;         // 재산정 종료일시
    private String procRsn;           // 재산정 사유

    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;

    public String getMrkProcExcpProcId() {
        return mrkProcExcpProcId;
    }

    public void setMrkProcExcpProcId(String mrkProcExcpProcId) {
        this.mrkProcExcpProcId = mrkProcExcpProcId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getProcSdttm() {
        return procSdttm;
    }

    public void setProcSdttm(String procSdttm) {
        this.procSdttm = procSdttm;
    }

    public String getProcEdttm() {
        return procEdttm;
    }

    public void setProcEdttm(String procEdttm) {
        this.procEdttm = procEdttm;
    }

    public String getProcRsn() {
        return procRsn;
    }

    public void setProcRsn(String procRsn) {
        this.procRsn = procRsn;
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
}
