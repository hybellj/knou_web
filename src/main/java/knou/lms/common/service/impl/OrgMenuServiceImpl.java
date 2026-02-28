package knou.lms.common.service.impl;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.dao.OrgAuthGrpDAO;
import knou.lms.common.dao.OrgAuthGrpLangDAO;
import knou.lms.common.dao.OrgAuthGrpMenuDAO;
import knou.lms.common.dao.OrgMenuDAO;
import knou.lms.common.dao.OrgOrgInfoDAO;
import knou.lms.common.service.OrgMenuService;
import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.common.vo.OrgAuthGrpMenuVO;
import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultListVO;

/**
 *  <b>기관 - 기관 메뉴 관리</b> 영역  Service 클래스
 * @author Jamfam
 *
 */
@Service("orgMenuService")
public class OrgMenuServiceImpl extends EgovAbstractServiceImpl implements OrgMenuService {

	/**
	 * 메뉴값을 저장하는 내부 변수 [캐쉬 저장소]
	 * key : menuType + "_" + authGrp
	 * value : 해당되는 rootMenuDTO
	 */
	private final Hashtable<String, OrgMenuVO> menuCache = new Hashtable<String, OrgMenuVO>();
	
	/**
	 * 메뉴값을 저장하는 내부 변수 [캐쉬 저장소]
	 * key : vo.getMenuType()+"."+vo.getOrgId()+"."+vo.getMenuCd()
	 * value : 해당되는 rootMenuDTO
	 */
	private final Hashtable<String, OrgMenuVO> viewMenuCache = new Hashtable<String, OrgMenuVO>();

	/**
	 * 캐쉬저장소의 유효성을 판단하는 버젼값
	 */
	private int menuVersion = -1;
	private int menuCompareVersion = -2;
	
	/**
     * 내부 변수 [캐쉬 저장소]
     * key : vo.getOrgId()+"."+vo.getMenuType()+"."+vo.getAuthrtGrpcd()
     */
    private final Hashtable<String, Object> cache = new Hashtable<String, Object>();

    /**
     * 캐쉬저장소의 유효성을 판단하는 버젼값
     */
    private int version = -1;
    private int compareVersion = -2;

    @Resource(name="orgAuthGrpDAO")
    private OrgAuthGrpDAO orgAuthGrpDAO;
    
    @Resource(name="orgAuthGrpLangDAO")
    private OrgAuthGrpLangDAO orgAuthGrpLangDAO;
	
    @Resource(name="orgAuthGrpMenuDAO")
    private OrgAuthGrpMenuDAO 	orgAuthGrpMenuDAO;

    @Resource(name="orgMenuDAO")
    private OrgMenuDAO orgMenuDAO;

    @Resource(name="orgOrgInfoDAO")
    private OrgOrgInfoDAO orgOrgInfoDAO;
   
    /**
     *  권한의 전체 목록을 조회한다.
     * @param OrgAuthGrpVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<OrgAuthGrpVO> listAuthGrp(OrgAuthGrpVO vo) throws Exception {

        String menuKey = vo.getOrgId()+"."+vo.getAuthrtGrpcd()+"."+vo.getAuthrtCd();

        if(this.isCacheChanged()) {
            this.cache.clear();
            this.version += 1;
            this.compareVersion = this.version;
        }
        
        if(!this.cache.containsKey(menuKey)) {
            this.cache.put(menuKey, this.rootListAuthGrpFromDB(vo)); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }
        
        // 값 변경시 cache value 변경
        List<OrgAuthGrpVO> oList = this.rootListAuthGrpFromDB(vo);
        List<OrgAuthGrpVO> cList = (List<OrgAuthGrpVO>)this.cache.get(menuKey);
        if(!oList.containsAll(cList)) {
            this.cache.put(menuKey, this.rootListAuthGrpFromDB(vo));
        }
        ProcessResultListVO<OrgAuthGrpVO> resultList = new ProcessResultListVO<OrgAuthGrpVO>(); 
        resultList.setReturnList((List<OrgAuthGrpVO>)this.cache.get(menuKey));
        resultList.setResult(1);
        
        return resultList;
    }
    
    /**
     * 실제 DB에서 권한을 검색하여, 언어별 조회 하여 OrgAuthGrpVO 반환
     * @param orgId : 기관 코드 (필수)
     * @param menuType : 메뉴 유형 (필수)
     * @return ProcessResultListDTO
     */
    private List<OrgAuthGrpVO> rootListAuthGrpFromDB(OrgAuthGrpVO vo) throws Exception {
        List<OrgAuthGrpVO> result =  orgAuthGrpDAO.list(vo);
        List<OrgAuthGrpVO> authGrpList = new ArrayList<OrgAuthGrpVO>();

        for(OrgAuthGrpVO sagvo : result) {
            OrgAuthGrpVO saglvo = new OrgAuthGrpVO();
            saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
            saglvo.setAuthrtCd(sagvo.getAuthrtCd());
            saglvo.setOrgId(sagvo.getOrgId());

            List<OrgAuthGrpVO> authGrpLangList = orgAuthGrpDAO.list(saglvo);
            sagvo.setAuthGrpLangList(authGrpLangList);
            authGrpList.add(sagvo);
        }       
        return authGrpList;
    }

