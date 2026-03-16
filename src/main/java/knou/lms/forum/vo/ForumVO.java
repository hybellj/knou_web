package knou.lms.forum.vo;

import java.util.List;

import javax.validation.constraints.Size;

import knou.lms.common.vo.DefaultVO;
import knou.lms.forum2.vo.Forum2TeamDtlVO;

public class ForumVO extends DefaultVO {

    private static final long serialVersionUID = 6771664743351825074L;
    
    /* tb_lms_forum */
    private String forumCd;                     // 토론코드
    private String forumCtgrCd;                 // 토론분류코드
    private String forumEndDttm;                // 토론 종료일시
    private String forumStartDttm;              // 토론시작일시
    private String forumOpenYn;                 // 토론공개여부
    private String extStartDttm;                // 토론연장시작일시
    private String extEndDttm;                  // 토론연장종료일시
    private String periodAfterWriteYn;          // 기간후작성여부
    private String scoreAplyYn;                 // 성적적용여부
    private String scoreOpenYn;                 // 성적공개여부
    private String scoreOpenDttm;               // 성적공개일시
    
    @Size(max = 200, message = "내용은 최대 200자까지 작성 가능합니다.")
    private String forumTitle;                  // 토론제목
    private String forumArtl;                   // 토론내용
    private String teamAtclOpenYn;              // 팀토론 게시글 공개여부
    private String prosConsForumCfg;            // 찬성반대토론설정
    private String prosConsRateOpenYn;          // 찬반 비율 공개
    private String regOpenYn;                   // 작성자 비공개로 설정
    private String multiAtclYn;                 // 의견글 복수 등록 가능
    private Integer evalLimitCnt;               // 평가 제한 인원 수
    private String evalRsltOpenYn;              // 평가결과 공개 여부
    private String evalStartDttm;               // 평가시작일시
    private String evalEndDttm;                 // 평가종료일시
    private String evalCritUseYn;               // 평가기준사용여부
    private Integer scoreRatio;                 // 성적 반영 비율
    private String stareType;                   // 시험 응시 유형(L - 기말, M - 중간, S - 성적반영)
    private String avgScoreOpenYn;              // 평균 성적 공개 여부
    private String declsRegYn;                  // 분반등록여부
    private String pushNoticeYn;                // 푸시 알림 여부
    private String delYn;                       // 삭제여부
    private String evalCtgr;                    // 평가방법
    private String mutEvalYn;                   // 상호평가여부
    private String aplyAsnYn;                   // 댓글 답변 요청
    private String otherViewYn;                 // 타게시글열람여부
    
    private String crsCreCd;                    // 과정 개설 코드
    private String crsCreNm;                    // 과정 개설 명
    private String declsNo;                     // 분반 번호
    private String teamForumCfgYn;              // 팀토론 설정 여부
    private String prosConsModYn;               // 찬성반대수정여부
    private String rowNum;                      // 수정자 이름
    // 26.3.16 : 팀별부토론사용여부 추가.
    private String byteamSubdscsUseyn;          // 팀별부토론사용여부
    private List<Forum2TeamDtlVO> teamForumDtlList; // 팀토론 상세목록
    private String dscsGrpnm;                   // 팀토론그룹명(=학습그룹명)

    private String orgEvalCd;                   // 평가방식 루브릭 수정전 고유 코드
    private String evalCd;                      // 평가방식 루브릭 고유 코드
    private String evalTitle;                   // 평가방식 루브릭명
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
    private String stdId;                       // 학습자 번호
    private String forumStatus;
    
    /*tb_lms_forum_team_rltn*/
    private String teamCtgrCd;                  // 팀 분류 코드
    private String teamCd;                      //팀 코드 
    private String teamCtgrNm;                  //팀 분류코드 명
    private String teamNm;                      // 팀명
    private String stdList;
//    private String teamCreateMode;
//    private String teamCreateStartDttm;
//    private String teamCreateEndDttm;
    private String newTeamCtgrCd;
    
    private List<String> crsCreCds;             // 분반 같이 등록용 과목 리스트
    private String declsGrpCd;                  // 분반 공용 등록시 사용할 그룹코드
    private String forumCds;
    private String scoreRatios;
    private String userId;
    private String termCd;
    private String termNm;

    // 좋아요, 추천 기능 용 파라미터
    private int likes;
    private String recomStatus;
    
    private String[] deleteFileId;
//    private String selectType;                // 조회유형(USER_ID, USER_NM, SUBMIT_DT
//    private String sortType;                  // 조회정렬유형
    
    private String creYear;
    private String creTerm;
    
    private String writeAuth;
    
    private String examStareTypeCd;
    private String parExamCd;
    
