package knou.lms.user.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.user.vo.UsrUserAuthGrpVO;

/**
 *  <b>사용자 - 사용자 권한 그룹 정보 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("usrUserAuthGrpDAO")
public interface UsrUserAuthGrpDAO {
	
    /**
	 * 사용자 권한 정보의 전체 목록을 조회한다. 
	 * @param  UsrUserAuthGrpVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<UsrUserAuthGrpVO> selectUserAuthList(UsrUserAuthGrpVO vo) throws Exception;
	
	/**
     * 사용자 권한 정보의 상세 정보를 등록한다.  
     * @param  UsrUserAuthGrpVO
     * @return void
     * @throws Exception
     */
	public void insert(UsrUserAuthGrpVO vo) throws Exception;
	
	/**
     * 사용자 권한 정보 단일 항목을 삭제한다.  
     * @param  UsrUserAuthGrpVO
     * @return void
     * @throws Exception
     */
	public void delete(UsrUserAuthGrpVO vo) throws Exception;
	
	/**
     * 사용자 권한 정보중 메뉴 구분의 전체 권한을 삭제한다.  
     * @param  UsrUserAuthGrpVO
     * @return void
     * @throws Exception
     */
	public void deleteAll(UsrUserAuthGrpVO vo) throws Exception;
	
	/**
     * 사용자 권한 정보 전체를 삭제한다.  
     * @param  UsrUserAuthGrpVO
     * @return void
     * @throws Exception
     */
	public void deleteAllUser(UsrUserAuthGrpVO vo) throws Exception;
	
}
