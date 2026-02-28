package knou.lms.menu.vo;

import knou.lms.common.vo.DefaultVO;

public class ReviewVO extends DefaultVO {

    private static final long serialVersionUID = -6627136185177479376L;
    
    /** tb_lms_lesson_schedule */
    private String lessonCntsId;                        /* 학습콘텐츠 아이디 */
    private String crsCreCd;                            /* 과정 개설 코드 */
    private String crsCd;
    private String lessonTimeId;                        /* 교시 아이디 */
    private String lessonScheduleId;                    /* 학습일정 아이디 */
    private String lessonTypeCd;                        /* 학습유형코드 */
    private String lessonTypeNm;                        /* 학습유형명 */
    private String lessonCntsNm;                        /* 학습콘텐츠명 */
    private String lessonCntsOrder;                     /* 학습콘텐츠순서 */
    private String cntsGbn;                             /* 콘텐츠구분 */
    private String cntsGbnNm;                             /* 콘텐츠구분 */
    private String prgrYn;                              /* 진도반영여부 */
    private String lessonStartDttm;                     /* 학습시작일시 */
    private String lessonEndDttm;                       /* 학습종료일시 */
    private String lessonCntsFileLocCd;                 /* 학습파일위치코드 */
    private String lessonCntsFileNm;                    /* 학습파일명 */
    private String lessonCntsFilePath;                  /* 학습파일경로 */
    private String lessonCntsUrl;                       /* 학습URL */
    private String lessonCntsFileLocCdM;                /* 모바일학습파일위치코드 */
    private String lessonCntsFileNmM;                   /* 모바일학습파일명 */
    private String lessonCntsFilePathM;                 /* 모바일학습파일경로 */
    private String lessonCntsUrlM;                      /* 모바일학습URL */
    private String recmmdStudyTime;                     /* 권장학습시간(분) */
    private String prgrRatioTypeCd;                     /* 진도율체크방식 */
    private String viewYn;                              /* 조회 여부 */
    private String periodOutLearnYn;                    /* 기간외학습여부 */
    private String periodOutLearnDayCnt;                /* 기간외학습일수 */
    private String periodOutLearnStatusCd;              /* 기간외학습인정상태 */
    private String learnStatusCheckYn;                  /* 학습상태체크여부 */
    private String newWindowLearnYn;                    /* 새창학습여부 */
    private String lessonDataFileYn;                    /* 학습자료파일여부 */
    private String lessonDataFileNm;                    /* 학습자료파일명 */
    private String lessonDataFilePath;                  /* 학습자료경로 */
    private String lessonDataFileUrl;                   /* 학습자료URL */
    private String attplanTime;                         /* 출석부시간 */
    private String skplcDivCd;                          /* 휴보강구분코드 */
    private String vcLearnStartDttm;                    /* 화상학습시작일시 */
    private String vcLearnEndDttm;                      /* 화상학습종료일시 */
    private String vcLearnRoomPwd;                      /* 화상학습방비밀번호 */
    private String vcLearnDesc;                         /* 화상학습설명 */
    private String vcRoomRelId;                         /* 화상방연결아이디 */
    private String delYn;                               /* 삭제 여부 */
    private String rgtrId;                               /* 등록자 */
    private String regDttm;                             /* 등록일 */
    private String mdfrId;                               /* 수정자 */
    private String modDttm;                             /* 수정일 */

    /** tb_lms_lesson_schedule */
    // private String lessonScheduleId;                 /* 학습일정ID */
    // private String crsCreCd;                         /* 과정개설코드 */
    private String lessonScheduleNm;                    /* 학습일정명 */
    private String lessonScheduleOrder;                 /* 학습일정순서 */
    private String enrlType;                            /* 수강유형(online, offline) */
    private String lessonObject;                        /* 학습목표 */
    private String lessonSummary;                       /* 학습개요 */
    private String lessonRefData;                       /* 학습참고자로 */
    private String lessonStartDt;                       /* 학습시작일자 */
    private String lessonEndDt;                         /* 학습종료일자 */
    private String openYn;                              /* 오픈여부 */
    private String lbnTm;                               /* 학습시간 */
    private String ltNote;                              /* 강의노트 */
    // private String delYn;                            /* 삭제여부 */
    // private String rgtrId;                            /* 등록자 */
    // private String regDttm;                          /* 등록일 */
    // private String mdfrId;                            /* 수정자 */
    // private String modDttm;                          /* 수정일 */

