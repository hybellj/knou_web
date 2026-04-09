package knou.lms.forum2.vo;

import java.util.List;

import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;

public class DscsVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String dscsId; // 토론아이디
    private String dscsGrpId; // 토론그룹아이디
    private String dscsGrpnm; // 토론 그룹명
    private String dscsGbncd; // 토론구분코드
    private String dscsUnitTycd; // 토론단위유형코드
    private String evlScrTycd; // 평가점수유형코드
    private String dscsTtl; // 토론제목
    private String dscsCts; // 토론내용
    private String dscsSdttm; // 토론시작일시
    private String dscsEdttm; // 토론종료일시
    private String dvclsNo; // 분반아이디
    private String lrnGrpId; // 학습그룹아이디
    private String delyn; // 삭제여부
    private String oatclInqyn; // 타게시글조회여부
    private String oknokrtOyn; // 찬성반대비율공개여부
    private String oknokStngyn; // 찬성반대토론설정여부
    private String oknokModyn; // 찬성반대수정여부
    private String mltOpnnRegyn; // 다중의견등록여부
    private String oknokRgtrOyn; // 찬성반대작성자공개여부
    private String cmntRspnsReqyn; // 댓글답변요청여부
    private String mrkRfltyn; // 성적반영여부
    private Integer mrkRfltrt; // 성적반영비율
    private String mrkOyn; // 성적공개여부
    private String rgtrId; // 등록자아이디
    private String regDttm; // 등록일시
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시
    private String sbjctId; // 과목아이디
    private String dvclasNo; // 분반아이디
    private String byteamDscsUseyn; // 팀별부토론사용여부
    private String upDscsId; // 상위토론ID (자식 토론 INSERT용)
    private String teamId;   // 팀ID (자식 토론 INSERT용)

    private List<DscsDvclasSelVO> dvclasSelList; // 분반선택 목록(sbjctIds)
    private List<DscsLrnGrpVO> lrnGrpInfoList; // 학습그룹선택 목록(teamForumDiv)
    private List<DscsTeamDscsVO> teamDscsList; // 팀토론 상세목록 (SELECT용)
    private List<DscsTeamDscsVO> teamDscsDtlList; // 팀별 부주제 입력 목록 (INSERT용, JSP 바인딩)

    /* DB와 관계없는 파라미터 */
    private Integer dscsAtclCnt; // 게시글 갯수
    private Integer dscsCmntCnt; // 댓글 갯수
    private Integer dscsMyAtclCnt; // 내가 쓴 게시글 갯수
    private Integer dscsMyCmntCnt; // 내가 쓴 댓글 갯수
    private Integer dscsAtclPorsCnt; // 찬성 게시글 갯수
    private Integer dscsAtclConsCnt; // 반대 게시글 갯수
    private Integer dscsUserTotalCnt; // 총 인원 수
    private Integer dscsJoinUserCnt; // 참여자 수
    private Integer dscsMyScore; // 내 평가 점수
    private Integer dscsMyFdbk; // 내 피드백 수
    private Integer dscsEvalCnt; // 평가한 인원수
    private String smstrChrtId; // 학기기수아이디
    private String dscsOpenYn;
    private String teamAtclOpenYn;
    private Integer evalLimitCnt;
    private String evalRsltOpenYn;
    private String evalCritUseYn;
    private String avgScoreOpenYn;
    private String declsRegYn;
    private String pushNoticeYn;
    private String mutEvalYn;
    private String aplyAsnYn;
    private String otherViewYn;
    private String teamDscsCfgYn;
    private String otherTeamViewYn;
    private String otherTeamAplyYn;
    private String dscsStatus;
    private String teamTycd;
    private String teamCtgrCd;
    private String teamCtgrNm;
    private String teamNm;
    private String stdId;
    private String stdList;
    private String copyDscsId;
    private String lessonScheduleId;
    private String lessonScheduleNm;
    private String dscsCtgrNm;
    private int likes;
    private String recomStatus;
    private String[] deleteFileId;

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

    public String getDvclsNo() {
        return dvclsNo;
    }

    public void setDvclsNo(String dvclsNo) {
        this.dvclsNo = dvclsNo;
    }

    public String getLrnGrpId() {
        return lrnGrpId;
    }

    public void setLrnGrpId(String lrnGrpId) {
        this.lrnGrpId = lrnGrpId;
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

    public List<DscsLrnGrpVO> getLrnGrpInfoList() {
        return lrnGrpInfoList;
    }

    public void setLrnGrpInfoList(List<DscsLrnGrpVO> lrnGrpInfoList) {
        this.lrnGrpInfoList = lrnGrpInfoList;
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

    public Integer getDscsMyScore() {
        return dscsMyScore;
    }

    public void setDscsMyScore(Integer dscsMyScore) {
        this.dscsMyScore = dscsMyScore;
    }

    public Integer getDscsMyFdbk() {
        return dscsMyFdbk;
    }

    public void setDscsMyFdbk(Integer dscsMyFdbk) {
        this.dscsMyFdbk = dscsMyFdbk;
    }

    public Integer getDscsEvalCnt() {
        return dscsEvalCnt;
    }

    public void setDscsEvalCnt(Integer dscsEvalCnt) {
        this.dscsEvalCnt = dscsEvalCnt;
    }

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getDscsOpenYn() { return dscsOpenYn; }
    public void setDscsOpenYn(String dscsOpenYn) { this.dscsOpenYn = dscsOpenYn; }
    public String getTeamAtclOpenYn() { return teamAtclOpenYn; }
    public void setTeamAtclOpenYn(String teamAtclOpenYn) { this.teamAtclOpenYn = teamAtclOpenYn; }
    public Integer getEvalLimitCnt() { return evalLimitCnt; }
    public void setEvalLimitCnt(Integer evalLimitCnt) { this.evalLimitCnt = evalLimitCnt; }
    public String getEvalRsltOpenYn() { return evalRsltOpenYn; }
    public void setEvalRsltOpenYn(String evalRsltOpenYn) { this.evalRsltOpenYn = evalRsltOpenYn; }
    public String getEvalCritUseYn() { return evalCritUseYn; }
    public void setEvalCritUseYn(String evalCritUseYn) { this.evalCritUseYn = evalCritUseYn; }
    public String getAvgScoreOpenYn() { return avgScoreOpenYn; }
    public void setAvgScoreOpenYn(String avgScoreOpenYn) { this.avgScoreOpenYn = avgScoreOpenYn; }
    public String getDeclsRegYn() { return declsRegYn; }
    public void setDeclsRegYn(String declsRegYn) { this.declsRegYn = declsRegYn; }
    public String getPushNoticeYn() { return pushNoticeYn; }
    public void setPushNoticeYn(String pushNoticeYn) { this.pushNoticeYn = pushNoticeYn; }
    public String getMutEvalYn() { return mutEvalYn; }
    public void setMutEvalYn(String mutEvalYn) { this.mutEvalYn = mutEvalYn; }
    public String getAplyAsnYn() { return aplyAsnYn; }
    public void setAplyAsnYn(String aplyAsnYn) { this.aplyAsnYn = aplyAsnYn; }
    public String getOtherViewYn() { return otherViewYn; }
    public void setOtherViewYn(String otherViewYn) { this.otherViewYn = otherViewYn; }
    public String getTeamDscsCfgYn() { return teamDscsCfgYn; }
    public void setTeamDscsCfgYn(String teamDscsCfgYn) { this.teamDscsCfgYn = teamDscsCfgYn; }
    public String getOtherTeamViewYn() { return otherTeamViewYn; }
    public void setOtherTeamViewYn(String otherTeamViewYn) { this.otherTeamViewYn = otherTeamViewYn; }
    public String getOtherTeamAplyYn() { return otherTeamAplyYn; }
    public void setOtherTeamAplyYn(String otherTeamAplyYn) { this.otherTeamAplyYn = otherTeamAplyYn; }
    public String getDscsStatus() { return dscsStatus; }
    public void setDscsStatus(String dscsStatus) { this.dscsStatus = dscsStatus; }
    public String getTeamCtgrCd() { return teamCtgrCd; }
    public void setTeamCtgrCd(String teamCtgrCd) { this.teamCtgrCd = teamCtgrCd; }
    public String getTeamCtgrNm() { return teamCtgrNm; }
    public void setTeamCtgrNm(String teamCtgrNm) { this.teamCtgrNm = teamCtgrNm; }
    public String getTeamNm() { return teamNm; }
    public void setTeamNm(String teamNm) { this.teamNm = teamNm; }
    public String getStdId() { return stdId; }
    public void setStdId(String stdId) { this.stdId = stdId; }
    public String getStdList() { return stdList; }
    public void setStdList(String stdList) { this.stdList = stdList; }
    public String getCopyDscsId() { return copyDscsId; }
    public void setCopyDscsId(String copyDscsId) { this.copyDscsId = copyDscsId; }
    public String getLessonScheduleId() { return lessonScheduleId; }
    public void setLessonScheduleId(String lessonScheduleId) { this.lessonScheduleId = lessonScheduleId; }
    public String getLessonScheduleNm() { return lessonScheduleNm; }
    public void setLessonScheduleNm(String lessonScheduleNm) { this.lessonScheduleNm = lessonScheduleNm; }
    public String getDscsCtgrNm() { return dscsCtgrNm; }
    public void setDscsCtgrNm(String dscsCtgrNm) { this.dscsCtgrNm = dscsCtgrNm; }
    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }
    public String getRecomStatus() { return recomStatus; }
    public void setRecomStatus(String recomStatus) { this.recomStatus = recomStatus; }
    public String[] getDeleteFileId() { return deleteFileId; }
    public void setDeleteFileId(String[] deleteFileId) { this.deleteFileId = deleteFileId; }

    public String getDeclsNo() { return dvclsNo; }
    public void setDeclsNo(String declsNo) { this.dvclsNo = declsNo; }
    public String getDelYn() { return delyn; }
    public void setDelYn(String delYn) { this.delyn = delYn; }
    public String getProsConsForumCfg() { return oknokStngyn; }
    public void setProsConsForumCfg(String prosConsForumCfg) { this.oknokStngyn = prosConsForumCfg; }
    public String getProsConsRateOpenYn() { return oknokrtOyn; }
    public void setProsConsRateOpenYn(String prosConsRateOpenYn) { this.oknokrtOyn = prosConsRateOpenYn; }
    public String getRegOpenYn() { return oknokRgtrOyn; }
    public void setRegOpenYn(String regOpenYn) { this.oknokRgtrOyn = regOpenYn; }
    public String getMultiAtclYn() { return mltOpnnRegyn; }
    public void setMultiAtclYn(String multiAtclYn) { this.mltOpnnRegyn = multiAtclYn; }
    public String getProsConsModYn() { return oknokModyn; }
    public void setProsConsModYn(String prosConsModYn) { this.oknokModyn = prosConsModYn; }
    public String getTeamTycd() { return teamTycd; }
    public void setTeamTycd(String teamTycd) { this.teamTycd = teamTycd; }
}
