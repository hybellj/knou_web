package knou.lms.org.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.org.vo.OrgCodeCtgrVO;
import knou.lms.org.vo.OrgCodeLangVO;
import knou.lms.org.vo.OrgCodeVO;

public interface OrgCodeService {

	public List<OrgCodeVO> selectOrgCodeList(CreCrsVO vo) throws Exception;

	public List<OrgCodeVO> selectOrgCodeList(String codeCtgrCd)  throws Exception;
	
	public List<OrgCodeVO> selectOrgCodeList(OrgCodeVO vo) throws Exception;
	
	public List<OrgCodeVO> listCode(String orgId, boolean use) throws Exception;
	
	/**
     * 코드 정보의 목록를 반환한다.
     * @param OrgCodeCtgrVO
     * @return ProcessResultListDTO<OrgCodeVO>
     * @throws Exception
     */
    public ProcessResultListVO<OrgCodeVO> listCode(String orgId, String codeCtgrCd) throws Exception;

    public ProcessResultListVO<OrgCodeVO> listCode(String orgId, String codeCtgrCd, boolean use) throws Exception;

    public ProcessResultListVO<OrgCodeVO> listCode(String orgId, String codeCtgrCd, String langCd, boolean use) throws Exception;    
    /**
     * 코드의 정보를 조회한다.
     * @param orgId
     * @param codeCtgrCd
     * @param codeCd
     * @return OrgCodeVO
     */
    public OrgCodeVO viewCode(String orgId, String codeCtgrCd, String codeCd) throws Exception;

    /**
     *  코드 분류 전체 목록을 조회한다.
     * @param OrgCodeCtgrVO
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<OrgCodeCtgrVO> listCtgr(OrgCodeCtgrVO vo) throws Exception;
    
    /**
     * 코드 분류 페이징 목록을 조회한다.
     * @param OrgCodeCtgrVO
     * @param pageIndex
     * @param listScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<OrgCodeVO> listCodePageing(OrgCodeVO vo, int pageIndex) throws Exception;
    public ProcessResultListVO<OrgCodeCtgrVO> listCtgrPageing(OrgCodeCtgrVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<OrgCodeCtgrVO> listCtgrPageing(OrgCodeCtgrVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    
    /**
     * 코드 카테고리 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception
     */
    public int countCodeCtgr(OrgCodeCtgrVO vo) throws Exception;

    /**
     * 코드 분류 정보를 등록한다.
     * @param OrgCodeCtgrVO
     * @return String
     * @throws Exception
     */
    public int addCtgr(OrgCodeCtgrVO vo) throws Exception;
    
    /**
     * 코드 분류 상세 정보를 조회한다.
     * @param OrgCodeCtgrVO
     * @return OrgCodeCtgrVO
     * @throws Exception
     */
    public OrgCodeCtgrVO viewCtgr(OrgCodeCtgrVO vo) throws Exception;
    
    /**
     * 코드 분류 정보를 수정한다.
     * @param OrgCodeCtgrVO
     * @return int
     * @throws Exception
     */
    public int editCtgr(OrgCodeCtgrVO vo) throws Exception;
    
    /**
     * 코드 분류 정보를 삭제 한다.
     * @param OrgCodeCtgrVO
     * @return int
     * @throws Exception
     */
    public int removeCtgr(String orgId, String codeCtgrCd) throws Exception;
    
    /**
     * 코드 정보의 페이지 목록를 반환한다.
     * @param codeCtgrCd
     * @return ProcessResultListDTO<OrgCodeVO>
     * @throws Exception 
     */
    public ProcessResultListVO<OrgCodeVO> listCodePageing(OrgCodeVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<OrgCodeVO> listCodePageing(OrgCodeVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    
    /**
     * 코드 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception
     */
    public int countCode(OrgCodeVO vo) throws Exception;
    
    /**
     * 코드 정보를 등록한다.
     * @param OrgCodeVO
     * @return int
     * @throws Exception
     */
    public int addCode(OrgCodeVO vo) throws Exception;
    
    /**
     * 특정 언어키 값에 해당하는 코드의 정보를 조회한다.
     * @param cdCtgrCd
     * @param cdCd
     * @param langCd
     * @return OrgCodeVO
     */
    public OrgCodeLangVO viewCode(String orgId, String codeCtgrCd, String codeCd, String langCode) throws Exception;
    
    /**
     * 코드 정보를 수정한다.
     * @param OrgCodeVO
     * @return int
     * @throws Exception
     */
    public int editCode(OrgCodeVO vo) throws Exception;
    
    /**
     * 코드 정보를 삭제한다.
     * @param codeCtgrCd
     * @param codeCd
     * @return int
     * @throws Exception
     */
    public int removeCode(String orgId, String codeCtgrCd, String codeCd) throws Exception;
    
    /**
     * 코드 정보의 상세 정보를 조회한다. 
     * @param  OrgCodeVO 
     * @return OrgCodeVO
     * @throws Exception
      */
    public OrgCodeVO select(OrgCodeVO vo) throws Exception;

    public List<OrgCodeVO> list(CreCrsVO vo) throws Exception;

    public List<OrgCodeVO> list(String codeCtgrCd)  throws Exception;
        
    public List<OrgCodeVO> list(OrgCodeVO vo) throws Exception;
    
    
    /**
     * 코드 정보의 목록를 반환한다.
     * @param OrgCodeCtgrVO
     * @return ProcessResultListDTO<OrgCodeVO>
     * @throws Exception
     */
    public ProcessResultListVO<OrgCodeVO> listCodes(String orgId, String codeCtgrCd) throws Exception;
    public ProcessResultListVO<OrgCodeVO> listCodes(String orgId, String codeCtgrCd, boolean use) throws Exception;
    public ProcessResultListVO<OrgCodeVO> listCodes(String orgId, String codeCtgrCd, String langCd, boolean use) throws Exception;
    
    /**
     * 시스템 코드 리스트를 반환한다.
     *
     * @param codeCtgrCd
     * @return
     */
    public List<OrgCodeVO> getOrgCodeList(String codeCtgrCd) throws Exception;

}
