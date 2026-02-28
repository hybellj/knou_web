package knou.lms.org.vo;

import org.apache.ibatis.type.Alias;

@Alias("orgCodeLangVO")
public class OrgCodeLangVO extends OrgCodeVO {

	private static final long serialVersionUID = 2159772976271937080L;
	
    private String langCd;

    private int result = 1;	// 조회 결과
    
    public String getLangCd() {
        return langCd;
    }
    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }
    
    public int getResult() {
        return result;
    }
    public void setResult(int result) {
        this.result = result;
    }
}
