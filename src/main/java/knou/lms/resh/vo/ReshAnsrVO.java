package knou.lms.resh.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ReshAnsrVO extends DefaultVO {
	private static final long serialVersionUID = 4698530020934037323L;
	
	/** tb_lms_resch_ansr */
    private String		reschAnsrCd;        // 설문 응답 고유번호
    private String		reschCd;            // 설문 고유번호
    private String		reschQstnCd;        // 설문 항목 고유번호
    private String		reschQstnItemCd;    // 설문 함옥 선택지 고유번호
    private String		reschScaleCd;       // 설문 척도 고유번호
    private String		etcOpinion;         // 기타 의견
    
    /** tb_lms_resch_join_User */
    private String		stdId;              // 수강생 번호
    private String		deviceTypeCd;       // 접속 환경 코드
    private String		connIp;             // 접속 IP
    private Double		score;              // 점수
    private String		evalYn;             // 평가 여부
    private String		profMemo;           // 교수 메모
    
    private List<String> reshQstnCdList;    // 설문제출시 사용
    private List<String> etcOpinionList;    // 설문제출시 사용
    private List<String> reshAnswerList;    // 설문제출시 사용
    private List<String> reschQstnCds;      // 문항 삭제 전 확인시 사용
    
    private String scoreType;           // 점수 저장용  
    private String userIds;             // 점수 저장용
    private String deptNm;
    
    public String getReschAnsrCd() {
        return reschAnsrCd;
    }
    public void setReschAnsrCd(String reschAnsrCd) {
        this.reschAnsrCd = reschAnsrCd;
    }
    public String getReschCd() {
        return reschCd;
    }
    public void setReschCd(String reschCd) {
        this.reschCd = reschCd;
    }
    public String getReschQstnCd() {
        return reschQstnCd;
    }
    public void setReschQstnCd(String reschQstnCd) {
        this.reschQstnCd = reschQstnCd;
    }
    public String getReschQstnItemCd() {
        return reschQstnItemCd;
    }
    public void setReschQstnItemCd(String reschQstnItemCd) {
        this.reschQstnItemCd = reschQstnItemCd;
    }
    public String getReschScaleCd() {
        return reschScaleCd;
    }
    public void setReschScaleCd(String reschScaleCd) {
        this.reschScaleCd = reschScaleCd;
    }
    public String getEtcOpinion() {
        return etcOpinion;
    }
    public void setEtcOpinion(String etcOpinion) {
        this.etcOpinion = etcOpinion;
    }
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public String getDeviceTypeCd() {
        return deviceTypeCd;
    }
    public void setDeviceTypeCd(String deviceTypeCd) {
        this.deviceTypeCd = deviceTypeCd;
    }
    public String getConnIp() {
        return connIp;
    }
    public void setConnIp(String connIp) {
        this.connIp = connIp;
    }
    public List<String> getReshQstnCdList() {
        return reshQstnCdList;
    }
    public void setReshQstnCdList(List<String> reshQstnCdList) {
        this.reshQstnCdList = reshQstnCdList;
    }
    public List<String> getEtcOpinionList() {
        return etcOpinionList;
    }
    public void setEtcOpinionList(List<String> etcOpinionList) {
        this.etcOpinionList = etcOpinionList;
    }
    public List<String> getReshAnswerList() {
        return reshAnswerList;
    }
    public void setReshAnswerList(List<String> reshAnswerList) {
        this.reshAnswerList = reshAnswerList;
    }
    public List<String> getReschQstnCds() {
        return reschQstnCds;
    }
    public void setReschQstnCds(List<String> reschQstnCds) {
        this.reschQstnCds = reschQstnCds;
    }
    public String getEvalYn() {
        return evalYn;
    }
    public void setEvalYn(String evalYn) {
        this.evalYn = evalYn;
    }
    public String getProfMemo() {
        return profMemo;
    }
    public void setProfMemo(String profMemo) {
        this.profMemo = profMemo;
    }
    public Double getScore() {
        return score;
    }
    public void setScore(Double score) {
        this.score = score;
    }
    public String getScoreType() {
        return scoreType;
    }
    public void setScoreType(String scoreType) {
        this.scoreType = scoreType;
    }
    public String getUserIds() {
        return userIds;
    }
    public void setUserIds(String userIds) {
        this.userIds = userIds;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    
}
