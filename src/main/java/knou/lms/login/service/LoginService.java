package knou.lms.login.service;

import java.util.List;

import knou.lms.login.vo.LoginVO;

public interface LoginService {
    
    /*****************************************************
     * TODO 기관 리스트 조회
     * @param 
     * @return List<LoginVO>
     * @throws Exception
     ******************************************************/
    public List<LoginVO> selectOrgList() throws Exception;
}
