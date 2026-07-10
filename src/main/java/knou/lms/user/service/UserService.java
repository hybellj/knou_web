package knou.lms.user.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.login.param.LoginParam;
import knou.lms.user.vo.UserIdsDTO;
import knou.lms.user.vo.UserVO;

public interface UserService {

	/**
	 * 사용자 조회
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public UserVO userSelect(String userId) throws Exception;

	/**
	 *
	 * @param userRprsId
	 * @return
	 * @throws Exception
	 */
	public List<UserVO> registeredUsersSelect(String userRprsId) throws Exception;

	/**
	 *
	 * @param userRprsId
	 * @return
	 * @throws Exception
	 */
	public UserIdsDTO userIdsSelect(String userRprsId) throws Exception;

	/**
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public EgovMap existUserIdWithPswd(LoginParam param) throws Exception;

	/**
	 * 시스템 관리자 구분 목록 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<UserVO> userTycdList(UserVO vo) throws Exception;

	/**
     * 사용자설정수정
     * @param  UserVO
     * @return void
     * @throws Exception
     */
    public void userStngModify(UserVO vo) throws Exception;

}