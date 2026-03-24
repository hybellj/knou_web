package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

public class ClsVO extends DefaultVO {
    private static final long serialVersionUID = -8061054982843918999L;

    private String sbjctId;
    private String sbjctYr;
    private String sbjctSmstr;
    private String crclmnNo;
    private String sbjctnm;
    private String dvclasNo;
    private String dvclasNcknm;
    private    int crdts;
    private String profId;
    private String usernm;
    private String coProfNm; // 공동교수
    private String deptId;
    private String deptnm;
    private String smstrChrtId;
    private String useyn;
    private String delyn;
    private String searchYr;
    private String searchSmstr;
    private String univGbn;
    private String searchKeyword;

    private String tutor;   // TB_LMS_SBJCT_ADM SBJCT_ADM_TYCD = 'TUTOR'
    private String asst;    // TB_LMS_SBJCT_ADM SBJCT_ADM_TYCD = 'ASST'

    private int wkCnt;  // 전체 주차 수 (TB_LMS_SBJCT.WHOL_WK_CNT)

    public String getSbjctId() { return sbjctId; }
    public void setSbjctId(String sbjctId) { this.sbjctId = sbjctId; }

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

    public String getSearchSmstr() { return searchSmstr; }
    public void setSearchSmstr(String searchSmstr) { this.searchSmstr = searchSmstr; }

    public String getUnivGbn() { return univGbn; }
    public void setUnivGbn(String univGbn) { this.univGbn = univGbn; }

    public String getSearchKeyword() { return searchKeyword; }
    public void setSearchKeyword(String searchKeyword) { this.searchKeyword = searchKeyword; }

    public String getTutor() { return tutor; }
    public void setTutor(String tutor) { this.tutor = tutor; }

    public String getAsst() { return asst; }
    public void setAsst(String asst) { this.asst = asst; }

    public int getWkCnt() { return wkCnt; }
    public void setWkCnt(int wkCnt) { this.wkCnt = wkCnt; }
}
