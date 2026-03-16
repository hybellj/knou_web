package knou.lms.common.vo;

import knou.framework.util.StringUtil;

import java.io.Serializable;
import java.util.List;

/**
 * VO 공통
 */
public class DefaultVO implements Serializable {
    private static final long serialVersionUID = 9023775012070173889L;

    // 공통
    private String		gubun;				// 공통 구분값 전달
    private String		pageType;			// 페이지 형식 (normal, iframe)

    // 페이징
    private int		pageIndex = 1;		// 현재 페이지 번호
    private int		firstIndex = 1;		// 페이지 시작번호
    private int		lastIndex = 1;		// 페이지 마지막 번호
    private int		listScale = 20;		// 페이징 목록 수
    private int		pageScale = 10;		// 페이징 번호 표시 Scale
    private String		pagingYn;			// 페이징 적용 여부
    private int		totalCnt;			// 페이징 된 리스트의 총 갯수

    // 사용자 정보
    private String		userRprsId;			// 사용자 대표 아이디
    private String		userId;				// 사용자 로그인 아이디
    private String		userNm;				// 사용자 명
    private String		rgtrId;				// 등록자 아이디
    private String		rgtrnm;				// 등록자 이름
    private String		regDttm;			// 등록 일시
    private String		regIp;				// 등록자 IP
    private String		mdfrId;				// 수정자 ID
    private String		mdfrNm;				// 수정자 이름
    private String		modDttm;			// 수정 일시
    private String		modIp;				// 수정자 IP
    private String		loginIp;			// 로그인 IP

    // 검색 파라미터
    private String		searchKey;			// 검색키
    private String		searchKeyNm;		// 검색키명
    private String		searchValue;		// 검색내용
    private String		searchFrom;			// 검색 From
    private String		searchTo;			// 검색 To
    private String		searchText = "";	// 검색어
    private String		searchMenu;			// 메뉴종류
    private String		searchSort = "";	// 정렬파라미터
    private String		searchType = "";	// 검색구분
    private String		searchGubun = "";	// 엑셀 출력을 위한 조회 시 일반 조회와 구분하기 위한 파라미터
    private String		sortKey = "";		// 정렬키

    // 파일
    private String		fileSns = "";		// 첨부파일 주키 목록
    private String		fileIds = "";		// 첨부파일 ID 목록
    private String		fileNames = "";		// 첨부파일명 목록
    private String		fileSizes = "";		// 첨부파일 사이즈 목록
    private String[]	delFileIds = {};	// 삭제할 첨부파일 ID 목록
    private String		delFileIdStr = "";	// 삭제할 첨부파일 ID 목록 문자열
    private List<?>		fileList;			// 첨부파일 목록
    private String		uploadPath = "";	// 첨부파일 저장 경로
    private String		uploadFiles = "";	// 첨부파일(문자열)
    private String		copyFiles = "";		// 복사파일
    private String		repoCd = "";		// 첨부파일 저장소 코드
    private int		fileCnt = 0;		// 첨부파일수


    //
    // 이하 필드들은 사용여부 확인하여 삭제할것....
    //

    private String[] sqlForeach;            // WHERE IN을 위한 배열 파라미터
    private String[] sqlForeach2;        // WHERE IN을 위한 배열 파라미터
    private String audioData;            // 음성데이터
    private String audioFile;            // 음성파일
    private String excelGrid;            // 엑셀 헤더정보JSON string
    private String orgId;                // 기관코드 구 orgId
    private String orgNm;                // 기관명
    private String lineNo;                // 라인번호
    private String langCd = "";        // 언어코드
    private int result = 1;            // 처리결과
    private String goMcd;                // 이동 메뉴 코드
    private String goUrl;                // 이동 URL
    private String subParam;            // 서브 파라미터
    private String tabCd;                // 탭코드
    private String termCd;                // 학기 코드
    private String termNm;                // 학기 명

    private String haksaYear;            // 학사 년도(구)
    private String haksaTerm;            // 학사 학기(구)

    private String dgrsYr; 				// 학위년도
    private String dgrsSmstrChrt;		// 학위학기기수

