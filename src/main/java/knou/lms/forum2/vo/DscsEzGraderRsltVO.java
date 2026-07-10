package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsEzGraderRsltVO extends DefaultVO {

    private String dscsId; // 토론아이디
    private String stdId; // 사용자아이디
    private String stdIds; // EZ-Grader 점수 처리 대상 학습자 목록
    private String teamId; // 팀아이디
    private Double scr; // 점수
    private String evlyn; // 평가여부

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

    public String getStdIds() {
        return stdIds;
    }

    public void setStdIds(String stdIds) {
        this.stdIds = stdIds;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public Double getScr() {
        return scr;
    }

    public void setScr(Double scr) {
        this.scr = scr;
    }

    public String getEvlyn() {
        return evlyn;
    }

    public void setEvlyn(String evlyn) {
        this.evlyn = evlyn;
    }
}
