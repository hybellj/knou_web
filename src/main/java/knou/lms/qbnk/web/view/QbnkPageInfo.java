package knou.lms.qbnk.web.view;

import knou.framework.common.PageInfo;

public class QbnkPageInfo extends PageInfo {

	String upQbnkCtgrId;
	String qbnkCtgrId;

	public QbnkPageInfo() {
		super();
	}

	public QbnkPageInfo(Object voObj) throws Exception {
		super(voObj); // PageInfo의 voObj 생성자 명시 호출
	}

	public String getUpQbnkCtgrId() {
		return upQbnkCtgrId;
	}

	public String getQbnkCtgrId() {
		return qbnkCtgrId;
	}

	public void setUpQbnkCtgrId(String upQbnkCtgrId) {
		this.upQbnkCtgrId = upQbnkCtgrId;
	}

	public void setQbnkCtgrId(String qbnkCtgrId) {
		this.qbnkCtgrId = qbnkCtgrId;
	}

}
