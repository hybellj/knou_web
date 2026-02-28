package knou.lms.system.config.service.impl;

import java.util.Hashtable;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.system.config.vo.SysCfgCtgrVO;
import knou.lms.system.config.dao.SysCfgCtgrDAO;
import knou.lms.system.config.dao.SysCfgDAO;
import knou.lms.system.config.service.SysCfgService;
import knou.lms.system.config.vo.SysCfgVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 *  <b>시스템 - 시스템 설정 정보 관리</b> 영역  Service 클래스
 * @author Jamfam
 *
 */
@Service("sysCfgService")
public class SysCfgServiceImpl extends EgovAbstractServiceImpl implements SysCfgService {
	
    /**
     * 내부 변수 [캐쉬 저장소]
     * key : cfgCtgrCd.cfgCd
     */
    private final Hashtable<String, SysCfgVO> cache = new Hashtable<String, SysCfgVO>();

    /**
     * 캐쉬저장소의 유효성을 판단하는 버젼값
     */
    private int version = -1;
    private int compareVersion = -2;
    
    @Resource(name="sysCfgCtgrDAO")
    private SysCfgCtgrDAO sysCfgCtgrDAO;
    
    @Resource(name="sysCfgDAO")
    private SysCfgDAO sysCfgDAO;
    
    /**
 	 *  설정 분류 전체 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultListVO<SysCfgCtgrVO> listCtgr(SysCfgCtgrVO vo) throws Exception {
 	    
 		ProcessResultListVO<SysCfgCtgrVO> resultList = new ProcessResultListVO<SysCfgCtgrVO>(); 
 		List<SysCfgCtgrVO> cfgCtgrList =  sysCfgCtgrDAO.list(vo);
 		resultList.setResult(1);
 		resultList.setReturnList(cfgCtgrList);
 		
 		return resultList;
 	}
 	
     /**
 	 * 설정 분류 페이징 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @param pageIndex
 	 * @param listScale
 	 * @param pageScale
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultListVO<SysCfgCtgrVO> listCtgrPageing(SysCfgCtgrVO vo, 
 			int pageIndex, int listScale, int pageScale) throws Exception {
 	    
 		ProcessResultListVO<SysCfgCtgrVO> resultList = new ProcessResultListVO<SysCfgCtgrVO>(); 
 		
		/** start of paging */
		PagingInfo paginationInfo = new PagingInfo();
		paginationInfo.setCurrentPageNo(pageIndex);
		paginationInfo.setRecordCountPerPage(listScale);
		paginationInfo.setPageSize(pageScale);
		
		vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
		vo.setLastIndex(paginationInfo.getLastRecordIndex());
		
		// 전체 목록 수
		int totalCount = sysCfgCtgrDAO.count(vo);
		paginationInfo.setTotalRecordCount(totalCount);
		
		List<SysCfgCtgrVO> cfgCtgrList =  sysCfgCtgrDAO.listPageing(vo);
		resultList.setResult(1);
		resultList.setReturnList(cfgCtgrList);
		resultList.setPageInfo(paginationInfo);
 			
