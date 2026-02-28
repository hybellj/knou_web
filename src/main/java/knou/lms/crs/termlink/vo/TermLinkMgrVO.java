package knou.lms.crs.termlink.vo;

import knou.lms.common.vo.DefaultVO;

public class TermLinkMgrVO extends DefaultVO {

    private static final long serialVersionUID = 4528083746518184703L;
    
    /** tb_lms_term_link_mgr */
    private String  termLinkMgrId;              // 학사연동 관리 아이디
    private String  autoLinkYn;                 // 자동 연동 여부
    private String  lastLinkDttm;               // 최종 연동 일시
    private String  lastLinkDttmUpdateYn;       // 최종 연동 일시 수정 여부
    
    public String getTermLinkMgrId() {
        return termLinkMgrId;
    }
    public void setTermLinkMgrId(String termLinkMgrId) {
        this.termLinkMgrId = termLinkMgrId;
    }
    public String getAutoLinkYn() {
        return autoLinkYn;
    }
    public void setAutoLinkYn(String autoLinkYn) {
        this.autoLinkYn = autoLinkYn;
    }
    public String getLastLinkDttm() {
        return lastLinkDttm;
    }
    public void setLastLinkDttm(String lastLinkDttm) {
        this.lastLinkDttm = lastLinkDttm;
    }
    public String getLastLinkDttmUpdateYn() {
        return lastLinkDttmUpdateYn;
    }
    public void setLastLinkDttmUpdateYn(String lastLinkDttmUpdateYn) {
        this.lastLinkDttmUpdateYn = lastLinkDttmUpdateYn;
    }

}
