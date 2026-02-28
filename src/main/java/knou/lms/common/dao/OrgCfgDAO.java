package knou.lms.common.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.OrgCfgVO;

/**
 *  <b>시스템 - 시스템 설정 정보 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("orgCfgDAO")
public interface OrgCfgDAO {

    /**
	 * 설정 정보의 전체 목록을 조회한다. 
	 * @param  OrgCfgVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<OrgCfgVO> list(OrgCfgVO vo) throws Exception;
	
    /**
	 * 설정 정보의 검색된 수를 카운트 한다. 
	 * @param  OrgCfgVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(OrgCfgVO vo) throws Exception;
	
    /**
	 * 설정 정보의 전체 목록을 조회한다. 
	 * @param  OrgCfgVO 
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<OrgCfgVO> listPageing(OrgCfgVO vo) throws Exception;
	
    /**
	 * 설정 정보의 상세 정보를 조회한다. 
	 * @param  OrgCfgVO 
	 * @return OrgCfgVO
	 * @throws Exception
	 */
	public OrgCfgVO select(OrgCfgVO vo) throws Exception;

    /**
     * 설정 정보의 상세 정보를 등록한다.  
     * @param  OrgCfgVO
     * @return void
     * @throws Exception
     */
    public void insert(OrgCfgVO vo) throws Exception;
    
    /**
     * 설정 정보의 상세 정보를 수정한다. 
     * @param  OrgCfgVO
     * @return void
     * @throws Exception
     */
    public void update(OrgCfgVO vo) throws Exception;
    
    /**
     * 설정 정보의 상세 정보를 삭제한다.  
     * @param  OrgCfgVO
     * @return int
     * @throws Exception
     */
    public void delete(OrgCfgVO vo) throws Exception;
    
    /**
     * 분류 코드 하위의 설정 정보의 상세 정보 전체를 삭제한다.  
     * @param  OrgCfgVO
     * @return int
     * @throws Exception
     */
    public void deleteAll(OrgCfgVO vo) throws Exception;
    
}
