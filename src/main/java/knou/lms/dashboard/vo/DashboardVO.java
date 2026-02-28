package knou.lms.dashboard.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;
import knou.lms.crs.crecrs.vo.HpIntchVO;

public class DashboardVO extends DefaultVO {
    private static final long serialVersionUID = 1L;
    
    private String             uniCd;
    private String             univGbn;
    private String             deptCd;
    private String             haksaYear;
    private String             haksaTerm;
    private String 				orgKnouRltn = "N";
    private List<MainCreCrsVO> creCrsList;
    private List<HpIntchVO> hpIntchList;

    /* 관리자 메인페이지 > 개설과목 현황 엑셀 다운로드 */
    private String crsCreCd;			// 개설과정코드
    private String univGbnNm;			// 구분
    private String crsCd;			    // 학수번호
    private String crsCreNm;			// 과목명
    private String creYear;             // 연도
    private String creTerm;             // 학기
    private String deptNm;              // 학과
    private String declsNo;             // 분반
    private String userNm;              // 교수명
    private String userId;              // 교수번호
    private String mobileNo;            // 연락처
    private String email;               // 이메일
    private String assistNo;            // 조교번호
    private String assistNm;            // 조교명
    private String assistOfceTelno;     //

	private float stdCnt;               // 수강생
	private float auditCnt;             // 청강생
	private float noticeCnt;            // 강의공지

    private String qnaCnt;              // Q&A
    private String secretCnt;           // 1:1상담
    private String asmntCnt;            // 과제평가
    private String forumCnt;            // 토론평가
    private String quizCnt;             // 퀴즈평가
    private String reschCnt;            // 설문평가
    private String aexamCnt;            // 수시평가
    private String midExamTypeCd;       //
    private String midExamTitle;        //
    private String midExamStartDttm;    //
    private String midScoreOpenYn;      //
    private String midGradeViewYn;      //
    private String midInsRefCd;         //
    private String midExamCnt;          //
    private String lastExamTypeCd;      //
    private String lastExamTitle;       //
    private String lastExamStartDttm;   //
    private String lastScoreOpenYn;     //
    private String lastGradeViewYn;     //
    private String lastInsRefCd;        //
    private String lastExamCnt;         //
    private String midExamInfo;         // 중간고사
    private String lastExamInfo;        // 기말고사

    /* 위젯 샘플1 */
    private String widgetId;
    private String widgetName;
    private Integer posX;
    private Integer posY;
    private Integer posW;
    private Integer posH;
    private String visibleYn;
    private String gridLv;
    private List<DashboardVO> widgets;

    /* 위젯 샘플1 */
    private String widgetId1;
    private String widgetId2;
    private String widgetId3;
    private String widgetId4;
    private String widgetId5;
    private String widgetId6;
    private String widgetId7;
    private String widgetName1;
    private String widgetName2;
    private String widgetName3;
    private String widgetName4;
    private String widgetName5;
    private String widgetName6;
    private String widgetName7;
    private Integer posX1;
    private Integer posX2;
    private Integer posX3;
    private Integer posX4;
    private Integer posX5;
    private Integer posX6;
    private Integer posX7;
    private Integer posY1;
    private Integer posY2;
    private Integer posY3;
    private Integer posY4;
    private Integer posY5;
    private Integer posY6;
    private Integer posY7;
    private Integer posW1;
    private Integer posW2;
    private Integer posW3;
    private Integer posW4;
    private Integer posW5;
    private Integer posW6;
    private Integer posW7;
    private Integer posH1;
    private Integer posH2;
    private Integer posH3;
    private Integer posH4;
    private Integer posH5;
    private Integer posH6;
    private Integer posH7;
    private String visibleYn1;
    private String visibleYn2;
    private String visibleYn3;
    private String visibleYn4;
    private String visibleYn5;
    private String visibleYn6;
    private String visibleYn7;
    private String color;
    private String userGbn;

    private String menuTycd;
    private String authrtGrpcd;

    /* 위젯 */
    private String widgetNm;
    private String widgetUseId;
    private String widgetUserStngCts;

    public String getUserGbn() {
		return userGbn;
	}

	public void setUserGbn(String userGbn) {
		this.userGbn = userGbn;
	}

