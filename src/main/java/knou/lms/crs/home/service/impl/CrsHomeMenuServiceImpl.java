package knou.lms.crs.home.service.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import knou.lms.crs.home.dao.CrsHomeMenuDAO;
import knou.lms.crs.home.service.CrsHomeMenuService;
import knou.lms.crs.home.vo.CrsHomeBbsMenuVO;
import knou.lms.crs.home.vo.CrsHomeMenuVO;
import knou.lms.crs.home.vo.CrsHomeVO;

/**
 *  <b>
 * @aut
 * hor Jamfam
 *
 */
@Service("crsHomeMenuService")
public class CrsHomeMenuServiceImpl 
	extends EgovAbstractServiceImpl implements CrsHomeMenuService {

	protected final Log log = LogFactory.getLog(getClass());
	
	@Autowired
	private CrsHomeMenuDAO crsHomeMenuDAO; 

	/**
     *  권한에 대한 메뉴 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return CrsHomeVO
     * @throws Exception
     */
    @Override
    public CrsHomeVO selectCrsHomeMenulist(CrsHomeMenuVO vo) throws Exception {
        CrsHomeVO resultVo = new CrsHomeVO();
        
        List<CrsHomeMenuVO> menuList = crsHomeMenuDAO.selectCrsHomeMenulist(vo);
        List<CrsHomeBbsMenuVO> menuBbsList = null;
        
        if(!"ADM".equals(vo.getAuthrtGrpcd())) {
            menuBbsList = crsHomeMenuDAO.selectCrsHomeBbsMenulist(vo);
            resultVo.setBbsMenuList(menuBbsList);
        }
        
        resultVo.setMenuList(menuList);
        
        return resultVo;
    }
    
    /**
     *  권한별 메뉴 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return CrsHomeVO
     * @throws Exception
     */
    @Override
    public CrsHomeVO selectCrsAuthHomeMenulist(CrsHomeMenuVO vo) throws Exception {
        CrsHomeVO resultVo = new CrsHomeVO();
        
        List<CrsHomeMenuVO> menuList = crsHomeMenuDAO.selectCrsAuthHomeMenulist(vo);
        List<CrsHomeBbsMenuVO> menuBbsList = null;
        
        if(!"ADM".equals(vo.getAuthrtGrpcd())) {
            menuBbsList = crsHomeMenuDAO.selectCrsHomeBbsMenulist(vo);
            resultVo.setBbsMenuList(menuBbsList);
        }
        
        resultVo.setMenuList(menuList);
        
        return resultVo;
    }

    /**
     *  과목 메뉴 게시판 리스트를 조회한다.
     * @param CrsHomeMenuVO
     * @return List<CrsHomeBbsMenuVO>
     * @throws Exception
     */
    @Override
    public List<CrsHomeBbsMenuVO> selectCrsHomeBbslist(CrsHomeMenuVO vo) throws Exception {
        
        List<CrsHomeBbsMenuVO> menuBbsList = crsHomeMenuDAO.selectCrsHomeBbsMenulist(vo);
        
        return menuBbsList;
    }
}
