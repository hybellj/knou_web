package knou.lms.mrk.vo;

import knou.lms.common.vo.DefaultVO;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;

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
    private double totScr;          // 총점 (성정항목별 평가점수 합)
    private double adtnScr;         // 가산 점수 (성적 이의신청으로 얻은 점수)
    private double etcScr;          // 기타 점수 (성적관리에서 교수가 임의대로 추가하는 점수)
    private double lstScr;          // 최종 점수 (총점 + 가산점수 + 기타점수)

    public MarkSubjectVO() {};

    public MarkSubjectVO(String sbjctId, String userId, double totScr, double lstScr, double adtnScr) {
        super();
        this.setSbjctId(sbjctId);
        this.setUserId(userId);
        this.totScr = totScr;
        this.lstScr = lstScr;
        this.adtnScr = adtnScr;
    };

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

    public double getLstScr() {
        return lstScr;
    }

    public void setLstScr(double lstScr) {
        this.lstScr = lstScr;
    }

    public double getAdtnScr() {
        return adtnScr;
    }

    public void setAdtnScr(double adtnScr) {
        this.adtnScr = adtnScr;
    }

    public double getTotScr() {
        return totScr;
    }

    public void setTotScr(double totScr) {
        this.totScr = totScr;
    }

    public double getEtcScr() {
        return etcScr;
    }

    public void setEtcScr(double etcScr) {
        this.etcScr = etcScr;
    }
}
