package knou.lms.system.config.service;

import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.system.config.vo.SysCfgCtgrVO;
import knou.lms.system.config.vo.SysCfgVO;

public interface SysCfgService {

	/**
	 *  설정 분류 전체 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgCtgrVO> listCtgr(SysCfgCtgrVO vo)	throws Exception;

	/**
	 * 설정 분류 페이징 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @param pageIndex
	 * @param listScale
	 * @param pageScale
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgCtgrVO> listCtgrPageing(
			SysCfgCtgrVO vo, int pageIndex, int listScale, int pageScale)
			throws Exception;

	/**
	 * 설정 분류 페이징 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @param pageIndex
	 * @param listScale
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgCtgrVO> listCtgrPageing(
			SysCfgCtgrVO vo, int pageIndex, int listScale) throws Exception;

	/**
	 * 설정 분류 페이징 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @param pageIndex
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgCtgrVO> listCtgrPageing(
			SysCfgCtgrVO vo, int pageIndex) throws Exception;

	/**
	 * 설정 분류 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @param pageIndex
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgVO> listConfig(SysCfgCtgrVO vo) throws Exception;

	/**
	 * 설정 분류 상세 정보를 조회한다.
	 * @param SysCfgCtgrVO
	 * @return SysCfgCtgrVO
	 * @throws Exception
	 */
	public abstract SysCfgCtgrVO viewCtgr(SysCfgCtgrVO vo) throws Exception;

	/**
	 * 설정 분류 정보를 등록한다.
	 * @param SysCfgCtgrVO
	 * @return String
	 * @throws Exception
	 */
	public abstract int addCtgr(SysCfgCtgrVO vo) throws Exception;

	/**
	 * 설정 분류 정보를 수정한다.
	 * @param SysCfgCtgrVO
	 * @return int
	 * @throws Exception
	 */
	public abstract int editCtgr(SysCfgCtgrVO vo) throws Exception;

	/**
	 * 설정 분류 정보를 삭제 한다.
	 * @param SysCfgCtgrVO
	 * @return int
	 * @throws Exception
	 */
	public abstract int removeCtgr(String cfgCtgrCd) throws Exception;

	/**
	 *  설정 정보 전체 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgVO> listCfg(SysCfgVO vo) throws Exception;

	/**
	 * 설정 정보 페이징 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @param pageIndex
	 * @param listScale
	 * @param pageScale
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgVO> listCfgPageing(SysCfgVO vo,
			int pageIndex, int listScale, int pageScale) throws Exception;

	/**
	 * 설정 정보 페이징 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @param pageIndex
	 * @param listScale
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgVO> listCfgPageing(SysCfgVO vo,
			int pageIndex, int listScale) throws Exception;

	/**
	 * 설정 정보 페이징 목록을 조회한다.
	 * @param SysCfgCtgrVO
	 * @param pageIndex
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public abstract ProcessResultListVO<SysCfgVO> listCfgPageing(SysCfgVO vo,
			int pageIndex) throws Exception;

	/**
	 * 설정 정보 상세 정보를 조회한다.
	 * @param SysCfgCtgrVO
	 * @return SysCfgCtgrVO
	 * @throws Exception
	 */
	public abstract SysCfgVO viewCfg(SysCfgVO vo) throws Exception;

	/**
	 * 설정 정보 상제 정보를 등록한다.
	 * @param SysCfgCtgrVO
	 * @return String
	 * @throws Exception
	 */
	public abstract int addCfg(SysCfgVO vo) throws Exception;

	/**
	 * 설정 정보 상세 정보를 수정한다.
	 * @param SysCfgCtgrVO
	 * @return int
	 * @throws Exception
	 */
	public abstract void editCfg(SysCfgVO vo) throws Exception;

	/**
	 * 설정 정보 상세 정보를 삭제 한다.
	 * @param SysCfgCtgrVO
	 * @return int
	 * @throws Exception
	 */
	public abstract int removeCfg(SysCfgVO vo) throws Exception;

 	/**
 	 * 설정 정보 상세 정보를 조회한다.
 	 * @param cfgCtgrCd
 	 * @param cfgCd
 	 * @return SysCfgCtgrVO
 	 * @throws Exception
 	 */
	public abstract String getValue(String cfgCtgrCd, String cfgCd) throws Exception;
	
	/*****************************************************
     * 시스템 설정 관리 정보를 설정 관리로 insert 한다.
     * @param SysCfgCtgrVO
     * @return int
     * @throws Exception
     ******************************************************/
	public abstract int addOrgSysCfgCtgr(SysCfgCtgrVO vo) throws Exception;
}