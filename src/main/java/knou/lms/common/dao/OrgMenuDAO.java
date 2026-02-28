package knou.lms.common.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.OrgMenuVO;

/**
 *  <b>기관 - 기관 메뉴 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("orgMenuDAO")
public interface OrgMenuDAO  {
	
    /**
	 * 기관 메뉴의 전체 목록을 조회한다. 
	 * @param  OrgMenuVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<OrgMenuVO> list(OrgMenuVO vo) throws Exception;
	
    /**
	 * 기관 메뉴의 상세 정보를 조회한다. 
	 * @param  OrgMenuVO 
	 * @return OrgMenuVO
	 * @throws Exception
	 */
	public OrgMenuVO selectAuthorizeByMenu(OrgMenuVO vo) throws Exception;
	
	/**
	 * 메뉴 코드로 사용자 권한 출력한다.
	 * @param  OrgMenuVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<OrgMenuVO> listAuthMenuCdByMenu(OrgMenuVO vo) throws Exception;
	
    /**
	 * 기관 메뉴의 상세 정보를 조회한다. 
	 * @param  OrgMenuVO 
	 * @return OrgMenuVO
	 * @throws Exception
	 */
	public OrgMenuVO select(OrgMenuVO vo) throws Exception;
	
    /**
	 * 기관 메뉴의 전체 목록을 조회한다. 
	 * @param  OrgMenuVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<OrgMenuVO> listAuthGrpMenu(OrgMenuVO vo) throws Exception;
	
    /**
	 * 기관 메뉴의 키를 생성한다. 
	 * @param  OrgMenuVO 
	 * @return OrgMenuVO
	 * @throws Exception
	 */
	public String selectKey() throws Exception;

    /**
     * 기관 메뉴의 상세 정보를 등록한다.  
     * @param  OrgMenuVO
     * @return String
     * @throws Exception
     */
    public void insert(OrgMenuVO vo) throws Exception;
    
    /**
     * 기관 메뉴의 상세 정보를 수정한다. 
     * @param  OrgMenuVO
     * @return int
     * @throws Exception
     */
    public int update(OrgMenuVO vo) throws Exception ;
    
    /**
     * 기관 메뉴의 정보를 삭제한다.  
     * @param  OrgMenuVO
     * @return int
     * @throws Exception
     */
    public int delete(OrgMenuVO vo) throws Exception ;
    
    /**
     * 기관 메뉴의 초기화 등록한다.  
     * @param  OrgMenuVO
     * @return String
     * @throws Exception
     */
    public void insertInit(OrgMenuVO vo) throws Exception;
    
    /**
     * 기관 메뉴의 초기화 삭제한다.  
     * @param  OrgMenuVO
     * @return int
     * @throws Exception
     */
    public int deleteByMenuLvl(OrgMenuVO vo) throws Exception ; 
    
    /**
     * 기관 메뉴의 간략 정보를 조회한다. 
     * @param  OrgMenuVO 
     * @return OrgMenuVO
     * @throws Exception
     */
    public OrgMenuVO selectMenuSimpleInfo(OrgMenuVO vo) throws Exception;

}
