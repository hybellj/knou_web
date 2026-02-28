package knou.lms.crs.term.vo;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.DefaultVO;

public class TermVO extends DefaultVO{

    private static final long serialVersionUID = -3977438462234145774L;
    
    private String  termCd;
    private String  termNm;
    private String  orgId;
    private String  haksaYear;
    private String  haksaTerm;
    private String  haksaTermNm;
    private String  termType;
    private String  offLessonMgtYn;         /*오프라인수강주차관리여부*/
    private String  termStatus;
    private String  termLinkYn;             /*학사연동여부*/
    private String  svcStartDttm;           /*운영 시작 일시*/
    private String  svcEndDttm;            /*운영 종료 일시*/
    private String  enrlAplcStartDttm;      /*수강신청 시작 일자*/
    private String  enrlAplcEndDttm;
    private String  enrlModStartDttm;       /*수강 정정 시작 일자*/
    private String  enrlModEndDttm;
    private String  enrlStartDttm;          /*수강 시작 일자*/
    private String  enrlEndDttm;
    private String  scoreEvalStartDttm;     /*성적 평가 시작 일자*/
    private String  scoreEvalEndDttm;
    private String  scoreOpenStartDttm;     /*성적 공개 시작 일자*/
    private String  scoreOpenEndDttm;
    private String  scoreCalcCtgr;          /*성적 산출 분류*/
    private String  mobileAttendYn;         /* 모바일 축석 여부*/
    private String  rgtrId;
    private String  regDttm;
    private String  mdfrId;
    private String  modDttm;
    private Integer count;
    private String  gubun;
    private Integer termOrder;
    private String  termTypeNm;
    private String  nowSmstryn;              /*현재학기여부*/
    
    private String crsCreCd;     /*상호평가 문항가져오기용 과정개설코드*/
    
    private String crsCd;     /*학기제 개설 강의 등록할때 필요*/
    
    private String svcStartDt; 
    private String svcStartHh; 
    private String svcStartMm; 
    
    private String svcEndtDt; 
    private String svcEndtHh; 
    private String svcEndtMm; 
 
    // tb_lms_term_lesson
    private String  enrlType;       /*online, offline */
    private Integer lsnOdr;         /*목차 순서*/
    private String  startDt;        /*주차  시작일*/
    private String  endDt;          /*주차  종료일*/
    private String  ltDetmFrDt;     /*강의인정시작일자*/
    private String  ltDetmToDt;     /*강의인정종료일자*/
    private Integer orderCnt;       /*실존 하는 값의 주차 개수*/
    private Integer onlineCnt;      /*학기 주차 전체 저장할때 쓰임*/
    private Integer offlineCnt;     /*학기 주차 전체 저장할때 쓰임*/
    private String  userId;
    
    private String reloadYn;
    
    private String[] crsCreArray;
    
    private String  crsCount; 
    
    private String useYn;
    private String svcStartYn;  // 강의시작일 시작여부
    private String svcEndYn;    // 강의종료일 종료여부
    private String scoInputStartDttm;
    private String scoInputEndDttm;
    private String scoViewStartDttm;
    private String scoViewEndDttm;
    private String scoObjtStartDttm;
    private String scoObjtEndDttm;
    private String scoRechkStartDttm;
    private String scoRechkEndDttm;

    
    public TermVO(UserContext userCtx) {
		this.userId = userCtx.getUserId();
		this.orgId = userCtx.getOrgId();
	}
	public TermVO() {
	}
	
