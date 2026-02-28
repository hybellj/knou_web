package knou.lms.common.service;

import java.util.List;

import knou.lms.common.vo.OrgAuthGrpMenuVO;
import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.common.vo.ProcessResultListVO;

public interface OrgMenuService {

    /**
     *  권한의 전체 목록을 조회한다.
     * @param OrgAuthGrpVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public ProcessResultListVO<OrgAuthGrpVO> listAuthGrp(OrgAuthGrpVO vo) throws Exception;

    /**
     * 권한의 상세 정보를 조회한다.
     * @param OrgAuthGrpVO
     * @return OrgAuthGrpVO
     * @throws Exception
     */
    public OrgAuthGrpVO viewAuthGrp(OrgAuthGrpVO vo) throws Exception;

    /**
     * 권한의 상세 정보를 등록한다.
     * @param OrgAuthGrpVO
     * @return String
     * @throws Exception
     */
    public String addAuthGrp(OrgAuthGrpVO vo) throws Exception;

    /**
     * 권한의 상세 정보를 수정한다.
     * @param OrgAuthGrpVO
     * @return int
     * @throws Exception
     */
    public int editAuthGrp(OrgAuthGrpVO vo) throws Exception;

    /**
     * 권한의 상세 정보를 삭제 한다.
     * @param OrgAuthGrpVO
     * @return int
     * @throws Exception
     */
    public int removeAuthGrp(OrgAuthGrpVO vo) throws Exception;

	/**
	 *  메뉴의 전체 목록을 트리 형태로 조회한다.
	 * @param OrgMenuVO
	 * @return ProcessResultVO
	 * @throws Exception
	 */
    public ProcessResultListVO<OrgMenuVO> listTreeMenu(OrgMenuVO vo) throws Exception;

	/**
	 * 기관의 권한 메뉴 조회
	 * 하위 메뉴를 포함한 최상위 메뉴 DTO를 반환함.
	 * @param dto.orgId : 기관 코드 (필수)
	 * @param dto.menuType : 메뉴 유형 (필수)
	 * @return ProcessResultListDTO
	 */
	public OrgMenuVO listAuthGrpTreeMenu(OrgMenuVO vo) throws Exception;

	/**
	 * 주어진 MenuDTO에서 menuCd에 해당되는 메뉴를 찾아서 반환한다.
	 * @param rootMenu 찾고자 하는 대상 루트메뉴
	 * @param menuCd 찾을 MenuCd
	 * @return 찾아진 MenuDTO, 없을 경우 null 반환.
	 */
	public OrgMenuVO findMenuByMenuCd(OrgMenuVO rootMenu, String menuCd);
	/**
	 * 주어진 MenuDTO에서 부모 menuCd에 해당되는 메뉴를 찾아서 반환한다.
	 * @param rootMenu 찾고자 하는 대상 루트메뉴
	 * @param menuCd 찾을 MenuCd
	 * @return 찾아진 MenuDTO, 없을 경우 null 반환.
	 */
	public OrgMenuVO findParMenuByMenuCd(OrgMenuVO rootMenu, String parMenuCd);

	/**
	 * 기관 메뉴의 단일 레코드를 반환한다.
	 * @param dto.orgId : 기관 코드 (필수)
	 * @param dto.menuType : 메뉴 유형 (필수)
	 * @param dto.menuCd : 메뉴 코드 (필수)
	 * @return ProcessResultListDTO
	 */
	public OrgMenuVO viewMenu(OrgMenuVO vo) throws Exception;

	/**
	 * 기관의 메뉴를 등록한다.
	 * @param OrgMenuVO
	 * @return String
	 * @throws Exception
	 */
	public String addMenu(OrgMenuVO vo) throws Exception;

	/**
	 * 기관의 메뉴를 수정한다.
	 * @param OrgMenuVO
	 * @return int
	 * @throws Exception
	 */
	public int editMenu(OrgMenuVO vo) throws Exception;

	/**
	 * 기관의 메뉴를 삭제한다.
	 * @param OrgMenuVO
	 * @return int
	 * @throws Exception
	 */
	public int removeMenu(OrgMenuVO vo) throws Exception;

	/**
	 * 기관의 메뉴의 순서를 변경한다.
	 * @param OrgMenuVO
	 * @return int
	 * @throws Exception
	 */
	public int moveMenu(OrgMenuVO vo, String moveType) throws Exception;
	
	/**
	 * 기관의 메뉴의 순서를 변경한다.
	 * @param OrgMenuVO
	 * @return int
	 * @throws Exception
	 */
	public int sortMenu(OrgMenuVO vo) throws Exception;

	/**
	 * 기관의 메뉴를 초기화 한다.
	 * @param OrgMenuVO
	 * @return int
	 * @throws Exception
	 */
	public String initMenu(OrgMenuVO vo) throws Exception;

	/**
	 * 기관의 권한 메뉴를 등록 한다.
	 * @param OrgAuthGrpMenuVO
	 * @return int
	 * @throws Exception
	 */
	public int addAuthGrpMenu(OrgAuthGrpMenuVO vo) throws Exception;

	/**
	 * 기관 메뉴의 권한 정보 조회
	 * @param OrgAuthGrpMenuVO
	 * @return int
	 * @throws Exception
	 */
	public OrgMenuVO viewAuthorizeByMenu(OrgMenuVO vo)	throws Exception;

    /**
     *  기관 권한 언어의 메뉴별 목록을 조회한다.
     * @param OrgAuthGrpLangVO
     * @return List
     * @throws Exception
     */
    public List<OrgAuthGrpVO> listOrgAuthGrpLangByMenuType(OrgAuthGrpVO vo) throws Exception;
    
    /**
     * 기관 메뉴의 간략 정보 조회
     * @param OrgMenuVO
     * @return OrgMenuVO
     * @throws Exception
     */
    public OrgMenuVO getMenuSimpleInfo(OrgMenuVO vo) throws Exception;
    
    /**
     * 사용자의 개설과목 MENU_TYPE 및 권한 정보
     * @param orgId
     * @param crsCreCd
     * @param userId
     * @return
     * @throws Exception
     */
    public OrgAuthGrpMenuVO getCrsCreAuth(String orgId, String crsCreCd, String userId) throws Exception;
    
}