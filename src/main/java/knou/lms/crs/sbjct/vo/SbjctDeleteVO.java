package knou.lms.crs.sbjct.vo;

import knou.lms.common.vo.DefaultVO;

public class SbjctDeleteVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctId;  // 과목아이디(SBJCT_ID)

    private String mdfrId;   // 수정자아이디(MDFR_ID)
    private String modDttm;  // 수정일시(MOD_DTTM)

    public String getSbjctId() { return sbjctId; }
    public void setSbjctId(String sbjctId) { this.sbjctId = sbjctId; }

    public String getMdfrId() { return mdfrId; }
    public void setMdfrId(String mdfrId) { this.mdfrId = mdfrId; }

    public String getModDttm() { return modDttm; }
    public void setModDttm(String modDttm) { this.modDttm = modDttm; }
}
