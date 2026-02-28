package knou.lms.common.service.impl;

import java.util.Hashtable;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.CommConst;
import knou.lms.common.dao.OrgCfgCtgrDAO;
import knou.lms.common.dao.OrgCfgDAO;
import knou.lms.common.service.OrgCfgService;
import knou.lms.common.vo.OrgCfgCtgrVO;
import knou.lms.common.vo.OrgCfgVO;
import knou.lms.common.vo.ProcessResultVO;

/**
 * <b>시스템 - 시스템 설정 정보 관리</b> 영역 Service 클래스
 * 
 * @author Jamfam
 */
@Service("orgCfgService")
public class OrgCfgServiceImpl extends EgovAbstractServiceImpl implements OrgCfgService {
    
    /**
     * 내부 변수 [캐쉬 저장소]
     * key : cfgCtgrCd.cfgCd
     */
    private final Hashtable<String, OrgCfgVO> cache = new Hashtable<String, OrgCfgVO>();

    /**
     * 캐쉬저장소의 유효성을 판단하는 버젼값
     */
    private int version = -1;
    private int compareVersion = -2;
    
    @Resource(name="orgCfgCtgrDAO")
    private OrgCfgCtgrDAO orgCfgCtgrDAO;
    
    @Resource(name="orgCfgDAO")
    private OrgCfgDAO orgCfgDAO;
    
    /**
     *  설정 분류 전체 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgCtgrVO> listCtgr(OrgCfgCtgrVO vo) throws Exception {
        
        ProcessResultVO<OrgCfgCtgrVO> resultList = new ProcessResultVO<OrgCfgCtgrVO>(); 
        List<OrgCfgCtgrVO> cfgCtgrList =  orgCfgCtgrDAO.list(vo);
        resultList.setResult(1);
        resultList.setReturnList(cfgCtgrList);
        
        return resultList;
    }

    /**
     * 설정 분류 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgCtgrVO> listCtgrPageing(OrgCfgCtgrVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultVO<OrgCfgCtgrVO> resultList = new ProcessResultVO<OrgCfgCtgrVO>(); 
        
        /** start of paging */
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(pageIndex);
        paginationInfo.setRecordCountPerPage(listScale);
        paginationInfo.setPageSize(pageScale);
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        // 전체 목록 수
        int totalCount = orgCfgCtgrDAO.count(vo);
        paginationInfo.setTotalRecordCount(totalCount);
        
        List<OrgCfgCtgrVO> cfgCtgrList =  orgCfgCtgrDAO.listPageing(vo);
        resultList.setResult(1);
        resultList.setReturnList(cfgCtgrList);
        resultList.setPageInfo(paginationInfo);
            
