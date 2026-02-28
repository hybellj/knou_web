package knou.lms.sys.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.sys.vo.SysJobSchVO;

public interface SysJobSchService {

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
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<SysJobSchVO> listPaging(SysJobSchVO vo) throws Exception;
    
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
    
    /*****************************************************
     * TODO ERP 업무일정 연동
     * @param SysJobSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void getEepLink(SysJobSchVO vo) throws Exception;

}
