package knou.lms.common.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.SysFileRepoVO;

@Mapper("sysFileRepoDAO")
public interface SysFileRepoDAO {

    /*****************************************************
     * TODO 파일 리파지토리 전체 목록
     * @param SysFileRepoVO
     * @return List<SysFileRepoVO>
     * @throws Exception
     ******************************************************/
    public List<SysFileRepoVO> list(SysFileRepoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 파일 리파지토리 전체 목록 페이징
     * @param SysFileRepoVO
     * @return List<SysFileRepoVO>
     * @throws Exception
     ******************************************************/
    public List<SysFileRepoVO> listPageing(SysFileRepoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 파일 리파지토리 전체 목록 개수
     * @param SysFileRepoVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int count(SysFileRepoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 파일 리파지토리의 정보 조회
     * @param SysFileRepoVO
     * @return SysFileRepoVO
     * @throws Exception
     ******************************************************/
    public SysFileRepoVO select(SysFileRepoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 파일 리파지토리의 정보 등록
     * @param SysFileRepoVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(SysFileRepoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 파일 리파지토리의 정보 수정
     * @param SysFileRepoVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(SysFileRepoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 파일 리파지토리의 정보 삭제
     * @param SysFileRepoVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(SysFileRepoVO vo) throws Exception;
    
}
