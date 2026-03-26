package knou.lms.menu.service.impl;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Service;

import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.menu.dao.SysAuthGrpDAO;
import knou.lms.menu.dao.SysAuthGrpLangDAO;
import knou.lms.menu.dao.SysMenuDAO;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.MenuUseOrgVO;
import knou.lms.menu.vo.MenuVO;
import knou.lms.menu.vo.MgrSysMenuVO;
import knou.lms.menu.vo.SysAuthGrpLangVO;
import knou.lms.menu.vo.SysAuthGrpMenuVO;
import knou.lms.menu.vo.SysAuthGrpVO;
import knou.lms.menu.vo.SysMenuVO;

/**
 *  시스템 권한 메뉴 관리 Service
 */
@Service("sysMenuService")
public class SysMenuServiceImpl
	extends EgovAbstractServiceImpl implements SysMenuService {

	/**
	 * 메뉴값을 저장하는 내부 변수 [캐쉬 저장소]
	 * key : menuType + "_" + authGrp
	 * value : 해당되는 rootMenuDTO
	 */
	private final Hashtable<String, SysMenuVO> menuCache = new Hashtable<String, SysMenuVO>();

    @Resource(name="sysAuthGrpDAO")
    private SysAuthGrpDAO sysAuthGrpDAO;

    @Resource(name="sysAuthGrpLangDAO")
    private SysAuthGrpLangDAO sysAuthGrpLangDAO;

    @Resource(name="sysMenuDAO")
    private SysMenuDAO sysMenuDAO;

    /**
     *  권한/메뉴관리의 권한목록을 조회한다.
     * @param SysAuthGrpVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<SysAuthGrpVO> selectListAuthGrp(SysAuthGrpVO vo) throws Exception {
        ProcessResultVO<SysAuthGrpVO> resultList = new ProcessResultVO<SysAuthGrpVO>();
        List<SysAuthGrpVO> result =  sysAuthGrpDAO.selectListAuthGrp(vo);

        resultList.setResult(1);
        resultList.setReturnList(result);
        return resultList;
    }

    /**
     *  권한에 대한 메뉴 리스트를 조회한다.
     * @param SysMenuVO
     * @return List<MgrSysMenuVO>
     * @throws Exception
     */
    @Override
    public List<MgrSysMenuVO> selectSysMenulist(SysMenuVO vo) throws Exception {
        List<MgrSysMenuVO> result =  sysMenuDAO.selectSysMenulist(vo);
        return result;
    }

    /**
     *  관리자 메뉴 사용 유무 저장
     * @param SysMenuVO
     * @return int
     * @throws Exception
     */
    @Override
    public void updateSysMenuListUseYn(SysMenuVO vo) throws Exception {
        for(SysMenuVO sysMenuVO : vo.getSubList()) {
            sysMenuVO.setOrgId(vo.getOrgId());
            sysMenuVO.setMdfrId(vo.getMdfrId());
            sysMenuVO.setAuthrtGrpcd(vo.getAuthrtGrpcd());
            sysMenuDAO.updateSysMenuListUseYn(sysMenuVO);
        }
    }


    /**
 	 *  권한의 전체 목록을 조회한다.
 	 * @param SysAuthGrpVO
 	 * @return ProcessResultVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultVO<SysAuthGrpVO> listAuthGrp(SysAuthGrpVO vo) throws Exception {
 		ProcessResultVO<SysAuthGrpVO> resultList = new ProcessResultVO<SysAuthGrpVO>();
 		List<SysAuthGrpVO> result =  sysAuthGrpDAO.list(vo);

 		List<SysAuthGrpVO> authGrpList = new ArrayList<SysAuthGrpVO>();
		for(SysAuthGrpVO sagvo : result) {
			SysAuthGrpLangVO saglvo = new SysAuthGrpLangVO();
			saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
			saglvo.setAuthrtGrpcd(sagvo.getAuthrtGrpcd());
			List<SysAuthGrpLangVO> authGrpLangList = sysAuthGrpLangDAO.list(saglvo);
			sagvo.setAuthGrpLangList(authGrpLangList);
			authGrpList.add(sagvo);
		}
 		resultList.setResult(1);
 		resultList.setReturnList(authGrpList);
 		return resultList;
 	}

 	/**
 	 * 권한의 상세 정보를 조회한다.
 	 * @param SysAuthGrpVO
 	 * @return SysAuthGrpVO
 	 * @throws Exception
 	 */
 	@Override
	public SysAuthGrpVO viewAuthGrp(SysAuthGrpVO vo) throws Exception {
 		vo = sysAuthGrpDAO.select(vo);
 		SysAuthGrpLangVO saglvo = new SysAuthGrpLangVO();
		saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		List<SysAuthGrpLangVO> authGrpLangList = sysAuthGrpLangDAO.list(saglvo);
		vo.setAuthGrpLangList(authGrpLangList);
 		return vo;
 	}

 	/**
 	 * 권한의 상세 정보를 등록한다.
 	 * @param SysAuthGrpVO
 	 * @return String
 	 * @throws Exception
 	 */
 	@Override
	public String addAuthGrp(SysAuthGrpVO vo) throws Exception {
 		sysAuthGrpDAO.insert(vo);
 		String result = "1";
 		List<SysAuthGrpLangVO> authGrpLangList = vo.getAuthGrpLangList();
		for(SysAuthGrpLangVO saglvo : authGrpLangList) {
			saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
			sysAuthGrpLangDAO.merge(saglvo);
		}
		return result;
 	}

 	/**
 	 * 권한의 상세 정보를 수정한다.
 	 * @param SysAuthGrpVO
 	 * @return int
 	 * @throws Exception
 	 */
 	@Override
	public int editAuthGrp(SysAuthGrpVO vo) throws Exception {
 		int result = sysAuthGrpDAO.update(vo);
		List<SysAuthGrpLangVO> authGrpLangList = vo.getAuthGrpLangList();
		for(SysAuthGrpLangVO saglvo : authGrpLangList) {
			saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
			sysAuthGrpLangDAO.merge(saglvo);
		}
		return result;
 	}

 	/**
 	 * 권한의 상세 정보를 삭제 한다.
 	 * @param SysAuthGrpVO
 	 * @return int
 	 * @throws Exception
 	 */
 	@Override
	public int removeAuthGrp(SysAuthGrpVO vo) throws Exception {
 		SysAuthGrpLangVO saglvo = new SysAuthGrpLangVO();
 		saglvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
 		sysAuthGrpLangDAO.deleteAll(saglvo);
 		return sysAuthGrpDAO.delete(vo);
 	}

    /**
 	 *  메뉴의 전체 목록을 트리 형태로 조회한다.
 	 * @param SysMenuVO
 	 * @return ProcessResultVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultVO<SysMenuVO> listTreeMenu(SysMenuVO vo) throws Exception {
 		ProcessResultVO<SysMenuVO> resultList = new ProcessResultVO<SysMenuVO>();
 		List<SysMenuVO> result =  this.listMenuByDB(vo);

		//최상단용 VO 만들기
 		SysMenuVO smvo = new SysMenuVO();

		//-- 트리형태로 목록을 구성하여 내보낸다.
		for (SysMenuVO parent : result) {
			if(StringUtil.isNull(parent.getUpMenuId())) {
				smvo.addSubMenu(parent);
			}
			for (SysMenuVO child : result) {
				if(parent.getMenuId().equals(child.getUpMenuId())) {
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
 	 * @param SysMenuVO
 	 * @return ProcessResultVO
 	 * @throws Exception
 	 */
 	@Override
	public List<SysMenuVO> listMenuByDB(SysMenuVO vo) throws Exception {
 		List<SysMenuVO> result =  sysMenuDAO.list(vo);
 		List<SysMenuVO> menuList = new ArrayList<SysMenuVO>();

 		return menuList;
 	}

 	/**
 	 * 메뉴의 상세 정보를 조회 한다.
 	 * @param SysMenuVO
 	 * @return SysMenuVO
 	 * @throws Exception
 	 */
 	@Override
	public SysMenuVO viewMenu(SysMenuVO vo) throws Exception {
 		vo = sysMenuDAO.select(vo);
 		if(ValidationUtils.isEmpty(vo)) {
			vo = new SysMenuVO();
			throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
		}

 		return vo;
 	}

 	/**
 	 * 권한별 메뉴의 상세 정보를 조회 한다.
 	 * @param SysMenuVO
 	 * @return SysMenuVO
 	 * @throws Exception
 	 */
 	@Override
	public SysMenuVO viewMenuByAuth(SysMenuVO vo) throws Exception {
 		vo = sysMenuDAO.selectByAuth(vo);

 		return vo;
 	}

 	/**
 	 * 메뉴의 상세 정보를 등록한다.
 	 * @param SysMenuVO
 	 * @return String
 	 * @throws Exception
 	 */
 	@Override
	public String addMenu(SysMenuVO vo) throws Exception {
		// 상위 메뉴 정보 조회
		SysMenuVO parent = new SysMenuVO();
		parent.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		parent.setMenuId(vo.getUpMenuId());
		try {
			parent = sysMenuDAO.select(parent);
		} catch (Exception e) {
			// 조회 결과가 없을 경우는 최상위 메뉴이므로 계속 속행한다.
			parent.setMenuLv(0);
		}

		String menuId = vo.getMenuId();
		if("Y".equals(vo.getAutoMakeYn())) {
			//---- 메뉴 코드 신규 생성
			menuId = sysMenuDAO.selectCd();
		}

		//---- 신규 메뉴코드 세팅
		vo.setMenuId(menuId);
		//---- 메뉴 레벨 : 상위 메뉴 레벨 + 1
		vo.setMenuLv(parent.getMenuLv()+1);
		//---- 메뉴 경로 : 상위 메뉴 경로 + 현제 메뉴 코드
		vo.setMenuPath(StringUtil.nvl(parent.getMenuPath(),"")+"|"+menuId);

		sysMenuDAO.insert(vo);
 		String result ="1";

		this.setMenuChanged();	// DB의 변경 여부를 기록
		return result;
 	}

 	/**
 	 * 메뉴의 상세 정보를 수정한다.
 	 * @param SysMenuVO
 	 * @return String
 	 * @throws Exception
 	 */
 	@Override
	public int editMenu(SysMenuVO vo) throws Exception {
 		try {
 			//-- 상위 메뉴 검색
 			SysMenuVO pvo = new SysMenuVO();
 			pvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
 			pvo.setMenuId(vo.getUpMenuId());
 			pvo = sysMenuDAO.select(pvo);
 			vo.setMenuPath(pvo.getMenuPath()+"|"+vo.getMenuId());
 		} catch (Exception e) {
 			vo.setMenuPath("|"+vo.getMenuId());
 		}
 		int result = sysMenuDAO.update(vo);

		this.setMenuChanged();	// DB의 변경 여부를 기록
		return result;
 	}

 	/**
 	 * 메뉴의 순서를 변경한다.
 	 * @param SysMenuVO
 	 * @return String
 	 * @throws Exception
 	 */
 	@Override
	public int sortMenu(SysMenuVO vo) throws Exception {

		String[] menuList = StringUtil.split(vo.getMenuId(),"|");

		// 하위 코드 목록을 한꺼번에 조회
		SysMenuVO smvo = new SysMenuVO();
		smvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
		List<SysMenuVO> menuArray = sysMenuDAO.list(smvo);

		// 이중 포문으로 menuArray에 변경된 order를 다시 저장
		// 만약 파라매터로 코드키가 누락되는 경우가 있다면... 로직 수정 필요.
		for (SysMenuVO ismvo : menuArray) {
			for (int order = 0; order < menuList.length; order++) {
				if(ismvo.getMenuId().equals(menuList[order])) {
					ismvo.setMenuOdr(order+1);	// 1부터 차례로 순서값을 지정
					sysMenuDAO.update(ismvo);
				}
			}
		}
		// DB의 변경 여부를 기록
		this.setMenuChanged();
		return 1;
 	}

 	/**
 	 * 메뉴의 상세 정보를 삭제한다.
 	 * @param SysMenuVO
 	 * @return String
 	 * @throws Exception
 	 */
 	@Override
	public int removeMenu(SysMenuVO vo) throws Exception {
 		// 권한 그룹 메뉴 삭제
 		SysAuthGrpMenuVO sagmvo = new SysAuthGrpMenuVO();
 		sagmvo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
 		sagmvo.setMenuCd(vo.getMenuId());
 		sysMenuDAO.deleteAuthGrpMenuByMenuCd(sagmvo);

		// 메뉴 삭제
 		int result = sysMenuDAO.delete(vo);
		this.setMenuChanged();	// DB의 변경 여부를 기록
		return result;
 	}

 	/**
 	 * 권한 그룹의 메뉴 사용 권한을 저장한다.
 	 * @param SysAuthGrpMenuVO
 	 * @return String
 	 * @throws Exception
 	 */
 	@Override
	public int addAuthGroupMenu(SysAuthGrpMenuVO vo) throws Exception {
 		// 권한 그룹에 연결되어 있는 권한 메뉴를 삭제한다.
 		sysMenuDAO.deleteAuthGrpMenuByAuthGrp(vo);
		String[] viewList = StringUtil.split(vo.getViewAuthArray(),"|");
		String[] creList = StringUtil.split(vo.getCreAuthArray(),"|");

		List<SysAuthGrpMenuVO> authGrpMenuArray = new ArrayList<SysAuthGrpMenuVO>();

		for(int i=1;i<viewList.length;i++) {
			makeAuthGroupMenu(vo.getAuthrtGrpcd(), vo.getAuthGrpCd(), viewList[i], authGrpMenuArray, creList);
		}

		for(int i=0; i < authGrpMenuArray.size();i++) {
			SysAuthGrpMenuVO sagmvo = authGrpMenuArray.get(i);
			try {
				sysMenuDAO.insertAuthGrpMenu(sagmvo);
			} catch (Exception e) {
				sysMenuDAO.updateAuthGrpMenu(sagmvo);
			}
		}
		// DB의 변경 여부를 기록
		this.setMenuChanged();

 		int result = 1;
		return result;
 	}

	private void makeAuthGroupMenu(String menuType, String authGrpCd, String menuCd, List<SysAuthGrpMenuVO> menuList, String[] creList) throws Exception {
		SysMenuVO smvo = new SysMenuVO();
		smvo.setAuthrtGrpcd(menuType);
		smvo.setMenuId(menuCd);
		smvo = sysMenuDAO.select(smvo);

		if(!"".equals(StringUtil.nvl(smvo.getUpMenuId()))) {
			makeAuthGroupMenu(menuType, authGrpCd, smvo.getUpMenuId(), menuList, creList);
		}

		SysAuthGrpMenuVO sagmvo = new SysAuthGrpMenuVO();
		String creAuth = "N";
		for(int j=1;j<creList.length;j++){
			if(menuCd.equals(creList[j])) creAuth = "Y";
		}

		sagmvo.setAuthrtGrpcd(menuType);
		sagmvo.setAuthGrpCd(authGrpCd);
		sagmvo.setMenuCd(menuCd);
		sagmvo.setViewAuth("Y");
		sagmvo.setCreAuth(creAuth);
		sagmvo.setModAuth(creAuth);
		sagmvo.setDelAuth(creAuth);

		menuList.add(sagmvo);
	}

	/**
	 * 메뉴의 버젼값을 DB와 비교한다.
	 * @return true:변경됨, false:변경되지 않음
	 */
	private boolean isMenuChanged() throws Exception{
		int menuVersion = -1;
		return (menuVersion != StringUtil.nvl(sysMenuDAO.selectVersion(), 0)) ? true : false;
	}

	/**
	 * 메뉴가 변경되었음을 DB에 저장한다.
	 */
	private void setMenuChanged() throws Exception{
		sysMenuDAO.updateVersion();
	}

    /**
 	 * 권한별 메뉴를 목록으로 가져온다.
 	 * 회원의 메뉴 조회시 사용
 	 * @param SysMenuVO
 	 * @return ProcessResultVO
 	 * @throws Exception
 	 */
 	@Override
	public ProcessResultVO<SysMenuVO> listUserMenu(String menuType, String authGrpCd) throws Exception {
 		ProcessResultVO<SysMenuVO> resultList = new ProcessResultVO<SysMenuVO>();
 		SysMenuVO smvo = this.listAuthGrpMenuWithCache(menuType, authGrpCd,"");
		resultList.setReturnList(smvo.getSubList());
 		return resultList;
 	}

	/**
	 * 캐쉬에서 해당 메뉴를 검색해서 반환한다.
	 * DB에서 메뉴의 변경여부를 확인하고 변경되었을 경우 캐쉬를 비우는 역활도 이곳에서 한다.
	 * @param menuType		메뉴 유형 (HOME, ADMIN, LEC)
	 * @param authGrpCd		권한그룹코드
	 * @param menuCd
	 * @return
	 */
	private SysMenuVO listAuthGrpMenuWithCache(String menuType, String authGrpCd, String menuCd) throws Exception {

		String menuKey = menuType + "." + authGrpCd;
		SysMenuVO rootMenu = null;

		/*
		 * 메뉴를 Hashtable에서 조회해 오는 기능입니다.
		 * 캐시가 있을 경우 어떤 동작도 하지 않기 때문에 세션에 의한정보 노출에
		 * 해당하지 않습니다.
		 */
		// 변경이 감지되면 캐쉬를 비우고 메뉴 버젼값을 동기화한다.
		if(isMenuChanged()) {
			int menuVersion = -1;
			menuCache.clear();
			menuVersion = StringUtil.nvl(sysMenuDAO.selectVersion(), 0);
			//log.debug("메뉴 변경내용 감지.. 캐쉬를 초기화 합니다. menuVersion [" + this.menuVersion + "]");
		}

		// 메모리에 로드되어 있지 않으면 DB에서 로딩..
		if(!this.menuCache.containsKey(menuKey)) {
			this.menuCache.put(menuKey, this.listAuthGrpMenuWithPersistant(menuType, authGrpCd));
			//log.debug("캐쉬 적중 실패 DB에서 직접 메뉴를 조회합니다. menuKey,menuCd [" + menuKey + ", " + menuCd + "]");
		} else {
			//log.debug("캐쉬 적중 성공 메모리에서 메뉴를 불러옵니다. menuKey,menuCd [" + menuKey + ", " + menuCd + "]");
		}

		// 캐쉬에서 루트메뉴 읽기
		rootMenu = this.menuCache.get(menuKey);

		// 캐쉬에서 추출한 메뉴중 서브 매뉴를 탐색해서 반환
		return findMenuByMenuCd(rootMenu, menuCd);
	}

	/**
	 * 실제 DB에서 메뉴를 조회해서 트리형태로 구성한 뒤 메뉴를 반환.(루트메뉴로만 반환된다.
	 * @param menuType
	 * @param authGrpCd
	 */
	private SysMenuVO listAuthGrpMenuWithPersistant(String menuType, String authGrpCd) throws Exception {
		SysMenuVO rootMenu = new SysMenuVO();

		rootMenu.setMenuNm("ROOT");
		rootMenu.setMenuId(menuType + "." + authGrpCd + "." + "ROOT");

		SysMenuVO smvo = new SysMenuVO();
		smvo.setAuthrtGrpcd(menuType);
		smvo.setAuthrtGrpcd(authGrpCd);
		List<SysMenuVO> listMenu = sysMenuDAO.listByAuth(smvo);

		for (SysMenuVO parent : listMenu) {
			if(StringUtil.isNull(parent.getUpMenuId())) {
				rootMenu.addSubMenu(parent);
			}
			for (SysMenuVO child : listMenu) {
				if(parent.getMenuId().equals(child.getUpMenuId())) {
					parent.addSubMenu(child);
				}
			}
		}
		return rootMenu;
	}

	/**
	 * 주어진 MenuDTO에서 menuCd에 해당되는 메뉴를 찾아서 반환한다.
	 * @param rootMenu 찾고자 하는 대상 루트메뉴
	 * @param menuCd 찾을 MenuCd
	 * @return 찾아진 MenuDTO, 없을 경우 null 반환.
	 */
	private SysMenuVO findMenuByMenuCd(SysMenuVO rootMenu, String menuCd) {

		// rootMenu가 menuCd와 일치하거나,
		// 주어진 검색키(menuCd)가 없으면 바로 rootMenu를 반환. (기본값으로 rootMenu가 반환)
		if(StringUtil.isNull(menuCd) || rootMenu.getMenuId().equals(menuCd))
			return rootMenu;

		SysMenuVO result = null;

		// childMenu가 있을 경우
		if(rootMenu.getSubList().size() > 0) {
			for (SysMenuVO current : rootMenu.getSubList()) {
				// 탐색 및 자식메뉴들에 대한 재귀호출
				if(current.getMenuId().equals(menuCd)) {
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
	 * 메뉴 케시 목록에서 메뉴 DTO를 가져온다.
	 * @param menuType
	 * @param authGrpCd
	 * @param menuCd
	 * @return
	 */
	public SysMenuVO getMenuByCache(String menuType, String authGrpCd, String menuCd) throws Exception {
		return listAuthGrpMenuWithCache(menuType, authGrpCd, menuCd);
	}


	/**
     * 서비스 메뉴 정보 조회
     */
    public List<SysMenuVO> selectServiceMenuAll(SysMenuVO vo) throws Exception {
        return sysMenuDAO.selectServiceMenuAll(vo);
    }


    /*
    새버전 작업..........................
    */


    /**
     * 메인메뉴 전체 목록 조회
     */
    public List<MenuVO> selectMainMenuAll(MenuVO vo) throws Exception {
        return sysMenuDAO.selectMainMenuAll(vo);
    }

    /**
     * 메인메뉴 기관 사용 전체 목록 조회
     */
    public List<MenuUseOrgVO> selectMainMenuUseOrgAll(MenuUseOrgVO vo) throws Exception {
        return sysMenuDAO.selectMainMenuUseOrgAll(vo);
    }

    /**
     * 강의실 메뉴 목록 조회
     * @return List<MenuVO>
     * @throws Exception
     */
    public List<MenuVO> selectLectMenuList(MenuVO vo) throws Exception {
    	return sysMenuDAO.selectLectMenuList(vo);
    }
}
