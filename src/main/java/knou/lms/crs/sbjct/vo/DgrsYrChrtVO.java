package knou.lms.crs.sbjct.vo;

import knou.lms.common.vo.DefaultVO;

public class DgrsYrChrtVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String smstrChrtId;                 // 학기기수아이디
    private String orgId;                       // 기관아이디
    private String dgrsYr;                      // 학위연도
    private String dgrsSmstrChrt;               // 학위학기기수
    private String smstrChrtNm;                 // 학기기수명
    private String nowSmstrYn;                  // 현재학기여부

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getOrgId() { return orgId; }
    public void setOrgId(String orgId) { this.orgId = orgId; }

    public String getDgrsYr() { return dgrsYr; }
    public void setDgrsYr(String dgrsYr) { this.dgrsYr = dgrsYr; }

    public String getDgrsSmstrChrt() { return dgrsSmstrChrt; }
    public void setDgrsSmstrChrt(String dgrsSmstrChrt) { this.dgrsSmstrChrt = dgrsSmstrChrt; }

    public String getSmstrChrtNm() { return smstrChrtNm; }
    public void setSmstrChrtNm(String smstrChrtNm) { this.smstrChrtNm = smstrChrtNm; }

    public String getNowSmstrYn() { return nowSmstrYn; }
    public void setNowSmstrYn(String nowSmstrYn) { this.nowSmstrYn = nowSmstrYn; }
}
