package knou.lms.user.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 학과부서
 * TB_LMS_DEPT
 */
public class UsrDeptCdVO extends DefaultVO {

    private static final long serialVersionUID = -374363516904145789L;
    
    private String  deptId;         // 부서 코드
    private String  deptnm;         // 부서(학과) 명
    private String  deptEnnm;       // 부서(학과) 명(영문)
    private String  upDeptId;      // 상위 부서 코드
    
    
    public String getDeptId() {
        return deptId;
    }
    public void setDeptId(String deptCd) {
        this.deptId = deptCd;
    }
    public String getDeptnm() {
        return deptnm;
    }
    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }
    public String getDeptEnnm() {
        return deptEnnm;
    }
    public void setDeptEnnm(String deptEnnm) {
        this.deptEnnm = deptEnnm;
    }
    public String getUpDeptId() {
        return upDeptId;
    }
    public void setUpDeptId(String upDeptId) {
        this.upDeptId = upDeptId;
    }
}