    private String otherTeamViewYn;
    private String otherTeamAplyYn;
    
    private String parExamEndDttm;
    private String copyForumCd;
    private String lessonScheduleId;
    private String lessonScheduleNm;
    private String forumCtgrNm;
    
    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    public String getForumCtgrCd() {
        return forumCtgrCd;
    }
    public void setForumCtgrCd(String forumCtgrCd) {
        this.forumCtgrCd = forumCtgrCd;
    }
    public String getForumEndDttm() {
        return forumEndDttm;
    }
    public void setForumEndDttm(String forumEndDttm) {
        this.forumEndDttm = forumEndDttm;
    }
    public String getForumStartDttm() {
        return forumStartDttm;
    }
    public void setForumStartDttm(String forumStartDttm) {
        this.forumStartDttm = forumStartDttm;
    }
    public String getForumOpenYn() {
        return forumOpenYn;
    }
    public void setForumOpenYn(String forumOpenYn) {
        this.forumOpenYn = forumOpenYn;
    }
    public String getPeriodAfterWriteYn() {
        return periodAfterWriteYn;
    }
    public void setPeriodAfterWriteYn(String periodAfterWriteYn) {
        this.periodAfterWriteYn = periodAfterWriteYn;
    }
    public String getScoreAplyYn() {
        return scoreAplyYn;
    }
    public void setScoreAplyYn(String scoreAplyYn) {
        this.scoreAplyYn = scoreAplyYn;
    }
    public String getScoreOpenYn() {
        return scoreOpenYn;
    }
    public void setScoreOpenYn(String scoreOpenYn) {
        this.scoreOpenYn = scoreOpenYn;
    }
    public String getScoreOpenDttm() {
        return scoreOpenDttm;
    }
    public void setScoreOpenDttm(String scoreOpenDttm) {
        this.scoreOpenDttm = scoreOpenDttm;
    }
    public String getForumTitle() {
        return forumTitle;
    }
    public void setForumTitle(String forumTitle) {
        this.forumTitle = forumTitle;
    }
    public String getForumArtl() {
        return forumArtl;
    }
    public void setForumArtl(String forumArtl) {
        this.forumArtl = forumArtl;
    }
    public String getTeamAtclOpenYn() {
        return teamAtclOpenYn;
    }
    public void setTeamAtclOpenYn(String teamAtclOpenYn) {
        this.teamAtclOpenYn = teamAtclOpenYn;
    }
    public String getProsConsForumCfg() {
        return prosConsForumCfg;
    }
    public void setProsConsForumCfg(String prosConsForumCfg) {
        this.prosConsForumCfg = prosConsForumCfg;
    }
    public String getProsConsRateOpenYn() {
        return prosConsRateOpenYn;
    }
    public void setProsConsRateOpenYn(String prosConsRateOpenYn) {
        this.prosConsRateOpenYn = prosConsRateOpenYn;
    }
    public String getRegOpenYn() {
        return regOpenYn;
    }
    public void setRegOpenYn(String regOpenYn) {
        this.regOpenYn = regOpenYn;
    }
    public String getMultiAtclYn() {
        return multiAtclYn;
    }
    public void setMultiAtclYn(String multiAtclYn) {
        this.multiAtclYn = multiAtclYn;
    }
    public Integer getEvalLimitCnt() {
        return evalLimitCnt;
    }
    public void setEvalLimitCnt(Integer evalLimitCnt) {
        this.evalLimitCnt = evalLimitCnt;
    }
    public String getEvalRsltOpenYn() {
        return evalRsltOpenYn;
    }
    public void setEvalRsltOpenYn(String evalRsltOpenYn) {
        this.evalRsltOpenYn = evalRsltOpenYn;
    }
    public Integer getScoreRatio() {
        return scoreRatio;
    }
    public void setScoreRatio(Integer scoreRatio) {
        this.scoreRatio = scoreRatio;
    }
    public String getAvgScoreOpenYn() {
        return avgScoreOpenYn;
    }
    public void setAvgScoreOpenYn(String avgScoreOpenYn) {
        this.avgScoreOpenYn = avgScoreOpenYn;
    }
    public String getDeclsRegYn() {
        return declsRegYn;
    }
    public void setDeclsRegYn(String declsRegYn) {
        this.declsRegYn = declsRegYn;
    }
    public String getPushNoticeYn() {
        return pushNoticeYn;
    }
    public void setPushNoticeYn(String pushNoticeYn) {
        this.pushNoticeYn = pushNoticeYn;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public Integer getForumAtclCnt() {
        return forumAtclCnt;
    }
    public void setForumAtclCnt(Integer forumAtclCnt) {
        this.forumAtclCnt = forumAtclCnt;
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
    public Integer getForumJoinUserCnt() {
        return forumJoinUserCnt;
    }
    public void setForumJoinUserCnt(Integer forumJoinUserCnt) {
        this.forumJoinUserCnt = forumJoinUserCnt;
    }
    public Integer getForumCmntCnt() {
        return forumCmntCnt;
    }
    public void setForumCmntCnt(Integer forumCmntCnt) {
        this.forumCmntCnt = forumCmntCnt;
    }
    public Integer getForumUserTotalCnt() {
        return forumUserTotalCnt;
    }
    public void setForumUserTotalCnt(Integer forumUserTotalCnt) {
        this.forumUserTotalCnt = forumUserTotalCnt;
    }
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public String getTeamCtgrCd() {
        return teamCtgrCd;
    }
    public void setTeamCtgrCd(String teamCtgrCd) {
        this.teamCtgrCd = teamCtgrCd;
    }
    public String getForumStatus() {
        return forumStatus;
    }
    public void setForumStatus(String forumStatus) {
        this.forumStatus = forumStatus;
    }
    /**
     * @return the evalCritUseYn
     */
    public String getEvalCritUseYn() {
        return evalCritUseYn;
    }
    /**
     * @param evalCritUseYn the evalCritUseYn to set
     */
    public void setEvalCritUseYn(String evalCritUseYn) {
        this.evalCritUseYn = evalCritUseYn;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getTeamForumCfgYn() {
        return teamForumCfgYn;
    }
    public void setTeamForumCfgYn(String teamForumCfgYn) {
        this.teamForumCfgYn = teamForumCfgYn;
    }
    public String getProsConsModYn() {
        return prosConsModYn;
    }
    public void setProsConsModYn(String prosConsModYn) {
        this.prosConsModYn = prosConsModYn;
    }
    public String getRowNum() {
        return rowNum;
    }
    public void setRowNum(String rowNum) {
        this.rowNum = rowNum;
    }

    public String getByteamSubdscsUseyn() {
        return byteamSubdscsUseyn;
    }

    public void setByteamSubdscsUseyn(String byteamSubdscsUseyn) {
        this.byteamSubdscsUseyn = byteamSubdscsUseyn;
    }

    public List<Forum2TeamDtlVO> getTeamForumDtlList() {
        return teamForumDtlList;
    }

    public void setTeamForumDtlList(List<Forum2TeamDtlVO> teamForumDtlList) {
        this.teamForumDtlList = teamForumDtlList;
    }

    public String getDscsGrpnm() {
        return dscsGrpnm;
    }

    public void setDscsGrpnm(String dscsGrpnm) {
        this.dscsGrpnm = dscsGrpnm;
    }

    public String getTeamCd() {
        return teamCd;
    }
    public void setTeamCd(String teamCd) {
        this.teamCd = teamCd;
    }
    public String getTeamCtgrNm() {
        return teamCtgrNm;
    }
    public void setTeamCtgrNm(String teamCtgrNm) {
        this.teamCtgrNm = teamCtgrNm;
    }
    public String getStdList() {
        return stdList;
    }
    public void setStdList(String stdList) {
        this.stdList = stdList;
    }
    public String getNewTeamCtgrCd() {
        return newTeamCtgrCd;
    }
    public void setNewTeamCtgrCd(String newTeamCtgrCd) {
        this.newTeamCtgrCd = newTeamCtgrCd;
    }
    public List<String> getCrsCreCds() {
        return crsCreCds;
    }
    public void setCrsCreCds(List<String> crsCreCds) {
        this.crsCreCds = crsCreCds;
    }
    public String getDeclsGrpCd() {
        return declsGrpCd;
    }
    public void setDeclsGrpCd(String declsGrpCd) {
        this.declsGrpCd = declsGrpCd;
    }
    public String getForumCds() {
        return forumCds;
    }
    public void setForumCds(String forumCds) {
        this.forumCds = forumCds;
    }
    public String getScoreRatios() {
        return scoreRatios;
    }
    public void setScoreRatios(String scoreRatios) {
        this.scoreRatios = scoreRatios;
    }
    public String getEvalCtgr() {
        return evalCtgr;
    }
    public void setEvalCtgr(String evalCtgr) {
        this.evalCtgr = evalCtgr;
    }
    public String getMutEvalYn() {
        return mutEvalYn;
    }
    public void setMutEvalYn(String mutEvalYn) {
        this.mutEvalYn = mutEvalYn;
    }
    public String getAplyAsnYn() {
        return aplyAsnYn;
    }
    public void setAplyAsnYn(String aplyAsnYn) {
        this.aplyAsnYn = aplyAsnYn;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }
    public String getTermNm() {
        return termNm;
    }
    public void setTermNm(String termNm) {
        this.termNm = termNm;
    }
    public Integer getForumEvalCnt() {
        return forumEvalCnt;
    }
    public void setForumEvalCnt(Integer forumEvalCnt) {
        this.forumEvalCnt = forumEvalCnt;
    }
    public String getCrsCreNm() {
        return crsCreNm;
    }
    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }
    public String getEvalCd() {
        return evalCd;
    }
    public void setEvalCd(String evalCd) {
        this.evalCd = evalCd;
    }
    public String getEvalTitle() {
        return evalTitle;
    }
    public void setEvalTitle(String evalTitle) {
        this.evalTitle = evalTitle;
    }
    public String getOrgEvalCd() {
        return orgEvalCd;
    }
    public void setOrgEvalCd(String orgEvalCd) {
        this.orgEvalCd = orgEvalCd;
    }
    public int getLikes() {
        return likes;
    }
    public void setLikes(int likes) {
        this.likes = likes;
    }
    public String getRecomStatus() {
        return recomStatus;
    }
    public void setRecomStatus(String recomStatus) {
        this.recomStatus = recomStatus;
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
	public String getStareType() {
		return stareType;
	}
	public void setStareType(String stareType) {
		this.stareType = stareType;
	}
	public String getEvalStartDttm() {
		return evalStartDttm;
	}
	public void setEvalStartDttm(String evalStartDttm) {
		this.evalStartDttm = evalStartDttm;
	}
	public String getEvalEndDttm() {
		return evalEndDttm;
	}
	public void setEvalEndDttm(String evalEndDttm) {
		this.evalEndDttm = evalEndDttm;
	}
	public String getExtStartDttm() {
		return extStartDttm;
	}
	public void setExtStartDttm(String extStartDttm) {
		this.extStartDttm = extStartDttm;
	}
	public String getExtEndDttm() {
		return extEndDttm;
	}
	public void setExtEndDttm(String extEndDttm) {
		this.extEndDttm = extEndDttm;
	}
	public String getDeclsNo() {
		return declsNo;
	}
	public void setDeclsNo(String declsNo) {
		this.declsNo = declsNo;
	}
	public String getOtherViewYn() {
		return otherViewYn;
	}
	public void setOtherViewYn(String otherViewYn) {
		this.otherViewYn = otherViewYn;
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
	public String getTeamNm() {
		return teamNm;
	}
	public void setTeamNm(String teamNm) {
		this.teamNm = teamNm;
	}
    public String getCreYear() {
        return creYear;
    }
    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }
    public String getCreTerm() {
        return creTerm;
    }
    public void setCreTerm(String creTerm) {
        this.creTerm = creTerm;
    }
    public String getWriteAuth() {
        return writeAuth;
    }
    public void setWriteAuth(String writeAuth) {
        this.writeAuth = writeAuth;
    }
    public String getExamStareTypeCd() {
        return examStareTypeCd;
    }
    public void setExamStareTypeCd(String examStareTypeCd) {
        this.examStareTypeCd = examStareTypeCd;
    }
    public String getParExamCd() {
        return parExamCd;
    }
    public void setParExamCd(String parExamCd) {
        this.parExamCd = parExamCd;
    }
    public String[] getDeleteFileId() {
        return deleteFileId;
    }
    public void setDeleteFileId(String[] deleteFileId) {
        this.deleteFileId = deleteFileId;
    }
    public String getOtherTeamViewYn() {
        return otherTeamViewYn;
    }
    public void setOtherTeamViewYn(String otherTeamViewYn) {
        this.otherTeamViewYn = otherTeamViewYn;
    }
    public String getOtherTeamAplyYn() {
        return otherTeamAplyYn;
    }
    public void setOtherTeamAplyYn(String otherTeamAplyYn) {
        this.otherTeamAplyYn = otherTeamAplyYn;
    }
    public String getParExamEndDttm() {
        return parExamEndDttm;
    }
    public void setParExamEndDttm(String parExamEndDttm) {
        this.parExamEndDttm = parExamEndDttm;
    }
    public String getCopyForumCd() {
        return copyForumCd;
    }
    public void setCopyForumCd(String copyForumCd) {
        this.copyForumCd = copyForumCd;
    }
    public String getLessonScheduleId() {
        return lessonScheduleId;
    }
    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }
    public String getLessonScheduleNm() {
        return lessonScheduleNm;
    }
    public void setLessonScheduleNm(String lessonScheduleNm) {
        this.lessonScheduleNm = lessonScheduleNm;
    }
    public String getForumCtgrNm() {
        return forumCtgrNm;
    }
    public void setForumCtgrNm(String forumCtgrNm) {
        this.forumCtgrNm = forumCtgrNm;
    }

}
