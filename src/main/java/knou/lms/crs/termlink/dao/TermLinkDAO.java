package knou.lms.crs.termlink.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.crs.termlink.vo.TermLinkVO;

@Mapper("termLinkDAO")
public interface TermLinkDAO {

    // 소속 정보 연동
    @SuppressWarnings("linkDepartmentProc")
    public void linkDepartmentProc(TermLinkVO vo) throws Exception;
    
    // 사용자(학습자/교수자/기타사용자) 정보 연동
    @SuppressWarnings("linkUserProc")
    public void linkUserProc(TermLinkVO vo) throws Exception;
    
    // 운영 과목 정보 연동
    @SuppressWarnings("linkCourseProc")
    public void linkCourseProc(TermLinkVO vo) throws Exception;
    
    // 과목 운영자 정보 연동
    @SuppressWarnings("linkCourseProfessorProc")
    public void linkCourseProfessorProc(TermLinkVO vo) throws Exception;
    
    // 과목 수강생 정보 연동
    @SuppressWarnings("linklearnerProc")
    public void linklearnerProc(TermLinkVO vo) throws Exception;
    
    // 강의계획서 정보 연동
    @SuppressWarnings("linkLessonPlanProc")
    public void linkLessonPlanProc(TermLinkVO vo) throws Exception;
    
    // 평가비율 정보 연동
    @SuppressWarnings("linkCourseScoreProc")
    public void linkCourseScoreProc(TermLinkVO vo) throws Exception;
    
    // 주차별 강의 정보 연동
    @SuppressWarnings("linkLessonScheduleProc")
    public void linkLessonScheduleProc(TermLinkVO vo) throws Exception;
    
}
