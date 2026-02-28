package knou.lms.common.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.OrgCfgCtgrVO;
import knou.lms.common.vo.OrgCfgVO;

/**
 *  <b>시스템 - 시스템 설정 분류 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("orgCfgCtgrDAO")
public interface OrgCfgCtgrDAO {
	
    /**
	 * 설정 분류의 전체 목록을 조회한다. 
	 * @param  OrgCfgCtgrVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<OrgCfgCtgrVO> list(OrgCfgCtgrVO vo) throws Exception;
	
    /**
	 * 설정 분류의 검색된 수를 카운트 한다. 
	 * @param  OrgCfgCtgrVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(OrgCfgCtgrVO vo) throws Exception;
	
    /**
	 * 설정 분류의 전체 목록을 조회한다. 
	 * @param  OrgCfgCtgrVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<OrgCfgCtgrVO> listPageing(OrgCfgCtgrVO vo) throws Exception ;

	/**
	 * 설정 분류의 전체 목록을 조회한다. 
	 * @param  OrgCfgCtgrVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<OrgCfgVO> listConfig(OrgCfgCtgrVO vo) throws Exception;

    /**
	 * 설정 분류의 상세 정보를 조회한다. 
	 * @param  OrgCfgCtgrVO 
	 * @return OrgCfgCtgrVO
	 * @throws Exception
	 */
	public OrgCfgCtgrVO select(OrgCfgCtgrVO vo) throws Exception;

    /**
     * 설정 분류의 상세 정보를 등록한다.  
     * @param  OrgCfgCtgrVO
     * @return String
     * @throws Exception
     */
    public void insert(OrgCfgCtgrVO vo) throws Exception;
    
    /**
     * 설정 분류의 상세 정보를 수정한다. 
     * @param  OrgCfgCtgrVO
     * @return int
     * @throws Exception
     */
    public void update(OrgCfgCtgrVO vo) throws Exception ;
    
    /**
     * 설정 분류의 상세 정보를 삭제한다.  
     * @param  OrgCfgCtgrVO
     * @return int
     * @throws Exception
     */
    public void delete(OrgCfgCtgrVO vo) throws Exception ;

}
