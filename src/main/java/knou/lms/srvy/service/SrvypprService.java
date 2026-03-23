package knou.lms.srvy.service;

import java.util.List;

import knou.lms.srvy.vo.SrvypprVO;

public interface SrvypprService {

	/**
	* 설문지목록조회
	*
	* @param srvyId		설문아이디
	* @param searchType	조회유형
	* @return 설문지목록
	* @throws Exception
	*/
	public List<SrvypprVO> srvypprList(String srvyId, String searchType) throws Exception;

	/**
	* 설문지조회
	*
	* @param srvypprId	설문지아이디
	* @return 설문지정보
	* @throws Exception
	*/
	public SrvypprVO srvypprSelect(String srvypprId) throws Exception;

	/**
	 * 설문지등록
	 *
	 * @param SrvypprVO
	 * @throws Exception
	 */
	public void srvypprRegist(SrvypprVO vo) throws Exception;

	/**
	* 설문지참여수조회
	*
	* @param sbjctId	과목아이디
	* @param srvyId		설문아이디
	* @param srvypprId	설문지아이디
	* @return 설문지참여수
	* @throws Exception
	*/
	public int srvypprPtcpCntSelect(SrvypprVO vo) throws Exception;

	/**
	* 설문지삭제
	*
	* @param SrvypprVO
	* @throws Exception
	*/
	public void srvypprDelete(SrvypprVO vo) throws Exception;

	/**
     * 설문지순번수정
     *
     * @param srvyId 	설문아이디
     * @param srvySeqno 변경할 설문지순번
     * @param searchKey 설문지순번
     * @throws Exception
     */
	public void srvySeqnoModify(SrvypprVO vo) throws Exception;

}
