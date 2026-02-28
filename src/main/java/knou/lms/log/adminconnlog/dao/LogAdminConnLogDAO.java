package knou.lms.log.adminconnlog.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.log.adminconnlog.vo.LogAdminConnLogVO;

@Mapper("logAdminConnLogDAO")
public interface LogAdminConnLogDAO {

	/**
	 * 관리자 페이지 접속 로그 목록을 조회한다.
	 * @param  LogSysConnLogVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<LogAdminConnLogVO> list(LogAdminConnLogVO vo)  throws Exception;
	
	/**
	 * 관리자 페이지 접속 로그 목록을 조회한다. (페이징 적용)
	 * @param  LogSysConnLogVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<LogAdminConnLogVO> listPageing(LogAdminConnLogVO vo)  throws Exception;
	
	/**
	 * 관리자 페이지 접속 로그 개수를 조회한다.
	 * @param  UsrDeptCdVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(LogAdminConnLogVO vo) throws Exception;
	
    /**
	 * 관리자 페이지 접속 로그의 마지막 데이터 PK를 반환한다.
	 * @param  LogSysConnLogVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public LogAdminConnLogVO selectLastSn(LogAdminConnLogVO vo) throws Exception;
	
    /**
	 * 관리자 페이지 접속 로그를 등록한다.
	 * @param  LogSysConnLogVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void insert(LogAdminConnLogVO vo) throws Exception;
	
    /**
	 * 관리자 페이지 접속 로그를 수정한다. (로그아웃 일시)
	 * @param  LogSysConnLogVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void update(LogAdminConnLogVO vo) throws Exception;
}
