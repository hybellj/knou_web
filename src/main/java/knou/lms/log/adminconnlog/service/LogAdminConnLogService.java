package knou.lms.log.adminconnlog.service;

import org.springframework.transaction.annotation.Transactional;

import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.log.adminconnlog.vo.LogAdminConnLogVO;

public interface LogAdminConnLogService {
	
	/**
	 * 관리자 페이지 접속 로그 목록을 조회한다.
	 * @param OrgConnIpVO
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	public	ProcessResultListVO<LogAdminConnLogVO> listLoginLog(LogAdminConnLogVO vo, int curPage, int listScale, int pageScale) throws Exception;

	/**
	 * 관리자 페이지 접속 로그의 마지막 데이터 PK를 반환한다.
	 * @param OrgConnIpVO
	 * @return LogAdminConnLogVO
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	public LogAdminConnLogVO viewLoginLogLast(LogAdminConnLogVO vo) throws Exception;

	/**
	 * 관리자 페이지 접속 로그를 등록한다.
	 * @param OrgConnIpVO
	 * @return 
	 * @throws Exception
	 */
	public abstract void addConnectLog(LogAdminConnLogVO vo) throws Exception;

	/**
	 * 관리자 페이지 접속 로그를 수정한다. (로그아웃 일시)
	 * @param OrgConnIpVO
	 * @return 
	 * @throws Exception
	 */
	public abstract void editConnectLog(LogAdminConnLogVO vo) throws Exception;
}