    private String crsCreCd;            // 과목코드(구)
    private String crsCreNm;            // 과목명(구)

    private String sbjctOfrngId;		// 개설과목ID
    private String sbjctnm;				// 개설과목명
    private String sbjctId;

    // 권한
    private String authrtCd;            // 권한 코드
    private String authrtGrpcd;        // 권한 그룹 코드
    private String authrtGrpnm;        // 권한 그룹 명
    private String adminAuthYn;        // 관리자 여부

    private String pageNumber = "";    // 페이지번호
    private String moreNumber = "";    // 더보기 페이지번호
    private String searchMore = "";    // 더보기 페이지파라미터
    private String resFlag = "";    // 재검색 유무
    private String movStrQuery = "";    // 동영상 이전검색쿼리
    private String docStrQuery = "";    // 문서 이전검색쿼리
    private String htmlStrQuery = "";    // HTML 이전검색쿼리
    private String eduStrQuery = "";    // 교육 이전검색쿼리

    private String hy = "";            // 학넌
    private String entrYy = "";        // 입학년도
    private String entrHy = "";        // 입학학년
    private String entrGbnNm = "";        // 입학구분명

    public int getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(int pageIndex) {
        this.pageIndex = pageIndex;
    }

    public int getFirstIndex() {
        return firstIndex;
    }

    public void setFirstIndex(int firstIndex) {
        this.firstIndex = firstIndex;
    }

    public int getLastIndex() {
        return lastIndex;
    }

    public void setLastIndex(int lastIndex) {
        this.lastIndex = lastIndex;
    }

    public int getListScale() {
        return listScale;
    }

    public void setListScale(int listScale) {
        this.listScale = listScale;
    }

    public int getPageScale() {
        return pageScale;
    }

    public void setPageScale(int pageScale) {
        this.pageScale = pageScale;
    }

    public String getPagingYn() {
        return pagingYn;
    }

    public void setPagingYn(String pagingYn) {
        this.pagingYn = pagingYn;
    }

    public int getTotalCnt() {
        return totalCnt;
    }

