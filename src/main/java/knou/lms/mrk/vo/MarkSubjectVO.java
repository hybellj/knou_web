package knou.lms.mrk.vo;

import knou.lms.common.vo.DefaultVO;

import java.math.BigDecimal;

/**
 * TB_LMS_MRK_SBJCT (성적과목)
 */
public class MarkSubjectVO extends DefaultVO {

	private static final long serialVersionUID = 36784384581333335L;
	
	private String sbjctMrkId;      // 성적과목 아이디
    private String scrMrkGrdCd;     // 점수 성적 등급코드
    private String scrCnvsStscd;    // 점수 환산 상태코드
    private String profMemo;        // 교수 메모
    private String drvtnMrkGrdcd;   // 산출성적 등급코드
    private String passyn;          // 통과여부

    private BigDecimal totScr;          // 총점 (성정항목별 평가점수 합)
    private BigDecimal adtnScr;         // 가산 점수 (성적 이의신청으로 얻은 점수)
    private BigDecimal etcScr;          // 기타 점수 (성적관리에서 교수가 임의대로 추가하는 점수)
    private BigDecimal lstScr;          // 최종 점수 (총점 + 가산점수 + 기타점수)

    private String sbjctMrkListStr;

    private String stdntNo;         // 학번

    public MarkSubjectVO() {};

    public MarkSubjectVO(String sbjctId, String sbjctMrkId, String userId) {
        super();
        this.sbjctMrkId = sbjctMrkId;
        this.setSbjctId(sbjctId);
        this.setUserId(userId);
    };

    public MarkSubjectVO(String sbjctId, String userId, BigDecimal totScr, BigDecimal lstScr, BigDecimal adtnScr) {
        super();
        this.setSbjctId(sbjctId);
        this.setUserId(userId);
        this.totScr = totScr;
        this.lstScr = lstScr;
        this.adtnScr = adtnScr;
    };

    public String getSbjctMrkId() {
        return sbjctMrkId;
    }

    public void setSbjctMrkId(String sbjctMrkId) {
        this.sbjctMrkId = sbjctMrkId;
    }

    public String getScrMrkGrdCd() {
        return scrMrkGrdCd;
    }

    public void setScrMrkGrdCd(String scrMrkGrdCd) {
        this.scrMrkGrdCd = scrMrkGrdCd;
    }

    public String getScrCnvsStscd() {
        return scrCnvsStscd;
    }

    public void setScrCnvsStscd(String scrCnvsStscd) {
        this.scrCnvsStscd = scrCnvsStscd;
    }

    public String getProfMemo() {
        return profMemo;
    }

    public void setProfMemo(String profMemo) {
        this.profMemo = profMemo;
    }

    public String getDrvtnMrkGrdcd() {
        return drvtnMrkGrdcd;
    }

    public void setDrvtnMrkGrdcd(String drvtnMrkGrdcd) {
        this.drvtnMrkGrdcd = drvtnMrkGrdcd;
    }

    public String getPassyn() {
        return passyn;
    }

    public void setPassyn(String passyn) {
        this.passyn = passyn;
    }

    public BigDecimal getLstScr() {
        return lstScr;
    }

    public void setLstScr(BigDecimal lstScr) {
        this.lstScr = lstScr;
    }

    public BigDecimal getAdtnScr() {
        return adtnScr;
    }

    public void setAdtnScr(BigDecimal adtnScr) {
        this.adtnScr = adtnScr;
    }

    public BigDecimal getTotScr() {
        return totScr;
    }

    public void setTotScr(BigDecimal totScr) {
        this.totScr = totScr;
    }

    public BigDecimal getEtcScr() {
        return etcScr;
    }

    public void setEtcScr(BigDecimal etcScr) {
        this.etcScr = etcScr;
    }

    /*
        ***stdMrkList***
        - Outer Map Key: userId
        - Inner Map Key: mrkItmTycd
        => {"user12": { "ASMT": 90, "DSCS": 80, ... , "etcScr": 5},
            "user13": { "ASMT": 90, "DSCS": 80, ... , "etcScr": 5},
            ...
           }
     */
    public String getSbjctMrkListStr() {
        return sbjctMrkListStr;
    }

    public void setSbjctMrkListStr(String sbjctMrkListStr) {
        this.sbjctMrkListStr = sbjctMrkListStr;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }
}
