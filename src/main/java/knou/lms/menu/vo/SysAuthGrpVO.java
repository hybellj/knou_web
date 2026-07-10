package knou.lms.menu.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;

public class SysAuthGrpVO extends DefaultVO {

	private static final long serialVersionUID = -4005909597684571757L;

	private String menuType;
	private String useYn;
	private String authGrpDesc;
	private int authGrpOdr;
	private String fileLimitSize;

	private String authrtId;
	private String authrtnm;
	private String authrtCd;
	private String orgId;
	private String orgnm;
	private String deptId;
	private String deptnm;
	private String userTycd;
	private String userId;
	private String usernm;
	private String cntct;
	private String eml;

	private String mode;

	private String menuAuthTycd;
    private String menuGbncd;
    private String menunm;
    private String dataGbncd;

    private String authrtMenuId;
    private String menuId;
    private String authrtMenuGbncd;
    private String crudCd;
    private String useyn;
    private String writeyn;

    private String authrtTycd;
    private String authrtChgCts;
	private List<SysAuthGrpLangVO> authGrpLangList;

	// 생성자
	public SysAuthGrpVO() {
	}

    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getAuthGrpDesc() {
        return authGrpDesc;
    }
    public void setAuthGrpDesc(String authGrpDesc) {
        this.authGrpDesc = authGrpDesc;
    }

    public int getAuthGrpOdr() {
        return authGrpOdr;
    }
    public void setAuthGrpOdr(int authGrpOdr) {
        this.authGrpOdr = authGrpOdr;
    }

    public String getFileLimitSize() {
        return fileLimitSize;
    }
    public void setFileLimitSize(String fileLimitSize) {
        this.fileLimitSize = fileLimitSize;
    }

	public List<SysAuthGrpLangVO> getAuthGrpLangList() {
		if(ValidationUtils.isEmpty(authGrpLangList)) authGrpLangList = new ArrayList<SysAuthGrpLangVO>();
		return authGrpLangList;
	}
	public void setAuthGrpLangList(List<SysAuthGrpLangVO> authGrpLangList) {
		this.authGrpLangList = authGrpLangList;
	}

	public String getMenuType() {
		return menuType;
	}

	public String getAuthrtnm() {
		return authrtnm;
	}

	public String getOrgnm() {
		return orgnm;
	}

	public String getDeptnm() {
		return deptnm;
	}

	public String getUserTycd() {
		return userTycd;
	}

	public String getUsernm() {
		return usernm;
	}

	public String getCntct() {
		return cntct;
	}

	public String getEml() {
		return eml;
	}

	public void setMenuType(String menuType) {
		this.menuType = menuType;
	}

	public void setAuthrtnm(String authrtnm) {
		this.authrtnm = authrtnm;
	}

	public void setOrgnm(String orgnm) {
		this.orgnm = orgnm;
	}

	public void setDeptnm(String deptnm) {
		this.deptnm = deptnm;
	}

	public void setUserTycd(String userTycd) {
		this.userTycd = userTycd;
	}

	public void setUsernm(String usernm) {
		this.usernm = usernm;
	}

	public void setCntct(String cntct) {
		this.cntct = cntct;
	}

	public void setEml(String eml) {
		this.eml = eml;
	}

	public String getAuthrtId() {
		return authrtId;
	}

	public String getOrgId() {
		return orgId;
	}

	public String getDeptId() {
		return deptId;
	}

	public String getUserId() {
		return userId;
	}

	public void setAuthrtId(String authrtId) {
		this.authrtId = authrtId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAuthrtCd() {
		return authrtCd;
	}

	public void setAuthrtCd(String authrtCd) {
		this.authrtCd = authrtCd;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}

	public String getMenuAuthTycd() {
		return menuAuthTycd;
	}

	public String getMenuGbncd() {
		return menuGbncd;
	}

	public String getMenunm() {
		return menunm;
	}

	public String getDataGbncd() {
		return dataGbncd;
	}

	public void setMenuAuthTycd(String menuAuthTycd) {
		this.menuAuthTycd = menuAuthTycd;
	}

	public void setMenuGbncd(String menuGbncd) {
		this.menuGbncd = menuGbncd;
	}

	public void setMenunm(String menunm) {
		this.menunm = menunm;
	}

	public void setDataGbncd(String dataGbncd) {
		this.dataGbncd = dataGbncd;
	}

	public String getAuthrtMenuId() {
		return authrtMenuId;
	}

	public String getMenuId() {
		return menuId;
	}

	public String getAuthrtMenuGbncd() {
		return authrtMenuGbncd;
	}

	public String getCrudCd() {
		return crudCd;
	}

	public String getUseyn() {
		return useyn;
	}

	public String getWriteyn() {
		return writeyn;
	}

	public void setAuthrtMenuId(String authrtMenuId) {
		this.authrtMenuId = authrtMenuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public void setAuthrtMenuGbncd(String authrtMenuGbncd) {
		this.authrtMenuGbncd = authrtMenuGbncd;
	}

	public void setCrudCd(String crudCd) {
		this.crudCd = crudCd;
	}

	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}

	public void setWriteyn(String writeyn) {
		this.writeyn = writeyn;
	}

	public String getAuthrtTycd() {
		return authrtTycd;
	}

	public void setAuthrtTycd(String authrtTycd) {
		this.authrtTycd = authrtTycd;
	}

	public String getAuthrtChgCts() {
		return authrtChgCts;
	}

	public void setAuthrtChgCts(String authrtChgCts) {
		this.authrtChgCts = authrtChgCts;
	}

}
