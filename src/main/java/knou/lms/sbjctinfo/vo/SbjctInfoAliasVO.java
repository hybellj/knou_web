package knou.lms.sbjctinfo.vo;

import knou.lms.common.vo.DefaultVO;

public class SbjctInfoAliasVO extends DefaultVO {
    private static final long serialVersionUID = -8687268042580514971L;
    private String crsCreCd;        // 개설과목아이디
    private String dvclasNo;       // 분반번호
    private String dvclasNcknm;     // 분반별칭

    private String useYn;           // 사용여부

    public String getCrsCreCd() { return crsCreCd; }
    public void setCrsCreCd(String crsCreCd) { this.crsCreCd = crsCreCd; }

    public String getDvclasNo() { return dvclasNo; }
    public void setDvclasNo(String dvclasNo) { this.dvclasNo = dvclasNo; }

    public String getDvclasNcknm() { return dvclasNcknm; }
    public void setDvclasNcknm(String dvclasNcknm) { this.dvclasNcknm = dvclasNcknm; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
}


