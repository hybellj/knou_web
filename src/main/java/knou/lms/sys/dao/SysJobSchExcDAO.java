package knou.lms.sys.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.sys.vo.SysJobSchExcVO;

@Mapper("sysJobSchExcDAO")
public interface SysJobSchExcDAO {

    /*****************************************************
     * TODO 업무일정 예외 조회
     * @param SysJobSchExcVO
     * @return SysJobSchExcVO
     * @throws Exception
     ******************************************************/
    public SysJobSchExcVO select(SysJobSchExcVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 예외 목록 조회
     * @param SysJobSchExcVO
     * @return List<SysJobSchExcVO>
     * @throws Exception
     ******************************************************/
    public List<SysJobSchExcVO> list(SysJobSchExcVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 예외 등록
     * @param SysJobSchExcVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(SysJobSchExcVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 예외 삭제
     * @param SysJobSchExcVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(SysJobSchExcVO vo) throws Exception;
    
}
