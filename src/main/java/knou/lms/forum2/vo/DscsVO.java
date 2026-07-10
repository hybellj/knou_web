package knou.lms.forum2.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class DscsVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String dscsId; // 토론아이디
    private String dscsGrpId; // 토론그룹아이디
    private String dscsGrpnm; // 토론그룹명
    private String dscsGbncd; // 토론구분코드
    private String dscsUnitTycd; // 토론단위유형코드
    private String evlScrTycd; // 평가점수유형코드
    private String dscsTtl; // 토론제목
    private String dscsCts; // 토론내용
    private String dscsSdttm; // 토론시작일시
    private String dscsEdttm; // 토론종료일시
    private String teamGrpId; // 팀그룹아이디
    private String delyn; // 삭제여부
    private String oatclInqyn; // 타게시글조회여부
    private String oknokrtOyn; // 찬성반대비율공개여부
    private String oknokStngyn; // 찬성반대설정여부
    private String oknokModyn; // 찬성반대수정여부
    private String mltOpnnRegyn; // 다중의견등록여부
    private String oknokRgtrOyn; // 찬성반대등록자공개여부
    private String cmntRspnsReqyn; // 댓글답변요청여부
    private String mrkRfltyn; // 성적반영여부
    private Integer mrkRfltrt; // 성적반영비율
    private String mrkOyn; // 성적공개여부
    private String rgtrId; // 등록자아이디
    private String regDttm; // 등록일시
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시
    private String sbjctId; // 과목아이디
    private String dvclasNo; // 분반번호
    private String byteamDscsUseyn; // 팀별토론사용여부
    private String upDscsId; // 상위토론아이디
    private String teamId; // 팀아이디

    private List<DscsDvclasSelVO> dvclasSelList; // 분반선택 목록
    private List<DscsTeamGrpVO> teamGrpInfoList; // 팀그룹선택 목록
    private List<DscsTeamDscsVO> teamDscsList; // 팀토론 상세목록
    private List<DscsTeamDscsVO> teamDscsDtlList; // 팀별 부주제 입력 목록

    /* DB와 관계없는 파라미터 */
    private Integer dscsAtclCnt; // 게시글 수
    private Integer dscsCmntCnt; // 댓글 수
    private Integer dscsMyAtclCnt; // 내 게시글 수
    private Integer dscsMyCmntCnt; // 내 댓글 수
    private Integer dscsAtclPorsCnt; // 찬성 게시글 수
    private Integer dscsAtclConsCnt; // 반대 게시글 수
    private Integer dscsUserTotalCnt; // 총 인원 수
    private Integer dscsJoinUserCnt; // 참여자 수
    private Integer dscsEvalCnt; // 평가한 인원 수
    private String smstrChrtId; // 학기기수아이디
    private String stdId; // 학습자 아이디
    private String stdList; // 학습자 목록

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

    public String getDscsGrpnm() {
        return dscsGrpnm;
    }

    public void setDscsGrpnm(String dscsGrpnm) {
        this.dscsGrpnm = dscsGrpnm;
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

    public String getTeamGrpId() {
        return teamGrpId;
    }

    public void setTeamGrpId(String teamGrpId) {
        this.teamGrpId = teamGrpId;
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

    public String getOknokStngyn() {
        return oknokStngyn;
    }

    public void setOknokStngyn(String oknokStngyn) {
        this.oknokStngyn = oknokStngyn;
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

    public Integer getMrkRfltrt() {
        return mrkRfltrt;
    }

    public void setMrkRfltrt(Integer mrkRfltrt) {
        this.mrkRfltrt = mrkRfltrt;
    }

    public String getMrkOyn() {
        return mrkOyn;
    }

    public void setMrkOyn(String mrkOyn) {
        this.mrkOyn = mrkOyn;
    }

    @Override
    public String getRgtrId() {
        return rgtrId;
    }

    @Override
    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    @Override
    public String getRegDttm() {
        return regDttm;
    }

    @Override
    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    @Override
    public String getMdfrId() {
        return mdfrId;
    }

    @Override
    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    @Override
    public String getModDttm() {
        return modDttm;
    }

    @Override
    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    @Override
    public String getSbjctId() {
        return sbjctId;
    }

    @Override
    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getByteamDscsUseyn() {
        return byteamDscsUseyn;
    }

    public void setByteamDscsUseyn(String byteamDscsUseyn) {
        this.byteamDscsUseyn = byteamDscsUseyn;
    }

    public String getUpDscsId() {
        return upDscsId;
    }

    public void setUpDscsId(String upDscsId) {
        this.upDscsId = upDscsId;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public List<DscsDvclasSelVO> getDvclasSelList() {
        return dvclasSelList;
    }

    public void setDvclasSelList(List<DscsDvclasSelVO> dvclasSelList) {
        this.dvclasSelList = dvclasSelList;
    }

    public List<DscsTeamGrpVO> getTeamGrpInfoList() {
        return teamGrpInfoList;
    }

    public void setTeamGrpInfoList(List<DscsTeamGrpVO> teamGrpInfoList) {
        this.teamGrpInfoList = teamGrpInfoList;
    }

    public List<DscsTeamDscsVO> getTeamDscsList() {
        return teamDscsList;
    }

    public void setTeamDscsList(List<DscsTeamDscsVO> teamDscsList) {
        this.teamDscsList = teamDscsList;
    }

    public List<DscsTeamDscsVO> getTeamDscsDtlList() {
        return teamDscsDtlList;
    }

    public void setTeamDscsDtlList(List<DscsTeamDscsVO> teamDscsDtlList) {
        this.teamDscsDtlList = teamDscsDtlList;
    }

    public Integer getDscsAtclCnt() {
        return dscsAtclCnt;
    }

    public void setDscsAtclCnt(Integer dscsAtclCnt) {
        this.dscsAtclCnt = dscsAtclCnt;
    }

    public Integer getDscsCmntCnt() {
        return dscsCmntCnt;
    }

    public void setDscsCmntCnt(Integer dscsCmntCnt) {
        this.dscsCmntCnt = dscsCmntCnt;
    }

    public Integer getDscsMyAtclCnt() {
        return dscsMyAtclCnt;
    }

    public void setDscsMyAtclCnt(Integer dscsMyAtclCnt) {
        this.dscsMyAtclCnt = dscsMyAtclCnt;
    }

    public Integer getDscsMyCmntCnt() {
        return dscsMyCmntCnt;
    }

    public void setDscsMyCmntCnt(Integer dscsMyCmntCnt) {
        this.dscsMyCmntCnt = dscsMyCmntCnt;
    }

    public Integer getDscsAtclPorsCnt() {
        return dscsAtclPorsCnt;
    }

    public void setDscsAtclPorsCnt(Integer dscsAtclPorsCnt) {
        this.dscsAtclPorsCnt = dscsAtclPorsCnt;
    }

    public Integer getDscsAtclConsCnt() {
        return dscsAtclConsCnt;
    }

    public void setDscsAtclConsCnt(Integer dscsAtclConsCnt) {
        this.dscsAtclConsCnt = dscsAtclConsCnt;
    }

    public Integer getDscsUserTotalCnt() {
        return dscsUserTotalCnt;
    }

    public void setDscsUserTotalCnt(Integer dscsUserTotalCnt) {
        this.dscsUserTotalCnt = dscsUserTotalCnt;
    }

    public Integer getDscsJoinUserCnt() {
        return dscsJoinUserCnt;
    }

    public void setDscsJoinUserCnt(Integer dscsJoinUserCnt) {
        this.dscsJoinUserCnt = dscsJoinUserCnt;
    }

    public Integer getDscsEvalCnt() {
        return dscsEvalCnt;
    }

    public void setDscsEvalCnt(Integer dscsEvalCnt) {
        this.dscsEvalCnt = dscsEvalCnt;
    }

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getStdId() { return stdId; }
    public void setStdId(String stdId) { this.stdId = stdId; }
    public String getStdList() { return stdList; }
    public void setStdList(String stdList) { this.stdList = stdList; }
}
