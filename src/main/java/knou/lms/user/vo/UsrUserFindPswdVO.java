package knou.lms.user.vo;

import knou.lms.common.vo.DefaultVO;

public class UsrUserFindPswdVO extends DefaultVO {

    private static final long serialVersionUID = -1033591414075017199L;
    
    /** tb_home_user_find_pswd */
    private String  userFindPswdSn;     // 회원 비밀번호 찾기 고유번호
    private String  findPswdTypeCd;     // 비밀번호 찾기 유형 코드
    private String  senderNm;           // 발송자 명
    private String  senderEmail;        // 발송자 이메일
    private String  title;              // 제목
    private String  cts;                // 내용
    
    public String getUserFindPswdSn() {
        return userFindPswdSn;
    }
    public void setUserFindPswdSn(String userFindPswdSn) {
        this.userFindPswdSn = userFindPswdSn;
    }
    public String getFindPswdTypeCd() {
        return findPswdTypeCd;
    }
    public void setFindPswdTypeCd(String findPswdTypeCd) {
        this.findPswdTypeCd = findPswdTypeCd;
    }
    public String getSenderNm() {
        return senderNm;
    }
    public void setSenderNm(String senderNm) {
        this.senderNm = senderNm;
    }
    public String getSenderEmail() {
        return senderEmail;
    }
    public void setSenderEmail(String senderEmail) {
        this.senderEmail = senderEmail;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getCts() {
        return cts;
    }
    public void setCts(String cts) {
        this.cts = cts;
    }
    
}
