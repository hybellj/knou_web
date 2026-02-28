package knou.lms.file.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("crsSizeMgrVO")
public class CrsSizeMgrVO extends DefaultVO {

    private static final long serialVersionUID = -484409939756667137L;
    
    // 검색
    private String selectedCrsCreCd;
    private String searchCreYear;
    private String searchCreTerm;
    private String userOrgId;
    private String langCd;

    // 목록 결과
    private Integer rowNum;
    private String crsCd;
    private String crsCreCd;
    private String crsTypeCd;
    private String creYear;
    private String crsCreNm;
    private String declsNo;
    private String declsNm;
    private String learningType;
    private String learningTypeNm;
    private String courseType;
    private String courseTypeNm;
    private String professorNo;
    private String professorNm;
    private Integer bbsFileSize;
    private Integer forumFileSize;
    private Integer asmtFileSize;
    private Integer examFileSize;
    private Integer teamFileSize;
    private Integer lectureFileSize;

    // 용량 초기 설정 목록
    private String fileSizeLimitId;
    private String limitTypeCd;

    // 수정
    private Integer limitFileSize;
    private String  limitTypeDetlCd;
    private String  limitTypeDetlNm;

    /** @return selectedCrsCreCd 값을 반환한다. */
    public String getSelectedCrsCreCd() {
        return selectedCrsCreCd;
    }

    /**
     * @param selectedCrsCreCd을 selectedCrsCreCd 에 저장한다.
     */
    public void setSelectedCrsCreCd(String selectedCrsCreCd) {
        this.selectedCrsCreCd = selectedCrsCreCd;
    }

    /** @return searchCreYear 값을 반환한다. */
    public String getSearchCreYear() {
        return searchCreYear;
    }

    /**
     * @param searchCreYear을 searchCreYear 에 저장한다.
     */
    public void setSearchCreYear(String searchCreYear) {
        this.searchCreYear = searchCreYear;
    }

    /** @return searchCreTerm 값을 반환한다. */
    public String getSearchCreTerm() {
        return searchCreTerm;
    }

    /**
     * @param searchCreTerm을 searchCreTerm 에 저장한다.
     */
    public void setSearchCreTerm(String searchCreTerm) {
        this.searchCreTerm = searchCreTerm;
    }

    /** @return rowNum 값을 반환한다. */
    public Integer getRowNum() {
        return rowNum;
    }

    /**
     * @param rowNum을 rowNum 에 저장한다.
     */
    public void setRowNum(Integer rowNum) {
        this.rowNum = rowNum;
    }

    /** @return crsCd 값을 반환한다. */
    public String getCrsCd() {
        return crsCd;
    }

    /**
     * @param crsCd을 crsCd 에 저장한다.
     */
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    /** @return crsCreCd 값을 반환한다. */
    public String getCrsCreCd() {
        return crsCreCd;
    }

    /**
     * @param crsCreCd을 crsCreCd 에 저장한다.
     */
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    /** @return crsCreNm 값을 반환한다. */
    public String getCrsCreNm() {
        return crsCreNm;
    }

