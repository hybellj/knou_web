package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class Forum2ListVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctId; // 검색조건: 과목아이디
    private String dvclsId; // 검색조건: 분반아이디
    private String lrnGrpId; // 검색조건: 학습그룹아이디
    private String dscsGbncd; // 검색조건: 토론구분코드
    private String dscsUnitTycd; // 검색조건: 토론단위유형코드
    private String evlScrTycd; // 평가점수유형코드
    private String dscsTtl; // 검색조건: 토론제목
    private String dscsSdttmFrom; // 검색조건: 토론시작일시 From
    private String dscsSdttmTo; // 검색조건: 토론시작일시 To

    private String dscsId; // 목록표시: 토론아이디
    private String dscsGrpId; // 목록표시: 토론그룹아이디
    private String dscsCts; // 목록표시: 토론내용
    private String dscsSdttm; // 목록표시: 토론시작일시
    private String dscsEdttm; // 목록표시: 토론종료일시
    private String delyn; // 목록표시: 삭제여부
    private String oatclInqyn; // 목록표시: 타게시글조회여부
    private String oknokrtOyn; // 목록표시: 찬성반대비율공개여부
    private String oknokModyn; // 목록표시: 찬성반대수정여부
    private String mltOpnnRegyn; // 목록표시: 다중의견등록여부
    private String oknokRgtrOyn; // 목록표시: 작성자공개여부
    private String cmntRspnsReqyn; // 목록표시: 댓글답변요청여부
    private String mrkRfltyn; // 목록표시: 성적반영여부
    private String mrkOyn; // 목록표시: 성적공개여부
    private String rgtrId; // 목록표시: 등록자아이디
    private String regDttm; // 목록표시: 등록일시
    private String mdfrId; // 목록표시: 수정자아이디
    private String modDttm; // 목록표시: 수정일시

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getDvclsId() {
        return dvclsId;
    }

    public void setDvclsId(String dvclsId) {
        this.dvclsId = dvclsId;
    }

    public String getLrnGrpId() {
        return lrnGrpId;
    }

    public void setLrnGrpId(String lrnGrpId) {
        this.lrnGrpId = lrnGrpId;
    }

    public String getDscsGbncd() {
        return dscsGbncd;
    }

    public void setDscsGbncd(String dscsGbncd) {
        this.dscsGbncd = dscsGbncd;
    }

    public String getDscsUnitTycd() {
        return dscsUnitTycd;
    }

    public void setDscsUnitTycd(String dscsUnitTycd) {
        this.dscsUnitTycd = dscsUnitTycd;
    }

    public String getEvlScrTycd() {
        return evlScrTycd;
    }

    public void setEvlScrTycd(String evlScrTycd) {
        this.evlScrTycd = evlScrTycd;
    }

    public String getDscsTtl() {
        return dscsTtl;
    }

    public void setDscsTtl(String dscsTtl) {
        this.dscsTtl = dscsTtl;
    }

    public String getDscsSdttmFrom() {
        return dscsSdttmFrom;
    }

    public void setDscsSdttmFrom(String dscsSdttmFrom) {
        this.dscsSdttmFrom = dscsSdttmFrom;
    }

    public String getDscsSdttmTo() {
        return dscsSdttmTo;
    }

    public void setDscsSdttmTo(String dscsSdttmTo) {
        this.dscsSdttmTo = dscsSdttmTo;
    }

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getDscsGrpId() {
        return dscsGrpId;
    }

    public void setDscsGrpId(String dscsGrpId) {
        this.dscsGrpId = dscsGrpId;
    }

    public String getDscsCts() {
        return dscsCts;
    }

    public void setDscsCts(String dscsCts) {
        this.dscsCts = dscsCts;
    }

    public String getDscsSdttm() {
        return dscsSdttm;
    }

    public void setDscsSdttm(String dscsSdttm) {
        this.dscsSdttm = dscsSdttm;
    }

    public String getDscsEdttm() {
        return dscsEdttm;
    }

    public void setDscsEdttm(String dscsEdttm) {
        this.dscsEdttm = dscsEdttm;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }

    public String getOatclInqyn() {
        return oatclInqyn;
    }

    public void setOatclInqyn(String oatclInqyn) {
        this.oatclInqyn = oatclInqyn;
    }

    public String getOknokrtOyn() {
        return oknokrtOyn;
    }

    public void setOknokrtOyn(String oknokrtOyn) {
        this.oknokrtOyn = oknokrtOyn;
    }

    public String getOknokModyn() {
        return oknokModyn;
    }

    public void setOknokModyn(String oknokModyn) {
        this.oknokModyn = oknokModyn;
    }

    public String getMltOpnnRegyn() {
        return mltOpnnRegyn;
    }

    public void setMltOpnnRegyn(String mltOpnnRegyn) {
        this.mltOpnnRegyn = mltOpnnRegyn;
    }

    public String getOknokRgtrOyn() {
        return oknokRgtrOyn;
    }

    public void setOknokRgtrOyn(String oknokRgtrOyn) {
        this.oknokRgtrOyn = oknokRgtrOyn;
    }

    public String getCmntRspnsReqyn() {
        return cmntRspnsReqyn;
    }

    public void setCmntRspnsReqyn(String cmntRspnsReqyn) {
        this.cmntRspnsReqyn = cmntRspnsReqyn;
    }

    public String getMrkRfltyn() {
        return mrkRfltyn;
    }

    public void setMrkRfltyn(String mrkRfltyn) {
        this.mrkRfltyn = mrkRfltyn;
    }

    public String getMrkOyn() {
        return mrkOyn;
    }

    public void setMrkOyn(String mrkOyn) {
        this.mrkOyn = mrkOyn;
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
}
