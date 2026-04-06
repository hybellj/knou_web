package knou.lms.sch.dao;

import java.util.List;

import knou.lms.sch.vo.OrgTaskScheduleVO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.sch.vo.SchCalendarVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("schCalendarDAO")
public interface SchCalendarDAO {

	// 캘린더 정보 조회
	List<SchCalendarVO> listCalendar(SchCalendarVO vo) throws Exception;
	
	// 일정 조회
	List<SchCalendarVO> listSchedule(SchCalendarVO vo) throws Exception;
	
	// 수업일정 페이징 조회
	List<SchCalendarVO> listPaging(SchCalendarVO vo) throws Exception;

    // 기관업무일정 조회
    public OrgTaskScheduleVO orgTaskSchdlSelect(@Param("orgId")String orgId, @Param("taskSchdlTycd")String taskSchdlTycd);

}
