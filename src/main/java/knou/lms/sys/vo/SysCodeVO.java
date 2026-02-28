package knou.lms.sys.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

/**
 * TB_LMS_CMMN_CD (공통코드)
 *
 */
public class SysCodeVO extends DefaultVO {

    private static final long serialVersionUID = -5310046812034329034L;
    
    private String  cmmnCdId;	// 공통코드 아이디
    private String  cd;         // 코드
    private String	upCd;		// 상위 코드
    private Integer cdSeq;        // 코드 순서
    private String  cdnm;		// 코드명
    private String	cdVl;		// 코드값
    private String	cdEnnm;		// 코드 영문명
    private String  cdExpln;	// 코드 설명
    private String	grpcd;		// 그룹 코드
    private String  useYn;          // 사용 여부
    
//    private String  codeOptn;       // 코드 옵션
    
    private List<SysCodeLangVO> codeLangList;
    
   
    public String getCmmnCdId() {
		return cmmnCdId;
	}
	public void setCmmnCdId(String cmmnCdId) {
		this.cmmnCdId = cmmnCdId;
	}
	public String getCd() {
		return cd;
	}
	public void setCd(String cd) {
		this.cd = cd;
	}
	public String getUpCd() {
		return upCd;
	}
	public void setUpCd(String upCd) {
		this.upCd = upCd;
	}
	public Integer getCdSeq() {
		return cdSeq;
	}
	public void setCdSeq(Integer cdSeq) {
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
	public String getCdEnnm() {
		return cdEnnm;
	}
	public void setCdEnnm(String cdEnnm) {
		this.cdEnnm = cdEnnm;
	}
	public String getCdExpln() {
		return cdExpln;
	}
	public void setCdExpln(String cdExpln) {
		this.cdExpln = cdExpln;
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
	//    public String getCodeOptn() {
//        return codeOptn;
//    }
//    public void setCodeOptn(String codeOptn) {
//        this.codeOptn = codeOptn;
//    }
    public List<SysCodeLangVO> getCodeLangList() {
        return codeLangList;
    }
    public void setCodeLangList(List<SysCodeLangVO> codeLangList) {
        this.codeLangList = codeLangList;
    }

}
