package knou.lms.system.manage.vo;

import java.io.Serializable;

public class AcademicScheduleVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 학사일정ID */
    private String acadSchdlId;

    /** 기관ID */
    private String orgId;

    /** 학년도 */
    private String acadYr;

    /** 학기 */
    private String acadSmstrChrt;

    /** 학사일정 시작일시 */
    private String acadSchdlSdttm;

    /** 학사일정 종료일시 */
    private String acadSchdlEdttm;

    /** 학사일정유형코드 */
    private String acadSchdlTycd;

    /** 학사일정 설명 */
    private String acadSchdlExpln;

    /** 등록자ID */
    private String rgtrId;

    /** 등록일시 */
    private String regDttm;

    /** 수정자ID */
    private String mdfrId;

    /** 수정일시 */
    private String modDttm;

    /** 학기차트ID */
    private String smstrChrtId;

    public String getAcadSchdlId() {
        return acadSchdlId;
    }

    public void setAcadSchdlId(String acadSchdlId) {
        this.acadSchdlId = acadSchdlId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getAcadYr() {
        return acadYr;
    }

    public void setAcadYr(String acadYr) {
        this.acadYr = acadYr;
    }

    public String getAcadSmstrChrt() {
        return acadSmstrChrt;
    }

    public void setAcadSmstrChrt(String acadSmstrChrt) {
        this.acadSmstrChrt = acadSmstrChrt;
    }

    public String getAcadSchdlSdttm() {
        return acadSchdlSdttm;
    }

    public void setAcadSchdlSdttm(String acadSchdlSdttm) {
        this.acadSchdlSdttm = acadSchdlSdttm;
    }

    public String getAcadSchdlEdttm() {
        return acadSchdlEdttm;
    }

    public void setAcadSchdlEdttm(String acadSchdlEdttm) {
        this.acadSchdlEdttm = acadSchdlEdttm;
    }

    public String getAcadSchdlTycd() {
        return acadSchdlTycd;
    }

    public void setAcadSchdlTycd(String acadSchdlTycd) {
        this.acadSchdlTycd = acadSchdlTycd;
    }

    public String getAcadSchdlExpln() {
        return acadSchdlExpln;
    }

    public void setAcadSchdlExpln(String acadSchdlExpln) {
        this.acadSchdlExpln = acadSchdlExpln;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    @Override
    public String toString() {
        return "AcademicScheduleVO{" +
                "acadSchdlId='" + acadSchdlId + '\'' +
                ", orgId='" + orgId + '\'' +
                ", acadYr='" + acadYr + '\'' +
                ", acadSmstrChrt='" + acadSmstrChrt + '\'' +
                ", acadSchdlSdttm='" + acadSchdlSdttm + '\'' +
                ", acadSchdlEdttm='" + acadSchdlEdttm + '\'' +
                ", acadSchdlTycd='" + acadSchdlTycd + '\'' +
                ", acadSchdlExpln='" + acadSchdlExpln + '\'' +
                ", rgtrId='" + rgtrId + '\'' +
                ", regDttm='" + regDttm + '\'' +
                ", mdfrId='" + mdfrId + '\'' +
                ", modDttm='" + modDttm + '\'' +
                ", smstrChrtId='" + smstrChrtId + '\'' +
                '}';
    }
}