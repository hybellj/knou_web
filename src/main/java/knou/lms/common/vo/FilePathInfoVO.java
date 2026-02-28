package knou.lms.common.vo;




/***************************************************
 * <pre>
 *  
 * 업무 그룹명 : 파일함
 * 서부 업무명 : 파일함
 * 설         명 : 삭제할 파일의 경로 및 파일명 VO
 * 작   성   자 : gilgam
 * 작   성   일 : 2021. 4. 14.
 * Copyright ⓒ MediopiaTec All Right Reserved
 * ======================================
 * 작성자/작성일 : gilgam / 2021. 4. 14.
 * 변경사유/내역 : 최초 작성
 * --------------------------------------
 * 변경자/변경일 :  
 * 변경사유/내역 : 
 * ======================================
 * </pre>
 ***************************************************/

public class FilePathInfoVO extends DefaultVO
{
    private static final long serialVersionUID = -1713444079170527668L;
    
    private String fileSn;
    private String  repoPath;
    private String  filePath;
    private String  fileSaveNm;

    /** @return fileSn 값을 반환한다. */
    public String getFileSn()
    {
        return fileSn;
    }

    /**
     * @param fileSn
     *            을 fileSn 에 저장한다.
     */
    public void setFileSn(String fileSn)
    {
        this.fileSn = fileSn;
    }

    /** @return repoPath 값을 반환한다. */
    public String getRepoPath()
    {
        return repoPath;
    }

    /**
     * @param repoPath
     *            을 repoPath 에 저장한다.
     */
    public void setRepoPath(String repoPath)
    {
        this.repoPath = repoPath;
    }

    /** @return filePath 값을 반환한다. */
    public String getFilePath()
    {
        return filePath;
    }

    /**
     * @param filePath
     *            을 filePath 에 저장한다.
     */
    public void setFilePath(String filePath)
    {
        this.filePath = filePath;
    }

    /** @return fileSaveNm 값을 반환한다. */
    public String getFileSaveNm()
    {
        return fileSaveNm;
    }

    /**
     * @param fileSaveNm
     *            을 fileSaveNm 에 저장한다.
     */
    public void setFileSaveNm(String fileSaveNm)
    {
        this.fileSaveNm = fileSaveNm;
    }

}
