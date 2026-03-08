package knou.lms.bbs.vo;

import java.util.List;

import javax.validation.constraints.Size;

import knou.framework.common.CommConst;
import knou.framework.util.ValidationUtils;

/**
 * TB_LMS_BBS_ATCL (게시판 게시글)
 * TB_LMS_BBS_ATCL_INQ_RCD	(게시판 게시글 조회 기록)
 * TB_LMS_BBS_ATCL_OPTN (게시판 게시글 옵션)
 * @author 김도희
 *
 */
public class BbsAtclVO extends BbsInfoVO {
    private static final long serialVersionUID = 180723044442176021L;
    // 게시글 테이블
    private String		atclId;				// 게시글아이디
    private String		bbsId;				// 게시판아이디
    private String		userId;				// 사용자아이디
    private String		upAtclId;			// 상위게시글아이디
    private String		dvclasRegAtclId;	// 분반등록게시글아이디
    private String		atclTtl;			// 게시글제목
    private String		atclCts;			// 게시글내용
    private String		atclHashTagCts;		// 게시글해시태그내용
    private int		atclLv;				// 게시글레벨
    private int		atclSeqno;			// 게시글순번
    private int		fvrtCnt;			// 좋아요수
    private int		inqCnt;				// 조회수
    private String		refCmntId;			// 참조댓글아이디
    private String		thmbFileId;			// 썸네일파일아이디
    private String		procStscd;			// 처리상태코드
    private String		hdrTycd;			// 말머리유형코드
    private String		athrId;				// 원작자아이디
    private String		dscsnProfId;		// 상담교수아이디
    private String		srcAtclId;			// 원본게시글아이디

    private String		prevAtclId;			// 이전글아이디
    private String		prevAtclTtl;		// 이전글제목
    private String		nextAtclId;			// 다음글아이디
    private String		nextAtclTtl;		// 다음글제목

    private String	sbjctId;	// 과목 아이디
    private String	crsCreCd;

    @Size(max = 200, message = "내용은 최대 200자까지 작성 가능합니다.")
    private String	atclTagCd;	// 게시글 꼬리표 코드	(구 atclTag)
    private int	thmbFileSn;	// 썸네일 파일 아이디 (구 thumbFileSn)
    private String	vwerId;		// 조회자 아이디 (구 viwerNo)

    /* 불필요 시 삭제 가능 */
    private String	noticeYn;
    private String	cmntUseYn;
    private String	noticeStartDttm;
    private String	noticeEndDttm;
    private String	prcsStatusCd;
    private String	lockYn;
    private String	editorYn;
    private String	goodUseYn;
    private String	rsrvUseYn;
    private String	rsrvDttm;
    private String	imptYn;
    private String	delYn;
    private String	uniCd;
    private String	univGbn;

    private List<String>	bbsIdList;       // 게시판 ID 리스트
    private List<String>	declsList;       // 분반 리스트
    private String		atchUseYn;           // 첨부파일 사용여부
    private int		atchFileCnt;         // 첨부파일 수
    private int		cmntCnt;             // 댓글 수
    private int		declsNo;             // 강의실 분반
    private String		answerYn;            // 답변 완료글 여부
    private String		isNew;               // 7일내 작성글 여부
    private int		viewerGoodCnt;       // 조회 사용자 추천 수
    private String		viewYn;              // 사용자 글 조회여부
    private String		ansViewYn;           // 사용자 답글 조회여부
    private String		learnerViewModeYn;   // 학생 예약등록글 보기 모드
    private String		teamCtgrCd;          // 팀 카테고리 코드
    private String		teamCtgrNm;          // 팀 카테고리 명
    private String		teamCd;              // 팀 코드
    private String		teamNm;              // 팀 명
    private String		termCd;              // 학기코드
    private int   		noAnsCnt = 0;        // 미답변수
    private String		rsrvDttmStartYn;     // 예약등록일 시작여부
    private String[]	univGbnList;         // 대학구분 리스트

    private String		beforeAtclId;		//TODO 삭제...
    private String		afterAtclId;		//TODO 삭제...
    private int		answerAtclCnt;       // 답글 수
    private String		regMenuType;         // 등록자 메뉴타입
    private String		copyAtclId;          // 게시글 복사대상 id
    private String		rltnRefCd;
    private String		menuTycd;

