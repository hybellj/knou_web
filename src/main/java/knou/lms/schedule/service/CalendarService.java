package knou.lms.schedule.service;

import java.util.List;

import javax.validation.Valid;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.CalendarDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.schedule.vo.OrgTaskScheduleVO;
import knou.lms.schedule.vo.CalendarVO;
import knou.lms.schedule.vo.ClassScheduleVO;

public interface CalendarService {

	// 캘린더 정보 조회
	ProcessResultVO<CalendarVO> listCalendar(CalendarVO vo) throws Exception;

	// 일정 조회
	ProcessResultVO<CalendarVO> listSchedule(CalendarVO vo) throws Exception;
	
	// 수업일정 페이징 조회
	ProcessResultVO<CalendarVO> listPaging(CalendarVO vo) throws Exception;

    // 기관업무일정 조회
    OrgTaskScheduleVO orgTaskSchdlSelect(String orgId, String taskSchdlTycd);    

	List<EgovMap> myScheduleList(UserContext userCtx, CalendarDTO calDto);

	int profClassScheduleDelete(ClassScheduleVO classScheduleVO);

	int profClassScheduleRegist(@Valid ClassScheduleVO classScheduleVO);

	int profClassScheduleModify(@Valid ClassScheduleVO classScheduleVO);
}
