package knou.lms.sys.vo;

import knou.lms.common.vo.DefaultVO;

public class SysCodeCtgrVO extends DefaultVO {

    private static final long serialVersionUID = 4201445044949374313L;
    /** tb_sys_code_ctgr */
    private String  codeCtgrCd;     // 코드 분류 코드
    private String  sysTypeCd;      // 시스템 유형코드
    private String  codeCtgrNm;     // 코드 분류 명
    private String  codeCtgrDesc;   // 코드 분류 설명
    private Integer codeCtgrOdr;    // 코드 분류 순서
    private String  useYn;          // 사용 여부
    
    public String getCodeCtgrCd() {
        return codeCtgrCd;
    }
    public void setCodeCtgrCd(String codeCtgrCd) {
        this.codeCtgrCd = codeCtgrCd;
    }
    public String getSysTypeCd() {
        return sysTypeCd;
    }
    public void setSysTypeCd(String sysTypeCd) {
        this.sysTypeCd = sysTypeCd;
    }
    public String getCodeCtgrNm() {
        return codeCtgrNm;
    }
    public void setCodeCtgrNm(String codeCtgrNm) {
        this.codeCtgrNm = codeCtgrNm;
    }
    public String getCodeCtgrDesc() {
        return codeCtgrDesc;
    }
    public void setCodeCtgrDesc(String codeCtgrDesc) {
        this.codeCtgrDesc = codeCtgrDesc;
    }
    public Integer getCodeCtgrOdr() {
        return codeCtgrOdr;
    }
    public void setCodeCtgrOdr(Integer codeCtgrOdr) {
        this.codeCtgrOdr = codeCtgrOdr;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

}
