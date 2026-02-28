package knou.lms.menu.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.OrgMenuVO;
import knou.lms.menu.vo.SysMenuVO;

public interface SysMenuMemService {

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	public abstract List<SysMenuVO> getAdmMenuList(String authGrpCd)
			throws Exception;

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	public abstract List<SysMenuVO> getMngMenuList(String authGrpCd)
			throws Exception;

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	public abstract List<SysMenuVO> getHomeMenuList(String authGrpCd)
			throws Exception;

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	public abstract OrgMenuVO getOrgHomeMenuList(String orgId, String authGrpCd)
			throws Exception;
	/**
	 * 메뉴타입별 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	public abstract OrgMenuVO getOrgMenuList(String orgId, String menuType, String authGrpCd)
			throws Exception;

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	public abstract List<SysMenuVO> getLecMenuList(String authGrpCd)
			throws Exception;

	/**
	 * 메뉴코드, 사용자 유형 정보를 이용해서 최종적으로 표시할 메뉴정보를 결정하고,
	 * 이 정보를 세션에 기록한다.
	 * @param mcd 요청메뉴코드
	 * @param userType 사용자 유형
	 * @param request 메뉴정보를 기록할 세션을 담은 request
	 * @return
	 */
	public abstract OrgMenuVO decideHomeMenuWithSession(String mcd,
			HttpServletRequest request) throws Exception;
	/**
	 * 메뉴코드, 사용자 유형 정보를 이용해서 최종적으로 표시할 메뉴정보를 결정하고,
	 * 이 정보를 세션에 기록한다.
	 * @param mcd 요청메뉴코드
	 * @param userType 사용자 유형
	 * @param request 메뉴정보를 기록할 세션을 담은 request
	 * @return
	 */
	public abstract OrgMenuVO decideMenuWithSession(String mcd,
			HttpServletRequest request) throws Exception;
	/**
	 * 세션에 등록된 메뉴 정보를 삭제 한다.
	 * @param request 메뉴정보를 기록할 세션을 담은 request
	 * @return
	 */
	public abstract void clearMenuSession(HttpServletRequest request) 
			throws Exception;

}