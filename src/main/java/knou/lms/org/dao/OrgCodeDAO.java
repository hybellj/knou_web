package knou.lms.org.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.org.vo.OrgCodeCtgrVO;
import knou.lms.org.vo.OrgCodeVO;

@Mapper("orgCodeDAO")
public interface OrgCodeDAO {

	public List<OrgCodeVO> selectOrgCodeList(OrgCodeVO orgCodeVO) throws Exception;

	public OrgCodeVO select(OrgCodeVO vo) throws Exception;

    /**
     * 코드 분류 하위의 코드 정보 전체를 상세 정보를 삭제한다.  
     * @param  OrgCodeVO
     * @return int
     * @throws Exception
     */
    public int deleteAll(OrgCodeVO vo) throws Exception;
    
    /**
     * 코드 정보의 검색된 수를 카운트 한다. 
     * @param  OrgCodeVO 
     * @return int
     * @throws Exception
     */
    public int count(OrgCodeVO vo) throws Exception;
    
    /**
     * 코드 정보의 전체 목록을 조회한다. 
     * @param  OrgCodeVO 
     * @return List
     * @throws Exception
     */
    public List<OrgCodeVO> listPageing(OrgCodeVO vo) throws Exception;
    
    public String selectKey(OrgCodeVO vo) throws Exception;

    /**
     * 코드 정보의 상세 정보를 등록한다.  
     * @param  OrgCodeVO
     * @return int
     * @throws Exception
     */
    public int insert(OrgCodeVO vo) throws Exception;
    
    /**
     * 코드 정보의 상세 정보를 수정한다. 
     * @param  OrgCodeVO
     * @return int
     * @throws Exception
     */
    public int update(OrgCodeVO vo) throws Exception;

    /**
     * 코드 정보의 상세 정보를 삭제한다.  
     * @param  OrgCodeVO
     * @return int
     * @throws Exception
     */
    public int delete(OrgCodeVO vo) throws Exception;
    
    public List<OrgCodeVO> list(OrgCodeVO orgCodeVO) throws Exception;
}