    /** tb_lms_lesson_time */
    // private String lessonTimeId;             /* 교시ID */
    // private String lessonScheduleId;         /* 학습일정ID */
    // private String crsCreCd;                 /* 과정개설코드 */
    private String lessonTimeNm;                /* 교시명 */
    private String lessonTimeOrder;             /* 교시순서 */
    private String stdyMethod;                  /* 학습방법 */
    // private String rgtrId;                    /* 등록자 */
    // private String regDttm;                  /* 등록일 */
    // private String mdfrId;                    /* 수정자 */
    // private String modDttm;                  /* 수정일 */
    
    private String orgId;
    private String creYear;
    private String creTerm;
    private String deptCd;
    private String deptNm;
    private String useYn;
    private String declsNo;
    private String enrlCertStatus;
    private String uniCd;
    
    private String reviewStatus; /* 복습기간 상태 0 : 불가 1 : 영구 2 : 기간설정 */
        
    private String reviewStartDttm;         /* 복습학습시작일시 */
    private String reviewEndDttm;           /* 복습학습종료일시 */

    private String crsOperTypeCd;
    private String userNm;

    private Integer lsnOdr;         /*목차 순서*/
    private Integer orderCnt;       /*실존 하는 값의 주차 개수*/
    private Integer onlineCnt;      /*학기 주차 전체 저장할때 쓰임*/

    private String crsTypeCds;
    private String[] crsTypeCdList;
    
