package knou.lms.bbs.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

/**
 * Table: TB_LMS_BBS (게시판)
 */
public class BbsVO extends DefaultVO {
    private static final long serialVersionUID = -8061054982843918999L;

    private String bbsId;			// 게시판 아이디
    private String sbjctId;			// 과목 아이디
    private String crsCd;			// 과정 아이디

    private String bbsRefTypeId;	// 게시판 참조 유형 아이디
    private String bbsRefTycd;		// 게시판 참조 유형 코드

    private String bbsnm;			// 게시판 명
    private String bbsEnnm;			// 게시판 영문명
    private String bbsExpln;		// 게시판 설명
    private String bbsTycd;			/* 게시판 유형 코드
    								 (ex. BBS_BOARD, BBS_QNA 등등...
    								 TB_LMS_CMMN_CDDML UP_CD='BBS_TYCD' 참고)*/

    private String bbsBscLangCd;	// 게시판 기본 언어 코드 (구 dfltLangCd)
    private String menuCd;			// 메뉴 코드
    private int    mnImgFileId;		// 메인 이미지 파일아이디(구 mainImgFileSn)
    private int    listCnt;			// 목록 수 (구 listViewCnt)

    private int    atflMaxCnt;		// (구 atchFileCnt)
    private int    atflMaxsz;		// (구 atchFileSizeLimit)
    private String atflUseyn;		// (구 atchUseYn)

    private String univId;			// 대학교 아이디
    private String delyn;			// 삭제 여부


    /* 불필요 시 삭제 가능 */
    private String sysUseYn;
    private String sysDefaultYn;
    private String writeUseYn;
    private String cmntUseYn;
    private String ansrUseYn;
    private String notiUseYn;
    private String goodUseYn;
    private String atchCvsnUseYn;
    private String editorUseYn;
    private String mobileUseYn;
    private String secrtAtclUseYn;
    private String viwrUseYn;
    private String nmbrViewYn;
    private String nmbrCreYn;
    private String headUseYn;
    private String stdViewYn;
    private String useYn;
    private String lockUseYn;
    /* 불필요 시 삭제 가능 */


