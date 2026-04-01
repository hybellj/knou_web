package knou.lms.user.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.user.vo.UserVO;

@Mapper("userDAO")
public interface UserDAO {
	
	public UserVO userSelect(String	userId) throws Exception;
	
	public List<UserVO> registeredUsersSelect(String	userRprsId) throws Exception;

}