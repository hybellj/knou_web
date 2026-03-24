package knou.lms.menu.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.menu.vo.MenuUseOrgVO;
import knou.lms.menu.vo.MenuVO;
import knou.lms.menu.vo.MgrSysMenuVO;
import knou.lms.menu.vo.SysAuthGrpMenuVO;
import knou.lms.menu.vo.SysAuthGrpVO;
import knou.lms.menu.vo.SysMenuVO;

/**
 *  <b>시스템 - 시스템 권한 메뉴 관리</b> 영역  Service 클래스
 * @author Jamfam
 *
 */
public interface SysMenuService {
    /**
     *  권한/메뉴관리의 권한목록을 조회한다.
     * @param SysAuthGrpVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public ProcessResultVO<SysAuthGrpVO> selectListAuthGrp(SysAuthGrpVO vo) throws Exception;

    /**
     *  권한에 대한 메뉴 리스트를 조회한다.
     * @param SysMenuVO
     * @return List<MgrSysMenuVO>
     * @throws Exception
     */
    public List<MgrSysMenuVO> selectSysMenulist(SysMenuVO vo) throws Exception;

    /**
     *  관리자 메뉴 사용 유무 저장
     * @param SysMenuVO
     * @return int
     * @throws Exception
     */
    public void updateSysMenuListUseYn(SysMenuVO vo) throws Exception;

	/**
	 *  권한의 전체 목록을 조회한다.
	 * @param SysAuthGrpVO
	 * @return ProcessResultVO
	 * @throws Exception
	 */
	public abstract ProcessResultVO<SysAuthGrpVO> listAuthGrp(
			SysAuthGrpVO vo) throws Exception;

	/**
	 * 권한의 상세 정보를 조회한다.
	 * @param SysAuthGrpVO
	 * @return SysAuthGrpVO
	 * @throws Exception
	 */
	public abstract SysAuthGrpVO viewAuthGrp(SysAuthGrpVO vo) throws Exception;

	/**
	 * 권한의 상세 정보를 등록한다.
	 * @param SysAuthGrpVO
	 * @return String
	 * @throws Exception
	 */
	public abstract String addAuthGrp(SysAuthGrpVO vo) throws Exception;

	/**
	 * 권한의 상세 정보를 수정한다.
	 * @param SysAuthGrpVO
	 * @return int
	 * @throws Exception
	 */
	public abstract int editAuthGrp(SysAuthGrpVO vo) throws Exception;

	/**
	 * 권한의 상세 정보를 삭제 한다.
	 * @param SysAuthGrpVO
	 * @return int
	 * @throws Exception
	 */
	public abstract int removeAuthGrp(SysAuthGrpVO vo) throws Exception;

	/**
	 *  메뉴의 전체 목록을 트리 형태로 조회한다.
	 * @param SysMenuVO
	 * @return ProcessResultVO
	 * @throws Exception
	 */
	public abstract ProcessResultVO<SysMenuVO> listTreeMenu(SysMenuVO vo)
			throws Exception;

	/**
	 *  메뉴의 전체 목록을 디비에서 조회한다.
	 * @param SysMenuVO
	 * @return List
	 * @throws Exception
	 */
	public abstract List<SysMenuVO> listMenuByDB(SysMenuVO vo) throws Exception;

	/**
	 * 메뉴의 상세 정보를 조회 한다.
	 * @param SysMenuVO
	 * @return SysMenuVO
	 * @throws Exception
	 */
	public abstract SysMenuVO viewMenu(SysMenuVO vo) throws Exception;

 	/**
 	 * 권한별 메뉴의 상세 정보를 조회 한다.
 	 * @param SysMenuVO
 	 * @return SysMenuVO
 	 * @throws Exception
 	 */
	public abstract SysMenuVO viewMenuByAuth(SysMenuVO vo) throws Exception;

	/**
	 * 메뉴의 상세 정보를 등록한다.
	 * @param SysMenuVO
	 * @return String
	 * @throws Exception
	 */
	public abstract String addMenu(SysMenuVO vo) throws Exception;

	/**
	 * 메뉴의 상세 정보를 수정한다.
	 * @param SysMenuVO
	 * @return String
	 * @throws Exception
	 */
	public abstract int editMenu(SysMenuVO vo) throws Exception;

	/**
	 * 메뉴의 순서를 변경한다.
	 * @param SysMenuVO
	 * @return String
	 * @throws Exception
	 */
	public abstract int sortMenu(SysMenuVO vo) throws Exception;

	/**
	 * 메뉴의 상세 정보를 삭제한다.
	 * @param SysMenuVO
	 * @return String
	 * @throws Exception
	 */
	public abstract int removeMenu(SysMenuVO vo) throws Exception;

	/**
	 * 권한 그룹의 메뉴 사용 권한을 저장한다.
	 * @param SysAuthGrpMenuVO
	 * @return String
	 * @throws Exception
	 */
	public abstract int addAuthGroupMenu(SysAuthGrpMenuVO vo) throws Exception;

	/**
	 * 권한별 메뉴를 목록으로 가져온다.
	 * 회원의 메뉴 조회시 사용
	 * @param SysMenuVO
	 * @return ProcessResultVO
	 * @throws Exception
	 */
	public abstract ProcessResultVO<SysMenuVO> listUserMenu(
			String menuType, String authGrpCd) throws Exception;

	/**
	 * 메뉴 케시 목록에서 메뉴 VO를 가져온다.
	 * @param menuType
	 * @param authGrpCd
	 * @param menuCd
	 * @return
	 */
	public abstract SysMenuVO getMenuByCache(String menuType,
			String authGrpCd, String menuCd) throws Exception;


	/**
     * 서비스 메뉴 정보 조회
     */
    public List<SysMenuVO> selectServiceMenuAll(SysMenuVO vo) throws Exception;


    /**
     * 메인메뉴 전체 목록 조회
     */
    public List<MenuVO> selectMainMenuAll(MenuVO vo) throws Exception;

    /**
     * 메인메뉴 기관 사용 전체 목록 조회
     */
    public List<MenuUseOrgVO> selectMainMenuUseOrgAll(MenuUseOrgVO vo) throws Exception;
}