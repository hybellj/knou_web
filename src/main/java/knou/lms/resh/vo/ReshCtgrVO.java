package knou.lms.resh.vo;

import knou.lms.common.vo.DefaultVO;

public class ReshCtgrVO extends DefaultVO {

    /** tb_lms_resch_ctgr */
    private String  reschCtgrCd;        // 설문 분류 코드
    private String  orgId;              // 기관 코드
    private String  parReschCtgrCd;     // 상위 설문 분류 코드
    private String  reschCtgrNm;        // 설문 분류 명
    private String  reschCtgrDesc;      // 설문 분류 설명
    private Integer reschCtgrLvl;       // 설문 분류 레벨
    private Integer reschCtgrOdr;       // 설문 분류 순서
    private String  shareYn;            // 공유 여부
    private String  useYn;              // 사용 여부
    private String  delYn;              // 삭제 여부
    
    public String getReschCtgrCd() {
        return reschCtgrCd;
    }
    public void setReschCtgrCd(String reschCtgrCd) {
        this.reschCtgrCd = reschCtgrCd;
    }
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
    public String getParReschCtgrCd() {
        return parReschCtgrCd;
    }
    public void setParReschCtgrCd(String parReschCtgrCd) {
        this.parReschCtgrCd = parReschCtgrCd;
    }
    public String getReschCtgrNm() {
        return reschCtgrNm;
    }
    public void setReschCtgrNm(String reschCtgrNm) {
        this.reschCtgrNm = reschCtgrNm;
    }
    public String getReschCtgrDesc() {
        return reschCtgrDesc;
    }
    public void setReschCtgrDesc(String reschCtgrDesc) {
        this.reschCtgrDesc = reschCtgrDesc;
    }
    public Integer getReschCtgrLvl() {
        return reschCtgrLvl;
    }
    public void setReschCtgrLvl(Integer reschCtgrLvl) {
        this.reschCtgrLvl = reschCtgrLvl;
    }
    public Integer getReschCtgrOdr() {
        return reschCtgrOdr;
    }
    public void setReschCtgrOdr(Integer reschCtgrOdr) {
        this.reschCtgrOdr = reschCtgrOdr;
    }
    public String getShareYn() {
        return shareYn;
    }
    public void setShareYn(String shareYn) {
        this.shareYn = shareYn;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    
}