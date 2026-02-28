package knou.lms.user.vo;

import knou.lms.common.vo.DefaultVO;

public class UsrEmailAuthVO extends DefaultVO {

    private static final long serialVersionUID = 7136072960656671271L;
    /** tb_home_user_email_auth */
    private String  userEmailAuthId;        // 회원 이메일 인증 아이디
    private String  useYn;                  // 사용 여부
    private String  senderNm;               // 발송자 명
    private String  senderEmail;            // 발송자 이메일
    private String  title;                  // 제목
    private String  cts;                    // 내용
    
    public String getUserEmailAuthId() {
        return userEmailAuthId;
    }
    public void setUserEmailAuthId(String userEmailAuthId) {
        this.userEmailAuthId = userEmailAuthId;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
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
