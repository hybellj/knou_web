package knou.lms.resh.vo;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.DefaultVO;

public class ReshPageVO extends DefaultVO {

    /** tb_lms_resch_page */
    private String  reschPageCd;        // 설문 페이지 고유번호
    private String  reschCd;            // 설문 고유번호
    private String  reschPageTitle;     // 설문 페이지 제목
    private String  reschPageArtl;      // 설문 페이지 내용
    private Integer reschPageOdr;       // 설문 페이지 순서
    
    private List<ReshQstnVO> reschQstnList;     // 문항 리스트
    
    // 문항 가져오기
    private String   copyReschCd;           // 복사 설문 고유번호
    private String   copyReschQstnCds;
    private String[] copyReschQstnCdList;   // 복사 설문 문항 고유번호
    private String   entireCopyYn;          // 전체 복사 여부 (Y : 전체 복사, N : 일부 복사)
    
    private Integer  newReschPageOdr;
    
    private int    excelUploadSkipRows; // 엑셀 업로드 시 상단 설명글 또는 헤더 부분 이후의 실제 데이터가 시작하는 row를 찾기 위해 스킵해야하는 row 수
    private String encFileSn;
    
    private List<EgovMap> answerList;   // ezgrader 페이지용
    
    public String getReschPageCd() {
        return reschPageCd;
    }
    public void setReschPageCd(String reschPageCd) {
        this.reschPageCd = reschPageCd;
    }
    public String getReschCd() {
        return reschCd;
    }
    public void setReschCd(String reschCd) {
        this.reschCd = reschCd;
    }
    public String getReschPageTitle() {
        return reschPageTitle;
    }
    public void setReschPageTitle(String reschPageTitle) {
        this.reschPageTitle = reschPageTitle;
    }
    public String getReschPageArtl() {
        return reschPageArtl;
    }
    public void setReschPageArtl(String reschPageArtl) {
        this.reschPageArtl = reschPageArtl;
    }
    public Integer getReschPageOdr() {
        return reschPageOdr;
    }
    public void setReschPageOdr(Integer reschPageOdr) {
        this.reschPageOdr = reschPageOdr;
    }
    public List<ReshQstnVO> getReschQstnList() {
        return reschQstnList;
    }
    public void setReschQstnList(List<ReshQstnVO> reschQstnList) {
        this.reschQstnList = reschQstnList;
    }
    public String getCopyReschCd() {
        return copyReschCd;
    }
    public void setCopyReschCd(String copyReschCd) {
        this.copyReschCd = copyReschCd;
    }
    public String[] getCopyReschQstnCdList() {
        return copyReschQstnCdList;
    }
    public void setCopyReschQstnCdList(String[] copyReschQstnCdList) {
        this.copyReschQstnCdList = copyReschQstnCdList;
    }
    public String getEntireCopyYn() {
        return entireCopyYn;
    }
    public void setEntireCopyYn(String entireCopyYn) {
        this.entireCopyYn = entireCopyYn;
    }
    public String getCopyReschQstnCds() {
        return copyReschQstnCds;
    }
    public void setCopyReschQstnCds(String copyReschQstnCds) {
        this.copyReschQstnCds = copyReschQstnCds;
    }
    public Integer getNewReschPageOdr() {
        return newReschPageOdr;
    }
    public void setNewReschPageOdr(Integer newReschPageOdr) {
        this.newReschPageOdr = newReschPageOdr;
    }
    public int getExcelUploadSkipRows() {
        return excelUploadSkipRows;
    }
    public void setExcelUploadSkipRows(int excelUploadSkipRows) {
        this.excelUploadSkipRows = excelUploadSkipRows;
    }
    public String getEncFileSn() {
        return encFileSn;
    }
    public void setEncFileSn(String encFileSn) {
        this.encFileSn = encFileSn;
    }
    public List<EgovMap> getAnswerList() {
        return answerList;
    }
    public void setAnswerList(List<EgovMap> answerList) {
        this.answerList = answerList;
    }
    
}
