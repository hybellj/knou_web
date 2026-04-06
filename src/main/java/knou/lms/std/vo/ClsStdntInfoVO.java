package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 수강생 상세정보 VO
 */
public class ClsStdntInfoVO extends DefaultVO {
    private static final long serialVersionUID = 3921047865412309871L;

    private String usernm;      // 이름
    private String stdntNo;     // 학번
    private String mobileNo;    // 휴대폰번호
    private String email;       // 이메일
    private String orgNm;       // 기관명
    private String photoUrl;    // 사진 URL




    public String getUsernm()  { return usernm; }
    public void setUsernm(String usernm) { this.usernm = usernm; }

    public String getStdntNo() { return stdntNo; }
    public void setStdntNo(String stdntNo) { this.stdntNo = stdntNo; }

    public String getMobileNo() { return mobileNo; }
    public void setMobileNo(String mobileNo) { this.mobileNo = mobileNo; }

    public String getEmail()   { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getOrgNm()   { return orgNm; }
    public void setOrgNm(String orgNm) { this.orgNm = orgNm; }

    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }
}