package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class Forum2TeamDtlVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String subdscsId;  // 부토론아이디
    private String dscsId;     // 토론아이디
    private String subdscsTtl; // 부토론제목
    private String subdscsCts; // 부토론내용
    private String teamId;     // 팀아이디
    private String teamnm;     // 팀이름
    private String rgtrId;     // 등록자아이디
    private String regDttm;    // 등록일시 (YYYYMMDDHH24MISS)
    private String mdfrId;     // 수정자아이디
    private String modDttm;    // 수정일시 (YYYYMMDDHH24MISS)

    // DB Field 외의 값.
    private String groupMembers; // 학습그룹 구성원 요약(Ex: 홍팀장1 외 11)

    public String getSubdscsId() {
        return subdscsId;
    }

    public void setSubdscsId(String subdscsId) {
        this.subdscsId = subdscsId;
    }

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getSubdscsTtl() {
        return subdscsTtl;
    }

    public void setSubdscsTtl(String subdscsTtl) {
        this.subdscsTtl = subdscsTtl;
    }

    public String getSubdscsCts() {
        return subdscsCts;
    }

    public void setSubdscsCts(String subdscsCts) {
        this.subdscsCts = subdscsCts;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public String getTeamnm() {
        return teamnm;
    }

    public void setTeamnm(String teamnm) {
        this.teamnm = teamnm;
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

    public String getGroupMembers() {
        return groupMembers;
    }

    public void setGroupMembers(String groupMembers) {
        this.groupMembers = groupMembers;
    }
}
