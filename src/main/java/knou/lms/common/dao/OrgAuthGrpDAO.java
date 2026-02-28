package knou.lms.common.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.OrgAuthGrpVO;

/**
 *  <b>기관 - 기관 권한 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("orgAuthGrpDAO")
public interface OrgAuthGrpDAO{
	
    /**
	 * 기관 권한의 전체 목록을 조회한다. 
	 * @param  OrgAuthGrpVO 
	 * @return List
	 * @throws Exception
	 */
	public List<OrgAuthGrpVO> list(OrgAuthGrpVO vo) throws Exception;
	
     /**
	 * 기관 권한의 상세 정보를 조회한다. 
	 * @param  OrgAuthGrpVO 
	 * @return OrgAuthGrpVO
	 * @throws Exception
	 */
	public OrgAuthGrpVO select(OrgAuthGrpVO vo) throws Exception;

    /**
     * 기관 권한의 상세 정보를 등록한다.  
     * @param  OrgAuthGrpVO
     * @return String
     * @throws Exception
     */
    public void insert(OrgAuthGrpVO vo) throws Exception;
    
    /**
     * 기관 권한의 상세 정보를 수정한다. 
     * @param  OrgAuthGrpVO
     * @return int
     * @throws Exception
     */
    public int update(OrgAuthGrpVO vo) throws Exception;
    
    /**
     * 기관 권한의 상세 정보를 삭제한다.  
     * @param  OrgAuthGrpVO
     * @return int
     * @throws Exception
     */
    public int delete(OrgAuthGrpVO vo) throws Exception ;
}
