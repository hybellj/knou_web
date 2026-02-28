package knou.lms.mrk.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * TB_LMS_MRK_ITM_STNG (성적항목설정)
 */
public class MarkItemSettingVO extends DefaultVO {

    private static final long serialVersionUID = 4013882729091094259L;

    private String mrkItmStngId;    // 성적항목설정 아이디
    private String lctrPandocId;    // 강의계획서 아이디

    private String mrkItmnm;        // 성적항목명
    private String mrkItmExpln;        // 성적항목 설명
    private String mrkEvlGbncd;        // 성적평가구분코드 (절대,상대...)
    private String mrkItmTycd;        // 성적항목 유형코드
    private Integer mrkRfltrt;        // 성적반영 비율
    private String mrkOyn;            // 성적공개여부
    private String mrkItmUseyn;      // 성적항목사용여부

    public String getMrkItmStngId() {
        return mrkItmStngId;
    }

    public void setMrkItmStngId(String mrkItmStngId) {
        this.mrkItmStngId = mrkItmStngId;
    }

    public String getLctrPandocId() {
        return lctrPandocId;
    }

    public void setLctrPandocId(String lctrPandocId) {
        this.lctrPandocId = lctrPandocId;
    }

    public String getMrkItmnm() {
        return mrkItmnm;
    }

    public void setMrkItmnm(String mrkItmnm) {
        this.mrkItmnm = mrkItmnm;
    }

    public String getMrkItmExpln() {
        return mrkItmExpln;
    }

    public void setMrkItmExpln(String mrkItmExpln) {
        this.mrkItmExpln = mrkItmExpln;
    }

    public String getMrkEvlGbncd() {
        return mrkEvlGbncd;
    }

    public void setMrkEvlGbncd(String mrkEvlGbncd) {
        this.mrkEvlGbncd = mrkEvlGbncd;
    }

    public String getMrkItmTycd() {
        return mrkItmTycd;
    }

    public void setMrkItmTycd(String mrkItmTycd) {
        this.mrkItmTycd = mrkItmTycd;
    }

    public Integer getMrkRfltrt() {
        return mrkRfltrt;
    }

    public void setMrkRfltrt(Integer mrkRfltrt) {
        this.mrkRfltrt = mrkRfltrt;
    }

    public String getMrkOyn() {
        return mrkOyn;
    }

    public void setMrkOyn(String mrkOyn) {
        this.mrkOyn = mrkOyn;
    }

    public String getMrkItmUseyn() {
        return mrkItmUseyn;
    }

    public void setMrkItmUseyn(String mrkItmUseyn) {
        this.mrkItmUseyn = mrkItmUseyn;
    }
}
