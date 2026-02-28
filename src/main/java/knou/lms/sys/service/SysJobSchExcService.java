package knou.lms.sys.service;

import java.util.List;

import knou.lms.sys.vo.SysJobSchExcVO;

public interface SysJobSchExcService {

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
     * TODO 업무일정 예외 삭제
     * @param SysJobSchExcVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(SysJobSchExcVO vo) throws Exception;
    
}
