package knou.lms.sys.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.sys.vo.SysJobSchVO;

@Mapper("sysJobSchDAO")
public interface SysJobSchDAO {
    
    /*****************************************************
     * TODO 업무일정 조회
     * @param SysJobSchVO
     * @return SysJobSchVO
     * @throws Exception
     ******************************************************/
    public SysJobSchVO select(SysJobSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 목록 조회
     * @param SysJobSchVO
     * @return List<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    public List<SysJobSchVO> list(SysJobSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 목록 조회 페이징
     * @param SysJobSchVO
     * @return List<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    public List<SysJobSchVO> listPaging(SysJobSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 등록
     * @param SysJobSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(SysJobSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 수정
     * @param SysJobSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(SysJobSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 삭제
     * @param SysJobSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(SysJobSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 마지막 종료일시 정보 조회
     * @param SysJobSchVO
     * @return SysJobSchVO
     * @throws Exception
     ******************************************************/
    public SysJobSchVO selectByEndDt(SysJobSchVO vo) throws Exception;

}
