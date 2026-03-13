package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

/**
 * 전체수업현황 - 주차별 수강생 학습현황 VO
 * 화면ID : KNOU_MN_B0102060102
 */
public class ClsStdntVO extends DefaultVO {
    private static final long serialVersionUID = 194466706021209066L;

    // TB_LMS_ATNDLC
    private String sbjctId;       // 과목 ID

    // TB_LMS_USER
    private String userId;        // 사용자 ID
    private String usernm;        // 학생 이름
    private String stdntNo;       // 학번
    private String entyR;         // 입학연도
    private String scyr;          // 학년
    private String mobileNo;      // 휴대전화
    private String email;         // 이메일

    // TB_LMS_DEPT
    private String deptnm;        // 학과명

    // TB_LMS_BYWK_USER_LRN_STS - 주차별 학습상태 (MyBatis 결과 매핑용)
    private String wk1Sts;
    private String wk2Sts;
    private String wk3Sts;
    private String wk4Sts;
    private String wk5Sts;
    private String wk6Sts;
    private String wk7Sts;
    private String wk8Sts;
    private String wk9Sts;
    private String wk10Sts;
    private String wk11Sts;
    private String wk12Sts;
    private String wk13Sts;
    private String wk14Sts;
    private String wk15Sts;

    // 출석/지각/결석 집계
    private int atndCnt;
    private int lateCnt;
    private int absnCnt;

    // 검색 조건
    private String srchKeyword;   // 이름/학번/학과 검색어
    private int    absnWknoFrom;  // 결석주차 시작
    private int    absnWknoTo;    // 결석주차 종료
    private int    wkNo;          // 주차 번호
    private List<Integer> wkList;  // MyBatis <foreach>용 입력 파라미터 (1~15 주차 리스트)
    private String excelGrid;  // 엑셀


    public String getSbjctId() { return sbjctId; }
    public void setSbjctId(String sbjctId) { this.sbjctId = sbjctId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUsernm() { return usernm; }
    public void setUsernm(String usernm) { this.usernm = usernm; }

    public String getStdntNo() { return stdntNo; }
    public void setStdntNo(String stdntNo) { this.stdntNo = stdntNo; }

    public String getEntyR() { return entyR; }
    public void setEntyR(String entyR) { this.entyR = entyR; }

    public String getScyr() { return scyr; }
    public void setScyr(String scyr) { this.scyr = scyr; }

    public String getMobileNo() { return mobileNo; }
    public void setMobileNo(String mobileNo) { this.mobileNo = mobileNo; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getDeptnm() { return deptnm; }
    public void setDeptnm(String deptnm) { this.deptnm = deptnm; }

    public String getWk1Sts() { return wk1Sts; }
    public void setWk1Sts(String wk1Sts) { this.wk1Sts = wk1Sts; }

    public String getWk2Sts() { return wk2Sts; }
    public void setWk2Sts(String wk2Sts) { this.wk2Sts = wk2Sts; }

    public String getWk3Sts() { return wk3Sts; }
    public void setWk3Sts(String wk3Sts) { this.wk3Sts = wk3Sts; }

    public String getWk4Sts() { return wk4Sts; }
    public void setWk4Sts(String wk4Sts) { this.wk4Sts = wk4Sts; }

    public String getWk5Sts() { return wk5Sts; }
    public void setWk5Sts(String wk5Sts) { this.wk5Sts = wk5Sts; }

    public String getWk6Sts() { return wk6Sts; }
    public void setWk6Sts(String wk6Sts) { this.wk6Sts = wk6Sts; }

    public String getWk7Sts() { return wk7Sts; }
    public void setWk7Sts(String wk7Sts) { this.wk7Sts = wk7Sts; }

    public String getWk8Sts() { return wk8Sts; }
    public void setWk8Sts(String wk8Sts) { this.wk8Sts = wk8Sts; }

    public String getWk9Sts() { return wk9Sts; }
    public void setWk9Sts(String wk9Sts) { this.wk9Sts = wk9Sts; }

    public String getWk10Sts() { return wk10Sts; }
    public void setWk10Sts(String wk10Sts) { this.wk10Sts = wk10Sts; }

    public String getWk11Sts() { return wk11Sts; }
    public void setWk11Sts(String wk11Sts) { this.wk11Sts = wk11Sts; }

    public String getWk12Sts() { return wk12Sts; }
    public void setWk12Sts(String wk12Sts) { this.wk12Sts = wk12Sts; }

    public String getWk13Sts() { return wk13Sts; }
    public void setWk13Sts(String wk13Sts) { this.wk13Sts = wk13Sts; }

    public String getWk14Sts() { return wk14Sts; }
    public void setWk14Sts(String wk14Sts) { this.wk14Sts = wk14Sts; }

    public String getWk15Sts() { return wk15Sts; }
    public void setWk15Sts(String wk15Sts) { this.wk15Sts = wk15Sts; }

    public int getAtndCnt() { return atndCnt; }
    public void setAtndCnt(int atndCnt) { this.atndCnt = atndCnt; }

    public int getLateCnt() { return lateCnt; }
    public void setLateCnt(int lateCnt) { this.lateCnt = lateCnt; }

    public int getAbsnCnt() { return absnCnt; }
    public void setAbsnCnt(int absnCnt) { this.absnCnt = absnCnt; }

    public String getSrchKeyword() { return srchKeyword; }
    public void setSrchKeyword(String srchKeyword) { this.srchKeyword = srchKeyword; }

    public int getAbsnWknoFrom() { return absnWknoFrom; }
    public void setAbsnWknoFrom(int absnWknoFrom) { this.absnWknoFrom = absnWknoFrom; }

    public int getAbsnWknoTo() { return absnWknoTo; }
    public void setAbsnWknoTo(int absnWknoTo) { this.absnWknoTo = absnWknoTo; }

    public int getWkNo() { return wkNo; }
    public void setWkNo(int wkNo) { this.wkNo = wkNo; }

    public List<Integer> getWkList() { return wkList; }
    public void setWkList(List<Integer> wkList) { this.wkList = wkList; }

    public String getExcelGrid() { return excelGrid; }
    public void setExcelGrid(String excelGrid) { this.excelGrid = excelGrid; }
}