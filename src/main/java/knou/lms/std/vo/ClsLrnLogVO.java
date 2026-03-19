package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 학습자 주차별 학습현황 팝업 - 3분 단위 학습로그 VO
 * 화면ID : KNOU_MN_B0102060102 (슬라이드7 팝업)
 *
 * sbjctId, userId, lineNo 는 DefaultVO 상속
 */
public class ClsLrnLogVO extends DefaultVO {
    private static final long serialVersionUID = 6634102938475620193L;

    // 조회 조건 (sbjctId, userId 는 DefaultVO 상속)
    private String cntntsId;   // 콘텐츠 ID

    // 로그 결과 (lineNo 는 DefaultVO 상속)
    private String logDttm;       // 일시 (YYYY.MM.DD HH:MI:SS)
    private String playPos;       // 재생 위치 ([차시번호] MM:SS)
    private String osNm;          // 운영체제명 (Window10 / MacOS / Android 등)
    private String actInfo;       // 브라우저+행동 (chrome, Play, 1.2X (PAGE:3, start HH:MI:SS))
    private String ipAddr;        // IP 주소

    // ===================== getter / setter =====================

    public String getCntntsId()          { return cntntsId; }
    public void   setCntntsId(String v)  { this.cntntsId = v; }

    public String getLogDttm()           { return logDttm; }
    public void setLogDttm(String v)     { this.logDttm = v; }

    public String getPlayPos()           { return playPos; }
    public void setPlayPos(String v)     { this.playPos = v; }

    public String getOsNm()              { return osNm; }
    public void setOsNm(String v)        { this.osNm = v; }

    public String getActInfo()           { return actInfo; }
    public void setActInfo(String v)     { this.actInfo = v; }

    public String getIpAddr()            { return ipAddr; }
    public void setIpAddr(String v)      { this.ipAddr = v; }
}