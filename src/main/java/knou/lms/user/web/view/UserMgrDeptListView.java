package knou.lms.user.web.view;

import java.util.List;

import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.vo.UserMgrDeptVO;

public class UserMgrDeptListView {

    private List<OrgInfoVO> orgList;            // 기관 목록
    private List<UserMgrDeptVO> deptCodeList;   // 상위 학과/부서 코드 목록
    private String allOrgYn;                    // 전체 기관 조회 가능 여부 (Y/N)
    private String haksaSyncYn;                 // 학사연동 가져오기 버튼 노출 여부 (초기 폼 기관 기준 Y/N)

    public List<OrgInfoVO> getOrgList() {
        return orgList;
    }

    public void setOrgList(List<OrgInfoVO> orgList) {
        this.orgList = orgList;
    }

    public List<UserMgrDeptVO> getDeptCodeList() {
        return deptCodeList;
    }

    public void setDeptCodeList(List<UserMgrDeptVO> deptCodeList) {
        this.deptCodeList = deptCodeList;
    }

    public String getAllOrgYn() {
        return allOrgYn;
    }

    public void setAllOrgYn(String allOrgYn) {
        this.allOrgYn = allOrgYn;
    }

    public String getHaksaSyncYn() {
        return haksaSyncYn;
    }

    public void setHaksaSyncYn(String haksaSyncYn) {
        this.haksaSyncYn = haksaSyncYn;
    }
}
