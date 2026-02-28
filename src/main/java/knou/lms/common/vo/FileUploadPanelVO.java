package knou.lms.common.vo;


/***************************************************
 * <pre>
 *  
 * 업무 그룹명 : 공통 파일 업로드
 * 서부 업무명 : 공통 파일 업로드
 * 설         명 : 공통 파일 업로드 패널 VO
 * 작   성   자 : gilgam
 * 작   성   일 : 2021. 4. 21.
 * Copyright ⓒ MediopiaTec All Right Reserved
 * ======================================
 * 작성자/작성일 : gilgam / 2021. 4. 21.
 * 변경사유/내역 : 최초 작성
 * --------------------------------------
 * 변경자/변경일 :  
 * 변경사유/내역 : 
 * ======================================
 * </pre>
 ***************************************************/

public class FileUploadPanelVO
{

    private String  fileUploadAreaId; // 한 페이지에 파일업로드 영역이 여러개 일 경우 구분하기 위한 아이디
    private String  repoCd;
    private Integer maxCnt;
    private Integer maxSize;          // 파일 한개의 최대 크기
    private Integer limitSize;        // 첨부한 모든 파일의 제한 용량
    private String  bindDataSn;
    private String  files;            // 이미 업로드한 파일목록(json형태의 문자열. 수정화면등에서 사용)
    private String  allowFileExt;
    private String  bbsId;            // 게시판에 파일 첨부하는 경우 게시판 자체의 사이즈 제한 검사하기 위해
    private String  crsCreCd;         // 과목별 용량제한 검사하기 위해
    private String  userOrgId;
    private String  useFileBoxYn;  // 파일 업로드 시 파일함에서 파일을 가져오기 할 지 여부
    private String  userAppendCallback; // 파일 첨부완료 후 호출할 콜백함수명 지정
    private String  userRemoveCallback; // 파일 삭제 후 호출할 콜백함수명 지정
    private String  rgtrId;
    
    public String getRgtrId() {
		return rgtrId;
	}

	public void setRgtrId(String rgtrId) {
		this.rgtrId = rgtrId;
	}

	/**
     * @return userAppendCallback 값을 반환한다.
     */
    public String getUserAppendCallback()
    {
        return userAppendCallback;
    }

    /**
     * @param userAppendCallback 을 userAppendCallback 에 저장한다.
     */
    public void setUserAppendCallback(String userAppendCallback)
    {
        this.userAppendCallback = userAppendCallback;
    }

    /**
     * @return userRemoveCallback 값을 반환한다.
     */
    public String getUserRemoveCallback()
    {
        return userRemoveCallback;
    }

    /**
     * @param userRemoveCallback 을 userRemoveCallback 에 저장한다.
     */
    public void setUserRemoveCallback(String userRemoveCallback)
    {
        this.userRemoveCallback = userRemoveCallback;
    }

    /** @return repoCd 값을 반환한다. */
    public String getRepoCd()
    {
        return repoCd;
    }

    /**
     * @param repoCd
     *            을 repoCd 에 저장한다.
     */
    public void setRepoCd(String repoCd)
    {
        this.repoCd = repoCd;
    }

    /** @return maxCnt 값을 반환한다. */
    public Integer getMaxCnt()
    {
        return maxCnt;
    }

    /**
     * @param maxCnt
     *            을 maxCnt 에 저장한다.
     */
    public void setMaxCnt(Integer maxCnt)
    {
        this.maxCnt = maxCnt;
    }

    /** @return maxSize 값을 반환한다. */
    public Integer getMaxSize()
    {
        return maxSize;
    }

    /**
     * @param maxSize
     *            을 maxSize 에 저장한다.
     */
    public void setMaxSize(Integer maxSize)
    {
        this.maxSize = maxSize;
    }

    /** @return limitSize 값을 반환한다. */
    public Integer getLimitSize()
    {
        return limitSize;
    }

    /**
     * @param limitSize
     *            을 limitSize 에 저장한다.
     */
    public void setLimitSize(Integer limitSize)
    {
        this.limitSize = limitSize;
    }

    /** @return bindDataSn 값을 반환한다. */
    public String getBindDataSn()
    {
        return bindDataSn;
    }

    /**
     * @param bindDataSn
     *            을 bindDataSn 에 저장한다.
     */
    public void setBindDataSn(String bindDataSn)
    {
        this.bindDataSn = bindDataSn;
    }

    /** @return files 값을 반환한다. */
    public String getFiles()
    {
        return files;
    }

    /**
     * @param files
     *            을 files 에 저장한다.
     */
    public void setFiles(String files)
    {
        this.files = files;
    }

    /** @return allowFileExt 값을 반환한다. */
    public String getAllowFileExt()
    {
        return allowFileExt;
    }

    /**
     * @param allowFileExt
     *            을 allowFileExt 에 저장한다.
     */
    public void setAllowFileExt(String allowFileExt)
    {
        this.allowFileExt = allowFileExt;
    }

    /** @return bbsId 값을 반환한다. */
    public String getBbsId()
    {
        return bbsId;
    }

    /**
     * @param bbsId
     *            을 bbsId 에 저장한다.
     */
    public void setBbsId(String bbsId)
    {
        this.bbsId = bbsId;
    }

    /** @return crsCreCd 값을 반환한다. */
    public String getCrsCreCd()
    {
        return crsCreCd;
    }

    /**
     * @param crsCreCd
     *            을 crsCreCd 에 저장한다.
     */
    public void setCrsCreCd(String crsCreCd)
    {
        this.crsCreCd = crsCreCd;
    }

    /** @return userOrgId 값을 반환한다. */
    public String getUserOrgId()
    {
        return userOrgId;
    }

    /**
     * @param userOrgId
     *            을 userOrgId 에 저장한다.
     */
    public void setUserOrgId(String userOrgId)
    {
        this.userOrgId = userOrgId;
    }

    /** @return fileUploadAreaId 값을 반환한다. */
    public String getFileUploadAreaId()
    {
        return fileUploadAreaId;
    }

    /**
     * @param fileUploadAreaId
     *            을 fileUploadAreaId 에 저장한다.
     */
    public void setFileUploadAreaId(String fileUploadAreaId)
    {
        this.fileUploadAreaId = fileUploadAreaId;
    }

    /** @return useFileBoxYn 값을 반환한다. */
    public String getUseFileBoxYn()
    {
        return useFileBoxYn;
    }

    /**
     * @param useFileBoxYn
     *            을 useFileBoxYn 에 저장한다.
     */
    public void setUseFileBoxYn(String useFileBoxYn)
    {
        this.useFileBoxYn = useFileBoxYn;
    }
}
