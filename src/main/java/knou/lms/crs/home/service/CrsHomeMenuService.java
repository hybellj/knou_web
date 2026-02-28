package knou.lms.crs.home.service;

import java.util.List;

import knou.lms.crs.home.vo.CrsHomeBbsMenuVO;
import knou.lms.crs.home.vo.CrsHomeMenuVO;
import knou.lms.crs.home.vo.CrsHomeVO;

public interface CrsHomeMenuService {
    
    /**
     *  권한에 대한 메뉴 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return CrsHomeVO
     * @throws Exception
     */
    public CrsHomeVO selectCrsHomeMenulist(CrsHomeMenuVO vo) throws Exception;
    
    /**
     *  권한별 메뉴 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return CrsHomeVO
     * @throws Exception
     */
    public CrsHomeVO selectCrsAuthHomeMenulist(CrsHomeMenuVO vo) throws Exception;   
 
    /**
     *  과목 메뉴 게시판 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return List<CrsHomeBbsMenuVO>
     * @throws Exception
     */
    public List<CrsHomeBbsMenuVO> selectCrsHomeBbslist(CrsHomeMenuVO vo) throws Exception;
}