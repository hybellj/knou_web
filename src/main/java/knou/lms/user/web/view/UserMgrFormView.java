package knou.lms.user.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.file.vo.AtflVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.vo.UserMgrVO;

public class UserMgrFormView {

    private UserMgrVO detail;                // 단건 상세 (수정 시), 등록 시 null
    private List<AtflVO> photoFileList;      // 기존 프로필 사진
    private List<OrgInfoVO> orgList;         // 기관 목록
    private List<EgovMap> authrtList;        // 관리자 구분 목록
    private List<String> userAuthrtIds;      // 사용자 보유 권한 ID 목록
    private List<EgovMap> userTyAuthrtList;  // 사용자 구분 목록
    private List<CmmnCdVO> acRcdTyList;      // 학적 상태(학적유형) 목록
    private List<CmmnCdVO> dsblTyList;       // 장애 유형 목록
    private List<CmmnCdVO> dsblGrdList;      // 장애 등급 목록
    private String allOrgYn;                 // 전체 기관 조회 가능 여부 (Y/N)

    public UserMgrVO getDetail() {
        return detail;
    }

    public void setDetail(UserMgrVO detail) {
        this.detail = detail;
    }

    public List<AtflVO> getPhotoFileList() {
        return photoFileList;
    }

    public void setPhotoFileList(List<AtflVO> photoFileList) {
        this.photoFileList = photoFileList;
    }

    public List<OrgInfoVO> getOrgList() {
        return orgList;
    }

    public void setOrgList(List<OrgInfoVO> orgList) {
        this.orgList = orgList;
    }

    public List<EgovMap> getAuthrtList() {
        return authrtList;
    }

    public void setAuthrtList(List<EgovMap> authrtList) {
        this.authrtList = authrtList;
    }

    public List<String> getUserAuthrtIds() {
        return userAuthrtIds;
    }

    public void setUserAuthrtIds(List<String> userAuthrtIds) {
        this.userAuthrtIds = userAuthrtIds;
    }

    public List<EgovMap> getUserTyAuthrtList() {
        return userTyAuthrtList;
    }

    public void setUserTyAuthrtList(List<EgovMap> userTyAuthrtList) {
        this.userTyAuthrtList = userTyAuthrtList;
    }

    public List<CmmnCdVO> getAcRcdTyList() {
        return acRcdTyList;
    }

    public void setAcRcdTyList(List<CmmnCdVO> acRcdTyList) {
        this.acRcdTyList = acRcdTyList;
    }

    public List<CmmnCdVO> getDsblTyList() {
        return dsblTyList;
    }

    public void setDsblTyList(List<CmmnCdVO> dsblTyList) {
        this.dsblTyList = dsblTyList;
    }

    public List<CmmnCdVO> getDsblGrdList() {
        return dsblGrdList;
    }

    public void setDsblGrdList(List<CmmnCdVO> dsblGrdList) {
        this.dsblGrdList = dsblGrdList;
    }

    public String getAllOrgYn() {
        return allOrgYn;
    }

    public void setAllOrgYn(String allOrgYn) {
        this.allOrgYn = allOrgYn;
    }
}
