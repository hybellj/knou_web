package knou.lms.crs.home.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.crs.home.vo.CrsHomeBbsMenuVO;
import knou.lms.crs.home.vo.CrsHomeMenuVO;

@Mapper("crsHomeMenuDAO")
public interface CrsHomeMenuDAO {
    
    /**
     *  권한에 대한 메뉴 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return List<CrsHomeMenuVO>
     * @throws Exception
     */
    public List<CrsHomeMenuVO> selectCrsHomeMenulist(CrsHomeMenuVO vo) throws Exception;

    /**
     *  권한별 메뉴 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return List<CrsHomeMenuVO>
     * @throws Exception
     */
    public List<CrsHomeMenuVO> selectCrsAuthHomeMenulist(CrsHomeMenuVO vo) throws Exception;
    
    /**
     *  과목 대한 게시판 메뉴 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return List<CrsHomeBbsMenuVO>
     * @throws Exception
     */
    public List<CrsHomeBbsMenuVO> selectCrsHomeBbsMenulist(CrsHomeMenuVO vo) throws Exception;
    
}
