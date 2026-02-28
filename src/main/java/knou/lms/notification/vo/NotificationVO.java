package knou.lms.notification.vo;

import knou.lms.common.vo.DefaultVO;

public class NotificationVO extends DefaultVO{
	private static final long serialVersionUID = 1L;
	
	private String notiType;
	private String notiTypeNm;
	private Integer notiCnt;
	private String contents; 
	private String readYn;
	
	private String userNm;
	private String userId;
	private String uniCd;
	private String univGbnNm;
	
	public String getNotiType() {
		return notiType;
	}
	public void setNotiType(String notiType) {
		this.notiType = notiType;
	}
	public String getNotiTypeNm() {
		return notiTypeNm;
	}
	public void setNotiTypeNm(String notiTypeNm) {
		this.notiTypeNm = notiTypeNm;
	}
	public Integer getNotiCnt() {
		return notiCnt;
	}
	public void setNotiCnt(Integer notiCnt) {
		this.notiCnt = notiCnt;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getReadYn() {
		return readYn;
	}
	public void setReadYn(String readYn) {
		this.readYn = readYn;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getUniCd() {
		return uniCd;
	}
	public void setUniCd(String uniCd) {
		this.uniCd = uniCd;
	}
	public String getUnivGbnNm() {
		return univGbnNm;
	}
	public void setUnivGbnNm(String univGbnNm) {
		this.univGbnNm = univGbnNm;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	

	
}
