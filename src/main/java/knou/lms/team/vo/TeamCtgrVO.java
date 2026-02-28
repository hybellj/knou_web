package knou.lms.team.vo;

import knou.lms.common.vo.DefaultVO;

public class TeamCtgrVO extends TeamVO {
    // TB_LMS_TEAM_CTGR
    private String teamCtgrCd;
    private String crsCreCd;
    private String orgId;
    private String teamCtgrNm;

    private String teamBbsYn;
    private String teamSetYn;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;

    private String regNm;
    private String teamCnt;

    private int asmntCnt;
    private int forumCnt;

    private String lrnGrpId;	// 학습그룹아이디
    private String lrnGrpnm;	// 학습그룹명

    public String getTeamCtgrCd() {
        return teamCtgrCd;
    }

    public void setTeamCtgrCd(String teamCtgrCd) {
        this.teamCtgrCd = teamCtgrCd;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getTeamCtgrNm() {
        return teamCtgrNm;
    }

    public void setTeamCtgrNm(String teamCtgrNm) {
        this.teamCtgrNm = teamCtgrNm;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public String getTeamBbsYn() {
        return teamBbsYn;
    }

    public void setTeamBbsYn(String teamBbsYn) {
        this.teamBbsYn = teamBbsYn;
    }

    public String getRegNm() {
        return regNm;
    }

    public void setRegNm(String regNm) {
        this.regNm = regNm;
    }

    public String getTeamCnt() {
        return teamCnt;
    }

    public void setTeamCnt(String teamCnt) {
        this.teamCnt = teamCnt;
    }

	public String getTeamSetYn() {
		return teamSetYn;
	}

	public void setTeamSetYn(String teamSetYn) {
		this.teamSetYn = teamSetYn;
	}

	public int getAsmntCnt() {
		return asmntCnt;
	}

	public void setAsmntCnt(int asmntCnt) {
		this.asmntCnt = asmntCnt;
	}

	public int getForumCnt() {
		return forumCnt;
	}

	public void setForumCnt(int forumCnt) {
		this.forumCnt = forumCnt;
	}

	public String getLrnGrpId() {
		return lrnGrpId;
	}

	public String getLrnGrpnm() {
		return lrnGrpnm;
	}

	public void setLrnGrpId(String lrnGrpId) {
		this.lrnGrpId = lrnGrpId;
	}

	public void setLrnGrpnm(String lrnGrpnm) {
		this.lrnGrpnm = lrnGrpnm;
	}

}