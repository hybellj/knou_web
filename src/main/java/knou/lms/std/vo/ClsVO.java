package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 전체수업현황 - 과목/분반 기본정보 VO
 * 공통 필드(orgId, userId, sbjctId, rgtrId, mdfrId, menuId, upMenuId, paging/search 등)는 DefaultVO 상속 필드를 사용한다.
 **/

public class ClsVO extends DefaultVO {
    private static final long serialVersionUID = -8061054982843918999L;

    private String sbjctYr; // 과목년도
    private String sbjctSmstr; // 과목 학기
    private String crclmnNo; // 교육과정 번호
    private String sbjctnm; // 과목명
    private String dvclasNo; // 분반 번호
    private String dvclasNcknm; // 분반 별칭
    private    int crdts; // 학점
    private String profId; // 당당교수 ID
    private String usernm; // 담당교수명
    private String coProfNm; // 공동교수명
    private String deptId; // 학과 ID
    private String deptnm; // 학과명
    private String smstrChrtId; // 학기차수 ID
    private String useyn; // 사용 여부
    private String delyn; // 삭제 여부
    private String searchYr; // 검색년도
    private String searchOrgId; // 검색 조직 ID
    private String searchKeyword; // 검색어

    private String tutor;   // 튜터명
    private String asst;    // 조교명

    private int wkCnt;  // 전체 주차 수 (TB_LMS_SBJCT.WHOL_WK_CNT)



    public String getSbjctYr() { return sbjctYr; }
    public void setSbjctYr(String sbjctYr) { this.sbjctYr = sbjctYr; }

    public String getSbjctSmstr() { return sbjctSmstr; }
    public void setSbjctSmstr(String sbjctSmstr) { this.sbjctSmstr = sbjctSmstr; }

    public String getCrclmnNo() { return crclmnNo; }
    public void setCrclmnNo(String crclmnNo) { this.crclmnNo = crclmnNo; }

    public String getSbjctnm() { return sbjctnm; }
    public void setSbjctnm(String sbjctnm) { this.sbjctnm = sbjctnm; }

    public String getDvclasNo() { return dvclasNo; }
    public void setDvclasNo(String dvclasNo) { this.dvclasNo = dvclasNo; }

    public String getDvclasNcknm() { return dvclasNcknm; }
    public void setDvclasNcknm(String dvclasNcknm) { this.dvclasNcknm = dvclasNcknm; }

    public int getCrdts() { return crdts; }
    public void setCrdts(int crdts) { this.crdts = crdts; }

    public String getProfId() { return profId; }
    public void setProfId(String profId) { this.profId = profId; }

    public String getUsernm() { return usernm; }
    public void setUsernm(String usernm) { this.usernm = usernm; }

    public String getCoProfNm() { return coProfNm; }
    public void setCoProfNm(String coProfNm) { this.coProfNm = coProfNm; }

    public String getDeptId() { return deptId; }
    public void setDeptId(String deptId) { this.deptId = deptId; }

    public String getDeptnm() { return deptnm; }
    public void setDeptnm(String deptnm) { this.deptnm = deptnm; }

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getUseyn() { return useyn; }
    public void setUseyn(String useyn) { this.useyn = useyn; }

    public String getDelyn() { return delyn; }
    public void setDelyn(String delyn) { this.delyn = delyn; }

    public String getSearchYr() { return searchYr; }
    public void setSearchYr(String searchYr) { this.searchYr = searchYr; }

    public String getSearchOrgId() { return searchOrgId; }
    public void setSearchOrgId(String searchOrgId) { this.searchOrgId = searchOrgId; }

    public String getSearchKeyword() { return searchKeyword; }
    public void setSearchKeyword(String searchKeyword) { this.searchKeyword = searchKeyword; }

    public String getTutor() { return tutor; }
    public void setTutor(String tutor) { this.tutor = tutor; }

    public String getAsst() { return asst; }
    public void setAsst(String asst) { this.asst = asst; }

    public int getWkCnt() { return wkCnt; }
    public void setWkCnt(int wkCnt) { this.wkCnt = wkCnt; }
}
