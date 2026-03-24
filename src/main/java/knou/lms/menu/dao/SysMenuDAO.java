package knou.lms.menu.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.menu.vo.MenuUseOrgVO;
import knou.lms.menu.vo.MenuVO;
import knou.lms.menu.vo.MgrSysMenuVO;
import knou.lms.menu.vo.SysAuthGrpMenuVO;
import knou.lms.menu.vo.SysMenuVO;

/**
 *  <b>시스템 - 시스템 메뉴 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("sysMenuDAO")
public interface SysMenuDAO{

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
    public int updateSysMenuListUseYn(SysMenuVO pVo) throws Exception;


    /**
	 * 시스템 메뉴의 전체 목록을 조회한다.
	 * @param  SysMenuVO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<SysMenuVO> list(SysMenuVO vo) throws Exception;

    /**
	 * 시스템 메뉴의 상세 정보를 조회한다.
	 * @param  SysMenuVO
	 * @return SysMenuVO
	 * @throws Exception
	 */
	public SysMenuVO select(SysMenuVO vo) throws Exception;

    /**
	 * 권한별 메뉴의 목록을 조회한다.
	 * @param  SysMenuVO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<SysMenuVO> listByAuth(SysMenuVO vo) throws Exception;

    /**
	 * 권한별 메뉴의 상세 정보를 조회한다.
	 * @param  SysMenuVO
	 * @return SysMenuVO
	 * @throws Exception
	 */
	public SysMenuVO selectByAuth(SysMenuVO vo) throws Exception;

    /**
	 * 시스템 메뉴의 코드를 생성한다.
	 * @param  SysMenuVO
	 * @return SysMenuVO
	 * @throws Exception
	 */
	public String selectCd() throws Exception;

    /**
     * 시스템 메뉴의 상세 정보를 등록한다.
     * @param  SysMenuVO
     * @return String
     * @throws Exception
     */
    public void insert(SysMenuVO vo) throws Exception;

    /**
     * 시스템 메뉴의 상세 정보를 수정한다.
     * @param  SysMenuVO
     * @return int
     * @throws Exception
     */
    public int update(SysMenuVO vo) throws Exception;

    /**
     * 시스템 메뉴의 상세 정보를 삭제한다.
     * @param  SysMenuVO
     * @return int
     * @throws Exception
     */
    public int delete(SysMenuVO vo) throws Exception;

    /**
     * 권한별 메뉴의 사용 권한을 등록한다.
     * @param  SysMenuVO
     * @return int
     * @throws Exception
     */
    public void insertAuthGrpMenu(SysAuthGrpMenuVO vo) throws Exception;

    /**
     * 권한별 메뉴의 사용 권한을 수정한다.
     * @param  SysMenuVO
     * @return int
     * @throws Exception
     */
    public int updateAuthGrpMenu(SysAuthGrpMenuVO vo) throws Exception;

    /**
     * 권한 그룹에 부여된 권한 메뉴를 삭제한다.
     * @param  SysAuthGrpMenuVO
     * @return int
     * @throws Exception
     */
    public int deleteAuthGrpMenuByAuthGrp(SysAuthGrpMenuVO vo) throws Exception;

    /**
     * 메뉴에 연결된 권한 메뉴를 삭제한다.
     * @param  SysAuthGrpMenuVO
     * @return int
     * @throws Exception
     */
    public int deleteAuthGrpMenuByMenuCd(SysAuthGrpMenuVO vo) throws Exception;

    /**
	 * 설정 테이블에 메뉴의 버전 값을 조회 한다.
	 * @return int
	 * @throws Exception
	 */
	public String selectVersion() throws Exception;

    /**
	 * 설정 테이블에 메뉴의 버전 값을 증가 시킨다.
	 * @return int
	 * @throws Exception
	 */
	public String updateVersion() throws Exception;

	/**
     * 서비스용 전체 메뉴 조회
     * @return List<SysMenuVO>
     * @throws Exception
     */
    public List<SysMenuVO> selectServiceMenuAll(SysMenuVO vo) throws Exception;


    /*
    새버전 작업..........................
    */

    /**
     * 메인메뉴 전체 목록 조회
     * @return List<MenuVO>
     * @throws Exception
     */
    public List<MenuVO> selectMainMenuAll(MenuVO vo) throws Exception;

    /**
     * 메인메뉴 기관 사용 전체 목록 조회
     * @return List<MenuUseOrgVO>
     * @throws Exception
     */
    public List<MenuUseOrgVO> selectMainMenuUseOrgAll(MenuUseOrgVO vo) throws Exception;
}
