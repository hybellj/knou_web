package knou.lms.log.logintry.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;

/**
 *  <b>로그 - 사용자 로그인 시도 로그 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("logUserLoginTryLogDAO")
public interface LogUserLoginTryLogDAO {
	
    /**
	 * 로그인 시도 로그의 전체 목록을 조회한다. 
	 * @param  LogUserLoginTryLogVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<LogUserLoginTryLogVO> list(LogUserLoginTryLogVO vo) throws Exception;
	
    /**
	 * 로그인 시도 로그의 검색된 수를 카운트 한다. 
	 * @param  LogUserLoginTryLogVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(LogUserLoginTryLogVO vo) throws Exception;
	
    /**
	 * 로그인 시도 로그의 전체 목록을 조회한다. 
	 * @param  LogUserLoginTryLogVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<LogUserLoginTryLogVO> listPageing(LogUserLoginTryLogVO vo) throws Exception;
	
    /**
	 * 로그인 시도 로그의 상세 정보를 조회한다. 
	 * @param   
	 * @return int
	 * @throws Exception
	 */
	public int selectKey() throws Exception;
	
    /**
     * 로그인 시도 로그의 상세 정보를 등록한다.  
     * @param  LogUserLoginTryLogVO
     * @return String
     * @throws Exception
     */
    public void insert(LogUserLoginTryLogVO vo) throws Exception;

    /**
     * 마지막 로그인 정보 조회
     * @param vo
     * @return
     * @throws Exception
     */
    public List<LogUserLoginTryLogVO> selectLastLogin(LogUserLoginTryLogVO vo) throws Exception;
}
