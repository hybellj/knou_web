package knou.lms.common.vo;

public class OrgAuthGrpMenuVO extends DefaultVO {

	private static final long serialVersionUID = -3308430116976261759L;

	private String  menuType;
	private String  menuCd;
	private String  viewAuth;
	private String  creAuth;
	private String  modAuth;
	private String  delAuth;
    private String  classOwnerType;
    private String  classLearnerType;

	private String	menuArray;
	private String	viewAuthArray;
	private String	creAuthArray;
    private String  crsTypeCd;
    
	public String getAuthrtGrpcd() {
		return menuType;
	}
	public void setAuthrtGrpcd(String menuType) {
		this.menuType = menuType;
	}
	public String getMenuCd() {
		return menuCd;
	}
	public void setMenuCd(String menuCd) {
		this.menuCd = menuCd;
	}
	public String getViewAuth() {
		return viewAuth;
	}
	public void setViewAuth(String viewAuth) {
		this.viewAuth = viewAuth;
	}
	public String getCreAuth() {
		return creAuth;
	}
	public void setCreAuth(String creAuth) {
		this.creAuth = creAuth;
	}
	public String getModAuth() {
		return modAuth;
	}
	public void setModAuth(String modAuth) {
		this.modAuth = modAuth;
	}
	public String getDelAuth() {
		return delAuth;
	}
	public void setDelAuth(String delAuth) {
		this.delAuth = delAuth;
	}
    public String getClassOwnerType() {
        return classOwnerType;
    }
    public void setClassOwnerType(String classOwnerType) {
        this.classOwnerType = classOwnerType;
    }
    public String getClassLearnerType() {
        return classLearnerType;
    }
    public void setClassLearnerType(String classLearnerType) {
        this.classLearnerType = classLearnerType;
    }
	public String getMenuArray() {
		return menuArray;
	}
	public void setMenuArray(String menuArray) {
		this.menuArray = menuArray;
	}
	public String getViewAuthArray() {
	    return viewAuthArray;
	}
	public void setViewAuthArray(String viewAuthArray) {
	    this.viewAuthArray = viewAuthArray;
	}
	public String getCreAuthArray() {
		return creAuthArray;
	}
	public void setCreAuthArray(String creAuthArray) {
		this.creAuthArray = creAuthArray;
	}	
    public String getCrsTypeCd() {
        return crsTypeCd;
    }
    public void setCrsTypeCd(String crsTypeCd) {
        this.crsTypeCd = crsTypeCd;
    }   
}
