package knou.lms.crs.sbjct.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class SbjctSchdlVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctSchdlId; // 과목일정아이디
    private String sbjctId; // 과목아이디
    private String smstrChrtSchdlId; // 학기기수일정아이디
    private Integer sbjctSchdlWkno; // 과목일정주차
    private String sbjctSchdlWknonm; // 과목일정주차명
    private Integer tocSeqno; // 목차순번
    private String sbjctSymd; // 과목시작일자
    private String sbjctEymd; // 과목종료일자
    private String sbjctAtndcRcgSymd; // 과목출석인정시작일자
    private String sbjctAtndcRcgEymd; // 과목출석인정종료일자
    private String rgtrId; // 등록자아이디
    private String regDttm; // 등록일시
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시

    /* DB와 관계없는 파라미터 */
    private List<SbjctSchdlVO> schdlList; // 과목일정목록

    public String getSbjctSchdlId() {
        return sbjctSchdlId;
    }

    public void setSbjctSchdlId(String sbjctSchdlId) {
        this.sbjctSchdlId = sbjctSchdlId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getSmstrChrtSchdlId() {
        return smstrChrtSchdlId;
    }

    public void setSmstrChrtSchdlId(String smstrChrtSchdlId) {
        this.smstrChrtSchdlId = smstrChrtSchdlId;
    }

    public Integer getSbjctSchdlWkno() {
        return sbjctSchdlWkno;
    }

    public void setSbjctSchdlWkno(Integer sbjctSchdlWkno) {
        this.sbjctSchdlWkno = sbjctSchdlWkno;
    }

    public String getSbjctSchdlWknonm() {
        return sbjctSchdlWknonm;
    }

    public void setSbjctSchdlWknonm(String sbjctSchdlWknonm) {
        this.sbjctSchdlWknonm = sbjctSchdlWknonm;
    }

    public Integer getTocSeqno() {
        return tocSeqno;
    }

    public void setTocSeqno(Integer tocSeqno) {
        this.tocSeqno = tocSeqno;
    }

    public String getSbjctSymd() {
        return sbjctSymd;
    }

    public void setSbjctSymd(String sbjctSymd) {
        this.sbjctSymd = sbjctSymd;
    }

    public String getSbjctEymd() {
        return sbjctEymd;
    }

    public void setSbjctEymd(String sbjctEymd) {
        this.sbjctEymd = sbjctEymd;
    }

    public String getSbjctAtndcRcgSymd() {
        return sbjctAtndcRcgSymd;
    }

    public void setSbjctAtndcRcgSymd(String sbjctAtndcRcgSymd) {
        this.sbjctAtndcRcgSymd = sbjctAtndcRcgSymd;
    }

    public String getSbjctAtndcRcgEymd() {
        return sbjctAtndcRcgEymd;
    }

    public void setSbjctAtndcRcgEymd(String sbjctAtndcRcgEymd) {
        this.sbjctAtndcRcgEymd = sbjctAtndcRcgEymd;
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

    public List<SbjctSchdlVO> getSchdlList() {
        return schdlList;
    }

    public void setSchdlList(List<SbjctSchdlVO> schdlList) {
        this.schdlList = schdlList;
    }
}
