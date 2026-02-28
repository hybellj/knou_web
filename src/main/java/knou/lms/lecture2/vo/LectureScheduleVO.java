package knou.lms.lecture2.vo;

import knou.lms.common.vo.DefaultVO;

public class LectureScheduleVO extends DefaultVO {

    /**
     *
     */
    private static final long serialVersionUID = -610127268422610228L;

    /**
     * 강의주차일정ID
     */
    private String lctrWknoSchdlId;

    /**
     * 교과목개설ID
     */
    private String sbjctOfrngId;

    /**
     * 강의계획서ID
     */
    private String lctrPlandocId;

    /**
     * 강의주차
     */
    private int lctrWkno;

    /**
     * 강의주차코드
     */
    private String lctrWknoCd;

    /**
     * 강의주차명
     */
    private String lctrWknoNm;

    /**
     * 강의주차설명
     */
    private String lctrWknoExpln;

    /**
     * 강의주차순번
     */
    private int lctrWknoSeqno;

    /**
     * 강의목표
     */
    private String lctrGoal;

    /**
     * 강의내용
     */
    private String lctrCts;

    /**
     * 강의개요
     */
    private String lctrOtln;

    /**
     * 참고자료
     */
    private String lctrRefData;

    /**
     * 강의주차시작일
     */
    private String lctrWknoSymd;

    /**
     * 강의주차종료일
     */
    private String lctrWknoEymd;

    /**
     * 출석인정시작일
     */
    private String atndcRcgSymd;

    /**
     * 출석인정종료일
     */
    private String atndcRcgEymd;

    /**
     * 학습시간(초)
     */
    private int lctrTocLrnScnds;

    /**
     * 공개여부
     */
    private String oyn;

    /**
     * 삭제여부
     */
    private String delyn;

    /**
     * 등록자ID
     */
    private String rgtrId;

    /**
     * 등록일시
     */
    private String regDttm;

    /**
     * 수정자ID
     */
    private String mdfrId;

    /**
     * 수정일시
     */
    private String modDttm;

    private String lctrTycd;    // 강의유형코드
    private String lctrTtl;     // 강의제목

    /*===저장용===*/
    private String wkChgyn;    // 주차변경여부

    public String getLctrWknoSchdlId() {
        return lctrWknoSchdlId;
    }

    public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
        this.lctrWknoSchdlId = lctrWknoSchdlId;
    }

    public String getSbjctOfrngId() {
        return sbjctOfrngId;
    }

    public void setSbjctOfrngId(String sbjctOfrngId) {
        this.sbjctOfrngId = sbjctOfrngId;
    }

    public String getLctrPlandocId() {
        return lctrPlandocId;
    }

    public void setLctrPlandocId(String lctrPlandocId) {
        this.lctrPlandocId = lctrPlandocId;
    }

    public int getLctrWkno() {
        return lctrWkno;
    }

    public void setLctrWkno(int lctrWkno) {
        this.lctrWkno = lctrWkno;
    }

    public String getLctrWknoCd() {
        return lctrWknoCd;
    }

    public void setLctrWknoCd(String lctrWknoCd) {
        this.lctrWknoCd = lctrWknoCd;
    }

    public String getLctrWknoNm() {
        return lctrWknoNm;
    }

    public void setLctrWknoNm(String lctrWknoNm) {
        this.lctrWknoNm = lctrWknoNm;
    }

    public String getLctrWknoExpln() {
        return lctrWknoExpln;
    }

    public void setLctrWknoExpln(String lctrWknoExpln) {
        this.lctrWknoExpln = lctrWknoExpln;
    }

    public int getLctrWknoSeqno() {
        return lctrWknoSeqno;
    }

    public void setLctrWknoSeq(int lctrWknoSeqno) {
        this.lctrWknoSeqno = lctrWknoSeqno;
    }

    public String getLctrGoal() {
        return lctrGoal;
    }

    public void setLctrGoal(String lctrGoal) {
        this.lctrGoal = lctrGoal;
    }

    public String getLctrCts() {
        return lctrCts;
    }

    public void setLctrCts(String lctrCts) {
        this.lctrCts = lctrCts;
    }

    public String getLctrOtln() {
        return lctrOtln;
    }

    public void setLctrOtln(String lctrOtln) {
        this.lctrOtln = lctrOtln;
    }

    public String getLctrRefData() {
        return lctrRefData;
    }

    public void setLctrRefData(String lctrRefData) {
        this.lctrRefData = lctrRefData;
    }

    public String getLctrWknoSymd() {
        return lctrWknoSymd;
    }

    public void setLctrWknoSymd(String lctrWknoSymd) {
        this.lctrWknoSymd = lctrWknoSymd;
    }

    public String getLctrWknoEymd() {
        return lctrWknoEymd;
    }

    public void setLctrWknoEymd(String lctrWknoEymd) {
        this.lctrWknoEymd = lctrWknoEymd;
    }

    public String getAtndcRcgSymd() {
        return atndcRcgSymd;
    }

    public void setAtndcRcgSymd(String atndcRcgSymd) {
        this.atndcRcgSymd = atndcRcgSymd;
    }

    public String getAtndcRcgEymd() {
        return atndcRcgEymd;
    }

    public void setAtndcRcgEymd(String atndcRcgEymd) {
        this.atndcRcgEymd = atndcRcgEymd;
    }

    public int getLctrTocLrnScnds() {
        return lctrTocLrnScnds;
    }

    public void setLctrTocLrnScnds(int lctrTocLrnScnds) {
        this.lctrTocLrnScnds = lctrTocLrnScnds;
    }

    public String getOyn() {
        return oyn;
    }

    public void setOyn(String oyn) {
        this.oyn = oyn;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
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

    public String getLctrTycd() {
        return lctrTycd;
    }

    public void setLctrTycd(String lctrTycd) {
        this.lctrTycd = lctrTycd;
    }

    public String getLctrTtl() {
        return lctrTtl;
    }

    public void setLctrTtl(String lctrTtl) {
        this.lctrTtl = lctrTtl;
    }

    public String getWkChgyn() {
        return wkChgyn;
    }

    public void setWkChgyn(String wkChgyn) {
        this.wkChgyn = wkChgyn;
    }
}