package knou.lms.forum2.vo;

import java.util.List;

import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;

public class DscsVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String dscsId; // 토론아이디
    private String dscsGrpId; // 토론그룹아이디
    private String dscsGrpnm; // dscs group name
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

    private String sourceDscssId; // 복사용: 원본 토론ID
    private String targetCrsId; // 복사용: 대상 과목ID
    private String targetdvclsNo; // 복사용: 대상 분반ID
    private String targetLrnGrpId; // 복사용: 대상 학습그룹ID
    private String targetDscsGrpId; // 복사용: 대상 토론그룹ID

    private String[] dvclsNoList; // 분반별 저장 대상 DVCLS_NO 목록
    private String[] lrnGrpIdList; // 분반별 학습그룹 ID 목록
    private List<DscsDvclasSelVO> dvclasSelList; // 분반선택 목록(sbjctIds)
    private List<DscsLrnGrpVO> lrnGrpInfoList; // 학습그룹선택 목록(teamForumDiv)
    private List<DscsTeamDscsVO> teamDscsList;     // 팀토론 상세목록 (SELECT용)
    private List<DscsTeamDscsVO> teamForumDtlList; // 팀별 부주제 입력 목록 (INSERT용, JSP 바인딩)

    /*DB와 관계없는 파라미터*/
    private Integer forumAtclCnt;               // 게시글 갯수
    private Integer forumCmntCnt;               // 댓글 갯수
    private Integer forumMyAtclCnt;             // 내가 쓴 게시글 갯수
    private Integer forumMyCmntCnt;             // 내가 쓴 댓글 갯수
    private Integer forumAtclPorsCnt;           // 찬성 게시글 갯수
    private Integer forumAtclConsCnt;           // 반대 게시글 갯수
    private Integer forumUserTotalCnt;          // 총 인원 수
    private Integer forumJoinUserCnt;           // 참여자 수
    private Integer forumMyScore;               // 내 평가 점수
    private Integer forumMyFdbk;                // 패드백
    private Integer forumEvalCnt;               // 평가한 인원수

    private String smstrChrtId;                 // 학기기수아이디
    private String forumOpenYn;
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
    private String teamForumCfgYn;
    private String otherTeamViewYn;
    private String otherTeamAplyYn;
    private String forumStatus;
    private String teamTycd;
    private String teamCtgrCd;
    private String teamCtgrNm;
    private String teamNm;
    private String stdId;
    private String stdList;
    private String copyForumCd;
    private String lessonScheduleId;
    private String lessonScheduleNm;
    private String forumCtgrNm;
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

    public String getSourceDscssId() {
        return sourceDscssId;
    }

    public void setSourceDscssId(String sourceDscssId) {
        this.sourceDscssId = sourceDscssId;
    }

    public String getTargetCrsId() {
        return targetCrsId;
    }

    public void setTargetCrsId(String targetCrsId) {
        this.targetCrsId = targetCrsId;
    }

    public String getTargetdvclsNo() {
        return targetdvclsNo;
    }

    public void setTargetdvclsNo(String targetdvclsNo) {
        this.targetdvclsNo = targetdvclsNo;
    }

    public String getTargetLrnGrpId() {
        return targetLrnGrpId;
    }

    public void setTargetLrnGrpId(String targetLrnGrpId) {
        this.targetLrnGrpId = targetLrnGrpId;
    }

    public String getTargetDscsGrpId() {
        return targetDscsGrpId;
    }

    public void setTargetDscsGrpId(String targetDscsGrpId) {
        this.targetDscsGrpId = targetDscsGrpId;
    }

    public String[] getDvclsNoList() {
        return dvclsNoList;
    }

    public void setDvclsNoList(String[] dvclsNoList) {
        this.dvclsNoList = dvclsNoList;
    }

    public String[] getLrnGrpIdList() {
        return lrnGrpIdList;
    }

    public void setLrnGrpIdList(String[] lrnGrpIdList) {
        this.lrnGrpIdList = lrnGrpIdList;
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

    public List<DscsTeamDscsVO> getTeamForumDtlList() {
        return teamForumDtlList;
    }

    public void setTeamForumDtlList(List<DscsTeamDscsVO> teamForumDtlList) {
        this.teamForumDtlList = teamForumDtlList;
    }

    public Integer getForumAtclCnt() {
        return forumAtclCnt;
    }

    public void setForumAtclCnt(Integer forumAtclCnt) {
        this.forumAtclCnt = forumAtclCnt;
    }

    public Integer getForumCmntCnt() {
        return forumCmntCnt;
    }

    public void setForumCmntCnt(Integer forumCmntCnt) {
        this.forumCmntCnt = forumCmntCnt;
    }

    public Integer getForumMyAtclCnt() {
        return forumMyAtclCnt;
    }

    public void setForumMyAtclCnt(Integer forumMyAtclCnt) {
        this.forumMyAtclCnt = forumMyAtclCnt;
    }

    public Integer getForumMyCmntCnt() {
        return forumMyCmntCnt;
    }

    public void setForumMyCmntCnt(Integer forumMyCmntCnt) {
        this.forumMyCmntCnt = forumMyCmntCnt;
    }

    public Integer getForumAtclPorsCnt() {
        return forumAtclPorsCnt;
    }

    public void setForumAtclPorsCnt(Integer forumAtclPorsCnt) {
        this.forumAtclPorsCnt = forumAtclPorsCnt;
    }

    public Integer getForumAtclConsCnt() {
        return forumAtclConsCnt;
    }

    public void setForumAtclConsCnt(Integer forumAtclConsCnt) {
        this.forumAtclConsCnt = forumAtclConsCnt;
    }

    public Integer getForumUserTotalCnt() {
        return forumUserTotalCnt;
    }

    public void setForumUserTotalCnt(Integer forumUserTotalCnt) {
        this.forumUserTotalCnt = forumUserTotalCnt;
    }

    public Integer getForumJoinUserCnt() {
        return forumJoinUserCnt;
    }

    public void setForumJoinUserCnt(Integer forumJoinUserCnt) {
        this.forumJoinUserCnt = forumJoinUserCnt;
    }

    public Integer getForumMyScore() {
        return forumMyScore;
    }

    public void setForumMyScore(Integer forumMyScore) {
        this.forumMyScore = forumMyScore;
    }

    public Integer getForumMyFdbk() {
        return forumMyFdbk;
    }

    public void setForumMyFdbk(Integer forumMyFdbk) {
        this.forumMyFdbk = forumMyFdbk;
    }

    public Integer getForumEvalCnt() {
        return forumEvalCnt;
    }

    public void setForumEvalCnt(Integer forumEvalCnt) {
        this.forumEvalCnt = forumEvalCnt;
    }

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getForumOpenYn() { return forumOpenYn; }
    public void setForumOpenYn(String forumOpenYn) { this.forumOpenYn = forumOpenYn; }
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
    public String getTeamForumCfgYn() { return teamForumCfgYn; }
    public void setTeamForumCfgYn(String teamForumCfgYn) { this.teamForumCfgYn = teamForumCfgYn; }
    public String getOtherTeamViewYn() { return otherTeamViewYn; }
    public void setOtherTeamViewYn(String otherTeamViewYn) { this.otherTeamViewYn = otherTeamViewYn; }
    public String getOtherTeamAplyYn() { return otherTeamAplyYn; }
    public void setOtherTeamAplyYn(String otherTeamAplyYn) { this.otherTeamAplyYn = otherTeamAplyYn; }
    public String getForumStatus() { return forumStatus; }
    public void setForumStatus(String forumStatus) { this.forumStatus = forumStatus; }
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
    public String getCopyForumCd() { return copyForumCd; }
    public void setCopyForumCd(String copyForumCd) { this.copyForumCd = copyForumCd; }
    public String getLessonScheduleId() { return lessonScheduleId; }
    public void setLessonScheduleId(String lessonScheduleId) { this.lessonScheduleId = lessonScheduleId; }
    public String getLessonScheduleNm() { return lessonScheduleNm; }
    public void setLessonScheduleNm(String lessonScheduleNm) { this.lessonScheduleNm = lessonScheduleNm; }
    public String getForumCtgrNm() { return forumCtgrNm; }
    public void setForumCtgrNm(String forumCtgrNm) { this.forumCtgrNm = forumCtgrNm; }
    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }
    public String getRecomStatus() { return recomStatus; }
    public void setRecomStatus(String recomStatus) { this.recomStatus = recomStatus; }
    public String[] getDeleteFileId() { return deleteFileId; }
    public void setDeleteFileId(String[] deleteFileId) { this.deleteFileId = deleteFileId; }

    public String getForumCtgrCd() { return dscsUnitTycd; }
    public void setForumCtgrCd(String forumCtgrCd) { this.dscsUnitTycd = forumCtgrCd; }
    public String getForumStartDttm() { return dscsSdttm; }
    public void setForumStartDttm(String forumStartDttm) { this.dscsSdttm = forumStartDttm; }
    public String getForumEndDttm() { return dscsEdttm; }
    public void setForumEndDttm(String forumEndDttm) { this.dscsEdttm = forumEndDttm; }
    public String getForumTitle() { return dscsTtl; }
    public void setForumTitle(String forumTitle) { this.dscsTtl = forumTitle; }
    public String getForumArtl() { return dscsCts; }
    public void setForumArtl(String forumArtl) { this.dscsCts = forumArtl; }
    public String getScoreAplyYn() { return mrkRfltyn; }
    public void setScoreAplyYn(String scoreAplyYn) { this.mrkRfltyn = scoreAplyYn; }
    public String getScoreOpenYn() { return mrkOyn; }
    public void setScoreOpenYn(String scoreOpenYn) { this.mrkOyn = scoreOpenYn; }
    public Integer getScoreRatio() { return mrkRfltrt; }
    public void setScoreRatio(Integer scoreRatio) { this.mrkRfltrt = scoreRatio; }
    public String getEvalCtgr() { return evlScrTycd; }
    public void setEvalCtgr(String evalCtgr) { this.evlScrTycd = evalCtgr; }
    @Override
    public String getCrsCreCd() { return StringUtil.isNull(sbjctId) ? super.getCrsCreCd() : sbjctId; }
    @Override
    public void setCrsCreCd(String crsCreCd) { this.sbjctId = crsCreCd; super.setCrsCreCd(crsCreCd); }
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
    public String getTeamCd() { return teamId; }
    public void setTeamCd(String teamCd) { this.teamId = teamCd; }
    public String getTeamTycd() { return teamTycd; }
    public void setTeamTycd(String teamTycd) { this.teamTycd = teamTycd; }
}






