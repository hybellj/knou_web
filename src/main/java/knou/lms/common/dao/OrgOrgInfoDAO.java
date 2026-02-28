package knou.lms.common.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.OrgOrgInfoVO;

/**
 *  <b>기관 - 기관 정보 관리</b> 영역  Mapper 클래스
 *  {mapperLocations}/TbOrgOrgInfoDAO_SQL.xml
 * @author Jamfam
 *
 */
@Mapper("orgOrgInfoDAO")
public interface OrgOrgInfoDAO  {

    /**
	 * 기관 정보의 전체 목록을 조회한다. 
	 * @param  OrgOrgInfoVO 
	 * @return List
	 * @throws Exception
	 */
	public List<OrgOrgInfoVO> list(OrgOrgInfoVO vo) throws Exception;
	
    /**
	 * 기관 정보의 검색된 수를 카운트 한다. 
	 * @param  OrgOrgInfoVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(OrgOrgInfoVO vo) throws Exception;
	
    /**
	 * 기관 정보의 전체 목록을 조회한다. 
	 * @param  OrgOrgInfoVO 
	 * @return List
	 * @throws Exception
	 */
	public List<OrgOrgInfoVO> listPaging(OrgOrgInfoVO vo) throws Exception;
	
    /**
	 * 기관 정보의 상세 정보를 조회한다. 
	 * @param  OrgOrgInfoVO 
	 * @return OrgOrgInfoVO
	 * @throws Exception
	 */
	public OrgOrgInfoVO select(OrgOrgInfoVO vo) throws Exception;
	
    /**
	 * 기관 정보의 상세 정보를 조회한다. 
	 * @return String
	 * @throws Exception
	 */
	public String selectKey() throws Exception;

    /**
     * 기관 정보의 상세 정보를 등록한다.  
     * @param  OrgOrgInfoVO
     * @return String
     * @throws Exception
     */
    public String insert(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 정보의 상세 정보를 수정한다. 
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int update(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 정보의 기본 정보만 수정한다. 
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int updateInfo(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 정보의 템플릿 정보만 수정한다. 
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int updateTemplate(OrgOrgInfoVO vo) throws Exception;

    /**
     * 기관 정보의 디자인 정보만 수정한다. 
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int updateDesign(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 정보의 상세 정보를 삭제한다.  
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int delete(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관의 메뉴 버전을 가져온다. 
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int selectMenuVersion(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관의 메뉴 버전 값을 증가 시킨다. 
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int updateMenuVersion(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관의 로그 기록 횟수를 구한다.  
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int selectLogCount(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 생성시 기본 코드 분류를 등록한다.  
     * @param  OrgOrgInfoVO
     * @return String
     * @throws Exception
     */
    public String insertCodeCtgr(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 삭제시 코드 분류 전부를 삭제한다.  
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int deleteCodeCtgr(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 생성시 기본 코드를 등록한다.  
     * @param  OrgOrgInfoVO
     * @return String
     * @throws Exception
     */
    public String insertCode(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 삭제시 코드 전부를 삭제한다.  
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int deleteCode(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 생성시 사용자 정보 설정값를 등록한다.  
     * @param  OrgOrgInfoVO
     * @return String
     * @throws Exception
     */
    public String insertUserInfoCfg(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 삭제시 사용자 정보 설정값 전부를 삭제한다.  
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int deleteUserInfoCfg(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 생성시 지식분류 코드값를 등록한다.  
     * @param  OrgOrgInfoVO
     * @return String
     * @throws Exception
     */
    public String insertKnowCtgr(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 삭제시 사용자의 지식분류 코드값 전부를 삭제한다.  
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int deleteUserKnowCtgr(OrgOrgInfoVO vo) throws Exception; 
    
    /**
     * 기관 삭제시 지식분류 코드값 전부를 삭제한다.  
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int deleteKnowCtgr(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 삭제시 관련사이트 정보 삭제
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int deleteRelatedSite(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 삭제시 관련사이트 분류의 정보 삭제
     * @param  OrgOrgInfoVO
     * @return int
     * @throws Exception
     */
    public int deleteRelatedSiteCtgr(OrgOrgInfoVO vo) throws Exception;
    
}
