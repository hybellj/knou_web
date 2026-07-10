package knou.lms.atndcrtr.vo;

import java.util.ArrayList;
import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class AtndCrtrVO extends DefaultVO {
    private static final long serialVersionUID = -6877194508842204052L;

    /* 목록/기본정보 */
    private String smstrChrtId;
    private String smstrChrtnm;
    private String haksaTermNm;
    private String orgShrtNm;
    private String orgTycd;
    private String orgTycdnm;
    private String chrgPrsnNm;
    private Integer crtrCnt;
    private String bywknoAttndncCrtrId;

    /* 출석점수 기준비율 */
    private String crtrStngId;
    private Integer crtrSeq;
    private Float startRate;
    private Float endRate;
    private Float score;

    /* 출결기준 및 진도율 설정 */
    private String playRateRecgYn = "Y";
    private Float atndMinPrgrt;
    private Float lateMinPrgrt;
    private Float lateRecgRate;
    private Float absentRecgRate;

    /* 화면 전송용 문자열 */
    private Float attendanceScore;
    private Float lateScore;
    private Float absenceScore;

    /* 상세 목록 */
    private List<AtndCrtrVO> dtlList = new ArrayList<AtndCrtrVO>();

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getAtndCrtrId() {
        return smstrChrtId;
    }

    public void setAtndCrtrId(String atndCrtrId) {
        this.smstrChrtId = atndCrtrId;
    }

    public String getSmstrChrtnm() {
        return smstrChrtnm;
    }

    public void setSmstrChrtnm(String smstrChrtnm) {
        this.smstrChrtnm = smstrChrtnm;
    }

    public String getHaksaTermNm() {
        return haksaTermNm;
    }

    public void setHaksaTermNm(String haksaTermNm) {
        this.haksaTermNm = haksaTermNm;
    }

    public String getOrgShrtNm() {
        return orgShrtNm;
    }

    public void setOrgShrtNm(String orgShrtNm) {
        this.orgShrtNm = orgShrtNm;
    }

    public String getOrgTycd() {
        return orgTycd;
    }

    public void setOrgTycd(String orgTycd) {
        this.orgTycd = orgTycd;
    }

    public String getOrgTycdnm() {
        return orgTycdnm;
    }

    public void setOrgTycdnm(String orgTycdnm) {
        this.orgTycdnm = orgTycdnm;
    }

    public String getChrgPrsnNm() {
        return chrgPrsnNm;
    }

    public void setChrgPrsnNm(String chrgPrsnNm) {
        this.chrgPrsnNm = chrgPrsnNm;
    }

    public Integer getCrtrCnt() {
        return crtrCnt;
    }

    public void setCrtrCnt(Integer crtrCnt) {
        this.crtrCnt = crtrCnt;
    }

    public String getBywknoAttndncCrtrId() {
        return bywknoAttndncCrtrId;
    }

    public void setBywknoAttndncCrtrId(String bywknoAttndncCrtrId) {
        this.bywknoAttndncCrtrId = bywknoAttndncCrtrId;
    }

    public String getCrtrStngId() {
        return crtrStngId;
    }

    public void setCrtrStngId(String crtrStngId) {
        this.crtrStngId = crtrStngId;
    }

    public Integer getCrtrSeq() {
        return crtrSeq;
    }

    public void setCrtrSeq(Integer crtrSeq) {
        this.crtrSeq = crtrSeq;
    }

    public Float getStartRate() {
        return startRate;
    }

    public void setStartRate(Float startRate) {
        this.startRate = startRate;
    }

    public Float getEndRate() {
        return endRate;
    }

    public void setEndRate(Float endRate) {
        this.endRate = endRate;
    }

    public Float getScore() {
        return score;
    }

    public void setScore(Float score) {
        this.score = score;
    }

    public Float getAtndMinPrgrt() {
        return atndMinPrgrt;
    }

    public void setAtndMinPrgrt(Float atndMinPrgrt) {
        this.atndMinPrgrt = atndMinPrgrt;
    }

    public Float getLateMinPrgrt() {
        return lateMinPrgrt;
    }

    public void setLateMinPrgrt(Float lateMinPrgrt) {
        this.lateMinPrgrt = lateMinPrgrt;
    }

    public Float getLateRecgRate() {
        return lateRecgRate;
    }

    public void setLateRecgRate(Float lateRecgRate) {
        this.lateRecgRate = lateRecgRate;
    }

    public Float getAbsentRecgRate() {
        return absentRecgRate;
    }

    public void setAbsentRecgRate(Float absentRecgRate) {
        this.absentRecgRate = absentRecgRate;
    }

    public String getPlayRateRecgYn() {
        return playRateRecgYn;
    }

    public void setPlayRateRecgYn(String playRateRecgYn) {
        this.playRateRecgYn = playRateRecgYn;
    }

    public Float getAttendanceScore() {
        return attendanceScore;
    }

    public void setAttendanceScore(Float attendanceScore) {
        this.attendanceScore = attendanceScore;
    }

    public Float getLateScore() {
        return lateScore;
    }

    public void setLateScore(Float lateScore) {
        this.lateScore = lateScore;
    }

    public Float getAbsenceScore() {
        return absenceScore;
    }

    public void setAbsenceScore(Float absenceScore) {
        this.absenceScore = absenceScore;
    }

    public List<AtndCrtrVO> getDtlList() {
        return dtlList;
    }

    public void setDtlList(List<AtndCrtrVO> dtlList) {
        this.dtlList = dtlList;
    }
}
