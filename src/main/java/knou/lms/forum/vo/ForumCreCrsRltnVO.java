package knou.lms.forum.vo;

import knou.lms.common.vo.DefaultVO;

public class ForumCreCrsRltnVO extends DefaultVO {

    private String crsCreCd;    // 과정개설코드
    private String forumCd;     // 토콘 코드
    private String grpCd;       // 그룹코드
    private String delYn;       // 삭제여부
    
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    public String getGrpCd() {
        return grpCd;
    }
    public void setGrpCd(String grpCd) {
        this.grpCd = grpCd;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

}
