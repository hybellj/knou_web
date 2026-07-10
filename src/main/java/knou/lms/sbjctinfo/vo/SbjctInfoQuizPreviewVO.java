package knou.lms.sbjctinfo.vo;

import knou.lms.common.vo.DefaultVO;

public class SbjctInfoQuizPreviewVO extends DefaultVO {

    private static final long serialVersionUID = -25773381208405745L;

    private String quizId;          // 돌발퀴즈 기본 아이디
    private String quizTtl;         // 돌발퀴즈 제목
    private Integer quizSec;        // 돌발퀴즈 노출 시점(초), 미연동 시 null

    private String qstnId;          // 문항 ID
    private Integer qstnSeqno;      // 문항 순번
    private String qstnRspnsTycd;   // 문항 답변유형코드
    private String qstnTtl;         // 문항 제목
    private String qstnCts;         // 문항 내용

    private String qstnVwitmId;     // 보기 ID
    private Integer qstnVwitmSeqno; // 보기 순번
    private String exCts;           // 보기 내용
    private String cransYn;         // 정답 여부
    private String cransExpln;      // 정답 설명

    public String getQuizId() { return quizId; }
    public void setQuizId(String quizId) { this.quizId = quizId; }

    public String getQuizTtl() { return quizTtl; }
    public void setQuizTtl(String quizTtl) { this.quizTtl = quizTtl; }

    public Integer getQuizSec() { return quizSec; }
    public void setQuizSec(Integer quizSec) { this.quizSec = quizSec; }

    public String getQstnId() { return qstnId; }
    public void setQstnId(String qstnId) { this.qstnId = qstnId; }

    public Integer getQstnSeqno() { return qstnSeqno; }
    public void setQstnSeqno(Integer qstnSeqno) { this.qstnSeqno = qstnSeqno; }

    public String getQstnRspnsTycd() { return qstnRspnsTycd; }
    public void setQstnRspnsTycd(String qstnRspnsTycd) { this.qstnRspnsTycd = qstnRspnsTycd; }

    public String getQstnTtl() { return qstnTtl; }
    public void setQstnTtl(String qstnTtl) { this.qstnTtl = qstnTtl; }

    public String getQstnCts() { return qstnCts; }
    public void setQstnCts(String qstnCts) { this.qstnCts = qstnCts; }

    public String getQstnVwitmId() { return qstnVwitmId; }
    public void setQstnVwitmId(String qstnVwitmId) { this.qstnVwitmId = qstnVwitmId; }

    public Integer getQstnVwitmSeqno() { return qstnVwitmSeqno; }
    public void setQstnVwitmSeqno(Integer qstnVwitmSeqno) { this.qstnVwitmSeqno = qstnVwitmSeqno; }

    public String getExCts() { return exCts; }
    public void setExCts(String exCts) { this.exCts = exCts; }

    public String getCransYn() { return cransYn; }
    public void setCransYn(String cransYn) { this.cransYn = cransYn; }

    public String getCransExpln() { return cransExpln; }
    public void setCransExpln(String cransExpln) { this.cransExpln = cransExpln; }
}
