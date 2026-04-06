package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsEzGraderVO extends DefaultVO {
	
	private static final long serialVersionUID = 7100179735049056024L;
	
	private String dscsId;
    private String orgId;                  // 기관 코드
    private String sbjctId;
    private String stdId;
    private String teamId;
    private String evalCd;
    
    private String evalCritUseYn;          // 평가기준사용여부
    private String evalCtgr;               // 평가방식(R : 루브릭)

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
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
