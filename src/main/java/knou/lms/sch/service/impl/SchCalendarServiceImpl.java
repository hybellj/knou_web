package knou.lms.sch.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.sch.dao.SchCalendarDAO;
import knou.lms.sch.service.SchCalendarService;
import knou.lms.sch.vo.SchCalendarVO;

@Service("schCalendarService")
public class SchCalendarServiceImpl implements SchCalendarService {

	@Resource(name = "schCalendarDAO")
	private SchCalendarDAO schCalendarDAO;
	
	// 캘린더 정보 조회
	@Override
	public ProcessResultVO<SchCalendarVO> listCalendar(SchCalendarVO vo) throws Exception {
		ProcessResultVO<SchCalendarVO> resultVO = new ProcessResultVO<SchCalendarVO>();
		try {
			List<SchCalendarVO> schList = schCalendarDAO.listCalendar(vo);
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
	public ProcessResultVO<SchCalendarVO> listSchedule(SchCalendarVO vo) throws Exception {
		ProcessResultVO<SchCalendarVO> returnVO = new ProcessResultVO<SchCalendarVO>();
		try {
			vo.setPagingYn("N");
			List<SchCalendarVO> schList = schCalendarDAO.listSchedule(vo);
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
    public ProcessResultVO<SchCalendarVO> listPaging(SchCalendarVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<SchCalendarVO> schList = schCalendarDAO.listPaging(vo);

        if(schList.size() > 0) {
            paginationInfo.setTotalRecordCount(schList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<SchCalendarVO> resultVO = new ProcessResultVO<SchCalendarVO>();

        resultVO.setReturnList(schList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

}