    /**
     * 권한의 상세 정보를 조회한다.
     * @param OrgAuthGrpVO
     * @return OrgAuthGrpVO
     * @throws Exception
     */
    @Override
    public OrgAuthGrpVO viewAuthGrp(OrgAuthGrpVO vo) throws Exception {
        vo = orgAuthGrpDAO.select(vo);
        OrgAuthGrpVO saglvo = new OrgAuthGrpVO();
        saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
        saglvo.setAuthrtCd(vo.getAuthrtCd());
        saglvo.setOrgId(vo.getOrgId());

        List<OrgAuthGrpVO> authGrpLangList = orgAuthGrpDAO.list(saglvo);
        vo.setAuthGrpLangList(authGrpLangList);
        return vo;
    }
    
    /**
     * 권한의 상세 정보를 등록한다.
     * @param OrgAuthGrpVO
     * @return String
     * @throws Exception
     */
    @Override
    public String addAuthGrp(OrgAuthGrpVO vo) throws Exception {
        orgAuthGrpDAO.insert(vo);
        String result = "1"; 
        List<OrgAuthGrpVO> authGrpLangList = vo.getAuthGrpLangList();
        for(OrgAuthGrpVO saglvo : authGrpLangList) {
            saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
            saglvo.setAuthrtCd(vo.getAuthrtCd());
            saglvo.setOrgId(vo.getOrgId());

            if(saglvo.getAuthrtGrpExpln()  == null || saglvo.getAuthrtGrpExpln() == "") {
                saglvo.setAuthrtGrpExpln(vo.getAuthrtGrpnm());
            }

            orgAuthGrpLangDAO.merge(saglvo);
        }
        return result;
    }
    
    /**
     * 권한의 상세 정보를 수정한다.
     * @param OrgAuthGrpVO
     * @return int
     * @throws Exception
     */
    @Override
    public int editAuthGrp(OrgAuthGrpVO vo) throws Exception {
        int result = orgAuthGrpDAO.update(vo);
        List<OrgAuthGrpVO> authGrpLangList = vo.getAuthGrpLangList();
        for(OrgAuthGrpVO saglvo : authGrpLangList) {
            saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
            saglvo.setAuthrtCd(vo.getAuthrtCd());
            saglvo.setOrgId(vo.getOrgId());

            if(saglvo.getAuthrtGrpExpln()  == null || saglvo.getAuthrtGrpExpln() == "") {
                saglvo.setAuthrtGrpExpln(vo.getAuthrtGrpnm());
            }

            orgAuthGrpLangDAO.merge(saglvo);
        }
        return result;
    }
    
    /**
     * 권한의 상세 정보를 삭제 한다.
     * @param OrgAuthGrpVO
     * @return int
     * @throws Exception
     */
    @Override
    public int removeAuthGrp(OrgAuthGrpVO vo) throws Exception {
        OrgAuthGrpVO saglvo = new OrgAuthGrpVO();
        saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
        saglvo.setAuthrtCd(vo.getAuthrtCd());
        orgAuthGrpLangDAO.deleteAll(saglvo);
        return orgAuthGrpDAO.delete(vo);
    }
    
