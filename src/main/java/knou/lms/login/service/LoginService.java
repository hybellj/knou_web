package knou.lms.login.service;

import knou.framework.context2.UserContext;
import knou.lms.login.param.LoginParam;
import knou.lms.login.vo.LoginVO;
import knou.lms.login.vo.UserLgnHstryVO;
import knou.lms.user.vo.UserVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public interface LoginService {

	@Deprecated
    public List<LoginVO> selectOrgList() throws Exception;

    public EgovMap userLatestLoginHstrySelect(String userId) throws Exception;

	public int userLatestLoginHstryInsert(UserLgnHstryVO insertVO) throws Exception;

	public UserContext processLogin(LoginParam param, UserLgnHstryVO userLgnHstryVO)  throws Exception;

	public UserContext buildUserContext(UserVO loginUser) throws Exception;

	LoginVO authenticate(LoginVO param) throws Exception;

	/**
	 * 아이디 존재 여부만 EP → LMS 순으로 확인한다 (비밀번호 검증 안 함).
	 * @return "EP" | "LMS" | null(둘 다 없음)
	 */
	String checkUserSource(LoginVO param) throws Exception;

	// ================================================================
	// 패스키(FIDO) 인증 로그인
	//   mSABER REST API 연동 (암호화 없음, x-www-form-urlencoded)
	// ================================================================

	/**
	 * 패스키 인증 세션토큰(challenge) 발급.
	 * mSABER: POST /passkey/restAPI/auth/option (ud, sd)
	 *
	 * @param userId 사용자 아이디
	 * @return {"result":1,"token":"...","msg":"성공"} 형태의 응답 맵
	 */
	Map<String, Object> requestPasskeyAuthOption(String ud);

	/**
	 * 패스키 인증 결과 검증.
	 * mSABER: POST /passkey/restAPI/auth/verify/ch (tk)
	 *
	 * @param token auth/option 에서 발급받은 세션토큰
	 * @return {"result":1,"userId":"...","msg":"..."} 형태의 응답 맵
	 */
	Map<String, Object> verifyPasskeyAuth(String token);

	/**
	 * 모바일 인증 결과 검증.
	 */
	Map<String, Object> requestMobileAuth(String challenge);
	Map<String, Object> checkMobileAuthResult(String challenge);
}