package knou.lms.common.vo;

public class SiteStatVO extends DefaultVO {

	private static final long serialVersionUID = 7017870596053655566L;
	
	private String  orgId;
	private String	orgNm;
	private int		userStatUCnt;
	private int		userStatCCnt;
	private int		userStatFCnt;
	private int		userStatDCnt;
	private int		knowDocCnt;
	private int		knowImgCnt;
	private int		knowHtmlCnt;
	private int		knowLinkCnt;
	private int		knowMovCnt;
	private int		knowStudyCnt;
	private int		shareKnowCnt;
	
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getOrgNm() {
		return orgNm;
	}
	public void setOrgNm(String orgNm) {
		this.orgNm = orgNm;
	}
	public int getUserStatUCnt() {
		return userStatUCnt;
	}
	public void setUserStatUCnt(int userStatUCnt) {
		this.userStatUCnt = userStatUCnt;
	}
	public int getUserStatCCnt() {
		return userStatCCnt;
	}
	public void setUserStatCCnt(int userStatCCnt) {
		this.userStatCCnt = userStatCCnt;
	}
	public int getUserStatFCnt() {
		return userStatFCnt;
	}
	public void setUserStatFCnt(int userStatFCnt) {
		this.userStatFCnt = userStatFCnt;
	}
	public int getUserStatDCnt() {
		return userStatDCnt;
	}
	public void setUserStatDCnt(int userStatDCnt) {
		this.userStatDCnt = userStatDCnt;
	}
	public int getKnowDocCnt() {
		return knowDocCnt;
	}
	public void setKnowDocCnt(int knowDocCnt) {
		this.knowDocCnt = knowDocCnt;
	}
	public int getKnowImgCnt() {
		return knowImgCnt;
	}
	public void setKnowImgCnt(int knowImgCnt) {
		this.knowImgCnt = knowImgCnt;
	}
	public int getKnowHtmlCnt() {
		return knowHtmlCnt;
	}
	public void setKnowHtmlCnt(int knowHtmlCnt) {
		this.knowHtmlCnt = knowHtmlCnt;
	}
	public int getKnowLinkCnt() {
		return knowLinkCnt;
	}
	public void setKnowLinkCnt(int knowLinkCnt) {
		this.knowLinkCnt = knowLinkCnt;
	}
	public int getKnowMovCnt() {
		return knowMovCnt;
	}
	public void setKnowMovCnt(int knowMovCnt) {
		this.knowMovCnt = knowMovCnt;
	}
	public int getKnowStudyCnt() {
		return knowStudyCnt;
	}
	public void setKnowStudyCnt(int knowStudyCnt) {
		this.knowStudyCnt = knowStudyCnt;
	}
	public int getShareKnowCnt() {
		return shareKnowCnt;
	}
	public void setShareKnowCnt(int shareKnowCnt) {
		this.shareKnowCnt = shareKnowCnt;
	}
}
