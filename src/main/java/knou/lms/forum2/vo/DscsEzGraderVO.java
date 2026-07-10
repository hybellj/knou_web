package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsEzGraderVO extends DefaultVO {
	
	private static final long serialVersionUID = 7100179735049056024L;
	
	private String dscsId;      // 토론아이디
    private String sbjctId;     // 과목아이디
    private String stdId;       // 사용자아이디
    private String teamId;      // 팀아이디
    private String evlScrTycd;  // 평가점수유형코드

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
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

    public String getEvlScrTycd() {
        return evlScrTycd;
    }

    public void setEvlScrTycd(String evlScrTycd) {
        this.evlScrTycd = evlScrTycd;
    }

}
