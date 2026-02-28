package knou.lms.lesson.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.lesson.vo.LessonProgVO;

public interface LessonProgService {
	
	/*****************************************************
     * 학습진도관리 전체/운영과목 현황
     * @param LessonProgVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public EgovMap LrnPrgrtStatusSelect(LessonProgVO vo) throws Exception;
    
    /*****************************************************
     * 학습진도관리 > 학과별 전체통계 목록 조회
     * @param LessonProgVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> ListLrnPrgrtStatusByDept(LessonProgVO vo) throws Exception;
    
    /*****************************************************
     * 과목명 목록 조회
     * @param LessonProgVO
     * @return 
     * @throws Exception
     ******************************************************/
    public List<LessonProgVO> selectCrsCreList(LessonProgVO vo) throws Exception; 
    
}
