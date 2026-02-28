package knou.lms.log.logintry.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;

public interface LogUserLoginTryLogService {

	/**
	 *  로그인 시도 로그 전체 목록을 조회한다.
	 * @param LogUserLoginTryLogVO
	 * @return ProcessResultVO
	 * @throws Exception
	 */
	public abstract ProcessResultVO<LogUserLoginTryLogVO> list(
			LogUserLoginTryLogVO vo) throws Exception;

	/**
	 * 로그인 시도 로그 페이징 목록을 조회한다.
	 * @param LogUserLoginTryLogVO
	 * @param pageIndex
	 * @param listScale
	 * @param pageScale
	 * @return ProcessResultVO
	 * @throws Exception
	 */
	public abstract ProcessResultVO<LogUserLoginTryLogVO> listPageing(
			LogUserLoginTryLogVO vo, int pageIndex, int listScale, int pageScale)
			throws Exception;

	/**
	 * 로그인 시도 로그 페이징 목록을 조회한다.
	 * @param LogUserLoginTryLogVO
	 * @param pageIndex
	 * @param listScale
	 * @return ProcessResultVO
	 * @throws Exception
	 */
	public abstract ProcessResultVO<LogUserLoginTryLogVO> listPageing(
			LogUserLoginTryLogVO vo, int pageIndex, int listScale)
			throws Exception;

	/**
	 * 로그인 시도 로그 페이징 목록을 조회한다.
	 * @param LogUserLoginTryLogVO
	 * @param pageIndex
	 * @return ProcessResultVO
	 * @throws Exception
	 */
	public abstract ProcessResultVO<LogUserLoginTryLogVO> listPageing(
			LogUserLoginTryLogVO vo, int pageIndex) throws Exception;

	/**
	 * 로그인 시도 로그 정보를 등록한다.
	 * @param LogUserLoginTryLogVO
	 * @return String
	 * @throws Exception
	 */
	public abstract void add(LogUserLoginTryLogVO vo) throws Exception;

	/**
     * 마지막 로그인 정보 조회
     * @param vo
     * @return
     * @throws Exception
     */
    public LogUserLoginTryLogVO selectLastLogin(LogUserLoginTryLogVO vo) throws Exception;
}