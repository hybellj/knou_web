package knou.lms.sch.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.sch.vo.SchCalendarVO;

public interface SchCalendarService {

	// 캘린더 정보 조회
	ProcessResultVO<SchCalendarVO> listCalendar(SchCalendarVO vo) throws Exception;

	// 일정 조회
	ProcessResultVO<SchCalendarVO> listSchedule(SchCalendarVO vo) throws Exception;
	
	// 수업일정 페이징 조회
	ProcessResultVO<SchCalendarVO> listPaging(SchCalendarVO vo) throws Exception;

}