    /**
     *  메뉴의 전체 목록을 트리 형태로 조회한다.
     * @param OrgMenuVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<OrgMenuVO> listTreeMenu(OrgMenuVO vo) throws Exception {

        ProcessResultListVO<OrgMenuVO> resultList = new ProcessResultListVO<OrgMenuVO>();
        List<OrgMenuVO> result =  this.listMenuByDB(vo);

        //최상단용 VO 만들기
        OrgMenuVO smvo = new OrgMenuVO();

        //-- 트리형태로 목록을 구성하여 내보낸다.
        for(OrgMenuVO parent : result) {
            if(StringUtil.isNull(parent.getParMenuCd())) {
                smvo.addSubMenu(parent);
            }
            for(OrgMenuVO child : result) {
                if(parent.getMenuCd().equals(child.getParMenuCd())) {
                    parent.addSubMenu(child);
                }
            }
        }
        //반환할 리스트 만들기
        resultList.setReturnList(smvo.getSubList());
        return resultList;
    }

    /**
 	 *  메뉴의 전체 목록을 디비에서 조회한다.
 	 * @param OrgMenuVO
 	 * @return ProcessResultVO
 	 * @throws Exception
 	 */
	private List<OrgMenuVO> listMenuByDB(OrgMenuVO vo) throws Exception {
 		List<OrgMenuVO> menuList =  orgMenuDAO.list(vo);

 		return menuList;
 	}

	/**
	 * 기관의 권한 메뉴 조회
	 * 하위 메뉴를 포함한 최상위 메뉴 DTO를 반환함.
	 * @param dto.orgId : 기관 코드 (필수)
	 * @param dto.menuType : 메뉴 유형 (필수)
	 * @return ProcessResultListDTO
	 */
	@Override
	public OrgMenuVO listAuthGrpTreeMenu(OrgMenuVO vo) throws Exception {

		OrgOrgInfoVO ooivo = new OrgOrgInfoVO();
		ooivo.setOrgId(vo.getOrgId());

		String menuKey = vo.getOrgId()+"."+vo.getAuthrtGrpcd()+"."+vo.getAuthrtCd();
		OrgMenuVO rootMenu = null;

		if(this.isMenuChanged(ooivo)) {
			this.menuCache.clear();
			orgOrgInfoDAO.updateMenuVersion(ooivo);
			this.menuVersion = orgOrgInfoDAO.selectMenuVersion(ooivo);
			this.menuCompareVersion = this.menuVersion;
		}

		if(!this.menuCache.containsKey(menuKey)) {
			this.menuCache.put(menuKey, this.rootMenuVOFromDB(vo)); //캐시가 없는 경우 DB값을 가져옴.
		} else {
			//-- 캐시가 있는 경우 아무것도 안해도됨.
		}

		rootMenu = this.menuCache.get(menuKey);

		return findMenuByMenuCd(rootMenu, vo.getMenuCd());
	}

	/**
	 * 실제 DB에서 메뉴를 검색하여, 상하위 구조화 하여 menuDTO 반환
	 * 하위 메뉴를 포함한 최상위 메뉴 DTO를 반환함.
	 * @param dto.orgId : 기관 코드 (필수)
	 * @param dto.menuType : 메뉴 유형 (필수)
	 * @return ProcessResultListDTO
	 */
	private OrgMenuVO rootMenuVOFromDB(OrgMenuVO vo) throws Exception {
		//-- 최상위 메뉴 DTO 초기화 셋팅
		OrgMenuVO omvo = new OrgMenuVO();
		omvo.setOrgId(vo.getOrgId());
		omvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		omvo.setMenuCd("ROOTMENU");
		omvo.setMenuNm("ROOTMENU");
		omvo.setAuthrtCd(vo.getAuthrtCd());
		omvo.setParMenuCd("");
		omvo.setMenuLvl(0);

		//--- 기관의 메뉴 목록 전체를 가져와 Tree 형태로 구조화 한다.
		List<OrgMenuVO> resultList = orgMenuDAO.listAuthGrpMenu(omvo);
		for(OrgMenuVO parent : resultList) {
			if(StringUtil.isNull(parent.getParMenuCd())) {
				omvo.addSubMenu(parent);
			}
			for(OrgMenuVO child : resultList) {
				if(parent.getMenuCd().equals(child.getParMenuCd())) {
					parent.addSubMenu(child);
				}
			}
		}
		return omvo;
	}

