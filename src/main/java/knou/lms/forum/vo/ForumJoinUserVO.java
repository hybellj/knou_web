package knou.lms.forum.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ForumJoinUserVO extends DefaultVO {
	private static final long serialVersionUID = 2877017439237698606L;

	private String  crsCreCd;
    private String  stdId;          // 수강생 번호
    private String  stdntNo;        // 학번.
    private String  stdIds;
    private List<String> stdIdList;
    
    private String  forumCd;        // 토론 코드
    private String  teamCd;         // 팀 코드
    private Double  score;          // 점수
    private String  scoreNull;
    private String  leaderYn;       // 팀장 여부
    private String  evalYn;         // 평가 여부
    private String  delYn;          // 삭제 여부
    private String  profMemo;       // 교수 메모
    private String  fdbkCts;        // 피드백
    
    private String  forumTitle;     // 토론제목
    private String  forumStartDttm; // 토론시작일시
    private String  forumEndDttm;   // 토론 종료일시
    
    private String  scoreType;
    private String  joinStatus;
    
    private Integer actlCnt;
    private Integer cmntCnt;
    private String  mutEvalYn;
    private String  evalRsltOpenYn;	// 평가결과공개여부
    private String  evalStartDttm;	// 평가시작일시
    private String  evalEndDttm;	// 평가종료일시
    
    private Integer forumAtclCnt;   //게시글 갯수
    private Integer forumCmntCnt;   //댓글 갯수
    private Integer forumMyAtclCnt; //내가 쓴 게시글 갯수
    private Integer forumMyCmntCnt; //내가 쓴 댓글 갯수
    
    private String	scoreArr;
    private String	scoreList;
    
    private String  conditionType;
    
    private String	deptNm;
    private String	teamNm;          // 팀명
    private String	memberRole;      // 역할
    private String	forumCtgrCd;     // 팀 토론 여부

    private int		mutCnt;			// 참여 인원
    private int		mutAvg;			// 평균 별점
    private String	mutSn;			// 상호평가 참여 고유번호
    
    private String	mobileNo;
    private String	email;
    
    private Long	ctsLen;			// 글자수
    private String	chkCmnt;		// 댓글 포함 여부
    private String	grscDegrCorsGbn;
    private String	grscDegrCorsGbnNm;

    private String  dscsPtcpId;         // 토론참여 PK (TB_LMS_DSCS_PTCP.DSCS_PTCP_ID)

    public String getDscsPtcpId() {
        return dscsPtcpId;
    }
    public void setDscsPtcpId(String dscsPtcpId) {
        this.dscsPtcpId = dscsPtcpId;
    }

    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    public String getTeamCd() {
        return teamCd;
    }
    public void setTeamCd(String teamCd) {
        this.teamCd = teamCd;
    }
    public Double getScore() {
        return score;
    }
    public void setScore(Double score) {
        this.score = score;
    }
    public String getEvalYn() {
        return evalYn;
    }
    public void setEvalYn(String evalYn) {
        this.evalYn = evalYn;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getStdIds() {
        return stdIds;
    }
    public void setStdIds(String stdIds) {
        this.stdIds = stdIds;
    }
    public String getScoreType() {
        return scoreType;
    }
    public void setScoreType(String scoreType) {
        this.scoreType = scoreType;
    }
    public String getJoinStatus() {
        return joinStatus;
    }
    public void setJoinStatus(String joinStatus) {
        this.joinStatus = joinStatus;
    }
    public Integer getActlCnt() {
        return actlCnt;
    }
    public void setActlCnt(Integer actlCnt) {
        this.actlCnt = actlCnt;
    }
    public Integer getCmntCnt() {
        return cmntCnt;
    }
    public void setCmntCnt(Integer cmntCnt) {
        this.cmntCnt = cmntCnt;
    }
    public List<String> getStdIdList() {
        return stdIdList;
    }
    public void setStdIdList(List<String> stdIdList) {
        this.stdIdList = stdIdList;
    }
    public String getScoreArr() {
        return scoreArr;
    }
    public void setScoreArr(String scoreArr) {
        this.scoreArr = scoreArr;
    }
    public String getConditionType() {
        return conditionType;
    }
    public void setConditionType(String conditionType) {
        this.conditionType = conditionType;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getScoreList() {
        return scoreList;
    }
    public void setScoreList(String scoreList) {
        this.scoreList = scoreList;
    }
    public String getProfMemo() {
        return profMemo;
    }
    public void setProfMemo(String profMemo) {
        this.profMemo = profMemo;
    }
    public String getForumTitle() {
        return forumTitle;
    }
    public void setForumTitle(String forumTitle) {
        this.forumTitle = forumTitle;
    }
    public String getForumStartDttm() {
        return forumStartDttm;
    }
    public void setForumStartDttm(String forumStartDttm) {
        this.forumStartDttm = forumStartDttm;
    }
    public String getForumEndDttm() {
        return forumEndDttm;
    }
    public void setForumEndDttm(String forumEndDttm) {
        this.forumEndDttm = forumEndDttm;
    }
    public String getFdbkCts() {
        return fdbkCts;
    }
    public void setFdbkCts(String fdbkCts) {
        this.fdbkCts = fdbkCts;
    }
    public String getTeamNm() {
        return teamNm;
    }
    public void setTeamNm(String teamNm) {
        this.teamNm = teamNm;
    }
    public String getMemberRole() {
        return memberRole;
    }
    public void setMemberRole(String memberRole) {
        this.memberRole = memberRole;
    }
    public int getMutCnt() {
        return mutCnt;
    }
    public void setMutCnt(int mutCnt) {
        this.mutCnt = mutCnt;
    }
    public int getMutAvg() {
        return mutAvg;
    }
    public void setMutAvg(int mutAvg) {
        this.mutAvg = mutAvg;
    }
    public String getMutSn() {
        return mutSn;
    }
    public void setMutSn(String mutSn) {
        this.mutSn = mutSn;
    }
    public String getLeaderYn() {
        return leaderYn;
    }
    public void setLeaderYn(String leaderYn) {
        this.leaderYn = leaderYn;
    }
    public String getForumCtgrCd() {
        return forumCtgrCd;
    }
    public void setForumCtgrCd(String forumCtgrCd) {
        this.forumCtgrCd = forumCtgrCd;
    }
    public String getMobileNo() {
        return mobileNo;
    }
    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public Long getCtsLen() {
        return ctsLen;
    }
    public void setCtsLen(Long ctsLen) {
        this.ctsLen = ctsLen;
    }
    public String getChkCmnt() {
        return chkCmnt;
    }
    public void setChkCmnt(String chkCmnt) {
        this.chkCmnt = chkCmnt;
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
	public String getMutEvalYn() {
		return mutEvalYn;
	}
	public void setMutEvalYn(String mutEvalYn) {
		this.mutEvalYn = mutEvalYn;
	}
	public String getEvalRsltOpenYn() {
		return evalRsltOpenYn;
	}
	public void setEvalRsltOpenYn(String evalRsltOpenYn) {
		this.evalRsltOpenYn = evalRsltOpenYn;
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
	public String getScoreNull() {
		return scoreNull;
	}
	public void setScoreNull(String scoreNull) {
		this.scoreNull = scoreNull;
	}
    public String getGrscDegrCorsGbn() {
        return grscDegrCorsGbn;
    }
    public void setGrscDegrCorsGbn(String grscDegrCorsGbn) {
        this.grscDegrCorsGbn = grscDegrCorsGbn;
    }
    public String getGrscDegrCorsGbnNm() {
        return grscDegrCorsGbnNm;
    }
    public void setGrscDegrCorsGbnNm(String grscDegrCorsGbnNm) {
        this.grscDegrCorsGbnNm = grscDegrCorsGbnNm;
    }

}
