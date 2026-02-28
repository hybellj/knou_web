package knou.lms.file.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.vo.FileVO;
import knou.lms.common.vo.FilePathInfoVO;
import knou.lms.file.vo.FileBoxInfoVO;

@Mapper("fileBoxInfoDAO")
public interface FileBoxInfoDAO
{
    /***************************************************** 
     * 파일함 트리 조회.
     * @param vo
     * @return List<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/
    public List<FileBoxInfoVO> listFileBoxTree(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 선택한 폴더 내의 파일 리스트를 조회한다.
     * @param vo
     * @return List<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/
    public List<FileBoxInfoVO> listFileBox(FileBoxInfoVO vo) throws Exception;
    public List<FileBoxInfoVO> listNoFileSnBox(FileBoxInfoVO vo) throws Exception;

    /***************************************************** 
     * 자신의 파일함 사용률 조회
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public FileBoxInfoVO selectFileBoxUseRate(FileBoxInfoVO vo) throws Exception;

    /***************************************************** 
     * 폴더생성
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insertFileBox(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일함 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteFileBox(FileBoxInfoVO vo) throws Exception;

    /***************************************************** 
     * 삭제할 파일박스 목록 조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public List<FileBoxInfoVO> listDeleteFileBox(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 삭제할 파일목록 조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public List<FilePathInfoVO> listDeleteFile(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일 또는 폴더 상세정보 조회
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public FileBoxInfoVO selectFileBoxDetailInfo(FileBoxInfoVO vo) throws Exception;

    /***************************************************** 
     * 선택한 폴더의 full 경로 조회
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    public List<String> listFullFolderPath(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일함의 폴더명 변경
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateFileBoxNm(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일함의 간단 정보 조회
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public FileBoxInfoVO selectFileBoxSimpleInfo(FileBoxInfoVO vo) throws Exception;

    /***************************************************** 
     * 시스템 파일함의 파일명 변경
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateSysFileNm(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 자신의 파일함 여부 카운트
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countUserFileBoxCd(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 자신의 파일함 파일정보 목록
     * @param vo
     * @return List<FileVO>
     * @throws Exception
     ******************************************************/
    public List<FileVO> listFileBoxFileInfo(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일박스 폴더 정보 가져오기
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public FileBoxInfoVO selectFileBox(FileBoxInfoVO vo) throws Exception; 

}