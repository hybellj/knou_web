package knou.lms.system.code.vo;

import knou.lms.common.vo.DefaultVO;

public class SysCmmnCdVO extends DefaultVO {
    private static final long serialVersionUID = 180723044442176021L;

    /*****************************************************
     * 테이블 컬럼
     *****************************************************/

    private String		cmmnCdId;		// 공통코드 ID (PK)
    private String		orgId;			// 기관 ID
    private String		langCd;			// 언어 코드
    private String		upCd;			// 공통코드 분류코드
    private String		cd;				// 공통코드
    private String		cdnm;			// 공통코드명
    private Integer		cdSeqno;			// 코드 순서
    private String		useyn;			// 사용 여부 (Y/N)
    private String		rgtrId;			// 등록자 ID
    private String		regDttm;		// 등록 일시
    private String		mdfrId;			// 수정자 ID
    private String		modDttm;		// 수정 일시

    private String 		upCdnm;			// 공통코드 분류코드명

    private Boolean 	isUpCdSelect;	// 분류코드만 조회 여부
    private Boolean 	isUpCdModify;	// 분류코드 변경 여부
    private Boolean 	isUpCdDelete;	// 분류코드 삭제 여부
    private String 		updtUpCd;		// 업데이트용 분류코드 

    /*****************************************************
     * Getter / Setter
     *****************************************************/

    // cmmnCdId
    public String getCmmnCdId() {
        return cmmnCdId;
    }

    public void setCmmnCdId(String cmmnCdId) {
        this.cmmnCdId = cmmnCdId;
    }

    // orgId
    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    // langCd
    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    // upCd
    public String getUpCd() {
        return upCd;
    }

    public void setUpCd(String upCd) {
        this.upCd = upCd;
    }

    // cd
    public String getCd() {
        return cd;
    }

    public void setCd(String cd) {
        this.cd = cd;
    }

    // cdnm
    public String getCdnm() {
        return cdnm;
    }

    public void setCdnm(String cdnm) {
        this.cdnm = cdnm;
    }

    // cdSeqno
    public Integer getCdSeqno() {
        return cdSeqno;
    }

    public void setCdSeqno(Integer cdSeqno) {
        this.cdSeqno = cdSeqno;
    }

    // useyn
    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

    // rgtrId
    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    // regDttm
    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    // mdfrId
    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }	

    // modDttm
    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    // upCdnm
    public String getUpCdnm() {
        return upCdnm;
    }

    public void setUpCdnm(String upCdnm) {
        this.upCdnm = upCdnm;
    }

    // isUpCdSelect
    public Boolean getIsUpCdSelect() {
        return isUpCdSelect;
    }

    public void setIsUpCdSelect(Boolean isUpCdSelect) {
        this.isUpCdSelect = isUpCdSelect;
    }

    // isUpCdModify
    public Boolean getIsUpCdModify() {
        return isUpCdModify;
    }

    public void setIsUpCdModify(Boolean isUpCdModify) {
        this.isUpCdModify = isUpCdModify;
    }

    // isUpCdModify
    public Boolean getIsUpCdDelete() {
        return isUpCdDelete;
    }

    public void setIsUpCdDelete(Boolean isUpCdDelete) {
        this.isUpCdDelete = isUpCdDelete;
    }
	
    // updtUpCd
    public String getUpdtUpCd() {
        return updtUpCd;
    }

    public void setUpdtUpCd(String updtUpCd) {
        this.updtUpCd = updtUpCd;
    }
}
