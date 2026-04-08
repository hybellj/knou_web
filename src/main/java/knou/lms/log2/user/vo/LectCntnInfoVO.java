package knou.lms.log2.user.vo;

public class LectCntnInfoVO extends LogUserActvVO {

    private static final long serialVersionUID = 1L;

    /* ======================================================
     * JOIN 결과 필드 (TB_LMS_USER / TB_LMS_SBJCT / TB_LMS_ORG)
     * ====================================================== */
    /** 사용자명 */
    private String usernm;

    /** 학번/교번 */
    private String stdntNo;

    /** 대표아이디 */
    private String userRprsId;

    /** 기관명 */
    private String orgnm;

    /** 과목명 */
    private String sbjctnm;

    /** 과목연도 */
    private String sbjctYr;

    /** 과목학기 */
    private String sbjctSmstr;

    /** 학과명 (DEPT_ID 기준) */
    private String deptNm;

    /** 분반번호 */
    private String dvclasNo;

    public String getUsernm() { return usernm; }
    public void setUsernm(String usernm) { this.usernm = usernm; }

    public String getStdntNo() { return stdntNo; }
    public void setStdntNo(String stdntNo) { this.stdntNo = stdntNo; }

    public String getUserRprsId() { return userRprsId; }
    public void setUserRprsId(String userRprsId) { this.userRprsId = userRprsId; }

    public String getOrgnm() { return orgnm; }
    public void setOrgnm(String orgnm) { this.orgnm = orgnm; }

    public String getSbjctnm() { return sbjctnm; }
    public void setSbjctnm(String sbjctnm) { this.sbjctnm = sbjctnm; }

    public String getSbjctYr() { return sbjctYr; }
    public void setSbjctYr(String sbjctYr) { this.sbjctYr = sbjctYr; }

    public String getSbjctSmstr() { return sbjctSmstr; }
    public void setSbjctSmstr(String sbjctSmstr) { this.sbjctSmstr = sbjctSmstr; }

    public String getDeptNm() { return deptNm; }
    public void setDeptNm(String deptNm) { this.deptNm = deptNm; }

    public String getDvclasNo() { return dvclasNo; }
    public void setDvclasNo(String dvclasNo) { this.dvclasNo = dvclasNo; }
}
