package knou.lms.org.vo;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;
import knou.framework.util.ValidationUtils;

@Alias("orgCodeVO")
public class OrgCodeVO extends DefaultVO {
    
	private static final long serialVersionUID = -8890591976537443757L;
	
	private String	cmmnCdId;		// 공통코드 아이디
	private String	upCd;			// 상위코드 아이디
	private String	cd;				// 코드
	private int		cdSeq;			// 코드 순서
	private String	cdnm;			// 코드명
	private String	cdVl;			// 코드값
	private String	cdExpln;		// 코드 설명
	private String	grpcd;			// 그룹 코드
	
	private String	useYn = "Y";	// 사용여부
	
	private String	codeOptn;
	
	private String autoMakeYn;
	private String searchValue;

	// excel upload용으로 추가
	private String  lineNo;
	private String  errorCode;
	private String  isUseable = "N";

    private List<OrgCodeLangVO> codeLangList;
    private OrgCodeLangVO codeLangVO;

    
	public String getCmmnCdId() {
		return cmmnCdId;
	}

	public void setCmmnCdId(String cmmnCdId) {
		this.cmmnCdId = cmmnCdId;
	}

	public String getUpCd() {
		return upCd;
	}
	
	public void setUpCd(String upCd) {
		this.upCd = upCd;
	}

	public String getCd() {
		return cd;
	}
	public void setCd(String cd) {
		this.cd = cd;
	}
	
	public int getCdSeq() {
		return cdSeq;
	}
	public void setCdSeq(int cdSeq) {
		this.cdSeq = cdSeq;
	}

	public String getCdnm() {
		return cdnm;
	}
	public void setCdnm(String cdnm) {
		this.cdnm = cdnm;
	}
	
	public String getCdVl() {
		return cdVl;
	}
	public void setCdVl(String cdVl) {
		this.cdVl = cdVl;
	}

	public String getCdExpln() {
		return cdExpln;
	}
	public void setCdExpln(String CdExpln) {
		this.cdExpln = CdExpln;
	}
	
	public String getGrpcd() {
		return grpcd;
	}
	public void setGrpcd(String grpcd) {
		this.grpcd = grpcd;
	}
	
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getCodeOptn() {
		return codeOptn;
	}
	public void setCodeOptn(String codeOptn) {
		this.codeOptn = codeOptn;
	}

	public List<OrgCodeLangVO> getCodeLangList() {
	    if(ValidationUtils.isEmpty(codeLangList)) codeLangList = new ArrayList<OrgCodeLangVO>();
		return codeLangList;
	}
	public void setCodeLangList(List<OrgCodeLangVO> codeLangList) {
		this.codeLangList = codeLangList;
	}

	public String getLineNo() {
		return lineNo;
	}
	public void setLineNo(String lineNo) {
		this.lineNo = lineNo;
	}

	public String getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getIsUseable() {
		return isUseable;
	}
	public void setIsUseable(String isUseable) {
		this.isUseable = isUseable;
	}

	public String getAutoMakeYn() {
		return autoMakeYn;
	}
	public void setAutoMakeYn(String autoMakeYn) {
		this.autoMakeYn = autoMakeYn;
	}
	public String getSearchValue() {
		return searchValue;
	}
	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}
	
    public OrgCodeLangVO getCodeLangVO() {
        return codeLangVO;
    }
    public void setCodeLangVO(OrgCodeLangVO codeLangVO) {
        this.codeLangVO = codeLangVO;
    }
}
