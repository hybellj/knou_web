package knou.lms.crs.termlink.vo;

import knou.lms.common.vo.DefaultVO;

public class TermLinkMgrResultVO extends DefaultVO {

    private static final long serialVersionUID = -248476067432185348L;
    
    /** tb_log_term_link_log */
    private String linkLogId;          // 연동 로그 ID
    private String  linkTypeCd;         // 연동 구분 코드
    private String  linkSucYn;          // 연동 성공 여부
    private String  linkRsltCd;         // 연동 결과 코드
    private String  linkRsltCts;        // 연동 결과 내용
    private Integer addCtn;             // 추가 건수
    private Integer modCnt;             // 갱신 건수
    private Integer delCnt;             // 삭제 건수
    private String  linkDttm;           // 연동 일시
    
    public String getLinkLogSn() {
        return linkLogId;
    }
    public void setLinkLogSn(String linkLogId) {
        this.linkLogId = linkLogId;
    }
    public String getLinkTypeCd() {
        return linkTypeCd;
    }
    public void setLinkTypeCd(String linkTypeCd) {
        this.linkTypeCd = linkTypeCd;
    }
    public String getLinkSucYn() {
        return linkSucYn;
    }
    public void setLinkSucYn(String linkSucYn) {
        this.linkSucYn = linkSucYn;
    }
    public String getLinkRsltCd() {
        return linkRsltCd;
    }
    public void setLinkRsltCd(String linkRsltCd) {
        this.linkRsltCd = linkRsltCd;
    }
    public String getLinkRsltCts() {
        return linkRsltCts;
    }
    public void setLinkRsltCts(String linkRsltCts) {
        this.linkRsltCts = linkRsltCts;
    }
    public Integer getAddCtn() {
        return addCtn;
    }
    public void setAddCtn(Integer addCtn) {
        this.addCtn = addCtn;
    }
    public Integer getModCnt() {
        return modCnt;
    }
    public void setModCnt(Integer modCnt) {
        this.modCnt = modCnt;
    }
    public Integer getDelCnt() {
        return delCnt;
    }
    public void setDelCnt(Integer delCnt) {
        this.delCnt = delCnt;
    }
    public String getLinkDttm() {
        return linkDttm;
    }
    public void setLinkDttm(String linkDttm) {
        this.linkDttm = linkDttm;
    }

}