    // 추가
    private List<String> bbsIdList;     // 게시판 ID 리스트
    private String bbsIds;
    private String bbsTypeNm;		// 게시판 유형 명칭
    private int    noAnswerAtclCnt; // 미답변 게시글 수
    private String selectedTabYn;
    private int    atclCnt;
    private String teamCtgrCd;
    private String teamCtgrNm;
    private String teamCd;
    private String teamNm;
    private String useyn;
    private String bbsNm;
    private String bbsOptnId;
    private String optnCd;
    private String optnCdNtc;
    private String optnCdRspns;
    private List<String> optnCdList;
    private String optnUseyn;
    private String bbsAddyn;
    private String bbsOptnNm;
    private String bbsWriteUseyn;
    private String bbsUseyn;

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
	public String getCrsCd() {
		return crsCd;
	}
	public void setCrsCd(String crsCd) {
		this.crsCd = crsCd;
	}
	public String getBbsRefTypeId() {
		return bbsRefTypeId;
	}
	public void setBbsRefTypeId(String bbsRefTypeId) {
		this.bbsRefTypeId = bbsRefTypeId;
	}
	public String getBbsRefTycd() {
		return bbsRefTycd;
	}
	public void setBbsRefTycd(String bbsRefTycd) {
		this.bbsRefTycd = bbsRefTycd;
	}
	public String getBbsnm() {
		return bbsnm;
	}
	public void setBbsnm(String bbsnm) {
		this.bbsnm = bbsnm;
	}
	public String getBbsEnnm() {
		return bbsEnnm;
	}
	public void setBbsEnnm(String bbsEnnm) {
		this.bbsEnnm = bbsEnnm;
	}
	public String getBbsExpln() {
		return bbsExpln;
	}
	public void setBbsExpln(String bbsExpln) {
		this.bbsExpln = bbsExpln;
	}
	public String getBbsTycd() {
		return bbsTycd;
	}
	public void setBbsTycd(String bbsTycd) {
		this.bbsTycd = bbsTycd;
	}
	public String getBbsBscLangCd() {
		return bbsBscLangCd;
	}
	public void setBbsBscLangCd(String bbsBscLangCd) {
		this.bbsBscLangCd = bbsBscLangCd;
	}
	public String getMenuCd() {
		return menuCd;
	}
	public void setMenuCd(String menuCd) {
		this.menuCd = menuCd;
	}
	public int getMnImgFileId() {
		return mnImgFileId;
	}
	public void setMnImgFileId(int mnImgFileId) {
		this.mnImgFileId = mnImgFileId;
	}
	public int getListCnt() {
		return listCnt;
	}
	public void setListCnt(int listCnt) {
		this.listCnt = listCnt;
	}
	public int getAtflMaxCnt() {
		return atflMaxCnt;
	}
	public void setAtflMaxCnt(int atflMaxCnt) {
		this.atflMaxCnt = atflMaxCnt;
	}
	public int getAtflMaxsz() {
		return atflMaxsz;
	}
	public void setAtflMaxsz(int atflMaxsz) {
		this.atflMaxsz = atflMaxsz;
	}
	public String getAtflUseyn() {
		return atflUseyn;
	}
	public void setAtflUseyn(String atflUseyn) {
		this.atflUseyn = atflUseyn;
	}
	public String getUnivId() {
		return univId;
	}
	public void setUnivId(String univId) {
		this.univId = univId;
	}
	public String getDelyn() {
		return delyn;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}
	public String getSysUseYn() {
		return sysUseYn;
	}
	public void setSysUseYn(String sysUseYn) {
		this.sysUseYn = sysUseYn;
	}
	public String getSysDefaultYn() {
		return sysDefaultYn;
	}
	public void setSysDefaultYn(String sysDefaultYn) {
		this.sysDefaultYn = sysDefaultYn;
	}
	public String getWriteUseYn() {
		return writeUseYn;
	}
	public void setWriteUseYn(String writeUseYn) {
		this.writeUseYn = writeUseYn;
	}
	public String getCmntUseYn() {
		return cmntUseYn;
	}
	public void setCmntUseYn(String cmntUseYn) {
		this.cmntUseYn = cmntUseYn;
	}
	public String getAnsrUseYn() {
		return ansrUseYn;
	}
	public void setAnsrUseYn(String ansrUseYn) {
		this.ansrUseYn = ansrUseYn;
	}
	public String getNotiUseYn() {
		return notiUseYn;
	}
	public void setNotiUseYn(String notiUseYn) {
		this.notiUseYn = notiUseYn;
	}
	public String getGoodUseYn() {
		return goodUseYn;
	}
	public void setGoodUseYn(String goodUseYn) {
		this.goodUseYn = goodUseYn;
	}
	public String getAtchCvsnUseYn() {
		return atchCvsnUseYn;
	}
	public void setAtchCvsnUseYn(String atchCvsnUseYn) {
		this.atchCvsnUseYn = atchCvsnUseYn;
	}
	public String getEditorUseYn() {
		return editorUseYn;
	}
	public void setEditorUseYn(String editorUseYn) {
		this.editorUseYn = editorUseYn;
	}
	public String getMobileUseYn() {
		return mobileUseYn;
	}
	public void setMobileUseYn(String mobileUseYn) {
		this.mobileUseYn = mobileUseYn;
	}
	public String getSecrtAtclUseYn() {
		return secrtAtclUseYn;
	}
	public void setSecrtAtclUseYn(String secrtAtclUseYn) {
		this.secrtAtclUseYn = secrtAtclUseYn;
	}
	public String getViwrUseYn() {
		return viwrUseYn;
	}
	public void setViwrUseYn(String viwrUseYn) {
		this.viwrUseYn = viwrUseYn;
	}
	public String getNmbrViewYn() {
		return nmbrViewYn;
	}
	public void setNmbrViewYn(String nmbrViewYn) {
		this.nmbrViewYn = nmbrViewYn;
	}
	public String getNmbrCreYn() {
		return nmbrCreYn;
	}
	public void setNmbrCreYn(String nmbrCreYn) {
		this.nmbrCreYn = nmbrCreYn;
	}
	public String getHeadUseYn() {
		return headUseYn;
	}
	public void setHeadUseYn(String headUseYn) {
		this.headUseYn = headUseYn;
	}
	public String getStdViewYn() {
		return stdViewYn;
	}
	public void setStdViewYn(String stdViewYn) {
		this.stdViewYn = stdViewYn;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getLockUseYn() {
		return lockUseYn;
	}
	public void setLockUseYn(String lockUseYn) {
		this.lockUseYn = lockUseYn;
	}
	public List<String> getBbsIdList() {
		return bbsIdList;
	}
	public void setBbsIdList(List<String> bbsIdList) {
		this.bbsIdList = bbsIdList;
	}
	public String getBbsIds() {
		return bbsIds;
	}
	public void setBbsIds(String bbsIds) {
		this.bbsIds = bbsIds;
	}
	public String getBbsTypeNm() {
		return bbsTypeNm;
	}
	public void setBbsTypeNm(String bbsTypeNm) {
		this.bbsTypeNm = bbsTypeNm;
	}
	public int getNoAnswerAtclCnt() {
		return noAnswerAtclCnt;
	}
	public void setNoAnswerAtclCnt(int noAnswerAtclCnt) {
		this.noAnswerAtclCnt = noAnswerAtclCnt;
	}
	public String getSelectedTabYn() {
		return selectedTabYn;
	}
	public void setSelectedTabYn(String selectedTabYn) {
		this.selectedTabYn = selectedTabYn;
	}
	public int getAtclCnt() {
		return atclCnt;
	}
	public void setAtclCnt(int atclCnt) {
		this.atclCnt = atclCnt;
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
	public String getUseyn() {
		return useyn;
	}
	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}
	public String getBbsNm() {
		return bbsNm;
	}
	public void setBbsNm(String bbsNm) {
		this.bbsNm = bbsNm;
	}
	public String getBbsOptnId() {
		return bbsOptnId;
	}
	public void setBbsOptnId(String bbsOptnId) {
		this.bbsOptnId = bbsOptnId;
	}
	public String getOptnUseyn() {
		return optnUseyn;
	}
	public void setOptnUseyn(String optnUseyn) {
		this.optnUseyn = optnUseyn;
	}
	public List<String> getOptnCdList() {
		return optnCdList;
	}
	public void setOptnCdList(List<String> optnCdList) {
		this.optnCdList = optnCdList;
	}
	public String getOptnCd() {
		return optnCd;
	}
	public void setOptnCd(String optnCd) {
		this.optnCd = optnCd;
	}
	public String getBbsAddyn() {
		return bbsAddyn;
	}
	public void setBbsAddyn(String bbsAddyn) {
		this.bbsAddyn = bbsAddyn;
	}
	public String getBbsOptnNm() {
		return bbsOptnNm;
	}
	public void setBbsOptnNm(String bbsOptnNm) {
		this.bbsOptnNm = bbsOptnNm;
	}
	public String getOptnCdNtc() {
		return optnCdNtc;
	}
	public String getOptnCdRspns() {
		return optnCdRspns;
	}
	public String getBbsWriteUseyn() {
		return bbsWriteUseyn;
	}
	public String getBbsUseyn() {
		return bbsUseyn;
	}
	public void setOptnCdNtc(String optnCdNtc) {
		this.optnCdNtc = optnCdNtc;
	}
	public void setOptnCdRspns(String optnCdRspns) {
		this.optnCdRspns = optnCdRspns;
	}
	public void setBbsWriteUseyn(String bbsWriteUseyn) {
		this.bbsWriteUseyn = bbsWriteUseyn;
	}
	public void setBbsUseyn(String bbsUseyn) {
		this.bbsUseyn = bbsUseyn;
	}
}