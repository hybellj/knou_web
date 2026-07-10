package knou.lms.asmt2.vo;

import knou.lms.common.vo.DefaultVO;

import java.math.BigDecimal;

public class AsmtEvlVO extends DefaultVO {
    private String sbmsnStscd;       // 제출상태코드
    private String asmtEvlId;        // 과제평가아이디
    private String asmtSbmsnId;      // 과제제출아이디
    private BigDecimal scr;             // 점수
    private BigDecimal rublicCnvsnScr;  // 루브릭환산점수
    private String evlMemo;          // 평가메모
    private String evlGrdcd;         // 평가등급코드
    private String evlyn;            // 평가여부
    private Double evlWgvlrt;        // 평가가중치비율
    private String exlnAsmtyn;       // 우수과제여부
    private String mosaCmpDttm;      // 모사비교일시
    private Double maxMosart;        // 최대모사비율
    private String maxMosaId;        // 최대모사아이디
    private String cmrclDataFileId;  // 상업용자료파일아이디
    private Double cmrclDataMosart;  // 상업용자료모사율
    private String asmtId;           // 과제아이디
    private String teamId;           // 팀아이디

    /* 내부로직용 */
    private String scoreType;       // 점수유형: batch(대상점수), addition(점수가감)
    private String userIds; // 다건 평가 대상
    private String saveTargetType; // 팀 / 개인 대상 저장

    public String getSbmsnStscd() {
        return sbmsnStscd;
    }

    public void setSbmsnStscd(String sbmsnStscd) {
        this.sbmsnStscd = sbmsnStscd;
    }

    public String getAsmtEvlId() {
        return asmtEvlId;
    }

    public void setAsmtEvlId(String asmtEvlId) {
        this.asmtEvlId = asmtEvlId;
    }

    public String getAsmtSbmsnId() {
        return asmtSbmsnId;
    }

    public void setAsmtSbmsnId(String asmtSbmsnId) {
        this.asmtSbmsnId = asmtSbmsnId;
    }

    public BigDecimal getScr() {
        return scr;
    }

    public void setScr(BigDecimal scr) {
        this.scr = scr;
    }

    public BigDecimal getRublicCnvsnScr() {
        return rublicCnvsnScr;
    }

    public void setRublicCnvsnScr(BigDecimal rublicCnvsnScr) {
        this.rublicCnvsnScr = rublicCnvsnScr;
    }

    public String getEvlMemo() {
        return evlMemo;
    }

    public void setEvlMemo(String evlMemo) {
        this.evlMemo = evlMemo;
    }

    public String getEvlGrdcd() {
        return evlGrdcd;
    }

    public void setEvlGrdcd(String evlGrdcd) {
        this.evlGrdcd = evlGrdcd;
    }

    public String getEvlyn() {
        return evlyn;
    }

    public void setEvlyn(String evlyn) {
        this.evlyn = evlyn;
    }

    public Double getEvlWgvlrt() {
        return evlWgvlrt;
    }

    public void setEvlWgvlrt(Double evlWgvlrt) {
        this.evlWgvlrt = evlWgvlrt;
    }

    public String getExlnAsmtyn() {
        return exlnAsmtyn;
    }

    public void setExlnAsmtyn(String exlnAsmtyn) {
        this.exlnAsmtyn = exlnAsmtyn;
    }

    public String getMosaCmpDttm() {
        return mosaCmpDttm;
    }

    public void setMosaCmpDttm(String mosaCmpDttm) {
        this.mosaCmpDttm = mosaCmpDttm;
    }

    public Double getMaxMosart() {
        return maxMosart;
    }

    public void setMaxMosart(Double maxMosart) {
        this.maxMosart = maxMosart;
    }

    public String getMaxMosaId() {
        return maxMosaId;
    }

    public void setMaxMosaId(String maxMosaId) {
        this.maxMosaId = maxMosaId;
    }

    public String getCmrclDataFileId() {
        return cmrclDataFileId;
    }

    public void setCmrclDataFileId(String cmrclDataFileId) {
        this.cmrclDataFileId = cmrclDataFileId;
    }

    public Double getCmrclDataMosart() {
        return cmrclDataMosart;
    }

    public void setCmrclDataMosart(Double cmrclDataMosart) {
        this.cmrclDataMosart = cmrclDataMosart;
    }

    public String getAsmtId() {
        return asmtId;
    }

    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
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

    public String getSaveTargetType() {
        return saveTargetType;
    }

    public void setSaveTargetType(String saveTargetType) {
        this.saveTargetType = saveTargetType;
    }
}


