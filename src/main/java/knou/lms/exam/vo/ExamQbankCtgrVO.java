package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamQbankCtgrVO extends DefaultVO {

    /** tb_lms_exam_qbank_ctgr */
    private String  examQbankCtgrCd;            // 문제은행 분류 코드
    private String  orgId;                      // 기관 코드
    private String  parExamQbankCtgrCd;         // 상위 문제은행 시험 분류 코드
    private String  crsNo;                      // 학수 번호
    private String  userId;                     // 사용자 번호
    private String  examCtgrNm;                 // 시험 분류 명
    private String  examCtgrDesc;               // 시험 분류 설명
    private Integer examCtgrLvl;                // 시험 분류 레벨
    private Integer examCtgrOdr;                // 시험 분류 순서
    private String  useYn;                      // 사용 여부
    private String  delYn;                      // 삭제 여부
    
    private String  parExamCtgrNm;              // 상위 시험 분류 명
    private Integer parExamCtgrOdr;             // 상위 시험 분류 순서
    private String  crsNm;                      // 과목명
    private String  userNm;                     // 사용자명
    private String  parExamCtgrLvl;             // 상위 시험 분류 레벨
    private String  crsCreCd;
    
    public String getExamQbankCtgrCd() {
        return examQbankCtgrCd;
    }
    public void setExamQbankCtgrCd(String examQbankCtgrCd) {
        this.examQbankCtgrCd = examQbankCtgrCd;
    }
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
    public String getParExamQbankCtgrCd() {
        return parExamQbankCtgrCd;
    }
    public void setParExamQbankCtgrCd(String parExamQbankCtgrCd) {
        this.parExamQbankCtgrCd = parExamQbankCtgrCd;
    }
    public String getCrsNo() {
        return crsNo;
    }
    public void setCrsNo(String crsNo) {
        this.crsNo = crsNo;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
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
    public String getParExamCtgrNm() {
        return parExamCtgrNm;
    }
    public void setParExamCtgrNm(String parExamCtgrNm) {
        this.parExamCtgrNm = parExamCtgrNm;
    }
    public Integer getParExamCtgrOdr() {
        return parExamCtgrOdr;
    }
    public void setParExamCtgrOdr(Integer parExamCtgrOdr) {
        this.parExamCtgrOdr = parExamCtgrOdr;
    }
    public String getCrsNm() {
        return crsNm;
    }
    public void setCrsNm(String crsNm) {
        this.crsNm = crsNm;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    public String getParExamCtgrLvl() {
        return parExamCtgrLvl;
    }
    public void setParExamCtgrLvl(String parExamCtgrLvl) {
        this.parExamCtgrLvl = parExamCtgrLvl;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    
}
