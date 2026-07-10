package knou.lms.statistics.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.statistics.vo.StatisticsVO;
import knou.lms.subject.vo.SubjectVO;

@Mapper("statisticsDAO")
public interface StatisticsDAO {
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 전체 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/
    public List<StatisticsVO> listContentStatisticsAll(StatisticsVO vo);
    public int countContentStatisticsAll(StatisticsVO vo);
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 주차별 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/
    public List<StatisticsVO> listContentStatisticsByWeek(StatisticsVO vo) throws Exception;
    public int countContentStatisticsByWeek(StatisticsVO vo) throws Exception; 
    
    /**
     * ***************************************************
     * 학습자별 콘텐츠 수강통계 과목별 목록
     * @param StatisticsVO
     * @return StatisticsVO
     * @throws Exception
     *****************************************************
     **/
    public List<StatisticsVO> listContentStatisticsByCourse(StatisticsVO vo) throws Exception;
    public int countContentStatisticsByCourse(StatisticsVO vo) throws Exception;

}