	public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }
    
    public String getTermNm() {
        return termNm;
    }
    public void setTermNm(String termNm) {
        this.termNm = termNm;
    }
    
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
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
    
    public String getHaksaTermNm() {
        return haksaTermNm;
    }
    public void setHaksaTermNm(String haksaTermNm) {
        this.haksaTermNm = haksaTermNm;
    }
    
    public String getTermType() {
        return termType;
    }
    public void setTermType(String termType) {
        this.termType = termType;
    }
    
    public String getOffLessonMgtYn() {
        return offLessonMgtYn;
    }
    public void setOffLessonMgtYn(String offLessonMgtYn) {
        this.offLessonMgtYn = offLessonMgtYn;
    }
    
    public String getTermStatus() {
        return termStatus;
    }
    public void setTermStatus(String termStatus) {
        this.termStatus = termStatus;
    }
    
    public String getTermLinkYn() {
        return termLinkYn;
    }
    public void setTermLinkYn(String termLinkYn) {
        this.termLinkYn = termLinkYn;
    }
    
    public String getSvcStartDttm() {
        return svcStartDttm;
    }
    public void setSvcStartDttm(String svcStartDttm) {
        this.svcStartDttm = svcStartDttm;
    }
    
    public String getSvcEndDttm() {
        return svcEndDttm;
    }
    public void setSvcEndDttm(String svcEndDttm) {
        this.svcEndDttm = svcEndDttm;
    }
    
    public String getEnrlAplcStartDttm() {
        return enrlAplcStartDttm;
    }
    public void setEnrlAplcStartDttm(String enrlAplcStartDttm) {
        this.enrlAplcStartDttm = enrlAplcStartDttm;
    }
    
    public String getEnrlAplcEndDttm() {
        return enrlAplcEndDttm;
    }
    public void setEnrlAplcEndDttm(String enrlAplcEndDttm) {
        this.enrlAplcEndDttm = enrlAplcEndDttm;
    }
    
    public String getEnrlModStartDttm() {
        return enrlModStartDttm;
    }
    public void setEnrlModStartDttm(String enrlModStartDttm) {
        this.enrlModStartDttm = enrlModStartDttm;
    }
    
    public String getEnrlModEndDttm() {
        return enrlModEndDttm;
    }
    public void setEnrlModEndDttm(String enrlModEndDttm) {
        this.enrlModEndDttm = enrlModEndDttm;
    }
    
    public String getEnrlStartDttm() {
        return enrlStartDttm;
    }
    public void setEnrlStartDttm(String enrlStartDttm) {
        this.enrlStartDttm = enrlStartDttm;
    }
    
    public String getEnrlEndDttm() {
        return enrlEndDttm;
    }
    public void setEnrlEndDttm(String enrlEndDttm) {
        this.enrlEndDttm = enrlEndDttm;
    }
    
    public String getScoreEvalStartDttm() {
        return scoreEvalStartDttm;
    }
    public void setScoreEvalStartDttm(String scoreEvalStartDttm) {
        this.scoreEvalStartDttm = scoreEvalStartDttm;
    }
    
    public String getScoreEvalEndDttm() {
        return scoreEvalEndDttm;
    }
    public void setScoreEvalEndDttm(String scoreEvalEndDttm) {
        this.scoreEvalEndDttm = scoreEvalEndDttm;
    }
    
    public String getScoreCalcCtgr() {
        return scoreCalcCtgr;
    }
    public void setScoreCalcCtgr(String scoreCalcCtgr) {
        this.scoreCalcCtgr = scoreCalcCtgr;
    }
    public String getMobileAttendYn() {
        return mobileAttendYn;
    }
    public void setMobileAttendYn(String mobileAttendYn) {
        this.mobileAttendYn = mobileAttendYn;
    }
    
    public String getRgtrId() {
        return rgtrId;
    }
    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }
    
    public String getRegDttm() {
        return regDttm;
    }
    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }
    
    public String getMdfrId() {
        return mdfrId;
    }
    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }
    
    public String getModDttm() {
        return modDttm;
    }
    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }
    
    public Integer getCount() {
        return count;
    }
    public void setCount(Integer count) {
        this.count = count;
    }
    
    public String getGubun() {
        return gubun;
    }
    public void setGubun(String gubun) {
        this.gubun = gubun;
    }
    
    public Integer getTermOrder() {
        return termOrder;
    }
    public void setTermOrder(Integer termOrder) {
        this.termOrder = termOrder;
    }
    
    public String getTermTypeNm() {
        return termTypeNm;
    }
    public void setTermTypeNm(String termTypeNm) {
        this.termTypeNm = termTypeNm;
    }
    
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    
    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    public String getSvcStartDt() {
        return svcStartDt;
    }
    public void setSvcStartDt(String svcStartDt) {
        this.svcStartDt = svcStartDt;
    }
    
    public String getSvcStartHh() {
        return svcStartHh;
    }
    public void setSvcStartHh(String svcStartHh) {
        this.svcStartHh = svcStartHh;
    }
    
    public String getSvcStartMm() {
        return svcStartMm;
    }
    public void setSvcStartMm(String svcStartMm) {
        this.svcStartMm = svcStartMm;
    }
    
    public String getSvcEndtDt() {
        return svcEndtDt;
    }
    public void setSvcEndtDt(String svcEndtDt) {
        this.svcEndtDt = svcEndtDt;
    }
    
    public String getSvcEndtHh() {
        return svcEndtHh;
    }
    public void setSvcEndtHh(String svcEndtHh) {
        this.svcEndtHh = svcEndtHh;
    }
    
    public String getSvcEndtMm() {
        return svcEndtMm;
    }
    public void setSvcEndtMm(String svcEndtMm) {
        this.svcEndtMm = svcEndtMm;
    }
    
    public String getEnrlType() {
        return enrlType;
    }
    public void setEnrlType(String enrlType) {
        this.enrlType = enrlType;
    }
    
    public Integer getLsnOdr() {
        return lsnOdr;
    }
    public void setLsnOdr(Integer lsnOdr) {
        this.lsnOdr = lsnOdr;
    }
    
    public String getStartDt() {
        return startDt;
    }
    public void setStartDt(String startDt) {
        this.startDt = startDt;
    }
    
    public String getEndDt() {
        return endDt;
    }
    public void setEndDt(String endDt) {
        this.endDt = endDt;
    }
    
    public Integer getOrderCnt() {
        return orderCnt;
    }
    public void setOrderCnt(Integer orderCnt) {
        this.orderCnt = orderCnt;
    }
    
    public Integer getOnlineCnt() {
        return onlineCnt;
    }
    public void setOnlineCnt(Integer onlineCnt) {
        this.onlineCnt = onlineCnt;
    }
    
    public Integer getOfflineCnt() {
        return offlineCnt;
    }
    public void setOfflineCnt(Integer offlineCnt) {
        this.offlineCnt = offlineCnt;
    }
    
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public String getNowSmstryn() {
        return nowSmstryn;
    }
    public void setNowSmstryn(String curTermYn) {
        this.nowSmstryn = curTermYn;
    }
    
    public String[] getCrsCreArray() {
        return crsCreArray;
    }
    public void setCrsCreArray(String[] crsCreArray) {
        this.crsCreArray = crsCreArray;
    }
    
    public String getScoreOpenStartDttm() {
        return scoreOpenStartDttm;
    }
    public void setScoreOpenStartDttm(String scoreOpenStartDttm) {
        this.scoreOpenStartDttm = scoreOpenStartDttm;
    }
    
    public String getScoreOpenEndDttm() {
        return scoreOpenEndDttm;
    }
    public void setScoreOpenEndDttm(String scoreOpenEndDttm) {
        this.scoreOpenEndDttm = scoreOpenEndDttm;
    }
    
    public String getReloadYn() {
        return reloadYn;
    }
    public void setReloadYn(String reloadYn) {
        this.reloadYn = reloadYn;
    }
    
    public String getLtDetmFrDt() {
        return ltDetmFrDt;
    }
    public void setLtDetmFrDt(String ltDetmFrDt) {
        this.ltDetmFrDt = ltDetmFrDt;
    }
    
    public String getLtDetmToDt() {
        return ltDetmToDt;
    }
    public void setLtDetmToDt(String ltDetmToDt) {
        this.ltDetmToDt = ltDetmToDt;
    }
    
    public String getCrsCount() {
        return crsCount;
    }
    public void setCrsCount(String crsCount) {
        this.crsCount = crsCount;
    }
    
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    
    public String getSvcStartYn() {
        return svcStartYn;
    }
    public void setSvcStartYn(String svcStartYn) {
        this.svcStartYn = svcStartYn;
    }
    
    public String getSvcEndYn() {
        return svcEndYn;
    }
    public void setSvcEndYn(String svcEndYn) {
        this.svcEndYn = svcEndYn;
    }
	public String getScoInputStartDttm() {
		return scoInputStartDttm;
	}
	public void setScoInputStartDttm(String scoInputStartDttm) {
		this.scoInputStartDttm = scoInputStartDttm;
	}
	public String getScoInputEndDttm() {
		return scoInputEndDttm;
	}
	public void setScoInputEndDttm(String scoInputEndDttm) {
		this.scoInputEndDttm = scoInputEndDttm;
	}
	public String getScoViewStartDttm() {
		return scoViewStartDttm;
	}
	public void setScoViewStartDttm(String scoViewStartDttm) {
		this.scoViewStartDttm = scoViewStartDttm;
	}
	public String getScoViewEndDttm() {
		return scoViewEndDttm;
	}
	public void setScoViewEndDttm(String scoViewEndDttm) {
		this.scoViewEndDttm = scoViewEndDttm;
	}
	public String getScoObjtStartDttm() {
		return scoObjtStartDttm;
	}
	public void setScoObjtStartDttm(String scoObjtStartDttm) {
		this.scoObjtStartDttm = scoObjtStartDttm;
	}
	public String getScoObjtEndDttm() {
		return scoObjtEndDttm;
	}
	public void setScoObjtEndDttm(String scoObjtEndDttm) {
		this.scoObjtEndDttm = scoObjtEndDttm;
	}
	public String getScoRechkStartDttm() {
		return scoRechkStartDttm;
	}
	public void setScoRechkStartDttm(String scoRechkStartDttm) {
		this.scoRechkStartDttm = scoRechkStartDttm;
	}
	public String getScoRechkEndDttm() {
		return scoRechkEndDttm;
	}
	public void setScoRechkEndDttm(String scoRechkEndDttm) {
		this.scoRechkEndDttm = scoRechkEndDttm;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