        return resultList;
    }

    /**
     * 설정 분류 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgCtgrVO> listCtgrPageing(OrgCfgCtgrVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listCtgrPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }

    /**
     * 설정 분류 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgCtgrVO> listCtgrPageing(OrgCfgCtgrVO vo, int pageIndex) throws Exception {
        
        return this.listCtgrPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }

    /**
     * 설정 분류 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgVO> listConfig(OrgCfgCtgrVO vo) throws Exception {
        
    	ProcessResultVO<OrgCfgVO> resultList = new ProcessResultVO<OrgCfgVO>(); 
        
        List<OrgCfgVO> cfgList =  orgCfgCtgrDAO.listConfig(vo);
        resultList.setReturnList(cfgList);
        
        return resultList;
    }

    /**
     * 설정 분류 상세 정보를 조회한다.
     * @param OrgCfgCtgrVO
     * @return OrgCfgCtgrVO
     * @throws Exception
     */
    @Override
    public OrgCfgCtgrVO viewCtgr(OrgCfgCtgrVO vo) throws Exception {

        return orgCfgCtgrDAO.select(vo);
    }

    /**
     * 설정 분류 정보를 등록한다.
     * @param OrgCfgCtgrVO
     * @return String
     * @throws Exception
     */
    @Override
    public void addCtgr(OrgCfgCtgrVO vo) throws Exception {

        orgCfgCtgrDAO.insert(vo);
    }

    /**
     * 설정 분류 정보를 수정한다.
     * @param OrgCfgCtgrVO
     * @return int
     * @throws Exception
     */
    @Override
    public void editCtgr(OrgCfgCtgrVO vo) throws Exception {
        
        orgCfgCtgrDAO.update(vo);
    }

    /**
     * 설정 분류 정보를 삭제 한다.
     * @param OrgCfgCtgrVO
     * @return void
     * @throws Exception
     */
    @Override
    public void removeCtgr(OrgCfgCtgrVO vo) throws Exception {

        // 분류 하위의 모든 설정 정보를 삭제함.
        OrgCfgVO OrgCfgVO = new OrgCfgVO();
        OrgCfgVO.setCfgCtgrCd(vo.getCfgCtgrCd());
        OrgCfgVO.setOrgId(vo.getOrgId());
        orgCfgDAO.deleteAll(OrgCfgVO);
        
        // 카테고리 삭제
        orgCfgCtgrDAO.delete(vo);
    }

    /**
     *  설정 정보 전체 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgVO> listCfg(OrgCfgVO vo) throws Exception {
        
        ProcessResultVO<OrgCfgVO> resultList = new ProcessResultVO<OrgCfgVO>(); 
        List<OrgCfgVO> cfgList =  orgCfgDAO.list(vo);
        resultList.setResult(1);
        resultList.setReturnList(cfgList);
        
        return resultList;
    }

    /**
     * 설정 정보 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgVO> listCfgPageing(OrgCfgVO vo, int pageIndex, int listScale, int pageScale) throws Exception {
        
        ProcessResultVO<OrgCfgVO> resultList = new ProcessResultVO<OrgCfgVO>(); 

        /** start of paging */
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(pageIndex);
        paginationInfo.setRecordCountPerPage(listScale);
        paginationInfo.setPageSize(pageScale);
            
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
        // 전체 목록 수
        int totalCount = orgCfgDAO.count(vo);
        paginationInfo.setTotalRecordCount(totalCount);
            
        List<OrgCfgVO> codeCtgrList =  orgCfgDAO.listPageing(vo);
        resultList.setResult(1);
        resultList.setReturnList(codeCtgrList);
        resultList.setPageInfo(paginationInfo);
        
        return resultList;
    }

    /**
     * 설정 정보 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgVO> listCfgPageing(OrgCfgVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listCfgPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }

    /**
     * 설정 정보 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgCfgVO> listCfgPageing(OrgCfgVO vo, int pageIndex) throws Exception {
        
        return this.listCfgPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }

    /**
     * 설정 정보 상세 정보를 조회한다.
     * @param OrgCfgCtgrVO
     * @return OrgCfgCtgrVO
     * @throws Exception
     */
    @Override
    public OrgCfgVO viewCfg(OrgCfgVO vo) throws Exception {
        
        return orgCfgDAO.select(vo);
    }

    /**
     * 설정 정보 상제 정보를 등록한다.
     * @param OrgCfgCtgrVO
     * @return String
     * @throws Exception
     */
    @Override
    public void addCfg(OrgCfgVO vo) throws Exception {
        
        orgCfgDAO.insert(vo);
    }

    /**
     * 설정 정보 상세 정보를 수정한다.
     * @param OrgCfgCtgrVO
     * @return void
     * @throws Exception
     */
    @Override
    public void editCfg(OrgCfgVO vo) throws Exception {
        
        orgCfgDAO.update(vo);
    }

    /**
     * 설정 정보 상세 정보를 삭제 한다.
     * @param OrgCfgCtgrVO
     * @return int
     * @throws Exception
     */
    @Override
    public void removeCfg(OrgCfgVO vo) throws Exception {
        
        orgCfgDAO.delete(vo);
    }

    /**
     * 설정 정보 상세 정보를 조회한다.
     * @param cfgCtgrCd
     * @param cfgCd
     * @return OrgCfgCtgrVO
     * @throws Exception
     */
    @Override
    public String getValue(OrgCfgVO vo) throws Exception {
        
		/* String menuKey = vo.getCfgCtgrCd()+"."+vo.getCfgCd(); */
		String menuKey = vo.getCfgCtgrCd();
		
    	if(this.isCacheChanged(vo)) {
            this.cache.clear();
            this.version += 1;
            this.compareVersion = this.version;
        }
        
        if(!this.cache.containsKey(menuKey)) {
            this.cache.put(menuKey, orgCfgDAO.select(vo)); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }

        OrgCfgVO scvo = this.cache.get(menuKey);
		/* String result = scvo.getCfgVal(); */
        String result = scvo.getCdVl();
        
        return result;
    }

    /**
     * 코드 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception 
     */
    @Override
    public int countCode(OrgCfgVO vo) throws Exception {
        
        return orgCfgDAO.count(vo);
    }

    /**
     * 코드 카테고리 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception 
     */
    @Override
    public int countCodeCtgr(OrgCfgCtgrVO vo) throws Exception {
        
        return orgCfgCtgrDAO.count(vo);
    }
    
    /**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    @SuppressWarnings("unused")
    private boolean isCacheChanged(OrgCfgVO vo) throws Exception {
        
        return (this.version != this.compareVersion) ? true : false;
    }

    /**
     * 버전값이 변경되었음을 저장한다.
     */
    @SuppressWarnings("unused")
    private void setCacheChanged(OrgCfgVO vo) throws Exception {
        
        int beforeVersion = this.version;
        this.cache.clear();
        this.compareVersion = beforeVersion+1;
    }
}
