package knou.lms.dashboard.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.dashboard.vo.SchVO;

public interface SchService {
    
    /*****************************************************
     * 캘린더 정보 조회
     * @param SchVO
     * @return ProcessResultVO<SchVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<SchVO> listCalendar(SchVO vo) throws Exception;
    
    /*****************************************************
     * 일정 조회
     * @param SchVO
     * @return ProcessResultVO<SchVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<SchVO> listSchedule(SchVO vo) throws Exception;
    public ProcessResultVO<SchVO> stuListSchedule(SchVO vo) throws Exception;
    public ProcessResultVO<SchVO> profListSchedule(SchVO vo) throws Exception;
    public ProcessResultVO<SchVO> listAcadSch(SchVO vo) throws Exception;
}
