package knou.lms.user.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.user.vo.UserVO;

@Mapper("userDAO")
public interface UserDAO {
	
	public UserVO userSelect(String	userId) throws Exception;
	
	public List<UserVO> registeredUsersSelect(String userRprsId) throws Exception;

	public List<String> userIdsSelect(String userRprsId) throws Exception;

	public List<EgovMap> subjectByUserOrgIdSelect(@Param("profIds") List<String> profIds, @Param("stdntIds") List<String> stdntIds) throws Exception;
}