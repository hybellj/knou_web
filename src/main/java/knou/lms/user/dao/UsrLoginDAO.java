package knou.lms.user.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.user.vo.UsrLoginVO;
import knou.lms.user.vo.UsrUserInfoVO;

/**
 *  <b>사용자 - 사용자 로그인 정보 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("usrLoginDAO")
public interface UsrLoginDAO {
	
    /**
	 * 사용자 로그인의 상세 정보를 조회한다. 
	 * @param  UsrLoginVO 
	 * @return UsrLoginVO
	 * @throws Exception
	 */
	public UsrLoginVO select(UsrLoginVO vo) throws Exception;

    /**
	 * 사용자 ID의 중복을 체크한다. 
	 * @param  UsrLoginVO 
	 * @return UsrLoginVO
	 * @throws Exception
	 */
	public String selectIdCheck(UsrLoginVO vo) throws Exception;
	
	/**
	 * 사용자 SSO ID의 중복을 체크한다. 
	 * @param  UsrLoginVO 
	 * @return UsrLoginVO
	 * @throws Exception
	 */
	public String selectSsoIdCheck(UsrUserInfoVO vo) throws Exception;
	
  /**
	 * snsDiv가 있는지  체크한다. 
	 * @param  UsrLoginVO 
	 * @return UsrLoginVO
	 * @throws Exception
	 */
	public String snsDivCheck(UsrLoginVO vo) throws Exception;
	
    /**
     * 사용자의 로그인 정보를 등록한다.  
     * @param  UsrLoginVO
     * @return String
     * @throws Exception
     */
    public void insert(UsrLoginVO vo) throws Exception;
    
    /**
     * 사용자의 로그인 정보를 수정한다. 
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public int update(UsrLoginVO vo) throws Exception ;
    
    /**
     * 사용자의 로그인 정보를 삭제한다.  
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public int delete(UsrLoginVO vo) throws Exception;
    
    /**
     * 사용자의 로그인 횟수를 증가 시킨다. 
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public int updateLoginCount(UsrLoginVO vo) throws Exception ;
    
    /**
     * 사용자의 로그인 실패 정보를 저장 한다. 
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public int updateFailInfo(UsrLoginVO vo) throws Exception ;

    /**
     * 사용자의 비밀번호를 변경한다. 
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public void updatePassword(UsrLoginVO vo) throws Exception ;
    
    /**
     * 사용자의 비밀번호를 변경한다. 
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public void updateTmpPassword(UsrLoginVO vo) throws Exception ;

    /**
     * 사용자의 상태를 변경한다. 
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public int updateStatus(UsrLoginVO vo) throws Exception ;

    /**
     * 사용자를 탈퇴 처리 한다. 
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public void updateWithdrawal(UsrLoginVO vo) throws Exception ;

    /**
     * 사용자를 비밀번호 변경일을 연장한다. 
     * @param  UsrLoginVO
     * @return int
     * @throws Exception
     */
    public int updatePassDate(UsrLoginVO vo) throws Exception ;
    
    /**
     * 사용자의 sns 정보를 업데이트 한다.  
     * @param  UsrLoginVO
     * @return String
     * @throws Exception
     */
    public String updateSnsDiv(UsrLoginVO vo) throws Exception ;
    
    
    /**
     * 사용자 세션ID 정보를 조회한다. 
     * @param  UsrLoginVO 
     * @return UsrLoginVO
     * @throws Exception
     */
    public UsrLoginVO selectSessionId(UsrLoginVO vo) throws Exception;
    
    /**
     * 사용자 세션ID 정보를 저장한다. 
     * @param  UsrLoginVO 
     * @return UsrLoginVO
     * @throws Exception
     */
    public void insertSessionId(UsrLoginVO vo) throws Exception;
    
    /**
     * 사용자 세션ID 정보를 수정한다. 
     * @param  UsrLoginVO 
     * @return 
     * @throws Exception
     */
    public void updateSessionId(UsrLoginVO vo) throws Exception;
}
