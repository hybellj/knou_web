package knou.lms.org.dao;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.org.vo.OrgCodeLangVO;

@Mapper("orgCodeLangDAO")
public interface OrgCodeLangDAO {

    /**
     * 코드 언어의 전체 목록을 조회한다. 
     * @param  OrgCodeLangVO 
     * @return List
     * @throws Exception
     */
    public List<OrgCodeLangVO> list(OrgCodeLangVO vo) throws EgovBizException;
    
    /**
     * 코드 언어의 검색된 수를 카운트 한다. 
     * @param  OrgCodeLangVO 
     * @return int
     * @throws Exception
     */
    public int count() throws Exception;
    
    /**
     * 코드 언어의 전체 목록을 조회한다. 
     * @param  OrgCodeLangVO 
     * @return List
     * @throws Exception
     */
    public List<OrgCodeLangVO> listPageing(OrgCodeLangVO vo) throws Exception;
    
    /**
     * 코드 언어의 상세 정보를 조회한다. 
     * @param  OrgCodeLangVO 
     * @return OrgCodeLangVO
     * @throws Exception
     */
    public OrgCodeLangVO select(OrgCodeLangVO vo) throws Exception;

    /**
     * 코드 언어의 상세 정보를 등록한다.  
     * @param  OrgCodeLangVO
     * @return String
     * @throws Exception
     */
    public String insert(OrgCodeLangVO vo) throws Exception;
    
    /**
     * 코드 언어의 상세 정보를 수정한다. 
     * @param  OrgCodeLangVO
     * @return int
     * @throws Exception
     */
    public int update(OrgCodeLangVO vo) throws Exception;
    
    /**
     * 코드 언어의 상세 정보를 삭제한다.  
     * @param  OrgCodeLangVO
     * @return int
     * @throws Exception
     */
    public int delete(OrgCodeLangVO vo) throws Exception;
    
    /**
     * 코드 정보의 하위 코드 언어 전체를 삭제한다.  
     * @param  OrgCodeLangVO
     * @return int
     * @throws Exception
     */
    public int deleteAll(OrgCodeLangVO vo) throws Exception;
    
    /**
     * 코드 분류 정보 하위의 코드 언어 전체를 삭제한다.  
     * @param  OrgCodeLangVO
     * @return int
     * @throws Exception
     */
    public int deleteAllByCtgr(OrgCodeLangVO vo) throws Exception;

}
