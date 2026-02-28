package knou.lms.user.service;

import knou.lms.user.vo.UsrLoginVO;
import knou.lms.user.vo.UsrUserInfoVO;

public interface UsrLoginService {

	/**
	 * 사용자 아이디 중복 체크
	 * @param UsrLoginVO
	 * @return  ProcessResultDTO
	 */
	public abstract String userIdCheck(UsrLoginVO vo) throws Exception;
	
	/**
	 * SSO 사용자 아이디 중복 체크
	 * @param UsrLoginVO
	 * @return  ProcessResultDTO
	 */
	public abstract String ssoUserIdCheck(UsrUserInfoVO vo) throws Exception;

	/**
	 * 사용자 로그인 조회
	 * @param UsrLoginVO vo
	 * @return  String
	 */
	public abstract UsrLoginVO select(UsrLoginVO vo) throws Exception;

	/**
	 * 사용자 로그인 등록
	 * @param UsrLoginVO vo
	 * @return  String
	 */
	public abstract void add(UsrLoginVO vo) throws Exception;

	/**
	 * 사용자 로그인 수정
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	public abstract int edit(UsrLoginVO vo) throws Exception;

	/**
	 * 사용자 로그인 삭제
	 * @param UsrLoginVO vo
	 * @return int
	 */
	public abstract int remove(UsrLoginVO vo) throws Exception;

	/**
	 * 사용자의 마지막 접속 정보 수정
	 * - 접속횟수 및 마지막 접속일자 수정
	 * - 접속실패에 대한 정보 초기화
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	public abstract int editLastLogin(UsrLoginVO vo) throws Exception;

	/**
	 * 사용자의 로그인 실패에 대한 기록
	 * - 접속실패에 대한 정보 수정
	 * @param UsrLoginVO vo
	 * @return  ProcessResultDTO
	 */
	public abstract UsrLoginVO editFailLogin(UsrLoginVO vo) throws Exception;

	/**
	 * 사용자의 암호를 변경한다.
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	public abstract void editPass(UsrLoginVO vo) throws Exception;
	
	/**
	 * 사용자의 암호를 변경한다.
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	public abstract void editTmpPass(UsrLoginVO vo) throws Exception;

	/**
	 * 사용자의 사용상태를 변경한다.
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	public abstract int editUserSts(UsrLoginVO vo, String userInfoChgDivCd)	throws Exception;
	
	/**
	 * 사용자를 탈퇴 처리한다.
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	public abstract void WithdrawalUser(UsrLoginVO vo)
			throws Exception;

	/**
	 * 비밀번호 초기화를 위한 비밀번호를 받아온다.
	 * 임의의 숫자 영문 조합으로 반환한다. (8자)
	 * @return
	 */
	public abstract String getNewPass();

	/**
	 * 사용자의 비밀번호의 암호화 처리
	 * @param UsrLoginVO vo
	 * @return  ProcessResultDTO
	 */
	public abstract void editEncriptPass(UsrLoginVO vo) throws Exception;

	/**
	 * 사용자의 비밀번호 변경일자 연장 처리
	 * @param UsrLoginVO vo
	 * @return  ProcessResultDTO
	 */
	public abstract int editPassChgDate(UsrLoginVO vo) throws Exception;
	
	/**
	 * sns_div 체크
	 * @param UsrLoginVO
	 * @return  ProcessResultDTO
	 */
	public abstract String snsDivCheck(UsrLoginVO vo) throws Exception;

	
    /**
     * 사용자 세션ID 조회
     * @param UsrLoginVO vo
     * @return  String
     */
    public abstract UsrLoginVO selectSessionId(UsrLoginVO vo) throws Exception;
	
	/**
     * 사용자 세션ID 저장
     * @param UsrLoginVO vo
     * @return  String
     */
    public abstract void insertSessionId(UsrLoginVO vo) throws Exception;
    
}