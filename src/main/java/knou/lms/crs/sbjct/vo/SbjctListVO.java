package knou.lms.crs.sbjct.vo;

import knou.lms.common.vo.DefaultVO;

public class SbjctListVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctCd; // 과목코드
    private String profId; // 교수아이디
    private String smstrChrtId; // 학기기수아이디
    private String sbjctYr; // 과목연도
    private String sbjctSmstr; // 과목학기
    private String crsGbncd; // 과정구분코드
    private String sbjctTycd; // 과목분류코드
    private String lctrGbncd; // 강의구분코드
    private String cmcrsGbncd; // 이수구분코드
    private String evlGbncd; // 평가구분코드
    private Integer dvclasNo; // 분반번호
    private Integer crdts; // 학점
    private String useyn; // 사용여부
    private String atndlcCertStscd; // 수강인증상태코드
    private String sbjctLctrSdttm; // 과목강의시작일시
    private String sbjctLctrEdttm; // 과목강의종료일시
    private String lessonCntsUrl; // 강의 미리보기 URL

    /* DB와 관계없는 파라미터 */
    private String crsGbncdnm; // 과정구분코드명
    private String sbjctTycdnm; // 과목분류코드명
    private String lctrGbncdnm; // 강의구분코드명
    private String cmcrsGbncdnm; // 이수구분코드명
    private String evlGbncdnm; // 평가구분코드명
    private String profUsernm; // 담당교수명
    private String tutUsernm; // 담당튜터명
    private String assiUsernm; // 담당조교명
    private Integer atndlcCnt; // 수강생수
    private Integer auditCnt; // 청강생수

    public String getSbjctCd() {
        return sbjctCd;
    }

    public void setSbjctCd(String sbjctCd) {
        this.sbjctCd = sbjctCd;
    }

    public String getProfId() {
        return profId;
    }

    public void setProfId(String profId) {
        this.profId = profId;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getSbjctYr() {
        return sbjctYr;
    }

    public void setSbjctYr(String sbjctYr) {
        this.sbjctYr = sbjctYr;
    }

    public String getSbjctSmstr() {
        return sbjctSmstr;
    }

    public void setSbjctSmstr(String sbjctSmstr) {
        this.sbjctSmstr = sbjctSmstr;
    }

    public String getCrsGbncd() {
        return crsGbncd;
    }

    public void setCrsGbncd(String crsGbncd) {
        this.crsGbncd = crsGbncd;
    }

    public String getCrsGbncdnm() {
        return crsGbncdnm;
    }

    public void setCrsGbncdnm(String crsGbncdnm) {
        this.crsGbncdnm = crsGbncdnm;
    }

    public String getSbjctTycd() {
        return sbjctTycd;
    }

    public void setSbjctTycd(String sbjctTycd) {
        this.sbjctTycd = sbjctTycd;
    }

    public String getSbjctTycdnm() {
        return sbjctTycdnm;
    }

    public void setSbjctTycdnm(String sbjctTycdnm) {
        this.sbjctTycdnm = sbjctTycdnm;
    }

    public String getLctrGbncd() {
        return lctrGbncd;
    }

    public void setLctrGbncd(String lctrGbncd) {
        this.lctrGbncd = lctrGbncd;
    }

    public String getLctrGbncdnm() {
        return lctrGbncdnm;
    }

    public void setLctrGbncdnm(String lctrGbncdnm) {
        this.lctrGbncdnm = lctrGbncdnm;
    }

    public String getCmcrsGbncd() {
        return cmcrsGbncd;
    }

    public void setCmcrsGbncd(String cmcrsGbncd) {
        this.cmcrsGbncd = cmcrsGbncd;
    }

    public String getCmcrsGbncdnm() {
        return cmcrsGbncdnm;
    }

    public void setCmcrsGbncdnm(String cmcrsGbncdnm) {
        this.cmcrsGbncdnm = cmcrsGbncdnm;
    }

    public String getEvlGbncd() {
        return evlGbncd;
    }

    public void setEvlGbncd(String evlGbncd) {
        this.evlGbncd = evlGbncd;
    }

    public String getEvlGbncdnm() {
        return evlGbncdnm;
    }

    public void setEvlGbncdnm(String evlGbncdnm) {
        this.evlGbncdnm = evlGbncdnm;
    }

    public Integer getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(Integer dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public Integer getCrdts() {
        return crdts;
    }

    public void setCrdts(Integer crdts) {
        this.crdts = crdts;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

    public String getAtndlcCertStscd() {
        return atndlcCertStscd;
    }

    public void setAtndlcCertStscd(String atndlcCertStscd) {
        this.atndlcCertStscd = atndlcCertStscd;
    }

    public String getSbjctLctrSdttm() {
        return sbjctLctrSdttm;
    }

    public void setSbjctLctrSdttm(String sbjctLctrSdttm) {
        this.sbjctLctrSdttm = sbjctLctrSdttm;
    }

    public String getSbjctLctrEdttm() {
        return sbjctLctrEdttm;
    }

    public void setSbjctLctrEdttm(String sbjctLctrEdttm) {
        this.sbjctLctrEdttm = sbjctLctrEdttm;
    }

    public String getLessonCntsUrl() {
        return lessonCntsUrl;
    }

    public void setLessonCntsUrl(String lessonCntsUrl) {
        this.lessonCntsUrl = lessonCntsUrl;
    }

    public String getProfUsernm() {
        return profUsernm;
    }

    public void setProfUsernm(String profUsernm) {
        this.profUsernm = profUsernm;
    }

    public String getTutUsernm() {
        return tutUsernm;
    }

    public void setTutUsernm(String tutUsernm) {
        this.tutUsernm = tutUsernm;
    }

    public String getAssiUsernm() {
        return assiUsernm;
    }

    public void setAssiUsernm(String assiUsernm) {
        this.assiUsernm = assiUsernm;
    }

    public Integer getAtndlcCnt() {
        return atndlcCnt;
    }

    public void setAtndlcCnt(Integer atndlcCnt) {
        this.atndlcCnt = atndlcCnt;
    }

    public Integer getAuditCnt() {
        return auditCnt;
    }

    public void setAuditCnt(Integer auditCnt) {
        this.auditCnt = auditCnt;
    }

}