 		return resultList;
 	}
 	
 	/**
 	 * 설정 분류 페이징 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @param pageIndex
 	 * @param listScale
 	 * @param pageScale
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
 	public ProcessResultListVO<SysCfgVO> listConfig(SysCfgCtgrVO vo) throws Exception {
 		ProcessResultListVO<SysCfgVO> resultList = new ProcessResultListVO<SysCfgVO>(); 
 		
 		List<SysCfgVO> cfgList =  sysCfgCtgrDAO.listConfig(vo);
 		resultList.setReturnList(cfgList);
 		
 		return resultList;
 	}
	
     /**
 	 * 설정 분류 페이징 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @param pageIndex
 	 * @param listScale
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultListVO<SysCfgCtgrVO> listCtgrPageing(SysCfgCtgrVO vo, 
 			int pageIndex, int listScale) throws Exception {
 		return this.listCtgrPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
 	}
 	
     /**
 	 * 설정 분류 페이징 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @param pageIndex
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultListVO<SysCfgCtgrVO> listCtgrPageing(SysCfgCtgrVO vo, 
 			int pageIndex) throws Exception {
 		return this.listCtgrPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
 	}	
 	
 	/**
 	 * 설정 분류 상세 정보를 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @return SysCfgCtgrVO
 	 * @throws Exception
 	 */
 	@Override
	public SysCfgCtgrVO viewCtgr(SysCfgCtgrVO vo) throws Exception {
 		return sysCfgCtgrDAO.select(vo);
 	}
 	
 	/**
 	 * 설정 분류 정보를 등록한다.
 	 * @param SysCfgCtgrVO
 	 * @return String
 	 * @throws Exception
 	 */
 	@Override
	public int addCtgr(SysCfgCtgrVO vo) throws Exception {
 		return sysCfgCtgrDAO.insert(vo);
 	}	
 	
 	/**
 	 * 설정 분류 정보를 수정한다.
 	 * @param SysCfgCtgrVO
 	 * @return int
 	 * @throws Exception
 	 */
 	@Override
	public int editCtgr(SysCfgCtgrVO vo) throws Exception {
 		return sysCfgCtgrDAO.update(vo);
 	}
 	
 	/**
 	 * 설정 분류 정보를 삭제 한다.
 	 * @param SysCfgCtgrVO
 	 * @return int
 	 * @throws Exception
 	 */
 	@Override
	public int removeCtgr(String cfgCtgrCd) throws Exception {
 		//-- 분류 하위의 모든 설정 정보를 삭제함.
 		SysCfgVO sysCfgVO = new SysCfgVO();
 		sysCfgVO.setCfgCtgrCd(cfgCtgrCd);
 		sysCfgDAO.deleteAll(sysCfgVO);
 		
 		SysCfgCtgrVO sysCfgCtgrVO = new SysCfgCtgrVO();
 		sysCfgCtgrVO.setCfgCtgrCd(cfgCtgrCd);
 		
 		return sysCfgCtgrDAO.delete(sysCfgCtgrVO);
 	}
 	
    /**
 	 *  설정 정보 전체 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultListVO<SysCfgVO> listCfg(SysCfgVO vo) throws Exception {
 		ProcessResultListVO<SysCfgVO> resultList = new ProcessResultListVO<SysCfgVO>(); 
 		List<SysCfgVO> cfgList =  sysCfgDAO.list(vo);
 		resultList.setResult(1);
 		resultList.setReturnList(cfgList);
 		return resultList;
 	}
 	
     /**
 	 * 설정 정보 페이징 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @param pageIndex
 	 * @param listScale
 	 * @param pageScale
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultListVO<SysCfgVO> listCfgPageing(SysCfgVO vo, 
 			int pageIndex, int listScale, int pageScale) throws Exception {
 		ProcessResultListVO<SysCfgVO> resultList = new ProcessResultListVO<SysCfgVO>(); 
 		
		/** start of paging */
		PagingInfo paginationInfo = new PagingInfo();
		paginationInfo.setCurrentPageNo(pageIndex);
		paginationInfo.setRecordCountPerPage(listScale);
		paginationInfo.setPageSize(pageScale);
		
		vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
		vo.setLastIndex(paginationInfo.getLastRecordIndex());
		
		// 전체 목록 수
		int totalCount = sysCfgDAO.count(vo);
		paginationInfo.setTotalRecordCount(totalCount);
		
		List<SysCfgVO> codeCtgrList =  sysCfgDAO.listPageing(vo);
		resultList.setResult(1);
		resultList.setReturnList(codeCtgrList);
		resultList.setPageInfo(paginationInfo);
 			
 		return resultList;
 	}
 	
     /**
 	 * 설정 정보 페이징 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @param pageIndex
 	 * @param listScale
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultListVO<SysCfgVO> listCfgPageing(SysCfgVO vo, 
 			int pageIndex, int listScale) throws Exception {
 	    
 		return this.listCfgPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
 	}
 	
     /**
 	 * 설정 정보 페이징 목록을 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @param pageIndex
 	 * @return ProcessResultListVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultListVO<SysCfgVO> listCfgPageing(SysCfgVO vo, 
 			int pageIndex) throws Exception {
 		return this.listCfgPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
 	}	
 	
 	/**
 	 * 설정 정보 상세 정보를 조회한다.
 	 * @param SysCfgCtgrVO
 	 * @return SysCfgCtgrVO
 	 * @throws Exception
 	 */
 	@Override
	public SysCfgVO viewCfg(SysCfgVO vo) throws Exception {
 		return sysCfgDAO.select(vo);
 	}
 	
 	/**
 	 * 설정 정보 상제 정보를 등록한다.
 	 * @param SysCfgCtgrVO
 	 * @return String
 	 * @throws Exception
 	 */
 	@Override
	public int addCfg(SysCfgVO vo) throws Exception {
 		return sysCfgDAO.insert(vo);
 	}	
 	
 	/**
 	 * 설정 정보 상세 정보를 수정한다.
 	 * @param SysCfgCtgrVO
 	 * @return int
 	 * @throws Exception
 	 */
 	@Override
	public void editCfg(SysCfgVO vo) throws Exception {
 		sysCfgDAO.update(vo);
 	}
 	
 	/**
 	 * 설정 정보 상세 정보를 삭제 한다.
 	 * @param SysCfgCtgrVO
 	 * @return int
 	 * @throws Exception
 	 */
 	@Override
	public int removeCfg(SysCfgVO vo) throws Exception {
 		return sysCfgDAO.delete(vo);
 	} 
 	
 	/**
 	 * 설정 정보 상세 정보를 조회한다.
 	 * @param cfgCtgrCd
 	 * @param cfgCd
 	 * @return SysCfgCtgrVO
 	 * @throws Exception
 	 */
 	@Override
	public String getValue(String cfgCtgrCd, String cfgCd) throws Exception {
 		SysCfgVO scvo = new SysCfgVO();
 		scvo.setCfgCtgrCd(cfgCtgrCd);
 		scvo.setCfgCd(cfgCd);
 		
 		String menuKey = cfgCtgrCd+"."+cfgCd;

        if(this.isCacheChanged(scvo)) {
            this.cache.clear();
            this.version += 1;
            this.compareVersion = this.version;
        }
        
        if(!this.cache.containsKey(menuKey)) {
            this.cache.put(menuKey, sysCfgDAO.select(scvo)); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }

        scvo = this.cache.get(menuKey);
 		String result = scvo.getCfgVal();
 		return result;
 	}

    /*****************************************************
     * <p>
     * 설정 관리 등록.
     * <p>
     * 시스템 설정 관리 정보를 설정 관리로 insert 한다.
     *
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/
    @Override
    public int addOrgSysCfgCtgr(SysCfgCtgrVO vo) throws Exception {
        return sysCfgCtgrDAO.insertOrg(vo);
    } 	
    
    /**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    private boolean isCacheChanged(SysCfgVO vo) throws Exception {
        return (this.version != this.compareVersion) ? true : false;
    }

    /**
     * 버전값이 변경되었음을 저장한다.
     */
    @SuppressWarnings("unused")
	private void setCacheChanged(SysCfgVO vo) throws Exception {
        int beforeVersion = this.version;
        this.cache.clear();
        this.compareVersion = beforeVersion+1;
    }

}