    /**
     * @param crsCreNm을 crsCreNm 에 저장한다.
     */
    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }

    /** @return declsNo 값을 반환한다. */
    public String getDeclsNo() {
        return declsNo;
    }

    /**
     * @param declsNo을 declsNo 에 저장한다.
     */
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }

    public String getDeclsNm() {
		return declsNm;
	}

	public void setDeclsNm(String declsNm) {
		this.declsNm = declsNm;
	}

	/** @return learningType 값을 반환한다. */
    public String getLearningType() {
        return learningType;
    }

    /**
     * @param learningType을 learningType 에 저장한다.
     */
    public void setLearningType(String learningType) {
        this.learningType = learningType;
    }

    /** @return learningTypeNm 값을 반환한다. */
    public String getLearningTypeNm() {
        return learningTypeNm;
    }

    /**
     * @param learningTypeNm을 learningTypeNm 에 저장한다.
     */
    public void setLearningTypeNm(String learningTypeNm) {
        this.learningTypeNm = learningTypeNm;
    }

    /** @return courseType 값을 반환한다. */
    public String getCourseType() {
        return courseType;
    }

    /**
     * @param courseType을 courseType 에 저장한다.
     */
    public void setCourseType(String courseType) {
        this.courseType = courseType;
    }

    /** @return courseTypeNm 값을 반환한다. */
    public String getCourseTypeNm() {
        return courseTypeNm;
    }

    /**
     * @param courseTypeNm을 courseTypeNm 에 저장한다.
     */
    public void setCourseTypeNm(String courseTypeNm) {
        this.courseTypeNm = courseTypeNm;
    }

    /** @return professorNo 값을 반환한다. */
    public String getProfessorNo() {
        return professorNo;
    }

    /**
     * @param professorNo을 professorNo 에 저장한다.
     */
    public void setProfessorNo(String professorNo) {
        this.professorNo = professorNo;
    }

    /** @return professorNm 값을 반환한다. */
    public String getProfessorNm() {
        return professorNm;
    }

    /**
     * @param professorNm을 professorNm 에 저장한다.
     */
    public void setProfessorNm(String professorNm) {
        this.professorNm = professorNm;
    }

    /** @return userOrgId 값을 반환한다. */
    public String getUserOrgId() {
        return userOrgId;
    }

    /**
     * @param userOrgId을 userOrgId 에 저장한다.
     */
    public void setUserOrgId(String userOrgId) {
        this.userOrgId = userOrgId;
    }

    /** @return bbsFileSize 값을 반환한다. */
    public Integer getBbsFileSize() {
        return bbsFileSize;
    }

    /**
     * @param bbsFileSize을 bbsFileSize 에 저장한다.
     */
    public void setBbsFileSize(Integer bbsFileSize) {
        this.bbsFileSize = bbsFileSize;
    }

    /** @return forumFileSize 값을 반환한다. */
    public Integer getForumFileSize() {
        return forumFileSize;
    }

    /**
     * @param forumFileSize을 forumFileSize 에 저장한다.
     */
    public void setForumFileSize(Integer forumFileSize) {
        this.forumFileSize = forumFileSize;
    }

    /** @return asmtFileSize 값을 반환한다. */
    public Integer getAsmtFileSize() {
        return asmtFileSize;
    }

    /**
     * @param asmtFileSize을 asmtFileSize 에 저장한다.
     */
    public void setAsmtFileSize(Integer asmtFileSize) {
        this.asmtFileSize = asmtFileSize;
    }

    /** @return examFileSize 값을 반환한다. */
    public Integer getExamFileSize() {
        return examFileSize;
    }

    /**
     * @param examFileSize을 examFileSize 에 저장한다.
     */
    public void setExamFileSize(Integer examFileSize) {
        this.examFileSize = examFileSize;
    }

    /** @return teamFileSize 값을 반환한다. */
    public Integer getTeamFileSize() {
        return teamFileSize;
    }

    /**
     * @param teamFileSize을 teamFileSize 에 저장한다.
     */
    public void setTeamFileSize(Integer teamFileSize) {
        this.teamFileSize = teamFileSize;
    }

    /** @return limitFileSize 값을 반환한다. */
    public Integer getLimitFileSize() {
        return limitFileSize;
    }

    /**
     * @param limitFileSize을 limitFileSize 에 저장한다.
     */
    public void setLimitFileSize(Integer limitFileSize) {
        this.limitFileSize = limitFileSize;
    }

    /** @return limitTypeDetlCd 값을 반환한다. */
    public String getLimitTypeDetlCd() {
        return limitTypeDetlCd;
    }

    /**
     * @param limitTypeDetlCd을 limitTypeDetlCd 에 저장한다.
     */
    public void setLimitTypeDetlCd(String limitTypeDetlCd) {
        this.limitTypeDetlCd = limitTypeDetlCd;
    }

    /** @return fileSizeLimitId 값을 반환한다. */
    public String getFileSizeLimitId() {
        return fileSizeLimitId;
    }

    /**
     * @param fileSizeLimitId을 fileSizeLimitId 에 저장한다.
     */
    public void setFileSizeLimitId(String fileSizeLimitId) {
        this.fileSizeLimitId = fileSizeLimitId;
    }

    /** @return limitTypeCd 값을 반환한다. */
    public String getLimitTypeCd() {
        return limitTypeCd;
    }

    /**
     * @param limitTypeCd을 limitTypeCd 에 저장한다.
     */
    public void setLimitTypeCd(String limitTypeCd) {
        this.limitTypeCd = limitTypeCd;
    }

    /** @return limitTypeDetlNm 값을 반환한다. */
    public String getLimitTypeDetlNm() {
        return limitTypeDetlNm;
    }

    /**
     * @param limitTypeDetlNm을 limitTypeDetlNm 에 저장한다.
     */
    public void setLimitTypeDetlNm(String limitTypeDetlNm) {
        this.limitTypeDetlNm = limitTypeDetlNm;
    }

    /** @return lectureFileSize 값을 반환한다. */
    public Integer getLectureFileSize() {
        return lectureFileSize;
    }

    /**
     * @param lectureFileSize을 lectureFileSize 에 저장한다.
     */
    public void setLectureFileSize(Integer lectureFileSize) {
        this.lectureFileSize = lectureFileSize;
    }

	public String getLangCd() {
		return langCd;
	}

	public void setLangCd(String langCd) {
		this.langCd = langCd;
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
	
}
