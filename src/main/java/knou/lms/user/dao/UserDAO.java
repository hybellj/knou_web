package knou.lms.user.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.user.vo.UserIdsDTO;
import knou.lms.user.vo.UserVO;

@Mapper("userDAO")
public interface UserDAO {
	
	public UserVO userSelect(String	userId) throws Exception;
	
	public List<UserVO> registeredUsersSelect(String userRprsId) throws Exception;

	public UserIdsDTO userIdsSelect(String userRprsId) throws Exception;
}