    public void setTotalCnt(int totalCnt) {
        this.totalCnt = totalCnt;
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public List<?> getFileList() {
        return fileList;
    }

    public void setFileList(List<?> fileList) {
        this.fileList = fileList;
    }

    public String getUploadFiles() {
        return uploadFiles;
    }

    public void setUploadFiles(String uploadFiles) {
        this.uploadFiles = uploadFiles;
    }

    public String getSearchKey() {
        return searchKey;
    }

    public void setSearchKey(String searchKey) {
        this.searchKey = searchKey;
    }

    public String getSearchKeyNm() {
        return searchKeyNm;
    }

    public void setSearchKeyNm(String searchKeyNm) {
        this.searchKeyNm = searchKeyNm;
    }

    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getSearchFrom() {
        return searchFrom;
    }

    public void setSearchFrom(String searchFrom) {
        this.searchFrom = searchFrom;
    }

    public String getSearchTo() {
        return searchTo;
    }

    public void setSearchTo(String searchTo) {
        this.searchTo = searchTo;
    }

    public String getSortKey() {
        return sortKey;
    }

    public void setSortKey(String sortKey) {
        this.sortKey = sortKey;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public String getSearchMenu() {
        return searchMenu;
    }

    public void setSearchMenu(String searchMenu) {
        this.searchMenu = searchMenu;
    }

    public String getExcelGrid() {
        return excelGrid;
    }

    public void setExcelGrid(String excelGrid) {
        this.excelGrid = excelGrid;
    }

    public String getFileIds() {
        return fileIds;
    }

    public void setFileIds(String fileIds) {
        this.fileIds = fileIds;
    }

    public String getFileNames() {
        return fileNames;
    }

    public void setFileNames(String fileNames) {
        this.fileNames = fileNames;
    }

    public String getFileSizes() {
        return fileSizes;
    }

    public void setFileSizes(String fileSizes) {
        this.fileSizes = fileSizes;
    }

    public String getUploadPath() {
        return uploadPath;
    }

    public void setUploadPath(String uploadPath) {
        this.uploadPath = uploadPath;
    }

    public int getResult() {
        return result;
    }

    public void setResult(int result) {
        this.result = result;
    }

    public String getGoMcd() {
        return goMcd;
    }

    public void setGoMcd(String goMcd) {
        this.goMcd = goMcd;
    }

    public String getGoUrl() {
        return goUrl;
    }

    public void setGoUrl(String goUrl) {
        this.goUrl = goUrl;
    }

    public String getSubParam() {
        return subParam;
    }

    public void setSubParam(String subParam) {
        this.subParam = subParam;
    }

    public String getTabCd() {
        return tabCd;
    }

    public void setTabCd(String tabCd) {
        this.tabCd = tabCd;
    }

    public String getLoginIp() {
        return loginIp;
    }

    public void setLoginIp(String loginIp) {
        this.loginIp = loginIp;
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

    public String getLineNo() {
        return lineNo;
    }

    public void setLineNo(String lineNo) {
        this.lineNo = lineNo;
    }

    public String getRepoCd() {
        return repoCd;
    }

    public void setRepoCd(String repoCd) {
        this.repoCd = repoCd;
    }

    public String getAudioData() {
        return audioData;
    }

    public void setAudioData(String audioData) {
        this.audioData = audioData;
    }

    public String getAudioFile() {
        return audioFile;
    }

    public void setAudioFile(String audioFile) {
        this.audioFile = audioFile;
    }

    public String[] getDelFileIds() {
        if(delFileIds.length == 0 && StringUtil.isNotNull(delFileIdStr)) {
            delFileIds = delFileIdStr.split(",");
        } else if(delFileIds.length == 1 && StringUtil.isNull(delFileIds[0])) {
            delFileIds = delFileIdStr.split(",");
        }
        return delFileIds;
    }

    public void setDelFileIds(String[] delFileIds) {
        this.delFileIds = delFileIds;
    }

    public String getFileSns() {
        return fileSns;
    }

    public void setFileSns(String fileSns) {
        this.fileSns = fileSns;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getCrsCreNm() {
        return crsCreNm;
    }

    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }

    public String getAuthrtCd() {
        return authrtCd;
    }

    public void setAuthrtCd(String authrtCd) {
        this.authrtCd = authrtCd;
    }

    public String getAuthrtGrpcd() {
        return authrtGrpcd;
    }

    public void setAuthrtGrpcd(String authrtGrpcd) {
        this.authrtGrpcd = authrtGrpcd;
    }

    public String getAuthrtGrpnm() {
        return authrtGrpnm;
    }

    public void setAuthrtGrpnm(String authGrpNm) {
        this.authrtGrpnm = authGrpNm;
    }

    public String getAdminAuthYn() {
        return adminAuthYn;
    }

    public void setAdminAuthYn(String adminAuthYn) {
        this.adminAuthYn = adminAuthYn;
    }

    public String getCopyFiles() {
        return copyFiles;
    }

    public void setCopyFiles(String copyFiles) {
        this.copyFiles = copyFiles;
    }

    public String getSearchSort() {
        return searchSort;
    }

    public void setSearchSort(String searchSort) {
        this.searchSort = searchSort;
    }

    public String[] getSqlForeach() {
        return sqlForeach;
    }

    public void setSqlForeach(String[] sqlForeach) {
        this.sqlForeach = sqlForeach;
    }

    public String[] getSqlForeach2() {
        return sqlForeach2;
    }

    public void setSqlForeach2(String[] sqlForeach2) {
        this.sqlForeach2 = sqlForeach2;
    }

    public String getSearchText() {
        return searchText;
    }

    public void setSearchText(String searchText) {
        this.searchText = searchText;
    }

    public String getPageNumber() {
        return pageNumber;
    }

    public void setPageNumber(String pageNumber) {
        this.pageNumber = pageNumber;
    }

    public String getMoreNumber() {
        return moreNumber;
    }

    public void setMoreNumber(String moreNumber) {
        this.moreNumber = moreNumber;
    }

    public String getSearchMore() {
        return searchMore;
    }

    public void setSearchMore(String searchMore) {
        this.searchMore = searchMore;
    }

    public String getResFlag() {
        return resFlag;
    }

    public void setResFlag(String resFlag) {
        this.resFlag = resFlag;
    }

    public String getMovStrQuery() {
        return movStrQuery;
    }

    public void setMovStrQuery(String movStrQuery) {
        this.movStrQuery = movStrQuery;
    }

    public String getDocStrQuery() {
        return docStrQuery;
    }

    public void setDocStrQuery(String docStrQuery) {
        this.docStrQuery = docStrQuery;
    }

    public String getHtmlStrQuery() {
        return htmlStrQuery;
    }

    public void setHtmlStrQuery(String htmlStrQuery) {
        this.htmlStrQuery = htmlStrQuery;
    }

    public String getEduStrQuery() {
        return eduStrQuery;
    }

    public void setEduStrQuery(String eduStrQuery) {
        this.eduStrQuery = eduStrQuery;
    }

    public String getSearchType() {
        return searchType;
    }

    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    public String getSearchGubun() {
        return searchGubun;
    }

    public void setSearchGubun(String searchGubun) {
        this.searchGubun = searchGubun;
    }

    public String getHy() {
        return hy;
    }

    public void setHy(String hy) {
        this.hy = hy;
    }

    public String getEntrYy() {
        return entrYy;
    }

    public void setEntrYy(String entrYy) {
        this.entrYy = entrYy;
    }

    public String getEntrHy() {
        return entrHy;
    }

    public void setEntrHy(String entrHy) {
        this.entrHy = entrHy;
    }

    public String getEntrGbnNm() {
        return entrGbnNm;
    }

    public void setEntrGbnNm(String entrGbnNm) {
        this.entrGbnNm = entrGbnNm;
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

    public String getDelFileIdStr() {
        return delFileIdStr;
    }

    public void setDelFileIdStr(String delFileIdStr) {
        this.delFileIdStr = delFileIdStr;
    }

    public String getRegIp() {
        return regIp;
    }

    public void setRegIp(String regIp) {
        this.regIp = regIp;
    }

    public String getModIp() {
        return modIp;
    }

    public void setModIp(String modIp) {
        this.modIp = modIp;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserRprsId() {
        return userRprsId;
    }

    public void setUserRprsId(String userRprsId) {
        this.userRprsId = userRprsId;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRgtrnm() {
        return rgtrnm;
    }

    public void setRgtrnm(String rgtrnm) {
        this.rgtrnm = rgtrnm;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getMdfrNm() {
        return mdfrNm;
    }

    public void setMdfrNm(String mdfrNm) {
        this.mdfrNm = mdfrNm;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getOrgNm() {
        return orgNm;
    }

    public void setOrgNm(String orgNm) {
        this.orgNm = orgNm;
    }

	public String getDgrsYr() {
		return dgrsYr;
	}

	public void setDgrsYr(String dgrsYr) {
		this.dgrsYr = dgrsYr;
	}

	public String getDgrsSmstrChrt() {
		return dgrsSmstrChrt;
	}

	public void setDgrsSmstrChrt(String dgrsSmstrChrt) {
		this.dgrsSmstrChrt = dgrsSmstrChrt;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getSbjctOfrngId() {
		return sbjctOfrngId;
	}

	public void setSbjctOfrngId(String sbjctOfrngId) {
		this.sbjctOfrngId = sbjctOfrngId;
	}

	public String getSbjctnm() {
		return sbjctnm;
	}

	public void setSbjctnm(String sbjctnm) {
		this.sbjctnm = sbjctnm;
	}

	public String getSbjctId() {
		return sbjctId;
	}

	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
	}

	public String getGubun() {
		return gubun;
	}

	public void setGubun(String gubun) {
		this.gubun = gubun;
	}

	public int getFileCnt() {
		return fileCnt;
	}

	public void setFileCnt(int fileCnt) {
		this.fileCnt = fileCnt;
	}

	public String getPageType() {
		return pageType;
	}

	public void setPageType(String pageType) {
		this.pageType = pageType;
	}
}