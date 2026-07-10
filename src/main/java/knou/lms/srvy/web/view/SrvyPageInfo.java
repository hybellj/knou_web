package knou.lms.srvy.web.view;

import knou.framework.common.PageInfo;

public class SrvyPageInfo extends PageInfo {

	String srvyId;
	String srvyPtcp;
	String srvyTrgtTycd;

    public SrvyPageInfo() {
    	super();
    }

    public SrvyPageInfo(Object voObj) throws Exception {
        super(voObj); // PageInfo의 voObj 생성자 명시 호출
    }

	public String getSrvyId() {
		return srvyId;
	}

	public String getSrvyPtcp() {
		return srvyPtcp;
	}

	public String getSrvyTrgtTycd() {
		return srvyTrgtTycd;
	}

	public void setSrvyId(String srvyId) {
		this.srvyId = srvyId;
	}

	public void setSrvyPtcp(String srvyPtcp) {
		this.srvyPtcp = srvyPtcp;
	}

	public void setSrvyTrgtTycd(String srvyTrgtTycd) {
		this.srvyTrgtTycd = srvyTrgtTycd;
	}

}