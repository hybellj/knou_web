package knou.framework.common;

import java.lang.reflect.Method;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 페이지 정보
 */
public class PageInfo extends PaginationInfo {
	
    private static Log log = LogFactory.getLog(PageInfo.class);
    
    //	기관
    String	orgId;
    String	orgnm;

    // 학과부서
    String deptId;
    String deptnm;
    
    //	사용자
	String	userId;
	String	usernm;
	String	stdntNo;
	String	rprsId;

	// 	과목
	String	sbjctId;
	String	sbjctnm;
	
	//	학기기수
	String	smstrChrtId;
	String	dgrsYr;
	String	dgrsSmstrChrt;
	String	smstrChrtnm;
	String	yrSmstr; // 연도학기
    String  smstrChrtGbncd; // 학기/기수 구분코드
	
	//	등록일
	String	fromRegDttm; 	//	등록일부터
	String	toRegDttm;		//	등록일까지
	
	String	searchFrom; 	//	등록일부터 	asis 호환을 위해
	String	searchTo;		//	등록일까지	asis 호환을 위해

    String  searchKey;      //	검색어	asis 호환을 위해
	String	searchValue;	//	검색어	asis 호환을 위해
	String	searchText;		// 	검색어 	asis 호환을 위해
	
	// 계륵이 된 경우
	boolean 	isUpCdSelect; 	// 	시스템관리-공통토드관리에서 상위코드 선택 시 - asis 호환을 위해
	boolean 	isUpCdDelete; 	// 	시스템관리-공통토드관리에서 상위코드 선택 시 - asis 호환을 위해 


    String		cdnm; // asis 호환을 위해
	String		upCd; // asis 호환을 위해
	
	/*
	 * 1. 과목에 하위 종속되는 각 단위업무는 PageInfo를 상속받는 class를 생성하여 사용합니다.
	 * 예) asmt > AsmtPageInfo
	 * 
	 * 2. 과목에 하위 종속되지 않는 프로그램들은 기본적으로 PageInfo를 사용합니다.
	 * - 기본 PageInfo를 사용하여 공통으로 사용할 수 없을 경우 새로 생성하고 단톡방에 공지합니다.
	 * 
	 * // 과제 String asmtId; // 시험 String examBscId; // 토론 String dscsId; // 설문
	 * String srvyId; // 퀴즈 String quizid; // 세미나 String smnrId;
	 */
	
	//	pageInfo
	int		firstIndex;
	int		lastIndex;
	int		pageScale;
	int		listScale;
	int		pageIndex;
	int		totalCnt;	
	
    
    public String getYrSmstr() {
		return yrSmstr;
	}

	public void setYrSmstr(String yrSmstr) {

	    this.yrSmstr = yrSmstr;

	    if (yrSmstr != null) {
	        yrSmstr = yrSmstr.trim();

	        if (yrSmstr.length() > 4) {
	            this.dgrsYr = yrSmstr.substring(0, 4);
	            this.dgrsSmstrChrt = yrSmstr.substring(4);
	            return;
	        }
	    }

	    this.dgrsYr = null;
	    this.dgrsSmstrChrt = null;
	}

	public String getUpCd() {
		return upCd;
	}

	public void setUpCd(String upCd) {
		this.upCd = upCd;
	}

	/*
     * 기본생성자
     */
    public PageInfo() {
        setCurrentPageNo(1);       // (구)pageIndex
        setRecordCountPerPage(20); // (구)listScale
        setPageSize(10);           // (구)pageScale
    }
    
    /**
     * 페이지 정보 생성자
     *
     * @param voObj (VO 객체 전달)
     */
    @Deprecated
    public PageInfo(Object voObj) throws Exception {
    	
        super();

        if(voObj != null) {
        	
            Method method = voObj.getClass().getMethod("getPageIndex");
            setCurrentPageNo((Integer) method.invoke(voObj));            
            this.setCurrentPageNo((Integer) method.invoke(voObj));
            this.setPageIndex((Integer) method.invoke(voObj));

            
            method = voObj.getClass().getMethod("getListScale");
            setRecordCountPerPage((Integer) method.invoke(voObj));
            
            if ( 0 >= (Integer) method.invoke(voObj) ) {
            	this.setRecordCountPerPage(10);
            	this.setListScale(10);
            } else {
	            this.setRecordCountPerPage((Integer) method.invoke(voObj));
	            this.setListScale((Integer) method.invoke(voObj));
            }
            
            method = voObj.getClass().getMethod("getPageScale");
            setPageSize((Integer) method.invoke(voObj));            
            this.setPageSize((Integer) method.invoke(voObj));
            this.setPageScale(this.getPageSize());
            

            method = voObj.getClass().getMethod("setFirstIndex", int.class);
            method.invoke(voObj, (Integer) getFirstRecordIndex());            
            this.setFirstIndex((Integer) getFirstRecordIndex());

            
            method = voObj.getClass().getMethod("setLastIndex", int.class);
            method.invoke(voObj, (Integer) getLastRecordIndex());            
            this.setLastIndex((Integer) getLastRecordIndex());
        }
    }

