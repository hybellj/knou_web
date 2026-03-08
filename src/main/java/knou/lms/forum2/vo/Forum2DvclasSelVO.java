package knou.lms.forum2.vo;

import java.io.Serializable;

public class Forum2DvclasSelVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String dvclasNo; // 분반번호
    private String sbjctId; // 과목아이디
    private String checkedYn; // 선택여부(Y/N)
    private String readonlyYn; // 고정선택여부(Y/N)

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getCheckedYn() {
        return checkedYn;
    }

    public void setCheckedYn(String checkedYn) {
        this.checkedYn = checkedYn;
    }

    public String getReadonlyYn() {
        return readonlyYn;
    }

    public void setReadonlyYn(String readonlyYn) {
        this.readonlyYn = readonlyYn;
    }
}
