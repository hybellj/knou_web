package knou.lms.lesson.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;

public class LessonVO extends DefaultVO{

    private static final long serialVersionUID = 1280604523703724679L;

    // 차시 검색 조건
    private String classUserTypeGubun;
    private List<LessonVO> subList;
    private LessonVO parLessonScheduleId;
    private String periodOutLearnDttm;          /* 기간 외 학습 날짜 */
    private Integer stdTotalCnt;                /* 개설 과목 총 학생수 */
    private Integer stdCompleteCnt;             /* 차시 출석 학생수 */
    private Integer stdStudyCnt;                /* 차시 지각 학생수 */
    private String tchNm;                       /* 강사이름 */
  	
  	//tb_lms_term
  	private String termType;
  	
  	//tb_lms_crs
  	private String crsTypeCd;
  	private String crsTypeCds;
  	
  	//tb_lms_cre_crs
  	private String crsCd;
    private String crsOperTypeCd;
    private String lessonScheduleIdVal;
    private String  enrlStartDttm;				/*수강 시작 일시*/
	private String  enrlEndDttm;
	private String  crsYear;
	

    //tb_lms_lesson_cnts
    private String  lessonCntsId;               /*학습콘텐츠아이디*/
    private String  lessonScheduleId;           /*학습콘텐츠아이디*/
    private String  lessonTypeCd;               /*학습유형코드*/
    private String  lessonCntsNm;               /*학습콘텐츠명*/
    private Integer lessonCntsOrder;            /*학습콘텐츠순서*/
    private String  lessonStartDttm;            /*학습시작일시*/
    private String  lessonEndDttm;              /*학습콘텐츠아이디*/
    private String  lessonCntsFileLocCd;        /*학습파일위치코드*/
    private String  lessonCntsFileNm;           /*학습파일명*/
    private String  lessonCntsFilePath;         /*학습파일경로*/
    private String  lessonCntsUrl;              /*학습URL*/
    private String  lessonCntsFileLocCdM;       /*모바일학습파일위치코드*/
    private String  lessonCntsFileNmM;          /*모바일학습파일명*/
    private String  lessonCntsFilePathM;        /*모바일학습파일경로*/
    private String  lessonCntsUrlM;             /*모바일학습URL*/
    private Integer recmmdStudyTime;            /*권장학습시간(분)*/
    private String  prgrRatioTypeCd;            /*표시여부*/
    private String  viewYn;                     /*표시여부*/
    private String  periodOutLearnYn;           /*기간외학습여부*/
    private String  periodOutLearnDay;          /*기간외학습일*/
    private String  periodOutLearnDayCnt;       /*기간외학습일수*/
    private String  periodOutLearnStatusCd;     /*기간외학습인정상태*/
    private String  learnStatusCheckYn;         /*학습상태체크여부*/
    private String  newWindowLearnYn;           /*새창학습여부*/
    private String  lessonDataFileYn;           /*학습자료파일여부*/
    private String  lessonDataFileNm;           /*학습자료파일명*/
    private String  lessonDataFilePath;         /*학습자료경로*/
    private String  lessonDataFileUrl;          /*학습자료URL*/
    private Integer attplanTime;                /*출석부시간*/
    private String  skplcDivCd;                 /*휴보강구분코드*/
    private String  vcLearnStartDttm;           /*화상학습시작일시*/
    private String  vcLearnEndDttm;             /*화상학습종료일시*/
    private String  vcLearnRoomPwd;             /*화상학습방비밀번호*/
    private String  vcLearnDesc;                /*화상학습설명*/
    private String  vcRoomRelId;                /*화상학습설명*/
    private String  delYn;                      /*삭제 여부*/

    //tb_lms_lesson_cnts_cmnt
    private String  lessonCntsCmntId;           /*학습콘텐츠 댓글아이디*/
    private String  parLessonCntsCmntId;        /*부모 학습콘텐츠 댓글아이디*/
    private String  cmntCts;                    /*댓글 내용*/
    
    //tb_lms_lesson_schedule
    private String  lessonScheduleNm;           /*학습일정명*/
    private Integer lessonScheduleOrder;        /*학습일정순서*/
    private String  lessonObject;               /*학습목표*/
    private String  lessonSummary;              /*학습개요*/
    private String  lessonRepData;              /*학습참고자료*/
    private String  lessonStartDt;              /*학습시작일*/
    private String  lessonEndDt;                /*학습종료일*/
    
    //tb_lms_lesson_study_record
    private String  studyStatusCd;              /*학습 상태 코드*/
    private String  studyStatusCdBak;           /*학습 상태 코드 백업*/
    private String  studyStatusCdNm;            /*학습 상태 코드(명)*/
    private Integer studyCnt;                   /*접속 수*/
    private Integer studySessionTm;             /*접속 시간*/
    private Integer studyTotalTm;               /*접속 총 시간*/
    private Integer studyAfterTm;               /*기간 후 학습 시간(초)*/
    private String  studyStartDttm;             /*학습 일시*/
    private String  studySessionDttm;           /*최근 학습 일시*/
    private String  studySessionLoc;            /*탐색시간*/
    private String  studyMaxLoc;                /*최대 학습 위치*/
    private Integer prgrRatio;                  /*진도 비율*/
    
