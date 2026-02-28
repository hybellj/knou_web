package knou.lms.user.dao;

import java.util.List;

import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.user.vo.UsrUserInfoChgHstyVO;

/**
 *  <b>사용자 - 사용자 정보 변경 로그 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("usrUserInfoChgHstyDAO")
public interface UsrUserInfoChgHstyDAO {
	
   /**
	 * 사용자 정보 변경 로그의 전체 목록을 조회한다. 
	 * @param  UsrUserInfoChgHstyVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<UsrUserInfoChgHstyVO> list(UsrUserInfoChgHstyVO vo) throws Exception;
	
    /**
	 * 사용자 정보 변경 로그의 검색된 수를 카운트 한다. 
	 * @param  UsrUserInfoChgHstyVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(UsrUserInfoChgHstyVO vo) throws Exception;
	
    /**
	 * 사용자 정보 변경 로그의 전체 목록을 조회한다. 
	 * @param  UsrUserInfoChgHstyVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<UsrUserInfoChgHstyVO> listPageing(UsrUserInfoChgHstyVO vo) throws Exception ;
	
    /**
	 * 사용자 정보 변경 로그의 상세 정보를 조회한다. 
	 * @param  UsrUserInfoChgHstyVO 
	 * @return UsrUserInfoChgHstyVO
	 * @throws Exception
	 */
	public UsrUserInfoChgHstyVO select(UsrUserInfoChgHstyVO vo) throws Exception;

    /**
     * 사용자 정보 변경 로그의 상세 정보를 등록한다.  
     * @param  UsrUserInfoChgHstyVO
     * @return String
     * @throws Exception
     */
    public void insert(UsrUserInfoChgHstyVO vo) throws Exception;
	
}
