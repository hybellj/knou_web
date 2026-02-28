package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExampprVO extends DefaultVO {

	private static final long serialVersionUID = 8412017082780086204L;

	// TB_LMS_EXAMPPR ( 시험지 )
	private String 	exampprId;				// 시험지아이디
	private String 	tkexamId;				// 시험응시아이디
	private String 	qstnId;					// 문항아이디
	private String 	qstnDsplySeqno;			// 문항화면표시순번
	private String  qstnVwitmDsplySeqno;	// 문항보기항목화면표시순번

	public String getExampprId() {
		return exampprId;
	}
	public String getTkexamId() {
		return tkexamId;
	}
	public String getQstnId() {
		return qstnId;
	}
	public String getQstnDsplySeqno() {
		return qstnDsplySeqno;
	}
	public String getQstnVwitmDsplySeqno() {
		return qstnVwitmDsplySeqno;
	}
	public void setExampprId(String exampprId) {
		this.exampprId = exampprId;
	}
	public void setTkexamId(String tkexamId) {
		this.tkexamId = tkexamId;
	}
	public void setQstnId(String qstnId) {
		this.qstnId = qstnId;
	}
	public void setQstnDsplySeqno(String qstnDsplySeqno) {
		this.qstnDsplySeqno = qstnDsplySeqno;
	}
	public void setQstnVwitmDsplySeqno(String qstnVwitmDsplySeqno) {
		this.qstnVwitmDsplySeqno = qstnVwitmDsplySeqno;
	}

}
