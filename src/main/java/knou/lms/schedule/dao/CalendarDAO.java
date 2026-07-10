package knou.lms.schedule.dao;

import java.util.List;

import javax.validation.Valid;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.CalendarDTO;
import knou.lms.schedule.vo.CalendarVO;
import knou.lms.schedule.vo.ClassScheduleVO;
import knou.lms.schedule.vo.OrgTaskScheduleVO;

@Mapper("calendarDAO")
public interface CalendarDAO {

	// 캘린더 정보 조회
	List<CalendarVO> listCalendar(CalendarVO vo) throws Exception;
	
	// 일정 조회
	List<CalendarVO> listSchedule(CalendarVO vo) throws Exception;
	
	// 수업일정 페이징 조회
	List<CalendarVO> listPaging(CalendarVO vo) throws Exception;

    // 기관업무일정 조회
    public OrgTaskScheduleVO orgTaskSchdlSelect(@Param("orgId")String orgId, @Param("taskSchdlTycd")String taskSchdlTycd);

	List<EgovMap> profMySchduleList(CalendarDTO calDto);

	List<EgovMap> stdntMySchduleList(CalendarDTO calDto);

	int profClassScheduleDelete(ClassScheduleVO classScheduleVO);

	int profClassScheduleRegist(@Valid ClassScheduleVO classScheduleVO);

	int profClassScheduleModify(@Valid ClassScheduleVO classScheduleVO);

}