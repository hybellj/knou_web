package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsFdbkVO extends DefaultVO {
    
	private static final long serialVersionUID = -934507734627621118L;
	
	private String  forumFdbkCd;            // ?좊줎 ?쇰뱶諛?肄붾뱶
    private String  dscsId;                 // ?좊줎 肄붾뱶
    private String  stdId;                  // ?섍컯??踰덊샇
    private String  parForumFdbkCd;         // ?곸쐞 ?좊줎 ?쇰뱶諛?肄붾뱶
    private String  teamId;                 // ? ID
    private String  fdbkCts;                // ?쇰뱶諛??댁슜
    private String  delYn;                  // ??젣 ?щ?
    
    private String selectType;              //議고쉶?좏삎 (OBJECT, LIST, PAGING)
    
    public String getForumFdbkCd() {
        return forumFdbkCd;
    }
    public void setForumFdbkCd(String forumFdbkCd) {
        this.forumFdbkCd = forumFdbkCd;
    }
    public String getDscsId() {
        return dscsId;
    }
    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
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
    public String getTeamId() {
        return teamId;
    }
    public void setTeamId(String teamId) {
        this.teamId = teamId;
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