	/**
	 * 주어진 MenuDTO에서 menuCd에 해당되는 메뉴를 찾아서 반환한다.
	 * @param rootMenu 찾고자 하는 대상 루트메뉴
	 * @param menuCd 찾을 MenuCd
	 * @return 찾아진 MenuDTO, 없을 경우 null 반환.
	 */
	@Override
	public OrgMenuVO findMenuByMenuCd(OrgMenuVO rootMenu, String menuCd) {
		// rootMenu가 menuCd와 일치하거나,
		// 주어진 검색키(menuCd)가 없으면 바로 rootMenu를 반환. (기본값으로 rootMenu가 반환)
		if(StringUtil.isNull(menuCd) || rootMenu.getMenuCd().equals(menuCd))
			return rootMenu;

		OrgMenuVO result = null;

		// childMenu가 있을 경우
		if(rootMenu.getSubList().size() > 0) {
			for(OrgMenuVO current : rootMenu.getSubList()) {
				// 탐색 및 자식메뉴들에 대한 재귀호출
				if(current.getMenuCd().equals(menuCd)) {
					return current;
				} else {
					result = findMenuByMenuCd(current, menuCd);
					if(result != null)
						return result;
				}
			}
		}
		return result;
	}

	/**
	 * 주어진 MenuDTO에서 menuCd에 해당되는 메뉴를 찾아서 반환한다.
	 * @param rootMenu 찾고자 하는 대상 루트메뉴
	 * @param menuCd 찾을 MenuCd
	 * @return 찾아진 MenuDTO, 없을 경우 null 반환.
	 */
	@Override
	public OrgMenuVO findParMenuByMenuCd(OrgMenuVO rootMenu, String parMenuCd) {
		// rootMenu가 menuCd와 일치하거나,
		// 주어진 검색키(menuCd)가 없으면 바로 rootMenu를 반환. (기본값으로 rootMenu가 반환)
		if(StringUtil.isNull(parMenuCd) || rootMenu.getMenuCd().equals(parMenuCd))
			return rootMenu;

		OrgMenuVO result = null;

		// childMenu가 있을 경우
		if(rootMenu.getSubList().size() > 0) {
			for(OrgMenuVO current : rootMenu.getSubList()) {
				// 탐색 및 자식메뉴들에 대한 재귀호출
				if(current.getParMenuCd().equals(parMenuCd)) {
					return current;
				} else {
					result = findMenuByMenuCd(current, parMenuCd);
					if(result != null)
						return result;
				}
			}
		}
		return result;
	}
	
	/**
	 * 기관 메뉴의 단일 레코드를 반환한다.
	 * @param dto.orgId : 기관 코드 (필수)
	 * @param dto.menuType : 메뉴 유형 (필수)
	 * @param dto.menuCd : 메뉴 코드 (필수)
	 * @return ProcessResultListDTO
	 */
	@Override
	public OrgMenuVO viewMenu(OrgMenuVO vo) throws Exception {
		
		String menuKey = vo.getAuthrtGrpcd()+"."+vo.getOrgId()+"."+vo.getMenuCd();

        if(this.isViewMenuCacheChanged()) {
            this.viewMenuCache.clear();
            this.version += 1;
            this.compareVersion = this.version;
        }
        
        if(!this.viewMenuCache.containsKey(menuKey)) {
            this.viewMenuCache.put(menuKey, this.rootViewMenuFromDB(vo)); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }
        
        return (OrgMenuVO)this.viewMenuCache.get(menuKey);
	}
	
	public OrgMenuVO rootViewMenuFromDB(OrgMenuVO vo) throws Exception {
        vo = orgMenuDAO.select(vo);

        return vo;
	}

