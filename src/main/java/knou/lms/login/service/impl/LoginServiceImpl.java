package knou.lms.login.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.login.dao.LoginDAO;
import knou.lms.login.service.LoginService;
import knou.lms.login.vo.LoginVO;

@Service("loginService")
public class LoginServiceImpl extends ServiceBase implements LoginService {
    
    @Resource(name="loginDAO")
    private LoginDAO loginDAO;

    /*****************************************************
     * <p>
     * TODO 기관 리스트 조회
     * </p>
     * 결시원 리스트 조회
     * 
     * @param 
     * @return List<LoginVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LoginVO> selectOrgList() throws Exception {
        return loginDAO.selectOrgList();
    }
}