    /**
     * 토탈 레코드 설정
     *
     * @param listObj (List<VO> 객체 전달)
     */
    @Deprecated
    public void setTotalRecord(Object listObj) throws Exception {
       
        if(listObj != null && (listObj instanceof List)) {
            List<?> list = (List<?>) listObj;

            if(!list.isEmpty()) {
                Object obj = list.get(0);

                // EgovMap / Map 처리
                if(obj instanceof java.util.Map) {
                    Object v = ((java.util.Map<?, ?>) obj).get("totalCnt");
                    if(v == null) v = ((java.util.Map<?, ?>) obj).get("TOTAL_CNT");

                    if(v instanceof Number) {
                        setTotalRecordCount(((Number) v).intValue());
                    } else if(v != null) {
                        setTotalRecordCount(Integer.parseInt(String.valueOf(v)));
                    }
                    return;
                }

                // VO 처리
                Method method = obj.getClass().getMethod("getTotalCnt");
                setTotalRecordCount((Integer) method.invoke(obj));
            }
        }
        this.setTotalCnt(getTotalRecordCount());
    }
    
    @Override
    public String toString() {
        return "PaginationInfo {" +
                "currentPageNo=" + getCurrentPageNo() +
                //", recordCountPerPage=" + getRecordCountPerPage() +
                ", pageSize=" + getPageSize() +
                ", totalRecordCount=" + getTotalRecordCount() +
                //", totalPageCount=" + getTotalPageCount() +
                //", firstPageNoOnPageList=" + getFirstPageNoOnPageList() +
                //", lastPageNoOnPageList=" + getLastPageNoOnPageList() +
                ", firstRecordIndex=" + getFirstRecordIndex() +
                ", lastRecordIndex=" + getLastRecordIndex() +
                ", firstIndex=" + getFirstIndex() +
                ", lastIndex=" + getLastIndex() +
                '}';
    }
    
	public boolean isUpCdSelect() {
		return isUpCdSelect;
	}

	public void setUpCdSelect(boolean isUpCdSelect) {
		this.isUpCdSelect = isUpCdSelect;
	}

	public boolean isUpCdDelete() {
		return isUpCdDelete;
	}

	public void setUpCdDelete(boolean isUpCdDelete) {
		this.isUpCdDelete = isUpCdDelete;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getOrgnm() {
		return orgnm;
	}

	public void setOrgnm(String orgnm) {
		this.orgnm = orgnm;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUsernm() {
		return usernm;
	}

	public void setUsernm(String usernm) {
		this.usernm = usernm;
	}

	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

    public String getDeptnm() {
        return deptnm;
    }

    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }

	public String getStdntNo() {
		return stdntNo;
	}

	public void setStdntNo(String stdntNo) {
		this.stdntNo = stdntNo;
	}

	public String getSbjctId() {
		return sbjctId;
	}

	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
	}

	public String getSbjctnm() {
		return sbjctnm;
	}

	public void setSbjctnm(String sbjctnm) {
		this.sbjctnm = sbjctnm;
	}

	public String getSmstrChrtId() {
		return smstrChrtId;
	}

	public void setSmstrChrtId(String smstrChrtId) {
		this.smstrChrtId = smstrChrtId;
	}

	public String getDgrsSmstrChrt() {
		return dgrsSmstrChrt;
	}

	public void setDgrsSmstrChrt(String dgrsSmstrChrt) {
		this.dgrsSmstrChrt = dgrsSmstrChrt;
	}

	public String getDgrsYr() {
		return dgrsYr;
	}

	public void setDgrsYr(String dgrsYr) {
		this.dgrsYr = dgrsYr;
	}

	public String getSmstrChrtnm() {
		return smstrChrtnm;
	}

	public void setSmstrChrtnm(String smstrChrtnm) {
		this.smstrChrtnm = smstrChrtnm;
	}

	public String getFromRegDttm() {
		return fromRegDttm;
	}

	public void setFromRegDttm(String fromRegDttm) {
		this.fromRegDttm = fromRegDttm;
	}

	public String getToRegDttm() {
		return toRegDttm;
	}

	public void setToRegDttm(String toRegDttm) {
		this.toRegDttm = toRegDttm;
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


	public String getRprsId() {
		return rprsId;
	}

	public void setRprsId(String rprsId) {
		this.rprsId = rprsId;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
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

	public int getPageScale() {
		return pageScale;
	}

	public void setPageScale(int pageScale) {
		this.pageScale = pageScale;
	}

	public int getListScale() {
		return listScale;
	}

	public void setListScale(int listScale) {
		this.listScale = listScale;
	}

	public int getPageIndex() {
		return pageIndex;
	}

	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}

	public int getTotalCnt() {
		return totalCnt;
	}
	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}

	public String getSearchText() {
		return searchText;
	}

	public void setSearchText(String searchText) {
		this.searchText = searchText;
	}
	public String getCdnm() {
		return cdnm;
	}
	public void setCdnm(String cdnm) {
		this.cdnm = cdnm;
	}

    public String getSmstrChrtGbncd() {
        return smstrChrtGbncd;
    }

    public void setSmstrChrtGbncd(String smstrChrtGbncd) {
        this.smstrChrtGbncd = smstrChrtGbncd;
    }

    public String getSearchKey() {
        return searchKey;
    }

    public void setSearchKey(String searchKey) {
        this.searchKey = searchKey;
    }
}