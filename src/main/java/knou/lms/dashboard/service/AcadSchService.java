package knou.lms.dashboard.service;

import knou.lms.dashboard.vo.AcadSchVO;

public interface AcadSchService {

    /*****************************************************
     * TODO 일정 관리 조회
     * @param AcadSchVO
     * @return AcadSchVO
     * @throws Exception
     ******************************************************/
    public AcadSchVO select(AcadSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 일정 관리 등록
     * @param AcadSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(AcadSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 일정 관리 수정
     * @param AcadSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(AcadSchVO vo) throws Exception;
    
    /*****************************************************
     * TODO 일정 관리 삭제
     * @param AcadSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(AcadSchVO vo) throws Exception;
    
}
