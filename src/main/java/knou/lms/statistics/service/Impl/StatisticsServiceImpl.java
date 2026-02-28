package knou.lms.statistics.service.Impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.statistics.dao.StatisticsDAO;
import knou.lms.statistics.service.StatisticsService;
import knou.lms.statistics.vo.StatisticsVO;
import knou.lms.subject2.vo.SubjectVO;

@Service("statisticsService")
public class StatisticsServiceImpl implements StatisticsService {
    
    @Resource(name="statisticsDAO")
    private StatisticsDAO statisticsDAO;
    
    /*****************************************************
     * 학습진도관리 전체/운영과목 현황 조회
     * @param SubjectVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public EgovMap stdntlrnPrgrtStatusSelect(SubjectVO vo) throws Exception {
    	return statisticsDAO.stdntlrnPrgrtStatusSelect(vo);
    }
    
    /*****************************************************
     * 학습자 학습진도 현황 목록 조회
     * @param SubjectVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> stdntLrnPrgrtList(SubjectVO vo) throws Exception {
        //resultVO.setReturnVO(lessonDAO.selectLessonProgress(vo));
        return statisticsDAO.stdntLrnPrgrtList(vo);
    }
    
    /*****************************************************
     * 학습진도관리 > 학과별 전체통계 목록 조회
     * @param SubjectVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
	@Override
	public List<EgovMap> listLrnPrgrtStatusByDept(SubjectVO vo) throws Exception {
		return statisticsDAO.listLrnPrgrtStatusByDept(vo);
	}
	
	
	
	
	
	
	
	
	
    
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