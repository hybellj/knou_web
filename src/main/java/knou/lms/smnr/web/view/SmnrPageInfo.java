package knou.lms.smnr.web.view;

import knou.framework.common.PageInfo;

public class SmnrPageInfo extends PageInfo {

	String pltfrmGbncd;

	public SmnrPageInfo() {
    	super();
    }

	public SmnrPageInfo(Object voObj) throws Exception {
        super(voObj); // PageInfo의 voObj 생성자 명시 호출
    }

	public String getPltfrmGbncd() {
		return pltfrmGbncd;
	}

	public void setPltfrmGbncd(String pltfrmGbncd) {
		this.pltfrmGbncd = pltfrmGbncd;
	}

}
