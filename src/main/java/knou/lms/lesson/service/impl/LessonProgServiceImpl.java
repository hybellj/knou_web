package knou.lms.lesson.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.lesson.dao.LessonProgDAO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.dao.LessonStudyDAO;
import knou.lms.lesson.service.LessonProgService;
import knou.lms.lesson.vo.LessonProgVO;

@Service("lessonProgService")
public class LessonProgServiceImpl extends ServiceBase implements LessonProgService {
    
    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;
    
    @Resource(name="lessonStudyDAO")
    private LessonStudyDAO lessonStudyDAO;

    @Resource(name="lessonProgDAO")
    private LessonProgDAO lessonProgDAO;
    
    /*****************************************************
     * 학습진도관리 전체/운영과목 현황
     * @param LessonProgVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap LrnPrgrtStatusSelect(LessonProgVO vo) throws Exception {
        return lessonProgDAO.lrnPrgrtStatusSelect(vo);
    }
    
    /*****************************************************
     * 학습진도관리 > 학과별 전체통계 목록 조회
     * @param LessonProgVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
	@Override
	public List<EgovMap> ListLrnPrgrtStatusByDept(LessonProgVO vo) throws Exception {
		return lessonProgDAO.listLrnPrgrtStatusByDept(vo);
	}
    
    /*****************************************************
     * 과목명 목록 조회
     * @param LessonProgVO
     * @return 
     * @throws Exception
     ******************************************************/
    public List<LessonProgVO> selectCrsCreList(LessonProgVO vo) throws Exception {
        return lessonProgDAO.selectCrsCreList(vo);
    }
}