 	/**
 	 * 기관의 메뉴를 등록한다.
 	 * @param OrgMenuVO
 	 * @return String
 	 * @throws Exception
 	 */
	@Override
	public String addMenu(OrgMenuVO vo) throws Exception {

		String orgId = vo.getOrgId();
		String option1 = StringUtil.nvl(vo.getOptnCtgrCd1(),""); //-- bbs, page
		String option2 = StringUtil.nvl(vo.getOptnCtgrCd2(),""); //-- bbsCd, pageCd

		// 상위 메뉴 정보 조회
		OrgMenuVO parentMenu = new OrgMenuVO();
		parentMenu.setOrgId(vo.getOrgId());
		parentMenu.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		parentMenu.setMenuCd(vo.getParMenuCd());
		parentMenu.setAuthrtCd(vo.getAuthrtCd());

		if(vo.getParMenuCd() == null || "".equals(vo.getParMenuCd())){
			parentMenu.setMenuLvl(0);
		}else{
			parentMenu = orgMenuDAO.select(parentMenu);
		}

		String menuCd = vo.getMenuCd();
		if("Y".equals(vo.getAutoMakeYn())) {
			//---- 메뉴 코드 신규 생성
			menuCd = IdGenerator.getNewId("MH");
			//menuCd = orgMenuDAO.selectKey();
		}

		//---- 신규 메뉴코드 세팅
		vo.setMenuCd(menuCd);

		//---- 메뉴 레벨 : 상위 메뉴 레벨 + 1
		vo.setMenuLvl(parentMenu.getMenuLvl()+1);

		//---- 메뉴 경로 : 상위 메뉴 경로 + 현제 메뉴 코드
		vo.setMenuPath(StringUtil.nvl(parentMenu.getMenuPath(),"")+"|"+menuCd);
		
		//---- 메뉴 상위 빈값 처리
		if("".equals(StringUtil.nvl(vo.getParMenuCd())))vo.setParMenuCd(null);

		//-- 메뉴 등록
		orgMenuDAO.insert(vo);
		String result = "1";

		OrgOrgInfoVO ooivo = new OrgOrgInfoVO();
		ooivo.setOrgId(vo.getOrgId());

		this.setMenuChanged(ooivo);	// DB의 변경 여부를 기록

		String[] menuList = StringUtil.split(vo.getMenuCd(),"|");
		String[] creList = {};
		String[] viewList = StringUtil.split(vo.getMenuCd(),"|");

		List<OrgAuthGrpMenuVO> authGroupMenuArray = new ArrayList<OrgAuthGrpMenuVO>();

		for(int i=0;i<viewList.length;i++) {
			makeAuthGroupMenu(vo.getOrgId(), vo.getAuthrtGrpcd(), vo.getAuthrtCd(), menuList[i], authGroupMenuArray, creList,viewList);
		}
		
		for(int i=0; i < authGroupMenuArray.size();i++) {
			OrgAuthGrpMenuVO ioagmvo = authGroupMenuArray.get(i);
			orgAuthGrpMenuDAO.merge(ioagmvo);
		}
		return result;
	}

 	/**
 	 * 기관의 메뉴를 수정한다.
 	 * @param OrgMenuVO
 	 * @return int
 	 * @throws Exception
 	 */
	@Override
	public int editMenu(OrgMenuVO vo) throws Exception {
		//-- 기존의 메뉴 정보를 가져온다.
		// 변경전의 메뉴 Path를 가져와 셋팅한다.
		OrgMenuVO oldMenuVO = orgMenuDAO.select(vo);
		vo.setMenuPath(oldMenuVO.getMenuPath());

		//-- 메뉴 정보 Update
		int result = orgMenuDAO.update(vo);

		OrgOrgInfoVO ooivo = new OrgOrgInfoVO();
		ooivo.setOrgId(vo.getOrgId());
		this.setMenuChanged(ooivo);	// DB의 변경 여부를 기록

		return result;
	}

