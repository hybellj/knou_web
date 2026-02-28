package knou.lms.lesson.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class LessonCntsVO extends DefaultVO {

    private static final long serialVersionUID = -5976667654704002512L;

    /** tb_lms_lesson_cnts */
    private String  lessonCntsId;           // 학습콘텐츠 아이디
    private String  crsCreCd;               // 과정 개설 코드
    private String  lessonTimeId;           // 교시 아이디
    private String  lessonTimeOrder;        // 교시 순서
    private String  lessonScheduleId;       // 학습일정 아이디
    private String  lessonScheduleOrder;    // 학습일정 순서
    private String  lessonTypeCd;           // 학습유형코드
    private String  lessonCntsNm;           // 학습콘텐츠명
    private Integer lessonCntsOrder;        // 학습콘텐츠 순서
    private String  lessonStartDttm;        // 학습 시작일시
    private String  lessonEndDttm;          // 학습 종료일시
    private String  lessonCntsFileLocCd;    // 학습파일위치코드
    private String  lessonCntsFileNm;       // 학습파일명
    private String  lessonCntsFilePath;     // 학습파일경로
    private String  lessonCntsUrl;          // 학습URL
    private String  lessonCntsFileLocCdM;   // 모바일 학습파일 위치코드
    private String  lessonCntsFileNmM;      // 모바일 학습파일명
    private String  lessonCntsFilePathM;    // 모바일 학습파일경로
    private String  lessonCntsUrlM;         // 모바일 학습URL
    private Integer recmmdStudyTime;        // 권장학습시간(분)
    private String  prgrRatioTypeCd;        // 진도율체크방식
    private String  viewYn;                 // 조회 여부
    private String  periodOutLearnYn;       // 기간 외 학습여부
    private Integer periodOutLearnDayCnt;   // 기간 외 학습일수
    private String  periodOutLearnStatusCd; // 기간 외 학습인정상태
    private String  learnStatusCheckYn;     // 학습상태 체크여부
    private String  newWindowLearnYn;       // 새창 학습여부
    private String  lessonDataFileYn;       // 학습자료파일여부
    private String  lessonDataFileNm;       // 학습자료파일명
    private String  lessonDataFilePath;     // 학습자료경로
    private String  lessonDataFileUrl;      // 학습자료URL
    private Integer attplanTime;            // 출석부시간
    private String  skplcDivCd;             // 휴보강구분코드
    private String  vcLearnStartDttm;       // 화상학습시작일시
    private String  vcLearnEndDttm;         // 화상학습종료일시
    private String  vcLearnRoomPwd;         // 화상학습방비밀번호
    private String  vcLearnDesc;            // 화상학습설명
    private String  vcRoomRelId;            // 화상방연결아이디
    private String  delYn;                  // 삭제여부
    private String  cntsGbn;                // 콘텐츠구분
    private String  prgrYn;                 // 진도반영여부
    private String  cntsText;               // 콘텐츠텍스트
    private String  videoTimeCalcMethod;    // 동영상 길이 시간체크 방식 (MANUAL: 수동)

    private String stdId;
    private String orgId;
    private String pageInfo;
    private String fileBoxCd;
    private String year;
    private String semester;
    private String courseCode;
    private int week;
    private String lcdmsLinkYn;
    
    private LessonStudyRecordVO lessonStudyRecordVO;
    private List<LessonPageVO> listLessonPage;
    private String copyLessonCntsId;
    
    private String subtitKo;
    private String subtitEn;
    private String scriptKo;
    private String scriptEn;
    private String subtitKoFiles;
    private String subtitEnFiles;
    private String scriptKoFiles;
    private String scriptEnFiles;
    private String subtitKoDelIds;
    private String subtitEnDelIds;
    private String scriptKoDelIds;
    private String scriptEnDelIds;
    private String subInfo;

    private String subtit1;
    private String subtit2;
    private String subtit3;
    private String subtitFiles1;
    private String subtitFiles2;
    private String subtitFiles3;
    private String subtitDelIds1;
    private String subtitDelIds2;
    private String subtitDelIds3;
    private String subtitLang1;
    private String subtitLang2;
    private String subtitLang3;
    
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

    public String getLessonCntsNm() {
        return lessonCntsNm;
    }

    public void setLessonCntsNm(String lessonCntsNm) {
        this.lessonCntsNm = lessonCntsNm;
    }

    public Integer getLessonCntsOrder() {
        return lessonCntsOrder;
    }

    public void setLessonCntsOrder(Integer lessonCntsOrder) {
        this.lessonCntsOrder = lessonCntsOrder;
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

    public Integer getRecmmdStudyTime() {
        return recmmdStudyTime;
    }

    public void setRecmmdStudyTime(Integer recmmdStudyTime) {
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

    public Integer getPeriodOutLearnDayCnt() {
        return periodOutLearnDayCnt;
    }

    public void setPeriodOutLearnDayCnt(Integer periodOutLearnDayCnt) {
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

    public Integer getAttplanTime() {
        return attplanTime;
    }

    public void setAttplanTime(Integer attplanTime) {
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

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getCntsGbn() {
        return cntsGbn;
    }

    public void setCntsGbn(String cntsGbn) {
        this.cntsGbn = cntsGbn;
    }

    public String getPageInfo() {
        return pageInfo;
    }

    public void setPageInfo(String pageInfo) {
        this.pageInfo = pageInfo;
    }

    public String getPrgrYn() {
        return prgrYn;
    }

    public void setPrgrYn(String prgrYn) {
        this.prgrYn = prgrYn;
    }

    public String getCntsText() {
        return cntsText;
    }

    public void setCntsText(String cntsText) {
        this.cntsText = cntsText;
    }

    public String getFileBoxCd() {
        return fileBoxCd;
    }

    public void setFileBoxCd(String fileBoxCd) {
        this.fileBoxCd = fileBoxCd;
    }

    public LessonStudyRecordVO getLessonStudyRecordVO() {
        return lessonStudyRecordVO;
    }

    public void setLessonStudyRecordVO(LessonStudyRecordVO lessonStudyRecordVO) {
        this.lessonStudyRecordVO = lessonStudyRecordVO;
    }

    public List<LessonPageVO> getListLessonPage() {
        return listLessonPage;
    }

    public void setListLessonPage(List<LessonPageVO> listLessonPage) {
        this.listLessonPage = listLessonPage;
    }

    public String getCopyLessonCntsId() {
        return copyLessonCntsId;
    }

    public void setCopyLessonCntsId(String copyLessonCntsId) {
        this.copyLessonCntsId = copyLessonCntsId;
    }

    public String getLessonTimeOrder() {
        return lessonTimeOrder;
    }

    public void setLessonTimeOrder(String lessonTimeOrder) {
        this.lessonTimeOrder = lessonTimeOrder;
    }

    public String getLessonScheduleOrder() {
        return lessonScheduleOrder;
    }

    public void setLessonScheduleOrder(String lessonScheduleOrder) {
        this.lessonScheduleOrder = lessonScheduleOrder;
    }

    public String getVideoTimeCalcMethod() {
        return videoTimeCalcMethod;
    }

    public void setVideoTimeCalcMethod(String videoTimeCalcMethod) {
        this.videoTimeCalcMethod = videoTimeCalcMethod;
    }

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getSemester() {
		return semester;
	}

	public void setSemester(String semester) {
		this.semester = semester;
	}

	public int getWeek() {
		return week;
	}

	public void setWeek(int week) {
		this.week = week;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getCourseCode() {
		return courseCode;
	}

	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}

	public String getLcdmsLinkYn() {
		return lcdmsLinkYn;
	}

	public void setLcdmsLinkYn(String lcdmsLinkYn) {
		this.lcdmsLinkYn = lcdmsLinkYn;
	}

	public String getSubtitKo() {
		return subtitKo;
	}

	public void setSubtitKo(String subtitKo) {
		this.subtitKo = subtitKo;
	}

	public String getSubtitEn() {
		return subtitEn;
	}

	public void setSubtitEn(String subtitEn) {
		this.subtitEn = subtitEn;
	}

	public String getScriptKo() {
		return scriptKo;
	}

	public void setScriptKo(String scriptKo) {
		this.scriptKo = scriptKo;
	}

	public String getScriptEn() {
		return scriptEn;
	}

	public void setScriptEn(String scriptEn) {
		this.scriptEn = scriptEn;
	}

	public String getSubtitKoFiles() {
		return subtitKoFiles;
	}

	public void setSubtitKoFiles(String subtitKoFiles) {
		this.subtitKoFiles = subtitKoFiles;
	}

	public String getSubtitEnFiles() {
		return subtitEnFiles;
	}

	public void setSubtitEnFiles(String subtitEnFiles) {
		this.subtitEnFiles = subtitEnFiles;
	}

	public String getScriptKoFiles() {
		return scriptKoFiles;
	}

	public void setScriptKoFiles(String scriptKoFiles) {
		this.scriptKoFiles = scriptKoFiles;
	}

	public String getScriptEnFiles() {
		return scriptEnFiles;
	}

	public void setScriptEnFiles(String scriptEnFiles) {
		this.scriptEnFiles = scriptEnFiles;
	}

	public String getSubtitKoDelIds() {
		return subtitKoDelIds;
	}

	public void setSubtitKoDelIds(String subtitKoDelIds) {
		this.subtitKoDelIds = subtitKoDelIds;
	}

	public String getSubtitEnDelIds() {
		return subtitEnDelIds;
	}

	public void setSubtitEnDelIds(String subtitEnDelIds) {
		this.subtitEnDelIds = subtitEnDelIds;
	}

	public String getScriptKoDelIds() {
		return scriptKoDelIds;
	}

	public void setScriptKoDelIds(String scriptKoDelIds) {
		this.scriptKoDelIds = scriptKoDelIds;
	}

	public String getScriptEnDelIds() {
		return scriptEnDelIds;
	}

	public void setScriptEnDelIds(String scriptEnDelIds) {
		this.scriptEnDelIds = scriptEnDelIds;
	}

	public String getSubInfo() {
		return subInfo;
	}

	public void setSubInfo(String subInfo) {
		this.subInfo = subInfo;
	}

	public String getSubtit1() {
		return subtit1;
	}

	public void setSubtit1(String subtit1) {
		this.subtit1 = subtit1;
	}

	public String getSubtit2() {
		return subtit2;
	}

	public void setSubtit2(String subtit2) {
		this.subtit2 = subtit2;
	}

	public String getSubtit3() {
		return subtit3;
	}

	public void setSubtit3(String subtit3) {
		this.subtit3 = subtit3;
	}

	public String getSubtitFiles1() {
		return subtitFiles1;
	}

	public void setSubtitFiles1(String subtitFiles1) {
		this.subtitFiles1 = subtitFiles1;
	}

	public String getSubtitFiles2() {
		return subtitFiles2;
	}

	public void setSubtitFiles2(String subtitFiles2) {
		this.subtitFiles2 = subtitFiles2;
	}

	public String getSubtitFiles3() {
		return subtitFiles3;
	}

	public void setSubtitFiles3(String subtitFiles3) {
		this.subtitFiles3 = subtitFiles3;
	}

	public String getSubtitDelIds1() {
		return subtitDelIds1;
	}

	public void setSubtitDelIds1(String subtitDelIds1) {
		this.subtitDelIds1 = subtitDelIds1;
	}

	public String getSubtitDelIds2() {
		return subtitDelIds2;
	}

	public void setSubtitDelIds2(String subtitDelIds2) {
		this.subtitDelIds2 = subtitDelIds2;
	}

	public String getSubtitDelIds3() {
		return subtitDelIds3;
	}

	public void setSubtitDelIds3(String subtitDelIds3) {
		this.subtitDelIds3 = subtitDelIds3;
	}

	public String getSubtitLang1() {
		return subtitLang1;
	}

	public void setSubtitLang1(String subtitLang1) {
		this.subtitLang1 = subtitLang1;
	}

	public String getSubtitLang2() {
		return subtitLang2;
	}

	public void setSubtitLang2(String subtitLang2) {
		this.subtitLang2 = subtitLang2;
	}

	public String getSubtitLang3() {
		return subtitLang3;
	}

	public void setSubtitLang3(String subtitLang3) {
		this.subtitLang3 = subtitLang3;
	}


}
