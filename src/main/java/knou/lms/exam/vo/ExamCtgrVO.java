package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamCtgrVO extends DefaultVO {
    
    /** tb_lms_exam_ctgr */
    private String  examCtgrCd;         // 시험 분류 코드
    private String  orgId;              // 기관 코드
    private String  parExamCtgrCd;      // 상위 시험 분류 코드
    private String  examCtgrNm;         // 시험 분류 명
    private String  examCtgrDesc;       // 시험 분류 설명
    private Integer examCtgrLvl;        // 시험 분류 레벨
    private Integer examCtgrOdr;        // 시험 분류 순서
    private String  useYn;              // 사용 여부
    private String  delYn;              // 삭제 여부
    
    public String getExamCtgrCd() {
        return examCtgrCd;
    }
    public void setExamCtgrCd(String examCtgrCd) {
        this.examCtgrCd = examCtgrCd;
    }
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
    public String getParExamCtgrCd() {
        return parExamCtgrCd;
    }
    public void setParExamCtgrCd(String parExamCtgrCd) {
        this.parExamCtgrCd = parExamCtgrCd;
    }
    public String getExamCtgrNm() {
        return examCtgrNm;
    }
    public void setExamCtgrNm(String examCtgrNm) {
        this.examCtgrNm = examCtgrNm;
    }
    public String getExamCtgrDesc() {
        return examCtgrDesc;
    }
    public void setExamCtgrDesc(String examCtgrDesc) {
        this.examCtgrDesc = examCtgrDesc;
    }
    public Integer getExamCtgrLvl() {
        return examCtgrLvl;
    }
    public void setExamCtgrLvl(Integer examCtgrLvl) {
        this.examCtgrLvl = examCtgrLvl;
    }
    public Integer getExamCtgrOdr() {
        return examCtgrOdr;
    }
    public void setExamCtgrOdr(Integer examCtgrOdr) {
        this.examCtgrOdr = examCtgrOdr;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    
}