 	/**
 	 * 기관의 메뉴를 삭제한다.
 	 * @param OrgMenuVO
 	 * @return int
 	 * @throws Exception
 	 */
	@Override
	public int removeMenu(OrgMenuVO vo) throws Exception {

		//-- 메뉴 정보 검색
		vo = orgMenuDAO.select(vo);

		OrgOrgInfoVO ooivo = new OrgOrgInfoVO();
		ooivo.setOrgId(vo.getOrgId());

		String option1 = vo.getOptnCtgrCd1(); // bbs, page
		String option2 = vo.getOptnCtgrCd2(); // bbs_cd, page_cd

		//-- 권한 그룹 값 셋팅
		OrgAuthGrpMenuVO oagmvo = new OrgAuthGrpMenuVO();
		oagmvo.setOrgId(vo.getOrgId());
		oagmvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		oagmvo.setMenuCd(vo.getMenuCd());

		// 권한 그룹 메뉴 삭제
		orgAuthGrpMenuDAO.delete(oagmvo);

		//-- DB 정보 삭제
		int result = orgMenuDAO.delete(vo);

		// DB의 변경 여부를 기록
		this.setMenuChanged(ooivo);

		return result;
	}

 	/**
 	 * 기관의 메뉴의 순서를 변경한다.
 	 * @param OrgMenuVO
 	 * @return int
 	 * @throws Exception
 	 */
	@Override
	public int moveMenu(OrgMenuVO vo, String moveType) throws Exception {

		//-- 상위 메뉴의 코드를 이용해 같은 Level의 메뉴 목록을 조회한다.
		OrgMenuVO parMenuVO = new OrgMenuVO();
		parMenuVO.setOrgId(vo.getOrgId());
		parMenuVO.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		parMenuVO.setMenuCd(vo.getMenuCd());
		parMenuVO = orgMenuDAO.select(parMenuVO);

		OrgOrgInfoVO ooivo = new OrgOrgInfoVO();
		ooivo.setOrgId(vo.getOrgId());

		List<OrgMenuVO> orgMenuList = orgMenuDAO.list(parMenuVO);
		List<OrgMenuVO> newMenuList = new ArrayList<OrgMenuVO>();
		int lineCnt = 0;
		if("up".equals(moveType)) {
			//-- 메뉴 위로.
			for(OrgMenuVO somvo : orgMenuList) {
				//-- 메뉴 코드가 같으면 하나 위의 omdto를 가져오고. 작업해 보자
				if(somvo.getMenuCd().equals(vo.getMenuCd())) {
					OrgMenuVO ssomvo = newMenuList.get(lineCnt - 1); // 하나 위의 메뉴 받아오기
					newMenuList.remove(lineCnt - 1); //-- 하나위의 목록을 삭제
					newMenuList.add(somvo);
					newMenuList.add(ssomvo);
				} else {
					newMenuList.add(somvo);
				}
				lineCnt++;
			}
		} else if("down".equals(moveType)) {
			//-- 메뉴 아래로
			OrgMenuVO nomdto = null;

			for(OrgMenuVO somvo : orgMenuList) {
				if(somvo.getMenuCd().equals(vo.getMenuCd())) {
					nomdto = somvo;
				} else {
					newMenuList.add(somvo);
					if(ValidationUtils.isNotEmpty(nomdto)) {
						newMenuList.add(nomdto);
						nomdto = null;
					}
				}
			}
		}
		int order = 0;
		for(OrgMenuVO ddto : newMenuList) {
			order++;
			ddto.setMenuOdr(order);
			orgMenuDAO.update(ddto);
		}
		this.setMenuChanged(ooivo);	// DB의 변경 여부를 기록

		return 1;
	}

	/**
	 * 기관의 메뉴의 순서를 변경한다.
	 * @param OrgMenuVO
	 * @return int
	 * @throws Exception
	 */
	@Override
	public int sortMenu(OrgMenuVO vo) throws Exception {

		String[] menuList = StringUtil.split(vo.getMenuCd(),"|");

		// 하위 코드 목록을 한꺼번에 조회
		OrgMenuVO omvo = new OrgMenuVO();
		omvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		omvo.setAuthrtCd(vo.getAuthrtCd());
		omvo.setOrgId(vo.getOrgId());

		OrgOrgInfoVO ooivo = new OrgOrgInfoVO();
		ooivo.setOrgId(vo.getOrgId());

		List<OrgMenuVO> menuArray = orgMenuDAO.list(omvo);

		// 이중 포문으로 menuArray에 변경된 order를 다시 저장
		// 만약 파라매터로 코드키가 누락되는 경우가 있다면... 로직 수정 필요.
		for(OrgMenuVO iomvo : menuArray) {
			for(int order = 0; order < menuList.length; order++) {
				if(iomvo.getMenuCd().equals(menuList[order])) {
					iomvo.setMenuOdr(order+1);	// 1부터 차례로 순서값을 지정
					orgMenuDAO.update(iomvo);
				}
			}
		}
		// DB의 변경 여부를 기록
		this.setMenuChanged(ooivo);
		return 1;
	}

