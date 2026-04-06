package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 강의실 활동기록 VO
 */

public class ClsActivityLogVO extends DefaultVO {
    private static final long serialVersionUID = 8834710293847562019L;

    private String actDttm;   // 활동 일시
    private String actConts;  // 활동 내용
    private String deviceNm;  // 접근 장비 (PC / Mobile)
    private String ipAddr;    // IP 주소

    // 검색 조건
    private String keyword;



    public String getActDttm()  { return actDttm; }
    public void setActDttm(String actDttm) { this.actDttm = actDttm; }

    public String getActConts() { return actConts; }
    public void setActConts(String actConts) { this.actConts = actConts; }

    public String getDeviceNm() { return deviceNm; }
    public void setDeviceNm(String deviceNm) { this.deviceNm = deviceNm; }

    public String getIpAddr()   { return ipAddr; }
    public void setIpAddr(String ipAddr) { this.ipAddr = ipAddr; }

    public String getKeyword()  { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
}