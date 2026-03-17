package knou.lms.mrk.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * TB_LMS_MRK_SBJCT (성적과목)
 */
public class MarkSubjectVO extends DefaultVO {

	private static final long serialVersionUID = 36784384581333335L;
	
	private String mrkSbjctId;      // 성적과목 아이디
    private String scrMrkGrdCd;     // 점수 성적 등급코드
    private String scrCnvsStscd;    // 점수 환산 상태코드
    private String profMemo;        // 교수 메모
    private String drvtnMrkGrdcd;   // 산출성적 등급코드
    private String passyn;          // 통과여부
    private int totScr;             // 총점 (최종점수 + 가산점수)
    private int lstScr;             // 최종 점수 (총점 - 가산점수)
    private int adtnScr;            // 가산 점수 (= 기타점수)


    public String getMrkSbjctId() {
        return mrkSbjctId;
    }

    public void setMrkSbjctId(String mrkSbjctId) {
        this.mrkSbjctId = mrkSbjctId;
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

    public int getTotScr() {
        return totScr;
    }

    public void setTotScr(int totScr) {
        this.totScr = totScr;
    }

    public int getLstScr() {
        return lstScr;
    }

    public void setLstScr(int lstScr) {
        this.lstScr = lstScr;
    }

    public int getAdtnScr() {
        return adtnScr;
    }

    public void setAdtnScr(int adtnScr) {
        this.adtnScr = adtnScr;
    }
}
