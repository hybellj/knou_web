package knou.lms.login.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.login.param.LoginParam;
import knou.lms.login.vo.LoginVO;
import knou.lms.login.vo.UserLgnHstryVO;
import knou.lms.user.param.UserMetaParam;

public interface LoginService {
    
	@Deprecated
    public List<LoginVO> selectOrgList() throws Exception;
    
    public UserContext processLogin(LoginParam param, UserMetaParam metaParam) throws Exception;
    
    public EgovMap userLatestLoginHstrySelect(String userId) throws Exception;

	public int userLatestLoginHstryInsert(UserLgnHstryVO insertVO) throws Exception;
}