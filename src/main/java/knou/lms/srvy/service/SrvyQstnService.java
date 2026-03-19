package knou.lms.srvy.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;

public interface SrvyQstnService {

	/**
	 * 설문문항목록조회
	 *
	 * @param srvyId	설문아이디
	 * @return 설문문항목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyQstnList(String srvyId) throws Exception;

	/**
	 * 설문지문항목록조회
	 *
	 * @param srvypprId		설문지아이디
	 * @return 설문지문항목록
	 * @throws Exception
	 */
	public List<SrvyQstnVO> srvypprQstnList(String srvypprId) throws Exception;

	/**
	 * 설문지문항삭제
	 *
	 * @param srvypprId		설문지아이디
	 * @throws Exception
	 */
	public void srvypprQstnDelete(String srvypprId) throws Exception;

	/**
	* 설문문항등록
	*
	* @param SrvyQstnVO
	* @throws Exception
	*/
	public SrvyQstnVO srvyQstnRegist(SrvyQstnVO vo) throws Exception;

	/**
	* 설문문항수정
	*
	* @param SrvyQstnVO
	* @throws Exception
	*/
	public void srvyQstnModify(SrvyQstnVO vo) throws Exception;

	/**
	* 설문문항삭제
	*
	* @param SrvyQstnVO
	* @throws Exception
	*/
	public void srvyQstnDelete(SrvyQstnVO vo) throws Exception;

	/**
	 * 설문문항조회
	 *
	 * @param srvypprId		설문지아이디
	 * @param srvyQstnId	설문문항아이디
	 * @return 설문문항
	 * @throws Exception
	 */
	public SrvyQstnVO srvyQstnSelect(SrvyQstnVO vo) throws Exception;

	/**
     * 문항순번수정
     *
     * @param srvypprId 	설문지아이디
     * @param qstnSeqno 	변경할 문항순번
     * @param searchKey 	문항순번
     * @throws Exception
     */
	public void qstnSeqnoModify(SrvyQstnVO vo) throws Exception;

	/**
     * 교수문항복사설문문항목록조회
     *
     * @param srvypprId 	설문지아이디
     * @return 설문문항목록
     * @throws Exception
     */
	public List<EgovMap> profQstnCopySrvyQstnList(SrvyQstnVO vo) throws Exception;

}
