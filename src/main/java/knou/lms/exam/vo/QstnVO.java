package knou.lms.exam.vo;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import knou.lms.common.vo.DefaultVO;

public class QstnVO extends DefaultVO {

	private static final long serialVersionUID = -7350347079785613420L;

	// TB_LMS_QSTN ( 문항 )
	private String 	qstnId;				// 문항아이디
	private String 	examDtlId;			// 시험상세아이디
	private String 	qstnTtl;			// 문항제목
	private String 	qstnCts;			// 문항내용
	private Integer	qstnSeqno;			// 문항순번
	private Integer	qstnCnddtSeqno;		// 문항후보순번
	private String 	qstnGbncd;			// 문항구분코드 ( TXT : 텍스트, IMG : 이미지, VDO : 비디오, VOICE : 오디오 )
	private String 	qstnRspnsTycd;		// 문항답변유형코드 ( MLT_CHC : 다중선택형, OX_CHC : OX선택형, LEVEL : 레벨형, ONE_CHC : 단일선택형 , LONG_TEXT : 서술형 , SHORT_TEXT : 단답형, LINK : 연결형 )
	private BigDecimal qstnScr;			// 문항점수
	private String 	qstnDfctlvTycd;		// 문항난이도유형코드 ( NONE : 상관없음, LOW : 하, MIDDLE : 중, HIGH : 상 )
	private String 	edtrUseyn;			// 편집기사용여부
	private String 	cransTycd;			// 정답유형코드 ( CRANS_INORDER : 정답순서에맞춰서, CRANS_NOT_INORDER : 정답순서에상관없이, CRANS_MLT : 다중정답 )
	private String 	delyn;				// 삭제여부

	private List<Map<String, Object>> qstns;	// 문항 등록용
	private String  examBscId;					// 시험기본아이디
	private Integer qstnCnt;                    // 문항 수
	private String  qstnRspnsTynm;				// 문항답변유형코드명

	private List<QstnVwitmVO> vwitmList;		// 문항보기항목 목록

	public String getQstnId() {
		return qstnId;
	}
	public String getExamDtlId() {
		return examDtlId;
	}
	public String getQstnTtl() {
		return qstnTtl;
	}
	public String getQstnCts() {
		return qstnCts;
	}
	public Integer getQstnSeqno() {
		return qstnSeqno;
	}
	public Integer getQstnCnddtSeqno() {
		return qstnCnddtSeqno;
	}
	public String getQstnGbncd() {
		return qstnGbncd;
	}
	public String getQstnRspnsTycd() {
		return qstnRspnsTycd;
	}
	public BigDecimal getQstnScr() {
		return qstnScr;
	}
	public String getQstnDfctlvTycd() {
		return qstnDfctlvTycd;
	}
	public String getEdtrUseyn() {
		return edtrUseyn;
	}
	public String getCransTycd() {
		return cransTycd;
	}
	public String getDelyn() {
		return delyn;
	}
	public void setQstnId(String qstnId) {
		this.qstnId = qstnId;
	}
	public void setExamDtlId(String examDtlId) {
		this.examDtlId = examDtlId;
	}
	public void setQstnTtl(String qstnTtl) {
		this.qstnTtl = qstnTtl;
	}
	public void setQstnCts(String qstnCts) {
		this.qstnCts = qstnCts;
	}
	public void setQstnSeqno(Integer qstnSeqno) {
		this.qstnSeqno = qstnSeqno;
	}
	public void setQstnCnddtSeqno(Integer qstnCnddtSeqno) {
		this.qstnCnddtSeqno = qstnCnddtSeqno;
	}
	public void setQstnGbncd(String qstnGbncd) {
		this.qstnGbncd = qstnGbncd;
	}
	public void setQstnRspnsTycd(String qstnRspnsTycd) {
		this.qstnRspnsTycd = qstnRspnsTycd;
	}
	public void setQstnScr(BigDecimal qstnScr) {
		this.qstnScr = qstnScr;
	}
	public void setQstnDfctlvTycd(String qstnDfctlvTycd) {
		this.qstnDfctlvTycd = qstnDfctlvTycd;
	}
	public void setEdtrUseyn(String edtrUseyn) {
		this.edtrUseyn = edtrUseyn;
	}
	public void setCransTycd(String cransTycd) {
		this.cransTycd = cransTycd;
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
	public String getExamBscId() {
		return examBscId;
	}
	public void setExamBscId(String examBscId) {
		this.examBscId = examBscId;
	}
	public Integer getQstnCnt() {
		return qstnCnt;
	}
	public void setQstnCnt(Integer qstnCnt) {
		this.qstnCnt = qstnCnt;
	}
	public String getQstnRspnsTynm() {
		return qstnRspnsTynm;
	}
	public void setQstnRspnsTynm(String qstnRspnsTynm) {
		this.qstnRspnsTynm = qstnRspnsTynm;
	}
	public List<QstnVwitmVO> getVwitmList() {
		return vwitmList;
	}
	public void setVwitmList(List<QstnVwitmVO> vwitmList) {
		this.vwitmList = vwitmList;
	}

}
