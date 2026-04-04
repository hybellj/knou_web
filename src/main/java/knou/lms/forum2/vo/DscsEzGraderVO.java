package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsEzGraderVO extends DefaultVO {
	
	private static final long serialVersionUID = 7100179735049056024L;
	
	private String forumCd;
    private String orgId;                  // 기관 코드
    private String crsCreCd;
    private String stdId;
    private String teamCd;
    private String evalCd;
    
    private String evalCritUseYn;          // 평가기준사용여부
    private String evalCtgr;               // 평가방식(R : 루브릭)

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

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getTeamCd() {
        return teamCd;
    }

    public void setTeamCd(String teamCd) {
        this.teamCd = teamCd;
    }

    public String getEvalCritUseYn() {
        return evalCritUseYn;
    }

    public void setEvalCritUseYn(String evalCritUseYn) {
        this.evalCritUseYn = evalCritUseYn;
    }

	public String getEvalCtgr() {
		return evalCtgr;
	}

	public void setEvalCtgr(String evalCtgr) {
		this.evalCtgr = evalCtgr;
	}
    public String getEvlScrTycd() {
        return evalCtgr;
    }

    public void setEvlScrTycd(String evlScrTycd) {
        this.evalCtgr = evlScrTycd;
    }

	public String getEvalCd() {
		return evalCd;
	}

	public void setEvalCd(String evalCd) {
		this.evalCd = evalCd;
	}

}
