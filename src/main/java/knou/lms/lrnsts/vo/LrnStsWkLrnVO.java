package knou.lms.lrnsts.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

/**
 * 나의 학습현황 주차별 상세 팝업 - 주차 요약 VO
 */
public class LrnStsWkLrnVO extends DefaultVO {
    private static final long serialVersionUID = 7654731319320532453L;

    // 조회조건 (sbjctId, userId, orgId 는 DefaultVO 상속)
    private int    wkNo;             // 주차번호
    private String lctrWknoSchdlId;  // 주차일정 ID

    // 주차 요약
    private String atndSts;          // 출결상태(ATND/LATE/ABSNT/STUDY)
    private int    totalLrnMin;      // 총 학습시간(분)

    // 기간 내 / 기간 후 학습시간
    private int    inPrdLrnMin;      // 기간내 분
    private int    inPrdLrnSec;      // 기간내 초
    private int    aftPrdLrnMin;     // 기간후 분
    private int    aftPrdLrnSec;     // 기간후 초

    // 학습기간
    private String lrnStDt;          // 학습 시작일
    private String lrnEndDt;         // 학습 종료일
    private int    totDurMin;        // 총 인정시간(분)

    // 학습방식
    private String lrnMthd;          // 수업방식 / 학습방식

    // 차시 목록
    private List<LrnStsChsiLrnVO> chsiList;  // 차시별 학습 목록



    public int getWkNo()                { return wkNo; }
    public void setWkNo(int v)          { this.wkNo = v; }

    public String getLctrWknoSchdlId() { return lctrWknoSchdlId; }
    public void setLctrWknoSchdlId(String v) { this.lctrWknoSchdlId = v; }

    public String getAtndSts()          { return atndSts; }
    public void setAtndSts(String v)    { this.atndSts = v; }

    public int getTotalLrnMin()         { return totalLrnMin; }
    public void setTotalLrnMin(int v)   { this.totalLrnMin = v; }

    public int getInPrdLrnMin()         { return inPrdLrnMin; }
    public void setInPrdLrnMin(int v)   { this.inPrdLrnMin = v; }

    public int getInPrdLrnSec()         { return inPrdLrnSec; }
    public void setInPrdLrnSec(int v)   { this.inPrdLrnSec = v; }

    public int getAftPrdLrnMin()        { return aftPrdLrnMin; }
    public void setAftPrdLrnMin(int v)  { this.aftPrdLrnMin = v; }

    public int getAftPrdLrnSec()        { return aftPrdLrnSec; }
    public void setAftPrdLrnSec(int v)  { this.aftPrdLrnSec = v; }

    public String getLrnStDt()          { return lrnStDt; }
    public void setLrnStDt(String v)    { this.lrnStDt = v; }

    public String getLrnEndDt()         { return lrnEndDt; }
    public void setLrnEndDt(String v)   { this.lrnEndDt = v; }

    public int getTotDurMin()           { return totDurMin; }
    public void setTotDurMin(int v)     { this.totDurMin = v; }

    public String getLrnMthd()          { return lrnMthd; }
    public void setLrnMthd(String v)    { this.lrnMthd = v; }

    public List<LrnStsChsiLrnVO> getChsiList() { return chsiList; }
    public void setChsiList(List<LrnStsChsiLrnVO> chsiList) { this.chsiList = chsiList; }

}