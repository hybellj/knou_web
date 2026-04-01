package knou.lms.user.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.user.dao.UserDAO;
import knou.lms.user.service.UserService;
import knou.lms.user.vo.UserVO;

@Service("userService")
public class UserServiceImpl  extends ServiceBase implements UserService{

	@Resource(name="userDAO")
    private UserDAO userDAO;
	
	@Override
	public UserVO userSelect(String userId) throws Exception {
		return userDAO.userSelect(userId);
	}

	@Override
	public List<UserVO> registeredUsersSelect(String userRprsId) throws Exception {
		return userDAO.registeredUsersSelect(userRprsId);
	}
}