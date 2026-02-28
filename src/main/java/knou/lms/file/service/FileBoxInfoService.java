package knou.lms.file.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.vo.FileVO;
import knou.lms.file.vo.FileBoxInfoVO;

public interface FileBoxInfoService {

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
     *선택한 폴더의 full경로를 조회한다(최상위 폴더에서 자신의 폴더까지 경로).
     * @param vo
     * @return List<String>
     * @throws Exception
     ******************************************************/ 
    public List<String> getFullFolderPath(FileBoxInfoVO vo) throws Exception;

    
    /***************************************************** 
     * 자신의 파일함 남은 용량 조회
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public long selectFileBoxUnusedByte(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 폴더생성
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public FileBoxInfoVO createFolder(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일함내의 폴더 또는 파일 삭제처리
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteFileBox(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일 또는 폴더 상세정보 조회
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public FileBoxInfoVO getFileBoxDetailInfo(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 선택한 폴더의 full 경로 조회
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    public List<String> listFullFolderPath(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일함 이름 변경
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateFileBoxNm(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일함에 추가
     * @param vo
     * @throws Exception
     ******************************************************/
    public void addFileBox(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일함에 파일 추가
     * @param vo
     * @throws Exception
     ******************************************************/
    public void addFileToFileBox(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 강의컨텐츠 파일박스 저장 폴더명 가져오기
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    public String getLessonCntsFolderNm(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 자신의 파일함 파일정보 목록
     * @param vo
     * @return List<FileVO>
     * @throws Exception
     ******************************************************/
    public List<FileVO> listFileBoxFileInfo(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 자신의 파일함 여부 카운트
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countUserFileBoxCd(FileBoxInfoVO vo) throws Exception;
    
    /***************************************************** 
     * 파일박스 폴더 정보 가져오기
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public FileBoxInfoVO selectFileBox(FileBoxInfoVO vo) throws Exception;
}
