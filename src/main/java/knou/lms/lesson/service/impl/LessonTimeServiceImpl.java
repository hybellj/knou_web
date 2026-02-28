package knou.lms.lesson.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.lesson.dao.LessonCntsDAO;
import knou.lms.lesson.dao.LessonTimeDAO;
import knou.lms.lesson.service.LessonCntsService;
import knou.lms.lesson.service.LessonTimeService;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonTimeVO;

@Service("lessonTimeService")
public class LessonTimeServiceImpl extends ServiceBase implements LessonTimeService {

    @Resource(name="lessonTimeDAO")
    private LessonTimeDAO lessonTimeDAO;
    
    @Resource(name="lessonCntsDAO")
    private LessonCntsDAO lessonCntsDAO;
    
    @Resource(name="lessonCntsService")
    private LessonCntsService lessonCntsService;

    /*****************************************************
     * 교시 조회
     * @param vo
     * @return LessonTimeVO
     * @throws Exception
     ******************************************************/
    public LessonTimeVO select(LessonTimeVO vo) throws Exception {
        return lessonTimeDAO.select(vo);
    }
    
    /*****************************************************
     * 교시 등록
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(LessonTimeVO vo) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        int lessonTimeOrder = vo.getLessonTimeOrder();
        
        // 순번 체크
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setLessonScheduleId(lessonScheduleId);
        
        int lessonTimeOrderMax = this.selectLessonTimeOrderMax(lessonTimeVO);
        
        if(lessonTimeOrder != lessonTimeOrderMax) {
            String[] msgArgs = {String.valueOf(lessonTimeOrderMax)};
            
            throw processException("lesson.error.duplicate.lesson.time.order", msgArgs); // lessonTimeOrderMax + "교시는 이미 등록되었습니다."
        }
        
        // 저장
        String lessonTimeId = IdGenerator.getNewId("LSTM");
        
        vo.setLessonTimeId(lessonTimeId);
        
        lessonTimeDAO.insert(vo);
    }

    /*****************************************************
     * 교시 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void update(LessonTimeVO vo) throws Exception {
        lessonTimeDAO.update(vo);
    }

    /*****************************************************
     * 교시 삭제
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(LessonTimeVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String lessonTimeId = vo.getLessonTimeId();
        
        // 교시의 학습콘텐츠 삭제
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setLessonTimeId(lessonTimeId);
        
        List<LessonCntsVO> lessonCntsList = lessonCntsDAO.list(lessonCntsVO);
        
        for(LessonCntsVO lessonCntsVO2 : lessonCntsList) {
            lessonCntsService.delete(lessonCntsVO2);
        }
        
        // 교시 삭제
        lessonTimeDAO.delete(vo);
    }
    
    /*****************************************************
     * 교시 순서 최대값
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public int selectLessonTimeOrderMax(LessonTimeVO vo) throws Exception {
        return lessonTimeDAO.selectLessonTimeOrderMax(vo);
    }

    /*****************************************************
     * 교시 목록 조회
     * @param vo
     * @return List<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonTimeVO> list(LessonTimeVO vo) throws Exception {
        return lessonTimeDAO.list(vo);
    }
}
