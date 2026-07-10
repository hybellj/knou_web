package knou.lms.lrnsts.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 나의 학습현황 주차별 상세 팝업 - 차시별 학습 로그 VO
 */
public class LrnStsLrnLogVO extends DefaultVO {
    private static final long serialVersionUID = 1097487303267193704L;

    private int wkNo;           // 주차번호
    private String cntntsId;    // 콘텐츠 ID

    private String logDttm;     // 학습 로그 일시
    private String playPos;     // 재생 위치
    private String actInfo;     // 학습 활동 정보
    private String ipAddr;      // IP 주소

    public int getWkNo() { return wkNo; }
    public void setWkNo(int wkNo) { this.wkNo = wkNo; }

    public String getCntntsId() { return cntntsId; }
    public void setCntntsId(String cntntsId) { this.cntntsId = cntntsId; }

    public String getLogDttm() { return logDttm; }
    public void setLogDttm(String logDttm) { this.logDttm = logDttm; }

    public String getPlayPos() { return playPos; }
    public void setPlayPos(String playPos) { this.playPos = playPos; }

    public String getActInfo() { return actInfo; }
    public void setActInfo(String actInfo) { this.actInfo = actInfo; }

    public String getIpAddr() { return ipAddr; }
    public void setIpAddr(String ipAddr) { this.ipAddr = ipAddr; }
}
