package knou.lms.statistics.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.statistics.vo.StatisticsVO;
import knou.lms.subject2.vo.SubjectVO;

public interface StatisticsService {
	
    public EgovMap stdntlrnPrgrtStatusSelect(SubjectVO vo) throws Exception;

    public List<EgovMap> stdntLrnPrgrtList(SubjectVO vo) throws Exception;
    
    public List<EgovMap> listLrnPrgrtStatusByDept(SubjectVO vo) throws Exception;
    
    
    
    
    
    
    
    
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/
    public ProcessResultVO<StatisticsVO> listContentStatisticsAll(StatisticsVO vo) throws Exception;
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 주차별 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/   
    public ProcessResultVO<StatisticsVO> listContentStatisticsByWeek(StatisticsVO vo) throws Exception;
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 과목별 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/  
    public ProcessResultVO<StatisticsVO> listContentStatisticsByCourse(StatisticsVO vo) throws Exception;

}