 	/**
 	 * 기관의 메뉴를 초기화 한다.
 	 * @param OrgMenuVO
 	 * @return int
 	 * @throws Exception
 	 */
	@Override
	public String initMenu(OrgMenuVO vo) throws Exception {

		OrgOrgInfoVO ooivo = new OrgOrgInfoVO();
		ooivo.setOrgId(vo.getOrgId());

		//-- 설정값 셋팅.
		OrgAuthGrpMenuVO oagmvo = new OrgAuthGrpMenuVO();
		oagmvo.setOrgId(vo.getOrgId());
		oagmvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		oagmvo.setRgtrId(vo.getRgtrId());
		oagmvo.setMdfrId(vo.getMdfrId());

		//--- 기존 정보 삭제.
		orgAuthGrpMenuDAO.deleteInit(oagmvo);

		//-- 단계별 메늏 삭제.. 3, 2, 1
		vo.setMenuLvl(3);
		orgMenuDAO.deleteByMenuLvl(vo);

		vo.setMenuLvl(2);
		orgMenuDAO.deleteByMenuLvl(vo);

		vo.setMenuLvl(1);
		orgMenuDAO.deleteByMenuLvl(vo);

		//-- 메뉴 초기화 등록
		orgMenuDAO.insertInit(vo);
		String result = "1";
		orgAuthGrpMenuDAO.insertInit(oagmvo);

		this.setMenuChanged(ooivo);	// DB의 변경 여부를 기록

		return result;
	}

 	/**
 	 * 기관의 권한 메뉴를 등록 한다.
 	 * @param OrgAuthGrpMenuVO
 	 * @return int
 	 * @throws Exception
 	 */
	@Override
	public int addAuthGrpMenu(OrgAuthGrpMenuVO vo) throws Exception {

		OrgOrgInfoVO ooivo = new OrgOrgInfoVO();
		ooivo.setOrgId(vo.getOrgId());

		String[] menuList = StringUtil.split(vo.getMenuArray(),"|");
		String[] viewList = StringUtil.split(vo.getViewAuthArray(),"|");
		String[] creList = StringUtil.split(vo.getCreAuthArray(),"|");

		List<OrgAuthGrpMenuVO> authGroupMenuArray = new ArrayList<OrgAuthGrpMenuVO>();

		for(int i=0;i<menuList.length;i++) {
		    makeAuthGroupMenu(vo.getOrgId(), vo.getAuthrtGrpcd(), vo.getAuthrtCd(), menuList[i], authGroupMenuArray, creList,viewList);
		}
		for(int i=0; i < authGroupMenuArray.size();i++) {
		    OrgAuthGrpMenuVO ioagmvo = authGroupMenuArray.get(i);
		    orgAuthGrpMenuDAO.merge(ioagmvo);
		}

		// DB의 변경 여부를 기록
		this.setMenuChanged(ooivo);

		// 성공처리를 표현하는 ProcessResultDTO<Object>를 반환.
		return 1;
	}

	private void makeAuthGroupMenu(String orgId, String menuType, String authGrpCd,
			String menuCd, List<OrgAuthGrpMenuVO> menuList, String[] creList,String[] viewList) throws Exception {
		OrgMenuVO omvo = new OrgMenuVO();
		omvo.setOrgId(orgId);
		omvo.setAuthrtGrpcd(menuType);
		omvo.setMenuCd(menuCd);
		omvo.setAuthrtCd(authGrpCd);
		omvo = orgMenuDAO.select(omvo);

		if(!"".equals(StringUtil.nvl(omvo.getParMenuCd()))) {
			makeAuthGroupMenu(orgId, menuType, authGrpCd, omvo.getParMenuCd(), menuList, creList,viewList);
		}

		OrgAuthGrpMenuVO ioagmvo = new OrgAuthGrpMenuVO();
		String creAuth = "N";
		String viewAuth = "N";
		for(int j=0;j<creList.length;j++){
			if(menuCd.equals(creList[j])) creAuth = "Y";
		}
		for(int j=0;j<viewList.length;j++){
		    if(menuCd.equals(viewList[j])) viewAuth = "Y";
		}

		ioagmvo.setOrgId(orgId);
		ioagmvo.setAuthrtGrpcd(menuType);
		ioagmvo.setAuthrtCd(authGrpCd);
		ioagmvo.setMenuCd(menuCd);
		ioagmvo.setViewAuth(viewAuth);
		ioagmvo.setCreAuth(creAuth);
		ioagmvo.setModAuth(creAuth);
		ioagmvo.setDelAuth(creAuth);
		ioagmvo.setRgtrId("USR000000001");
		ioagmvo.setMdfrId("USR000000001");

		menuList.add(ioagmvo);
	}

