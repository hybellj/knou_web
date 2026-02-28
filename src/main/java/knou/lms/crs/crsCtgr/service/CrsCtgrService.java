package knou.lms.crs.crsCtgr.service;

import java.util.List;

import knou.lms.crs.crsCtgr.vo.CreTmCtgrVO;
import knou.lms.crs.crsCtgr.vo.CrsCtgrVO;

public interface CrsCtgrService {
    /**
     *  교과별 분류 list 조회
     * @param CrsCtgrVO
     * @return List<CrsCtgrVO>
     * @throws Exception
     */
    public List<CrsCtgrVO> listCrsCtgrTree(CrsCtgrVO vo) throws Exception;
    
    
	/**
	 * 교과별 Tree
	 * @param CreTmCtgrVO
	 * @return List<CrsCtgrVO>
	 * @throws Exception
	 */
	public List<CrsCtgrVO> ctgrTree(CrsCtgrVO vo) throws Exception;
	
	/**
     *  교과별 분류 list 조회
     * @param CrsCtgrVO
     * @return List<CrsCtgrVO>
     * @throws Exception
     */
    public List<CrsCtgrVO> listCrsCtgr(CrsCtgrVO vo) throws Exception;
    
    /**
     * 교과별 분류 부모값 조회
     * @param CrsCtgrVO
     * @return int
     * @throws Exception
     */
    public CrsCtgrVO parCrsCtgrCd(CrsCtgrVO vo) throws Exception;
    
    /**
     *  테마별 분류 list 조회
     * @param CreTmCtgrVO
     * @return List<CreTmCtgrVO>
     * @throws Exception
     */
    public List<CreTmCtgrVO> listCreTmCtgr(CreTmCtgrVO vo) throws Exception;
    
    /**
     * 테마별 분류 부모값 조회
     * @param CreTmCtgrVO
     * @return int
     * @throws Exception
     */
    public CreTmCtgrVO parCreTmCtgrCd(CreTmCtgrVO vo) throws Exception;


    public List<CreTmCtgrVO> listCreTmCtgrTree(CreTmCtgrVO creTmCtgrVo) throws Exception;

}