    //tb_lms_lesson_study_detail
    private String  studyDetailId;              /*학습기록상세아이디*/
    private Integer studyTm;                    /*접속 시간*/
    private String  studyBrowserCd;             /*학습브라우저코드*/
    private String  studyDeviceCd;              /*학습기기코드*/
    private String  studyClientEnv;             /*학습자환경*/
    private String  regIp;                      /*등록자IP*/
    
    //tb_lms_lesson_study_detail
    private Integer recomCnt;                   /*학습콘텐츠 추천수*/
    private String  myRecomYn;                  /*학습자 추천 여부*/
    
    private String progressTypeCd;              /* 강의 형식(WEEK, TOPIC) 구분 */
    private String id;                          /* 학습콘텐츠아이디(lessonCntsId or lessonScheduleId) */
    private Integer studyInnerTm;               /* 기간 내 학습 시간(초)*/
    private String studyAfterTmMs;              /* 기간 외 학습(분초)*/
    private String studyInnerTmMs;              /* 기간 내 학습 시간(분초)*/
    private String lessonProgress;              /* 학습콘텐츠 진행 상태 */
    private String gubun;                       /* 강제 출석 처리 구분*/
    private String targetGubun;                 /* 대상구분 */ 
    private String callGubun;                   /* 호출구분 */ 
    private String openYn;                      /* 오픈여부 */ 
    private String selectStdNos;                /* 선택한 학생들 */ 
    private List<LessonStudyDetailVO>    listLessonStudyDetail;
    
    private String creYear;
    private String creTerm;
    private String uniCd;
    private String univGbn;
    private String univGbnNm;
    private String deptCd;
    private String lcdmsLinkYn;
    
    /* 엑셀 다운로드 */
	private String deptNm;                		/* 관장학과 */ 
	private String lessonTimeNm;          		/* 교시 */ 
	private String cntsGbn;               		/* 구분 */ 
	private Integer lbnTm;                 		/* 기준시간 */ 
	private String ltNote;                		/* 강의노트 */ 
	
