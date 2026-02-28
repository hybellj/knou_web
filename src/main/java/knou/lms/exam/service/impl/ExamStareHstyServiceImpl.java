package knou.lms.exam.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.exam.dao.ExamStareHstyDAO;
import knou.lms.exam.service.ExamStareHstyService;
import knou.lms.exam.vo.ExamStareHstyVO;

@Service("examStareHstyService")
public class ExamStareHstyServiceImpl extends ServiceBase implements ExamStareHstyService {

    @Resource(name="examStareHstyDAO")
    private ExamStareHstyDAO examStareHstyDAO;

    /*****************************************************
     * <p>
     * TODO 시험 참여 이력 조회
     * </p>
     * 시험 참여 이력 조회
     * 
     * @param ExamStareHstyVO
     * @return List<ExamStareHstyVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamStareHstyVO> listExamStareHsty(ExamStareHstyVO vo) throws Exception {
        return examStareHstyDAO.listExamStareHsty(vo);
    }
    
}
