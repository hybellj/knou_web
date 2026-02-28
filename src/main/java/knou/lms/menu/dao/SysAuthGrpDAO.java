package knou.lms.menu.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.menu.vo.SysAuthGrpVO;

/**
 *  <b>시스템 - 시스템 권한 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("sysAuthGrpDAO")
public interface SysAuthGrpDAO{
    
    /**
     *  권한/메뉴관리의 권한목록을 조회한다.
     * @param SysAuthGrpVO
     * @return List<SysAuthGrpVO>
     * @throws Exception
     */
    public List<SysAuthGrpVO> selectListAuthGrp(SysAuthGrpVO vo) throws Exception;
	
    
    /**
	 * 시스템 권한의 전체 목록을 조회한다. 
	 * @param  SysAuthGrpVO 
	 * @return List
	 * @throws Exception
	 */
	public List<SysAuthGrpVO> list(SysAuthGrpVO vo) throws Exception;
	
     /**
	 * 시스템 권한의 상세 정보를 조회한다. 
	 * @param  SysAuthGrpVO 
	 * @return SysAuthGrpVO
	 * @throws Exception
	 */
	public SysAuthGrpVO select(SysAuthGrpVO vo) throws Exception;

    /**
     * 시스템 권한의 상세 정보를 등록한다.  
     * @param  SysAuthGrpVO
     * @return String
     * @throws Exception
     */
    public void insert(SysAuthGrpVO vo) throws Exception;
    
    /**
     * 시스템 권한의 상세 정보를 수정한다. 
     * @param  SysAuthGrpVO
     * @return int
     * @throws Exception
     */
    public int update(SysAuthGrpVO vo) throws Exception;
    
    /**
     * 시스템 권한의 상세 정보를 삭제한다.  
     * @param  SysAuthGrpVO
     * @return int
     * @throws Exception
     */
    public int delete(SysAuthGrpVO vo) throws Exception ;
    
}
