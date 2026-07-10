package knou.lms.contents.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 관리자 콘텐츠 관리 화면의 과목 목록 행 정보를 담는다.
 */
public class ContsSbjctListVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctCd; // 과목코드
    private String dvclasNo; // 분반번호
    private String smstrChrtId; // 학기기수아이디
    private String sbjctYr; // 학사년도
    private String sbjctSmstr; // 학기
    private String smstrChrtGbncd; // 학기기수구분코드
    private String useyn; // 사용여부

    public String getSbjctCd() {
        return sbjctCd;
    }

    public void setSbjctCd(String sbjctCd) {
        this.sbjctCd = sbjctCd;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
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

    public String getSmstrChrtGbncd() {
        return smstrChrtGbncd;
    }

    public void setSmstrChrtGbncd(String smstrChrtGbncd) {
        this.smstrChrtGbncd = smstrChrtGbncd;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }
}
