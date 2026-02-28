package knou.lms.common.service;

import knou.lms.common.vo.OrgCfgCtgrVO;
import knou.lms.common.vo.OrgCfgVO;
import knou.lms.common.vo.ProcessResultVO;

public interface OrgCfgService {

    /**
     *  설정 분류 전체 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgCtgrVO> listCtgr(OrgCfgCtgrVO vo)
            throws Exception;

    /**
     * 설정 분류 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgCtgrVO> listCtgrPageing(
            OrgCfgCtgrVO vo, int pageIndex, int listScale, int pageScale)
            throws Exception;

    /**
     * 설정 분류 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgCtgrVO> listCtgrPageing(
            OrgCfgCtgrVO vo, int pageIndex, int listScale) throws Exception;

    /**
     * 설정 분류 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgCtgrVO> listCtgrPageing(
            OrgCfgCtgrVO vo, int pageIndex) throws Exception;

    /**
     * 설정 분류 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgVO> listConfig(OrgCfgCtgrVO vo) throws Exception;

    /**
     * 설정 분류 상세 정보를 조회한다.
     * @param OrgCfgCtgrVO
     * @return OrgCfgCtgrVO
     * @throws Exception
     */
    public abstract OrgCfgCtgrVO viewCtgr(OrgCfgCtgrVO vo) throws Exception;

    /**
     * 설정 분류 정보를 등록한다.
     * @param OrgCfgCtgrVO
     * @return String
     * @throws Exception
     */
    public abstract void addCtgr(OrgCfgCtgrVO vo) throws Exception;

    /**
     * 설정 분류 정보를 수정한다.
     * @param OrgCfgCtgrVO
     * @return int
     * @throws Exception
     */
    public abstract void editCtgr(OrgCfgCtgrVO vo) throws Exception;

    /**
     * 설정 분류 정보를 삭제 한다.
     * @param OrgCfgCtgrVO
     * @return void
     * @throws Exception
     */
    public abstract void removeCtgr(OrgCfgCtgrVO vo) throws Exception;

    /**
     *  설정 정보 전체 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgVO> listCfg(OrgCfgVO vo)
            throws Exception;

    /**
     * 설정 정보 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgVO> listCfgPageing(OrgCfgVO vo,
            int pageIndex, int listScale, int pageScale) throws Exception;

    /**
     * 설정 정보 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @param listScale
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgVO> listCfgPageing(OrgCfgVO vo,
            int pageIndex, int listScale) throws Exception;

    /**
     * 설정 정보 페이징 목록을 조회한다.
     * @param OrgCfgCtgrVO
     * @param pageIndex
     * @return ProcessResultVO
     * @throws Exception
     */
    public abstract ProcessResultVO<OrgCfgVO> listCfgPageing(OrgCfgVO vo,
            int pageIndex) throws Exception;

    /**
     * 설정 정보 상세 정보를 조회한다.
     * @param OrgCfgCtgrVO
     * @return OrgCfgCtgrVO
     * @throws Exception
     */
    public abstract OrgCfgVO viewCfg(OrgCfgVO vo) throws Exception;

    /**
     * 설정 정보 상제 정보를 등록한다.
     * @param OrgCfgCtgrVO
     * @return String
     * @throws Exception
     */
    public abstract void addCfg(OrgCfgVO vo) throws Exception;

    /**
     * 설정 정보 상세 정보를 수정한다.
     * @param OrgCfgCtgrVO
     * @return int
     * @throws Exception
     */
    public abstract void editCfg(OrgCfgVO vo) throws Exception;

    /**
     * 설정 정보 상세 정보를 삭제 한다.
     * @param OrgCfgCtgrVO
     * @return int
     * @throws Exception
     */
    public abstract void removeCfg(OrgCfgVO vo) throws Exception;

    /**
     * 설정 정보 상세 정보를 조회한다.
     * @param cfgCtgrCd
     * @param cfgCd
     * @return OrgCfgCtgrVO
     * @throws Exception
     */
    public abstract String getValue(OrgCfgVO vo) throws Exception;
    
    /**
     * 코드 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception
     */
    public abstract int countCode(OrgCfgVO vo) throws Exception;
    
    /**
     * 코드 카테고리 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception
     */
    public abstract int countCodeCtgr(OrgCfgCtgrVO vo) throws Exception;
    
}