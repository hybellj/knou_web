package knou.lms.mrk.vo;

import knou.framework.common.PageInfo;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.stream.Collectors;

// TB_LMS_MRK_PROC_HSTRY (성적처리이력)
public class MrkProcStatusVO extends PageInfo {

    private String mrkProcHstryId;      // 성적처리이력 아이디
    private String mrkProcHstryTycd;    // 성적처리이력 유형코드
    private BigDecimal scrBfr;          // 변경 전 점수
    private BigDecimal scrAft;          // 변경 후 점수
    private String rgtrId;              // 등록자 아이디
    private String regDttm;             // 등록일시
    private String mdfrId;              // 수정자 아이디
    private String modDttm;             // 수정일시


    private String langCd;
    private String excelGrid;
    private String mrkProcStatusCds;
    private String[] mrkProcStatusCdList;

    public MrkProcStatusVO() {
    }

    public MrkProcStatusVO(String sbjctId, String userId, String mrkProcHstryId, String mrkProcHstryTycd, BigDecimal scrBfr, BigDecimal scrAft, String rgtrId) {
        super();
        this.setUserId(userId);
        this.mrkProcHstryId = mrkProcHstryId;
        this.mrkProcHstryTycd = mrkProcHstryTycd;
        this.scrBfr = scrBfr;
        this.scrAft = scrAft;
        this.rgtrId = rgtrId;
    }

    public void normalizeStatusParams() {
        this.mrkProcStatusCds = joinCodes(this.mrkProcStatusCdList, this.mrkProcStatusCds);
    }

    private String joinCodes(String[] codes, String fallback) {
        if(codes == null || codes.length == 0) {
            return fallback;
        }
        return Arrays.stream(codes)
                .filter(code -> code != null && !code.trim().isEmpty())
                .map(String::trim)
                .distinct()
                .collect(Collectors.joining(","));
    }

    public String getMrkProcHstryId() {
        return mrkProcHstryId;
    }

    public void setMrkProcHstryId(String mrkProcHstryId) {
        this.mrkProcHstryId = mrkProcHstryId;
    }

    public String getMrkProcHstryTycd() {
        return mrkProcHstryTycd;
    }

    public void setMrkProcHstryTycd(String mrkProcHstryTycd) {
        this.mrkProcHstryTycd = mrkProcHstryTycd;
    }

    public BigDecimal getScrBfr() {
        return scrBfr;
    }

    public void setScrBfr(BigDecimal scrBfr) {
        this.scrBfr = scrBfr;
    }

    public BigDecimal getScrAft() {
        return scrAft;
    }

    public void setScrAft(BigDecimal scrAft) {
        this.scrAft = scrAft;
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

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getExcelGrid() {
        return excelGrid;
    }

    public void setExcelGrid(String excelGrid) {
        this.excelGrid = excelGrid;
    }

    public String getMrkProcStatusCds() {
        return mrkProcStatusCds;
    }

    public void setMrkProcStatusCds(String mrkProcStatusCds) {
        this.mrkProcStatusCds = mrkProcStatusCds;
    }

    public String[] getMrkProcStatusCdList() {
        return mrkProcStatusCdList;
    }

    public void setMrkProcStatusCdList(String[] mrkProcStatusCdList) {
        this.mrkProcStatusCdList = mrkProcStatusCdList;
    }
}
