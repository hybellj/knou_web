package knou.lms.contents.web.paging;

import knou.framework.common.PageInfo;

/**
 * 관리자 학습목차 돌발퀴즈 선택 목록 검색 조건을 전달한다.
 */
public class ContsSddnQstnPageInfo extends PageInfo {

    private static final long serialVersionUID = 1L;

    private String langCd; // 언어코드
    private String sbjctId; // 과목아이디

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

}
