package knou.lms.seminar.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.seminar.dao.SeminarLogDAO;
import knou.lms.seminar.service.SeminarLogService;
import knou.lms.seminar.vo.SeminarLogVO;

@Service("seminarLogService")
public class SeminarLogServiceImpl extends ServiceBase implements SeminarLogService {

    @Resource(name="seminarLogDAO")
    private SeminarLogDAO seminarLogDAO;

    /*****************************************************
     * <p>
     * TODO 세미나 로그 정보 조회
     * </p>
     * 세미나 로그 정보 조회
     * 
     * @param SeminarLogVO
     * @return SeminarLogVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarLogVO select(SeminarLogVO vo) throws Exception {
        return seminarLogDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 로그 목록 조회
     * </p>
     * 세미나 로그 목록 조회
     * 
     * @param SeminarLogVO
     * @return List<SeminarLogVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<SeminarLogVO> list(SeminarLogVO vo) throws Exception {
        return seminarLogDAO.list(vo);
    }
    
}