    public String getLessonCntsId() {
        return lessonCntsId;
    }
    public void setLessonCntsId(String lessonCntsId) {
        this.lessonCntsId = lessonCntsId;
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
    public String getLessonTimeId() {
        return lessonTimeId;
    }
    public void setLessonTimeId(String lessonTimeId) {
        this.lessonTimeId = lessonTimeId;
    }
    public String getLessonScheduleId() {
        return lessonScheduleId;
    }
    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }
    public String getLessonTypeCd() {
        return lessonTypeCd;
    }
    public void setLessonTypeCd(String lessonTypeCd) {
        this.lessonTypeCd = lessonTypeCd;
    }
    public String getLessonTypeNm() {
        return lessonTypeNm;
    }
    public void setLessonTypeNm(String lessonTypeNm) {
        this.lessonTypeNm = lessonTypeNm;
    }
    public String getLessonCntsNm() {
        return lessonCntsNm;
    }
    public void setLessonCntsNm(String lessonCntsNm) {
        this.lessonCntsNm = lessonCntsNm;
    }
    public String getLessonCntsOrder() {
        return lessonCntsOrder;
    }
    public void setLessonCntsOrder(String lessonCntsOrder) {
        this.lessonCntsOrder = lessonCntsOrder;
    }
    public String getCntsGbn() {
        return cntsGbn;
    }
    public void setCntsGbn(String cntsGbn) {
        this.cntsGbn = cntsGbn;
    }
    public String getCntsGbnNm() {
        return cntsGbnNm;
    }
    public void setCntsGbnNm(String cntsGbnNm) {
        this.cntsGbnNm = cntsGbnNm;
    }
    public String getPrgrYn() {
        return prgrYn;
    }
    public void setPrgrYn(String prgrYn) {
        this.prgrYn = prgrYn;
    }
    public String getLessonStartDttm() {
        return lessonStartDttm;
    }
    public void setLessonStartDttm(String lessonStartDttm) {
        this.lessonStartDttm = lessonStartDttm;
    }
    public String getLessonEndDttm() {
        return lessonEndDttm;
    }
    public void setLessonEndDttm(String lessonEndDttm) {
        this.lessonEndDttm = lessonEndDttm;
    }
    public String getLessonCntsFileLocCd() {
        return lessonCntsFileLocCd;
    }
    public void setLessonCntsFileLocCd(String lessonCntsFileLocCd) {
        this.lessonCntsFileLocCd = lessonCntsFileLocCd;
    }
    public String getLessonCntsFileNm() {
        return lessonCntsFileNm;
    }
    public void setLessonCntsFileNm(String lessonCntsFileNm) {
        this.lessonCntsFileNm = lessonCntsFileNm;
    }
    public String getLessonCntsFilePath() {
        return lessonCntsFilePath;
    }
    public void setLessonCntsFilePath(String lessonCntsFilePath) {
        this.lessonCntsFilePath = lessonCntsFilePath;
    }
    public String getLessonCntsUrl() {
        return lessonCntsUrl;
    }
    public void setLessonCntsUrl(String lessonCntsUrl) {
        this.lessonCntsUrl = lessonCntsUrl;
    }
    public String getLessonCntsFileLocCdM() {
        return lessonCntsFileLocCdM;
    }
    public void setLessonCntsFileLocCdM(String lessonCntsFileLocCdM) {
        this.lessonCntsFileLocCdM = lessonCntsFileLocCdM;
    }
    public String getLessonCntsFileNmM() {
        return lessonCntsFileNmM;
    }
    public void setLessonCntsFileNmM(String lessonCntsFileNmM) {
        this.lessonCntsFileNmM = lessonCntsFileNmM;
    }
    public String getLessonCntsFilePathM() {
        return lessonCntsFilePathM;
    }
    public void setLessonCntsFilePathM(String lessonCntsFilePathM) {
        this.lessonCntsFilePathM = lessonCntsFilePathM;
    }
    public String getLessonCntsUrlM() {
        return lessonCntsUrlM;
    }
    public void setLessonCntsUrlM(String lessonCntsUrlM) {
        this.lessonCntsUrlM = lessonCntsUrlM;
    }
    public String getRecmmdStudyTime() {
        return recmmdStudyTime;
    }
    public void setRecmmdStudyTime(String recmmdStudyTime) {
        this.recmmdStudyTime = recmmdStudyTime;
    }
    public String getPrgrRatioTypeCd() {
        return prgrRatioTypeCd;
    }
    public void setPrgrRatioTypeCd(String prgrRatioTypeCd) {
        this.prgrRatioTypeCd = prgrRatioTypeCd;
    }
    public String getViewYn() {
        return viewYn;
    }
    public void setViewYn(String viewYn) {
        this.viewYn = viewYn;
    }
    public String getPeriodOutLearnYn() {
        return periodOutLearnYn;
    }
    public void setPeriodOutLearnYn(String periodOutLearnYn) {
        this.periodOutLearnYn = periodOutLearnYn;
    }
    public String getPeriodOutLearnDayCnt() {
        return periodOutLearnDayCnt;
    }
    public void setPeriodOutLearnDayCnt(String periodOutLearnDayCnt) {
        this.periodOutLearnDayCnt = periodOutLearnDayCnt;
    }
    public String getPeriodOutLearnStatusCd() {
        return periodOutLearnStatusCd;
    }
    public void setPeriodOutLearnStatusCd(String periodOutLearnStatusCd) {
        this.periodOutLearnStatusCd = periodOutLearnStatusCd;
    }
    public String getLearnStatusCheckYn() {
        return learnStatusCheckYn;
    }
    public void setLearnStatusCheckYn(String learnStatusCheckYn) {
        this.learnStatusCheckYn = learnStatusCheckYn;
    }
    public String getNewWindowLearnYn() {
        return newWindowLearnYn;
    }
    public void setNewWindowLearnYn(String newWindowLearnYn) {
        this.newWindowLearnYn = newWindowLearnYn;
    }
    public String getLessonDataFileYn() {
        return lessonDataFileYn;
    }
    public void setLessonDataFileYn(String lessonDataFileYn) {
        this.lessonDataFileYn = lessonDataFileYn;
    }
    public String getLessonDataFileNm() {
        return lessonDataFileNm;
    }
    public void setLessonDataFileNm(String lessonDataFileNm) {
        this.lessonDataFileNm = lessonDataFileNm;
    }
    public String getLessonDataFilePath() {
        return lessonDataFilePath;
    }
    public void setLessonDataFilePath(String lessonDataFilePath) {
        this.lessonDataFilePath = lessonDataFilePath;
    }
    public String getLessonDataFileUrl() {
        return lessonDataFileUrl;
    }
    public void setLessonDataFileUrl(String lessonDataFileUrl) {
        this.lessonDataFileUrl = lessonDataFileUrl;
    }
    public String getAttplanTime() {
        return attplanTime;
    }
    public void setAttplanTime(String attplanTime) {
        this.attplanTime = attplanTime;
    }
    public String getSkplcDivCd() {
        return skplcDivCd;
    }
    public void setSkplcDivCd(String skplcDivCd) {
        this.skplcDivCd = skplcDivCd;
    }
    public String getVcLearnStartDttm() {
        return vcLearnStartDttm;
    }
    public void setVcLearnStartDttm(String vcLearnStartDttm) {
        this.vcLearnStartDttm = vcLearnStartDttm;
    }
    public String getVcLearnEndDttm() {
        return vcLearnEndDttm;
    }
    public void setVcLearnEndDttm(String vcLearnEndDttm) {
        this.vcLearnEndDttm = vcLearnEndDttm;
    }
    public String getVcLearnRoomPwd() {
        return vcLearnRoomPwd;
    }
    public void setVcLearnRoomPwd(String vcLearnRoomPwd) {
        this.vcLearnRoomPwd = vcLearnRoomPwd;
    }
    public String getVcLearnDesc() {
        return vcLearnDesc;
    }
    public void setVcLearnDesc(String vcLearnDesc) {
        this.vcLearnDesc = vcLearnDesc;
    }
    public String getVcRoomRelId() {
        return vcRoomRelId;
    }
    public void setVcRoomRelId(String vcRoomRelId) {
        this.vcRoomRelId = vcRoomRelId;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
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
    public String getLessonScheduleNm() {
        return lessonScheduleNm;
    }
    public void setLessonScheduleNm(String lessonScheduleNm) {
        this.lessonScheduleNm = lessonScheduleNm;
    }
    public String getLessonScheduleOrder() {
        return lessonScheduleOrder;
    }
    public void setLessonScheduleOrder(String lessonScheduleOrder) {
        this.lessonScheduleOrder = lessonScheduleOrder;
    }
    public String getEnrlType() {
        return enrlType;
    }
    public void setEnrlType(String enrlType) {
        this.enrlType = enrlType;
    }
    public String getLessonObject() {
        return lessonObject;
    }
    public void setLessonObject(String lessonObject) {
        this.lessonObject = lessonObject;
    }
    public String getLessonSummary() {
        return lessonSummary;
    }
    public void setLessonSummary(String lessonSummary) {
        this.lessonSummary = lessonSummary;
    }
    public String getLessonRefData() {
        return lessonRefData;
    }
    public void setLessonRefData(String lessonRefData) {
        this.lessonRefData = lessonRefData;
    }
    public String getLessonStartDt() {
        return lessonStartDt;
    }
    public void setLessonStartDt(String lessonStartDt) {
        this.lessonStartDt = lessonStartDt;
    }
    public String getLessonEndDt() {
        return lessonEndDt;
    }
    public void setLessonEndDt(String lessonEndDt) {
        this.lessonEndDt = lessonEndDt;
    }
    public String getOpenYn() {
        return openYn;
    }
    public void setOpenYn(String openYn) {
        this.openYn = openYn;
    }
    public String getLbnTm() {
        return lbnTm;
    }
    public void setLbnTm(String lbnTm) {
        this.lbnTm = lbnTm;
    }
    public String getLtNote() {
        return ltNote;
    }
    public void setLtNote(String ltNote) {
        this.ltNote = ltNote;
    }
    public String getLessonTimeNm() {
        return lessonTimeNm;
    }
    public void setLessonTimeNm(String lessonTimeNm) {
        this.lessonTimeNm = lessonTimeNm;
    }
    public String getLessonTimeOrder() {
        return lessonTimeOrder;
    }
    public void setLessonTimeOrder(String lessonTimeOrder) {
        this.lessonTimeOrder = lessonTimeOrder;
    }
    public String getStdyMethod() {
        return stdyMethod;
    }
    public void setStdyMethod(String stdyMethod) {
        this.stdyMethod = stdyMethod;
    }
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
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
    public String getDeptCd() {
        return deptCd;
    }
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    public String getEnrlCertStatus() {
        return enrlCertStatus;
    }
    public void setEnrlCertStatus(String enrlCertStatus) {
        this.enrlCertStatus = enrlCertStatus;
    }
    public String getUniCd() {
        return uniCd;
    }
    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }
    
