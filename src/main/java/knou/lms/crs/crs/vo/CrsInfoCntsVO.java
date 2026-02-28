package knou.lms.crs.crs.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("crsInfoCntsVO")
public class CrsInfoCntsVO extends DefaultVO {
	
	private static final long serialVersionUID = 8502979470754269304L;
	
	private String  crsCd;				/*과정 코드*/
	private String  crsInfoCntsCd;		/*과정정보콘텐츠코드*/
	private String  crsInfoCntsDivCd;	/*과정정보콘텐츠구분코드*/
	private Integer cntsOrder;			/*과정 코드*/
	private String  cntsFileLocCd;		/*콘텐츠파일위치코드*/
	private String  cntsFileNm;			/*콘텐츠파일명 */
	private String  cntsFilePath;		/*콘테네츠파일경로*/
	private String  cntsUrl;			/*콘텐츠UR/
	private String  rgtrId;				/*등록자 번호*/
	private String  regDttm;			/*등록 일시*/
	
	private String  crsCreCd;			/*개설 : 과정 개설 코드*/
	private String  orgId;              /*기관 코드*/
	
	public String getCrsCd() {
		return crsCd;
	}
	public void setCrsCd(String crsCd) {
		this.crsCd = crsCd;
	}
	public String getCrsInfoCntsCd() {
		return crsInfoCntsCd;
	}
	public void setCrsInfoCntsCd(String crsInfoCntsCd) {
		this.crsInfoCntsCd = crsInfoCntsCd;
	}
	public String getCrsInfoCntsDivCd() {
		return crsInfoCntsDivCd;
	}
	public void setCrsInfoCntsDivCd(String crsInfoCntsDivCd) {
		this.crsInfoCntsDivCd = crsInfoCntsDivCd;
	}
	public Integer getCntsOrder() {
		return cntsOrder;
	}
	public void setCntsOrder(Integer cntsOrder) {
		this.cntsOrder = cntsOrder;
	}
	public String getCntsFileLocCd() {
		return cntsFileLocCd;
	}
	public void setCntsFileLocCd(String cntsFileLocCd) {
		this.cntsFileLocCd = cntsFileLocCd;
	}
	public String getCntsFileNm() {
		return cntsFileNm;
	}
	public void setCntsFileNm(String cntsFileNm) {
		this.cntsFileNm = cntsFileNm;
	}
	public String getCntsFilePath() {
		return cntsFilePath;
	}
	public void setCntsFilePath(String cntsFilePath) {
		this.cntsFilePath = cntsFilePath;
	}
	public String getCntsUrl() {
		return cntsUrl;
	}
	public void setCntsUrl(String cntsUrl) {
		this.cntsUrl = cntsUrl;
	}
	public String getRegDttm() {
		return regDttm;
	}
	public void setRegDttm(String regDttm) {
		this.regDttm = regDttm;
	}
	public String getCrsCreCd() {
		return crsCreCd;
	}
	public void setCrsCreCd(String crsCreCd) {
		this.crsCreCd = crsCreCd;
	}
	/** @return orgId 값을 반환한다. */
    public String getOrgId() {
        return orgId;
    }
    /** @param orgId 을 orgId 에 저장한다. */
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
	
}
