package knou.lms.contents.web.paging;

import knou.framework.common.PageInfo;

/**
 * 관리자 학습목차 연습문제 선택 목록 검색 조건을 전달한다.
 */
public class ContsExrcsQstnPageInfo extends PageInfo {

    private static final long serialVersionUID = 1L;

    private String langCd; // 언어코드
    private String sbjctId; // 과목아이디
    private Integer lctrWkno; // 강의주차
    private String searchSbjctId; // 검색과목아이디
    private String dvclasNo; // 분반번호

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public Integer getLctrWkno() {
        return lctrWkno;
    }

    public void setLctrWkno(Integer lctrWkno) {
        this.lctrWkno = lctrWkno;
    }

    public String getSearchSbjctId() {
        return searchSbjctId;
    }

    public void setSearchSbjctId(String searchSbjctId) {
        this.searchSbjctId = searchSbjctId;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

}
