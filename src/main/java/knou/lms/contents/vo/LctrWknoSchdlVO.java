package knou.lms.contents.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 강의주차일정 관리 정보를 담는다.
 */
public class LctrWknoSchdlVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String lctrWknoSchdlId; // 강의주차일정아이디
    private String sbjctId; // 과목아이디
    private String lctrWknonm; // 강의주차명
    private String lctrWknoSymd; // 강의주차시작일자
    private String lctrWknoEymd; // 강의주차종료일자
    private String wknoAtndcRcgSymd; // 주차출석인정시작일자
    private String wknoAtndcRcgEymd; // 주차출석인정종료일자

    public String getLctrWknoSchdlId() {
        return lctrWknoSchdlId;
    }

    public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
        this.lctrWknoSchdlId = lctrWknoSchdlId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getLctrWknonm() {
        return lctrWknonm;
    }

    public void setLctrWknonm(String lctrWknonm) {
        this.lctrWknonm = lctrWknonm;
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

    public String getWknoAtndcRcgSymd() {
        return wknoAtndcRcgSymd;
    }

    public void setWknoAtndcRcgSymd(String wknoAtndcRcgSymd) {
        this.wknoAtndcRcgSymd = wknoAtndcRcgSymd;
    }

    public String getWknoAtndcRcgEymd() {
        return wknoAtndcRcgEymd;
    }

    public void setWknoAtndcRcgEymd(String wknoAtndcRcgEymd) {
        this.wknoAtndcRcgEymd = wknoAtndcRcgEymd;
    }
}
