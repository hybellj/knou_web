package knou.lms.mut.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class MutEvalVO extends DefaultVO {

    private String selectType; //조회유형 (OBJECT, LIST, PAGING)

    /** tb_lms_mut_eval */
    private String  evalCd;         // 평가 코드
    private String  evalTypeCd;     // 평가 유형 코드
    private String  evalTitle;      // 평가 제목

    private List<MutEvalQstnVO>  evalQstnList;      // 문항 리스트

    private String  evalDivCd;
    private String  rltnCd;

    private String delYn;
    private String useYn;
    private String rgtrId;
    private String regNm;
    private String regDttm;
    private String evalCnt;
    private String adminYn;

    public String getEvalCd() {
        return evalCd;
    }
    public void setEvalCd(String evalCd) {
        this.evalCd = evalCd;
    }
    public String getEvalTypeCd() {
        return evalTypeCd;
    }
    public void setEvalTypeCd(String evalTypeCd) {
        this.evalTypeCd = evalTypeCd;
    }
    public String getEvalTitle() {
        return evalTitle;
    }
    public void setEvalTitle(String evalTitle) {
        this.evalTitle = evalTitle;
    }
    public List<MutEvalQstnVO> getEvalQstnList() {
        return evalQstnList;
    }
    public void setEvalQstnList(List<MutEvalQstnVO> evalQstnList) {
        this.evalQstnList = evalQstnList;
    }
    public String getEvalDivCd() {
        return evalDivCd;
    }
    public void setEvalDivCd(String evalDivCd) {
        this.evalDivCd = evalDivCd;
    }
    public String getRltnCd() {
        return rltnCd;
    }
    public void setRltnCd(String rltnCd) {
        this.rltnCd = rltnCd;
    }
    public String getSelectType() {
        return selectType;
    }
    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getRgtrId() {
        return rgtrId;
    }
    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }
    public String getRegNm() {
        return regNm;
    }
    public void setRegNm(String regNm) {
        this.regNm = regNm;
    }
    public String getRegDttm() {
        return regDttm;
    }
    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }
    public String getEvalCnt() {
        return evalCnt;
    }
    public void setEvalCnt(String evalCnt) {
        this.evalCnt = evalCnt;
    }
    public String getAdminYn() {
        return adminYn;
    }
    public void setAdminYn(String adminYn) {
        this.adminYn = adminYn;
    }

}
