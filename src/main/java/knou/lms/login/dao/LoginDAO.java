package knou.lms.login.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.login.vo.LoginVO;

@Mapper("loginDAO")
public interface LoginDAO {
    
    /*****************************************************
     * TODO 기관 리스트 조회
     * @param 
     * @return List<LoginVO>
     * @throws Exception
     ******************************************************/
    public List<LoginVO> selectOrgList() throws Exception;
    
    public  EgovMap userLatestLoginHstrySelect(String userId) throws Exception;
}
