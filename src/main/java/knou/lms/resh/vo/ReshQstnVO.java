package knou.lms.resh.vo;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.DefaultVO;

public class ReshQstnVO extends DefaultVO {

    /** tb_lms_resch_qstn */
    private String  reschQstnCd;            // 설문 항목 고유번호
    private String  reschPageCd;            // 설문 페이지 고유번호
    private String  reschQstnTypeCd;        // 설문 항목 유형 코드
    private String  reschQstnTitle;         // 설문 항목 제목
    private String  reschQstnCts;           // 설문 항목 내용
    private Integer reschQstnOdr;           // 설문 항목 순서
    private String  reqChoiceYn;            // 필수 선택 여부
    private String  etcOpinionYn;           // 기타 의견 여부
    private String  jumpChoiceYn;           // 이동 선택 여부
    private Integer reschScaleLvl;          // 척도 평가 등급
    
    private List<ReshQstnItemVO> reschQstnItemList;     // 설문 항목 아이템 리스트
    private List<ReshScaleVO> reschScaleList;           // 설문 항목 척도형 리스트
    private List<EgovMap> reschAnswerList;              // 설문 항목 답변 리스트
    private Integer reschPageOdr;                       // 설문 페이지 순서
    private String  reschQstnTypeNm;                    // 설문 항목 유형 코드명
    private String  etcJumpPage;                        // 기타 항목 점프 페이지
    private String  etcItemCd;                          // 기타 항목 고유번호
    
    // 문항 추가용 변수
    private List<String> reschQstnItemTitles;
    private List<String> scaleTitles;
    private List<String> scaleScores;
    private List<String> jumpPages;
    
    private Integer newReschQstnOdr;
    
    public String getReschQstnCd() {
        return reschQstnCd;
    }
    public void setReschQstnCd(String reschQstnCd) {
        this.reschQstnCd = reschQstnCd;
    }
    public String getReschPageCd() {
        return reschPageCd;
    }
    public void setReschPageCd(String reschPageCd) {
        this.reschPageCd = reschPageCd;
    }
    public String getReschQstnTypeCd() {
        return reschQstnTypeCd;
    }
    public void setReschQstnTypeCd(String reschQstnTypeCd) {
        this.reschQstnTypeCd = reschQstnTypeCd;
    }
    public String getReschQstnTitle() {
        return reschQstnTitle;
    }
    public void setReschQstnTitle(String reschQstnTitle) {
        this.reschQstnTitle = reschQstnTitle;
    }
    public String getReschQstnCts() {
        return reschQstnCts;
    }
    public void setReschQstnCts(String reschQstnCts) {
        this.reschQstnCts = reschQstnCts;
    }
    public Integer getReschQstnOdr() {
        return reschQstnOdr;
    }
    public void setReschQstnOdr(Integer reschQstnOdr) {
        this.reschQstnOdr = reschQstnOdr;
    }
    public String getReqChoiceYn() {
        return reqChoiceYn;
    }
    public void setReqChoiceYn(String reqChoiceYn) {
        this.reqChoiceYn = reqChoiceYn;
    }
    public String getEtcOpinionYn() {
        return etcOpinionYn;
    }
    public void setEtcOpinionYn(String etcOpinionYn) {
        this.etcOpinionYn = etcOpinionYn;
    }
    public String getJumpChoiceYn() {
        return jumpChoiceYn;
    }
    public void setJumpChoiceYn(String jumpChoiceYn) {
        this.jumpChoiceYn = jumpChoiceYn;
    }
    public Integer getReschScaleLvl() {
        return reschScaleLvl;
    }
    public void setReschScaleLvl(Integer reschScaleLvl) {
        this.reschScaleLvl = reschScaleLvl;
    }
    public List<ReshQstnItemVO> getReschQstnItemList() {
        return reschQstnItemList;
    }
    public void setReschQstnItemList(List<ReshQstnItemVO> reschQstnItemList) {
        this.reschQstnItemList = reschQstnItemList;
    }
    public List<ReshScaleVO> getReschScaleList() {
        return reschScaleList;
    }
    public void setReschScaleList(List<ReshScaleVO> reschScaleList) {
        this.reschScaleList = reschScaleList;
    }
    public List<EgovMap> getReschAnswerList() {
        return reschAnswerList;
    }
    public void setReschAnswerList(List<EgovMap> reschAnswerList) {
        this.reschAnswerList = reschAnswerList;
    }
    public Integer getReschPageOdr() {
        return reschPageOdr;
    }
    public void setReschPageOdr(Integer reschPageOdr) {
        this.reschPageOdr = reschPageOdr;
    }
    public String getReschQstnTypeNm() {
        return reschQstnTypeNm;
    }
    public void setReschQstnTypeNm(String reschQstnTypeNm) {
        this.reschQstnTypeNm = reschQstnTypeNm;
    }
    public String getEtcJumpPage() {
        return etcJumpPage;
    }
    public void setEtcJumpPage(String etcJumpPage) {
        this.etcJumpPage = etcJumpPage;
    }
    public Integer getNewReschQstnOdr() {
        return newReschQstnOdr;
    }
    public void setNewReschQstnOdr(Integer newReschQstnOdr) {
        this.newReschQstnOdr = newReschQstnOdr;
    }
    public String getEtcItemCd() {
        return etcItemCd;
    }
    public void setEtcItemCd(String etcItemCd) {
        this.etcItemCd = etcItemCd;
    }
    public List<String> getReschQstnItemTitles() {
        return reschQstnItemTitles;
    }
    public void setReschQstnItemTitles(List<String> reschQstnItemTitles) {
        this.reschQstnItemTitles = reschQstnItemTitles;
    }
    public List<String> getScaleTitles() {
        return scaleTitles;
    }
    public void setScaleTitles(List<String> scaleTitles) {
        this.scaleTitles = scaleTitles;
    }
    public List<String> getScaleScores() {
        return scaleScores;
    }
    public void setScaleScores(List<String> scaleScores) {
        this.scaleScores = scaleScores;
    }
    public List<String> getJumpPages() {
        return jumpPages;
    }
    public void setJumpPages(List<String> jumpPages) {
        this.jumpPages = jumpPages;
    }
    
}
