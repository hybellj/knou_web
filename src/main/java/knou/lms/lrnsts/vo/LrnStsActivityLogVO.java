package knou.lms.lrnsts.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 나의 학습현황 - 강의실 활동기록 VO
 */
public class LrnStsActivityLogVO extends DefaultVO {
    private static final long serialVersionUID = 1287719293140703179L;

    private String actDttm;   // 활동일시
    private String actConts;  // 활동내용
    private String deviceNm;  // 접속기기
    private String ipAddr;    // IP 주소

    // 검색조건
    private String keyword;   // 검색어



    public String getActDttm() { return actDttm; }
    public void setActDttm(String actDttm) { this.actDttm = actDttm; }

    public String getActConts() { return actConts; }
    public void setActConts(String actConts) { this.actConts = actConts; }

    public String getDeviceNm() { return deviceNm; }
    public void setDeviceNm(String deviceNm) { this.deviceNm = deviceNm; }

    public String getIpAddr() { return ipAddr; }
    public void setIpAddr(String ipAddr) { this.ipAddr = ipAddr; }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
}