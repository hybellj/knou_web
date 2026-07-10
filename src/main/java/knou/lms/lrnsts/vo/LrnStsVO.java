package knou.lms.lrnsts.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 나의 학습현황 목록/검색 VO
 */
public class LrnStsVO extends DefaultVO {
    private static final long serialVersionUID = -644084095284974423L;

    // 목록 표시용 필드
    private String sbjctYr;        // 과목 연도
    private String sbjctSmstr;     // 과목 학기
    private String orgNm;          // 기관명
    private String dvclasNo;       // 분반번호
    private int    crdts;          // 학점
    private String coProfNm;       // 공동교수명
    private String tutor;          // 튜터명
    private String asst;           // 조교명

    // 검색 조건
    private String searchYr;       // 검색 연도
    private String smstrChrtId;    // 학기 차트 ID
    private String searchOrgId;    // 검색 기관 ID
    private String searchSbjctId;  // 검색 과목 ID

    public String getSbjctYr() { return sbjctYr; }
    public void setSbjctYr(String sbjctYr) { this.sbjctYr = sbjctYr; }

    public String getSbjctSmstr() { return sbjctSmstr; }
    public void setSbjctSmstr(String sbjctSmstr) { this.sbjctSmstr = sbjctSmstr; }

    public String getOrgNm() { return orgNm; }
    public void setOrgNm(String orgNm) { this.orgNm = orgNm; }

    public String getDvclasNo() { return dvclasNo; }
    public void setDvclasNo(String dvclasNo) { this.dvclasNo = dvclasNo; }

    public int getCrdts() { return crdts; }
    public void setCrdts(int crdts) { this.crdts = crdts; }

    public String getCoProfNm() { return coProfNm; }
    public void setCoProfNm(String coProfNm) { this.coProfNm = coProfNm; }

    public String getTutor() { return tutor; }
    public void setTutor(String tutor) { this.tutor = tutor; }

    public String getAsst() { return asst; }
    public void setAsst(String asst) { this.asst = asst; }

    public String getSearchYr() { return searchYr; }
    public void setSearchYr(String searchYr) { this.searchYr = searchYr; }

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getSearchOrgId() { return searchOrgId; }
    public void setSearchOrgId(String searchOrgId) { this.searchOrgId = searchOrgId; }

    public String getSearchSbjctId() { return searchSbjctId; }
    public void setSearchSbjctId(String searchSbjctId) { this.searchSbjctId = searchSbjctId; }
}
