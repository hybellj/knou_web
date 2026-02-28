package knou.lms.org.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("orgCodeCtgrVO")
public class OrgCodeCtgrVO extends DefaultVO {

	private static final long serialVersionUID = -4265527871171838050L;
	
	private String	orgId;
	private String codeCtgrCd;
	private String codeCtgrNm;
	private int	     codeCtgrOdr;
	private String	 codeCtgrDesc;
	private String	 useYn = "Y";

	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	
	public String getCodeCtgrCd() {
		return codeCtgrCd;
	}
	public void setCodeCtgrCd(String codeCtgrCd) {
		this.codeCtgrCd = codeCtgrCd;
	}
	
	public String getCodeCtgrNm() {
		return codeCtgrNm;
	}
	public void setCodeCtgrNm(String codeCtgrNm) {
		this.codeCtgrNm = codeCtgrNm;
	}
	
	public int getCodeCtgrOdr() {
		return codeCtgrOdr;
	}
	public void setCodeCtgrOdr(int codeCtgrOdr) {
		this.codeCtgrOdr = codeCtgrOdr;
	}
	
	public String getCodeCtgrDesc() {
		return codeCtgrDesc;
	}
	public void setCodeCtgrDesc(String codeCtgrDesc) {
		this.codeCtgrDesc = codeCtgrDesc;
	}
	
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

}