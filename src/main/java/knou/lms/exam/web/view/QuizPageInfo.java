package knou.lms.exam.web.view;

import knou.framework.common.PageInfo;

public class QuizPageInfo extends PageInfo {

	String qstnGbncd;

	public QuizPageInfo() {
    	super();
    }

    public QuizPageInfo(Object voObj) throws Exception {
        super(voObj); // PageInfo의 voObj 생성자 명시 호출
    }

	public String getQstnGbncd() {
		return qstnGbncd;
	}

	public void setQstnGbncd(String qstnGbncd) {
		this.qstnGbncd = qstnGbncd;
	}

}
