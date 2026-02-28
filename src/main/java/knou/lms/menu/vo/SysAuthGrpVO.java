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

}
