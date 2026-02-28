package knou.lms.seminar.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.seminar.dao.SeminarHstyDAO;
import knou.lms.seminar.service.SeminarHstyService;
import knou.lms.seminar.vo.SeminarHstyVO;

@Service("seminarHstyService")
public class SeminarHstyServiceImpl extends ServiceBase implements SeminarHstyService {
    
    @Resource(name="seminarHstyDAO")
    private SeminarHstyDAO seminarHstyDAO;

    /*****************************************************
     * <p>
     * TODO 세미나 참석 기록 정보 조회
     * </p>
     * 세미나 참석 기록 정보 조회
     * 
     * @param SeminarHstyVO
     * @return SeminarHstyVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarHstyVO select(SeminarHstyVO vo) throws Exception {
        return seminarHstyDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 참석 기록 목록 조회
     * </p>
     * 세미나 참석 기록 목록 조회
     * 
     * @param SeminarHstyVO
     * @return List<SeminarHstyVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<SeminarHstyVO> list(SeminarHstyVO vo) throws Exception {
        return seminarHstyDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 참석 기록 등록
     * </p>
     * 세미나 참석 기록 등록
     * 
     * @param SeminarHstyVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(SeminarHstyVO vo) throws Exception {
        seminarHstyDAO.insert(vo);
    }
    
}