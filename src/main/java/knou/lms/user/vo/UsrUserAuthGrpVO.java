package knou.lms.user.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * TB_LMS_AUTHRT (권한 그룹)
 * TB_LMS_USER_ACNT_AUTHRT (사용자 계정 권한)
 * 
 */
public class UsrUserAuthGrpVO extends DefaultVO {

	private static final long serialVersionUID = -2897766342230335596L;
	
	private String  menuTycd; 
    private String  sysTycd;	// 시스템 유형 코드
	private Integer atfl_maxsz;	// 첨부파일 최대 크기 (구 fileLimitSize)
	
	
	public String getMenuTycd() {
		return menuTycd;
	}
	
	public void setMenuTycd(String menuTycd) {
		this.menuTycd = menuTycd;
	}
	public String getSysTycd() {
		return sysTycd;
	}
	
	public void setSysTycd(String sysTypeCd) {
		this.sysTycd = sysTypeCd;
	}
	
    public Integer getAtfl_maxsz() {
        return atfl_maxsz;
    }
    
    public void setAtfl_maxsz(Integer fileLimitSize) {
        this.atfl_maxsz = fileLimitSize;
    }
}
