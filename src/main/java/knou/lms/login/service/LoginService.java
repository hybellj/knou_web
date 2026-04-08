package knou.lms.login.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.login.param.LoginParam;
import knou.lms.login.vo.LoginVO;

public interface LoginService {
    
    public List<LoginVO> selectOrgList() throws Exception;
    
    public UserContext processLogin(LoginParam param) throws Exception;
    
    public EgovMap userLatestLoginHstrySelect(String userId) throws Exception;
}