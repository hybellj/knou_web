package knou.lms.erp.vo;

import knou.lms.common.vo.DefaultVO;

public class ErpJobScheduleVO extends DefaultVO {

    private static final long serialVersionUID = 4432631399017757719L;
    
    private String gubun;
    private String scheCd;
    private String scheCdNm;
    private String notiCtnt;
    private String frDttm;
    private String toDttm;
    private String insertAt;
    private String modifyAt;
    
    public String getGubun() {
        return gubun;
    }
    public void setGubun(String gubun) {
        this.gubun = gubun;
    }
    public String getScheCd() {
        return scheCd;
    }
    public void setScheCd(String scheCd) {
        this.scheCd = scheCd;
    }
    public String getScheCdNm() {
        return scheCdNm;
    }
    public void setScheCdNm(String scheCdNm) {
        this.scheCdNm = scheCdNm;
    }
    public String getFrDttm() {
        return frDttm;
    }
    public void setFrDttm(String frDttm) {
        this.frDttm = frDttm;
    }
    public String getToDttm() {
        return toDttm;
    }
    public void setToDttm(String toDttm) {
        this.toDttm = toDttm;
    }
    public String getInsertAt() {
        return insertAt;
    }
    public void setInsertAt(String insertAt) {
        this.insertAt = insertAt;
    }
    public String getModifyAt() {
        return modifyAt;
    }
    public void setModifyAt(String modifyAt) {
        this.modifyAt = modifyAt;
    }
    public String getNotiCtnt() {
        return notiCtnt;
    }
    public void setNotiCtnt(String notiCtnt) {
        this.notiCtnt = notiCtnt;
    }

}
