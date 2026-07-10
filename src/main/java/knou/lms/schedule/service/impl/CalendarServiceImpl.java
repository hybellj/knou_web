package knou.lms.schedule.service.impl;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;
import javax.validation.Valid;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.CalendarDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.schedule.dao.CalendarDAO;
import knou.lms.schedule.service.CalendarService;
import knou.lms.schedule.vo.CalendarVO;
import knou.lms.schedule.vo.ClassScheduleVO;
import knou.lms.schedule.vo.OrgTaskScheduleVO;

@Service("calendarService")
public class CalendarServiceImpl implements CalendarService {

	@Resource(name = "calendarDAO")
	private CalendarDAO calendarDAO;
	
	// 캘린더 정보 조회
	@Override
	public ProcessResultVO<CalendarVO> listCalendar(CalendarVO vo) throws Exception {
		ProcessResultVO<CalendarVO> resultVO = new ProcessResultVO<CalendarVO>();
		try {
			List<CalendarVO> schList = calendarDAO.listCalendar(vo);
			resultVO.setResult(1);
			resultVO.setReturnList(schList);
		} catch(Exception e) {
			e.printStackTrace();
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		}

		return resultVO;
	}

	// 일정 조회
	@Override
	public ProcessResultVO<CalendarVO> listSchedule(CalendarVO vo) throws Exception {
		ProcessResultVO<CalendarVO> returnVO = new ProcessResultVO<CalendarVO>();
		try {
			vo.setPagingYn("N");
			List<CalendarVO> schList = calendarDAO.listSchedule(vo);
			returnVO.setResult(1);
			returnVO.setReturnList(schList);
		} catch (Exception e) {
			e.printStackTrace();
			returnVO.setResult(-1);
			returnVO.setMessage(e.getMessage());
		}
		return returnVO;
	}

	// 수업일정 페이징 조회
    @Override
    public ProcessResultVO<CalendarVO> listPaging(CalendarVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<CalendarVO> schList = calendarDAO.listPaging(vo);

        if(schList.size() > 0) {
            paginationInfo.setTotalRecordCount(schList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<CalendarVO> resultVO = new ProcessResultVO<CalendarVO>();

        resultVO.setReturnList(schList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 기관업무일정 조회
     * @param orgId
     * @param taskSchdlTycd
     * @return
     */
    @Override
    public OrgTaskScheduleVO orgTaskSchdlSelect(String orgId, String taskSchdlTycd) {

        return calendarDAO.orgTaskSchdlSelect(orgId, taskSchdlTycd);
    }

	@Override
	public List<EgovMap> myScheduleList(UserContext userCtx, CalendarDTO calDto) {
		if ( userCtx.isProfessor())
			return calendarDAO.profMySchduleList(calDto);
		
		if ( userCtx.isStudent())
			return calendarDAO.stdntMySchduleList(calDto);
	
		return Collections.emptyList();
	}

	@Override
	public int profClassScheduleDelete(ClassScheduleVO classScheduleVO) {
		return calendarDAO.profClassScheduleDelete(classScheduleVO);
	}

	@Override
	public int profClassScheduleRegist(@Valid ClassScheduleVO classScheduleVO) {
		return calendarDAO.profClassScheduleRegist(classScheduleVO);
	}

	@Override
	public int profClassScheduleModify(@Valid ClassScheduleVO classScheduleVO) {
		return calendarDAO.profClassScheduleModify(classScheduleVO);
	}
}
