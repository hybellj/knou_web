package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;
import java.util.List;

/**
 * 학습자 주차별 학습현황 팝업 - 주차 요약 VO
 **/

public class ClsWkLrnVO extends DefaultVO {
    private static final long serialVersionUID = 4412309871039847561L;

    // 조회 조건 (sbjctId, userId, orgId 는 DefaultVO 상속)
    private int    wkNo;          // 주차 번호
    private String elemType;      // 학습요소 유형
    private String lctrWknoSchdlId; // 주차 스케줄 ID

    // 주차 요약 - 출결
    private String atndSts;       // 출결 상태(ATND/LATE/ABSNT)
    private int    totalLrnMin;   // 총 학습시간(분)

    // 기간 내 / 기간 후 학습시간
    private int    inPrdLrnMin;   // 기간내 분
    private int    inPrdLrnSec;   // 기간내 초
    private int    aftPrdLrnMin;  // 기간후 분
    private int    aftPrdLrnSec;  // 기간후 초

    // 학습기간
    private String lrnStDt;       // 학습 시작일 (YYYY.MM.DD)
    private String lrnEndDt;      // 학습 종료일 (YYYY.MM.DD)
    private int    totDurMin;     // 총 진도 기준 분

    // 학습방식
    private String lrnMthd;       // 순차학습 / 자유학습

    // 출석인증 기간 여부 (버튼 노출 제어)
    private String atndCertUseYn; // Y: 출석인증 시작일 이후 버튼 노출
    private String lastWkYn;      // Y: 14주차 마지막일 → 버튼 숨김

    // 차시 목록 (조회 결과 담는 용도)
    private List<ClsChsiLrnVO> chsiList; //차시별 학습 목록



    public int getWkNo()                { return wkNo; }
    public void setWkNo(int v)          { this.wkNo = v; }

    public String getElemType()        { return elemType; }
    public void setElemType(String v)  { this.elemType = v; }

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

    public String getAtndCertUseYn()       { return atndCertUseYn; }
    public void setAtndCertUseYn(String v) { this.atndCertUseYn = v; }

    public String getLastWkYn()         { return lastWkYn; }
    public void setLastWkYn(String v)   { this.lastWkYn = v; }

    public List<ClsChsiLrnVO> getChsiList()              { return chsiList; }
    public void setChsiList(List<ClsChsiLrnVO> chsiList) { this.chsiList = chsiList; }
}
