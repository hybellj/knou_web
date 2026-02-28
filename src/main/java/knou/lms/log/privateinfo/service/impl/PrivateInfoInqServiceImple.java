package knou.lms.log.privateinfo.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.log.privateinfo.dao.PrivateInfoInqDAO;
import knou.lms.log.privateinfo.service.PrivateInfoInqService;
import knou.lms.log.privateinfo.vo.PrivateInfoInqVO;

@Service("privateInfoInqService")
public class PrivateInfoInqServiceImple extends ServiceBase implements PrivateInfoInqService {

    @Resource(name="privateInfoInqDAO")
    private PrivateInfoInqDAO privateInfoInqDAO;

    /*****************************************************
     * <p>
     * TODO 개인정보 조회 이력 정보를 저장하고 결과를 반환한다.
     * </p>
     * 개인정보 조회 이력 정보를 저장하고 결과를 반환한다.
     *
     * @param PrivateInfoInqVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void add(PrivateInfoInqVO vo) throws Exception {
        privateInfoInqDAO.insert(vo);
    }
    
}
