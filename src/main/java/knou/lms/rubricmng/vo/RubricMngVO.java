package knou.lms.rubricmng.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class RubricMngVO extends DefaultVO {
    private static final long serialVersionUID = -4197838996535956673L;

    // 루브릭 기본정보
    private String rubricId;            // 루브릭 ID
    private String rubricTtl;           // 루브릭 제목
    private int rubricQstnCnt;          // 루브릭 문항 수
    private String rubricTycd;          // 루브릭 유형 코드
    private String useyn;               // 사용 여부
    private String upRubricId;          // 상위 루브릭 ID
    private String profnm;              // 교수명
    private String usernm;              // 사용자명

    // 루브릭 문항
    private String rubricQstnId;        // 루브릭 문항 ID
    private String rubricQstnTtl;       // 루브릭 문항 재목
    private int rubricQstnSeqno;        // 루브릭 문항 순번
    private int evlrt;                  // 평가 비율
    private String rubricEvlTycd;       // 루브릭 평가 유형 코드

    // 루브릭 문항 보기항목
    private String rubricVwitmId;       // 루브릭 보기항목 ID
    private String rubricVwitmTtl;      // 루브릭 보기항목 제목
    private int rubricVwitmPnt;         // 루브릭 보기항목 점수
    private int rubricVwitmSeqno;       // 루브릭 보기항목 순번

    // 등록/수정 시 파라미터로 전달되는 문항 목록
    private List<RubricMngVO> rubricQstns;
    // 보기항목 구분 문자열
    private String rubricVwitmPntList;
    private String rubricVwitmTtlList;

    public String getRubricId() {
        return rubricId;
    }

    public void setRubricId(String rubricId) {
        this.rubricId = rubricId;
    }

    public String getRubricTtl() {
        return rubricTtl;
    }

    public void setRubricTtl(String rubricTtl) {
        this.rubricTtl = rubricTtl;
    }

    public int getRubricQstnCnt() {
        return rubricQstnCnt;
    }

    public void setRubricQstnCnt(int rubricQstnCnt) {
        this.rubricQstnCnt = rubricQstnCnt;
    }

    public String getRubricTycd() {
        return rubricTycd;
    }

    public void setRubricTycd(String rubricTycd) {
        this.rubricTycd = rubricTycd;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

    public String getUpRubricId() {
        return upRubricId;
    }

    public void setUpRubricId(String upRubricId) {
        this.upRubricId = upRubricId;
    }

    public String getProfnm() {
        return profnm;
    }

    public void setProfnm(String profnm) {
        this.profnm = profnm;
    }

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }

    public String getRubricQstnId() {
        return rubricQstnId;
    }

    public void setRubricQstnId(String rubricQstnId) {
        this.rubricQstnId = rubricQstnId;
    }

    public String getRubricQstnTtl() {
        return rubricQstnTtl;
    }

    public void setRubricQstnTtl(String rubricQstnTtl) {
        this.rubricQstnTtl = rubricQstnTtl;
    }

    public int getRubricQstnSeqno() {
        return rubricQstnSeqno;
    }

    public void setRubricQstnSeqno(int rubricQstnSeqno) {
        this.rubricQstnSeqno = rubricQstnSeqno;
    }

    public int getEvlrt() {
        return evlrt;
    }

    public void setEvlrt(int evlrt) {
        this.evlrt = evlrt;
    }

    public String getRubricEvlTycd() {
        return rubricEvlTycd;
    }

    public void setRubricEvlTycd(String rubricEvlTycd) {
        this.rubricEvlTycd = rubricEvlTycd;
    }

    public String getRubricVwitmId() {
        return rubricVwitmId;
    }

    public void setRubricVwitmId(String rubricVwitmId) {
        this.rubricVwitmId = rubricVwitmId;
    }

    public String getRubricVwitmTtl() {
        return rubricVwitmTtl;
    }

    public void setRubricVwitmTtl(String rubricVwitmTtl) {
        this.rubricVwitmTtl = rubricVwitmTtl;
    }

    public int getRubricVwitmPnt() {
        return rubricVwitmPnt;
    }

    public void setRubricVwitmPnt(int rubricVwitmPnt) {
        this.rubricVwitmPnt = rubricVwitmPnt;
    }

    public int getRubricVwitmSeqno() {
        return rubricVwitmSeqno;
    }

    public void setRubricVwitmSeqno(int rubricVwitmSeqno) {
        this.rubricVwitmSeqno = rubricVwitmSeqno;
    }

    public List<RubricMngVO> getRubricQstns() {
        return rubricQstns;
    }

    public void setRubricQstns(List<RubricMngVO> rubricQstns) {
        this.rubricQstns = rubricQstns;
    }

    public String getRubricVwitmPntList() {
        return rubricVwitmPntList;
    }

    public void setRubricVwitmPntList(String rubricVwitmPntList) {
        this.rubricVwitmPntList = rubricVwitmPntList;
    }

    public String getRubricVwitmTtlList() {
        return rubricVwitmTtlList;
    }

    public void setRubricVwitmTtlList(String rubricVwitmTtlList) {
        this.rubricVwitmTtlList = rubricVwitmTtlList;
    }
}
