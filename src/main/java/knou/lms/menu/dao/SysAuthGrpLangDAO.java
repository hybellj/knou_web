package knou.lms.menu.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.menu.vo.SysAuthGrpLangVO;

/**
 *  <b>시스템 - 시스템 권한 언어 언어 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("sysAuthGrpLangDAO")
public interface SysAuthGrpLangDAO {

   /**
	 * 시스템 권한 언어의 전체 목록을 조회한다. 
	 * @param  SysAuthGrpLangVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<SysAuthGrpLangVO> list(SysAuthGrpLangVO vo) throws Exception;
	
     /**
	 * 시스템 권한 언어의 상세 정보를 조회한다. 
	 * @param  SysAuthGrpLangVO 
	 * @return SysAuthGrpLangVO
	 * @throws Exception
	 */
	public SysAuthGrpLangVO select(SysAuthGrpLangVO vo) throws Exception;

    /**
     * 시스템 권한 언어의 상세 정보를 등록한다.  
     * @param  SysAuthGrpLangVO
     * @return String
     * @throws Exception
     */
    public void insert(SysAuthGrpLangVO vo) throws Exception;
    
    /**
     * 시스템 권한 언어의 상세 정보를 등록한다.  
     * @param  SysAuthGrpLangVO
     * @return String
     * @throws Exception
     */
    public void merge(SysAuthGrpLangVO vo) throws Exception;
    
    /**
     * 시스템 권한 언어의 상세 정보를 수정한다. 
     * @param  SysAuthGrpLangVO
     * @return int
     * @throws Exception
     */
    public int update(SysAuthGrpLangVO vo) throws Exception;
    
    /**
     * 시스템 권한 언어의 상세 정보를 삭제한다.  
     * @param  SysAuthGrpLangVO
     * @return int
     * @throws Exception
     */
    public int delete(SysAuthGrpLangVO vo) throws Exception;
    
    /**
     * 시스템 권한 언어의 전체 정보를 삭제한다.  
     * @param  SysAuthGrpLangVO
     * @return int
     * @throws Exception
     */
    public int deleteAll(SysAuthGrpLangVO vo) throws Exception;     
}
