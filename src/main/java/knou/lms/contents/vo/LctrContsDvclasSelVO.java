package knou.lms.contents.vo;

import java.io.Serializable;

/**
 * 학습목차 콘텐츠 분반 선택 정보를 담는다.
 */
public class LctrContsDvclasSelVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String sbjctId; // 과목아이디
    private String sbjctnm; // 과목명
    private String dvclasNo; // 분반번호
    private String wknoSchdlYn; // 주차일정보유여부
    private String registYn; // 등록가능여부
    private String checkedYn; // 선택여부

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getSbjctnm() {
        return sbjctnm;
    }

    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getWknoSchdlYn() {
        return wknoSchdlYn;
    }

    public void setWknoSchdlYn(String wknoSchdlYn) {
        this.wknoSchdlYn = wknoSchdlYn;
    }

    public String getRegistYn() {
        return registYn;
    }

    public void setRegistYn(String registYn) {
        this.registYn = registYn;
    }

    public String getCheckedYn() {
        return checkedYn;
    }

    public void setCheckedYn(String checkedYn) {
        this.checkedYn = checkedYn;
    }

}
