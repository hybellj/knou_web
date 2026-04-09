package knou.lms.asmt2.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

public class AsmtVO extends DefaultVO {

    private String grpcd; //그룹코드
    private String asmtId; //과제아이디(PK)
    private String newAsmtId;
    private String prevAsmtId;
    private String upAsmtId;    // 상위과제아이디
    private String asmtGbncd; //과제구분코드
    private String asmtGbnnm;   //과제구분명
    private String dvclasNo;    // 분반번호
    private String asmtTtl; //과제제목
    private String asmtCts; //과제내용
    private String sbasmtTycd; //제출과제유형코드
    private String rublicId;           // 루브릭아이디
    private String delyn; //삭제 여부
    private String sbjctNm;                //과목명
    private String dgrsSmstrChrt;          //학기기수차트
    private String smstrChrtId; //학기기수아이디
    private String asmtSbmsnSdttm;         //과제제출시작일시
    private String asmtSbmsnEdttm;         //과제제출종료일시
    private String asmtPrctcyn;            //실습여부
    private String sbmsnFileMimeTycd;      //제출파일마임유형코드
    private String asmtOyn;                //과제공개여부
    private String extdSbmsnPrmyn;         //연장제출허용여부
    private String extdSbmsnSdttm;         //연장제출시작일시
    private String extdSbmsnEdttm;         //연장제출종료일시
    private String teamAsmtStngyn;         //팀과제설정여부
    private String lrnGrpId;               //학습그룹아이디
    private String lrnGrpNm;               //학습그룹명
    private String asmtGrpId;              //과제그룹아이디
    private String asmtGrpnm;              //과제그룹명
    private String tmbrIndivSbmsnPrmyn;          //팀원제출허용여부
    private String mrkRfltyn;              //성적반영여부
    private String mrkRfltrt;             //성적반영비율
    private String mrkOyn;                 //성적공개여부
    private String mrkInqSdttm;            //성적조회시작일시
    private String mrkInqEdttm;            //성적조회종료일시
    private String evlUseyn;               // 평가사용여부
    private String evlScrTycd;              //평가점수유형코드
    private String evlRsltOyn;              //평가결과공개여부
    private String avgScrOyn;               //평균점수공개여부
    private String pushAlimyn;              //푸시알림여부
    private String sbasmtOstdOyn;           //제출과제외부공개여부
    private String sbasmtOstdOpenSdttm;     //제출과제외부공개시작일시
    private String sbasmtOstdOpenEdttm;     //제출과제외부공개종료일시
    private String indvAsmtyn;              //개별과제여부
    private String resbmsnSdttm;            //재제출시작일시
    private String resbmsnEdttm;            //재제출종료일시
    private Integer resbmsnMrkRfltrt;       //재제출성적반영비율
    private String lctrWknoSchdlId;         //강의주차일정아이디
    private String lctrWknonm;              //강의주차명
    private String exlnAsmtDwldyn; //우수과제다운로드여부
    private String[] asmtArray;         // 과제목록
    private String[] mrkRfltrtArray;    // 성적반영비율목록
    private String dvclasCncrntRegyn;    // 분반동시등록여부
    private String byteamAsmtUseyn;     // 팀별과제사용여부


    /*
     * 내부 로직 용
     */
    private String indvAsmtList;    // 개별과제 목록
    private String[] dvclasListArr; // 분반선택목록
    private String[] lrnGrpIds; // 학습그룹ID 목록
    private String[] byteamAsmtUseyns;     // 팀별과제사용여부 목록
    private List<AsmtVO> dvclasInfoList;   // 분반정보목록

    private List<AsmtSubDtlVO> subAsmtDtlList; // 팀별 부과제 상세목록

    public String getGrpcd() {
        return grpcd;
    }

    public void setGrpcd(String grpcd) {
        this.grpcd = grpcd;
    }

