package knou.lms.menu.vo;

import java.util.List;

public class AdmAuthSaveVO {
    private String authrtChgCts;          // 변경 사유
    private List<SysAuthGrpVO> admList; // 관리자 목록

    public String getAuthrtChgCts() { return authrtChgCts; }
    public void setAuthrtChgCts(String authrtChgCts) { this.authrtChgCts = authrtChgCts; }

    public List<SysAuthGrpVO> getAdmList() { return admList; }
    public void setAdmList(List<SysAuthGrpVO> admList) { this.admList = admList; }
}