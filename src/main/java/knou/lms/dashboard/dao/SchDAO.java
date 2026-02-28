package knou.lms.dashboard.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.dashboard.vo.SchVO;

@Mapper("schDAO")
public interface SchDAO {

    /*****************************************************
     * 캘린더 정보 조회
     * @param SchVO
     * @return List<SchVO>
     * @throws Exception
     ******************************************************/
    public List<SchVO> listCalendar(SchVO vo) throws Exception;
    
    /*****************************************************
     * 일정 조회
     * @param SchVO
     * @return List<SchVO>
     * @throws Exception
     ******************************************************/
    public List<SchVO> listSchedule(SchVO vo) throws Exception;
    public List<SchVO> stuListSchedule(SchVO vo) throws Exception;
    public List<SchVO> profListSchedule(SchVO vo) throws Exception;
    public List<SchVO> listAcadSch(SchVO vo) throws Exception;
}
