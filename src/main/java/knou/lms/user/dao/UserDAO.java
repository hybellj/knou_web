package knou.lms.user.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.login.param.LoginParam;
import knou.lms.user.vo.UserIdsDTO;
import knou.lms.user.vo.UserVO;

@Mapper("userDAO")
public interface UserDAO {

	public UserVO userSelect(String	userId) throws Exception;

	public List<UserVO> registeredUsersSelect(String userRprsId) throws Exception;

	public UserIdsDTO userIdsSelect(String userRprsId) throws Exception;

	public EgovMap existUserIdWithPswd(LoginParam param) throws Exception;

	public List<UserVO> userTycdList(UserVO vo) throws Exception;

    /**
     * 사용자설정수정
     * @param  UserVO
     * @return void
     * @throws Exception
     */
    public void userStngModify(UserVO vo) throws Exception;


}