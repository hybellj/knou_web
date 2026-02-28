package knou.lms.sys.vo;

import knou.lms.common.vo.DefaultVO;

public class SysCodeLangVO extends DefaultVO {

    private static final long serialVersionUID = -957718307094935543L;
    /** tb_sys_code_lang */
    private String  codeCtgrCd;     // 코드 분류 코드
    private String  codeCd;         // 코드
    private String  langCd;         // 언어 코드
    private String  codeNm;         // 코드 명
    private String  codeDesc;       // 코드 설명
    
    public String getCodeCtgrCd() {
        return codeCtgrCd;
    }
    public void setCodeCtgrCd(String codeCtgrCd) {
        this.codeCtgrCd = codeCtgrCd;
    }
    public String getCodeCd() {
        return codeCd;
    }
    public void setCodeCd(String codeCd) {
        this.codeCd = codeCd;
    }
    public String getLangCd() {
        return langCd;
    }
    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }
    public String getCodeNm() {
        return codeNm;
    }
    public void setCodeNm(String codeNm) {
        this.codeNm = codeNm;
    }
    public String getCodeDesc() {
        return codeDesc;
    }
    public void setCodeDesc(String codeDesc) {
        this.codeDesc = codeDesc;
    }

}
