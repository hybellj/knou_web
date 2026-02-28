package knou.lms.org.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class OrgAbsentRatioVO extends DefaultVO {

    private static final long serialVersionUID = -4868388899082660502L;
    /** tb_org_absent_ratio */
    private String  absentGbn;      // 결시유형구분
    private String  examGbn;        // 결시시험구분
    private Integer scorRatio;      // 결시점수비율
    private String  absentDesc;     // 결시반영내용
    
    private String  absentGbnNm;
    private String  examGbnNm;
    
    // 저장용 변수
    private List<String>  absentGbnList;
    private List<String>  examGbnList;
    private List<Integer> scorRatioList;
    private List<String>  absentDescList;
    
    public String getAbsentGbn() {
        return absentGbn;
    }
    public void setAbsentGbn(String absentGbn) {
        this.absentGbn = absentGbn;
    }
    public String getExamGbn() {
        return examGbn;
    }
    public void setExamGbn(String examGbn) {
        this.examGbn = examGbn;
    }
    public Integer getScorRatio() {
        return scorRatio;
    }
    public void setScorRatio(Integer scorRatio) {
        this.scorRatio = scorRatio;
    }
    public String getAbsentDesc() {
        return absentDesc;
    }
    public void setAbsentDesc(String absentDesc) {
        this.absentDesc = absentDesc;
    }
    public String getAbsentGbnNm() {
        return absentGbnNm;
    }
    public void setAbsentGbnNm(String absentGbnNm) {
        this.absentGbnNm = absentGbnNm;
    }
    public String getExamGbnNm() {
        return examGbnNm;
    }
    public void setExamGbnNm(String examGbnNm) {
        this.examGbnNm = examGbnNm;
    }
    public List<String> getAbsentGbnList() {
        return absentGbnList;
    }
    public void setAbsentGbnList(List<String> absentGbnList) {
        this.absentGbnList = absentGbnList;
    }
    public List<String> getExamGbnList() {
        return examGbnList;
    }
    public void setExamGbnList(List<String> examGbnList) {
        this.examGbnList = examGbnList;
    }
    public List<Integer> getScorRatioList() {
        return scorRatioList;
    }
    public void setScorRatioList(List<Integer> scorRatioList) {
        this.scorRatioList = scorRatioList;
    }
    public List<String> getAbsentDescList() {
        return absentDescList;
    }
    public void setAbsentDescList(List<String> absentDescList) {
        this.absentDescList = absentDescList;
    }

}
