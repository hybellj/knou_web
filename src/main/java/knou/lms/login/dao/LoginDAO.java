package knou.lms.login.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.login.vo.LoginVO;
import knou.lms.login.vo.UserLgnHstryVO;

@Mapper("loginDAO")
public interface LoginDAO {    
    
	@Deprecated
    public 	List<LoginVO> selectOrgList() throws Exception;
    
    public  EgovMap userLatestLoginHstrySelect(String userId) throws Exception;

	public int userLatestLoginHstryInsert(UserLgnHstryVO userLgnHstryVO) throws Exception;
}
