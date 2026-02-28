package knou.lms.common.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import knou.framework.vo.FileVO;
import knou.lms.common.vo.ProcessResultVO;

public interface SysFileService {

    public FileVO addFile(FileVO vo) throws Exception;

    public FileVO getFile(FileVO vo, boolean updateEnabled) throws Exception;

    public FileVO getFile(FileVO vo) throws Exception;

    public ProcessResultVO<FileVO> list(FileVO vo) throws Exception;

    public void removeFile(FileVO vo) throws Exception;

    public void removeFile(String fileSn) throws Exception;

    public FileVO copyFile(FileVO vo) throws Exception;

    public FileVO insertFileInfo(FileVO vo) throws Exception;

    public void zipFileDown(String fileDownNm, List<FileVO> list, HttpServletRequest request, HttpServletResponse response) throws Exception;

    public void copyFileInfoFromOrigin(FileVO vo) throws Exception;

    public int convertToHtmlViewerFile(FileVO vo) throws Exception;

    public void convertToHtmlViewerFileList(List<FileVO> list) throws Exception;

    public void removeConvertFile(FileVO vo) throws Exception;
}