    public String getAsmtId() {
        return asmtId;
    }

    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }

    public String getNewAsmtId() {
        return newAsmtId;
    }

    public void setNewAsmtId(String newAsmtId) {
        this.newAsmtId = newAsmtId;
    }

    public String getPrevAsmtId() {
        return prevAsmtId;
    }

    public void setPrevAsmtId(String prevAsmtId) {
        this.prevAsmtId = prevAsmtId;
    }

    public String getAsmtGbncd() {
        return asmtGbncd;
    }

    public void setAsmtGbncd(String asmtGbncd) {
        this.asmtGbncd = asmtGbncd;
    }

    public String getAsmtGbnnm() {
        return asmtGbnnm;
    }

    public void setAsmtGbnnm(String asmtGbnnm) {
        this.asmtGbnnm = asmtGbnnm;
    }

    public String getAsmtTtl() {
        return asmtTtl;
    }

    public void setAsmtTtl(String asmtTtl) {
        this.asmtTtl = asmtTtl;
    }

    public String getAsmtCts() {
        return asmtCts;
    }

    public void setAsmtCts(String asmtCts) {
        this.asmtCts = asmtCts;
    }

    public String getSbasmtTycd() {
        return sbasmtTycd;
    }

    public void setSbasmtTycd(String sbasmtTycd) {
        this.sbasmtTycd = sbasmtTycd;
    }

    public String getRublicId() {
        return rublicId;
    }

    public void setRublicId(String rublicId) {
        this.rublicId = rublicId;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }

    public String getSbjctNm() {
        return sbjctNm;
    }

    public void setSbjctNm(String sbjctNm) {
        this.sbjctNm = sbjctNm;
    }

    @Override
    public String getDgrsSmstrChrt() {
        return dgrsSmstrChrt;
    }

    @Override
    public void setDgrsSmstrChrt(String dgrsSmstrChrt) {
        this.dgrsSmstrChrt = dgrsSmstrChrt;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getAsmtSbmsnSdttm() {
        return asmtSbmsnSdttm;
    }

    public void setAsmtSbmsnSdttm(String asmtSbmsnSdttm) {
        this.asmtSbmsnSdttm = asmtSbmsnSdttm;
    }

    public String getAsmtSbmsnEdttm() {
        return asmtSbmsnEdttm;
    }

    public void setAsmtSbmsnEdttm(String asmtSbmsnEdttm) {
        this.asmtSbmsnEdttm = asmtSbmsnEdttm;
    }

    public String getAsmtPrctcyn() {
        return asmtPrctcyn;
    }

    public void setAsmtPrctcyn(String asmtPrctcyn) {
        this.asmtPrctcyn = asmtPrctcyn;
    }

    public String getSbmsnFileMimeTycd() {
        return sbmsnFileMimeTycd;
    }

    public void setSbmsnFileMimeTycd(String sbmsnFileMimeTycd) {
        this.sbmsnFileMimeTycd = sbmsnFileMimeTycd;
    }

    public String getAsmtOyn() {
        return asmtOyn;
    }

    public void setAsmtOyn(String asmtOyn) {
        this.asmtOyn = asmtOyn;
    }

    public String getExtdSbmsnPrmyn() {
        return extdSbmsnPrmyn;
    }

    public void setExtdSbmsnPrmyn(String extdSbmsnPrmyn) {
        this.extdSbmsnPrmyn = extdSbmsnPrmyn;
    }

    public String getExtdSbmsnSdttm() {
        return extdSbmsnSdttm;
    }

    public void setExtdSbmsnSdttm(String extdSbmsnSdttm) {
        this.extdSbmsnSdttm = extdSbmsnSdttm;
    }

    public String getExtdSbmsnEdttm() {
        return extdSbmsnEdttm;
    }

    public void setExtdSbmsnEdttm(String extdSbmsnEdttm) {
        this.extdSbmsnEdttm = extdSbmsnEdttm;
    }

    public String getTeamAsmtStngyn() {
        return teamAsmtStngyn;
    }

    public void setTeamAsmtStngyn(String teamAsmtStngyn) {
        this.teamAsmtStngyn = teamAsmtStngyn;
    }

    public String getLrnGrpId() {
        return lrnGrpId;
    }

    public void setLrnGrpId(String lrnGrpId) {
        this.lrnGrpId = lrnGrpId;
    }

    public String getLrnGrpNm() {
        return lrnGrpNm;
    }

    public void setLrnGrpNm(String lrnGrpNm) {
        this.lrnGrpNm = lrnGrpNm;
    }

    public String getAsmtGrpId() {
        return asmtGrpId;
    }

    public void setAsmtGrpId(String asmtGrpId) {
        this.asmtGrpId = asmtGrpId;
    }

    public String getAsmtGrpnm() {
        return asmtGrpnm;
    }

    public void setAsmtGrpnm(String asmtGrpnm) {
        this.asmtGrpnm = asmtGrpnm;
    }

    public String getTmbrIndivSbmsnPrmyn() {
        return tmbrIndivSbmsnPrmyn;
    }

    public void setTmbrIndivSbmsnPrmyn(String tmbrIndivSbmsnPrmyn) {
        this.tmbrIndivSbmsnPrmyn = tmbrIndivSbmsnPrmyn;
    }

    public String getMrkRfltyn() {
        return mrkRfltyn;
    }

    public void setMrkRfltyn(String mrkRfltyn) {
        this.mrkRfltyn = mrkRfltyn;
    }

    public String getMrkRfltrt() {
        return mrkRfltrt;
    }

    public void setMrkRfltrt(String mrkRfltrt) {
        this.mrkRfltrt = mrkRfltrt;
    }

    public String getMrkOyn() {
        return mrkOyn;
    }

    public void setMrkOyn(String mrkOyn) {
        this.mrkOyn = mrkOyn;
    }

    public String getMrkInqSdttm() {
        return mrkInqSdttm;
    }

    public void setMrkInqSdttm(String mrkInqSdttm) {
        this.mrkInqSdttm = mrkInqSdttm;
    }

    public String getMrkInqEdttm() {
        return mrkInqEdttm;
    }

    public void setMrkInqEdttm(String mrkInqEdttm) {
        this.mrkInqEdttm = mrkInqEdttm;
    }

    public String getEvlUseyn() {
        return evlUseyn;
    }

    public void setEvlUseyn(String evlUseyn) {
        this.evlUseyn = evlUseyn;
    }

    public String getEvlScrTycd() {
        return evlScrTycd;
    }

    public void setEvlScrTycd(String evlScrTycd) {
        this.evlScrTycd = evlScrTycd;
    }

    public String getEvlRsltOyn() {
        return evlRsltOyn;
    }

    public void setEvlRsltOyn(String evlRsltOyn) {
        this.evlRsltOyn = evlRsltOyn;
    }

    public String getAvgScrOyn() {
        return avgScrOyn;
    }

    public void setAvgScrOyn(String avgScrOyn) {
        this.avgScrOyn = avgScrOyn;
    }

    public String getPushAlimyn() {
        return pushAlimyn;
    }

    public void setPushAlimyn(String pushAlimyn) {
        this.pushAlimyn = pushAlimyn;
    }

    public String getSbasmtOstdOyn() {
        return sbasmtOstdOyn;
    }

    public void setSbasmtOstdOyn(String sbasmtOstdOyn) {
        this.sbasmtOstdOyn = sbasmtOstdOyn;
    }

    public String getSbasmtOstdOpenSdttm() {
        return sbasmtOstdOpenSdttm;
    }

    public void setSbasmtOstdOpenSdttm(String sbasmtOstdOpenSdttm) {
        this.sbasmtOstdOpenSdttm = sbasmtOstdOpenSdttm;
    }

    public String getSbasmtOstdOpenEdttm() {
        return sbasmtOstdOpenEdttm;
    }

    public void setSbasmtOstdOpenEdttm(String sbasmtOstdOpenEdttm) {
        this.sbasmtOstdOpenEdttm = sbasmtOstdOpenEdttm;
    }

    public String getIndvAsmtyn() {
        return indvAsmtyn;
    }

    public void setIndvAsmtyn(String indvAsmtyn) {
        this.indvAsmtyn = indvAsmtyn;
    }

    public String getResbmsnSdttm() {
        return resbmsnSdttm;
    }

    public void setResbmsnSdttm(String resbmsnSdttm) {
        this.resbmsnSdttm = resbmsnSdttm;
    }

    public String getResbmsnEdttm() {
        return resbmsnEdttm;
    }

    public void setResbmsnEdttm(String resbmsnEdttm) {
        this.resbmsnEdttm = resbmsnEdttm;
    }

    public Integer getResbmsnMrkRfltrt() {
        return resbmsnMrkRfltrt;
    }

    public void setResbmsnMrkRfltrt(Integer resbmsnMrkRfltrt) {
        this.resbmsnMrkRfltrt = resbmsnMrkRfltrt;
    }

    public String getLctrWknoSchdlId() {
        return lctrWknoSchdlId;
    }

    public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
        this.lctrWknoSchdlId = lctrWknoSchdlId;
    }

    public String getLctrWknonm() {
        return lctrWknonm;
    }

    public void setLctrWknonm(String lctrWknonm) {
        this.lctrWknonm = lctrWknonm;
    }

    public String getExlnAsmtDwldyn() {
        return exlnAsmtDwldyn;
    }

    public void setExlnAsmtDwldyn(String exlnAsmtDwldyn) {
        this.exlnAsmtDwldyn = exlnAsmtDwldyn;
    }

    public String getUpAsmtId() {
        return upAsmtId;
    }

    public void setUpAsmtId(String upAsmtId) {
        this.upAsmtId = upAsmtId;
    }

    public String[] getMrkRfltrtArray() {
        return mrkRfltrtArray;
    }

    public void setMrkRfltrtArray(String[] mrkRfltrtArray) {
        this.mrkRfltrtArray = mrkRfltrtArray;
    }

    public String[] getAsmtArray() {
        return asmtArray;
    }

    public void setAsmtArray(String[] asmtArray) {
        this.asmtArray = asmtArray;
    }

    public String getDvclasCncrntRegyn() {
        return dvclasCncrntRegyn;
    }

    public void setDvclasCncrntRegyn(String dvclasCncrntRegyn) {
        this.dvclasCncrntRegyn = dvclasCncrntRegyn;
    }

    public String getIndvAsmtList() {
        return indvAsmtList;
    }

    public void setIndvAsmtList(String indvAsmtList) {
        this.indvAsmtList = indvAsmtList;
    }

    public List<AsmtSubDtlVO> getSubAsmtDtlList() {
        return subAsmtDtlList;
    }

    public void setSubAsmtDtlList(List<AsmtSubDtlVO> subAsmtDtlList) {
        this.subAsmtDtlList = subAsmtDtlList;
    }

    public String[] getDvclasListArr() {
        return dvclasListArr;
    }

    public void setDvclasListArr(String[] dvclasListArr) {
        this.dvclasListArr = dvclasListArr;
    }

    public String[] getLrnGrpIds() {
        return lrnGrpIds;
    }

    public void setLrnGrpIds(String[] lrnGrpIds) {
        this.lrnGrpIds = lrnGrpIds;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getByteamAsmtUseyn() {
        return byteamAsmtUseyn;
    }

    public void setByteamAsmtUseyn(String byteamAsmtUseyn) {
        this.byteamAsmtUseyn = byteamAsmtUseyn;
    }

    public String[] getByteamAsmtUseyns() {
        return byteamAsmtUseyns;
    }

    public void setByteamAsmtUseyns(String[] byteamAsmtUseyns) {
        this.byteamAsmtUseyns = byteamAsmtUseyns;
    }

    public List<AsmtVO> getDvclasInfoList() {
        return dvclasInfoList;
    }

    public void setDvclasInfoList(List<AsmtVO> dvclasInfoList) {
        this.dvclasInfoList = dvclasInfoList;
    }
}
