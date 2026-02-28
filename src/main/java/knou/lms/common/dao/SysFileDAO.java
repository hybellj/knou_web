package knou.lms.common.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.framework.vo.FileVO;

@Mapper("sysFileDAO")
public interface SysFileDAO {

    /*****************************************************
     * 파일 전체 목록
     * @param FileVO
     * @return List<FileVO>
     * @throws Exception
     ******************************************************/
    public List<FileVO> list(FileVO vo) throws Exception;
    
    /*****************************************************
     * 파일 전체 목록 페이징
     * @param FileVO
     * @return List<FileVO>
     * @throws Exception
     ******************************************************/
    public List<FileVO> listPageing(FileVO vo) throws Exception;
    
    /*****************************************************
     * 파일 전체 목록 카운트
     * @param FileVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int count(FileVO vo) throws Exception;
    
    /*****************************************************
     * 파일 정보 조회
     * @param FileVO
     * @return FileVO
     * @throws Exception
     ******************************************************/
    public FileVO select(FileVO vo) throws Exception;
    
    /*****************************************************
     * 파일 키 생성
     * @param FileVO
     * @return int
     * @throws Exception
     ******************************************************/
    public String selectKey() throws Exception;
    
    /*****************************************************
     * 파일 정보 등록
     * @param FileVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(FileVO vo) throws Exception;
    
    /*****************************************************
     * 파일 바인딩 정보 수정
     * @param FileVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateFileBindData(FileVO vo) throws Exception;
    
    /*****************************************************
     * 파일 바인딩 정보 삭제
     * @param FileVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteFileBindData(FileVO vo) throws Exception;
    
    /*****************************************************
     * 파일 정보 삭제
     * @param FileVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(FileVO vo) throws Exception;
    
    /*****************************************************
     * 시스템 파일 조회에 따른 마지막 접속일시와 조회수 증가 업데이트
     * @param FileVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateFileLastInqDttm(FileVO vo) throws Exception;
    
    /*****************************************************
     * 업무에서 사용하지 않은 쓰레기 파일 목록 조회
     * @param FileVO
     * @return List<FileVO>
     * @throws Exception
     ******************************************************/
    public List<FileVO> listGarbageFile(FileVO vo) throws Exception;
    
    /*****************************************************
     * 원본 파일정보 복사
     * @param FileVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void copyFileInfoFromOrigin(FileVO vo) throws Exception;
    
    /*****************************************************
     * 오브젝트 스토리지 경로 정보 수정
     * @param FileVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateObjectStorageInfo(FileVO vo) throws Exception;

}