 	/**
 	 * 기관 메뉴의 권한 정보 조회
 	 * @param OrgAuthGrpMenuVO
 	 * @return int
 	 * @throws Exception
 	 */
	@Override
	public OrgMenuVO viewAuthorizeByMenu(OrgMenuVO vo) throws Exception {
		// 캐쉬 태우기 검토
		return orgMenuDAO.selectAuthorizeByMenu(vo);
	}

	/**
	 * 메뉴의 버젼값을 DB와 비교한다.
	 * @return true:변경됨, false:변경되지 않음
	 */
	@SuppressWarnings("unused")
    private boolean isMenuChanged(OrgOrgInfoVO vo) throws Exception {
		return (this.menuVersion != this.menuCompareVersion) ? true : false;
	}

	/**
	 * 메뉴가 변경되었음을 DB에 저장한다.
	 */
	@SuppressWarnings("unused")
    private void setMenuChanged(OrgOrgInfoVO vo) throws Exception {
	    this.menuCache.clear();
	    orgOrgInfoDAO.updateMenuVersion(vo);
        this.menuCompareVersion = orgOrgInfoDAO.selectMenuVersion(vo);
	}
	
	/**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    @SuppressWarnings("unused")
    private boolean isViewMenuCacheChanged() throws Exception {
        return (this.version != this.compareVersion) ? true : false;
    }

    /**
     * 버전값이 변경되었음을 저장한다.
     */
    @SuppressWarnings("unused")
    private void setViewMenuCacheChanged() throws Exception {
        int beforeVersion = this.version;
        this.viewMenuCache.clear();
        this.compareVersion = beforeVersion+1;
    }
    
    /**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    @SuppressWarnings("unused")
    private boolean isCacheChanged() throws Exception {
        return (this.version != this.compareVersion) ? true : false;
    }
    
    /**
     * 버전값이 변경되었음을 저장한다.
     */
    @SuppressWarnings("unused")
    private void setCacheChanged() throws Exception {
        int beforeVersion = this.version;
        this.cache.clear();
        this.compareVersion = beforeVersion+1;
    }

    /**
     *  기관 권한 언어의 메뉴별 목록을 조회한다.
     * @param OrgAuthGrpVO
     * @return List
     * @throws Exception
     */
    @Override
    public List<OrgAuthGrpVO> listOrgAuthGrpLangByMenuType(OrgAuthGrpVO vo) throws Exception {
        return orgAuthGrpLangDAO.listOrgAuthGrpLangByMenuType(vo);
    }

    /**
     *  기관 메뉴의 간략 정보를 조회한다.
     * @param OrgMenuVO
     * @return OrgMenuVO
     * @throws Exception
     */
    @Override
    public OrgMenuVO getMenuSimpleInfo(OrgMenuVO vo) throws Exception {
        return orgMenuDAO.selectMenuSimpleInfo(vo);
    }
    
    /**
     * 사용자의 개설과목 MENU_TYPE 및 권한 정보
     * @param orgId
     * @param crsCreCd
     * @param userId
     * @return
     * @throws Exception
     */
    @Override
    public OrgAuthGrpMenuVO getCrsCreAuth(String orgId, String crsCreCd, String userId) throws Exception  {
        return orgAuthGrpMenuDAO.selectCrsCreAuth(orgId, crsCreCd, userId);  
    }
}
