package knou.lms.statistics.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.statistics.vo.StatisticsVO;
import knou.lms.subject2.vo.SubjectVO;

@Mapper("statisticsDAO")
public interface StatisticsDAO {
	
	/*****************************************************
     * 전체/운영과목 학습진도 현황(수강생수, 평균학습진도율)
     * @param SubjectVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public EgovMap stdntlrnPrgrtStatusSelect(SubjectVO vo) throws Exception;
    
    /*****************************************************
     * 학습자 학습진도 현황 목록 조회
     * @param SubjectVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> stdntLrnPrgrtList(SubjectVO vo) throws Exception;
    
    /*****************************************************
     * 학습진도관리 > 학과별 학습진도율 목록 조회
     * @param SubjectVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLrnPrgrtStatusByDept(SubjectVO vo) throws Exception;
    
    
    
    
    
    
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