package knou.lms.statistics.service.Impl;

import java.util.List;

import javax.annotation.Resource;

import knou.framework.common.PageInfo;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.statistics.dao.StatisticsDAO;
import knou.lms.statistics.service.StatisticsService;
import knou.lms.statistics.vo.StatisticsVO;
import knou.lms.subject.vo.SubjectVO;

@Service("statisticsService")
public class StatisticsServiceImpl implements StatisticsService {
    
    @Resource(name="statisticsDAO")
    private StatisticsDAO statisticsDAO;
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 전체 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/
    public ProcessResultVO<StatisticsVO> listContentStatisticsAll(StatisticsVO vo) throws Exception {
        ProcessResultVO<StatisticsVO> processResultVO = new ProcessResultVO<>();
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totalCount = statisticsDAO.countContentStatisticsAll(vo);
        
        paginationInfo.setTotalRecordCount(totalCount);
        
        List<StatisticsVO> resultList = statisticsDAO.listContentStatisticsAll(vo); 
       
        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);
        
        return processResultVO;
    }
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 주차별 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/
    public ProcessResultVO<StatisticsVO> listContentStatisticsByWeek(StatisticsVO vo) throws Exception {
        ProcessResultVO<StatisticsVO> processResultVO = new ProcessResultVO<>();
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totalCount = statisticsDAO.countContentStatisticsByWeek(vo);
        
        paginationInfo.setTotalRecordCount(totalCount);
        
        List<StatisticsVO> resultList = statisticsDAO.listContentStatisticsByWeek(vo); 
       
        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);
        
        return processResultVO;
    }
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 과목별 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/
    public ProcessResultVO<StatisticsVO> listContentStatisticsByCourse(StatisticsVO vo) throws Exception {
        ProcessResultVO<StatisticsVO> processResultVO = new ProcessResultVO<>();
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totalCount = statisticsDAO.countContentStatisticsByCourse(vo);
        
        paginationInfo.setTotalRecordCount(totalCount);
        
        List<StatisticsVO> resultList = statisticsDAO.listContentStatisticsByCourse(vo); 
       
        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);
        
        return processResultVO;
    }
    
}