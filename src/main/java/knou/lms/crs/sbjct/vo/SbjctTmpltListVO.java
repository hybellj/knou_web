package knou.lms.crs.sbjct.vo;

import knou.lms.common.vo.DefaultVO;

public class SbjctTmpltListVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctTmpltId; // 과목템플릿아이디
    private String sbjctCd; // 과목코드
    private String smstrChrtId; // 학기기수아이디
    private String sbjctnm; // 과목명
    private String sbjctYr; // 과목연도
    private String sbjctSmstr; // 과목학기
    private String sbjctTycd; // 과목유형코드
    private String lctrGbncd; // 강의구분코드
    private String useyn; // 사용여부

    /* DB와 관계없는 파라미터 */
    private String sbjctTycdnm; // 과목유형코드명
    private String lctrGbncdnm; // 강의구분코드명

    public String getSbjctTmpltId() {
        return sbjctTmpltId;
    }

    public void setSbjctTmpltId(String sbjctTmpltId) {
        this.sbjctTmpltId = sbjctTmpltId;
    }

    public String getSbjctCd() {
        return sbjctCd;
    }

    public void setSbjctCd(String sbjctCd) {
        this.sbjctCd = sbjctCd;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    @Override
    public String getSbjctnm() {
        return sbjctnm;
    }

    @Override
    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }

    public String getSbjctYr() {
        return sbjctYr;
    }

    public void setSbjctYr(String sbjctYr) {
        this.sbjctYr = sbjctYr;
    }

    public String getSbjctSmstr() {
        return sbjctSmstr;
    }

    public void setSbjctSmstr(String sbjctSmstr) {
        this.sbjctSmstr = sbjctSmstr;
    }

    public String getSbjctTycd() {
        return sbjctTycd;
    }

    public void setSbjctTycd(String sbjctTycd) {
        this.sbjctTycd = sbjctTycd;
    }

    public String getLctrGbncd() {
        return lctrGbncd;
    }

    public void setLctrGbncd(String lctrGbncd) {
        this.lctrGbncd = lctrGbncd;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

    public String getSbjctTycdnm() {
        return sbjctTycdnm;
    }

    public void setSbjctTycdnm(String sbjctTycdnm) {
        this.sbjctTycdnm = sbjctTycdnm;
    }

    public String getLctrGbncdnm() {
        return lctrGbncdnm;
    }

    public void setLctrGbncdnm(String lctrGbncdnm) {
        this.lctrGbncdnm = lctrGbncdnm;
    }
}
