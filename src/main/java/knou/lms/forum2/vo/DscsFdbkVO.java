package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsFdbkVO extends DefaultVO {
    
	private static final long serialVersionUID = -934507734627621118L;
	
	private String  dscsFdbkId;             // 토론 피드백 ID
    private String  dscsId;                 // 토론 코드
    private String  stdId;                  // 수강생 번호
    private String  upDscsFdbkId;           // 상위 토론 피드백 ID
    private String  teamId;                 // 팀 ID
    private String  fdbkCts;                // 피드백 내용
    private String  delYn;                  // 삭제 여부
    
    private String selectType;              // 조회유형 (OBJECT, LIST, PAGING)
    
    public String getDscsFdbkId() {
        return dscsFdbkId;
    }
    public void setDscsFdbkId(String dscsFdbkId) {
        this.dscsFdbkId = dscsFdbkId;
    }
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
    public String getUpDscsFdbkId() {
        return upDscsFdbkId;
    }
    public void setUpDscsFdbkId(String upDscsFdbkId) {
        this.upDscsFdbkId = upDscsFdbkId;
    }
    public String getTeamId() {
        return teamId;
    }
    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }
    public String getFdbkCts() {
        return fdbkCts;
    }
    public void setFdbkCts(String fdbkCts) {
        this.fdbkCts = fdbkCts;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getSelectType() {
        return selectType;
    }
    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }

}
