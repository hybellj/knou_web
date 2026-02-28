package knou.lms.dashboard.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.dashboard.dao.AcadSchDAO;
import knou.lms.dashboard.service.AcadSchService;
import knou.lms.dashboard.vo.AcadSchVO;

@Service("acadSchService")
public class AcadSchServiceImpl extends ServiceBase implements AcadSchService {

    @Resource(name="acadSchDAO")
    private AcadSchDAO acadSchDAO;

    /*****************************************************
     * <p>
     * TODO 일정 관리 조회
     * </p>
     * 일정 관리 조회
     *
     * @param AcadSchVO
     * @return AcadSchVO
     * @throws Exception
     ******************************************************/
    @Override
    public AcadSchVO select(AcadSchVO vo) throws Exception {
        return acadSchDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 일정 관리 등록
     * </p>
     * 일정 관리 등록
     *
     * @param AcadSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(AcadSchVO vo) throws Exception {
        acadSchDAO.insert(vo);
    }

    /*****************************************************
     * <p>
     * TODO 일정 관리 수정
     * </p>
     * 일정 관리 수정
     *
     * @param AcadSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void update(AcadSchVO vo) throws Exception {
        acadSchDAO.update(vo);
    }

    /*****************************************************
     * <p>
     * TODO 일정 관리 삭제
     * </p>
     * 일정 관리 삭제
     *
     * @param AcadSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(AcadSchVO vo) throws Exception {
        acadSchDAO.delete(vo);
    }
    
}
