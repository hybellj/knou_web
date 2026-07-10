package knou.lms.user.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.org.vo.OrgInfoVO;

public class UserMgrListView {

    private List<OrgInfoVO> orgList;         // 기관 목록
    private List<EgovMap> authrtGrpList;     // 관리자 구분 목록 (등록페이지와 동일: ADM 권한)
    private List<CmmnCdVO> userStscdList;       // 사용자 상태 목록
    private List<EgovMap> userTyList;        // 사용자 구분 목록 (등록페이지와 동일: non-ADM 권한)
    private List<CmmnCdVO> acRcdTyList;      // 학적 상태(학적유형) 목록
    private String allOrgYn;                 // 전체 기관 조회 가능 여부 (Y/N)

    public List<OrgInfoVO> getOrgList() {
        return orgList;
    }

    public void setOrgList(List<OrgInfoVO> orgList) {
        this.orgList = orgList;
    }

    public List<EgovMap> getAuthrtGrpList() {
        return authrtGrpList;
    }

    public void setAuthrtGrpList(List<EgovMap> authrtGrpList) {
        this.authrtGrpList = authrtGrpList;
    }

    public List<CmmnCdVO> getUserStscdList() {
        return userStscdList;
    }

    public void setUserStscdList(List<CmmnCdVO> userStscdList) {
        this.userStscdList = userStscdList;
    }

    public List<EgovMap> getUserTyList() {
        return userTyList;
    }

    public void setUserTyList(List<EgovMap> userTyList) {
        this.userTyList = userTyList;
    }

    public List<CmmnCdVO> getAcRcdTyList() {
        return acRcdTyList;
    }

    public void setAcRcdTyList(List<CmmnCdVO> acRcdTyList) {
        this.acRcdTyList = acRcdTyList;
    }

    public String getAllOrgYn() {
        return allOrgYn;
    }

    public void setAllOrgYn(String allOrgYn) {
        this.allOrgYn = allOrgYn;
    }
}