    public String getUniCd() {
        return uniCd;
    }

    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }

    public String getDeptCd() {
        return deptCd;
    }

    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }

    public String getHaksaYear() {
        return haksaYear;
    }

    public void setHaksaYear(String haksaYear) {
        this.haksaYear = haksaYear;
    }

    public String getHaksaTerm() {
        return haksaTerm;
    }

    public void setHaksaTerm(String haksaTerm) {
        this.haksaTerm = haksaTerm;
    }

    public List<MainCreCrsVO> getCreCrsList() {
        return creCrsList;
    }

    public void setCreCrsList(List<MainCreCrsVO> creCrsList) {
        this.creCrsList = creCrsList;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public List<HpIntchVO> getHpIntchList() {
        return hpIntchList;
    }

    public void setHpIntchList(List<HpIntchVO> hpIntchList) {
        this.hpIntchList = hpIntchList;
    }

	public String getOrgKnouRltn() {
		return orgKnouRltn;
	}

	public void setOrgKnouRltn(String orgKnouRltn) {
		this.orgKnouRltn = orgKnouRltn;
	}

    public String getUnivGbn() {
        return univGbn;
    }

    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }

	public String getCrsCreCd() {
		return crsCreCd;
	}

	public void setCrsCreCd(String crsCreCd) {
		this.crsCreCd = crsCreCd;
	}

	public String getUnivGbnNm() {
		return univGbnNm;
	}

	public void setUnivGbnNm(String univGbnNm) {
		this.univGbnNm = univGbnNm;
	}

	public String getCrsCd() {
		return crsCd;
	}

	public void setCrsCd(String crsCd) {
		this.crsCd = crsCd;
	}

	public String getCrsCreNm() {
		return crsCreNm;
	}

	public void setCrsCreNm(String crsCreNm) {
		this.crsCreNm = crsCreNm;
	}

	public String getCreYear() {
		return creYear;
	}

	public void setCreYear(String creYear) {
		this.creYear = creYear;
	}

	public String getCreTerm() {
		return creTerm;
	}

	public void setCreTerm(String creTerm) {
		this.creTerm = creTerm;
	}

	public String getDeptNm() {
		return deptNm;
	}

	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}

	public String getDeclsNo() {
		return declsNo;
	}

	public void setDeclsNo(String declsNo) {
		this.declsNo = declsNo;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAssistNo() {
		return assistNo;
	}

	public void setAssistNo(String assistNo) {
		this.assistNo = assistNo;
	}

	public String getAssistNm() {
		return assistNm;
	}

	public void setAssistNm(String assistNm) {
		this.assistNm = assistNm;
	}

	public String getAssistOfceTelno() {
		return assistOfceTelno;
	}

	public void setAssistOfceTelno(String assistOfceTelno) {
		this.assistOfceTelno = assistOfceTelno;
	}

	public float getStdCnt() {
		return stdCnt;
	}

	public void setStdCnt(float stdCnt) {
		this.stdCnt = stdCnt;
	}

	public float getAuditCnt() {
		return auditCnt;
	}

	public void setAuditCnt(float auditCnt) {
		this.auditCnt = auditCnt;
	}

	public float getNoticeCnt() {
		return noticeCnt;
	}

	public void setNoticeCnt(float noticeCnt) {
		this.noticeCnt = noticeCnt;
	}

	public String getQnaCnt() {
		return qnaCnt;
	}

	public void setQnaCnt(String qnaCnt) {
		this.qnaCnt = qnaCnt;
	}

	public String getSecretCnt() {
		return secretCnt;
	}

	public void setSecretCnt(String secretCnt) {
		this.secretCnt = secretCnt;
	}

	public String getAsmntCnt() {
		return asmntCnt;
	}

	public void setAsmntCnt(String asmntCnt) {
		this.asmntCnt = asmntCnt;
	}

	public String getForumCnt() {
		return forumCnt;
	}

	public void setForumCnt(String forumCnt) {
		this.forumCnt = forumCnt;
	}

	public String getQuizCnt() {
		return quizCnt;
	}

	public void setQuizCnt(String quizCnt) {
		this.quizCnt = quizCnt;
	}

	public String getReschCnt() {
		return reschCnt;
	}

	public void setReschCnt(String reschCnt) {
		this.reschCnt = reschCnt;
	}

	public String getAexamCnt() {
		return aexamCnt;
	}

	public void setAexamCnt(String aexamCnt) {
		this.aexamCnt = aexamCnt;
	}

	public String getMidExamTypeCd() {
		return midExamTypeCd;
	}

	public void setMidExamTypeCd(String midExamTypeCd) {
		this.midExamTypeCd = midExamTypeCd;
	}

	public String getMidExamTitle() {
		return midExamTitle;
	}

	public void setMidExamTitle(String midExamTitle) {
		this.midExamTitle = midExamTitle;
	}

	public String getMidExamStartDttm() {
		return midExamStartDttm;
	}

	public void setMidExamStartDttm(String midExamStartDttm) {
		this.midExamStartDttm = midExamStartDttm;
	}

	public String getMidScoreOpenYn() {
		return midScoreOpenYn;
	}

	public void setMidScoreOpenYn(String midScoreOpenYn) {
		this.midScoreOpenYn = midScoreOpenYn;
	}

	public String getMidGradeViewYn() {
		return midGradeViewYn;
	}

	public void setMidGradeViewYn(String midGradeViewYn) {
		this.midGradeViewYn = midGradeViewYn;
	}

	public String getMidInsRefCd() {
		return midInsRefCd;
	}

	public void setMidInsRefCd(String midInsRefCd) {
		this.midInsRefCd = midInsRefCd;
	}

	public String getMidExamCnt() {
		return midExamCnt;
	}

	public void setMidExamCnt(String midExamCnt) {
		this.midExamCnt = midExamCnt;
	}

	public String getLastExamTypeCd() {
		return lastExamTypeCd;
	}

	public void setLastExamTypeCd(String lastExamTypeCd) {
		this.lastExamTypeCd = lastExamTypeCd;
	}

	public String getLastExamTitle() {
		return lastExamTitle;
	}

	public void setLastExamTitle(String lastExamTitle) {
		this.lastExamTitle = lastExamTitle;
	}

	public String getLastExamStartDttm() {
		return lastExamStartDttm;
	}

	public void setLastExamStartDttm(String lastExamStartDttm) {
		this.lastExamStartDttm = lastExamStartDttm;
	}

	public String getLastScoreOpenYn() {
		return lastScoreOpenYn;
	}

	public void setLastScoreOpenYn(String lastScoreOpenYn) {
		this.lastScoreOpenYn = lastScoreOpenYn;
	}

	public String getLastGradeViewYn() {
		return lastGradeViewYn;
	}

	public void setLastGradeViewYn(String lastGradeViewYn) {
		this.lastGradeViewYn = lastGradeViewYn;
	}

	public String getLastInsRefCd() {
		return lastInsRefCd;
	}

	public void setLastInsRefCd(String lastInsRefCd) {
		this.lastInsRefCd = lastInsRefCd;
	}

	public String getLastExamCnt() {
		return lastExamCnt;
	}

	public void setLastExamCnt(String lastExamCnt) {
		this.lastExamCnt = lastExamCnt;
	}

	public String getMidExamInfo() {
		return midExamInfo;
	}

	public void setMidExamInfo(String midExamInfo) {
		this.midExamInfo = midExamInfo;
	}

	public String getLastExamInfo() {
		return lastExamInfo;
	}

	public void setLastExamInfo(String lastExamInfo) {
		this.lastExamInfo = lastExamInfo;
	}

	/* 위젯 샘플 1 */
	public String getWidgetId() {
        return widgetId;
    }

    public void setWidgetId(String widgetId) {
        this.widgetId = widgetId;
    }

    public String getWidgetName() {
        return widgetName;
    }

    public void setWidgetName(String widgetName) {
        this.widgetName = widgetName;
    }

    public Integer getPosX() {
        return posX;
    }

    public void setPosX(Integer posX) {
        this.posX = posX;
    }

    public Integer getPosY() {
        return posY;
    }

    public void setPosY(Integer posY) {
        this.posY = posY;
    }

    public Integer getPosW() {
        return posW;
    }

    public void setPosW(Integer posW) {
        this.posW = posW;
    }

    public Integer getPosH() {
        return posH;
    }

    public void setPosH(Integer posH) {
        this.posH = posH;
    }

    public String getVisibleYn() {
        return visibleYn;
    }

    public void setVisibleYn(String visibleYn) {
        this.visibleYn = visibleYn;
    }

    public String getGridLv() {
        return gridLv;
    }

    public void setGridLv(String gridLv) {
        this.gridLv = gridLv;
    }

    public List<DashboardVO> getWidgets() {
		return widgets;
	}

	public void setWidgets(List<DashboardVO> widgets) {
		this.widgets = widgets;
	}

	/* 위젯 샘플 2 */
	public String getWidgetId1() {
	    return widgetId1;
	}

	public void setWidgetId1(String widgetId1) {
	    this.widgetId1 = widgetId1;
	}

	public String getWidgetId2() {
	    return widgetId2;
	}

	public void setWidgetId2(String widgetId2) {
	    this.widgetId2 = widgetId2;
	}

	public String getWidgetId3() {
	    return widgetId3;
	}

	public void setWidgetId3(String widgetId3) {
	    this.widgetId3 = widgetId3;
	}

	public String getWidgetId4() {
	    return widgetId4;
	}

	public void setWidgetId4(String widgetId4) {
	    this.widgetId4 = widgetId4;
	}

	public String getWidgetId5() {
	    return widgetId5;
	}

	public void setWidgetId5(String widgetId5) {
	    this.widgetId5 = widgetId5;
	}

	public String getWidgetId6() {
	    return widgetId6;
	}

	public void setWidgetId6(String widgetId6) {
	    this.widgetId6 = widgetId6;
	}

	public String getWidgetId7() {
	    return widgetId7;
	}

	public void setWidgetId7(String widgetId7) {
	    this.widgetId7 = widgetId7;
	}

	public String getWidgetName1() {
	    return widgetName1;
	}

	public void setWidgetName1(String widgetName1) {
	    this.widgetName1 = widgetName1;
	}

	public String getWidgetName2() {
	    return widgetName2;
	}

	public void setWidgetName2(String widgetName2) {
	    this.widgetName2 = widgetName2;
	}

	public String getWidgetName3() {
	    return widgetName3;
	}

	public void setWidgetName3(String widgetName3) {
	    this.widgetName3 = widgetName3;
	}

	public String getWidgetName4() {
	    return widgetName4;
	}

	public void setWidgetName4(String widgetName4) {
	    this.widgetName4 = widgetName4;
	}

	public String getWidgetName5() {
	    return widgetName5;
	}

	public void setWidgetName5(String widgetName5) {
	    this.widgetName5 = widgetName5;
	}

	public String getWidgetName6() {
	    return widgetName6;
	}

	public void setWidgetName6(String widgetName6) {
	    this.widgetName6 = widgetName6;
	}

	public String getWidgetName7() {
	    return widgetName7;
	}

	public void setWidgetName7(String widgetName7) {
	    this.widgetName7 = widgetName7;
	}

	public Integer getPosX1() {
	    return posX1;
	}

	public void setPosX1(Integer posX1) {
	    this.posX1 = posX1;
	}

	public Integer getPosX2() {
	    return posX2;
	}

	public void setPosX2(Integer posX2) {
	    this.posX2 = posX2;
	}

	public Integer getPosX3() {
	    return posX3;
	}

	public void setPosX3(Integer posX3) {
	    this.posX3 = posX3;
	}

	public Integer getPosX4() {
	    return posX4;
	}

	public void setPosX4(Integer posX4) {
	    this.posX4 = posX4;
	}

	public Integer getPosX5() {
	    return posX5;
	}

	public void setPosX5(Integer posX5) {
	    this.posX5 = posX5;
	}

	public Integer getPosX6() {
	    return posX6;
	}

	public void setPosX6(Integer posX6) {
	    this.posX6 = posX6;
	}

	public Integer getPosX7() {
	    return posX7;
	}

	public void setPosX7(Integer posX7) {
	    this.posX7 = posX7;
	}

	public Integer getPosY1() {
	    return posY1;
	}

	public void setPosY1(Integer posY1) {
	    this.posY1 = posY1;
	}

	public Integer getPosY2() {
	    return posY2;
	}

	public void setPosY2(Integer posY2) {
	    this.posY2 = posY2;
	}

	public Integer getPosY3() {
	    return posY3;
	}

	public void setPosY3(Integer posY3) {
	    this.posY3 = posY3;
	}

	public Integer getPosY4() {
	    return posY4;
	}

	public void setPosY4(Integer posY4) {
	    this.posY4 = posY4;
	}

	public Integer getPosY5() {
	    return posY5;
	}

	public void setPosY5(Integer posY5) {
	    this.posY5 = posY5;
	}

	public Integer getPosY6() {
	    return posY6;
	}

	public void setPosY6(Integer posY6) {
	    this.posY6 = posY6;
	}

	public Integer getPosY7() {
	    return posY7;
	}

	public void setPosY7(Integer posY7) {
	    this.posY7 = posY7;
	}

	public Integer getPosW1() {
	    return posW1;
	}

	public void setPosW1(Integer posW1) {
	    this.posW1 = posW1;
	}

	public Integer getPosW2() {
	    return posW2;
	}

	public void setPosW2(Integer posW2) {
	    this.posW2 = posW2;
	}

	public Integer getPosW3() {
	    return posW3;
	}

	public void setPosW3(Integer posW3) {
	    this.posW3 = posW3;
	}

	public Integer getPosW4() {
	    return posW4;
	}

	public void setPosW4(Integer posW4) {
	    this.posW4 = posW4;
	}

	public Integer getPosW5() {
	    return posW5;
	}

	public void setPosW5(Integer posW5) {
	    this.posW5 = posW5;
	}

	public Integer getPosW6() {
	    return posW6;
	}

	public void setPosW6(Integer posW6) {
	    this.posW6 = posW6;
	}

	public Integer getPosW7() {
	    return posW7;
	}

	public void setPosW7(Integer posW7) {
	    this.posW7 = posW7;
	}

	public Integer getPosH1() {
	    return posH1;
	}

	public void setPosH1(Integer posH1) {
	    this.posH1 = posH1;
	}

	public Integer getPosH2() {
	    return posH2;
	}

	public void setPosH2(Integer posH2) {
	    this.posH2 = posH2;
	}

	public Integer getPosH3() {
	    return posH3;
	}

	public void setPosH3(Integer posH3) {
	    this.posH3 = posH3;
	}

	public Integer getPosH4() {
	    return posH4;
	}

	public void setPosH4(Integer posH4) {
	    this.posH4 = posH4;
	}

	public Integer getPosH5() {
	    return posH5;
	}

	public void setPosH5(Integer posH5) {
	    this.posH5 = posH5;
	}

	public Integer getPosH6() {
	    return posH6;
	}

	public void setPosH6(Integer posH6) {
	    this.posH6 = posH6;
	}

	public Integer getPosH7() {
	    return posH7;
	}

	public void setPosH7(Integer posH7) {
	    this.posH7 = posH7;
	}

	public String getVisibleYn1() {
	    return visibleYn1;
	}

	public void setVisibleYn1(String visibleYn1) {
	    this.visibleYn1 = visibleYn1;
	}

	public String getVisibleYn2() {
	    return visibleYn2;
	}

	public void setVisibleYn2(String visibleYn2) {
	    this.visibleYn2 = visibleYn2;
	}

	public String getVisibleYn3() {
	    return visibleYn3;
	}

	public void setVisibleYn3(String visibleYn3) {
	    this.visibleYn3 = visibleYn3;
	}

	public String getVisibleYn4() {
	    return visibleYn4;
	}

	public void setVisibleYn4(String visibleYn4) {
	    this.visibleYn4 = visibleYn4;
	}

	public String getVisibleYn5() {
	    return visibleYn5;
	}

	public void setVisibleYn5(String visibleYn5) {
	    this.visibleYn5 = visibleYn5;
	}

	public String getVisibleYn6() {
	    return visibleYn6;
	}

	public void setVisibleYn6(String visibleYn6) {
	    this.visibleYn6 = visibleYn6;
	}

	public String getVisibleYn7() {
	    return visibleYn7;
	}

	public void setVisibleYn7(String visibleYn7) {
	    this.visibleYn7 = visibleYn7;
	}

	public String getColor() {
	    return color;
	}

	public void setColor(String color) {
	    this.color = color;
	}

	public String getWidgetUserStngCts() {
		return widgetUserStngCts;
	}

	public String getWidgetNm() {
		return widgetNm;
	}

	public String getWidgetUseId() {
		return widgetUseId;
	}

	public void setWidgetUserStngCts(String widgetUserStngCts) {
		this.widgetUserStngCts = widgetUserStngCts;
	}

	public void setWidgetNm(String widgetNm) {
		this.widgetNm = widgetNm;
	}

	public void setWidgetUseId(String widgetUseId) {
		this.widgetUseId = widgetUseId;
	}

	public String getMenuTycd() {
		return menuTycd;
	}

	public void setMenuTycd(String menuTycd) {
		this.menuTycd = menuTycd;
	}

	public String getAuthrtGrpcd() {
		return authrtGrpcd;
	}

	public void setAuthrtGrpcd(String authrtGrpcd) {
		this.authrtGrpcd = authrtGrpcd;
	}
}
