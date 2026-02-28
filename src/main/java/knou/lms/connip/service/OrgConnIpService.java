package knou.lms.connip.service;

import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.connip.vo.OrgConnIpVO;

public interface OrgConnIpService {

	/**
	 * 접속 IP 전체 목록을 조회한다.
	 * @param OrgConnIpVO
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public ProcessResultListVO<OrgConnIpVO> list(OrgConnIpVO vo) throws Exception;

	/**
	 * 접속 IP 페이징 목록을 조회한다.
	 * @param OrgConnIpVO
	 * @param pageIndex
	 * @param listScale
	 * @param pageScale
	 * @return ProcessResultListVO
	 * @throws Exception
	 */
	public ProcessResultListVO<OrgConnIpVO> listPageing(OrgConnIpVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
	public ProcessResultListVO<OrgConnIpVO> listPageing(OrgConnIpVO vo, int pageIndex, int listScale) throws Exception;
	public ProcessResultListVO<OrgConnIpVO> listPageing(OrgConnIpVO vo, int pageIndex) throws Exception;

	/**
	 * 접속 IP 상세 정보를 조회한다.
	 * @param OrgConnIpVO
	 * @return OrgConnIpVO
	 * @throws Exception
	 */
	public OrgConnIpVO view(OrgConnIpVO vo) throws Exception;

	/**
	 * 접속 IP 정보를 등록한다.
	 * @param OrgConnIpVO
	 * @return String
	 * @throws Exception
	 */
	public void add(OrgConnIpVO vo) throws Exception;

	/**
	 * 접속 IP 정보를 삭제 한다.
	 * @param OrgConnIpVO
	 * @return int
	 * @throws Exception
	 */
	public void remove(OrgConnIpVO vo) throws Exception;
    /**
	 *  접속IP 권한 체크  
	 * @param OrgConnIpVO
	 * @return boolean
	 * @throws Exception
	 */
	public boolean orgConnIpAuth(OrgConnIpVO vo) throws Exception ;

}