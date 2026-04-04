package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsFdbkVO extends DefaultVO {
    
	private static final long serialVersionUID = -934507734627621118L;
	
	private String  forumFdbkCd;            // 토론 피드백 코드
    private String  forumCd;                // 토론 코드
    private String  stdId;                  // 수강생 번호
    private String  parForumFdbkCd;         // 상위 토론 피드백 코드
    private String  teamCd;                 // 팀 ID
    private String  fdbkCts;                // 피드백 내용
    private String  delYn;                  // 삭제 여부
    
    private String selectType;              //조회유형 (OBJECT, LIST, PAGING)
    
    public String getForumFdbkCd() {
        return forumFdbkCd;
    }
    public void setForumFdbkCd(String forumFdbkCd) {
        this.forumFdbkCd = forumFdbkCd;
    }
    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    public String getDscsId() {
        return forumCd;
    }
    public void setDscsId(String dscsId) {
        this.forumCd = dscsId;
    }
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public String getParForumFdbkCd() {
        return parForumFdbkCd;
    }
    public void setParForumFdbkCd(String parForumFdbkCd) {
        this.parForumFdbkCd = parForumFdbkCd;
    }
    public String getTeamCd() {
        return teamCd;
    }
    public void setTeamCd(String teamCd) {
        this.teamCd = teamCd;
    }
    public String getFdbkCts() {
        return fdbkCts;
    }
    public void setFdbkCts(String fdbkCts) {
        this.fdbkCts = fdbkCts;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getSelectType() {
        return selectType;
    }
    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }

}
