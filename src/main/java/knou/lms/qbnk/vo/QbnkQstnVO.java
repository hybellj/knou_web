package knou.lms.qbnk.vo;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import knou.lms.common.vo.DefaultVO;

public class QbnkQstnVO extends DefaultVO {

	private static final long serialVersionUID = -4960904049064066347L;

	// TB_LMS_QBNK_QSTN ( 문제은행문항 )
	private String 	qbnkQstnId;			// 문제은행문항아이디
	private String 	qbnkCtgrId;			// 문제은행분류아이디
	private Integer	qstnSeqno;			// 문항순번
	private String 	qstnTtl;			// 문항제목
	private String 	qstnCts;			// 문항내용
	private String 	qstnRspnsTycd;		// 문항답변유형코드 ( MLT_CHC : 다중선택형, OX_CHC : OX선택형, LEVEL : 레벨형(척도형), ONE_CHC : 단일선택형 , LONG_TXT : 서술형 , SHORT_TXT : 단답형, ESSAY_TXT : 논술형, COUPLE : 짝짓기형 )
	private BigDecimal qstnScr;			// 문항점수
	private String 	cransTycd;			// 정답유형코드 ( CRANS_INORDER : 정답순서에맞춰서, CRANS_NOT_INORDER : 정답순서에상관없이, CRANS_MLT : 다중정답 )
	private String 	qstnDfctlvTycd;		// 문항난이도유형코드 ( NONE : 상관없음, LOW : 하, MIDDLE : 중, HIGH : 상 )
	private String 	edtrUseyn;			// 에디터사용여부
	private String 	delyn;				// 삭제여부

	private List<Map<String, Object>> qstns;	// 문항 등록용

	public String getQbnkQstnId() {
		return qbnkQstnId;
	}
	public String getQbnkCtgrId() {
		return qbnkCtgrId;
	}
	public Integer getQstnSeqno() {
		return qstnSeqno;
	}
	public String getQstnTtl() {
		return qstnTtl;
	}
	public String getQstnCts() {
		return qstnCts;
	}
	public String getQstnRspnsTycd() {
		return qstnRspnsTycd;
	}
	public BigDecimal getQstnScr() {
		return qstnScr;
	}
	public String getCransTycd() {
		return cransTycd;
	}
	public String getQstnDfctlvTycd() {
		return qstnDfctlvTycd;
	}
	public String getEdtrUseyn() {
		return edtrUseyn;
	}
	public String getDelyn() {
		return delyn;
	}
	public void setQbnkQstnId(String qbnkQstnId) {
		this.qbnkQstnId = qbnkQstnId;
	}
	public void setQbnkCtgrId(String qbnkCtgrId) {
		this.qbnkCtgrId = qbnkCtgrId;
	}
	public void setQstnSeqno(Integer qstnSeqno) {
		this.qstnSeqno = qstnSeqno;
	}
	public void setQstnTtl(String qstnTtl) {
		this.qstnTtl = qstnTtl;
	}
	public void setQstnCts(String qstnCts) {
		this.qstnCts = qstnCts;
	}
	public void setQstnRspnsTycd(String qstnRspnsTycd) {
		this.qstnRspnsTycd = qstnRspnsTycd;
	}
	public void setQstnScr(BigDecimal qstnScr) {
		this.qstnScr = qstnScr;
	}
	public void setCransTycd(String cransTycd) {
		this.cransTycd = cransTycd;
	}
	public void setQstnDfctlvTycd(String qstnDfctlvTycd) {
		this.qstnDfctlvTycd = qstnDfctlvTycd;
	}
	public void setEdtrUseyn(String edtrUseyn) {
		this.edtrUseyn = edtrUseyn;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}
	public List<Map<String, Object>> getQstns() {
		return qstns;
	}
	public void setQstns(List<Map<String, Object>> qstns) {
		this.qstns = qstns;
	}

}
