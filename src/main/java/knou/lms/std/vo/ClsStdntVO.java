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
    private String deptnm;        // 학과명

    private String prgrt;         // 진도율

    // 주차별 학습상태 목록 (동적 주차 대응)
    private List<ClsWkStsVO> wkStsList;

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

    public String getPrgrt() { return prgrt; }
    public void setPrgrt(String prgrt) { this.prgrt = prgrt; }

    public List<ClsWkStsVO> getWkStsList() { return wkStsList; }
    public void setWkStsList(List<ClsWkStsVO> wkStsList) { this.wkStsList = wkStsList; }

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