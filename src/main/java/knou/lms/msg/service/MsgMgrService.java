package knou.lms.msg.service;

import java.util.List;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;

public interface MsgMgrService {

	public List<CmmnCdVO> selectCmmnCdList(CreCrsVO vo) throws Exception;

	public List<CmmnCdVO> selectCmmnCdList(String codeCtgrCd)  throws Exception;
	
	public List<CmmnCdVO> selectCmmnCdList(CmmnCdVO vo) throws Exception;
	
	public List<CmmnCdVO> listCode(String orgId, boolean use) throws Exception;
	
	/**
     * 코드 정보의 목록를 반환한다.
     * @param MsgMgrVO
     * @return ProcessResultListDTO<CmmnCdVO>
     * @throws Exception
     */
    public ProcessResultListVO<CmmnCdVO> listCode(String orgId, String codeCtgrCd) throws Exception;

    public ProcessResultListVO<CmmnCdVO> listCode(String orgId, String codeCtgrCd, boolean use) throws Exception;

    public ProcessResultListVO<CmmnCdVO> listCode(String orgId, String codeCtgrCd, String langCd, boolean use) throws Exception;    

    /**
     *  공통 코드 목록을 조회한다.
     * @param MsgMgrVO
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<CmmnCdVO> listCmmnCd(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 분류 페이징 목록을 조회한다.
     * @param MsgMgrVO
     * @param pageIndex
     * @param listScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<CmmnCdVO> listCmmnCdPageing(CmmnCdVO vo, int pageIndex) throws Exception;
    public ProcessResultListVO<CmmnCdVO> listCmmnCdPageing(CmmnCdVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<CmmnCdVO> listCmmnCdPageing(CmmnCdVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    
    /**
     * 코드 카테고리 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception
     */
    public int countUpCd(CmmnCdVO vo) throws Exception;

    /**
     * 코드 분류 정보를 등록한다.
     * @param MsgMgrVO
     * @return String
     * @throws Exception
     */
    public int addUpCd(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 분류 상세 정보를 조회한다.
     * @param MsgMgrVO
     * @return CmmnCdVO
     * @throws Exception
     */
    public CmmnCdVO viewUpCd(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 분류 정보를 수정한다.
     * @param MsgMgrVO
     * @return int
     * @throws Exception
     */
    public int editUpCd(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 분류 정보를 삭제 한다.
     * @param MsgMgrVO
     * @return int
     * @throws Exception
     */
    public int removeUpCd(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 정보의 페이지 목록를 반환한다.
     * @param codeCtgrCd
     * @return ProcessResultListDTO<CmmnCdVO>
     * @throws Exception 
     */
    public ProcessResultListVO<CmmnCdVO> listCodePageing(CmmnCdVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<CmmnCdVO> listCodePageing(CmmnCdVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    
    /**
     * 코드 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception
     */
    public int countCode(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 정보를 등록한다.
     * @param MsgMgrVO
     * @return int
     * @throws Exception
     */
    public int addCode(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드의 정보를 조회한다.
     * @param orgId
     * @param codeCtgrCd
     * @param codeCd
     * @return CmmnCdVO
     */
    public CmmnCdVO viewCode(String orgId, String upCd, String cd) throws Exception;

    /**
     * 특정 언어키 값에 해당하는 코드의 정보를 조회한다.
     * @param cdCtgrCd
     * @param cdCd
     * @param langCd
     * @return CmmnCdVO
     */
    public CmmnCdVO viewCode(CmmnCdVO vo) throws Exception;
	public CmmnCdVO viewCode(String orgId, String upCd, String cd, String langCd) throws Exception;

    /**
     * 코드 정보를 수정한다.
     * @param MsgMgrVO
     * @return int
     * @throws Exception
     */
    public int editCode(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 정보를 삭제한다.
     * @param codeCtgrCd
     * @param codeCd
     * @return int
     * @throws Exception
     */
    public int removeCode(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 정보의 상세 정보를 조회한다. 
     * @param  MsgMgrVO 
     * @return CmmnCdVO
     * @throws Exception
      */
//    public CmmnCdVO select(CmmnCdVO vo) throws Exception;
//
    public List<CmmnCdVO> list(CreCrsVO vo) throws Exception;

    public List<CmmnCdVO> list(String codeCtgrCd)  throws Exception;
        
    public List<CmmnCdVO> list(CmmnCdVO vo) throws Exception;
    
    
    /**
     * 코드 정보의 목록를 반환한다.
     * @param MsgMgrVO
     * @return ProcessResultListDTO<CmmnCdVO>
     * @throws Exception
     */
    public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String codeCtgrCd) throws Exception;
    public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String codeCtgrCd, boolean use) throws Exception;
    public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String codeCtgrCd, String langCd, boolean use) throws Exception;
    
    /**
     * 시스템 코드 리스트를 반환한다.
     *
     * @param codeCtgrCd
     * @return
     */
    public List<CmmnCdVO> getCmmnCdList(String codeCtgrCd) throws Exception;

}
