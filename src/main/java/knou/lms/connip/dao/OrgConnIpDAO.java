package knou.lms.connip.dao;

import java.util.List;

import knou.lms.connip.vo.OrgConnIpVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 *  <b>교육기관 - 기관 접속 IP 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("orgConnIpDAO")
public interface OrgConnIpDAO {
    
	/**
	 * 접속 IP의 전체 목록을 조회한다. 
	 * @param  OrgConnIpVO 
	 * @return List
	 * @throws Exception
	 */
	public List<OrgConnIpVO> list(OrgConnIpVO vo) throws Exception;
	
    /**
	 * 접속 IP의 검색된 수를 카운트 한다. 
	 * @param  OrgConnIpVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(OrgConnIpVO vo) throws Exception;
	
    /**
	 * 접속 IP의 전체 목록을 조회한다. 
	 * @param  OrgConnIpVO 
	 * @return List
	 * @throws Exception
	 */
	public List<OrgConnIpVO> listPageing(OrgConnIpVO vo) throws Exception ;
	
    /**
	 * 접속 IP의 상세 정보를 조회한다. 
	 * @param  OrgConnIpVO 
	 * @return OrgConnIpVO
	 * @throws Exception
	 */
	public OrgConnIpVO select(OrgConnIpVO vo) throws Exception;

    /**
     * 접속 IP의 상세 정보를 등록한다.  
     * @param  OrgConnIpVO
     * @return String
     * @throws Exception
     */
    public void insert(OrgConnIpVO vo) throws Exception;
    
    /**
     * 접속 IP의 상세 정보를 삭제한다.  
     * @param  OrgConnIpVO
     * @return int
     * @throws Exception
     */
    public void delete(OrgConnIpVO vo) throws Exception ;
}
