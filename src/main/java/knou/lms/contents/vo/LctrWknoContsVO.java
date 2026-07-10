package knou.lms.contents.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 강의주차 일정과 주차별 학습자료 정보를 함께 담는다.
 */
public class LctrWknoContsVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String lctrWknoSchdlId; // 강의주차일정아이디
    private Integer lctrWkno; // 강의주차
    private String lctrWknoCd; // 강의주차코드
    private String lctrWknonm; // 강의주차명
    private String lctrWknoExpln; // 강의주차설명
    private Integer lctrWknoSeqno; // 강의주차순번
    private String lctrWknoSymd; // 강의주차시작일자
    private String lctrWknoEymd; // 강의주차종료일자
    private String lctrId; // 강의아이디
    private String lctrnm; // 강의명
    private Integer lctrSeqno; // 강의순번
    private String lctrContsId; // 강의콘텐츠아이디
    private Integer contsSeqno; // 콘텐츠순번
    private String contsnm; // 콘텐츠명
    private String lrnTocTtl; // 학습목차제목
    private String lctrContsTycd; // 강의콘텐츠유형코드
    private String contsUrl; // 콘텐츠URL
    private String contsPath; // 콘텐츠경로
    private String contsFileExt; // 콘텐츠파일확장자
    private String contsPstnCd; // 콘텐츠위치코드
    private Integer vdoMnts; // 동영상분
    private String vdoQltyGbncd; // 동영상화질구분코드
    private String atndcRfltyn; // 출석반영여부
    private String seqLrnyn; // 순차학습여부
    private String oyn; // 공개여부
    private String exrcsQstnId; // 연습문제아이디
    private Integer sddnQstnCnt; // 돌발퀴즈수

    public String getLctrWknoSchdlId() {
        return lctrWknoSchdlId;
    }

    public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
        this.lctrWknoSchdlId = lctrWknoSchdlId;
    }

    public Integer getLctrWkno() {
        return lctrWkno;
    }

    public void setLctrWkno(Integer lctrWkno) {
        this.lctrWkno = lctrWkno;
    }

    public String getLctrWknoCd() {
        return lctrWknoCd;
    }

    public void setLctrWknoCd(String lctrWknoCd) {
        this.lctrWknoCd = lctrWknoCd;
    }

    public String getLctrWknonm() {
        return lctrWknonm;
    }

    public void setLctrWknonm(String lctrWknonm) {
        this.lctrWknonm = lctrWknonm;
    }

    public String getLctrWknoExpln() {
        return lctrWknoExpln;
    }

    public void setLctrWknoExpln(String lctrWknoExpln) {
        this.lctrWknoExpln = lctrWknoExpln;
    }

    public Integer getLctrWknoSeqno() {
        return lctrWknoSeqno;
    }

    public void setLctrWknoSeqno(Integer lctrWknoSeqno) {
        this.lctrWknoSeqno = lctrWknoSeqno;
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

    public String getLctrId() {
        return lctrId;
    }

    public void setLctrId(String lctrId) {
        this.lctrId = lctrId;
    }

    public String getLctrnm() {
        return lctrnm;
    }

    public void setLctrnm(String lctrnm) {
        this.lctrnm = lctrnm;
    }

    public Integer getLctrSeqno() {
        return lctrSeqno;
    }

    public void setLctrSeqno(Integer lctrSeqno) {
        this.lctrSeqno = lctrSeqno;
    }

    public String getLctrContsId() {
        return lctrContsId;
    }

    public void setLctrContsId(String lctrContsId) {
        this.lctrContsId = lctrContsId;
    }

    public Integer getContsSeqno() {
        return contsSeqno;
    }

    public void setContsSeqno(Integer contsSeqno) {
        this.contsSeqno = contsSeqno;
    }

    public String getContsnm() {
        return contsnm;
    }

    public void setContsnm(String contsnm) {
        this.contsnm = contsnm;
    }

    public String getLrnTocTtl() {
        return lrnTocTtl;
    }

    public void setLrnTocTtl(String lrnTocTtl) {
        this.lrnTocTtl = lrnTocTtl;
    }

    public String getLctrContsTycd() {
        return lctrContsTycd;
    }

    public void setLctrContsTycd(String lctrContsTycd) {
        this.lctrContsTycd = lctrContsTycd;
    }

    public String getContsUrl() {
        return contsUrl;
    }

    public void setContsUrl(String contsUrl) {
        this.contsUrl = contsUrl;
    }

    public String getContsPath() {
        return contsPath;
    }

    public void setContsPath(String contsPath) {
        this.contsPath = contsPath;
    }

    public String getContsFileExt() {
        return contsFileExt;
    }

    public void setContsFileExt(String contsFileExt) {
        this.contsFileExt = contsFileExt;
    }

    public String getContsPstnCd() {
        return contsPstnCd;
    }

    public void setContsPstnCd(String contsPstnCd) {
        this.contsPstnCd = contsPstnCd;
    }

    public Integer getVdoMnts() {
        return vdoMnts;
    }

    public void setVdoMnts(Integer vdoMnts) {
        this.vdoMnts = vdoMnts;
    }

    public String getVdoQltyGbncd() {
        return vdoQltyGbncd;
    }

    public void setVdoQltyGbncd(String vdoQltyGbncd) {
        this.vdoQltyGbncd = vdoQltyGbncd;
    }

    public String getAtndcRfltyn() {
        return atndcRfltyn;
    }

    public void setAtndcRfltyn(String atndcRfltyn) {
        this.atndcRfltyn = atndcRfltyn;
    }

    public String getSeqLrnyn() {
        return seqLrnyn;
    }

    public void setSeqLrnyn(String seqLrnyn) {
        this.seqLrnyn = seqLrnyn;
    }

    public String getOyn() {
        return oyn;
    }

    public void setOyn(String oyn) {
        this.oyn = oyn;
    }

    public String getExrcsQstnId() {
        return exrcsQstnId;
    }

    public void setExrcsQstnId(String exrcsQstnId) {
        this.exrcsQstnId = exrcsQstnId;
    }

    public Integer getSddnQstnCnt() {
        return sddnQstnCnt;
    }

    public void setSddnQstnCnt(Integer sddnQstnCnt) {
        this.sddnQstnCnt = sddnQstnCnt;
    }
}
