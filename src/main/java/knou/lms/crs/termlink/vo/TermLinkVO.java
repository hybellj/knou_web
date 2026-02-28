package knou.lms.crs.termlink.vo;

import knou.lms.common.vo.DefaultVO;

public class TermLinkVO extends DefaultVO {

    private static final long serialVersionUID = 3878411119566881006L;
    private String  userId;         // 사용자 번호
    private String  userType;       // 사용자 구분
    private String  autoLinkYn;     // 자동연동여부(Y : 자동연동, N : 수동연동)
    private String  termCd;         // 학기/기수 코드
    private String  linkType;       // 연동 유향
    private String  resultYn;       // 결과여부(Y : 성공, N : 실패)
    private Integer insertCnt;      // 입력건수
    private Integer updaetCnt;      // 수정건수
    private Integer deleteCnt;      // 삭제건수
    private String  updateDttm;     // 업데이트 일시
    
    private String  errorMsg;       // 에러메세지

    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getUserType() {
        return userType;
    }
    public void setUserType(String userType) {
        this.userType = userType;
    }
    public String getAutoLinkYn() {
        return autoLinkYn;
    }
    public void setAutoLinkYn(String autoLinkYn) {
        this.autoLinkYn = autoLinkYn;
    }
    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }
    public String getLinkType() {
        return linkType;
    }
    public void setLinkType(String linkType) {
        this.linkType = linkType;
    }
    public String getResultYn() {
        return resultYn;
    }
    public void setResultYn(String resultYn) {
        this.resultYn = resultYn;
    }
    public Integer getInsertCnt() {
        return insertCnt;
    }
    public void setInsertCnt(Integer insertCnt) {
        this.insertCnt = insertCnt;
    }
    public Integer getUpdaetCnt() {
        return updaetCnt;
    }
    public void setUpdaetCnt(Integer updaetCnt) {
        this.updaetCnt = updaetCnt;
    }
    public Integer getDeleteCnt() {
        return deleteCnt;
    }
    public void setDeleteCnt(Integer deleteCnt) {
        this.deleteCnt = deleteCnt;
    }
    public String getUpdateDttm() {
        return updateDttm;
    }
    public void setUpdateDttm(String updateDttm) {
        this.updateDttm = updateDttm;
    }
    public String getErrorMsg() {
        return errorMsg;
    }
    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

}
