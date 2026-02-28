package knou.lms.file.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("lmsTermVO")
public class LmsTermVO extends DefaultVO {

    private static final long serialVersionUID = -484409939756667137L;
    
    // 검색
    private String termCd;
    private String termNm;
    private String userOrgId;

    /** @return termCd 값을 반환한다. */
    public String getTermCd() { 
        return termCd;
    }

    /**
     * @param termCd을 termCd 에 저장한다.
     */
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }

    /** @return termNm 값을 반환한다. */
    public String getTermNm() {
        return termNm;
    }

    /**
     * @param termNm을 termNm 에 저장한다.
     */
    public void setTermNm(String termNm) {
        this.termNm = termNm;
    }

    /** @return userOrgId 값을 반환한다. */
    public String getUserOrgId() {
        return userOrgId;
    }

    /**
     * @param userOrgId
     *            을 userOrgId 에 저장한다.
     */
    public void setUserOrgId(String userOrgId) {
        this.userOrgId = userOrgId;
    }

}