    public String getReviewStatus() {
        return reviewStatus;
    }
    public void setReviewStatus(String reviewStatus) {
        this.reviewStatus = reviewStatus;
    }
    
    public String getReviewStartDttm() {
        return reviewStartDttm;
    }
    public void setReviewStartDttm(String reviewStartDttm) {
        this.reviewStartDttm = reviewStartDttm;
    }
    public String getReviewEndDttm() {
        return reviewEndDttm;
    }
    public void setReviewEndDttm(String reviewEndDttm) {
        this.reviewEndDttm = reviewEndDttm;
    }
    public String getCrsOperTypeCd() {
        return crsOperTypeCd;
    }
    public void setCrsOperTypeCd(String crsOperTypeCd) {
        this.crsOperTypeCd = crsOperTypeCd;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    
    public Integer getLsnOdr() {
        return lsnOdr;
    }
    public void setLsnOdr(Integer lsnOdr) {
        this.lsnOdr = lsnOdr;
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
    
    public String getCrsTypeCds() {
        return crsTypeCds;
    }
    public void setCrsTypeCds(String crsTypeCds) {
        this.crsTypeCds = crsTypeCds;
    }
    public String[] getCrsTypeCdList() {
        return crsTypeCdList;
    }
    public void setCrsTypeCdList(String[] crsTypeCdList) {
        this.crsTypeCdList = crsTypeCdList;
    }
    
}
