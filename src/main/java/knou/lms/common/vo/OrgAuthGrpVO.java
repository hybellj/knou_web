package knou.lms.common.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;

public class OrgAuthGrpVO extends DefaultVO {

	private static final long serialVersionUID = -4005909597684571757L;

//	private String 	authGrpCd;
//	private String	authGrpNm;
	private String	useyn;
	private String	authrtGrpExpln;
	private int		authrtGrpSeq;

	private List<OrgAuthGrpVO> authGrpLangList;

	public int getAuthrtGrpSeq() {
		return authrtGrpSeq;
	}

	public void setAuthrtGrpSeq(int authGrpOdr) {
		this.authrtGrpSeq = authGrpOdr;
	}

	public String getAuthrtGrpExpln() {
		return authrtGrpExpln;
	}

	public void setAuthrtGrpExpln(String authGrpDesc) {
		this.authrtGrpExpln = authGrpDesc;
	}

	public String getUseyn() {
		return useyn;
	}

	public void setUseyn(String useYn) {
		this.useyn = useYn;
	}

	public List<OrgAuthGrpVO> getAuthGrpLangList() {
		if(ValidationUtils.isEmpty(authGrpLangList)) authGrpLangList = new ArrayList<OrgAuthGrpVO>();
		return authGrpLangList;
	}

	public void setAuthGrpLangList(List<OrgAuthGrpVO> authGrpLangList) {
		this.authGrpLangList = authGrpLangList;
	}
}
