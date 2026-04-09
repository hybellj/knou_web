package knou.lms.user.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.login.param.LoginParam;
import knou.lms.user.vo.UserIdsDTO;
import knou.lms.user.vo.UserVO;

public interface UserService {

	UserVO userSelect(String userId) throws Exception;

	List<UserVO> registeredUsersSelect(String userRprsId) throws Exception;

	UserIdsDTO userIdsSelect(String userRprsId) throws Exception;

	EgovMap existUserIdWithPswd(LoginParam param) throws Exception;	
}