    public String getCrsCd() {
		return crsCd;
	}
	public void setCrsCd(String crsCd) {
		this.crsCd = crsCd;
	}
	public String getCrsOperTypeCd() {
		return crsOperTypeCd;
	}
	public void setCrsOperTypeCd(String crsOperTypeCd) {
		this.crsOperTypeCd = crsOperTypeCd;
	}
	public String getLessonScheduleIdVal() {
		return lessonScheduleIdVal;
	}
	public void setLessonScheduleIdVal(String lessonScheduleIdVal) {
		this.lessonScheduleIdVal = lessonScheduleIdVal;
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
	public String getCrsYear() {
		return crsYear;
	}
	public void setCrsYear(String crsYear) {
		this.crsYear = crsYear;
	}
	public String getClassUserTypeGubun() {
		return classUserTypeGubun;
	}
	public void setClassUserTypeGubun(String classUserTypeGubun) {
		this.classUserTypeGubun = classUserTypeGubun;
	}
	public List<LessonVO> getSubList() {
		if(ValidationUtils.isEmpty(subList)) subList = new ArrayList<LessonVO>();
		return subList;
	}
	public void setSubList(List<LessonVO> subList) {
		this.subList = subList;
	}
	//-- vo 게체에 하위 겍체를 추가한다.
	public void addSubLessonCnts(LessonVO vo) {
		vo.setlessoncnts(this);
		this.getSubList().add(vo);
	}
	public void setlessoncnts(LessonVO parLessonScheduleId) {
		this.parLessonScheduleId = parLessonScheduleId;
	}
	public LessonVO getParLessonScheduleId() {
		return parLessonScheduleId;
	}
	public void setParLessonScheduleId(LessonVO parLessonScheduleId) {
		this.parLessonScheduleId = parLessonScheduleId;
	}
	public String getPeriodOutLearnDttm() {
		return periodOutLearnDttm;
	}
	public void setPeriodOutLearnDttm(String periodOutLearnDttm) {
		this.periodOutLearnDttm = periodOutLearnDttm;
	}
	public Integer getStdTotalCnt() {
		return stdTotalCnt;
	}
	public void setStdTotalCnt(Integer stdTotalCnt) {
		this.stdTotalCnt = stdTotalCnt;
	}
	public Integer getStdCompleteCnt() {
		return stdCompleteCnt;
	}
	public void setStdCompleteCnt(Integer stdCompleteCnt) {
		this.stdCompleteCnt = stdCompleteCnt;
	}
	public Integer getStdStudyCnt() {
		return stdStudyCnt;
	}
	public void setStdStudyCnt(Integer stdStudyCnt) {
		this.stdStudyCnt = stdStudyCnt;
	}
	/**
     * @return lessonCntsId 값을 반환한다.
     */
    public String getLessonCntsId()
    {
        return lessonCntsId;
    }
    /**
     * @param lessonCntsId 을 lessonCntsId 에 저장한다.
     */
    public void setLessonCntsId(String lessonCntsId)
    {
        this.lessonCntsId = lessonCntsId;
    }
    /**
     * @return lessonScheduleId 값을 반환한다.
     */
    public String getLessonScheduleId()
    {
        return lessonScheduleId;
    }
    /**
     * @param lessonScheduleId 을 lessonScheduleId 에 저장한다.
     */
    public void setLessonScheduleId(String lessonScheduleId)
    {
        this.lessonScheduleId = lessonScheduleId;
    }
    /**
     * @return lessonTypeCd 값을 반환한다.
     */
    public String getLessonTypeCd()
    {
        return lessonTypeCd;
    }
    /**
     * @param lessonTypeCd 을 lessonTypeCd 에 저장한다.
     */
    public void setLessonTypeCd(String lessonTypeCd)
    {
        this.lessonTypeCd = lessonTypeCd;
    }
    /**
     * @return lessonCntsNm 값을 반환한다.
     */
    public String getLessonCntsNm()
    {
        return lessonCntsNm;
    }
    /**
     * @param lessonCntsNm 을 lessonCntsNm 에 저장한다.
     */
    public void setLessonCntsNm(String lessonCntsNm)
    {
        this.lessonCntsNm = lessonCntsNm;
    }
    /**
     * @return lessonCntsOrder 값을 반환한다.
     */
    public Integer getLessonCntsOrder()
    {
        return lessonCntsOrder;
    }
    /**
     * @param lessonCntsOrder 을 lessonCntsOrder 에 저장한다.
     */
    public void setLessonCntsOrder(Integer lessonCntsOrder)
    {
        this.lessonCntsOrder = lessonCntsOrder;
    }
    /**
     * @return lessonStartDttm 값을 반환한다.
     */
    public String getLessonStartDttm()
    {
        return lessonStartDttm;
    }
    /**
     * @param lessonStartDttm 을 lessonStartDttm 에 저장한다.
     */
    public void setLessonStartDttm(String lessonStartDttm)
    {
        this.lessonStartDttm = lessonStartDttm;
    }
    /**
     * @return lessonEndDttm 값을 반환한다.
     */
    public String getLessonEndDttm()
    {
        return lessonEndDttm;
    }
    /**
     * @param lessonEndDttm 을 lessonEndDttm 에 저장한다.
     */
    public void setLessonEndDttm(String lessonEndDttm)
    {
        this.lessonEndDttm = lessonEndDttm;
    }
    /**
     * @return lessonCntsFileLocCd 값을 반환한다.
     */
    public String getLessonCntsFileLocCd()
    {
        return lessonCntsFileLocCd;
    }
    /**
     * @param lessonCntsFileLocCd 을 lessonCntsFileLocCd 에 저장한다.
     */
    public void setLessonCntsFileLocCd(String lessonCntsFileLocCd)
    {
        this.lessonCntsFileLocCd = lessonCntsFileLocCd;
    }
    /**
     * @return lessonCntsFileNm 값을 반환한다.
     */
    public String getLessonCntsFileNm()
    {
        return lessonCntsFileNm;
    }
    /**
     * @param lessonCntsFileNm 을 lessonCntsFileNm 에 저장한다.
     */
    public void setLessonCntsFileNm(String lessonCntsFileNm)
    {
        this.lessonCntsFileNm = lessonCntsFileNm;
    }
    /**
     * @return lessonCntsFilePath 값을 반환한다.
     */
    public String getLessonCntsFilePath()
    {
        return lessonCntsFilePath;
    }
    /**
     * @param lessonCntsFilePath 을 lessonCntsFilePath 에 저장한다.
     */
    public void setLessonCntsFilePath(String lessonCntsFilePath)
    {
        this.lessonCntsFilePath = lessonCntsFilePath;
    }
    /**
     * @return lessonCntsUrl 값을 반환한다.
     */
    public String getLessonCntsUrl()
    {
        return lessonCntsUrl;
    }
    /**
     * @param lessonCntsUrl 을 lessonCntsUrl 에 저장한다.
     */
    public void setLessonCntsUrl(String lessonCntsUrl)
    {
        this.lessonCntsUrl = lessonCntsUrl;
    }
    /**
     * @return lessonCntsFileLocCdM 값을 반환한다.
     */
    public String getLessonCntsFileLocCdM()
    {
        return lessonCntsFileLocCdM;
    }
    /**
     * @param lessonCntsFileLocCdM 을 lessonCntsFileLocCdM 에 저장한다.
     */
    public void setLessonCntsFileLocCdM(String lessonCntsFileLocCdM)
    {
        this.lessonCntsFileLocCdM = lessonCntsFileLocCdM;
    }
    /**
     * @return lessonCntsFileNmM 값을 반환한다.
     */
    public String getLessonCntsFileNmM()
    {
        return lessonCntsFileNmM;
    }
    /**
     * @param lessonCntsFileNmM 을 lessonCntsFileNmM 에 저장한다.
     */
    public void setLessonCntsFileNmM(String lessonCntsFileNmM)
    {
        this.lessonCntsFileNmM = lessonCntsFileNmM;
    }
    /**
     * @return lessonCntsFilePathM 값을 반환한다.
     */
    public String getLessonCntsFilePathM()
    {
        return lessonCntsFilePathM;
    }
    /**
     * @param lessonCntsFilePathM 을 lessonCntsFilePathM 에 저장한다.
     */
    public void setLessonCntsFilePathM(String lessonCntsFilePathM)
    {
        this.lessonCntsFilePathM = lessonCntsFilePathM;
    }
    /**
     * @return lessonCntsUrlM 값을 반환한다.
     */
    public String getLessonCntsUrlM()
    {
        return lessonCntsUrlM;
    }
    /**
     * @param lessonCntsUrlM 을 lessonCntsUrlM 에 저장한다.
     */
    public void setLessonCntsUrlM(String lessonCntsUrlM)
    {
        this.lessonCntsUrlM = lessonCntsUrlM;
    }
    /**
     * @return recmmdStudyTime 값을 반환한다.
     */
    public Integer getRecmmdStudyTime()
    {
        return recmmdStudyTime;
    }
    /**
     * @param recmmdStudyTime 을 recmmdStudyTime 에 저장한다.
     */
    public void setRecmmdStudyTime(Integer recmmdStudyTime)
    {
        this.recmmdStudyTime = recmmdStudyTime;
    }
    /**
     * @return prgrRatioTypeCd 값을 반환한다.
     */
    public String getPrgrRatioTypeCd()
    {
        return prgrRatioTypeCd;
    }
    /**
     * @param prgrRatioTypeCd 을 prgrRatioTypeCd 에 저장한다.
     */
    public void setPrgrRatioTypeCd(String prgrRatioTypeCd)
    {
        this.prgrRatioTypeCd = prgrRatioTypeCd;
    }
    /**
     * @return viewYn 값을 반환한다.
     */
    public String getViewYn()
    {
        return viewYn;
    }
    /**
     * @param viewYn 을 viewYn 에 저장한다.
     */
    public void setViewYn(String viewYn)
    {
        this.viewYn = viewYn;
    }
    /**
     * @return periodOutLearnYn 값을 반환한다.
     */
    public String getPeriodOutLearnYn()
    {
        return periodOutLearnYn;
    }
    /**
     * @param periodOutLearnYn 을 periodOutLearnYn 에 저장한다.
     */
    public void setPeriodOutLearnYn(String periodOutLearnYn)
    {
        this.periodOutLearnYn = periodOutLearnYn;
    }
    /**
     * @return periodOutLearnDay 값을 반환한다.
     */
    public String getPeriodOutLearnDay()
    {
        return periodOutLearnDay;
    }
    /**
     * @param periodOutLearnDay 을 periodOutLearnDay 에 저장한다.
     */
    public void setPeriodOutLearnDay(String periodOutLearnDay)
    {
        this.periodOutLearnDay = periodOutLearnDay;
    }
    /**
     * @return periodOutLearnDayCnt 값을 반환한다.
     */
    public String getPeriodOutLearnDayCnt()
    {
        return periodOutLearnDayCnt;
    }
    /**
     * @param periodOutLearnDayCnt 을 periodOutLearnDayCnt 에 저장한다.
     */
    public void setPeriodOutLearnDayCnt(String periodOutLearnDayCnt)
    {
        this.periodOutLearnDayCnt = periodOutLearnDayCnt;
    }
    /**
     * @return periodOutLearnStatusCd 값을 반환한다.
     */
    public String getPeriodOutLearnStatusCd()
    {
        return periodOutLearnStatusCd;
    }
    /**
     * @param periodOutLearnStatusCd 을 periodOutLearnStatusCd 에 저장한다.
     */
    public void setPeriodOutLearnStatusCd(String periodOutLearnStatusCd)
    {
        this.periodOutLearnStatusCd = periodOutLearnStatusCd;
    }
    /**
     * @return learnStatusCheckYn 값을 반환한다.
     */
    public String getLearnStatusCheckYn()
    {
        return learnStatusCheckYn;
    }
    /**
     * @param learnStatusCheckYn 을 learnStatusCheckYn 에 저장한다.
     */
    public void setLearnStatusCheckYn(String learnStatusCheckYn)
    {
        this.learnStatusCheckYn = learnStatusCheckYn;
    }
    /**
     * @return newWindowLearnYn 값을 반환한다.
     */
    public String getNewWindowLearnYn()
    {
        return newWindowLearnYn;
    }
    /**
     * @param newWindowLearnYn 을 newWindowLearnYn 에 저장한다.
     */
    public void setNewWindowLearnYn(String newWindowLearnYn)
    {
        this.newWindowLearnYn = newWindowLearnYn;
    }
    /**
     * @return lessonDataFileYn 값을 반환한다.
     */
    public String getLessonDataFileYn()
    {
        return lessonDataFileYn;
    }
    /**
     * @param lessonDataFileYn 을 lessonDataFileYn 에 저장한다.
     */
    public void setLessonDataFileYn(String lessonDataFileYn)
    {
        this.lessonDataFileYn = lessonDataFileYn;
    }
    /**
     * @return lessonDataFileNm 값을 반환한다.
     */
    public String getLessonDataFileNm()
    {
        return lessonDataFileNm;
    }
    /**
     * @param lessonDataFileNm 을 lessonDataFileNm 에 저장한다.
     */
    public void setLessonDataFileNm(String lessonDataFileNm)
    {
        this.lessonDataFileNm = lessonDataFileNm;
    }
    /**
     * @return lessonDataFilePath 값을 반환한다.
     */
    public String getLessonDataFilePath()
    {
        return lessonDataFilePath;
    }
    /**
     * @param lessonDataFilePath 을 lessonDataFilePath 에 저장한다.
     */
    public void setLessonDataFilePath(String lessonDataFilePath)
    {
        this.lessonDataFilePath = lessonDataFilePath;
    }
    /**
     * @return lessonDataFileUrl 값을 반환한다.
     */
    public String getLessonDataFileUrl()
    {
        return lessonDataFileUrl;
    }
    /**
     * @param lessonDataFileUrl 을 lessonDataFileUrl 에 저장한다.
     */
    public void setLessonDataFileUrl(String lessonDataFileUrl)
    {
        this.lessonDataFileUrl = lessonDataFileUrl;
    }
    /**
     * @return attplanTime 값을 반환한다.
     */
    public Integer getAttplanTime()
    {
        return attplanTime;
    }
    /**
     * @param attplanTime 을 attplanTime 에 저장한다.
     */
    public void setAttplanTime(Integer attplanTime)
    {
        this.attplanTime = attplanTime;
    }
    /**
     * @return skplcDivCd 값을 반환한다.
     */
    public String getSkplcDivCd()
    {
        return skplcDivCd;
    }
    /**
     * @param skplcDivCd 을 skplcDivCd 에 저장한다.
     */
    public void setSkplcDivCd(String skplcDivCd)
    {
        this.skplcDivCd = skplcDivCd;
    }
    /**
     * @return vcLearnStartDttm 값을 반환한다.
     */
    public String getVcLearnStartDttm()
    {
        return vcLearnStartDttm;
    }
    /**
     * @param vcLearnStartDttm 을 vcLearnStartDttm 에 저장한다.
     */
    public void setVcLearnStartDttm(String vcLearnStartDttm)
    {
        this.vcLearnStartDttm = vcLearnStartDttm;
    }
    /**
     * @return vcLearnEndDttm 값을 반환한다.
     */
    public String getVcLearnEndDttm()
    {
        return vcLearnEndDttm;
    }
    /**
     * @param vcLearnEndDttm 을 vcLearnEndDttm 에 저장한다.
     */
    public void setVcLearnEndDttm(String vcLearnEndDttm)
    {
        this.vcLearnEndDttm = vcLearnEndDttm;
    }
    /**
     * @return vcLearnRoomPwd 값을 반환한다.
     */
    public String getVcLearnRoomPwd()
    {
        return vcLearnRoomPwd;
    }
    /**
     * @param vcLearnRoomPwd 을 vcLearnRoomPwd 에 저장한다.
     */
    public void setVcLearnRoomPwd(String vcLearnRoomPwd)
    {
        this.vcLearnRoomPwd = vcLearnRoomPwd;
    }
    /**
     * @return vcLearnDesc 값을 반환한다.
     */
    public String getVcLearnDesc()
    {
        return vcLearnDesc;
    }
    /**
     * @param vcLearnDesc 을 vcLearnDesc 에 저장한다.
     */
    public void setVcLearnDesc(String vcLearnDesc)
    {
        this.vcLearnDesc = vcLearnDesc;
    }
    /**
     * @return vcRoomRelId 값을 반환한다.
     */
    public String getVcRoomRelId()
    {
        return vcRoomRelId;
    }
    /**
     * @param vcRoomRelId 을 vcRoomRelId 에 저장한다.
     */
    public void setVcRoomRelId(String vcRoomRelId)
    {
        this.vcRoomRelId = vcRoomRelId;
    }
    /**
     * @return delYn 값을 반환한다.
     */
    public String getDelYn()
    {
        return delYn;
    }
    /**
     * @param delYn 을 delYn 에 저장한다.
     */
    public void setDelYn(String delYn)
    {
        this.delYn = delYn;
    }
    /**
     * @return rgtrId 값을 반환한다.
     */
    /**
     * @return lessonCntsCmntId 값을 반환한다.
     */
    public String getLessonCntsCmntId()
    {
        return lessonCntsCmntId;
    }
    /**
     * @param lessonCntsCmntId 을 lessonCntsCmntId 에 저장한다.
     */
    public void setLessonCntsCmntId(String lessonCntsCmntId)
    {
        this.lessonCntsCmntId = lessonCntsCmntId;
    }
    /**
     * @return parLessonCntsCmntId 값을 반환한다.
     */
    public String getParLessonCntsCmntId()
    {
        return parLessonCntsCmntId;
    }
    /**
     * @param parLessonCntsCmntId 을 parLessonCntsCmntId 에 저장한다.
     */
    public void setParLessonCntsCmntId(String parLessonCntsCmntId)
    {
        this.parLessonCntsCmntId = parLessonCntsCmntId;
    }
    /**
     * @return cmntCts 값을 반환한다.
     */
    public String getCmntCts()
    {
        return cmntCts;
    }
    /**
     * @param cmntCts 을 cmntCts 에 저장한다.
     */
    public void setCmntCts(String cmntCts)
    {
        this.cmntCts = cmntCts;
    }
    /**
     * @return lessonScheduleNm 값을 반환한다.
     */
    public String getLessonScheduleNm()
    {
        return lessonScheduleNm;
    }
    /**
     * @param lessonScheduleNm 을 lessonScheduleNm 에 저장한다.
     */
    public void setLessonScheduleNm(String lessonScheduleNm)
    {
        this.lessonScheduleNm = lessonScheduleNm;
    }
    /**
     * @return lessonScheduleOrder 값을 반환한다.
     */
    public Integer getLessonScheduleOrder()
    {
        return lessonScheduleOrder;
    }
    /**
     * @param lessonScheduleOrder 을 lessonScheduleOrder 에 저장한다.
     */
    public void setLessonScheduleOrder(Integer lessonScheduleOrder)
    {
        this.lessonScheduleOrder = lessonScheduleOrder;
    }
    /**
     * @return lessonObject 값을 반환한다.
     */
    public String getLessonObject()
    {
        return lessonObject;
    }
    /**
     * @param lessonObject 을 lessonObject 에 저장한다.
     */
    public void setLessonObject(String lessonObject)
    {
        this.lessonObject = lessonObject;
    }
    /**
     * @return lessonSummary 값을 반환한다.
     */
    public String getLessonSummary()
    {
        return lessonSummary;
    }
    /**
     * @param lessonSummary 을 lessonSummary 에 저장한다.
     */
    public void setLessonSummary(String lessonSummary)
    {
        this.lessonSummary = lessonSummary;
    }
    /**
     * @return lessonRepData 값을 반환한다.
     */
    public String getLessonRepData()
    {
        return lessonRepData;
    }
    /**
     * @param lessonRepData 을 lessonRepData 에 저장한다.
     */
    public void setLessonRepData(String lessonRepData)
    {
        this.lessonRepData = lessonRepData;
    }
    /**
     * @return lessonStartDt 값을 반환한다.
     */
    public String getLessonStartDt()
    {
        return lessonStartDt;
    }
    /**
     * @param lessonStartDt 을 lessonStartDt 에 저장한다.
     */
    public void setLessonStartDt(String lessonStartDt)
    {
        this.lessonStartDt = lessonStartDt;
    }
    /**
     * @return lessonEndDt 값을 반환한다.
     */
    public String getLessonEndDt()
    {
        return lessonEndDt;
    }
    /**
     * @param lessonEndDt 을 lessonEndDt 에 저장한다.
     */
    public void setLessonEndDt(String lessonEndDt)
    {
        this.lessonEndDt = lessonEndDt;
    }
    /**
     * @return studyStatusCd 값을 반환한다.
     */
    public String getStudyStatusCd()
    {
        return studyStatusCd;
    }
    /**
     * @param studyStatusCd 을 studyStatusCd 에 저장한다.
     */
    public void setStudyStatusCd(String studyStatusCd)
    {
        this.studyStatusCd = studyStatusCd;
    }
    /**
	 * @return the studyStatusCdBak
	 */
	public String getStudyStatusCdBak() {
		return studyStatusCdBak;
	}
	/**
	 * @param studyStatusCdBak the studyStatusCdBak to set
	 */
	public void setStudyStatusCdBak(String studyStatusCdBak) {
		this.studyStatusCdBak = studyStatusCdBak;
	}
	/**
	 * @return the studyStatusCdNm
	 */
	public String getStudyStatusCdNm() {
		return studyStatusCdNm;
	}
	/**
	 * @param studyStatusCdNm the studyStatusCdNm to set
	 */
	public void setStudyStatusCdNm(String studyStatusCdNm) {
		this.studyStatusCdNm = studyStatusCdNm;
	}
	/**
     * @return studyCnt 값을 반환한다.
     */
    public Integer getStudyCnt()
    {
        return studyCnt;
    }
    /**
     * @param studyCnt 을 studyCnt 에 저장한다.
     */
    public void setStudyCnt(Integer studyCnt)
    {
        this.studyCnt = studyCnt;
    }
    /**
     * @return studySessionTm 값을 반환한다.
     */
    public Integer getStudySessionTm()
    {
        return studySessionTm;
    }
    /**
     * @param studySessionTm 을 studySessionTm 에 저장한다.
     */
    public void setStudySessionTm(Integer studySessionTm)
    {
        this.studySessionTm = studySessionTm;
    }
    /**
     * @return studyTotalTm 값을 반환한다.
     */
    public Integer getStudyTotalTm()
    {
        return studyTotalTm;
    }
    /**
     * @param studyTotalTm 을 studyTotalTm 에 저장한다.
     */
    public void setStudyTotalTm(Integer studyTotalTm)
    {
        this.studyTotalTm = studyTotalTm;
    }
    /**
     * @return studyAfterTm 값을 반환한다.
     */
    public Integer getStudyAfterTm()
    {
        return studyAfterTm;
    }
    /**
     * @param studyAfterTm 을 studyAfterTm 에 저장한다.
     */
    public void setStudyAfterTm(Integer studyAfterTm)
    {
        this.studyAfterTm = studyAfterTm;
    }
    /**
     * @return studyStartDttm 값을 반환한다.
     */
    public String getStudyStartDttm()
    {
        return studyStartDttm;
    }
    /**
     * @param studyStartDttm 을 studyStartDttm 에 저장한다.
     */
    public void setStudyStartDttm(String studyStartDttm)
    {
        this.studyStartDttm = studyStartDttm;
    }
    /**
     * @return studySessionDttm 값을 반환한다.
     */
    public String getStudySessionDttm()
    {
        return studySessionDttm;
    }
    /**
     * @param studySessionDttm 을 studySessionDttm 에 저장한다.
     */
    public void setStudySessionDttm(String studySessionDttm)
    {
        this.studySessionDttm = studySessionDttm;
    }
    /**
     * @return studySessionLoc 값을 반환한다.
     */
    public String getStudySessionLoc()
    {
        return studySessionLoc;
    }
    /**
     * @param studySessionLoc 을 studySessionLoc 에 저장한다.
     */
    public void setStudySessionLoc(String studySessionLoc)
    {
        this.studySessionLoc = studySessionLoc;
    }
    /**
     * @return studyMaxLoc 값을 반환한다.
     */
    public String getStudyMaxLoc()
    {
        return studyMaxLoc;
    }
    /**
     * @param studyMaxLoc 을 studyMaxLoc 에 저장한다.
     */
    public void setStudyMaxLoc(String studyMaxLoc)
    {
        this.studyMaxLoc = studyMaxLoc;
    }
    /**
     * @return prgrRatio 값을 반환한다.
     */
    public Integer getPrgrRatio()
    {
        return prgrRatio;
    }
    /**
     * @param prgrRatio 을 prgrRatio 에 저장한다.
     */
    public void setPrgrRatio(Integer prgrRatio)
    {
        this.prgrRatio = prgrRatio;
    }
    /**
     * @return studyDetailId 값을 반환한다.
     */
    public String getStudyDetailId()
    {
        return studyDetailId;
    }
    /**
     * @param studyDetailId 을 studyDetailId 에 저장한다.
     */
    public void setStudyDetailId(String studyDetailId)
    {
        this.studyDetailId = studyDetailId;
    }
    /**
     * @return studyTm 값을 반환한다.
     */
    public Integer getStudyTm()
    {
        return studyTm;
    }
    /**
     * @param studyTm 을 studyTm 에 저장한다.
     */
    public void setStudyTm(Integer studyTm)
    {
        this.studyTm = studyTm;
    }
    /**
     * @return studyBrowserCd 값을 반환한다.
     */
    public String getStudyBrowserCd()
    {
        return studyBrowserCd;
    }
    /**
     * @param studyBrowserCd 을 studyBrowserCd 에 저장한다.
     */
    public void setStudyBrowserCd(String studyBrowserCd)
    {
        this.studyBrowserCd = studyBrowserCd;
    }
    /**
     * @return studyDeviceCd 값을 반환한다.
     */
    public String getStudyDeviceCd()
    {
        return studyDeviceCd;
    }
    /**
     * @param studyDeviceCd 을 studyDeviceCd 에 저장한다.
     */
    public void setStudyDeviceCd(String studyDeviceCd)
    {
        this.studyDeviceCd = studyDeviceCd;
    }
    /**
     * @return studyClientEnv 값을 반환한다.
     */
    public String getStudyClientEnv()
    {
        return studyClientEnv;
    }
    /**
     * @param studyClientEnv 을 studyClientEnv 에 저장한다.
     */
    public void setStudyClientEnv(String studyClientEnv)
    {
        this.studyClientEnv = studyClientEnv;
    }
    /**
     * @return regIp 값을 반환한다.
     */
    public String getRegIp()
    {
        return regIp;
    }
    /**
     * @param regIp 을 regIp 에 저장한다.
     */
    public void setRegIp(String regIp)
    {
        this.regIp = regIp;
    }
    /**
     * @return recomCnt 값을 반환한다.
     */
    public Integer getRecomCnt()
    {
        return recomCnt;
    }
    /**
     * @param recomCnt 을 recomCnt 에 저장한다.
     */
    public void setRecomCnt(Integer recomCnt)
    {
        this.recomCnt = recomCnt;
    }
    /**
     * @return myRecomYn 값을 반환한다.
     */
    public String getMyRecomYn()
    {
        return myRecomYn;
    }
    /**
     * @param myRecomYn 을 myRecomYn 에 저장한다.
     */
    public void setMyRecomYn(String myRecomYn)
    {
        this.myRecomYn = myRecomYn;
    }
	/**
	 * @return the studyInnerTm
	 */
	public Integer getStudyInnerTm() {
		return studyInnerTm;
	}
	/**
	 * @param studyInnerTm the studyInnerTm to set
	 */
	public void setStudyInnerTm(Integer studyInnerTm) {
		this.studyInnerTm = studyInnerTm;
	}
	/**
	 * @return the studyAfterTmMs
	 */
	public String getStudyAfterTmMs() {
		return studyAfterTmMs;
	}
	/**
	 * @param studyAfterTmMs the studyAfterTmMs to set
	 */
	public void setStudyAfterTmMs(String studyAfterTmMs) {
		this.studyAfterTmMs = studyAfterTmMs;
	}
	/**
	 * @return the studyInnerTmMs
	 */
	public String getStudyInnerTmMs() {
		return studyInnerTmMs;
	}
	/**
	 * @param studyInnerTmMs the studyInnerTmMs to set
	 */
	public void setStudyInnerTmMs(String studyInnerTmMs) {
		this.studyInnerTmMs = studyInnerTmMs;
	}
	/**
	 * @return the lessonProgress
	 */
	public String getLessonProgress() {
		return lessonProgress;
	}
	/**
	 * @param lessonProgress the lessonProgress to set
	 */
	public void setLessonProgress(String lessonProgress) {
		this.lessonProgress = lessonProgress;
	}
	/**
	 * @return the gubun
	 */
	public String getGubun() {
		return gubun;
	}
	/**
	 * @param gubun the gubun to set
	 */
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	/**
	 * @return the targetGubun
	 */
	public String getTargetGubun() {
		return targetGubun;
	}
	/**
	 * @param targetGubun the targetGubun to set
	 */
	public void setTargetGubun(String targetGubun) {
		this.targetGubun = targetGubun;
	}
	/**
	 * @return the callGubun
	 */
	public String getCallGubun() {
		return callGubun;
	}
	/**
	 * @param callGubun the callGubun to set
	 */
	public void setCallGubun(String callGubun) {
		this.callGubun = callGubun;
	}
	/**
	 * @return the openYn
	 */
	public String getOpenYn() {
		return openYn;
	}
	/**
	 * @param openYn the openYn to set
	 */
	public void setOpenYn(String openYn) {
		this.openYn = openYn;
	}
	/**
	 * @return the selectStdNos
	 */
	public String getSelectStdNos() {
		return selectStdNos;
	}
	/**
	 * @param selectStdNos the selectStdNos to set
	 */
	public void setSelectStdNos(String selectStdNos) {
		this.selectStdNos = selectStdNos;
	}
	/**
	 * @return the progressTypeCd
	 */
	public String getProgressTypeCd() {
		return progressTypeCd;
	}
	/**
	 * @param progressTypeCd the progressTypeCd to set
	 */
	public void setProgressTypeCd(String progressTypeCd) {
		this.progressTypeCd = progressTypeCd;
	}
	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}
	/**
	 * @return the listLessonStudyDetail
	 */
	public List<LessonStudyDetailVO> getListLessonStudyDetail() {
		return listLessonStudyDetail;
	}
	/**
	 * @param listLessonStudyDetail the listLessonStudyDetail to set
	 */
	public void setListLessonStudyDetail(List<LessonStudyDetailVO> listLessonStudyDetail) {
		this.listLessonStudyDetail = listLessonStudyDetail;
	}
	public String getTchNm() {
		return tchNm;
	}
	public void setTchNm(String tchNm) {
		this.tchNm = tchNm;
	}
	public String getTermType() {
		return termType;
	}
	public void setTermType(String termType) {
		this.termType = termType;
	}
	public String getCrsTypeCd() {
		return crsTypeCd;
	}
	public void setCrsTypeCd(String crsTypeCd) {
		this.crsTypeCd = crsTypeCd;
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
    public String getCrsTypeCds() {
        return crsTypeCds;
    }
    public void setCrsTypeCds(String crsTypeCds) {
        this.crsTypeCds = crsTypeCds;
    }
	public String getLcdmsLinkYn() {
		return lcdmsLinkYn;
	}
	public void setLcdmsLinkYn(String lcdmsLinkYn) {
		this.lcdmsLinkYn = lcdmsLinkYn;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    public String getUnivGbn() {
        return univGbn;
    }
    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }
    public String getUnivGbnNm() {
        return univGbnNm;
    }
    public void setUnivGbnNm(String univGbnNm) {
        this.univGbnNm = univGbnNm;
    }
    
	public String getDeptNm() { 
		return deptNm;
	} 
	public void setDeptNm(String deptNm) { 
		this.deptNm = deptNm; 
	}
	public String getLessonTimeNm() {
		return lessonTimeNm;
	}
	public void setLessonTimeNm(String lessonTimeNm) {
		this.lessonTimeNm = lessonTimeNm;
	}
	public String getCntsGbn() {
		return cntsGbn;
	}
	public void setCntsGbn(String cntsGbn) {
		this.cntsGbn = cntsGbn;
	}
	public Integer getLbnTm() {
		return lbnTm;
	}
	public void setLbnTm(Integer lbnTm) {
		this.lbnTm = lbnTm;
	}
	public String getLtNote() {
		return ltNote;
	}
	public void setLtNote(String ltNote) {
		this.ltNote = ltNote;
	}
}
