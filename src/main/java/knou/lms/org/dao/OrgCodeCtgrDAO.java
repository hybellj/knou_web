package knou.lms.org.dao;

import java.util.List;

import knou.lms.org.vo.OrgCodeCtgrVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 *  <b>기관 - 기관 코드 분류 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("orgCodeCtgrDAO")
public interface OrgCodeCtgrDAO {
	
    /**
	 * 코드 분류의 전체 목록을 조회한다. 
	 * @param  OrgCodeCtgrVO 
	 * @return List
	 * @throws Exception
	 */
	public List<OrgCodeCtgrVO> list(OrgCodeCtgrVO vo) throws Exception;
	
    /**
	 * 코드 분류의 검색된 수를 카운트 한다. 
	 * @param  OrgCodeCtgrVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(OrgCodeCtgrVO vo) throws Exception;
	
    /**
	 * 코드 분류의 전체 목록을 조회한다. 
	 * @param  OrgCodeCtgrVO 
	 * @return List
	 * @throws Exception
	 */
	public List<OrgCodeCtgrVO> listPageing(OrgCodeCtgrVO vo) throws Exception;
	
    /**
	 * 코드 분류의 상세 정보를 조회한다. 
	 * @param  OrgCodeCtgrVO 
	 * @return OrgCodeCtgrVO
	 * @throws Exception
	 */
	public OrgCodeCtgrVO select(OrgCodeCtgrVO vo) throws Exception;

    /**
     * 코드 분류의 상세 정보를 등록한다.  
     * @param  OrgCodeCtgrVO
     * @return int
     * @throws Exception
     */
    public int insert(OrgCodeCtgrVO vo) throws Exception;
    
    /**
     * 코드 분류의 상세 정보를 수정한다. 
     * @param  OrgCodeCtgrVO
     * @return int
     * @throws Exception
     */
    public int update(OrgCodeCtgrVO vo) throws Exception;
    
    /**
     * 코드 분류의 상세 정보를 삭제한다.  
     * @param  OrgCodeCtgrVO
     * @return int
     * @throws Exception
     */
    public int delete(OrgCodeCtgrVO vo) throws Exception;

    /**
     * 기관 코드 전체 목록을 조회한다. 
     * @param  OrgCodeCtgrVO 
     * @return List
     * @throws Exception
     */
	public List<OrgCodeCtgrVO> listOrgId(OrgCodeCtgrVO vo)  throws Exception;
	
}