    private String		contentUrls;         // 컨텐츠 경로
    private String[]	contentUrlList;

    private String orgId;

    /* 불필요 시 삭제 가능 */

    public void setContentUrls(String contentUrls) {
        this.contentUrls = contentUrls;
    }

    public String getBbsId() {
		return bbsId;
	}

	public void setBbsId(String bbsId) {
		this.bbsId = bbsId;
	}

	public String getSbjctId() {
		return sbjctId;
	}

	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
	}

	public String getAtclId() {
		return atclId;
	}

	public void setAtclId(String atclId) {
		this.atclId = atclId;
	}

	public String getUpAtclId() {
		return upAtclId;
	}

	public void setUpAtclId(String upAtclId) {
		this.upAtclId = upAtclId;
	}

	public String getDvclasRegAtclId() {
		return dvclasRegAtclId;
	}

	public void setDvclasRegAtclId(String dvclasRegAtclId) {
		this.dvclasRegAtclId = dvclasRegAtclId;
	}

	public String getCrsCreCd() {
		return crsCreCd;
	}

	public void setCrsCreCd(String crsCreCd) {
		this.crsCreCd = crsCreCd;
	}

	public String getHdrTycd() {
		return hdrTycd;
	}

	public void setHdrTycd(String hdrTycd) {
		this.hdrTycd = hdrTycd;
	}

	public String getAtclTtl() {
		return atclTtl;
	}

	public void setAtclTtl(String atclTtl) {
		this.atclTtl = atclTtl;
	}

	public String getAtclCts() {
		return atclCts;
	}

	public void setAtclCts(String atclCts) {
		this.atclCts = atclCts;
	}

	public String getAtclTagCd() {
		return atclTagCd;
	}

	public void setAtclTagCd(String atclTagCd) {
		this.atclTagCd = atclTagCd;
	}

	public int getAtclLv() {
		return atclLv;
	}

	public void setAtclLv(int atclLv) {
		this.atclLv = atclLv;
	}

	public int getThmbFileSn() {
		return thmbFileSn;
	}

	public void setThmbFileSn(int thmbFileSn) {
		this.thmbFileSn = thmbFileSn;
	}

	public int getFvrtCnt() {
		return fvrtCnt;
	}

	public void setFvrtCnt(int fvrtCnt) {
		this.fvrtCnt = fvrtCnt;
	}

	public int getInqCnt() {
		return inqCnt;
	}

	public void setInqCnt(int inqCnt) {
		this.inqCnt = inqCnt;
	}

	public String getProcStscd() {
		return procStscd;
	}

	public void setProcStscd(String procStscd) {
		this.procStscd = procStscd;
	}

	public String getRefCmntId() {
		return refCmntId;
	}

	public void setRefCmntId(String refCmntId) {
		this.refCmntId = refCmntId;
	}

	public String getVwerId() {
		return vwerId;
	}

	public void setVwerId(String vwerId) {
		this.vwerId = vwerId;
	}

	public String getAthrId() {
		return athrId;
	}

	public void setAthrId(String athrId) {
		this.athrId = athrId;
	}

	public String getDscsnProfId() {
		return dscsnProfId;
	}

	public void setDscsnProfId(String dscsnProfId) {
		this.dscsnProfId = dscsnProfId;
	}

	public String getNoticeYn() {
		return noticeYn;
	}

	public void setNoticeYn(String noticeYn) {
		this.noticeYn = noticeYn;
	}

	public String getCmntUseYn() {
		return cmntUseYn;
	}

	public void setCmntUseYn(String cmntUseYn) {
		this.cmntUseYn = cmntUseYn;
	}

	public String getNoticeStartDttm() {
		return noticeStartDttm;
	}

	public void setNoticeStartDttm(String noticeStartDttm) {
		this.noticeStartDttm = noticeStartDttm;
	}

	public String getNoticeEndDttm() {
		return noticeEndDttm;
	}

	public void setNoticeEndDttm(String noticeEndDttm) {
		this.noticeEndDttm = noticeEndDttm;
	}

	public String getPrcsStatusCd() {
		return prcsStatusCd;
	}

	public void setPrcsStatusCd(String prcsStatusCd) {
		this.prcsStatusCd = prcsStatusCd;
	}

	public String getLockYn() {
		return lockYn;
	}

	public void setLockYn(String lockYn) {
		this.lockYn = lockYn;
	}

	public String getEditorYn() {
		return editorYn;
	}

	public void setEditorYn(String editorYn) {
		this.editorYn = editorYn;
	}

	public String getGoodUseYn() {
		return goodUseYn;
	}

	public void setGoodUseYn(String goodUseYn) {
		this.goodUseYn = goodUseYn;
	}

	public String getRsrvUseYn() {
		return rsrvUseYn;
	}

	public void setRsrvUseYn(String rsrvUseYn) {
		this.rsrvUseYn = rsrvUseYn;
	}

	public String getRsrvDttm() {
		return rsrvDttm;
	}

	public void setRsrvDttm(String rsrvDttm) {
		this.rsrvDttm = rsrvDttm;
	}

	public String getImptYn() {
		return imptYn;
	}

	public void setImptYn(String imptYn) {
		this.imptYn = imptYn;
	}

	public String getDelYn() {
		return delYn;
	}

	public void setDelYn(String delYn) {
		this.delYn = delYn;
	}

	public String getUniCd() {
		return uniCd;
	}

	public void setUniCd(String uniCd) {
		this.uniCd = uniCd;
	}

	public String getUnivGbn() {
		return univGbn;
	}

	public void setUnivGbn(String univGbn) {
		this.univGbn = univGbn;
	}

	public List<String> getBbsIdList() {
		return bbsIdList;
	}

	public void setBbsIdList(List<String> bbsIdList) {
		this.bbsIdList = bbsIdList;
	}

	public List<String> getDeclsList() {
		return declsList;
	}

	public void setDeclsList(List<String> declsList) {
		this.declsList = declsList;
	}

	public String getAtchUseYn() {
		return atchUseYn;
	}

	public void setAtchUseYn(String atchUseYn) {
		this.atchUseYn = atchUseYn;
	}

	public int getAtchFileCnt() {
		return atchFileCnt;
	}

	public void setAtchFileCnt(int atchFileCnt) {
		this.atchFileCnt = atchFileCnt;
	}

	public int getCmntCnt() {
		return cmntCnt;
	}

	public void setCmntCnt(int cmntCnt) {
		this.cmntCnt = cmntCnt;
	}

	public int getDeclsNo() {
		return declsNo;
	}

	public void setDeclsNo(int declsNo) {
		this.declsNo = declsNo;
	}

	public String getAnswerYn() {
		return answerYn;
	}

	public void setAnswerYn(String answerYn) {
		this.answerYn = answerYn;
	}

	public String getIsNew() {
		return isNew;
	}

	public void setIsNew(String isNew) {
		this.isNew = isNew;
	}

	public int getViewerGoodCnt() {
		return viewerGoodCnt;
	}

	public void setViewerGoodCnt(int viewerGoodCnt) {
		this.viewerGoodCnt = viewerGoodCnt;
	}

	public String getViewYn() {
		return viewYn;
	}

	public void setViewYn(String viewYn) {
		this.viewYn = viewYn;
	}

	public String getAnsViewYn() {
		return ansViewYn;
	}

	public void setAnsViewYn(String ansViewYn) {
		this.ansViewYn = ansViewYn;
	}

	public String getLearnerViewModeYn() {
		return learnerViewModeYn;
	}

	public void setLearnerViewModeYn(String learnerViewModeYn) {
		this.learnerViewModeYn = learnerViewModeYn;
	}

	public String getTeamCtgrCd() {
		return teamCtgrCd;
	}

	public void setTeamCtgrCd(String teamCtgrCd) {
		this.teamCtgrCd = teamCtgrCd;
	}

	public String getTeamCtgrNm() {
		return teamCtgrNm;
	}

	public void setTeamCtgrNm(String teamCtgrNm) {
		this.teamCtgrNm = teamCtgrNm;
	}

	public String getTeamCd() {
		return teamCd;
	}

	public void setTeamCd(String teamCd) {
		this.teamCd = teamCd;
	}

	public String getTeamNm() {
		return teamNm;
	}

	public void setTeamNm(String teamNm) {
		this.teamNm = teamNm;
	}

	public String getTermCd() {
		return termCd;
	}

	public void setTermCd(String termCd) {
		this.termCd = termCd;
	}

	public int getNoAnsCnt() {
		return noAnsCnt;
	}

	public void setNoAnsCnt(int noAnsCnt) {
		this.noAnsCnt = noAnsCnt;
	}

	public String getRsrvDttmStartYn() {
		return rsrvDttmStartYn;
	}

	public void setRsrvDttmStartYn(String rsrvDttmStartYn) {
		this.rsrvDttmStartYn = rsrvDttmStartYn;
	}

	public String[] getUnivGbnList() {
		return univGbnList;
	}

	public void setUnivGbnList(String[] univGbnList) {
		this.univGbnList = univGbnList;
	}

	public String getBeforeAtclId() {
		return beforeAtclId;
	}

	public void setBeforeAtclId(String beforeAtclId) {
		this.beforeAtclId = beforeAtclId;
	}

	public String getAfterAtclId() {
		return afterAtclId;
	}

	public void setAfterAtclId(String afterAtclId) {
		this.afterAtclId = afterAtclId;
	}

	public int getAnswerAtclCnt() {
		return answerAtclCnt;
	}

	public void setAnswerAtclCnt(int answerAtclCnt) {
		this.answerAtclCnt = answerAtclCnt;
	}

	public String getRegMenuType() {
		return regMenuType;
	}

	public void setRegMenuType(String regMenuType) {
		this.regMenuType = regMenuType;
	}

	public String getCopyAtclId() {
		return copyAtclId;
	}

	public void setCopyAtclId(String copyAtclId) {
		this.copyAtclId = copyAtclId;
	}

	public String getRltnRefCd() {
		return rltnRefCd;
	}

	public void setRltnRefCd(String rltnRefCd) {
		this.rltnRefCd = rltnRefCd;
	}

	public String getMenuTycd() {
		return menuTycd;
	}

	public void setMenuTycd(String menuType) {
		this.menuTycd = menuType;
	}

	public String getContentUrls() {
		return contentUrls;
	}

	public void setContentUrlList(String[] contentUrlList) {
		this.contentUrlList = contentUrlList;
	}

	public String[] getContentUrlList() {
        if(ValidationUtils.isNotEmpty(contentUrls)) {
            String[] contentUrlList = contentUrls.split(",");

            for(int i = 0; i < contentUrlList.length; i++) {
                contentUrlList[i] = CommConst.WEBDATA_CONTEXT + contentUrlList[i];
            }

            return contentUrlList;
        } else {
            return null;
        }
    }

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getAtclHashTagCts() {
		return atclHashTagCts;
	}

	public String getThmbFileId() {
		return thmbFileId;
	}

	public void setAtclHashTagCts(String atclHashTagCts) {
		this.atclHashTagCts = atclHashTagCts;
	}

	public void setThmbFileId(String thmbFileId) {
		this.thmbFileId = thmbFileId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getAtclSeqno() {
		return atclSeqno;
	}

	public void setAtclSeqno(int atclSeqno) {
		this.atclSeqno = atclSeqno;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getPrevAtclId() {
		return prevAtclId;
	}

	public void setPrevAtclId(String prevAtclId) {
		this.prevAtclId = prevAtclId;
	}

	public String getPrevAtclTtl() {
		return prevAtclTtl;
	}

	public void setPrevAtclTtl(String prevAtclTtl) {
		this.prevAtclTtl = prevAtclTtl;
	}

	public String getNextAtclId() {
		return nextAtclId;
	}

	public void setNextAtclId(String nextAtclId) {
		this.nextAtclId = nextAtclId;
	}

	public String getNextAtclTtl() {
		return nextAtclTtl;
	}

	public void setNextAtclTtl(String nextAtclTtl) {
		this.nextAtclTtl = nextAtclTtl;
	}

	public String getSrcAtclId() {
		return srcAtclId;
	}

	public void setSrcAtclId(String srcAtclId) {
		this.srcAtclId = srcAtclId;
	}
}