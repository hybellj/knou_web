package knou.lms.user.service;

import java.util.List;

import knou.lms.user.vo.UserIdsDTO;
import knou.lms.user.vo.UserVO;

public interface UserService {

	UserVO userSelect(String userId) throws Exception;

	List<UserVO> registeredUsersSelect(String userRprsId) throws Exception;

	UserIdsDTO userIdsSelect(String userRprsId) throws Exception;	
}